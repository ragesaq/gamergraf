@echo off
c:\windows\system32\mode 200,50
echo .
echo .
echo checking docker container status
docker ps -a
echo .
echo press any key to close this window
pause