@echo off
set PS_SCRIPT=%~dp0\diff.ps1
powershell -ExecutionPolicy RemoteSigned -STA -WindowStyle Hidden "%PS_SCRIPT%" """%1""" """%2"""
rem powershell -ExecutionPolicy RemoteSigned -STA "%PS_SCRIPT%" """%1""" """%2"""
