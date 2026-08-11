@echo off
REM ============================================================
REM  Windows 사용자는 이 파일을 더블클릭하세요.
REM  PowerShell 실행 정책 때문에 .ps1 이 직접 실행되지 않는 경우를
REM  우회하기 위한 래퍼입니다.
REM ============================================================
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
