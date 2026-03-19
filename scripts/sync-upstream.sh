#!/usr/bin/env bash
# sync-upstream.sh — Fetch upstream openclaw, reset to it, apply Synthios branding.
#
# Strategy: instead of merging (which creates conflicts every time upstream
# touches any "openclaw" string), we hard-reset to upstream/main and replay
# the branding replacements from scratch.  The result is always one clean
# "Rebrand" commit on top of upstream — zero merge conflicts.
#
# Usage:
#   ./scripts/sync-upstream.sh           # full sync (fetch + reset + rebrand)
#   ./scripts/sync-upstream.sh --dry-run # show what would change, don't commit
#   ./scripts/sync-upstream.sh --rebrand-only  # skip fetch/reset, just re-apply branding

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

DRY_RUN=false
REBRAND_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true ;;
    --rebrand-only) REBRAND_ONLY=true ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--rebrand-only]"
      echo "  --dry-run       Show what would change, don't commit"
      echo "  --rebrand-only  Skip fetch/reset, just re-apply branding to current tree"
      exit 0
      ;;
    *) echo "Unknown arg: $arg"; exit 1 ;;
  esac
done

# The old brand name (upstream) and the new brand name (ours).
# Spelled with hex escapes so this script itself is not mangled
# when it lives inside the repo and the broad sed runs over it.
OLD_LOWER=$(printf '\x6f\x70\x65\x6e\x63\x6c\x61\x77')   # openclaw
OLD_UPPER=$(printf '\x4f\x70\x65\x6e\x43\x6c\x61\x77')   # OpenClaw
OLD_ALLCAP=$(printf '\x4f\x50\x45\x4e\x43\x4c\x41\x57')   # OPENCLAW
NEW_LOWER="synthios"
NEW_UPPER="Synthios"
NEW_ALLCAP="SYNTHIOS"

# ── Safety checks ──────────────────────────────────────────────────────────────
if ! $REBRAND_ONLY; then
  if ! git remote get-url upstream &>/dev/null; then
    echo "error: no 'upstream' remote. Add it with:"
    echo "  git remote add upstream https://github.com/${OLD_LOWER}/${OLD_LOWER}.git"
    exit 1
  fi

  if [ -n "$(git status --porcelain)" ]; then
    echo "error: working tree is dirty. Commit or stash changes first."
    exit 1
  fi
fi

# ── Save this script (hard reset will delete it) ────────────────────────────
SELF_BACKUP="$(mktemp /tmp/sync-upstream-backup.XXXXXX)"
cp "$0" "$SELF_BACKUP"

# ── Step 1: Fetch & reset ────────────────────────────────────────────────────
if ! $REBRAND_ONLY; then
  echo "==> Fetching upstream/main..."
  git fetch upstream main

  UPSTREAM_HEAD="$(git rev-parse upstream/main)"
  LOCAL_HEAD="$(git rev-parse HEAD)"

  echo "  upstream/main: ${UPSTREAM_HEAD:0:12}"
  echo "  local HEAD:    ${LOCAL_HEAD:0:12}"

  echo "==> Resetting to upstream/main..."
  git reset --hard upstream/main

  # Restore this script after reset
  mkdir -p "$REPO_ROOT/scripts"
  cp "$SELF_BACKUP" "$REPO_ROOT/scripts/sync-upstream.sh"
  chmod +x "$REPO_ROOT/scripts/sync-upstream.sh"
fi
rm -f "$SELF_BACKUP"

# ── Step 2: Broad text replacements ──────────────────────────────────────────
echo "==> Applying ${NEW_UPPER} branding..."

file_count=0
while IFS= read -r -d '' file; do
  sed -i '' \
    -e "s|${OLD_LOWER}|${NEW_LOWER}|g" \
    -e "s|${OLD_UPPER}|${NEW_UPPER}|g" \
    -e "s|${OLD_ALLCAP}|${NEW_ALLCAP}|g" \
    "$file"
  file_count=$((file_count + 1))
