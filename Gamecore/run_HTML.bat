@echo off

REM === CONFIG ===   run as .\build_webapp
 set BATCHPATH=%~dp0
 set BASEPATH=%BATCHPATH:~0,-1%
 set BUILD_DIR=build
 cd %BASEPATH%/%BUILD_DIR%

REM === Activate Emscripten ===
REM call "%EMSDK_PATH%\emsdk_env.bat"

REM === Launch in Browser (optional) ===
REM emrun --no_browser --port 8080 .
REM emrun --browser chrome --port 8080 .
REM start emrun --port 8080 .
start emrun --port 8080 LuaVermelha.html


exit /b 0