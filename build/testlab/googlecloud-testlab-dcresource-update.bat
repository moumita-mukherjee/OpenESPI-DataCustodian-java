cd ..\..
C:\projects\tools\apache-maven-3.1.1\bin\mvn -P googlecloudtestlab-resource -Dmaven.test.skip=true clean install appengine:update
cd build\testlab
pause