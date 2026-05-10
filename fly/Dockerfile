FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    websockify \
    nginx \
    apache2-utils \
    gettext-base \
    curl \
    ca-certificates \
    chromium \
    fonts-liberation \
    fonts-noto-color-emoji \
    openssl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# noVNC moderno v1.4.0 (el paquete Debian es demasiado antiguo para resize)
RUN curl -sL https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz \
    | tar -xz -C /opt \
    && mv /opt/noVNC-1.4.0 /opt/novnc \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

RUN useradd -m -s /bin/bash claude

COPY start.sh /start.sh
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY claude.html /opt/novnc/claude.html
RUN chmod +x /start.sh \
    && rm -f /etc/nginx/sites-enabled/*

EXPOSE 8080

CMD ["/start.sh"]
