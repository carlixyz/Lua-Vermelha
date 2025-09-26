@echo off

REM === CONFIG ===   run as .\build_webapp
 set EMSDK_PATH=C:\emsdk
 set BATCHPATH=%~dp0
 set BASEPATH=%BATCHPATH:~0,-1%
 set BUILD_DIR=build
 
cd %BASEPATH%

REM === Activate Emscripten ===
call "%EMSDK_PATH%\emsdk_env.bat"

REM === Clean or create build folder ===
if not exist %BUILD_DIR% (
    mkdir %BUILD_DIR%
)
cd %BUILD_DIR%

REM === Configure with CMake ===
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release 
REM emcmake cmake .. -DPLATFORM=Web -Os -Wall -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-s USE_GLFW=3" --shell-file $HOME/raylib/src/minshell.html


exit /b 0
