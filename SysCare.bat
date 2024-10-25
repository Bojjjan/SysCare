@echo off
:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. 
    echo Please grant access when prompted.
    echo.
    :: Relaunch the script with administrative privileges
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:main
cls
echo        ____  _  _  ____   ___   __   ____  ____ 
echo       / ___)( \/ )/ ___) / __) / _\ (  _ \(  __)
echo       \___ \ )  / \___ \( (__ /    \ )   / ) _) 
echo       (____/(__/  (____/ \___)\_/\_/(__\_)(____)
echo.
echo ========================================================
echo                "ctrl + c" to end a task
echo ========================================================
echo.
echo.
echo [1] Check for application updates (winget)
echo [2] Check System Health
echo [3] Restart apps/ Services
echo.
echo.
echo [0] Exit
echo ========================================================
choice /c 1230 /n /m "Select an option: "

rem Errorlevel values handled below:
if %errorlevel%==1 goto check_applications
if %errorlevel%==2 goto systemHealthMenu
if %errorlevel%==3 goto restartServices
if %errorlevel%==4 goto exit

:restartServices
cls
echo        ____  _  _  ____   ___   __   ____  ____ 
echo       / ___)( \/ )/ ___) / __) / _\ (  _ \(  __)
echo       \___ \ )  / \___ \( (__ /    \ )   / ) _) 
echo       (____/(__/  (____/ \___)\_/\_/(__\_)(____)
echo.
echo ========================================================
echo               RESTART APPS/ SERVICES
echo ========================================================
echo.
echo [1] Rebuild Search index (windows Search)
echo.
echo.
echo [0] Back to main menu
echo ========================================================
choice /c 012 /n /m "Select an option: "

if %errorlevel%==1 goto main     			 :: '0'
if %errorlevel%==2 goto RebuildWindowsSearch             :: '1'


:RebuildWindowsSearch
cls
echo Restarting Windows Search service...

net stop "WSearch"
net start "WSearch"

echo Windows Search service restarted successfully!
pause
goto restartServices

:systemHealthMenu
cls
echo        ____  _  _  ____   ___   __   ____  ____ 
echo       / ___)( \/ )/ ___) / __) / _\ (  _ \(  __)
echo       \___ \ )  / \___ \( (__ /    \ )   / ) _) 
echo       (____/(__/  (____/ \___)\_/\_/(__\_)(____)
echo.
echo ========================================================
echo                  SYSTEM HEALTH CHECK
echo ========================================================
echo [a] Full Health Check (takes a while)
echo.
echo ---------------- System Repair -----------------------
echo [1] Restore system health (DISM /RestoreHealth)
echo [2] Check the integrity of Windows system (sfc)
echo [3] Scan your disk for errors and repair them (chkdsk)
echo [4] Microsoft Malicious Software Removal Tool (MRT)
echo.
echo.

echo ---------------- Clean System ------------------------
echo [5] Disk Cleanup (cleanmgr)
echo [6] Clean DNS (flushDNS)
echo.

echo.
echo [0] Back to main menu
echo ========================================================
choice /c a1234506 /n /m "Select an option: "

if %errorlevel%==1 goto all_System_health     :: 'a'
if %errorlevel%==2 goto dismcheck             :: '1'
if %errorlevel%==3 goto sfcscan               :: '2'
if %errorlevel%==4 goto chkdsk                :: '3'
if %errorlevel%==5 goto startMRT              :: '4'
if %errorlevel%==6 goto cleanmgr              :: '5'
if %errorlevel%==7 goto main                  :: '0'
if %errorlevel%==8 goto clearDNS    	      :: '6'

:startMRT
cls
echo Starting Microsoft Malicious Software Removal Tool...
cd %windir%\System32
start MRT.exe
pause
goto systemHealthMenu


:RebuildSearchIndex
cls
echo Rebuilding search index...

powershell -Command "Stop-Service -Name WSearch"
powershell -Command "Start-Service -Name WSearch"

echo Search index rebuild started!
pause
goto systemHealthMenu

:clearDNS
cls
echo Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared!
pause
goto systemHealthMenu


:cleanmgr
cls
echo Running Disk Cleanup...
cleanmgr /sagerun:1
Dism.exe /online /Cleanup-Image /StartComponentCleanup
echo Disk Cleanup complete!
pause
goto systemHealthMenu

:sfcscan
cls
sfc /scannow

if %errorlevel% equ 0 (
    echo SFC completed successfully and found no integrity violations.
) else if %errorlevel% equ 1 (
    echo SFC found issues and fixed them.
) else if %errorlevel% equ 2 (
    echo SFC found corrupt files but could not fix some of them. Check the CBS.log at C:\Windows\Logs\CBS\CBS.log for details.
) else (
    echo An unexpected error occurred during SFC scan. Check the CBS log for more information.
)
echo.
pause
goto systemHealthMenu



:dismcheck
cls
DISM /Online /Cleanup-Image /RestoreHealth

if %errorlevel% equ 0 (
    echo DISM completed successfully.
) else (
    echo DISM encountered an error. Check the DISM log file at C:\Windows\Logs\DISM\dism.log for more information.
)
echo.
pause
goto systemHealthMenu

:chkdsk
cls
chkdsk C: /f /r

if %errorlevel% equ 0 (
    echo No errors found on the disk.
) else if %errorlevel% geq 1 (
    echo CHKDSK found and corrected errors on the disk.
) else (
    echo CHKDSK encountered an error. Review the output or check the Event Viewer logs for details.
)
echo.
pause
goto systemHealthMenu



:all_System_health
cls
echo        ____  _  _  ____   ___   __   ____  ____ 
echo       / ___)( \/ )/ ___) / __) / _\ (  _ \(  __)
echo       \___ \ )  / \___ \( (__ /    \ )   / ) _) 
echo       (____/(__/  (____/ \___)\_/\_/(__\_)(____)
echo.
echo ========================================================
echo 		Performing full Health Check
echo +=====================+=================================
echo ^| Performing DISM ... ^|
echo +=====================+
DISM /Online /Cleanup-Image /RestoreHealth

if %errorlevel% equ 0 (
    echo DISM completed successfully.
) else (
    echo DISM encountered an error. Check the DISM log file at C:\Windows\Logs\DISM\dism.log for more information.
)


echo.
echo +=============================+
echo ^| Now performing SFC scan...  ^|
echo +=============================+
sfc /scannow

if %errorlevel% equ 0 (
    echo SFC completed successfully and found no integrity violations.
) else if %errorlevel% equ 1 (
    echo SFC found issues and fixed them.
) else if %errorlevel% equ 2 (
    echo SFC found corrupt files but could not fix some of them. Check the CBS.log at C:\Windows\Logs\CBS\CBS.log for details.
) else (
    echo An unexpected error occurred during SFC scan. Check the CBS log for more information.
)


echo.
echo +================================+
echo ^| Now performing Chkdsk scan...  ^|
echo +================================+
chkdsk C: /f /r

if %errorlevel% equ 0 (
    echo No errors found on the disk.
) else if %errorlevel% geq 1 (
    echo CHKDSK found and corrected errors on the disk.
) else (
    echo CHKDSK encountered an error. Review the output or check the Event Viewer logs for details.
)

echo.
pause
goto systemHealthMenu







:check_applications
cls

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Installing Python...
    winget install Python.Python.3.10
) else (
    echo Python is already installed.
)



echo        ____  _  _  ____   ___   __   ____  ____ 
echo       / ___)( \/ )/ ___) / __) / _\ (  _ \(  __)
echo       \___ \ )  / \___ \( (__ /    \ )   / ) _) 
echo       (____/(__/  (____/ \___)\_/\_/(__\_)(____)
echo.
echo +================================+======================
echo ^| Performing application upgrade ^|
echo +================================+
echo.

winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

set "scriptDir=%~dp0"
set "tempDir=%scriptDir%\src\temp"

mkdir "%tempDir%"
winget upgrade > "%tempDir%\temp.txt"

set "script_path=%scriptDir%\src\Extract_ids.py"
python "%script_path%"


echo.
echo.

echo ======================================================
echo The following packages could not be upgraded:


set "file=%tempDir%\output_ids.txt"
for /f "usebackq delims=" %%A in ("%file%") do (
    echo.
    echo Package to Reinstalling: %%A
    winget uninstall --id "%%A"
    winget install --id -h "%%A"
    
)


:: Cleanup temporary file
del "%tempDir%\temp.txt"
del  %file%
pause
goto main



:exit
exit
