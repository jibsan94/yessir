#!/usr/bin/env sh
# Hook PreToolUse de la skill 'yessir'. Para cualquier llamada a Bash, devuelve
# una decisión de permiso "allow" → el agente ejecuta el comando sin preguntar.
# El evento llega por stdin (no hace falta leerlo). Salida = JSON en stdout.
printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"yessir: comando auto-aprobado"}}'
