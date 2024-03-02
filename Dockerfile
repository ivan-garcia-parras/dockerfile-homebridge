FROM homebridge/homebridge:2024-01-08

RUN hb-service update-node 20.11.0 --allow-root

COPY startup.sh /defaults/startup.sh