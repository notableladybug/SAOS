#!/usr/bin/env bash
# Update Howdy config and log change

set -e

CONFIG_FILE="/Users/ludvighagedorn-poulsen/Documents/SAOS/OS/airootfs/etc/howdy/config.ini"

python3 - <<'PY'
from pathlib import Path
path = Path(r"/Users/ludvighagedorn-poulsen/Documents/SAOS/OS/airootfs/etc/howdy/config.ini")
text = path.read_text()
if "[core]" in text:
    newtext = text
    newtext = newtext.replace("timeout = 8", "timeout = 5")
    newtext = newtext.replace("suppress_unknown_user_message = false", "suppress_unknown_user_message = false\nno_confirmation = false")
    path.write_text(newtext)
    print("Updated Howdy config")
else:
    print("Howdy config not found or unexpected format")
PY
