FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    chromium \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libnspr4 \
    libnss3 \
    xdg-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
