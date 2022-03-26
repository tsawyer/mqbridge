FROM alpine:3.15.1

RUN apk update && apk add \
    net-tools \
    openrc \
    libstdc++ 

RUN mkdir -p /opt/P25Gateway/
RUN mkdir -p /opt/qbridge/

# Prevents constant tty errors
RUN sed -i 's/^tty/#tty/' /etc/inittab

COPY app /

# Start services
RUN rc-update add qbridge default
RUN rc-update add p25gateway default
ENTRYPOINT ["/sbin/init"]
