@echo off
REM ===================================================
REM Script de configuración inicial para Samsung Galaxy A21s
REM ===================================================

REM 1. Crear archivo setup_phone.json
echo { > config\setup_phone.json
echo   "prinstaledApps": [ >> config\setup_phone.json

REM 2. Obtener lista de apps instaladas
for /f "tokens=*" %%A in ('adb shell pm list packages') do (
    set "line=%%A"
    setlocal enabledelayedexpansion
    set "line=!line:package:=!"
    echo     "!line!", >> config\setup_phone.json
    endlocal
)

REM Quitar última coma y cerrar JSON (reemplazo manual opcional)
echo   ] >> config\setup_phone.json
echo } >> config\setup_phone.json

echo [OK] Listado de apps guardado en setup_phone.json

REM 3. Borrar caché y desinstalar apps innecesarias
echo [OK] Eliminando apps preinstaladas...
adb shell pm clear com.microsoft.skydrive
adb shell pm uninstall --user 0 com.microsoft.skydrive

adb shell pm clear com.netflix.mediaclient
adb shell pm uninstall --user 0 com.netflix.mediaclient

adb shell pm clear com.samsung.android.game.gamehome
adb shell pm uninstall --user 0 com.samsung.android.game.gamehome

adb shell pm clear com.google.android.googlequicksearchbox
adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox

adb shell pm clear com.google.android.gm
adb shell pm uninstall --user 0 com.google.android.gm

adb shell pm clear com.google.android.youtube
adb shell pm uninstall --user 0 com.google.android.youtube

echo [OK] Apps eliminadas.

REM 4. Copiar carpeta w a Pictures
echo [OK] Copiando carpeta w a /sdcard/Pictures/...
adb push data\backup\w /sdcard/Pictures/

REM Establecer fondos de pantalla (puede variar en Samsung)
adb push data\backup\w\lock_screen.jpg /sdcard/Pictures/
adb push data\backup\w\main_screen.jpg /sdcard/Pictures/

REM Fondo de pantalla principal
adb shell cmd wallpaper set /sdcard/Pictures/main_screen.jpg

REM Fondo de pantalla de bloqueo (puede que requiera root o apps de terceros)
adb shell cmd wallpaper set /sdcard/Pictures/lock_screen.jpg --lock

REM 5. Cambiar nombre del dispositivo
echo [OK] Cambiando nombre del dispositivo a NV[01]...
adb shell settings put global device_name "NV[01]"
adb shell setprop persist.sys.device_name "NV[01]"

REM 6. Instalar APKs desde carpeta apps
echo [OK] Instalando OnlyOffice y Aurora Store...
adb install -r data\apps\only-office.apk
adb install -r data\apps\aurora-store.apk
adb install -r data\apps\telegram.apk

echo ===================================================
echo [FIN] Configuración completada con éxito.
echo ===================================================
pause
