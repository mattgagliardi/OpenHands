
# OpenHands Docker Setup

This repository contains a Docker Compose template and an associated `.env` file creator for starting an OpenHands instance. The OpenHands project is an open-source initiative aimed at creating a collaborative platform for AI development and research.

FWIW you can get this to work with Ollama pretty easily, **but** Ollama has a tendency to bomb out...it's kind of an issue of finding the "right" model that is ready for agentic actions and is good at calling tools. They exist **but** using something like Deepseek...especially during the daily discount period...is really a much better alternative. You'll really save yourself a lot of time/effort for not much money.

## Table of Contents

- [Introduction](#introduction)
- [Setup Instructions](#setup-instructions)

## Introduction

This repository provides the necessary Docker Compose configuration to easily set up and run an OpenHands instance. OpenHands is designed to facilitate the development and sharing of AI models, datasets, and tools.

## Setup Instructions

To get started with OpenHands using Docker, follow these steps:

1. Clone this repository:

   ```bash
   git clone https://github.com/mattgagliardi/OpenHands.git
   ```

2. Navigate to the project directory:

   ```bash
   cd OpenHands
   ```

3. Ensure you have Docker and Docker Compose installed on your system.

4. Set up the necessary environment variables for the script:

   ```bash
   export GITHUB_PAT=-github-PAT-token-
   export LLM_API_KEY=-api-key-for-llm-of-choice-
   export LLM_MODEL=-llm-model-name-
   export TAVILY_API_KEY=-tavily-search-api-token-
   ```

5. Create the `.env` file Docker Compose will use by running the `generate-env.sh` script. Review the script, you probably need to add some environment variables to make the script populate fully.

   ```bash
   chmod +x generate-env.sh
   ./generate-env.sh
   ```

6. Start the OpenHands instance using Docker Compose:

   ```bash
   docker-compose up -d
   ```

7. Follow any additional instructions in the `.env` files or documentation to configure your instance as needed. You may need to enter your desired model provider, API keys, etc. in the UI that's exposed at `http://localhost:3000`.
