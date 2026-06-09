# yessir — modo "sí a todo" para comandos en Claude Code

Skill para **Claude Code** que deja de pedirte permiso para **ejecutar comandos**
(Bash) del sistema. No te deja a ciegas: el agente **sigue preguntándote** cuando
necesita información o una decisión de contexto (usa `AskUserQuestion`). yessir solo
silencia los permisos de *ejecución de comandos*, no el criterio para preguntar.

## Cómo funciona

No es magia del modelo: instala un **hook `PreToolUse`** en `~/.claude/settings.json`
con `matcher: "Bash"` que devuelve `permissionDecision: allow`. Así el harness aprueba
cada llamada a Bash automáticamente.

## Instalación

```sh
git clone https://github.com/<tu-usuario>/yessir.git
cd yessir
sh install.sh          # copia la skill a ~/.claude/skills/yessir/
```

Luego, en Claude Code:

```
/yessir                # activa el modo (ejecuta yessir-enable.sh)
```

O actívalo a mano sin invocar la skill:

```sh
sh ~/.claude/skills/yessir/yessir-enable.sh
```

> Reinicia Claude Code una vez si los hooks no se recargan en caliente.

## Desactivar

```
desactiva yessir       # en el chat
```
o
```sh
sh ~/.claude/skills/yessir/yessir-disable.sh
```

## Estructura del repo

```
yessir/
├─ README.md
├─ install.sh                 # copia la skill a ~/.claude/skills/yessir/
└─ skills/
   └─ yessir/
      ├─ SKILL.md             # definición de la skill (la lee Claude)
      ├─ yessir-allow.sh      # hook: imprime la decisión "allow"
      ├─ yessir-enable.sh     # fusiona el hook en settings.json (idempotente)
      └─ yessir-disable.sh    # quita el hook
```

## Seguridad

Auto-aprobar todos los comandos es cómodo pero **potente**: el agente podrá ejecutar
cualquier Bash sin confirmación. Úsalo en entornos de tu confianza (tu máquina/VM de
desarrollo) y desactívalo cuando no lo necesites. El alcance está limitado a `Bash`
(no afecta a otros permisos ni a las preguntas de contexto).

## Subir a GitHub

```sh
cd /home/jjrosat/yessir
git init && git add -A && git commit -m "yessir: skill sí-a-todo para comandos"
git branch -M main
git remote add origin https://github.com/<tu-usuario>/yessir.git
git push -u origin main
```