done < <(
  find . \
    \( -path ./node_modules -o -path ./dist -o -path ./dist-runtime \
       -o -path ./.git -o -path '**/node_modules' \
       -o -path ./pnpm-lock.yaml \) -prune \
    -o \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' \
          -o -name '*.json' -o -name '*.md' -o -name '*.mdx' \
          -o -name '*.yml' -o -name '*.yaml' -o -name '*.sh' \
          -o -name '*.swift' -o -name '*.kt' -o -name '*.kts' \
          -o -name '*.plist' -o -name '*.xml' -o -name '*.gradle' \
          -o -name '*.py' -o -name '*.toml' -o -name '*.cfg' \
          -o -name '*.mjs' -o -name '*.cjs' \
          -o -name '*.css' -o -name '*.html' -o -name '*.svg' \
          -o -name 'CNAME' -o -name 'Dockerfile' -o -name 'Makefile' \) \
       -type f -print0
)
echo "  Processed $file_count files"

# ── Step 3: Restore patterns that must stay with the old brand ───────────────
echo "==> Restoring upstream-only references..."

# 3a. npmSpec in extension package.json (real npm published package names)
while IFS= read -r -d '' pkg; do
  sed -i '' "s|\"npmSpec\": \"@${NEW_LOWER}/|\"npmSpec\": \"@${OLD_LOWER}/|g" "$pkg"
done < <(find ./extensions -name "package.json" -not -path "*/node_modules/*" -print0)

# 3b. plugin-npm-release test references the real @openclaw npm scope
if [ -f "./test/plugin-npm-release.test.ts" ]; then
  sed -i '' "s|@${NEW_LOWER}/|@${OLD_LOWER}/|g" "./test/plugin-npm-release.test.ts"
fi

# 3c. peerDependencies in extension package.json reference the npm-published
#     root package name ("openclaw"), not our rebranded name ("synthios").
#     The broad sed renamed these, so restore them.
while IFS= read -r -d '' pkg; do
  sed -i '' \
    -e "s|\"${NEW_LOWER}\": \">|\"${OLD_LOWER}\": \">|g" \
    -e "s|\"${NEW_LOWER}\": {|\"${OLD_LOWER}\": {|g" \
    "$pkg"
done < <(find ./extensions -name "package.json" -not -path "*/node_modules/*" -print0)

# ── Step 4: File renames ─────────────────────────────────────────────────────
echo "==> Renaming files..."

# 4a. openclaw.plugin.json → synthios.plugin.json
while IFS= read -r -d '' f; do
  target="$(dirname "$f")/${NEW_LOWER}.plugin.json"
  if [ ! -f "$target" ]; then
    git mv "$f" "$target" 2>/dev/null || mv "$f" "$target"
    echo "  renamed: $f"
  fi
done < <(find . -name "${OLD_LOWER}.plugin.json" -not -path "*/node_modules/*" -not -path "*/dist/*" -print0)

# 4b. openclaw.mjs → synthios.mjs
if [ -f "./${OLD_LOWER}.mjs" ] && [ ! -f "./${NEW_LOWER}.mjs" ]; then
  git mv "./${OLD_LOWER}.mjs" "./${NEW_LOWER}.mjs" 2>/dev/null || mv "./${OLD_LOWER}.mjs" "./${NEW_LOWER}.mjs"
  echo "  renamed: ${OLD_LOWER}.mjs → ${NEW_LOWER}.mjs"
fi

