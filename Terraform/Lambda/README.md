## 동작 방법
1. index.js 파일 zip 파일으로 압축하기
```bash
$ zip index.zip index.js
```
2. terraform 구동

terraform init 명령어로 구동 준비
```bash
$ terraform init
```

terraform plan 명령어로 미리 만들어질 리소스들 확인하기
```bash
$ terraform plan
```

문제 없으면 terraform apply로 적용하기
```bash
$ terraform apply [--auto-approve]
```

만들어진 리소스 지우고 싶을 때는 해당 폴더 안에서 
```bash
$ terraform destroy [--auto-approve]
```