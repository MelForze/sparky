#!/usr/bin/env bash
set -euo pipefail

export SPARK_HOME="${SPARK_HOME:-/opt/spark}"
export SPARK_NO_DAEMONIZE=1
export SPARK_MASTER_HOST="${SPARK_MASTER_HOST:-$(hostname)}"
export SPARK_MASTER_PORT="${SPARK_MASTER_PORT:-7077}"
export SPARK_MASTER_WEBUI_PORT="${SPARK_MASTER_WEBUI_PORT:-8080}"
export PYSPARK_PYTHON="${PYSPARK_PYTHON:-python3}"

mkdir -p "${SPARK_HOME}/logs" "${SPARK_HOME}/work"

exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.master.Master \
  --host "${SPARK_MASTER_HOST}" \
  --port "${SPARK_MASTER_PORT}" \
  --webui-port "${SPARK_MASTER_WEBUI_PORT}"
