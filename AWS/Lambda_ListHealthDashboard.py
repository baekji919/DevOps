import json
import boto3
import io
import csv

def lambda_handler(event=None, context=None):
	#Health Dashboard는 글로벌, s3는 서울
	client = boto3.client('health', region_name='us-east-1')
	s3_client = boto3.client('s3', region_name='ap-northeast-2')

	#s3 설정
	S3_BUCKET = 'test-s3'
	S3_KEY = 'test-health.csv'

	#csv 작성
	output = io.StringIO()
	output.write('\uFEFF')  ##utf-8
	writer = csv.writer(output, quoting=csv.QUOTE_ALL)
	writer.writerow(['event_arn', 'description', 'affected_resources', 'start_time', 'end_time'])
	
	#예정된 변경 사항 가져오기
	response = client.describe_events(
		filter={
			'eventTypeCategories': ['ScheduledChange'],
			'eventSatusCodes': ['upcoming']
		},
		maxResults=10
	)
	
	events = response.get('events', [])
	if not events:
		print('No scheduled changes found')
		return
        
	print('Scheduled changes: ', len(events), '건')
	for event in events:
		event_arn = event['arn']
		print("\n=====================")
		print('event_arn : ', event_arn)
		
		#이벤트 상세 정보 가져오기
		res = client.describe_event_details(eventArns=[event_arn]).get('successfulSet',[])
		des = res[0].get('eventDescription', {}).get('latestDescription', '')
		start_time = res[0].get('event', {}).get('startTime', '')
		end_time = res[0].get('event', {}).get('endTime', '')
		
		#영향받는 리소스
		resources = client.describe_affected_entities(filter={'eventArns' : [event_arn]}).get('entities,[])
		resource_arn = resoureces[0].get('entityArn', '')

    		writer.writerow([event_arn, des, resource_arn, start_time, end_time])

      s3_client.put_object(Bucket=S3_BUCKET, Key=S3_KEY, Body=output.getvalue(), CotentType='text/csv')

if __name__ == "__main__":
	lambda_handler()
