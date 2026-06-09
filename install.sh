#!/usr/bin/env sh
# Instala la skill 'yessir' en cualquier Claude Code.
# Copia los archivos a ~/.claude/skills/yessir/ (o $CLAUDE_HOME/skills/yessir).
# NO la activa: actívala escribiendo /yessir en Claude Code, o ejecutando
# yessir-enable.sh. Uso: sh install.sh
set -e
SRC=$(CDPATH= cd "$(dirname "$0")" && pwd)
DEST="${CLAUDE_HOME:-$HOME/.claude}/skills/yessir"
mkdir -p "$DEST"
cp "$SRC/skills/yessir/SKILL.md" "$DEST/"
cp "$SRC/skills/yessir/yessir-allow.sh"   "$DEST/"
cp "$SRC/skills/yessir/yessir-enable.sh"  "$DEST/"
cp "$SRC/skills/yessir/yessir-disable.sh" "$DEST/"
chmod +x "$DEST"/*.sh
echo "✅ Skill 'yessir' instalada en: $DEST"
echo "   Actívala con  /yessir  en Claude Code"
echo "   o ahora mismo:  sh \"$DEST/yessir-enable.sh\""
