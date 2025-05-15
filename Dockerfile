FROM ghcr.io/astral-sh/uv:python3.11-bookworm

ARG VERSION=1.2.6
ENV UV_HTTP_TIMEOUT=60 \
    UV_NO_CACHE=true

RUN set -eux; \
    apt-get update && apt-get install -y curl unzip git imagemagick ffmpeg; \
    sed -i '/<policy domain="path" rights="none" pattern="@\*"/d' /etc/ImageMagick-*/policy.xml; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -o main.zip -L https://github.com/harry0703/MoneyPrinterTurbo/archive/refs/tags/v$VERSION.zip; \
    unzip -o main.zip -d /tmp; \
    mv -f /tmp/MoneyPrinterTurbo-$VERSION /app; \
    rm -rf main.zip

WORKDIR /app
RUN uv venv && uv add -r requirements.txt
ADD run.sh /

HEALTHCHECK --interval=2m CMD curl -I localhost:8501 || exit 1
CMD ["/run.sh"]