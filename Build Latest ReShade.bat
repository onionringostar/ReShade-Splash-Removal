@echo off
setlocal
cd /d "%~dp0"
echo.
echo ReShade One-Click Update Builder
echo ================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-Latest-ReShade.ps1"
echo.
if errorlevel 1 (
  echo The updater stopped because an error occurred.
) else (
  echo The updater finished.
)
echo.
pause
