#!/bin/sh


# 필요치 않은 파일 삭제
sudo rm -rf /home/ubuntu/docker/static/.bash_history

# 권한 설정
sudo chmod -R 755 /home/ubuntu/docker/static

# WAR 준비
echo ' '
echo '-----------'
echo 'UNPACK WAR'
echo '-----------'
cp /home/ubuntu/current/ROOT.war /tmp/ROOT.war
sudo unzip -o /tmp/ROOT.war -d /home/ubuntu/docker/tomcat/webapps/ROOT

# DOCKER 중단
echo ' '
echo '-----------'
echo 'STOP DOCKER'
echo '-----------'
docker stop $(docker ps -q)

# WAR 복재
sudo chown -R www-data:www-data /home/ubuntu/docker/tomcat/webapps

# DOCKER 재시작
echo ' '
echo '-----------'
echo 'START DOCKER'
echo '-----------'
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d --build democracy-nginx democracy-tomcat

# 백업
TIMESTAMP=`date +"%G%m%e%H%M"`
cp /home/ubuntu/current/ROOT.war /home/ubuntu/released/ROOT.war.$TIMESTAMP

echo ' '
echo 'OK!'