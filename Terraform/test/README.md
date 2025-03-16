# Terraform 기반 AWS EKS 구축

## 실행 방법
### 1. Terraform 초기화 및 실행
```sh
terraform init
terraform apply -auto-approve
```

### 2. Kubernetes 클러스터 설정
```sh
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
kubectl apply -f kubernetes/
```

## 결과물
- AWS 환경에 VPC, EKS, ALB, Spring Boot 컨테이너 애플리케이션이 배포됩니다.
- ALB를 통해 외부에서 Spring Boot 서비스에 접근할 수 있습니다.

## 참고 사항
- EKS 클러스터와 ALB의 설정 값은 필요에 따라 변경할 수 있습니다.
- 배포된 리소스를 삭제하려면 아래 명령어를 실행하면 됩니다.
```sh
terraform destroy -auto-approve
```

