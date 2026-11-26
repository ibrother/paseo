ARG PASEO_VERSION=latest
FROM ghcr.io/getpaseo/paseo:${PASEO_VERSION}

USER root

RUN curl -fsSL https://claude.ai/install.sh | bash \
    && curl -fsSL https://chatgpt.com/codex/install.sh | sh \
    && curl -fsSL https://pi.dev/install.sh | sh
