# yessir — modo "sí a todo" para comandos en Claude Code

Skill para **Claude Code** que deja de pedirte permiso para **ejecutar comandos**
(Bash) del sistema. No te deja a ciegas: el agente **sigue preguntándote** cuando
necesita información o una decisión de contexto (usa `AskUserQuestion`). yessir solo
silencia los permisos de *ejecución de comandos*, no el criterio para preguntar.

## Cómo funciona

No es magia del modelo: instala un **hook `PreToolUse`** en `~/.claude/settings.json`
(matcher `Bash|Edit|Write|MultiEdit|NotebookEdit`) que ejecuta `yessir-allow.py`.
El script decide el permiso según la herramienta y devuelve `permissionDecision: allow`:

- **Bash** → **siempre** auto-aprobado.
- **Edit / Write / MultiEdit / NotebookEdit** → auto-aprobado **solo si la skill
  [`napkin`](https://github.com/jibsan94) está instalada** (`~/.claude/skills/napkin`).
  Así yessir se complementa con napkin: si napkin no está, las ediciones siguen el
  flujo normal de permisos.

> **Recarga de hooks:** Claude Code carga los hooks al **arrancar la sesión**. Si
> activas yessir a mitad de sesión (`/yessir`), el auto-aprobado de **ediciones** no
> surte efecto hasta la siguiente sesión — por eso una curación de napkin al final de
> esa misma sesión puede pedirte permiso una vez. **Reinicia Claude Code** tras activarlo.

## Instalación

```sh
git clone https://github.com/jibsan94/yessir.git
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
      ├─ yessir-allow.py      # decide el permiso (Bash siempre; ediciones si hay napkin)
      ├─ yessir-allow.sh      # wrapper del hook: reenvía el evento a yessir-allow.py
      ├─ yessir-enable.sh     # fusiona el hook en settings.json (idempotente)
      └─ yessir-disable.sh    # quita el hook
```

## Seguridad

Auto-aprobar comandos es cómodo pero **potente**: el agente podrá ejecutar cualquier
Bash sin confirmación (y, si tienes `napkin` instalada, también editar/crear ficheros
sin confirmación). Úsalo en entornos de tu confianza (tu máquina/VM de desarrollo) y
desactívalo cuando no lo necesites. No afecta a las **preguntas de contexto**
(`AskUserQuestion`): el agente te seguirá consultando decisiones e información.

## Subir a GitHub

```sh
cd /home/jjrosat/yessir
git init && git add -A && git commit -m "yessir: skill sí-a-todo para comandos"
git branch -M main
git remote add origin https://github.com/jibsan94/yessir.git
git push -u origin main
```
