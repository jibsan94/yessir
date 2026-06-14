#!/usr/bin/env python3
"""Hook PreToolUse de 'yessir'. Decide el permiso según la herramienta:
  - Bash                               -> SIEMPRE auto-aprobado.
  - Edit/Write/MultiEdit/NotebookEdit  -> auto-aprobado SOLO si la skill 'napkin'
    está instalada (~/.claude/skills/napkin). Así yessir se complementa con napkin.
El evento llega como JSON por stdin (incluye tool_name). Si no procede aprobar,
no imprime nada -> sin decisión -> el permiso sigue su flujo normal.
"""
import json
import os
import sys

try:
    data = json.load(sys.stdin)
except Exception:
    data = {}

tool = data.get("tool_name", "")
home = os.environ.get("CLAUDE_HOME") or os.path.join(os.environ.get("HOME", ""), ".claude")
napkin = os.path.isdir(os.path.join(home, "skills", "napkin"))
edit_tools = {"Edit", "Write", "MultiEdit", "NotebookEdit"}

allow = (tool == "Bash") or (tool in edit_tools and napkin)
if allow:
    reason = "yessir: auto-aprobado" if tool == "Bash" else "yessir+napkin: edición auto-aprobada"
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "allow",
        "permissionDecisionReason": reason,
    }}))
