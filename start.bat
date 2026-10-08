@echo off
title Recruiting Agent Control Tower (SW-06)
echo ======================================================================
echo   Launching Recruiting Agent Control Tower...
echo ======================================================================
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"
pause
