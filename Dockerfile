FROM homebridge/homebridge:2023-11-28

RUN hb-service update-node 20.10.0 --allow-root && \
    npm uninstall -g homebridge-config-ui-x && \
    npm install -g --unsafe-perm homebridge-config-ui-x@4.54.2 && \
    npm install homebridge-lg-thinq@v1.6.3 && \
    npm install github:ivan-garcia-parras/homebridge-eufy-security#feature/v2.3.1 && \
    npm install homebridge-webos-tv@v2.4.3 && \
    npm install homebridge-z2m@v1.10.0