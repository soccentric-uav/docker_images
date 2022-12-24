#!/bin/bash

# Build the docker image
docker build -t soccentirc-xilinx-docker/kas:0.1 .

# Run the docker image
#docker run -it --rm --name soccentric-xilinx-docker soccentirc-xilinx-docker:0.1
