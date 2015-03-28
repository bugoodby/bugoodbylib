@echo off
set PS_SCRIPT=%~dp0\01.command_line.ps1
powershell -ExecutionPolicy RemoteSigned "%PS_SCRIPT%" """%1""" """%2""" """%3"""
pause
