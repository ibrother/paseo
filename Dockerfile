ARG PASEO_VERSION=latest
FROM ghcr.io/getpaseo/paseo:${PASEO_VERSION}

USER root

# System packages: gh (via package manager), plus curl/ca-certificates for the rtk installer
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gh \
    && rm -rf /var/lib/apt/lists/*

# rtk: install system-wide into /usr/local/bin instead of $HOME/.local/bin
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh \
    | RTK_INSTALL_DIR=/usr/local/bin sh

# Antigravity CLI (agy): install system-wide into /usr/local/bin
RUN curl -fsSL https://antigravity.google/cli/install.sh \
    | bash -s -- --dir /usr/local/bin

RUN npm install -g @openai/codex @anthropic-ai/claude-code \
    && npm install -g --ignore-scripts @earendil-works/pi-coding-agent
