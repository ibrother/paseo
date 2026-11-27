ARG PASEO_VERSION=latest
FROM ghcr.io/getpaseo/paseo:${PASEO_VERSION}

USER root

# 1. System package manager (apt): foundational OS packages & classic utilities
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        python3 \
        sqlite3 \
        tree \
    && rm -rf /var/lib/apt/lists/*

# 2. mise + modern CLI tools (multi-arch: amd64 / arm64, system-wide read-only shims)
# Symlink shims (except `sg`, avoiding conflict with /usr/bin/sg) into /usr/local/bin
# so tools remain available even in login shells that reset PATH.
ENV MISE_DATA_DIR=/usr/local/share/mise \
    MISE_CONFIG_DIR=/etc/mise \
    PATH="$PATH:/usr/local/share/mise/shims"

RUN curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh \
    && MISE_CACHE_DIR=/tmp/mise-cache MISE_YES=1 mise use -g \
        ripgrep@latest \
        fd@latest \
        jq@latest \
        shellcheck@latest \
        gh@latest \
        uv@latest \
        ruff@latest \
        ast-grep@latest \
        yq@latest \
        sd@latest \
        duckdb@latest \
        github:boyter/scc@latest \
        gitleaks@latest \
        rtk@latest \
    && find /usr/local/share/mise/shims -maxdepth 1 -type l ! -name sg -exec ln -sf {} /usr/local/bin/ \; \
    && rm -rf /tmp/mise-cache

# 3. Official install script: Antigravity CLI (not in apt/mise/npm)
RUN curl -fsSL https://antigravity.google/cli/install.sh \
    | bash -s -- --dir /usr/local/bin

# 4. Node package manager (npm): AI coding CLIs
RUN npm install -g @openai/codex @anthropic-ai/claude-code \
    && npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
    && npm cache clean --force
