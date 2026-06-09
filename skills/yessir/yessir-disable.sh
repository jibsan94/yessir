#!/usr/bin/env sh
# Desactiva yessir: elimina el hook PreToolUse(Bash) de la skill de settings.json
set -e
SETTINGS="${CLAUDE_HOME:-$HOME/.claude}/settings.json"
[ -f "$SETTINGS" ] || { echo "No hay settings.json; nada que desactivar."; exit 0; }

python3 - "$SETTINGS" <<'PY'
import json, sys
settings = sys.argv[1]
with open(settings) as f:
    data = json.load(f)
pre = data.get("hooks", {}).get("PreToolUse", [])

def is_yessir(entry):
    return any("yessir-allow.sh" in h.get("command", "") for h in entry.get("hooks", []))

new = [e for e in pre if not is_yessir(e)]
if "hooks" in data:
    if new:
        data["hooks"]["PreToolUse"] = new
    else:
        data["hooks"].pop("PreToolUse", None)
        if not data["hooks"]:
            data.pop("hooks", None)
with open(settings, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print("yessir DESACTIVADO en", settings)
PY
