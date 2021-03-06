FROM ubuntu:18.04

RUN apt update -y

# install webserver service
RUN apt install nginx -y

# install python dependencies
RUN apt install python3.8 -y && \
    apt install python-pkg-resources python3-pkg-resources -y && \
    apt install python3-pip -y && \
    pip3 install RPi.GPIO && \
    pip3 install gpiozero && \
    pip3 install websockets

# install Husarnet client
RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

# some optional modules
RUN apt install vim -y
RUN apt install fonts-emojione -y
RUN apt install iputils-ping -y

# HTTP PORT
EXPOSE 80

# WEBSOCKET PORT
EXPOSE 8001

# Find your JoinCode at app.husarnet.com
ENV JOINCODE ""
ENV HOSTNAME my-hnet-container

# Number of Raspberry Pi pins where button and LED are connected
ENV BUTTON_PIN 23
ENV LED_PIN 16

# copy project files into the image
COPY init-container.sh /opt

COPY frontend_src /var/www/html/

WORKDIR /app
COPY backend_src /app/

# run the container setup script
CMD /opt/init-container.sh