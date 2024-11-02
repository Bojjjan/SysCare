echo +================================+======================
echo ^| Performing application upgrade ^|
echo +================================+
echo.

winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

set "scriptDir=%~dp0"
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
    echo ^| The following packages could not be upgraded  ^|
    echo ^| and therefore reinstalling                    ^|
    echo +================================================+
    echo.
    
    for /f "usebackq delims=" %%A in ("%file%") do (
        echo.
        echo Package reinstalling: %%A
        winget uninstall --id "%%A"
        winget install --id "%%A"
    )

    :: Cleanup temporary file
    del  %file%
)

echo Update Completed. No additional updates available!
del "%newDir%\temp.txt"
