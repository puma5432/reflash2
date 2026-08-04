#!/usr/bin/env bash
# Runs the macOS launch payload with adl.
# Usage: AIR_SDK_HOME=~/Developer/AIRSDK_51.3.3 bash tools/macos/run_macos.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PAYLOAD="$REPO_ROOT/.macos/payload"

: "${AIR_SDK_HOME:?Set AIR_SDK_HOME to your Harman AIR SDK path}"
[[ -f "$PAYLOAD/META-INF/AIR/application.xml" ]] || {
  echo "Payload missing. Run: bash tools/macos/prepare_macos_launch_payload.sh"
  exit 1
}

exec "$AIR_SDK_HOME/bin/adl" "$PAYLOAD/META-INF/AIR/application.xml" "$PAYLOAD" "$@"
