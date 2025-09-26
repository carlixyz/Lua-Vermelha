@echo off

REM === CONFIG ===   run as .\build_webapp
 set EMSDK_PATH=C:\emsdk
 set BATCHPATH=%~dp0
 set BASEPATH=%BATCHPATH:~0,-1%
 set BUILD_DIR=build
 set TARGET=LuaVermelha
 
cd %BASEPATH%/%BUILD_DIR%

REM === Activate Emscripten ===
call "%EMSDK_PATH%\emsdk_env.bat"

REM === Build with Make ===
emmake make

REM === Launch in Browser (optional) ===
REM emrun --no_browser --port 8080 .
REM emrun --browser chrome --port 8080 .
REM emrun --port 8080 .
REM emrun --browser chrome --port 8080 .

cd ..

exit /b 0