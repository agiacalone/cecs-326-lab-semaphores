# Your Makefile. Writing it is part of the lab (Milestone 1 in the README).
#
# Keep this first line. It gives you $(DUNGEON), $(DUNGEON_CFLAGS) and
# $(DUNGEON_LIBS); read dungeon/dungeon.mk for what each one is.
include dungeon/dungeon.mk

# Build four programs in the top folder of this repository:
#
#     game       from student/game.c
#     barbarian  from student/barbarian.c
#     wizard     from student/wizard.c
#     rogue      from student/rogue.c
#
# Each one is compiled with $(DUNGEON_CFLAGS), linked with $(DUNGEON), and
# linked with $(DUNGEON_LIBS) at the END of the command. Running `make` with
# no arguments must build all four. A `clean` target is a good idea.
