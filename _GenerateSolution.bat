@::!/dos/rocks
@echo on
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
	echo   %__BAT_NAME% [flags] "required argument" "optional argument" 
	echo.
	echo.  /?, --help           shows this help
	echo.  /v, --version        shows the version
	echo.  /e, --verbose        shows detailed output
	echo.  -f, --flag value     specifies a named parameter value
	goto :eof

:missing_argument
	call :header
	call :usage
	echo.
	echo ****    MISSING "REQUIRED ARGUMENT"    ****
	echo.
	goto :eof

:find_msbuild
	for /f "tokens=* USEBACKQ" %%f IN (
		`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`
	) do (
		set "MSBUILD_PATH=%%f"
	)
	echo %MSBUILD_PATH%
	goto :eof

:generate_solution
	if defined ConstFlag (
		copy "%PROJECT_FILE%" "%PROJECT_FILE%.backup"
		attrib +h "%PROJECT_FILE%.backup"
	)
	
	"%LAUNCHER_PATH%\Engine\Binaries\Win64\UnrealVersionSelector.exe" -switchversionsilent "%PROJECT_PATH%" "%ENGINE_PATH%"
	::"%ENGINE_PATH%\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.exe" -projectfiles -progress -project="%PROJECT_PATH%"

	if defined ConstFlag (
		attrib -h "%PROJECT_FILE%.backup"
		copy /Y "%PROJECT_FILE%.backup" "%PROJECT_FILE%"
		del /Q "%PROJECT_FILE%.backup"
	)
	goto :eof

:init
	set "__NAME=%~n0"

	set "__BAT_FILE=%~0"
	set "__BAT_PATH=%~dp0"
	set "__BAT_NAME=%~nx0"

	set "FALLBACK_ENGINE_PATH=C:\Program Files\Epic Games\UE_5.5"
	
	set "PROJECT_FILE="
	set "PROJECT_DIR="
	set "PROJECT_PATH="
	set "ENGINE_PATH="
	REM set "LAUNCHER_PATH="
	set "LAUNCHER_PATH=C:\Program Files (x86)\Epic Games\Launcher"
	set "SOLUTION_FILE="
	set "MSBUILD_PATH="
	set "MSBUILD_PROJECT_NAME="
	
	set "GenFlag="
	set "ConstFlag="
	set "BuildFlag="
	set "VSFlag="
	set "EditorFlag="

