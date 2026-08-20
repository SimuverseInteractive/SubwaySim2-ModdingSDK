@echo off
setlocal enabledelayedexpansion

if not defined DLC_NAME set DLC_NAME=Simuverse_ModTemplate
if not defined LEVEL_PATH set LEVEL_PATH=
if not defined ENGINE_ROOT set ENGINE_ROOT=C:\Program Files\Epic Games\UE_5.7

echo:
echo === Building mod "%DLC_NAME%" using engine "%ENGINE_ROOT%"...
echo:

cd /d "%~dp0\..\..\"
set SUCCESS=0

rem Check Dangling Assets
set DANGLING_ASSETS=0
for /r "%CD%\Mount" %%F in (*) do (
    if not exist "%%F\" (
        echo %%F
        set DANGLING_ASSETS=1
    )
)
if %DANGLING_ASSETS% equ 1 (
    echo:
    echo Please see previous lines and move assets created in temporary mount locations to your mod plugin or remove them.
    goto SkipBuild
)

rem NavMesh
if not "%LEVEL_PATH%" == "" (
    if not defined NAV_MESH set /p NAV_MESH=Build the NavMesh for level "%LEVEL_PATH%" ^(y/N^)^: 

    if /i "!NAV_MESH!" == "y" (
		"%ENGINE_ROOT%/Engine/Binaries/Win64/UnrealEditor.exe" "%CD%/SubwaySim2.uproject" "/%DLC_NAME%/%LEVEL_PATH%" -run=WorldPartitionBuilderCommandlet -AllowCommandletRendering -builder=WorldPartitionNavigationDataBuilder -SCCProvider=None
    )
)

rem Lua Import
"%CD%\Binaries\Win64\LuaImportSettings.exe"
"%ENGINE_ROOT%/Engine/Binaries/Win64/UnrealEditor-Cmd.exe" "%CD%/SubwaySim2.uproject" -run=ImportAssets -AllowCommandletRendering -nosourcecontrol -replaceexisting -unattended -importSettings="%CD%/Plugins/UnrealLuaJIT/luaImport.json"

rem Build Mod
call "%ENGINE_ROOT%/Engine/Build/BatchFiles/RunUAT.bat" BuildCookRun -project="%CD%/SubwaySim2.uproject" -platform=Win64 -configuration=Shipping -build -skipbuild -cook -stage -dlcname=%DLC_NAME% -basedonreleaseversion=1.0 -DLCIncludeEngineContent

rem Copy Movies
xcopy "%CD%\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Movies" "%CD%\Plugins\SubwaySim_Extern\%DLC_NAME%\Saved\Cooked\Windows\SubwaySim2\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Movies" /E /I /Y

rem Package Mod
call "%ENGINE_ROOT%/Engine/Build/BatchFiles/RunUAT.bat" BuildCookRun -project="%CD%/SubwaySim2.uproject" -platform=Win64 -configuration=Shipping -build -skipbuild -cook -skipcook -stage -skipstage -pak -package -archive -archivedirectory="%CD%/Output" -dlcname=%DLC_NAME% -basedonreleaseversion=1.0 -DLCIncludeEngineContent
set ARCHIVE_PAK=%CD%\Output\Windows\SubwaySim2\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Paks\Windows\%DLC_NAME%SubwaySim2-Windows.pak
if exist "%ARCHIVE_PAK%" (
    set SUCCESS=1
)

rem Finish Mod
if defined PAK_VERSION (
	set OUTPUT_PAK=%CD%\Output\%DLC_NAME%_v%PAK_VERSION%.pak
) else (
	set OUTPUT_PAK=%CD%\Output\%DLC_NAME%.pak
)
move "%ARCHIVE_PAK%" "%OUTPUT_PAK%"
if not defined PAK_VERSION (
	echo:
    echo === WARNING: Build the mod from within the editor. The mod could not be versioned and will not load. ===
)

rem Clean Up
rmdir /s /q "%CD%\Output\Windows"
rmdir /s /q "%CD%\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Lua"
rmdir /s /q "%CD%\Plugins\SubwaySim_Extern\%DLC_NAME%\Saved"
del "%CD%\Plugins\UnrealLuaJIT\luaImport.json"

:SkipBuild

echo:
if %SUCCESS% equ 1 (
    echo === Mod has been built: "%OUTPUT_PAK%" ===
) else (
    echo === Error while building mod "%DLC_NAME%". ===
)
echo:

pause
