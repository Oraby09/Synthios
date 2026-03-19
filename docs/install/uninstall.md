---
summary: "Uninstall Synthios completely (CLI, service, state, workspace)"
read_when:
  - You want to remove Synthios from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `synthios` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
synthios uninstall
```

Non-interactive (automation / npx):

```bash
synthios uninstall --all --yes --non-interactive
npx -y synthios uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
synthios gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
synthios gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${SYNTHIOS_STATE_DIR:-$HOME/.synthios}"
```

If you set `SYNTHIOS_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.synthios/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g synthios
pnpm remove -g synthios
bun remove -g synthios
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/Synthios.app
```

Notes:

- If you used profiles (`--profile` / `SYNTHIOS_PROFILE`), repeat step 3 for each state dir (defaults are `~/.synthios-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `synthios` is missing.

### macOS (launchd)

Default label is `ai.synthios.gateway` (or `ai.synthios.<profile>`; legacy `com.synthios.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.synthios.gateway
rm -f ~/Library/LaunchAgents/ai.synthios.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.synthios.<profile>`. Remove any legacy `com.synthios.*` plists if present.

### Linux (systemd user unit)

Default unit name is `synthios-gateway.service` (or `synthios-gateway-<profile>.service`):

```bash
systemctl --user disable --now synthios-gateway.service
rm -f ~/.config/systemd/user/synthios-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `Synthios Gateway` (or `Synthios Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "Synthios Gateway"
Remove-Item -Force "$env:USERPROFILE\.synthios\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.synthios-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://synthios.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g synthios@latest`.
Remove it with `npm rm -g synthios` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `synthios ...` / `bun run synthios ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