# 4c. Android package directory: ai/openclaw → ai/synthios
ANDROID_BASE="apps/android/app/src"
for subdir in main/java main/kotlin test/java test/kotlin androidTest/java androidTest/kotlin; do
  src="$ANDROID_BASE/$subdir/ai/${OLD_LOWER}"
  dst="$ANDROID_BASE/$subdir/ai/${NEW_LOWER}"
  if [ -d "$src" ] && [ ! -d "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    git mv "$src" "$dst" 2>/dev/null || mv "$src" "$dst"
    echo "  renamed: $src → $dst"
  fi
done

# 4d. macOS Swift package directories: OpenClaw* → Synthios*
for base in apps/macos/Sources apps/macos/Tests; do
  [ -d "$base" ] || continue
  for src in "$base"/${OLD_UPPER}*; do
    [ -d "$src" ] || continue
    dst="$(echo "$src" | sed "s|${OLD_UPPER}|${NEW_UPPER}|")"
    if [ ! -d "$dst" ]; then
      git mv "$src" "$dst" 2>/dev/null || mv "$src" "$dst"
      echo "  renamed: $src"
    fi
  done
done

# 4e. Xcode projects
for src in apps/macos/${OLD_UPPER}*.xcodeproj; do
  [ -e "$src" ] || continue
  dst="$(echo "$src" | sed "s|${OLD_UPPER}|${NEW_UPPER}|")"
  if [ ! -e "$dst" ]; then
    git mv "$src" "$dst" 2>/dev/null || mv "$src" "$dst"
    echo "  renamed: $src"
  fi
done

# 4f. Rename ALL remaining files whose names contain the old brand
while IFS= read -r src; do
  dst="$(echo "$src" | sed "s|${OLD_LOWER}|${NEW_LOWER}|g; s|${OLD_UPPER}|${NEW_UPPER}|g")"
  if [ "$src" != "$dst" ] && [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    git mv "$src" "$dst" 2>/dev/null || mv "$src" "$dst"
  fi
done < <(find . \
  \( -path ./node_modules -o -path ./dist -o -path ./dist-runtime \
     -o -path ./.git -o -path '**/node_modules' \) -prune \
  -o -type f -name "*${OLD_LOWER}*" -print -o -type f -name "*${OLD_UPPER}*" -print)

# 4g. Rename directories whose names contain the old brand (deepest first)
find . \
  \( -path ./node_modules -o -path ./dist -o -path ./dist-runtime \
     -o -path ./.git -o -path '**/node_modules' \) -prune \
  -o -type d \( -name "*${OLD_LOWER}*" -o -name "*${OLD_UPPER}*" \) -print \
  | sort -r | while read -r src; do
    dst="$(echo "$src" | sed "s|${OLD_LOWER}|${NEW_LOWER}|g; s|${OLD_UPPER}|${NEW_UPPER}|g")"
    if [ "$src" != "$dst" ] && [ ! -e "$dst" ]; then
      git mv "$src" "$dst" 2>/dev/null || mv "$src" "$dst"
    fi
done

# ── Step 5: CNAME for docs ───────────────────────────────────────────────────
if [ -f "docs/CNAME" ]; then
  echo "docs.${NEW_LOWER}.ai" > docs/CNAME
fi

# ── Step 6: Format fix (pre-commit hook requires it) ─────────────────────────
echo "==> Running format fix..."
if command -v pnpm &>/dev/null && [ -f "package.json" ]; then
  pnpm format:fix 2>/dev/null || true
fi

# ── Step 7: Commit ───────────────────────────────────────────────────────────
if $DRY_RUN; then
  echo ""
  echo "==> Dry run complete. Changes NOT committed."
  echo "  To see changes: git diff"
  echo "  To reset:       git reset --hard upstream/main"
  exit 0
fi

echo "==> Committing rebrand..."
git add -A
# Unstage .agent/ (partially ignored by .gitignore, breaks pre-commit hook)
git reset HEAD .agent/ 2>/dev/null || true
git checkout -- .agent/ 2>/dev/null || true

if git diff --cached --quiet; then
  echo "  No changes to commit (already up to date)."
else
  git commit --no-verify -m "Rebrand upstream merge to ${NEW_UPPER}"
fi

echo ""
echo "==> Done! Current state:"
echo "  $(git log --oneline -1)"
echo ""
echo "Next steps:"
echo "  1. Run: pnpm install && pnpm build"
echo "  2. Test: pnpm check && pnpm test"
echo "  3. Push: git push --force-with-lease origin main"
