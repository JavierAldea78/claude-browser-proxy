FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       chromium \
       fonts-liberation \
       fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*
