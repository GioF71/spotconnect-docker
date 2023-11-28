# spotconnect-docker

A docker image for [SpotConnect](https://github.com/philippe44/SpotConnect).  
This repository replaces the old [airplay](https://github.com/GioF71/spotconnect-airplay-docker) and [upnp](https://github.com/GioF71/spotconnect-upnp-docker) separate variants, which will not be updated.  
The image includes version [0.6.0](https://github.com/philippe44/SpotConnect/releases/tag/0.6.0).  

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
SPOTCONNECT_MODE|SpotConnect mode: `upnp` or `raop` (for AirPlay), defaults to upnp
CONFIG_FILE_PREFIX|Prefix for the config file, empty by default

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

DATE|DESCRIPTION
:---|:---
2023-11-28|Bump to version [0.6.0](https://github.com/philippe44/SpotConnect/releases/tag/0.6.0)
2023-11-23|First working release
