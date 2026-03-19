---
summary: "CLI reference for `synthios backup` (create local backup archives)"
read_when:
  - You want a first-class backup archive for local Synthios state
  - You want to preview which paths would be included before reset or uninstall
title: "backup"
---

# `synthios backup`

Create a local backup archive for Synthios state, config, credentials, sessions, and optionally workspaces.

```bash
synthios backup create
synthios backup create --output ~/Backups
synthios backup create --dry-run --json
synthios backup create --verify
synthios backup create --no-include-workspace
synthios backup create --only-config
synthios backup verify ./2026-03-09T00-00-00.000Z-synthios-backup.tar.gz
```

## Notes

- The archive includes a `manifest.json` file with the resolved source paths and archive layout.
- Default output is a timestamped `.tar.gz` archive in the current working directory.
- If the current working directory is inside a backed-up source tree, Synthios falls back to your home directory for the default archive location.
- Existing archive files are never overwritten.
- Output paths inside the source state/workspace trees are rejected to avoid self-inclusion.
- `synthios backup verify <archive>` validates that the archive contains exactly one root manifest, rejects traversal-style archive paths, and checks that every manifest-declared payload exists in the tarball.
- `synthios backup create --verify` runs that validation immediately after writing the archive.
- `synthios backup create --only-config` backs up just the active JSON config file.

## What gets backed up

`synthios backup create` plans backup sources from your local Synthios install:

- The state directory returned by Synthios's local state resolver, usually `~/.synthios`
- The active config file path
- The OAuth / credentials directory
- Workspace directories discovered from the current config, unless you pass `--no-include-workspace`

If you use `--only-config`, Synthios skips state, credentials, and workspace discovery and archives only the active config file path.

Synthios canonicalizes paths before building the archive. If config, credentials, or a workspace already live inside the state directory, they are not duplicated as separate top-level backup sources. Missing paths are skipped.

The archive payload stores file contents from those source trees, and the embedded `manifest.json` records the resolved absolute source paths plus the archive layout used for each asset.

## Invalid config behavior

`synthios backup` intentionally bypasses the normal config preflight so it can still help during recovery. Because workspace discovery depends on a valid config, `synthios backup create` now fails fast when the config file exists but is invalid and workspace backup is still enabled.

If you still want a partial backup in that situation, rerun:

```bash
synthios backup create --no-include-workspace
```

That keeps state, config, and credentials in scope while skipping workspace discovery entirely.

If you only need a copy of the config file itself, `--only-config` also works when the config is malformed because it does not rely on parsing the config for workspace discovery.

## Size and performance

Synthios does not enforce a built-in maximum backup size or per-file size limit.

Practical limits come from the local machine and destination filesystem:

- Available space for the temporary archive write plus the final archive
- Time to walk large workspace trees and compress them into a `.tar.gz`
- Time to rescan the archive if you use `synthios backup create --verify` or run `synthios backup verify`
- Filesystem behavior at the destination path. Synthios prefers a no-overwrite hard-link publish step and falls back to exclusive copy when hard links are unsupported

Large workspaces are usually the main driver of archive size. If you want a smaller or faster backup, use `--no-include-workspace`.

For the smallest archive, use `--only-config`.
