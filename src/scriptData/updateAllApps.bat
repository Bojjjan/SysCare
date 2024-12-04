cls
set "scriptDir=%~dp0"
call "%scriptDir%logo.bat" %1
setlocal enabledelayedexpansion

set "tempDir=%scriptDir:~0,-1%"
cd "%tempDir%"
cd ..
set "tempDir=%cd%"
set "newDir=%tempDir%\temp"

echo +================================+
echo ^| Performing application upgrade ^|
echo +================================+
echo.

set "Extract_ids_args=true"
winget upgrade > "%newDir%\temp.txt"
python "%tempDir%\update.py"
python "%tempDir%\Extract_ids.py" %Extract_ids_args%


set "file=%newDir%\output_ids.txt"
if exist %file% (
    FOR /f "usebackq delims=" %%A in ("%file%") do (
        echo.
        echo Upgrading %%A
        winget upgrade %%A -e --silent --accept-source-agreements --accept-package-agreements --include-unknown --source winget 
    )
    del  %file%


)

winget upgrade > "%newDir%\temp.txt"
python "%tempDir%\Extract_ids.py"
echo.

IF EXIST "%file%" (
    echo +================================================+
    echo ^| The following packages could not be upgraded^!  ^|
    echo +================================================+
    echo.
    
    FOR /f "usebackq delims=" %%A in ("%file%") do (
        echo  * %%A
    )

    echo.
    echo.

    set "skip=false" 
    echo Do you want to reinstall the above packages? ^[Y/N^]
    set /p choice="Select an option:"

    IF /I "!choice!"=="y" (
        set "skip=true"

    ) ELSE (
        set "skip=false"
    )

    IF "!skip!"=="true" (
        FOR /f "usebackq delims=" %%A in ("%file%") do (
            echo.
            echo Package reinstalling: %%A
            winget uninstall --id "%%~A" -e
            winget install --id "%%~A" -e --accept-source-agreements --source winget 
        )
        
    ) ELSE (
        echo.
        echo Reinstalling skipped
    )

    :: Cleanup temporary file
    del  %file%
)


del "%newDir%\temp.txt"
echo Update Completed. No additional updates available!

