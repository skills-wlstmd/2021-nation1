#!/bin/bash

# CloudWatch Logs 에이전트 설치
yum update -y
yum install -y awslogs

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token:$TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

cat << EOF > /etc/awslogs/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/app/app.log]
datetime_format = %Y-%m-%d %H:%M:%S
file = /var/log/app/app.log
buffer_duration = 5000
log_stream_name = api_${INSTANCE_ID}
initial_position = start_of_file
log_group_name = /aws/ec2/wsi
EOF

cat << EOF > /etc/awslogs/awscli.conf 
[plugins]
cwlogs = cwlogs
[default]
region = ap-northeast-2
EOF

# CloudWatch Logs 에이전트 시작 및 부팅 시 자동 시작 설정
# Amazon Linux2가 아닌 경우
# service awslogs start
# chkconfig awslogs on
# Amazon Linux 2
systemctl start awslogsd
systemctl enable awslogsd.service