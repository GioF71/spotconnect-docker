# Application help screens

## UPnP

```text
v0.9.2 (Mar  5 2024 @ 17:24:36)
See -t for license terms
Usage: [options]
  -b <ip>[:<port>]     network interface and UPnP port to use
  -a <port>[:<count>]  set inbound port and range for RTP and HTTP
  -r 96|160|320        set Spotify vorbis codec rate (160)
  -J <path>            path to Spotify credentials files
  -j                   store Spotify credentials in XML config file
  -U <user>            Spotify username
  -P <password>        Spotify password
  -l                   send continuous audio stream instead of separated tracks
  -g -3|-2|-1|0|<n>    HTTP content-length mode (-3:chunked(*), -2:if known, -1:none, 0:fixed, <n> your value)
  -A 0|1|2                     HTTP caching mode (0=memory, 1=memory but claim it's infinite(*), 2=on disk)
  -e                   disable gapless
  -u <version>         set the maximum UPnP version for search (default 1)
  -N <format>          transform device name using C format (%s=name)
  -x <config file>     read config from file (default ./config.xml)
  -i <config file>     discover players, save <config file> and exit
  -I                   auto save config at every network scan
  -f <logfile>         write debug to logfile
  -p <pid file>        write PID in file
  -m <n1,n2...>        exclude devices whose model include tokens
  -n <m1,m2,...>       exclude devices whose name includes tokens
  -o <m1,m2,...>       include only listed models; overrides -m and -n (use <NULL> if player don't return a model)
  -d <log>=<level>     set logging level
                       logs: all|main|util|upnp
                       level: error|warn|info|debug|sdebug
  -c mp3[:<rate>]|opus[:<rate>]|vorbis[:rate]|flc[:0..9]|wav|pcm audio format send to player (flac)
  -z                   daemonize
  -Z                   NOT interactive
  -k                   immediate exit on SIGQUIT and SIGTERM
  -t                   license terms

Build options: LINUX
```

## AirPlay

```text
v0.9.2 (Mar  5 2024 @ 14:38:15)
See -t for license terms
Usage: [options]
  -b <ip>             network interface/IP address to bind to
  -a <port>[:<count>] set inbound port and range for RTP and HTTP
  -J <path>           path to Spotify credentials files
  -j                   store Spotify credentials in XML config file
  -U <user>           Spotify username
  -P <password>       Spotify password
  -L                  set AirPlay player password
  -c <alac|pcm>       audio format send to player (alac)
  -r <96|160|320>     set Spotify vorbis codec rate (160)
  -N <format>         transform device name using C format (%s=name)
  -x <config file>    read config from file (default is ./config.xml)
  -i <config file>    discover players, save <config file> and exit
  -I                  auto save config at every network scan
  -f <logfile>        write debug to logfile
  -l                  AppleTV pairing
  -p <pid file>       write PID in file
  -m <n1,n2...>       exclude devices whose model include tokens
  -n <m1,m2,...>      exclude devices whose name includes tokens
  -o <m1,m2,...>      include only listed models; overrides -m and -n (use <NULL> if player don't return a model)
  -d <log>=<level>    set logging level
                      logs: all|main|util|raop
                      level: error|warn|info|debug|sdebug
  -z               daemonize
  -Z               NOT interactive
  -k               immediate exit on SIGQUIT and SIGTERM
  -t               license terms

Build options: LINUX
```
