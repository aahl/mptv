FROM ghcr.io/astral-sh/uv:python3.11-bookworm
ARG VERSION=1.2.6
ENV UV_HTTP_TIMEOUT=120 \
    PYTHONPATH=/app
RUN set -eux; \
    apt-get update && apt-get install -y curl unzip git imagemagick ffmpeg; \
    sed -i '/<policy domain="path" rights="none" pattern="@\*"/d' /etc/ImageMagick-*/policy.xml; \
    rm -rf /var/lib/apt/lists/*
RUN set -eux; \
    curl -o main.zip -L https://github.com/harry0703/MoneyPrinterTurbo/archive/refs/tags/v$VERSION.zip; \
    unzip -o main.zip -d /tmp; \
    mv -f /tmp/MoneyPrinterTurbo-main $PYTHONPATH; \
    rm -rf main.zip
WORKDIR /app
RUN uv venv && uv pip install --no-cache-dir -r requirements.txt
ADD run.sh /
CMD ["/run.sh"]