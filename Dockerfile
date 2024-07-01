FROM homebridge/homebridge:2024-05-02

RUN hb-service update-node 21.6.1 --allow-root

ARG RCLONE_VERSION=1.67.0
RUN wget https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.deb && \
    dpkg -i rclone-v${RCLONE_VERSION}-linux-amd64.deb && \
    rm rclone-v${RCLONE_VERSION}-linux-amd64.deb

COPY startup.sh /defaults/startup.sh