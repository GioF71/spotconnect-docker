#!/bin/bash

# errors
# 1 invalid parameter
# 2 invalid vorbis bitrate

mkdir /app/conf -p

DEFAULT_UID=1000
DEFAULT_GID=1000

if [ -z "${PUID}" ]; then
  PUID=$DEFAULT_UID;
  echo "Setting default value for PUID: ["$PUID"]"
fi

if [ -z "${PGID}" ]; then
  PGID=$DEFAULT_GID;
  echo "Setting default value for PGID: ["$PGID"]"
fi

DEFAULT_USER_NAME=spotc
DEFAULT_GROUP_NAME=spotc
DEFAULT_HOME_DIR=/home/$DEFAULT_USER_NAME

USER_NAME=$DEFAULT_USER_NAME
GROUP_NAME=$DEFAULT_GROUP_NAME
HOME_DIR=$DEFAULT_HOME_DIR

echo "Ensuring user with uid:[$PUID] gid:[$PGID] exists ...";
### create group if it does not exist
if [ ! $(getent group $PGID) ]; then
    echo "Group with gid [$PGID] does not exist, creating..."
    groupadd -g $PGID $GROUP_NAME
    echo "Group [$GROUP_NAME] with gid [$PGID] created."
else
    GROUP_NAME=$(getent group $PGID | cut -d: -f1)
    echo "Group with gid [$PGID] name [$GROUP_NAME] already exists."
fi
### create user if it does not exist
if [ ! $(getent passwd $PUID) ]; then
    echo "User with uid [$PUID] does not exist, creating..."
    useradd -g $PGID -u $PUID -M $USER_NAME
    echo "User [$USER_NAME] with uid [$PUID] created."
else
    USER_NAME=$(getent passwd $PUID | cut -d: -f1)
    echo "user with uid [$PUID] name [$USER_NAME] already exists."
    HOME_DIR="/home/$USER_NAME"
fi
### create home directory
if [ ! -d "$HOME_DIR" ]; then
    echo "Home directory [$HOME_DIR] not found, creating."
    mkdir -p $HOME_DIR
    echo ". done."
fi
chown -R $PUID:$PGID $HOME_DIR
chown -R $PUID:$PGID /config

if [[ -z "${SPOTCONNECT_MODE}" ]]; then
    # Use upnp mode by default
    SPOTCONNECT_MODE=upnp
fi

if [[ "${SPOTCONNECT_MODE^^}" == "UPNP" ]]; then
    SPOTCONNECT_MODE=upnp
elif [[ "${SPOTCONNECT_MODE^^}" == "RAOP" ]]; then
    SPOTCONNECT_MODE=raop
else
    echo "Invalid SPOTCONNECT_MODE [${SPOTCONNECT_MODE}], must be 'upnp' or 'raop'"
    exit 1
fi

binary_file=/app/bin/spot${SPOTCONNECT_MODE}-linux
if [[ -n "$PREFER_STATIC" ]]; then
    echo "PREFER_STATIC=[$PREFER_STATIC]"
    if [[ "${PREFER_STATIC^^}" == "YES" || "${PREFER_STATIC^^}" == "Y" ]]; then
        echo "Selecting static version ..."
        binary_file=$binary_file-static
        echo ". done."
    elif [[ "${PREFER_STATIC^^}" != "NO" && "${PREFER_STATIC^^}" != "N" ]]; then
        echo "Invalid value for PREFER_STATIC [$PREFER_STATIC]!"
        exit 2
    fi
fi

version=$(cat /app/bin/version.txt)

echo "Using SpotConnect ${SPOTCONNECT_MODE} version [${version}]"

CMD_LINE="$binary_file"

if [[ -z "${VORBIS_BITRATE}" ]]; then
    echo "VORBIS_BITRATE not set, using 320"
    VORBIS_BITRATE=320
fi

if [[ -n "${UPNP_HTTP_CONTENT_LENGTH_MODE}" ]]; then
    if [[ "${SPOTCONNECT_MODE^^}" == "UPNP" ]]; then
        echo "Using UPNP_HTTP_CONTENT_LENGTH_MODE=[${UPNP_HTTP_CONTENT_LENGTH_MODE}]"
        CMD_LINE="$CMD_LINE -g ${UPNP_HTTP_CONTENT_LENGTH_MODE}"
    else
        echo "UPNP_HTTP_CONTENT_LENGTH_MODE=[${UPNP_HTTP_CONTENT_LENGTH_MODE}] but SPOTCONNECT_MODE=[${SPOTCONNECT_MODE}], ignoring."
    fi
fi

if [[ -n "${UPNP_HTTP_CACHING_MODE}" ]]; then
    if [[ "${SPOTCONNECT_MODE^^}" == "UPNP" ]]; then
        echo "Using UPNP_HTTP_CACHING_MODE=[${UPNP_HTTP_CACHING_MODE}]"
        CMD_LINE="$CMD_LINE -A ${UPNP_HTTP_CACHING_MODE}"
    else
        echo "UPNP_HTTP_CACHING_MODE=[${UPNP_HTTP_CACHING_MODE}] but SPOTCONNECT_MODE=[${SPOTCONNECT_MODE}], ignoring."
    fi
