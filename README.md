# LUA VERMELHA
### An horror visual novel made with raylib + lua for web


## Summary
Made in my spare time

## Inputs:


### MVS Project required libraries:
1. Psytron\gameCore\Libraries\\**raylib** (lib used to handle window, sprites and sound FX, etc)
2. Psytron\gameCore\Libraries\\**lua** (required to load & read _**.YAML**_ config and dialog files)
- Both static libs are already built & included in the project folder ;)


#### Prerequisites:
1. Download as a .zip from https://github.com/emscripten-core/emsdk to c:\emsdk
2. open a command line there and execute ./emsdk install latest (wait a few minutes)
3. ./emsdk activate latest --permanent

#### Visual Studio project folder setup:
This project is entirely handled with MakeLists to be able to build it for multiple platforms:
Windows & Web HTML with emscripten, to build use:
| Platform   |              Build Action|
|-----------:|:-------------------------|
| MVC        | Ctrl + B, Ctrl + F5	|
| EMSCRIPTEN | Ctrl + Shift + B		|

To run on Web you need to execute ./run_web.bat in a command line inside root project folder

#### Be always sure to copy and include data folder in both places otherwise it won't work: 
- > LuaVermelha\build 					// for emscripten
- > LuaVermelha\intermediate\build\x64-Debug   		// for MVC 