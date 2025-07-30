#!/bin/bash
# Git information
$gitPAT = $env:GITHUB_PAT

# LLM Information
$apiKey = $env:OLLAMA_API_KEY
$llmModel = $env:OLLAMA_LLM_MODEL

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
GITHUB_TOKEN=$gitPAT
LLM_MODEL=$llmModel
LLM_API_KEY=$apiKey
EOF

if [[ "$OS" == "Darwin" ]]; then
  echo "DOCKER_SOCKET=/var/run/docker.sock" >> .env
  echo "OPENHANDS_PATH=/Users/$USERNAME/.openhands" >> .env
elif [[ "$OS" == "Linux" ]]; then
  # Check if running in WSL
  if grep -q "microsoft" /proc/version || grep -q "Microsoft" /proc/sys/kernel/osrelease 2>/dev/null; then
    # WSL2 environment
    echo "DOCKER_SOCKET=/var/run/docker.sock" >> .env
    echo "OPENHANDS_PATH=/home/$USERNAME/.openhands" >> .env
    echo "Note: Running in WSL2 environment"
  else
    # Standard Linux environment
    echo "DOCKER_SOCKET=/var/run/docker.sock" >> .env
    echo "OPENHANDS_PATH=/home/$USERNAME/.openhands" >> .env
  fi
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo ".env file created for $OS"
