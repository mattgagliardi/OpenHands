#!/bin/bash

OS=$(uname -s)
USERNAME=$(whoami)
USER_ID=$(id -u)

# Customize paths
CODE_PATH="$HOME/projects/openhands"  # <- adjust as needed
CONTAINER_PATH="/workspace"
RUNTIME_IMAGE="docker.all-hands.dev/all-hands-ai/runtime:0.50-nikolaik"

# Compose SANDBOX_VOLUMES
SANDBOX_VOLUMES="$CODE_PATH:$CONTAINER_PATH:rw"

# Write to .env
cat <<EOF > .env
SANDBOX_RUNTIME_CONTAINER_IMAGE=$RUNTIME_IMAGE
SANDBOX_USER_ID=$USER_ID
SANDBOX_VOLUMES=$SANDBOX_VOLUMES
EOF

if [[ "$OS" == "Darwin" ]]; then
  echo "DOCKER_SOCKET=/var/run/docker.sock" >> .env
  echo "OPENHANDS_PATH=/Users/$USERNAME/.openhands" >> .env
elif [[ "$OS" == "Linux" ]]; then
  echo "DOCKER_SOCKET=/var/run/docker.sock" >> .env
  echo "OPENHANDS_PATH=/home/$USERNAME/.openhands" >> .env
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo ".env file created for $OS"
