#!/usr/bin/env bash

SCREEN_NAME="cs16"
USER="steam"
PORT="27015"
DIR_STEAMCMD="/opt/steamcmd"
DIR_ROOT="$DIR_STEAMCMD/games/cs16"
DIR_GAME="$DIR_ROOT/cstrike"
DIR_LOGS="$DIR_GAME/logs"
STEAM_RUNSCRIPT="${DIR_STEAMCMD}/runscript_${SCREEN_NAME}"
DAEMON_GAME="hlds_run"

TZ=${TZ:-"UTC"}
PUID=${PUID:-1000}
PGID=${PGID:-1000}

SSMTP_PORT=${SSMTP_PORT:-"25"}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-"$(hostname -f)"}
SSMTP_TLS=${SSMTP_TLS:-"NO"}

GSLT=${GSLT}
STEAM_LOGIN=${STEAM_LOGIN:-"anonymous"}
STEAM_PASSWORD=${STEAM_PASSWORD:-"anonymous"}
UPDATE_LOG=${DIR_LOGS}/update_$(date +%Y%m%d).log
UPDATE_EMAIL=${UPDATE_EMAIL}
UPDATE_RETRY=${UPDATE_RETRY:-"3"}
CLEAR_DOWNLOAD_CACHE=${CLEAR_DOWNLOAD_CACHE:-"0"}
API_AUTHORIZATION_KEY=${API_AUTHORIZATION_KEY}
MAXPLAYERS=${MAXPLAYERS:-"12"}
TICKRATE=${TICKRATE:-"64"}

EXTRAPARAMS=${EXTRAPARAMS:-"+map de_inferno"}
PARAM_START="-game cstrike -console -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -insecure -nobreakpad -pingboost 2 -port 27015 +hostname ${SCREEN_NAME} +maxplayers ${MAXPLAYERS} +sv_lan 0 -sys_ticrate ${TICKRATE} -noipx -heapsize 40960 ${EXTRAPARAMS}"
PARAM_UPDATE="+login ${STEAM_LOGIN} ${STEAM_PASSWORD} +force_install_dir ${DIR_ROOT} +app_update 90 validate +quit"

# Timezone
echo "Setting timezone to ${TZ}..."
sudo ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} | sudo tee /etc/timezone > /dev/null

# Change steam UID / GID
echo "Checking if steam UID / GID has changed..."
if [ $(id -u steam) != ${PUID} ]; then
  usermod -u ${PUID} steam
fi
if [ $(id -g steam) != ${PGID} ]; then
  groupmod -g ${PGID} steam
fi

# Check vars
if [ ! -z "$UPDATE_EMAIL" ]; then
  if [ -z "$SSMTP_HOST" ] ; then
    echo "WARNING: SSMTP_HOST must be defined if you want to send emails"
    sudo cp -f /etc/ssmtp/ssmtp.conf.or /etc/ssmtp/ssmtp.conf
    UPDATE_EMAIL=""
  fi
else
  echo "NOTICE: UPDATE_EMAIL is not set"
fi

# SSMTP
if [ ! -z "$SSMTP_HOST" ] ; then
  echo "Setting SSMTP configuration..."
  cat > /tmp/ssmtp.conf <<EOL
mailhub=${SSMTP_HOST}:${SSMTP_PORT}
hostname=${SSMTP_HOSTNAME}
FromLineOverride=YES
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}
UseTLS=${SSMTP_TLS}
UseSTARTTLS=${SSMTP_TLS}
EOL
  sudo mv -f /tmp/ssmtp.conf /etc/ssmtp/ssmtp.conf
fi
unset SSMTP_HOST
unset SSMTP_USER
unset SSMTP_PASSWORD

# Config
cat > "/etc/cs16-server-launcher/cs16-server-launcher.conf" <<EOL
SCREEN_NAME="${SCREEN_NAME}"
USER="${USER}"
PORT="${PORT}"

# Anonymous connection will be deprecated in the near future. Therefore it is highly recommended to generate a Game Server Login Token.
GSLT="${GSLT}"

DIR_STEAMCMD="${DIR_STEAMCMD}"
STEAM_LOGIN="${STEAM_LOGIN}"
STEAM_PASSWORD="${STEAM_PASSWORD}"
STEAM_RUNSCRIPT="${STEAM_RUNSCRIPT}"

DIR_ROOT="${DIR_ROOT}"
DIR_GAME="${DIR_GAME}"
DIR_LOGS="${DIR_LOGS}"
DAEMON_GAME="${DAEMON_GAME}"

UPDATE_LOG="${UPDATE_LOG}"
UPDATE_EMAIL="${UPDATE_EMAIL}"
UPDATE_RETRY=${UPDATE_RETRY}
CLEAR_DOWNLOAD_CACHE=${CLEAR_DOWNLOAD_CACHE}

API_AUTHORIZATION_KEY="${API_AUTHORIZATION_KEY}"
WORKSHOP_COLLECTION_ID="${WORKSHOP_COLLECTION_ID}"
WORKSHOP_START_MAP="${WORKSHOP_START_MAP}"

# Game config
MAXPLAYERS="${MAXPLAYERS}"
TICKRATE="${TICKRATE}"
EXTRAPARAMS="${EXTRAPARAMS}"

# Major settings
PARAM_START="${PARAM_START}"
PARAM_UPDATE="${PARAM_UPDATE}"
EOL
unset GSLT
unset API_AUTHORIZATION_KEY

# Perms
echo "Fixing permissions..."
sudo chown -R steam. ${DIR_STEAMCMD} /home/steam /etc/cs16-server-launcher

exec "$@"
