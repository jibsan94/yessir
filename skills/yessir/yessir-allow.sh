#!/usr/bin/env sh
# Hook PreToolUse de 'yessir'. Reenvía el evento (JSON por stdin) al script Python
# que decide el permiso: Bash siempre; Edit/Write/MultiEdit/NotebookEdit solo si la
# skill 'napkin' está instalada. Mantener el stdin intacto (no usar heredoc, que lo
# consumiría). La salida JSON va a stdout.
DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
exec python3 "$DIR/yessir-allow.py"
