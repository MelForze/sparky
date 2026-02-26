FROM eclipse-temurin:8-jre-jammy AS java8

FROM python:3.7-slim-bullseye

ARG SPARK_VERSION=2.4.8
ARG HADOOP_VERSION=2.7
ARG SPARK_DIST=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/java/openjdk \
    SPARK_HOME=/opt/spark \
    PYTHONUNBUFFERED=1

ENV PATH="${JAVA_HOME}/bin:${SPARK_HOME}/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    tini \
 && rm -rf /var/lib/apt/lists/*

COPY --from=java8 /opt/java/openjdk /opt/java/openjdk

RUN curl -fsSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_DIST}.tgz" -o /tmp/spark.tgz \
 && tar -xzf /tmp/spark.tgz -C /opt \
 && mv "/opt/${SPARK_DIST}" "${SPARK_HOME}" \
 && rm -f /tmp/spark.tgz

COPY docker/spark24-lab/master.sh /usr/local/bin/spark-master-lab
COPY docker/spark24-lab/worker.sh /usr/local/bin/spark-worker-lab

RUN chmod +x /usr/local/bin/spark-master-lab /usr/local/bin/spark-worker-lab \
 && mkdir -p /opt/spark/work /opt/spark/logs

WORKDIR /opt/spark

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
