FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    websockify \
    nginx \
    apache2-utils \
    gettext-base \
    git \
    chromium \
    fonts-liberation \
    fonts-noto-color-emoji \
    openssl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# noVNC moderno desde GitHub (el paquete Debian es demasiado antiguo)
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

RUN useradd -m -s /bin/bash claude

COPY start.sh /start.sh
COPY nginx.conf.template /etc/nginx/nginx.conf.template
RUN chmod +x /start.sh \
    && rm -f /etc/nginx/sites-enabled/*

EXPOSE 8080

CMD ["/start.sh"]
