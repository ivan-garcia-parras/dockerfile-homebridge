FROM homebridge/homebridge:2024-01-08

RUN hb-service update-node 20.11.1 --allow-root && \
    npm install homebridge-lg-thinq@v1.8.1 && \
    npm install github:ivan-garcia-parras/homebridge-eufy-legacy#v4.1.0 && \
    npm install homebridge-webos-tv@v2.4.3 && \
    npm install homebridge-z2m@v1.10.0