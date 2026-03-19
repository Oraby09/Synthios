---
summary: "CLI reference for `synthios reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `synthios reset`

Reset local config/state (keeps the CLI installed).

```bash
synthios backup create
synthios reset
synthios reset --dry-run
synthios reset --scope config+creds+sessions --yes --non-interactive
```

Run `synthios backup create` first if you want a restorable snapshot before removing local state.
