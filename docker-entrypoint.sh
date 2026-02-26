#!/usr/bin/env bash
set -euo pipefail

cd "${SPARKY_HOME:-/opt/sparky}"

if [[ $# -eq 0 ]]; then
  exec python3 sparky.py -h
fi

case "$1" in
  sparky|sparky.py)
    shift
    exec python3 sparky.py "$@"
    ;;
  fireSparky|fireSparky.py|firesparky|brute)
    shift
    exec python3 fireSparky.py "$@"
    ;;
  python|python3|bash|sh|/bin/bash|/bin/sh)
    exec "$@"
    ;;
  *)
    exec python3 sparky.py "$@"
    ;;
esac
