@echo off
c:\windows\system32\mode 200,50
echo .
echo stopping docker containers
docker-compose stop
echo .
echo docker containers should be stopped
echo .
docker ps -a
echo .
echo press any key to close this window
pause