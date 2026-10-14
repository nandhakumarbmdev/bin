#!/bin/bash

PORT=8080
BASE_DIR="/Users/nandha/workspace/flutter/baseui"
PROJECT_DIR="$BASE_DIR/fleettrack"

if [ "$PWD" = "$BASE_DIR" ]; then
  cd "$PROJECT_DIR" || exit 1
fi

flutter run \
  -d web-server \
  --web-port="$PORT"