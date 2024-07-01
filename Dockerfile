FROM homebridge/homebridge:2024-05-02

RUN hb-service update-node 21.6.1 --allow-root

RUN apt-get update && apt-get install rclone

COPY startup.sh /defaults/startup.sh