FROM ghcr.io/prefix-dev/pixi:0.78.0 AS pixi-src

FROM node:22-bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        fd-find \
        git \
        ripgrep \
    && rm -rf /var/lib/apt/lists/* \
    # Symlink `fdfind` (default on Debian) into `fd`
    && ln -s /usr/bin/fdfind /usr/local/bin/fd

# Copy Pixi binary from official image
COPY --from=pixi-src /usr/local/bin/pixi /usr/local/bin/pixi

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Create an unprivileged user that Claude will run under
RUN useradd -m -s /bin/bash dev
USER dev

WORKDIR /home/dev/workspace

CMD ["bash"]
