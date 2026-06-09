#!/usr/bin/env sh
# Activa yessir: fusiona el hook PreToolUse(Bash → allow) en ~/.claude/settings.json
# Idempotente. Uso: sh yessir-enable.sh
set -e
DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
ALLOW="$DIR/yessir-allow.sh"
chmod +x "$ALLOW" 2>/dev/null || true
SETTINGS="${CLAUDE_HOME:-$HOME/.claude}/settings.json"

python3 - "$ALLOW" "$SETTINGS" <<'PY'
import json, os, sys
allow, settings = sys.argv[1], sys.argv[2]
os.makedirs(os.path.dirname(settings), exist_ok=True)
data = {}
if os.path.exists(settings):
    try:
        with open(settings) as f:
            data = json.load(f)
    except Exception:
        data = {}
hooks = data.setdefault("hooks", {})
pre = hooks.setdefault("PreToolUse", [])

def is_yessir(entry):
    return any("yessir-allow.sh" in h.get("command", "") for h in entry.get("hooks", []))

pre = [e for e in pre if not is_yessir(e)]          # quita versiones previas
pre.append({"matcher": "Bash",
            "hooks": [{"type": "command", "command": allow}]})
hooks["PreToolUse"] = pre
with open(settings, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print("yessir ACTIVADO en", settings)
PY
echo "Reinicia Claude Code si los hooks no se recargan en caliente."
