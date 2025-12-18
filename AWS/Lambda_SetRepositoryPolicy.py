import json
import boto3

def lambda_handler(event, context):
	client = boto3.client('ecr')
	
	registry_id = event['deatil']['responseElements']['repository']['registryId']
	repo_name = event['deatil']['responseElements']['repository']['repositoryName']
	
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
