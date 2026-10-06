#!/usr/bin/env bash
#
# selfcheck.sh: your own check, not the grader.
#
# It builds your programs the way the grader does and runs the dungeon once.
# Passing it does not guarantee full marks; failing it does not mean zero.
# The grader runs the same dungeon with its own key and reads the receipt.
#
#   ./selfcheck.sh

set -u
PASS=0; FAIL=0
say()  { printf '%s\n' "$*"; }
ok()   { PASS=$((PASS+1)); say "  PASS  $1"; }
bad()  { FAIL=$((FAIL+1)); say "  FAIL  $1"; }

say "Checking your Makefile."
if grep -Eq '^[[:space:]]*include[[:space:]]+dungeon/dungeon\.mk' Makefile 2>/dev/null; then
    ok "Makefile includes dungeon/dungeon.mk"
else
    bad "Makefile does not include dungeon/dungeon.mk (keep the line that was there)"
fi
if grep -v '^[[:space:]]*#' Makefile 2>/dev/null | grep -q 'dungeon_x86_64\.o'; then
    bad "Makefile names the dungeon file directly; use \$(DUNGEON) (the grader's copy is elsewhere)"
elif grep -v '^[[:space:]]*#' Makefile 2>/dev/null | grep -q '\$(DUNGEON)'; then
    ok "Makefile links \$(DUNGEON)"
else
    bad "Makefile never uses \$(DUNGEON); link it into all four programs"
fi

say ""
say "Building."
if make >/tmp/selfcheck-make.$$ 2>&1 && [ -x game ] && [ -x barbarian ] && [ -x wizard ] && [ -x rogue ]; then
    ok "make builds game, barbarian, wizard and rogue"
else
    tail -15 /tmp/selfcheck-make.$$
    bad "make did not build all four programs"
    rm -f /tmp/selfcheck-make.$$
    say ""; say "$PASS passed, $FAIL failed."; exit 1
fi
rm -f /tmp/selfcheck-make.$$

say ""
say "Running the dungeon once. This takes a minute or two."
rm -f /dev/shm/DungeonMem /dev/shm/sem.LeverOne /dev/shm/sem.LeverTwo run-receipt.txt 2>/dev/null
timeout 200 ./game > selfcheck-run.txt 2>&1
if [ ! -f run-receipt.txt ]; then
    bad "the dungeon did not finish a run (no run-receipt.txt). Read selfcheck-run.txt"
    grep -iE 'no longer running|did not survive|not currently set up|Insufficient party|error' selfcheck-run.txt | head -5
else
    line=$(head -1 run-receipt.txt)
    pre=$(printf '%s' "$line" | sed -n 's/.*|pre=\([0-9]*\)\/.*/\1/p')
    tot=$(printf '%s' "$line" | sed -n 's/.*|score=\([0-9]*\)\/.*/\1/p')
    door=$(printf '%s' "$line" | sed -n 's/.*|door=\([0-9]*\)|.*/\1/p')
    ok "the dungeon finished a run"
    [ "${pre:-0}" -ge 140 ] && ok "before semaphores: $pre/140" || bad "before semaphores: ${pre:-0}/140"
    tre=$(( ${tot:-0} - ${pre:-0} ))
    [ "$tre" -ge 220 ] && ok "treasure: $tre/220" || bad "treasure: $tre/220"
    [ "${door:-0}" = 1 ] && ok "the door closed behind the Rogue" || bad "the door did not close behind the Rogue in time"
fi
if grep -q 'wrote past the end' selfcheck-run.txt 2>/dev/null; then
    bad "the dungeon caught a write past the end of wizard.spell"
fi

say ""
say "$PASS passed, $FAIL failed. Full output: selfcheck-run.txt"
[ "$FAIL" -eq 0 ]
