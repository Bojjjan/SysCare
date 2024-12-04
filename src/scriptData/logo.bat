setlocal enabledelayedexpansion
set "len=43"

REM Get terminal dimensions
for /f "tokens=2 delims=:" %%A in ('mode con ^| find "Columns"') do set /a cols=%%A


REM Function to center a single line of text
set CenterLine=call :Center
goto :Output

:Center
set "line=%~1"
set /a padding=(cols - %len%) / 2
set "spaces="
for /l %%A in (1,1,%padding%) do set "spaces=!spaces! "
echo !spaces!%line%
goto :EOF

:Output
%CenterLine% " ____  _  _  ____   ___   __   ____  ____ "
%CenterLine% "/ ___)( \/ )/ ___) / __) / _\ (  _ \(  __)"
%CenterLine% "\___ \ )  / \___ \( (__ /    \ )   / ) _)"
%CenterLine% "(____/(__/  (____/ \___)\_/\_/(__\_)(____)"
%CenterLine% "v.%1" 
echo.