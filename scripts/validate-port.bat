@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo     %~nx0 ^<port-name^>
    exit /b 1
)

call "%~dp0\format-port.bat" %1

"%VCPKG_ROOT%\vcpkg" format-manifest ports\%1\vcpkg.json > nul

echo Validating port '%1'...

if not exist ports\%1\vcpkg.json (
    echo Missing vcpkg.json
    exit /b 1
)

if not exist ports\%1\portfile.cmake (
    echo Missing portfile.cmake
    exit /b 1
)

echo Validation successful
