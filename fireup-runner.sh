#!/usr/bin/env bash

docker run -d \
   -e REPO_URL="https://github.com/csbasic/walkthrough" \
   -e RUNNER_TOKEN="AS7JR5IN4HM53FFGSPRST4DIIQVDK" \
   -v /your/local/path:/home/runner \
   --name github-runner \
   --restart always \
   runner
