#!/usr/bin/env bash

docker run -d \
   -e REPO_URL="https://github.com/csbasic/walkthrough" \
   -e RUNNER_TOKEN="AS7JR5JUNJI2YY2YXQUH72LIJBU72" \
   -v /your/local/path:/home/runner \
   --name actions-runner \
   --restart always \
   runner-image
