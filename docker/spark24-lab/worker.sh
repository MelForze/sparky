#!/usr/bin/env bash
set -euo pipefail

export SPARK_HOME="${SPARK_HOME:-/opt/spark}"
export SPARK_NO_DAEMONIZE=1
export SPARK_MASTER="${SPARK_MASTER:-spark://spark-master:7077}"
export SPARK_WORKER_WEBUI_PORT="${SPARK_WORKER_WEBUI_PORT:-8081}"
export PYSPARK_PYTHON="${PYSPARK_PYTHON:-python3}"

mkdir -p "${SPARK_HOME}/logs" "${SPARK_HOME}/work"

args=(
  "${SPARK_MASTER}"
  "--webui-port" "${SPARK_WORKER_WEBUI_PORT}"
)

if [[ -n "${SPARK_WORKER_CORES:-}" ]]; then
  args+=("--cores" "${SPARK_WORKER_CORES}")
fi

if [[ -n "${SPARK_WORKER_MEMORY:-}" ]]; then
  args+=("--memory" "${SPARK_WORKER_MEMORY}")
fi

exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.worker.Worker "${args[@]}"
