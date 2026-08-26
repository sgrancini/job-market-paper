#!/bin/bash

set -euo pipefail

SOURCE_PDF="/Users/stefanograncini/Desktop/WORK/PhD/Second_Paper_Debt/Paper Writing/Current JMP/JMP.pdf"
REPO_DIR="/Users/stefanograncini/Desktop/WORK/Job Market/job-market-paper"
DEST_PDF="${REPO_DIR}/paper.pdf"
INDEX_HTML="${REPO_DIR}/index.html"
PUBLIC_PDF_URL="https://sgrancini.github.io/job-market-paper/paper.pdf"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

printf 'Publishing Stefano Grancini\047s Job Market Paper\n'
printf 'Source: %s\n' "$SOURCE_PDF"
printf 'Repository: %s\n\n' "$REPO_DIR"

[[ -f "$SOURCE_PDF" ]] || fail "Source PDF does not exist: $SOURCE_PDF"
[[ -r "$SOURCE_PDF" ]] || fail "Source PDF is not readable: $SOURCE_PDF"
[[ -s "$SOURCE_PDF" ]] || fail "Source PDF is empty: $SOURCE_PDF"

PDF_DESCRIPTION="$(/usr/bin/file -b "$SOURCE_PDF")"
case "$PDF_DESCRIPTION" in
  PDF\ document*) ;;
  *) fail "Source is not recognized as a PDF (file reports: $PDF_DESCRIPTION)" ;;
esac

[[ -d "${REPO_DIR}/.git" ]] || fail "Publishing repository is missing or is not a Git repository: $REPO_DIR"
[[ -f "$INDEX_HTML" ]] || fail "Landing page is missing: $INDEX_HTML"

BRANCH="$(/usr/bin/git -C "$REPO_DIR" branch --show-current)"
[[ -n "$BRANCH" ]] || fail "Could not determine the current Git branch."
/usr/bin/git -C "$REPO_DIR" remote get-url origin >/dev/null 2>&1 || fail "Git remote 'origin' is not configured."

SOURCE_CHANGED=1
if [[ -f "$DEST_PDF" ]] && /usr/bin/cmp -s "$SOURCE_PDF" "$DEST_PDF"; then
  SOURCE_CHANGED=0
fi

if [[ "$SOURCE_CHANGED" -eq 1 ]]; then
  UPDATE_DATE="$(/bin/date '+%Y-%m-%d')"
  MATCH_COUNT="$(/usr/bin/grep -Ec 'Last updated: <time datetime="[0-9]{4}-[0-9]{2}-[0-9]{2}">[0-9]{4}-[0-9]{2}-[0-9]{2}</time>' "$INDEX_HTML" || true)"
  [[ "$MATCH_COUNT" -eq 1 ]] || fail "Expected exactly one Last updated marker in index.html; found $MATCH_COUNT."

  TEMP_PDF="${DEST_PDF}.tmp.$$"
  TEMP_INDEX="${INDEX_HTML}.tmp.$$"
  cleanup() {
    /bin/rm -f "$TEMP_PDF" "$TEMP_INDEX"
  }
  trap cleanup EXIT INT TERM

  /bin/cp "$SOURCE_PDF" "$TEMP_PDF"
  /usr/bin/cmp -s "$SOURCE_PDF" "$TEMP_PDF" || fail "Copied PDF does not match the source."
  /usr/bin/sed -E "s#Last updated: <time datetime=\"[0-9]{4}-[0-9]{2}-[0-9]{2}\">[0-9]{4}-[0-9]{2}-[0-9]{2}</time>#Last updated: <time datetime=\"${UPDATE_DATE}\">${UPDATE_DATE}</time>#" "$INDEX_HTML" > "$TEMP_INDEX"

  /bin/mv "$TEMP_PDF" "$DEST_PDF"
  /bin/cp "$TEMP_INDEX" "$INDEX_HTML"
  /bin/rm -f "$TEMP_INDEX"
  trap - EXIT INT TERM
  printf 'Copied and validated the new paper.pdf.\n'
else
  printf 'The canonical source already matches paper.pdf.\n'
fi

printf '\nGit status:\n'
/usr/bin/git -C "$REPO_DIR" status --short

RELEVANT_CHANGES="$(/usr/bin/git -C "$REPO_DIR" status --porcelain -- index.html paper.pdf)"
if [[ -z "$RELEVANT_CHANGES" ]]; then
  CURRENT_COMMIT="$(/usr/bin/git -C "$REPO_DIR" rev-parse HEAD)"
  printf '\nNo publishable changes detected; no commit was created.\n'
  printf 'Current commit: %s\n' "$CURRENT_COMMIT"
  printf 'Public PDF: %s\n' "$PUBLIC_PDF_URL"
  exit 0
fi

/usr/bin/git -C "$REPO_DIR" add -- index.html paper.pdf

if /usr/bin/git -C "$REPO_DIR" diff --cached --quiet -- index.html paper.pdf; then
  fail "Git found no staged content change after validation."
fi

COMMIT_DATE="$(/bin/date '+%Y-%m-%d')"
/usr/bin/git -C "$REPO_DIR" commit --only -m "Update JMP — ${COMMIT_DATE}" -- index.html paper.pdf
/usr/bin/git -C "$REPO_DIR" push origin "$BRANCH"

NEW_COMMIT="$(/usr/bin/git -C "$REPO_DIR" rev-parse HEAD)"
printf '\nPublication push completed.\n'
printf 'Commit: %s\n' "$NEW_COMMIT"
printf 'Public PDF: %s\n' "$PUBLIC_PDF_URL"
