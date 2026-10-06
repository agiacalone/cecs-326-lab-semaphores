#ifndef DUNGEON_INFO_H
#define DUNGEON_INFO_H
#include <stdbool.h>
#include <unistd.h>
#include "dungeon_settings.h"

/* These are static so that more than one .c file in a program can include
 * this header. Before Fa26 they were plain globals, and a program built from
 * two files that both included it failed to link with "multiple definition
 * of `dungeon_shm_name'". The unused attribute keeps -Wall quiet in files
 * that do not use all three. */
#if defined(__GNUC__) || defined(__clang__)
#define DUNGEON_UNUSED __attribute__((unused))
#else
#define DUNGEON_UNUSED
#endif

//This is the name we will use for our shared memory.
static const char* const dungeon_shm_name DUNGEON_UNUSED = "/DungeonMem";

//These are the names for the levers when getting the treasure at the end.
static const char* const dungeon_lever_one DUNGEON_UNUSED = "/LeverOne";
static const char* const dungeon_lever_two DUNGEON_UNUSED = "/LeverTwo";


struct Barbarian{
	int attack;
};
struct Rogue{
	float pick;
};
struct Wizard{
	char spell[SPELL_BUFFER_SIZE];
};
struct Barrier{
	char spell[SPELL_BUFFER_SIZE + 1];
};
struct Enemy{
	int health;
};
struct Trap{
	char direction;
	bool locked;
};
struct Dungeon{
	bool running;
	pid_t dungeonPID;
	struct Barbarian barbarian;
	struct Rogue rogue;
	struct Wizard wizard;
	/* Reserved by the dungeon. Do not read or write this — it is how the
	 * dungeon notices when something has written past the end of
	 * wizard.spell, which is the most common way this lab goes wrong. */
	unsigned char _guard[16];
	struct Barrier barrier;
	struct Enemy enemy;
	struct Trap trap;
	char treasure[4];
	char spoils[4];
};

//Call this method to begin running the dungeon. Valid pid's must be passed for it to work.
void RunDungeon(pid_t wizard, pid_t rogue, pid_t barbarian);
#endif
