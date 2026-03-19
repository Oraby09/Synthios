---
summary: "CLI reference for `synthios uninstall` (remove gateway service + local data)"
read_when:
  - You want to remove the gateway service and/or local state
  - You want a dry-run first
title: "uninstall"
---

# `synthios uninstall`

Uninstall the gateway service + local data (CLI remains).

```bash
synthios backup create
synthios uninstall
synthios uninstall --all --yes
synthios uninstall --dry-run
```

Run `synthios backup create` first if you want a restorable snapshot before removing state or workspaces.
