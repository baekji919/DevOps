#!/bin/bash

lbs=$(aws elbv2 describe-load-balancers \
  --query "[LoadBalancers[].LoandBalancerArn]" --output text)

for lb in $lbs; do
	name=$(aws elbv2 describe-load-balancers --load-balancer-arns $lb \
		--query "LoadBalancers[0].LoadBalancerName" --output text)
	protection=$(aws elbv2 describe-load-balancer-attributes --load-balancer-arns $lb \
		--query "Attributes[>Key=='deletion_protection.enabled'].Value" --output text)
		
	echo -e "$name\t$protection"
done
