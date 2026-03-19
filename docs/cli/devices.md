---
summary: "CLI reference for `synthios devices` (device pairing + token rotation/revocation)"
read_when:
  - You are approving device pairing requests
  - You need to rotate or revoke device tokens
title: "devices"
---

# `synthios devices`

Manage device pairing requests and device-scoped tokens.

## Commands

### `synthios devices list`

List pending pairing requests and paired devices.

```
synthios devices list
synthios devices list --json
```

### `synthios devices remove <deviceId>`

Remove one paired device entry.

```
synthios devices remove <deviceId>
synthios devices remove <deviceId> --json
```

### `synthios devices clear --yes [--pending]`

Clear paired devices in bulk.

```
synthios devices clear --yes
synthios devices clear --yes --pending
synthios devices clear --yes --pending --json
```

### `synthios devices approve [requestId] [--latest]`

Approve a pending device pairing request. If `requestId` is omitted, Synthios
automatically approves the most recent pending request.

```
synthios devices approve
synthios devices approve <requestId>
synthios devices approve --latest
```

### `synthios devices reject <requestId>`

Reject a pending device pairing request.

```
synthios devices reject <requestId>
```

### `synthios devices rotate --device <id> --role <role> [--scope <scope...>]`

Rotate a device token for a specific role (optionally updating scopes).

```
synthios devices rotate --device <deviceId> --role operator --scope operator.read --scope operator.write
```

### `synthios devices revoke --device <id> --role <role>`

Revoke a device token for a specific role.

```
synthios devices revoke --device <deviceId> --role node
```

## Common options

- `--url <url>`: Gateway WebSocket URL (defaults to `gateway.remote.url` when configured).
- `--token <token>`: Gateway token (if required).
- `--password <password>`: Gateway password (password auth).
- `--timeout <ms>`: RPC timeout.
- `--json`: JSON output (recommended for scripting).

Note: when you set `--url`, the CLI does not fall back to config or environment credentials.
Pass `--token` or `--password` explicitly. Missing explicit credentials is an error.

## Notes

- Token rotation returns a new token (sensitive). Treat it like a secret.
- These commands require `operator.pairing` (or `operator.admin`) scope.
- `devices clear` is intentionally gated by `--yes`.
- If pairing scope is unavailable on local loopback (and no explicit `--url` is passed), list/approve can use a local pairing fallback.

## Token drift recovery checklist

Use this when Control UI or other clients keep failing with `AUTH_TOKEN_MISMATCH` or `AUTH_DEVICE_TOKEN_MISMATCH`.

1. Confirm current gateway token source:

```bash
synthios config get gateway.auth.token
```

2. List paired devices and identify the affected device id:

```bash
synthios devices list
```

3. Rotate operator token for the affected device:

```bash
synthios devices rotate --device <deviceId> --role operator
```

4. If rotation is not enough, remove stale pairing and approve again:

```bash
synthios devices remove <deviceId>
synthios devices list
synthios devices approve <requestId>
```

5. Retry client connection with the current shared token/password.

Related:

- [Dashboard auth troubleshooting](/web/dashboard#if-you-see-unauthorized-1008)
- [Gateway troubleshooting](/gateway/troubleshooting#dashboard-control-ui-connectivity)
