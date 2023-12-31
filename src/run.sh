#!/bin/bash

# Exit on error
set -e

# Wine settings
# export WINEPREFIX=/home/steam/.wine
# export WINEDLLOVERRIDES="mscoree=n,b;mshtml=n,b"
export WINEARCH=win64
export WINEDEBUG=-all
winetricks sound=disabled

# Remove X Server lock
rm -rf /tmp/.X1-lock
# Set up virtual X server using Xvfb
Xvfb :1 -screen 0 1024x768x16 &
# Set the DISPLAY environment variable
export DISPLAY=:1

# Check if SteamCMD directory exists
if [ ! -d "/home/steam/steamcmd" ]; then
  echo "SteamCMD directory not found. Make sure you have set up the volume correctly."
  exit 1
fi

# Fix windows newline characters for steam credentials
steamusername=$(echo -n "$STEAM_USERNAME" | sed $'s/\r//')
steampassword=$(echo -n "$STEAM_PASSWORD" | sed $'s/\r//')
steam2fa=$(echo -n "$STEAM_2FA" | sed $'s/\r//')
betaname=$(echo -n "$BETA_NAME" | sed $'s/\r//')

# Log in to SteamCMD using the provided credentials
steam_login_cmd="/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/battlebit +login $steamusername"
if [ "$steam2fa" != "true" ]; then
  steam_login_cmd="$steam_login_cmd $steampassword"
fi
if [ "$ENABLE_BETA" = "true" ]; then
  $steam_login_cmd +app_update 671860 -beta "$betaname" validate +quit
else
  $steam_login_cmd +app_update 671860 validate +quit
fi

# Check if the game directory exists
if [ ! -d "/home/steam/battlebit" ]; then
  echo "Game directory not found. There might be an issue with downloading the game."
  exit 1
fi

# Read server configurations from /config/server.conf
if [ -f "/home/steam/config/server.conf" ]; then
  # shellcheck source=/dev/null
  source /home/steam/config/server.conf
else
  echo "Server config file not found: /home/steam/config/server.conf"
  exit 1
fi

# Formulate the arguments for BattleBit executable
battlebit_args=(
  -batchmode
  -nographics
  -lowmtumode
  "-Name=$Name"
  "-Password=$Password"
  "-AntiCheat=$AntiCheat"
  "-Hz=$Hz"
  "-Port=$Port"
  "-MaxPing=$MaxPing"
  "-LocalIP=$LocalIP"
  "-VoxelMode=$VoxelMode"
  "-ApiEndpoint=$ApiEndpoint"
  "-FixedSize=$FixedSize"
  "-FirstSize=$FirstSize"
  "-MaxSize=$MaxSize"
  "-FirstGamemode=$FirstGamemode"
  "-FirstMap=$FirstMap"
)

echo "/-----------------------------/"
echo "Server Settings:"
echo "Name: $Name"
echo "Password: $Password"
echo "AntiCheat: $AntiCheat"
echo "Hz: $Hz"
echo "Port: $Port"
echo "MaxPing: $MaxPing"
echo "LocalIP: $LocalIP"
echo "VoxelMode: $VoxelMode"
echo "ApiEndpoint: $ApiEndpoint"
echo "FixedSize: $FixedSize"
echo "FirstSize: $FirstSize"
echo "MaxSize: $MaxSize"
echo "FirstGamemode: $FirstGamemode"
echo "FirstMap: $FirstMap"
echo "/-----------------------------/"
echo "Launching the BattleBit game server..."

# Run the BattleBit game server using Wine with the formulated arguments
cd /home/steam/battlebit

# Redirect stdout to the log file
exec wine ./BattleBit.exe "${battlebit_args[@]}"
