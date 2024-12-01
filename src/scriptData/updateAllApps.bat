cls
set "scriptDir=%~dp0"
call "%scriptDir%\logo.bat"


echo +================================+======================
echo ^| Performing application upgrade ^|
echo +================================+!!!!!!!!!!!!
echo.

winget upgrade --all -e --silent --accept-source-agreements --accept-package-agreements --source winget 

set "tempDir=%scriptDir:~0,-1%"
cd "%tempDir%"
cd ..
set "tempDir=%cd%"
set "newDir=%tempDir%\temp"



IF NOT EXIST "%newDir%" (
    mkdir "%tempDir%"
)

winget upgrade > "%newDir%\temp.txt"

set "script_path=%tempDir%\Extract_ids.py"
python "%script_path%"


echo.
echo.

set "file=%newDir%\output_ids.txt"
IF EXIST "%file%" (
    echo +================================================+
    echo ^| The following packages could not be upgraded!  ^|
    echo +================================================+
    echo.
    
    FOR /f "usebackq delims=" %%A in ("%file%") do (
        echo * %%A
    )

    echo.
    echo.

    set "skip=false" 
    echo Do you want to reinstall the above packages? ^[y/n^]
    set /p choice="Select an option: "

    IF /I "%choice%"=="y" (
        set "skip=true"

    ) ELSE (
        set "skip=false"
    )

    IF "%skip%"=="true" (
        FOR /f "usebackq delims=" %%A in ("%file%") do (
            echo.
            echo Package reinstalling: %%A
            winget uninstall --id "%%~A"
            winget install --id "%%~A" -e --accept-source-agreements --source winget 
        )
    ) ELSE (
        echo.
        echo Reinstalling skipped
    )

    :: Cleanup temporary file
    del  %file%
)

echo Update Completed. No additional updates available!
del "%newDir%\temp.txt"
