call "%logo%"
echo ========================================================
echo 		 Performing full Health Check
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