fi

if [[ -n "${OUTPUT_CODEC}" ]]; then
    echo "Using OUTPUT_CODEC=[${OUTPUT_CODEC}]"
    CMD_LINE="$CMD_LINE -c ${OUTPUT_CODEC}"
fi

if [[ "${VORBIS_BITRATE}" == "320" || "${VORBIS_BITRATE}" == "160" || "${VORBIS_BITRATE}" == "96" ]]; then
    CMD_LINE="$CMD_LINE -r ${VORBIS_BITRATE}"
else
    echo "Invalid VORBIS_BITRATE [${VORBIS_BITRATE}]"
    exit 2
fi

CONFIG_FILE_NAME="config.xml"
if [[ -n "${CONFIG_FILE_PREFIX}" ]]; then
    CONFIG_FILE_NAME="${CONFIG_FILE_PREFIX}-config.xml"
fi

if [[ -n "${LOG_LEVEL_ALL}" ]]; then
    CMD_LINE="$CMD_LINE -d all=${LOG_LEVEL_ALL}"
fi

if [[ -n "${LOG_LEVEL_MAIN}" ]]; then
    CMD_LINE="$CMD_LINE -d main=${LOG_LEVEL_MAIN}"
fi

if [[ -n "${LOG_LEVEL_UTIL}" ]]; then
    CMD_LINE="$CMD_LINE -d util=${LOG_LEVEL_UTIL}"
fi

if [[ -n "${LOG_LEVEL_UPNP}" ]]; then
    CMD_LINE="$CMD_LINE -d upnp=${LOG_LEVEL_UPNP}"
fi

if [[ -n "${LOG_LEVEL_RAOP}" ]]; then
    CMD_LINE="$CMD_LINE -d raop=${LOG_LEVEL_RAOP}"
fi

if [[ "${SPOTCONNECT_MODE}" == "raop" && ("${APPLETV_PAIRING_MODE^^}" == "YES" || "${APPLETV_PAIRING_MODE^^}" == "Y") ]]; then
    CMD_LINE="$CMD_LINE -x /config/$CONFIG_FILE_NAME -l"
else
    CMD_LINE="$CMD_LINE -x /config/$CONFIG_FILE_NAME -I -k -Z"
fi

if [[ -n "${STORE_CRED_XML}" ]]; then
    echo "STORE_CRED_XML=[${STORE_CRED_XML}]"
    if [[ "${STORE_CRED_XML^^}" == "YES" ]] || [[ "${STORE_CRED_XML^^}" == "Y" ]]; then
        CMD_LINE="$CMD_LINE -j"
    elif [[ "${STORE_CRED_XML^^}" != "NO" ]] && [[ "${STORE_CRED_XML^^}" != "N" ]]; then
        echo "Invalid STORE_CRED_XML=[${STORE_CRED_XML}]!"
        exit 1
    fi
else
    echo "STORE_CRED_XML not set, disabled by default"
fi

echo "NETWORK_SELECT=${NETWORK_SELECT}"
select_network="${NETWORK_SELECT}"
if [[ -z "${select_network}" ]]; then
    echo "ENABLE_AUTO_NETWORK=[${ENABLE_AUTO_NETWORK}]"
    if [[ -z "${ENABLE_AUTO_NETWORK}" ]] || [[ "${ENABLE_AUTO_NETWORK^^}" == "YES" ]] || [[ "${ENABLE_AUTO_NETWORK^^}" == "Y" ]]; then
        echo "Automatically setting network ..."
        auto_network_url="${AUTO_NETWORK_URL}"
        if [[ -z "${auto_network_url}" ]]; then
            auto_network_url=1.1.1.1
        fi
        select_network=$(ip route get $auto_network_url | grep -oP 'dev\s+\K[^ ]+')
        select_ip=$(ifconfig $select_network | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
        chosen_network_argument="${select_network}"
        if [[ -z "${NETWORK_USE_IP}" ]] || [[ "${NETWORK_USE_IP^^}" == "YES" ]] || [[ "${NETWORK_USE_IP^^}" == "Y" ]]; then
            chosen_network_argument="${select_ip}"
        fi
        echo "Automatically setting network [Done]"
        CMD_LINE="$CMD_LINE -b ${chosen_network_argument}"
    elif [[ "${ENABLE_AUTO_NETWORK^^}" != "NO" ]] && [[ "${ENABLE_AUTO_NETWORK^^}" != "N" ]]; then
        echo "Invalid ENABLE_AUTO_NETWORK=[${ENABLE_AUTO_NETWORK}]"
        exit 1
    fi
else
    # use provided iface
    CMD_LINE="$CMD_LINE -b ${select_network}"
fi

echo "Command Line: ["$CMD_LINE"]"
su - $USER_NAME -c "$CMD_LINE"
