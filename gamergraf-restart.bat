@echo off
c:\windows\system32\mode 200,50
echo .
echo restarting docker container
docker-compose restart
echo container should be restarted
echo .
docker ps -a
echo .
echo press any key to close this window
pause
