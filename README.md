# Claude Code sandbox

A Docker Compose setup for running [Claude Code](https://github.com/anthropics/claude-code)
against an arbitrary local project directory, with outbound network access
locked down to only the endpoints at Anthropic.

- The `claude` container has **no direct route to the internet**: the only thing
  it can reach at all is the `proxy` container.
- The `proxy` (tinyproxy) container is the sole egress path, and only forwards
  HTTPS `CONNECT` requests to hosts matching the allow-list in
  [`filter`](./filter)
- Both containers run with all Linux capabilities dropped (`cap_drop: ALL`),
  `no-new-privileges`, and the `claude` container has memory/CPU/PID limits.

## Requirements

- Docker and Docker Compose

## Usage

```sh
cd /path/to/your/project
/path/to/this/repo/run-claude.sh [optional args]
```

The `run-claude.sh` script can be run from any directory: it uses `$PWD` as the
project to mount. Any extra arguments are forwarded to the `claude` CLI, _e.g._:

```sh
run-claude.sh -p "summarise this repository"
```

The first time you run it, Docker will build the `claude` image from the
included [`Dockerfile`](./Dockerfile)). You'll also have to authenticate outside
of the sandbox, but subsequent sessions will use the credentials that have now
been stored in the `~/.claude-sandbox-home` directory.

## What gets mounted

- Your project directory (`$PWD` when you invoke the script) is mounted at
  `/home/dev/workspace` inside the container — this is what Claude Code can
  read and edit.
- `~/.claude-sandbox-home` (on the host, outside this repository) is mounted as
  the container's `$HOME` (`/home/dev`). This is where Claude Code persists its
  config, credentials, and session history _between runs of the sandbox_. It
  contains real secrets (`.credentials.json`, `.claude.json`) once you've logged
  in — treat it like any other credentials directory.

## Extending the allow-list

Add an anchored regular expression line to `filter` (e.g. `^some\.host\.com$`)
and restart.
