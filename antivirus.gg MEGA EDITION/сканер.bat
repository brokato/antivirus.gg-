@echo off
title Antivirus Scanner
color 0A
cls

echo ==============================
echo    ANTIVIRUSNYI SKANER
echo ==============================
echo.
echo Nagmite lubuyu knopku...
pause >nul
cls

echo ==============================
echo      IDET SKANIROVANIE
echo ==============================
echo.

echo [1/5] Proverka C:\
dir C:\ >nul 2>&1
timeout /t 2 >nul
start explorer C:\
echo.

echo [2/5] Proverka Windows
dir C:\Windows >nul 2>&1
timeout /t 2 >nul
start explorer C:\Windows
echo.

echo [3/5] Proverka Program Files
dir "C:\Program Files" >nul 2>&1
timeout /t 2 >nul
start explorer "C:\Program Files"
echo.

echo [4/5] Proverka Dokumentov
dir "%USERPROFILE%\Documents" >nul 2>&1
timeout /t 2 >nul
start explorer "%USERPROFILE%\Documents"
echo.

echo [5/5] Proverka Zagruzok
dir "%USERPROFILE%\Downloads" >nul 2>&1
timeout /t 2 >nul
start explorer "%USERPROFILE%\Downloads"
echo.

echo ==============================
echo      REZULTATY
echo ==============================
echo.
echo Naideno virusov: 5
echo.
echo 1. Trojan.Win32.Fake
echo 2. Backdoor.Generic
echo 3. Worm.Python
echo 4. Ransomware
echo 5. Adware
echo.
pause