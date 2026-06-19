@echo off
REM compile.bat – Compile and run MovieRater on Windows
REM Requirements: Java JDK 17+ on PATH and sqlite-jdbc.jar in lib\

set JAR=lib\sqlite-jdbc.jar
set OUT=out
set MAIN=movierater.Main

echo =^> Compiling...
if not exist %OUT% mkdir %OUT%
for /R src %%f in (*.java) do javac -cp %JAR% -d %OUT% "%%f"

echo =^> Starting MovieRater...
java -cp "%OUT%;%JAR%" %MAIN%
