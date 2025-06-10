#!/bin/bash

cd /home/github/actions-runner

if [ ! -f .runner ]; then
  echo "Configuring the runner..."
  export PATH=$PATH:/usr/local/bin
  if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" ]]; then
    echo "❌ Environment variables REPO_URL and RUNNER_TOKEN must be set"
    exit 1
  fi

  ./config.sh \
    --unattended \
    --url "$REPO_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$(hostname)" \
    --work _work \
    --labels docker,linux \
    --replace
fi

exec ./run.sh
