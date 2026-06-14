---
name: yessir
description: Modo "sí a todo" para comandos de terminal. Al invocarlo deja de pedir permiso para ejecutar Bash/comandos del sistema (instala un hook PreToolUse que auto-aprueba Bash). NO afecta a las preguntas de contexto (AskUserQuestion siguen funcionando). Úsalo cuando el usuario diga "/yessir", "yessir", "modo sí a todo", "no me pidas permiso para comandos" o "deja de pedir permisos".
---

# yessir — sí a todo (solo comandos)

Activa el auto-aprobado de **Bash** para que dejes de pedir permiso al usuario al
ejecutar comandos del sistema. No es magia del modelo: instala un **hook
`PreToolUse`** en `~/.claude/settings.json` que, para el tool `Bash`, devuelve
`permissionDecision: allow`.

**Complemento con napkin:** el hook también auto-aprueba las **ediciones**
(`Edit`/`Write`/`MultiEdit`/`NotebookEdit`) **solo si la skill `napkin` está
instalada** (`~/.claude/skills/napkin`). Si napkin no está, las ediciones siguen el
flujo normal de permisos. La decisión la toma `yessir-allow.py` (lee `tool_name` del
stdin del hook); el matcher es `Bash|Edit|Write|MultiEdit|NotebookEdit`.

## Qué hacer al invocar esta skill

1. **Activa** el modo ejecutando el script incluido:
   ```sh
   sh "$HOME/.claude/skills/yessir/yessir-enable.sh"
   ```
   Es idempotente: fusiona (sin duplicar) el hook en `~/.claude/settings.json`.
2. **Confirma** al usuario: «yessir activado — no volveré a pedir permiso para
   ejecutar comandos.»
3. Si el harness no recarga hooks en caliente, indica reiniciar Claude Code una vez.

## Excepción importante (no la rompas)

yessir **solo** silencia los permisos de *ejecución de comandos*. **Sigue usando
`AskUserQuestion`** siempre que necesites información o una decisión de contexto del
usuario (rutas, credenciales, elegir entre opciones, confirmar algo ambiguo). yessir
no convierte al agente en autónomo a ciegas: calla los permisos de Bash, no el
criterio para preguntar lo que de verdad hace falta.

## Desactivar

```sh
sh "$HOME/.claude/skills/yessir/yessir-disable.sh"
```
O cuando el usuario diga «desactiva yessir» / «vuelve a pedirme permiso».

## Cómo funciona (referencia)

El hook que se instala equivale a:
```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash",
        "hooks": [ { "type": "command",
          "command": "<.../yessir-allow.sh>" } ] }
    ]
  }
}
```
y `yessir-allow.sh` imprime:
`{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"yessir"}}`
