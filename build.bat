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
call %nuget% pack "SepaWriter\SepaWriter.csproj" -symbols -verbosity detailed -o Build -p Configuration=%config% %version%
if not "%errorlevel%"=="0" goto failure

:success
exit 0

:failure
exit -1

REM @echo Off
REM set config=%1
REM if "%config%" == "" (
   REM set config=Release
REM )
 
REM set version=1.0.0
REM if not "%PackageVersion%" == "" (
   REM set version=%PackageVersion%
REM )

REM set nuget=
REM if "%nuget%" == "" (
	REM set nuget=nuget
REM )

REM %WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild SepaWriter.sln /p:Configuration="%config%" /m /v:M /fl /flp:LogFile=msbuild.log;Verbosity=diag /nr:false

REM mkdir Build
REM mkdir Build\lib
REM mkdir Build\lib\net40

REM %nuget% pack "SepaWriter.nuspec" -NoPackageAnalysis -verbosity detailed -o Build -Version %version% -p Configuration="%config%"
