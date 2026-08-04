#!/usr/bin/env bash
# Builds macOS-compatible "stub" ANEs for the three Windows-only ANEs shipped
# with ReFlash2 (nativejoystick, DiscordANE, rumble).
#
# The originals only declare Windows-x86 / Windows-x86-64 platforms, so AIR
# refuses to load the app on macOS ("Requested extension X is not supported for
# MacOS-x86-64"). We repackage each ANE with a `default` platform that has NO
# native library: the ActionScript classes from library.swf still resolve, but
# ExtensionContext.createExtensionContext() returns null at runtime, so any
# native calls fail safely instead of blocking app launch.
#
# We don't need joystick/discord/rumble functionality for RL research.
#
# Usage: AIR_SDK_HOME=~/Developer/AIRSDK_51.3.3 bash tools/macos/build_stub_anes.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
EXT_SRC="$REPO_ROOT/build/META-INF/AIR/extensions"
OUT_DIR="$REPO_ROOT/tools/macos/stub_anes"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

: "${AIR_SDK_HOME:?Set AIR_SDK_HOME to your Harman AIR SDK path}"
ADT="$AIR_SDK_HOME/bin/adt"
[[ -x "$ADT" ]] || { echo "adt not found at $ADT"; exit 1; }

mkdir -p "$OUT_DIR"

for ext_dir in "$EXT_SRC"/*/; do
  ext_name="$(basename "$ext_dir")"
  ext_xml="$ext_dir/META-INF/ANE/extension.xml"
  [[ -f "$ext_xml" ]] || { echo "SKIP $ext_name (no extension.xml)"; continue; }

  echo "=== $ext_name ==="
  stage="$WORK_DIR/$ext_name"
  mkdir -p "$stage"

  # New extension.xml: REPLACE all platforms with a single native-less
  # `default` platform (we don't ship the Windows DLLs in the stub ANE).
  python3 - "$ext_xml" "$stage/extension.xml" <<'PYEOF'
import sys, re
src, dst = sys.argv[1], sys.argv[2]
xml = open(src).read()
default_platforms = (
    '\t<platforms>\n'
    '\t\t<platform name="default">\n'
    '\t\t\t<applicationDeployment/>\n'
    '\t\t</platform>\n'
    '\t</platforms>'
)
xml, n = re.subn(r'<platforms>.*?</platforms>', default_platforms, xml, count=1, flags=re.S)
assert n == 1, "no <platforms> block found"
open(dst, 'w').write(xml)
print("  wrote staged extension.xml (default platform only)")
PYEOF

  # Build SWC (zip of catalog.xml + library.swf at archive root).
  swc="$stage/$ext_name.swc"
  (cd "$ext_dir" && zip -q -X "$swc" catalog.xml library.swf)
  echo "  built SWC: $(basename "$swc")"

  # Platform folder for `default`: AS classes only, no native library.
  # adt requires <platformdir>/library.swf to exist for each declared platform.
  plat_dir="$stage/default"
  mkdir -p "$plat_dir"
  cp "$ext_dir/library.swf" "$plat_dir/library.swf"

  # Package the ANE.
  out_ane="$OUT_DIR/$ext_name.ane"
  rm -f "$out_ane"
  "$ADT" -package -target ane "$out_ane" "$stage/extension.xml" \
    -swc "$swc" -platform default -C "$plat_dir" library.swf
  echo "  packaged: $out_ane"
done

echo
echo "Stub ANEs written to: $OUT_DIR"
ls -la "$OUT_DIR"
