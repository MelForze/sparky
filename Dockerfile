FROM eclipse-temurin:8-jre-jammy AS java8

FROM python:3.7-slim-bullseye AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libev-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip setuptools wheel

RUN python -m pip wheel --wheel-dir /wheels \
    requests==2.31.0 \
    pyspark==2.4.8 \
    lxml==4.9.4 \
    prettytable==3.7.0 \
    gevent==22.10.2 \
    'greenlet<3'

FROM python:3.7-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    SPARKY_HOME=/opt/sparky \
    JAVA_HOME=/opt/java/openjdk

ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    findutils \
    grep \
    iproute2 \
    libev4 \
    libffi7 \
    libxml2 \
    libxslt1.1 \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY --from=java8 /opt/java/openjdk /opt/java/openjdk
COPY --from=builder /wheels /wheels
RUN python -m pip install --no-index --find-links /wheels \
    requests==2.31.0 \
    pyspark==2.4.8 \
    lxml==4.9.4 \
    prettytable==3.7.0 \
    gevent==22.10.2 \
    'greenlet<3' \
 && rm -rf /wheels

WORKDIR ${SPARKY_HOME}

COPY . ${SPARKY_HOME}
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080 8443

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["-h"]
