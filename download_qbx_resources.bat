@echo off
echo ====================================
echo QBX Resources Auto Downloader
echo KotaCeria FiveM Server
echo ====================================
echo.

cd /d "%~dp0resources\[QBX]"

echo Checking Git installation...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/
    pause
    exit /b 1
)

echo.
echo ====================================
echo Downloading Core Resources...
echo ====================================

echo [1/15] Downloading qbx_banking...
git clone https://github.com/Qbox-project/qbx_banking qb-banking-main

echo [2/15] Downloading qbx_ambulancejob...
git clone https://github.com/Qbox-project/qbx_ambulancejob qb-ambulancejob-main

echo [3/15] Downloading qbx_policejob...
git clone https://github.com/Qbox-project/qbx_policejob qb-policejob-main

echo [4/15] Downloading qbx_adminmenu...
git clone https://github.com/Qbox-project/qbx_adminmenu qbx_adminmenu-main

echo [5/15] Downloading qbx_management...
git clone https://github.com/Qbox-project/qbx_management qbx_management

echo [6/15] Downloading qbx_vehiclekeys...
git clone https://github.com/Qbox-project/qbx_vehiclekeys qbx_vehiclekeys

echo [7/15] Downloading qbx_radialmenu...
git clone https://github.com/Qbox-project/qbx_radialmenu qbx_radialmenu

echo [8/15] Downloading qbx_phone...
git clone https://github.com/Qbox-project/qbx_phone qbx_phone

echo [9/15] Downloading qbx_customs...
git clone https://github.com/Qbox-project/qbx_customs qbx_customs

echo [10/15] Downloading qbx_properties...
git clone https://github.com/Qbox-project/qbx_properties qbx_houses-main

echo [11/15] Downloading qb-clothing...
git clone https://github.com/Qbox-project/qb-clothing qb-clothing-main

echo [12/15] Downloading qbx_storerobbery...
git clone https://github.com/Qbox-project/qbx_storerobbery qbx_storerobbery-main

echo [13/15] Downloading qbx_bankrobbery...
git clone https://github.com/Qbox-project/qbx_bankrobbery qbx_bankrobbery-main

echo [14/15] Downloading qb-lapraces...
git clone https://github.com/Qbox-project/qb-lapraces qb-lapraces-main

echo [15/15] Downloading qb-crypto...
git clone https://github.com/Qbox-project/qb-crypto qb-crypto-main

echo.
echo ====================================
echo Download Complete!
echo ====================================
echo.
echo Next Steps:
echo 1. Import database tables from sql/ folders in each resource
echo 2. Update server.cfg to ensure all resources
echo 3. Restart your FiveM server
echo.
echo Check DOWNLOAD_RESOURCES.md for detailed instructions!
echo.
pause
