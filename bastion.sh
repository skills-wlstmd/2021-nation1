yum update -y
yum install python3 python3-pip -y
pip3 install flask
mkdir /var/log/app
touch /var/log/app/app.log
chmod 777 /var/log/app/app.log

cat << EOF > /home/ec2-user/app.py
#!/usr/bin/python3
from flask import Flask, abort, request, jsonify
import logging

logging.basicConfig(
  format = '%(asctime)s %(levelname)s %(message)s',
  datefmt = '%Y-%m-%d %H:%M:%S',
  filename = "/var/log/app/app.log",
  level = logging.INFO
)

app = Flask(__name__)

@app.route('/v1/color', methods=['GET'])
def get_color():
  try:
    color_name = request.args['name']
    color_hash = request.args['hash']

    ret = {'code': '', 'name': ''}

    if color_name == 'red':
        ret['code'] = 'f34a07'
        ret['name'] = 'orange'
    elif color_name == 'blue':
        ret['code'] = '71f0f9'
        ret['name'] = 'sky'
    else:
        ret['code'] = 'ff00ff'
        ret['name'] = 'pink'

    return jsonify(ret), 200
  except Exception as e:
    logging.error(e)
    abort(500)

@app.route('/health', methods=['GET'])
def get_health():
  try:
    ret = {'status': 'ok'}

    return jsonify(ret), 200
  except Exception as e:
    logging.error(e)
    abort(500)

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=8080)
EOF

cat << EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My Flask App

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
ExecStart=/usr/bin/python3 /home/ec2-user/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start myapp.service
systemctl enable myapp.service
systemctl status myapp.service