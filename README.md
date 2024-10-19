- 솔루션
1. VPC 생성
2. 채점 서버 생성
3. EIP 연결
4. 접속해서 서버 세팅 및 AMI 생성
5. Launch Template 생성 
    - IAM 역할 할당해주기 (CloudWatchAgentServerPolicy)
    - UserData에서 로깅 세팅해주기
    - 보안그룹에서 인바운드에 ALB 보안그룹만 허용하기
6. Target Group & ALB Setting (보안그룹 설정)
7. ASG구성
8. CloudWatch Dashbaord 구성
