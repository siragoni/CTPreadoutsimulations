@echo off
REM ****************************************************************************
REM Vivado (TM) v2018.3 (64-bit)
REM
REM Filename    : compile.bat
REM Simulator   : Mentor Graphics Questa Advanced Simulator
REM Description : Script for compiling the simulation design source files
REM
REM Generated by Vivado on Fri Jun 24 14:12:15 +0200 2022
REM SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
REM
REM Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
REM
REM usage: compile.bat
REM
REM ****************************************************************************
set bin_path=C:\\questasim64_10.6c\\win64
call %bin_path%/vsim  -c -do "do {IR_tb_compile.do}" -l compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
