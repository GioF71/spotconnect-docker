ARG BASE_IMAGE
FROM ${BASE_IMAGE:-debian:stable-slim} AS BASE

ARG SPOTCONNECT_VERSION=0.9.2

RUN mkdir /app/bin -p
COPY app/bin/install-pkg.sh /app/bin/
RUN chmod u+x /app/bin/install-pkg.sh
RUN /app/bin/install-pkg.sh
RUN rm /app/bin/install-pkg.sh

COPY app/bin/download.sh /app/bin/
RUN chmod u+x /app/bin/download.sh
RUN /app/bin/download.sh
RUN rm /app/bin/download.sh

COPY app/bin/install.sh /app/bin/
RUN chmod u+x /app/bin/install.sh
RUN /app/bin/install.sh
RUN rm /app/bin/install.sh

COPY app/bin/cleanup.sh /app/bin/
RUN chmod u+x /app/bin/cleanup.sh
RUN /app/bin/cleanup.sh
RUN rm /app/bin/cleanup.sh

COPY app/bin/run.sh /app/bin
RUN chmod 755 /app/bin/run.sh

FROM scratch
COPY --from=BASE / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/spotconnect-docker"

ENV PUID ""
ENV PGID ""
ENV PREFER_STATIC ""
ENV VORBIS_BITRATE ""
ENV SPOTCONNECT_MODE ""
ENV CONFIG_FILE_PREFIX ""
ENV APPLETV_PAIRING_MODE ""
ENV LOG_LEVEL_ALL ""
ENV LOG_LEVEL_MAIN ""
ENV LOG_LEVEL_UTIL ""
ENV LOG_LEVEL_UPNP ""
ENV LOG_LEVEL_RAOP ""

VOLUME /config

ENTRYPOINT ["/app/bin/run.sh"]
