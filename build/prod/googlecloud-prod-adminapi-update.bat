@echo off
set /p input="Do you want to deploye (Y/N)? "
if /I NOT "%input%"=="Y" ( exit )

cd ..\..
set MVN_PROFILE=googlecloudprod-adminapi
C:\projects\tools\apache-maven-3.1.1\bin\mvn -P %MVN_PROFILE% -Dmaven.test.skip=true clean install appengine:update
pause