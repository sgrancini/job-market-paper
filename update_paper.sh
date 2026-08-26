#!/bin/bash
#
# RETIRED. This script used to be a second, independent publishing implementation
# with a hard-coded dated source path. It is kept only so that old shortcuts fail
# loudly instead of publishing a stale file.
#
# The single publishing implementation now lives at:
#   Paper Writing/.jmp-publisher/publish_jmp.sh
#
# Publish by double-clicking:
#   Desktop/WORK/PhD/Second_Paper_Debt/Paper Writing/Publish JMP.command
#
set -u
cat >&2 <<'MSG'
update_paper.sh is retired and does nothing.

The publisher now always asks you to pick the exact PDF by hand.
Double-click instead:

  Desktop/WORK/PhD/Second_Paper_Debt/Paper Writing/Publish JMP.command

MSG
exit 1
