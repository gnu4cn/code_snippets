#! /bin/bash
# Before this command, a docker image already thru `docker build -t electron .` command with the Dockerfile inside the current folder
# before you can use GUI, `xhost + local:docker` should be executed at host
# docker run -it -v /tmp:/tmp -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY  --mount type=bind,source="$(pwd)",target=/app electron

docker run -it -v /tmp:/tmp -v /home/peng:/peng -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY unisko/ubuntu:20.04
