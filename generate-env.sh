
#!/bin/bash
# Git information
gitPAT="${GITHUB_PAT:-}"

# LLM Information
apiKey="${LLM_API_KEY:-}"
llmModel="${LLM_MODEL:-}"
tavilyKey="${TAVILY_API_KEY:-}"

OS=$(uname -s)
USERNAME=$(whoami)
USER_ID=$(id -u)

# Customize paths
CODE_PATH="$HOME/projects"  # <- adjust as needed
CONTAINER_PATH="/workspace"
RUNTIME_IMAGE="docker.all-hands.dev/all-hands-ai/runtime:0.51-nikolaik"

# Compose SANDBOX_VOLUMES
SANDBOX_VOLUMES="$CODE_PATH:$CONTAINER_PATH"

# Write to .env
cat <<EOF > .env
SANDBOX_RUNTIME_CONTAINER_IMAGE=$RUNTIME_IMAGE
SANDBOX_USER_ID=$USER_ID
SANDBOX_VOLUMES=$SANDBOX_VOLUMES
SANDBOX_DOCKER_RUNTIME_KWARGS="{"mem_limit": "2g", "cpu_count": 2}"
GITHUB_TOKEN=$gitPAT
LLM_MODEL=$llmModel
LLM_API_KEY=$apiKey
LLM_INPUT_COST_PER_TOKEN=0.00000027
LLM_OUTPUT_COST_PER_TOKEN=0.0000011
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

# Create settings.json file
cat <<EOF > settings.json
{"language":"en","agent":"CodeActAgent","max_iterations":150,"security_analyzer":null,"confirmation_mode":false,"llm_model":"${LLM_MODEL}","llm_api_key":"${LLM_API_KEY}","llm_base_url":"","remote_runtime_resource_factor":1,"secrets_store":{"provider_tokens":{}},"enable_default_condenser":true,"enable_sound_notifications":false,"enable_proactive_conversation_starters":false,"user_consents_to_analytics":false,"sandbox_base_container_image":null,"sandbox_runtime_container_image":"${RUNTIME_IMAGE}","mcp_config":{"sse_servers":[],"stdio_servers":[],"shttp_servers":[]},"search_api_key":"${TAVILY_API_KEY}","sandbox_api_key":null,"max_budget_per_task":null,"email":null,"email_verified":null}
EOF

echo "settings.json file created"