:parse
	if "%~1"=="" goto :validate

	if /i "%~1"=="/?"           call :header & call :usage "%~2" & goto :end
	if /i "%~1"=="-?"           call :header & call :usage "%~2" & goto :end
	if /i "%~1"=="--help"       call :header & call :usage "%~2" & goto :end

	if /i "%~1"=="/g"           set "GenFlag=yes"     & shift & goto :parse
	if /i "%~1"=="-g"           set "GenFlag=yes"     & shift & goto :parse
	if /i "%~1"=="--generate"   set "GenFlag=yes"     & shift & goto :parse

	if /i "%~1"=="/c"           set "ConstFlag=yes"   & shift & goto :parse
	if /i "%~1"=="-c"           set "ConstFlag=yes"   & shift & goto :parse
	if /i "%~1"=="--const"      set "ConstFlag=yes"   & shift & goto :parse

	if /i "%~1"=="/b"           set "BuildFlag=yes"   & shift & goto :parse
	if /i "%~1"=="-b"           set "BuildFlag=yes"   & shift & goto :parse
	if /i "%~1"=="--build"      set "BuildFlag=yes"   & shift & goto :parse

	if /i "%~1"=="/v"           set "VSFlag=yes"      & shift & goto :parse
	if /i "%~1"=="-v"           set "VSFlag=yes"      & shift & goto :parse
	if /i "%~1"=="--vs"         set "VSFlag=yes"      & shift & goto :parse

	if /i "%~1"=="/r"           set "RiderFlag=yes"   & shift & goto :parse
	if /i "%~1"=="-r"           set "RiderFlag=yes"   & shift & goto :parse
	if /i "%~1"=="--rider"      set "RiderFlag=yes"   & shift & goto :parse

	if /i "%~1"=="/u"           set "EditorFlag=yes"  & shift & goto :parse
	if /i "%~1"=="-u"           set "EditorFlag=yes"  & shift & goto :parse
	if /i "%~1"=="--editor"     set "EditorFlag=yes"  & shift & goto :parse

	if /i "%~1"=="/d"           set "PROJECT_DIR=%~2"     & shift & shift & goto :parse
	if /i "%~1"=="-d"           set "PROJECT_DIR=%~2"     & shift & shift & goto :parse
	if /i "%~1"=="--dir"        set "PROJECT_DIR=%~2"     & shift & shift & goto :parse

	if /i "%~1"=="/p"           set "PROJECT_FILE=%~2"    & shift & shift & goto :parse
	if /i "%~1"=="-p"           set "PROJECT_FILE=%~2"    & shift & shift & goto :parse
	if /i "%~1"=="--project"    set "PROJECT_FILE=%~2"    & shift & shift & goto :parse

	if /i "%~1"=="/s"           set "SOLUTION_FILE=%~2"   & shift & shift & goto :parse
	if /i "%~1"=="-s"           set "SOLUTION_FILE=%~2"   & shift & shift & goto :parse
	if /i "%~1"=="--solution"   set "SOLUTION_FILE=%~2"   & shift & shift & goto :parse

	if /i "%~1"=="/e"           set "ENGINE_PATH=%~2"     & shift & shift & goto :parse
	if /i "%~1"=="-e"           set "ENGINE_PATH=%~2"     & shift & shift & goto :parse
	if /i "%~1"=="--engine"     set "ENGINE_PATH=%~2"     & shift & shift & goto :parse

	if not defined UnNamedArgument     set "UnNamedArgument=%~1"     & shift & goto :parse
	if not defined UnNamedOptionalArg  set "UnNamedOptionalArg=%~1"  & shift & goto :parse

	shift
	goto :parse

:validate
	if 1==2 goto :end

:main
	if exist "_GenerateSolution_Overrides.bat" (
		call _GenerateSolution_Overrides.bat
	)
	
	if not defined PROJECT_DIR (
		set "PROJECT_DIR=%cd%"
	)
	
	for %%P in ("%PROJECT_DIR%\*.uproject") do (
		set "PROJECT_FILE=%%~nxP"
		set "MSBUILD_PROJECT_NAME=%%~nP"
		set "PROJECT_PATH=%%~fP"
	)
	
	if not defined PROJECT_FILE (
		echo "No .uproject file found at %PROJECT_DIR%"
		pause
		goto :end
	)

	if not defined ENGINE_PATH (
		set "ENGINE_PATH=%FALLBACK_ENGINE_PATH%"
	)

	if defined GenFlag (
		call :generate_solution
	)
	
	if not defined SOLUTION_FILE (
		for %%S in (*.sln) do (
			set "SOLUTION_FILE=%%~fS"
		)
	)
	
	if defined BuildFlag (
		call :find_msbuild
	)
	if defined BuildFlag (
		::call "%MSBUILD_PATH%" "%SOLUTION_FILE%" /p:Configuration="Development Editor" /p:Platform="Win64" /t:"Games\%MSBUILD_PROJECT_NAME%"
		call "%ENGINE_PATH%\Engine\Build\BatchFiles\RunUAT.bat" BuildEditor -project="%PROJECT_PATH%" -notools
		if ErrorLevel 1 (
			pause
			goto :end
		)
	)
	
	if defined EditorFlag (
		start "%ENGINE_PATH%\Engine\Binaries\Win64\UE4Editor.exe" "%PROJECT_PATH%"
		if ErrorLevel 1 (
			pause
		)
		goto :end
	)
	
	if defined RiderFlag (
		start rider64.exe "%PROJECT_PATH%"
		if ErrorLevel 1 (
			pause
		)
		goto :end
	)
	
	if defined VSFlag (
		start devenv "%SOLUTION_FILE%"
		if ErrorLevel 1 (
			pause
		)
		goto :end
	)
	
:end
	call :cleanup

	exit /B

:cleanup
	REM The cleanup function is only really necessary if you
	REM are _not_ using SETLOCAL.

	goto :eof
