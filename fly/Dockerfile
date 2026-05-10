FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    websockify \
    novnc \
    nginx \
    apache2-utils \
    chromium \
    fonts-liberation \
    fonts-noto-color-emoji \
    openssl \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash claude

COPY start.sh /start.sh
COPY nginx.conf /etc/nginx/sites-available/default
RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default \
    && chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
