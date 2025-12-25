ARG BASE_IMAGE
FROM ${BASE_IMAGE:-debian:stable-slim} AS base_image

ARG SPOTCONNECT_VERSION=0.20.1

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

FROM scratch
COPY --from=base_image / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/spotconnect-docker"

RUN mkdir -p /app/bin

COPY app/bin/run.sh /app/bin
RUN chmod 755 /app/bin/run.sh

ENV PUID=""
ENV PGID=""
ENV PREFER_STATIC=""
ENV VORBIS_BITRATE=""
ENV STORE_CRED_XML=""
ENV OUTPUT_CODEC=""
ENV UPNP_HTTP_CONTENT_LENGTH_MODE=""
ENV UPNP_HTTP_CACHING_MODE=""
ENV SPOTCONNECT_MODE=""
ENV CONFIG_FILE_PREFIX=""
ENV APPLETV_PAIRING_MODE=""
ENV LOG_LEVEL_ALL=""
ENV LOG_LEVEL_MAIN=""
ENV LOG_LEVEL_UTIL=""
ENV LOG_LEVEL_UPNP=""
ENV LOG_LEVEL_RAOP=""

ENV AUTO_NETWORK_URL=""
ENV ENABLE_AUTO_NETWORK=""
ENV NETWORK_SELECT=""
ENV NETWORK_USE_IP=""

VOLUME /config

ENTRYPOINT ["/app/bin/run.sh"]
