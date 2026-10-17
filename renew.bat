@echo off
setlocal EnableExtensions

cd /d "%~dp0"

echo [1/4] Checking files and tools...
if not exist "figures\figure2.pdf" (
  echo ERROR: figures\figure2.pdf was not found.
  goto :failed
)

where pdftoppm >nul 2>nul
if errorlevel 1 (
  echo ERROR: pdftoppm was not found in PATH.
  goto :failed
)

where node >nul 2>nul
if errorlevel 1 (
  echo ERROR: Node.js was not found in PATH.
  goto :failed
)

if not exist "media\" mkdir "media"

echo [2/4] Rendering the static Figure 2 preview...
pdftoppm -png -singlefile -scale-to-x 1600 -scale-to-y -1 "figures\figure2.pdf" "media\figure2"
if errorlevel 1 goto :failed

if not exist "media\figure2.png" (
  echo ERROR: media\figure2.png was not generated.
  goto :failed
)

echo [3/4] Updating all Figure 2 preview references...
node -e "const fs=require('fs');const p='assets/index-AkHX7tDp.js';let s=fs.readFileSync(p,'utf8');const u='media/figure2.png?v='+Date.now();s=s.replace(/media\/figure2(?:-thumb)?\.(?:webp|png)(?:\?v=\d+)?/g,u);fs.writeFileSync(p,s);"
if errorlevel 1 goto :failed

echo [4/4] Checking the website JavaScript...
node --check "assets\index-AkHX7tDp.js"
if errorlevel 1 goto :failed

echo.
echo Static display refreshed successfully.
echo Output: media\figure2.png
pause
exit /b 0

:failed
echo.
echo Refresh failed. Review the error above.
pause
exit /b 1
