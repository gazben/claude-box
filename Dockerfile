FROM apicore/php-server:8.5-dev

ARG UID=1000
ARG GID=1000
# 24 is the newest LTS line today; Node 26 becomes LTS on 2026-10-28
ARG NODE_MAJOR=24
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg git ripgrep less procps \
 # Node.js from NodeSource (Debian's own trixie package is Node 20)
 && install -d -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends nodejs \
 # Claude Code
 && npm install -g @anthropic-ai/claude-code \
 # Non-root user matching your host UID/GID
 && groupadd -g ${GID} node \
 && useradd -m -u ${UID} -g ${GID} -s /bin/bash node \
 && mkdir -p /workspace /home/node/.claude \
 && chown -R node:node /workspace /home/node \
 && rm -rf /var/lib/apt/lists/*

USER node

ENV CLAUDE_CONFIG_DIR=/home/node/.claude
ENV DISABLE_AUTOUPDATER=1

WORKDIR /workspace
