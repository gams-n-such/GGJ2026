@::!/dos/rocks
@echo off
SETLOCAL
goto :init

:header
    echo %__NAME% v%__VERSION%
    echo This is a sample batch file template,
    echo providing command-line arguments and flags.
    echo.
    goto :eof

:usage
    echo USAGE:
    echo   %__BAT_NAME% [flags] [BranchName] 
    echo.
    echo.  /?, --help           shows this help
    goto :eof

:missing_argument
    call :header
    call :usage
    echo.
    echo ****    Missing branch name    ****
    echo.
    goto :eof

:init
    set "__NAME=%~n0"

    set "__BAT_FILE=%~0"
    set "__BAT_PATH=%~dp0"
    set "__BAT_NAME=%~nx0"

    set "PullFlag="

:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"           call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="-?"           call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="--help"       call :header & call :usage "%~2" & goto :end

    if /i "%~1"=="/p"           set "PullFlag=yes"     & shift & goto :parse
    if /i "%~1"=="-p"           set "PullFlag=yes"     & shift & goto :parse
    if /i "%~1"=="--pull"       set "PullFlag=yes"     & shift & goto :parse

    if not defined BranchName   set "BranchName=%~1"   & shift & goto :parse

    shift
    goto :parse

:validate
    if not defined BranchName call :missing_argument & goto :end

:main
    cd "%__BAT_PATH%"
	
    git checkout "%BranchName%"
    
	if %errorlevel% neq 0 exit /b %errorlevel%
	
    if defined PullFlag (
        git pull
		
		if %errorlevel% neq 0 exit /b %errorlevel%
    )
    
	_GenerateSolution.bat /c /r
    
:end
    call :cleanup
    exit /B

:cleanup
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.

    goto :eof
