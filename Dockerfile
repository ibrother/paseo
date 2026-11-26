ARG PASEO_VERSION=latest
FROM ghcr.io/getpaseo/paseo:${PASEO_VERSION}

USER root

RUN npm install -g @openai/codex @anthropic-ai/claude-code \
    && npm install -g --ignore-scripts @earendil-works/pi-coding-agent
