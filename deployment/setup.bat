@echo off
echo ==========================================
echo 📦 SETTING UP COLD TURKEY CLONE (WINDOWS)
echo ==========================================

:: 1. Setup Backend
echo.
echo [1/4] Setting up Python Backend...
cd ..\..\api_server
call uv sync

:: 2. Setup Frontend
echo.
echo [2/4] Setting up Next.js Frontend...
cd ..\web_server
call pnpm install

echo.
echo ==========================================
echo ✅ SETUP COMPLETE!
echo You can now run 'start.bat'
echo ==========================================
pause