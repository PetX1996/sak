@echo OFF

echo	_______________________
echo.
ECHO	SAK compilator
echo	_______________________
echo.
echo.
echo.
echo	_______________________
echo.
echo	Kompilovat...
echo.
echo	1. ALL
echo	2. FF file
echo	3. IWD file
echo.
echo	0. Finish
echo.
echo.
echo	_______________________

set /p mod_compile=:
set mod_compile=%mod_compile:~0,1%
if "%mod_compile%"=="1" goto FF_COMPILE
if "%mod_compile%"=="2" goto FF_COMPILE
if "%mod_compile%"=="3" goto IWD_COMPILE
if "%mod_compile%"=="0" goto FINISH


:FF_COMPILE
cls
echo	_______________________
echo.
echo	Compile FF file...
echo	_______________________
echo.

echo	Delete old FF file.

del mod.ff

echo.
echo	Add new file...
echo.
echo	_______________________
echo.

echo	Menu file...
xcopy ui_mp ..\..\raw\ui_mp /SY
echo.
echo.
echo	FXs...
xcopy fx ..\..\raw\fx\ /SY
echo.
echo.
echo	Scripts...
xcopy maps ..\..\raw\maps\ /SY
xcopy petx ..\..\raw\petx /SY
echo.
echo.
echo	Sounds...
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy sound ..\..\raw\sound /SY
echo.
echo.
echo	Localized...
xcopy english ..\..\raw\english /SY
echo.
echo.
echo	Table...
xcopy mp ..\..\raw\mp /SY
echo.
echo.
echo	Materials...
xcopy images ..\..\raw\images /SY
xcopy materials ..\..\raw\materials /SY
xcopy material_properties ..\..\raw\material_properties /SY
echo.
echo.
echo	Vision...
xcopy vision ..\..\raw\vision /SY
echo.
echo.
echo	Models...
xcopy xmodel ..\..\raw\xmodel /SY
xcopy xmodelparts ..\..\raw\xmodelparts /SY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SY
xcopy xanim ..\..\raw\xanim /SY
echo.
echo.
echo	Weapons...
xcopy weapons ..\..\raw\weapons\ /SY
echo.
echo	_______________________
echo.
copy /Y mod.csv ..\..\zone_source
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\sak
copy ..\..\zone\english\mod.ff

echo.
echo	_______________________
echo.
echo	Kompilacia FF dokoncena.
echo	_______________________
echo.

if "%mod_compile%"=="1" goto IWD_COMPILE
goto FINISH

:IWD_COMPILE
cls
echo	_______________________
echo.
echo	Compile IWD file...
echo	_______________________
echo.

echo	Delete old IWD.

del z_sak.iwd

echo.
echo	Add new file...
echo.

7za a -mx9 -r -tzip z_sak.iwd images\*.iwi
7za a -mx9 -r -tzip z_sak.iwd sound\*.mp3 sound\*.wav sound\*.txt
7za a -mx9 -r -tzip z_sak.iwd weapons\mp\*_mp

echo.
echo	_______________________
echo.
echo	Kompilacia IWD dokoncena.
echo	_______________________
echo.

goto FINISH

:FINISH
echo.
echo	_______________________
echo.
echo	Kompilacia modu dokoncena!
echo	_______________________
echo.
echo	Pokracuj stlacenim lubovolnej klavesy...
pause > NUM