# Dockerfile

# =============================================================================
# Install Chromium Browser
# =============================================================================
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Other sections of the Dockerfile remain unchanged...