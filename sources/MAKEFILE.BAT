@echo off
REM SDCC ASM OBJ MAKEFILE
SET FILENAME=VDP_TMS9918A
REM 
if exist build\ goto NEXTSTEP1
echo MAKEDIR build
md build
:NEXTSTEP1
echo Compiling Object
sdasz80 -o build\%FILENAME%.rel src\%FILENAME%.s
pause
