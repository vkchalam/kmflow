#! /bin/bash -ex

adduser quizengine-user
mkdir -p /opt/kmflow/quizengine

cd /opt/kmflow/quizengine
aws s3 cp s3://kmflow-org-artifacts/${release_version}.tar.gz .
tar -xf ${release_version}.tar.gz --strip-components=1

cat > /etc/systemd/system/quizengine.service <<EOF
[Unit]
Description=Quiz Engine Service
After=network.target

[Service]
ExecStart=/opt/kmflow/quizengine/quizengine
Restart=always
User=quizengine-user
Environment=PATH=/usr/bin:/usr/local/bin
WorkingDirectory=/opt/kmflow/quizengine

[Install]
WantedBy=multi-user.target
EOF

chown -R quizengine-user:quizengine-user /opt/kmflow/quizengine

systemctl daemon-reload
systemctl enable quizengine
systemctl start quizengine