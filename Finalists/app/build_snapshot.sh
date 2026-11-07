#!/usr/bin/env bash
# Build a clean judge copy of the repo: tracked files of the current commit only.
# Usage: Finalists/app/build_snapshot.sh OUT_DIR      (OUT_DIR must not exist or be empty)
# Excludes: .git, api_keys.env, .Renviron, .RData, data/cache/llm/, files over 50 MB.
# Then scans the copy for secrets and exits non-zero if any is found.
# Never prints a key value, only file paths. Does not push or publish anything.
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: $0 OUT_DIR" >&2; exit 2; }
ROOT="$(git rev-parse --show-toplevel)"
OUT="$1"
mkdir -p "$OUT"
[ -z "$(ls -A "$OUT")" ] || { echo "ERROR: $OUT is not empty" >&2; exit 2; }
OUT="$(cd "$OUT" && pwd)"
cd "$ROOT"

# 1. Tracked files at HEAD only (no .git, no untracked or ignored files).
git archive HEAD | tar -x -C "$OUT"

# 2. Remove what judges must not get.
find "$OUT" \( -name api_keys.env -o -name '.Renviron' -o -name '.RData' -o -name '.Rhistory' \) -type f -delete
find "$OUT" -type d -path '*/data/cache/llm' -prune -exec rm -rf {} +
find "$OUT" -type f -size +50M -print | while read -r f; do echo "dropped (over 50 MB): ${f#"$OUT"/}"; done
find "$OUT" -type f -size +50M -delete
find "$OUT" -type d -empty -delete 2>/dev/null || true

# 3. Note about keys, unless the README already says it.
if ! grep -rqiE 'own (api )?keys?' "$OUT"/README.md "$OUT"/Finalists/README.md 2>/dev/null; then
  cat > "$OUT/SNAPSHOT_NOTE.md" <<'NOTE'
# Judge snapshot

This is a clean copy of the repository at one commit. It has no git history.

- `api_keys.env`, `.Renviron` and `.RData` are not included.
- LLM response caches (`data/cache/llm/`) and files over 50 MB are not included.
- To rerun anything that calls Simpler.Grants.gov or SAM.gov, make your own free API keys
  and put them in your own `api_keys.env` (see `.Renviron.example` for the variable names).
  Never commit that file.
NOTE
fi

# 4. Secret scan. Prints paths only, never values.
fail=0
KEYFILE="$ROOT/Finalists/api_keys.env"
if [ -f "$KEYFILE" ]; then
  while IFS='=' read -r k v; do
    case "$k" in ''|\#*) continue;; esac
    v="${v%$'\r'}"; v="${v%\"}"; v="${v#\"}"
    [ ${#v} -ge 8 ] || continue
    # exact value anywhere in the copy
    if grep -rlaF -e "$v" "$OUT" | sed 's/^/FAIL: key value of '"$k"' in /; s#'"$OUT"'/##' | grep .; then fail=1; fi
    # key name assigned a non-empty value
    if grep -rlaE -e "$k[[:space:]]*[=:][[:space:]]*['\"]?[A-Za-z0-9_-]{12,}" "$OUT" | sed 's/^/FAIL: '"$k"' assigned a value in /; s#'"$OUT"'/##' | grep .; then fail=1; fi
  done < "$KEYFILE"
fi
PATTERNS='sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{30,}|AIza[0-9A-Za-z_-]{35}|xox[abprs]-[A-Za-z0-9-]{10,}|AccountKey=[A-Za-z0-9+/=]{20,}|SharedAccessSignature=|-----BEGIN [A-Z ]*PRIVATE KEY-----|[Aa][Pp][Ii]_?[Kk][Ee][Yy][[:space:]]*[=:][[:space:]]*['"'"'"][A-Za-z0-9_-]{20,}'
if grep -rlaE -e "$PATTERNS" "$OUT" | sed 's/^/FAIL: secret-like pattern in /; s#'"$OUT"'/##' | grep .; then fail=1; fi
for bad in .git .RData .Renviron api_keys.env; do
  if find "$OUT" -name "$bad" | grep -q .; then echo "FAIL: $bad present"; fail=1; fi
done
if [ -d "$OUT/Finalists/src/data/cache/llm" ] || find "$OUT" -path '*/data/cache/llm/*' | grep -q .; then echo "FAIL: data/cache/llm present"; fail=1; fi

if [ $fail -ne 0 ]; then echo "Snapshot NOT safe: do not hand it out. (left at $OUT for inspection)" >&2; exit 1; fi
echo "OK: scan passed. $OUT: $(find "$OUT" -type f | wc -l | tr -d ' ') files, $(du -sh "$OUT" | cut -f1)"
