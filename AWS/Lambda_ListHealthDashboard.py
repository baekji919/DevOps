import json
import boto3

def lambda_handler(event=None, context=None):
	#Health Dashboard는 글로벌
    client = boto3.client('health', region_name='us-east-1')
    
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
        print('event description : ', des)
        
        #영향받는 리소스
        resources = client.describe_affected_entities(filter={'eventArns' : [event_arn]}).get('entities,[])
        print('resource Arn : ', resoureces[0].get('entityArn', ''))

if __name__ == "__main__":
	lambda_handler()
