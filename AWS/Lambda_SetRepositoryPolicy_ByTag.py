import json
import boto3

def lambda_handler(event, context):
	client = boto3.client('ecr')
  
	repo_info = event['deatil']['responseElements']['repository']
	registry_id = repo_info['registryId']
	repo_name = repo_info['repositoryName']
  repo_arn = repo_info['repositoryArn']

  tags = client.list_tags_for_resource(resourceArn=repo_arn).get('tags', [])

  if tags:
    for tag in tags:
      if tag['Key'] == 'env':
        env = tag['Value']

    if env == 'dev':
      policy = {
    		"Version" : "2008-10-17",
    		"Statement" : [
    			{
    				"Sid": "AllowCrossAccountPull",
    				"Effect": "Allow",
    				"Principal": "arn:aws:iam::xxxxxxxx:role/ec2-role",
    				"Action": [
    					"ecr:BatchCheckLayerAvailability",
    					"ecr:BatchGetImage",
    					"ecr:GetDownloadUrlForLayer"
    				]
    			}
    		]
    	}
    elif env == 'prod':
      policy = {
    		"Version" : "2008-10-17",
    		"Statement" : [
    			{
    				"Sid": "AllowCrossAccountPull",
    				"Effect": "Allow",
    				"Principal": "arn:aws:iam::xxxxxxxx:role/ec2-role",
    				"Action": [
    					"ecr:BatchCheckLayerAvailability",
    					"ecr:BatchGetImage",
    					"ecr:GetDownloadUrlForLayer"
    				]
    			}
    		]
      }
    response = client.set_repository_policy(
  		registryId=registry_id,
  		repositoryName=repo_name,
  		policyText=json.dunps(policy),
  		force=True
  	)
  	
  	print("response: " + response)
else:
  print("no tags")
