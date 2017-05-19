@echo off
c:\windows\system32\mode 200,50
echo .
echo building docker container, this will generate a lot of output
docker-compose build --force-rm --no-cache
echo .
echo .
echo .
echo bringing up docker container
docker-compose up -d
echo docker container should be up, checking status
echo .
echo .
docker ps -a
echo .
echo press any key to close this window
pause