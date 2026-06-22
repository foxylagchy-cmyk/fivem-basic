@echo off
echo ====================================
echo Collecting Files for Server Upload
echo ====================================
echo.

set OUTPUT_FOLDER=files_to_upload
set TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%

echo Creating output folder...
if exist %OUTPUT_FOLDER% (
    rmdir /s /q %OUTPUT_FOLDER%
)
mkdir %OUTPUT_FOLDER%

echo.
echo [1/8] Copying ox_inventory/server.lua...
mkdir "%OUTPUT_FOLDER%\[OX]\ox_inventory"
copy "resources\[OX]\ox_inventory\server.lua" "%OUTPUT_FOLDER%\[OX]\ox_inventory\" >nul

echo [2/8] Copying qbx_core/config/server.lua...
mkdir "%OUTPUT_FOLDER%\[QBX]\qbx_core\config"
copy "resources\[QBX]\qbx_core\config\server.lua" "%OUTPUT_FOLDER%\[QBX]\qbx_core\config\" >nul

echo [3/8] Copying qbx_spawn/client/main.lua...
mkdir "%OUTPUT_FOLDER%\[QBX]\qbx_spawn\client"
copy "resources\[QBX]\qbx_spawn\client\main.lua" "%OUTPUT_FOLDER%\[QBX]\qbx_spawn\client\" >nul

echo [4/8] Copying pefcl/.disabled...
mkdir "%OUTPUT_FOLDER%\[QBX]\pefcl"
copy "resources\[QBX]\pefcl\.disabled" "%OUTPUT_FOLDER%\[QBX]\pefcl\" >nul

echo [5/8] Copying qbx_npwd/.disabled...
mkdir "%OUTPUT_FOLDER%\[QBX]\qbx_npwd"
copy "resources\[QBX]\qbx_npwd\.disabled" "%OUTPUT_FOLDER%\[QBX]\qbx_npwd\" >nul

echo [6/8] Copying cmd_heal resource...
mkdir "%OUTPUT_FOLDER%\[local]\cmd_heal"
xcopy "resources\[local]\cmd_heal\*.*" "%OUTPUT_FOLDER%\[local]\cmd_heal\" /s /e /q

echo [7/8] Copying documentation...
copy "FIXES_APPLIED.md" "%OUTPUT_FOLDER%\" >nul
copy "UPLOAD_TO_SERVER.md" "%OUTPUT_FOLDER%\" >nul
copy "QUICK_FIX_SUMMARY.txt" "%OUTPUT_FOLDER%\" >nul

echo [8/8] Creating README for server admin...
(
echo ========================================
echo INSTALLATION INSTRUCTIONS
echo ========================================
echo.
echo 1. BACKUP ORIGINAL FILES FIRST!
echo.
echo 2. COPY FILES TO SERVER:
echo    - Copy [OX] folder to resources/[OX]/
echo    - Copy [QBX] folder to resources/[QBX]/
echo    - Copy [local] folder to resources/[local]/
echo.
echo 3. ADD TO server.cfg:
echo    ensure cmd_heal
echo.
echo 4. RESTART SERVER:
echo    - Via txAdmin: Click Restart
echo    - Via console: Type 'quit' then restart
echo.
echo 5. TEST:
echo    - Create new character
echo    - Check spawn selector appears
echo    - Test /healme command
echo    - Check console for errors
echo.
echo 6. IF PROBLEMS OCCUR:
echo    - Restore backup files
echo    - Restart server
echo    - Check FIXES_APPLIED.md for details
echo.
echo ========================================
echo WHAT'S FIXED:
echo ========================================
echo ✓ PEFCL errors fixed
echo ✓ NPWD warnings removed
echo ✓ Spawn selector black screen fixed
echo ✓ Admin heal commands added
echo.
echo Total size: ^<100 KB
echo Tested on: FiveM Build 3258
echo Framework: QBX
echo.
echo For questions: Check FIXES_APPLIED.md
echo ========================================
) > "%OUTPUT_FOLDER%\INSTALL.txt"

echo.
echo ====================================
echo Creating ZIP archive...
echo ====================================

powershell -Command "Compress-Archive -Path '%OUTPUT_FOLDER%\*' -DestinationPath 'fixes_for_server_%TIMESTAMP%.zip' -Force"

if exist "fixes_for_server_%TIMESTAMP%.zip" (
    echo.
    echo ====================================
    echo SUCCESS!
    echo ====================================
    echo.
    echo Folder: %OUTPUT_FOLDER%\
    echo ZIP: fixes_for_server_%TIMESTAMP%.zip
    echo.
    echo File siap untuk di-upload ke server!
    echo Size: Approx 100 KB
    echo.
    echo Next:
    echo 1. Upload ZIP ke server
    echo 2. Extract di folder server
    echo 3. Follow INSTALL.txt
    echo 4. Restart server
    echo.
) else (
    echo.
    echo ERROR: Failed to create ZIP
    echo Gunakan folder %OUTPUT_FOLDER% untuk manual upload
    echo.
)

pause
