---
summary: "CLI reference for `synthios voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
title: "voicecall"
---

# `synthios voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:

- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
synthios voicecall status --call-id <id>
synthios voicecall call --to "+15555550123" --message "Hello" --mode notify
synthios voicecall continue --call-id <id> --message "Any questions?"
synthios voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
synthios voicecall expose --mode serve
synthios voicecall expose --mode funnel
synthios voicecall expose --mode off
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.
