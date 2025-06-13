@echo off
setlocal enabledelayedexpansion

rem ADJUST THE VARIABLES
set DLC_NAME=Simuverse_SampleModMap
set LEVEL_PATH=Level/SampleModMap
set ENGINE_ROOT=C:\Program Files\Epic Games\UE_5.4
rem ADJUST THE VARIABLES


echo:
echo === Building mod "%DLC_NAME%" using engine "%ENGINE_ROOT%"...
echo:

rem NavMesh
if not "%LEVEL_PATH%" == "" (
    set /p BUILD_NAVMESH=Build the NavMesh for level "%LEVEL_PATH%" ^(y/N^)^: 

    if /i "!BUILD_NAVMESH!" == "y" (
		"%ENGINE_ROOT%/Engine/Binaries/Win64/UnrealEditor.exe" "%CD%/SubwaySim2.uproject" "/%DLC_NAME%/%LEVEL_PATH%" -run=WorldPartitionBuilderCommandlet -AllowCommandletRendering -builder=WorldPartitionNavigationDataBuilder -SCCProvider=None
    )
)

rem Lua Import
"%CD%\Binaries\Win64\LuaImportSettings.exe"
"%ENGINE_ROOT%/Engine/Binaries/Win64/UnrealEditor-Cmd.exe" "%CD%/SubwaySim2.uproject" -run=ImportAssets -AllowCommandletRendering -nosourcecontrol -replaceexisting -unattended -importSettings="%CD%/Plugins/UnrealLuaJIT/luaImport.json"

rem Build Mod
call "%ENGINE_ROOT%/Engine/Build/BatchFiles/RunUAT.bat" BuildCookRun -project="%CD%/SubwaySim2.uproject" -platform=Win64 -configuration=Shipping -build -skipbuild -cook -stage -pak -package -archive -archivedirectory="%CD%/Output" -dlcname=%DLC_NAME% -basedonreleaseversion=1.0 -DLCIncludeEngineContent
set ARCHIVE_PAK=%CD%\Output\Windows\SubwaySim2\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Paks\Windows\%DLC_NAME%SubwaySim2-Windows.pak
if exist "%ARCHIVE_PAK%" (
    set SUCCESS=1
) else (
    set SUCCESS=0
)

rem Clean Up
move "%ARCHIVE_PAK%" "%CD%\Output\%DLC_NAME%.pak"
rmdir /s /q "%CD%\Output\Windows"
rmdir /s /q "%CD%\Plugins\SubwaySim_Extern\%DLC_NAME%\Content\Lua"
del "%CD%\Plugins\UnrealLuaJIT\luaImport.json"

echo:
if "%SUCCESS%" equ "1" (
    echo === Mod has been built: "%CD%\Output\%DLC_NAME%.pak" ===
) else (
    echo === Error while building mod "%DLC_NAME%". ===
)
echo:

pause
