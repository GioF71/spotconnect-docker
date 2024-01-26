# spotconnect-docker

A docker image for [SpotConnect](https://github.com/philippe44/SpotConnect).  
This repository replaces the previous [airplay](https://github.com/GioF71/spotconnect-airplay-docker) and [upnp](https://github.com/GioF71/spotconnect-upnp-docker) separate variants of the project, which will be no longer updated.  
The latest images include version [0.9.1](https://github.com/philippe44/SpotConnect/releases/tag/0.9.1).  

## References

This is based on [this project](https://github.com/philippe44/SpotConnect) by [philippe44](https://github.com/philippe44).  
In UPnP mode (`SPOTCONNECT_MODE=upnp`), it will let you use your upnp renderers (including those created with [upmpdcli](https://github.com/GioF71/upmpdcli-docker) and [mpd](https://github.com/giof71/mpd-alsa-docker)) as Spotify Connect devices.  
In AirPlay mode (`SPOTCONNECT_MODE=raop`), it will let you use your AirPlay renderers as Spotify Connect devices, including those that you have created using [Shairport Sync](https://github.com/mikebrady/shairport-sync).  
A container image for the AirPlay version is available [here](https://github.com/GioF71/spotconnect-airplay-docker).  

## Links

REPOSITORY|DESCRIPTION
:---|:---
Source code|[GitHub](https://github.com/GioF71/spotconnect-docker)
Docker images|[Docker Hub](https://hub.docker.com/r/giof71/spotconnect)

## Build

Simply build using the following:

```
docker build . -t giof71/spotconnect:latest
```

## Configuration

Configuration is available through a set of environment variables.  
There are currently just a few variables available to set, but more will come as soon as possible.  

VARIABLE|DESCRIPTION
:---|:---
PUID|Group used to run the application, defaults to `1000`
PGID|Group used to run the application, defaults to `1000`
PREFER_STATIC|Prefer `-static` version of the executable, defaults to `no`
VORBIS_BITRATE|Set the vorbis bitrate to `320`, `160` or `96`, defaults to `320`
SPOTCONNECT_MODE|SpotConnect mode: `upnp` or `raop` (for AirPlay), defaults to `upnp`
APPLETV_PAIRING_MODE|Runs in Apple TV Pairing mode, see issue [#1](https://github.com/GioF71/spotconnect-docker/issues/1)
CONFIG_FILE_PREFIX|Prefix for the config file, empty by default
LOG_LEVEL_ALL|Enables log of type `all` using the provided value
LOG_LEVEL_MAIN|Enables log of type `main` using the provided value
LOG_LEVEL_UTIL|Enables log of type `util` using the provided value
LOG_LEVEL_UPNP|Enables log of type `upnp` using the provided value
LOG_LEVEL_RAOP|Enables log of type `raop` using the provided value

## Run

Simple docker-compose files below.  

### UPnP Mode

```
---
version: "3"

volumes:
  config:

services:
  spotconnect-upnp:
    image: giof71/spotconnect:latest
    container_name: spotconnect-upnp
    network_mode: host
    environment:
      - SPOTCONNECT_MODE=upnp
      - PUID=1000
      - PGID=1000
    volumes:
      - config:/config
    restart: unless-stopped
```

### AirPlay Mode

```
---
version: "3"

volumes:
  config:

services:
  spotconnect-airplay:
    image: giof71/spotconnect:latest
    container_name: spotconnect-airplay
    network_mode: host
    environment:
      - SPOTCONNECT_MODE=raop
      - PUID=1000
      - PGID=1000
    volumes:
      - config:/config
    restart: unless-stopped
```

## Changelog

The changelog of the upstream project is available [here](https://github.com/philippe44/SpotConnect/blob/master/CHANGELOG).  

DATE|DESCRIPTION
:---|:---
2024-01-26|Add support for log level of type `raop`
2024-01-26|Bump to version [0.9.1](https://github.com/philippe44/SpotConnect/releases/tag/0.9.1)
2024-01-15|Bump to version [0.9.0](https://github.com/philippe44/SpotConnect/releases/tag/0.9.0)
2024-01-10|Add support for log levels
2024-01-09|Bump to version [0.8.6](https://github.com/philippe44/SpotConnect/releases/tag/0.8.6)
2023-12-27|Bump to version [0.8.5](https://github.com/philippe44/SpotConnect/releases/tag/0.8.5)
2023-12-26|Bump to version [0.8.4](https://github.com/philippe44/SpotConnect/releases/tag/0.8.4)
2023-12-18|Bump to version [0.8.3](https://github.com/philippe44/SpotConnect/releases/tag/0.8.3)
2023-12-17|Bump to version [0.8.1](https://github.com/philippe44/SpotConnect/releases/tag/0.8.1)
2023-12-13|Support AppleTv Pairing mode (see [#1](https://github.com/GioF71/spotconnect-docker/issues/1))
2023-12-13|Bump to version [0.8.0](https://github.com/philippe44/SpotConnect/releases/tag/0.8.0)
2023-12-07|Bump to version [0.7.0](https://github.com/philippe44/SpotConnect/releases/tag/0.7.0)
2023-12-05|Bump to version [0.6.2](https://github.com/philippe44/SpotConnect/releases/tag/0.6.2)
2023-12-02|Bump to version [0.6.1](https://github.com/philippe44/SpotConnect/releases/tag/0.6.1)
2023-11-28|Bump to version [0.6.0](https://github.com/philippe44/SpotConnect/releases/tag/0.6.0)
2023-11-23|First working release
