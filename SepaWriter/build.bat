@echo Off
set config=%1
if "%config%" == "" (
   set config=Release
)

set version=
if not "%PackageVersion%" == "" (
   set version=-Version %PackageVersion%
)

set nunit="tools\nunit\nunit-console.exe"

REM Build
"%programfiles(x86)%\MSBuild\14.0\Bin\MSBuild.exe" SepaWriter.sln /p:Configuration="%config%" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=Normal /nr:false
if not "%errorlevel%"=="0" goto failure

REM Unit tests
%nunit% SepaWriter\SepaWriter.Tests\bin\%config%\SepaWriter.Tests.dll
if not "%errorlevel%"=="0" goto failure

REM Package
mkdir Build
call %nuget% pack "SepaWriter\SepaWriter.csproj" -symbols -o Build -p Configuration=%config% %version%
if not "%errorlevel%"=="0" goto failure

:success
exit 0

:failure
exit -1