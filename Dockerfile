FROM ubuntu:22.04

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
    pip3 install tzupdate && \
    chmod 4755 /bin/ping && \
    apt-get install -y avahi-daemon avahi-utils mdns-scan rclone inotify-tools && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    rm -rf /etc/cron.daily/apt-compat /etc/cron.daily/dpkg /etc/cron.daily/passwd /etc/cron.daily/exim4-base

RUN curl --proto "=https" --tlsv1.2 -sSf -L https://github.com/homebridge/ffmpeg-for-homebridge/releases/download/v2.1.1/ffmpeg-alpine-x86_64.tar.gz -o ffmpeg-alpine-x86_64.tar.gz && \
    tar -xzf ffmpeg-alpine-x86_64.tar.gz -C / --no-same-owner

ARG NODEJS_VERSION="v22.12.0"
RUN mkdir -p /opt/nodejs && \
    curl --proto "=https" --tlsv1.2 -sSf -L https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.gz -o node-${NODEJS_VERSION}-linux-x64.tar.gz && \
    tar -xzf node-${NODEJS_VERSION}-linux-x64.tar.gz -C /opt/nodejs/ && \
    mv /opt/nodejs/node-${NODEJS_VERSION}-linux-x64 /opt/nodejs/current

ENV PATH="$PATH:/opt/nodejs/current/bin/"

RUN mkdir -p /var/lib/homebridge && \
    npm install -g homebridge@1.8.5 && \
    npm install -g --unsafe-perm homebridge-config-ui-x@4.67.0 && \
    npm install -g homebridge-lg-thinq@v1.8.10 && \
    npm install -g homebridge-webos-tv@v2.4.6 && \
    npm install -g homebridge-z2m@v1.11.0-beta.6 && \
    npm install -g @vectronic/homebridge-script-switch@0.1.1

RUN git clone https://github.com/ivan-garcia-parras/homebridge-eufy-legacy.git /opt/homebridge/lib/node_modules/homebridge-eufy-legacy && \
    cd /opt/homebridge/lib/node_modules/homebridge-eufy-legacy && \
    npm install

RUN git clone https://github.com/ivan-garcia-parras/homebridge-daikin-onecta.git /opt/homebridge/lib/node_modules/homebridge-daikin-onecta && \
    cd /opt/homebridge/lib/node_modules/homebridge-daikin-onecta && \
    npm install