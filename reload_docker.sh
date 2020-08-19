#!/bin/bash

sudo systemctl stop docker

sudo cp daemon.json /etc/docker/

sudo rsync -aqxP /var/lib/docker/ /home/zorbax/bin/Docker

sudo systemctl daemon-reload && sudo systemctl start docker

docker info
