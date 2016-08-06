@echo off
cd %~dp0
if not exist logs md logs
lua main.lua
pause
