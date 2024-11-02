echo Checking dependencies...
set "restart_required=false"

:: Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Installing Python...
    winget install --id Python.Python.3.10 -e --source winget
    set "restart_required=true"
) else (
    echo Python is already installed.
)

:: Check for Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git not found. Installing Git...
    winget install --id Git.Git -e --source winget
    set "restart_required=true"
) else (
    echo Git is already installed.
)


:: Check if restart is required
if "%restart_required%"=="true" (
    echo Please restart the script!
    pause
    exit
)