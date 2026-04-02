FROM ubuntu:24.04

ENV USER=root
ENV HOMEBRIDGE_APT_PACKAGE=1
ENV UIX_CUSTOM_PLUGIN_PATH="/opt/homebridge/lib/node_modules"
ENV PATH="/opt/homebridge/bin:$PATH"
ENV HOME="/home/homebridge"
ENV npm_config_prefix=/opt/homebridge
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \
    ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    apt-get update && \
    apt-get install -y curl wget tzdata locales psmisc procps iputils-ping logrotate libatomic1 apt-transport-https apt-utils jq openssl sudo nano net-tools && \
    locale-gen en_US.UTF-8 && \
    ln -snf /usr/share/zoneinfo/Etc/GMT /etc/localtime && echo Etc/GMT > /etc/timezone && \
    apt-get install -y python3 python3-pip python3-setuptools git make g++ libnss-mdns avahi-discover libavahi-compat-libdnssd-dev python3-venv python3-dev && \
    rm /usr/lib/python3.*/EXTERNALLY-MANAGED && \
    pip3 install tzupdate && \
    chmod 4755 /bin/ping && \
    apt-get install -y avahi-daemon avahi-utils mdns-scan rclone inotify-tools && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    rm -rf /etc/cron.daily/apt-compat /etc/cron.daily/dpkg /etc/cron.daily/passwd /etc/cron.daily/exim4-base

ARG FFMPEG_FOR_HOMEBRIDGE_VERSION="v2.2.1"
RUN curl --proto "=https" --tlsv1.2 -sSf -L https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/${FFMPEG_FOR_HOMEBRIDGE_VERSION}/ffmpeg-alpine-x86_64.tar.gz -o ffmpeg-alpine-x86_64.tar.gz && \
    tar -xzf ffmpeg-alpine-x86_64.tar.gz -C / --no-same-owner

ARG NODEJS_VERSION="v24.14.0"
RUN mkdir -p /opt/nodejs && \
    curl --proto "=https" --tlsv1.2 -sSf -L https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.gz -o node-${NODEJS_VERSION}-linux-x64.tar.gz && \
    tar -xzf node-${NODEJS_VERSION}-linux-x64.tar.gz -C /opt/nodejs/ && \
    mv /opt/nodejs/node-${NODEJS_VERSION}-linux-x64 /opt/nodejs/current

ENV PATH="$PATH:/opt/nodejs/current/bin/"

RUN mkdir -p /var/lib/homebridge && \
    npm install -g homebridge@1.11.2 && \
    npm install -g homebridge-config-ui-x@5.19.0 && \
    npm install -g homebridge-lg-thinq@v1.8.11 && \
    npm install -g homebridge-webos-tv@v2.4.8 && \
    npm install -g homebridge-z2m@v1.11.0-beta.10 && \
    npm install -g @vectronic/homebridge-script-switch@0.2.0 && \
    npm install -g @mp-consulting/homebridge-daikin-cloud@1.3.18 && \
    npm install -g @homebridge-plugins/homebridge-eufy-security@4.6.1