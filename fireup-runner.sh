#!/usr/bin/env bash

docker run -d \
   -e REPO_URL="https://github.com/csbasic/walkthrough" \
   -e RUNNER_TOKEN="AS7JR5OQVKV2MHCUYAOKCNTIJDPXK" \
   -v /your/local/path:/home/runner \
   --name actions-runner \
   --restart always \
   runner-image
