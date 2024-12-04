@echo off

set "restart_required=false"
set "scriptDir=%~dp0"
set "tempDir=%scriptDir:~0,-1%"
cd "%tempDir%"
cd ..
set "tempDir=%cd%"
set "newDir=%tempDir%\temp"

IF NOT EXIST "%newDir%" (
    mkdir "%newDir%"
)

echo.
echo Checking dependencies...

REM Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Python not found. Installing Python...
    winget install --id Python.Python.3.10 -e --source winget
    set "restart_required=true"
) else (
    echo [+] Python is already installed.
)

REM Check for Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Git not found. Installing Git... 
    winget install --id Git.Git -e --source winget
    set "restart_required=true"
) else (
    echo [+] Git is already installed.
)


REM Check if restart is required
if "%restart_required%"=="true" (
    echo.
    echo Please restart the script!
    pause
    exit
)