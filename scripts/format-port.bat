@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo     %~nx0 ^<port-name^>
    echo.
    echo Formats the manifest of a registry port
    exit /b 1
)

set PORT_NAME=%~1
set MANIFEST=ports\%PORT_NAME%\vcpkg.json

if not exist "%MANIFEST%" (
    echo Port manifest not found:
    echo     %MANIFEST%
    exit /b 1
)

"%VCPKG_ROOT%\vcpkg" format-manifest "%MANIFEST%"
