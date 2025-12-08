@echo off
setlocal
cd /d "%~dp0"

:: -----------------------------------------------------------------------------
:: 1. CHECK FOR ADMIN PRIVILEGES (Self-elevation)
:: -----------------------------------------------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting Admin Privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

echo ==========================================
echo 🚀 STARTING COLD TURKEY CLONE
echo ==========================================

:: -----------------------------------------------------------------------------
:: 2. START BACKEND (New Window)
:: -----------------------------------------------------------------------------
echo 🔒 Starting Backend (Port 2345)...

:: Kill anything currently running on port 2345 to avoid conflicts
for /f "tokens=5" %%a in ('netstat -aon ^| find ":2345" ^| find "LISTENING"') do taskkill /f /pid %%a >nul 2>&1

:: Launch Uvicorn in a separate minimized window
:: We navigate to api_server, set PYTHONPATH to current dir, then run python
start "ColdTurkey_Backend" /min cmd /k "cd ..\..\api_server & set PYTHONPATH=%CD% & .venv\Scripts\python -m uvicorn app.main:app --reload --port 2345"

:: Wait a few seconds for backend to boot
timeout /t 5 /nobreak >nul

:: -----------------------------------------------------------------------------
:: 3. START FRONTEND (Current Window)
:: -----------------------------------------------------------------------------
echo Starting Web Server...
cd ..\..\web_server

:: Run pnpm dev
cmd /k "pnpm run dev"