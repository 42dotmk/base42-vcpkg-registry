@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo     %~nx0 ^<port-name^> [options]
    echo.
    echo Regenerates version metadata for a registry port
    exit /b 1
)

pushd "%~dp0\.."

"%VCPKG_ROOT%\vcpkg" ^
    --overlay-ports=ports ^
    --x-builtin-ports-root=ports ^
    --x-builtin-registry-versions-dir=versions ^
    x-add-version %*

popd
