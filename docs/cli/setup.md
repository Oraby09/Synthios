---
summary: "CLI reference for `synthios setup` (initialize config + workspace)"
read_when:
  - You’re doing first-run setup without full CLI onboarding
  - You want to set the default workspace path
title: "setup"
---

# `synthios setup`

Initialize `~/.synthios/synthios.json` and the agent workspace.

Related:

- Getting started: [Getting started](/start/getting-started)
- CLI onboarding: [Onboarding (CLI)](/start/wizard)

## Examples

```bash
synthios setup
synthios setup --workspace ~/.synthios/workspace
```

To run onboarding via setup:

```bash
synthios setup --wizard
```
