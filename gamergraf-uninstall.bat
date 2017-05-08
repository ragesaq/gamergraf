@echo off
c:\windows\system32\mode 200,50
echo .
echo bringing down docker containers and deleting containers
docker-compose down
echo docker containers should be stopped and deleted, rebuild with gamergraf-start if desired
echo .
docker ps -a
echo .
echo press any key to close this window
pause