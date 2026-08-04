#!/usr/bin/env bash
# Prepares a macOS launch payload from build/ by replacing the three
# Windows-only ANEs with unpacked stub versions (default platform, no native
# library). The original build/ directory is left untouched.
#
# Output: .macos/payload/  (gitignored)
# Launch: AIR_SDK_HOME=... bash tools/macos/run_macos.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PAYLOAD="$REPO_ROOT/.macos/payload"

echo "Copying build/ -> $PAYLOAD ..."
rm -rf "$PAYLOAD"
mkdir -p "$REPO_ROOT/.macos"
# Exclude Windows-only binaries that are useless on macOS (saves ~200MB).
rsync -a \
  --exclude 'Super Smash Flash 2 Beta.exe' \
  --exclude 'Adobe AIR/' \
  --exclude 'install/' \
  --exclude 'discord_game_sdk.dll' \
  "$REPO_ROOT/build/" "$PAYLOAD/"

EXT_DIR="$PAYLOAD/META-INF/AIR/extensions"

for ext_path in "$EXT_DIR"/*/; do
  ext_name="$(basename "$ext_path")"
  echo "Stubbing ANE: $ext_name"

  # 1) Rewrite extension.xml to declare only the native-less default platform.
  python3 - "$ext_path/META-INF/ANE/extension.xml" <<'PYEOF'
import sys, re
path = sys.argv[1]
xml = open(path).read()
default_platforms = (
    '\t<platforms>\n'
    '\t\t<platform name="default">\n'
    '\t\t\t<applicationDeployment/>\n'
    '\t\t</platform>\n'
    '\t</platforms>'
)
xml, n = re.subn(r'<platforms>.*?</platforms>', default_platforms, xml, count=1, flags=re.S)
assert n == 1, f"no <platforms> block in {path}"
open(path, 'w').write(xml)
PYEOF

  # 2) Provide the default platform library (AS classes only).
  mkdir -p "$ext_path/META-INF/ANE/default"
  cp "$ext_path/library.swf" "$ext_path/META-INF/ANE/default/library.swf"

  # 3) Drop Windows-only platform folders (DLLs).
  rm -rf "$ext_path/META-INF/ANE/Windows-x86" "$ext_path/META-INF/ANE/Windows-x86-64"
done

echo
echo "Payload ready at: $PAYLOAD"
echo "Launch with: AIR_SDK_HOME=<sdk> bash tools/macos/run_macos.sh"
