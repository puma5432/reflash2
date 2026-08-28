#!/usr/bin/env bash
# Builds the RL-instrumented SSF2.swf by replacing four scripts in one FFDec pass:
#   - com.mcleodgaming.ssf2.modapi.ModAPI  (RL bridge + auto-start)
#   - com.mcleodgaming.ssf2.Main           (one-line auto-start hook)
#   - com.mcleodgaming.ssf2.engine.AI      (control override queue)
#   - com.mcleodgaming.ssf2.engine.StageData (silent research pause)
# Then deploys it (and autostart.json) into the macOS launch payload.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
FFDEC="$REPO_ROOT/FFDec.app/Contents/Resources/ffdec.jar"
WORK="$REPO_ROOT/.macos/swf_work"
PAYLOAD="$REPO_ROOT/.macos/payload"

mkdir -p "$WORK"
cp "$REPO_ROOT/build/SSF2.swf" "$WORK/SSF2_patched.swf"

echo "Patching ModAPI + Main + AI + StageData via FFDec ..."
java -Xmx4g -jar "$FFDEC" -air -replace \
  "$WORK/SSF2_patched.swf" "$WORK/SSF2_patched.swf" \
  com.mcleodgaming.ssf2.modapi.ModAPI "$REPO_ROOT/tools/rl/patches/ModAPI_patched.as" \
  com.mcleodgaming.ssf2.Main "$REPO_ROOT/tools/rl/patches/Main_patched.as" \
  com.mcleodgaming.ssf2.engine.AI "$REPO_ROOT/tools/rl/patches/AI_patched.as" \
  com.mcleodgaming.ssf2.engine.StageData "$REPO_ROOT/tools/rl/patches/StageData_patched.as" \
  com.mcleodgaming.ssf2.Config "$REPO_ROOT/tools/rl/patches/Config_patched.as"


cp "$WORK/SSF2_patched.swf" "$PAYLOAD/SSF2.swf"
cp "$REPO_ROOT/tools/rl/config/autostart.json" "$PAYLOAD/autostart.json"
echo "DEPLOYED to $PAYLOAD"
