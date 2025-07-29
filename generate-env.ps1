# User and path setup
$uhome = $env:USERPROFILE
$username = $env:USERNAME

# Git information
$gitPAT = $env:GITHUB_PAT

# LLM Information
$apiKey = $env:OLLAMA_API_KEY
$llmModel = $env:OLLAMA_LLM_MODEL

# Convert Windows path to Docker-style path
$drive = $uhome.Substring(0,1).ToLower()
$path = $uhome.Substring(2) -replace '\\','/'
$dockerHome = "/$drive$path"

# Compose values
$runtimeImage = "docker.all-hands.dev/all-hands-ai/runtime:0.50-nikolaik"
$codePath = "$dockerHome/projects/openhands"  # <- adjust as needed
$containerPath = "/workspace"
$sandboxVolumes = "${codePath}:${containerPath}:rw"

# Windows usually runs as UID 1000 in containers
$sandboxUserId = 1000

# Output .env
@"
GITHUB_TOKEN=$gitPAT
LLM_API_KEY=$apiKey
LLM_MODEL=$llmModel
SANDBOX_RUNTIME_CONTAINER_IMAGE=$runtimeImage
SANDBOX_USER_ID=$sandboxUserId
SANDBOX_VOLUMES=$sandboxVolumes
DOCKER_SOCKET=//./pipe/docker_engine
OPENHANDS_PATH=$dockerHome/.openhands
"@ | Set-Content ".env" -Encoding UTF8

Write-Host ".env file created for Windows user $username"
