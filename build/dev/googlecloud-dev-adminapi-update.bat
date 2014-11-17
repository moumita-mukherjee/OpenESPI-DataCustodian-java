cd ..\..
set MVN_PROFILE=googleclouddev-adminapi
C:\projects\tools\apache-maven-3.1.1\bin\mvn -P %MVN_PROFILE% -Dmaven.test.skip=true clean install appengine:update
pause