# Job Market Paper

Version history and audit trail for Stefano Grancini's Job Market Paper,
*Public Debt, iMPCs & Fiscal Policy Transmission*.

## Where the paper lives

| | |
|---|---|
| **Authoritative latest version** | <https://jmp.stefanograncini.com/paper.pdf> |
| Legacy mirror (still updated) | <https://sgrancini.github.io/job-market-paper/paper.pdf> |
| Legacy landing page | <https://sgrancini.github.io/job-market-paper/> |

Circulate the authoritative URL — in the CV, on the website, inside the paper,
and in email. It is served by Cloudflare Pages with `Cache-Control: no-store`,
so a browser can never show a previously downloaded version.

The GitHub Pages mirror is kept up to date so that links already sent out keep
working, but GitHub Pages sends `cache-control: max-age=600`, which is why it is
no longer the link to hand to people.

This repository's job is version history, backup and the publication audit trail.

## Source of the paper

There is no canonical source path in this repository. The published PDF is
whichever file Stefano selects by hand in the publisher's file picker.

## Publish a new version

Double-click:

    Desktop/WORK/PhD/Second_Paper_Debt/Paper Writing/Publish JMP.command

Pick the PDF, read the summary it prints (path, pages, size, SHA-256, and how it
differs from what is live), then type `y`. Nothing changes unless you confirm.

The implementation lives outside this repository, in
`Paper Writing/.jmp-publisher/publish_jmp.sh`. `update_paper.sh` in this
repository is retired and refuses to run — do not use it.

Past versions remain recoverable from this repository's Git history.
