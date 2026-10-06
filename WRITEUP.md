---
# WHO THIS IS. Fill both in before you submit.
#
# This repository is PRIVATE: you and I are the only people who can read it.
# I need these two lines to put your grade in Canvas against the right person:
# GitHub knows you as a username, Canvas knows you as a student, and this is
# the only place those two meet. A blank or wrong ID means a grade that lands
# on nobody, and I have to come find you to fix it.
name: "YOUR NAME AS IT APPEARS IN CANVAS"
student_id: "YOUR 9-DIGIT CSULB ID"
---

# The Dungeon: writeup

Four questions, 90 points. A few paragraphs each is plenty. Code snippets from
your own programs are welcome, and often the clearest answer. Write in your
own words: I am grading whether you can explain the mechanism, not whether you
can restate the README.

---

## 1. One struct, four processes (25 points)

Your four programs are separate processes with separate address spaces. Yet
when the Barbarian writes `attack`, the dungeon sees it.

Walk through how that happens in *your* code. Which process creates the shared
memory, and with which calls? Which calls does every other process make, and
which does it skip? What does `mmap` give back, and why can you use it as a
`struct Dungeon *`?

Then: `wizard.spell` holds 100 characters. What would happen to the rest of
the struct if the Wizard copied a longer string into it, and why would no
error appear at the moment of the copy?

<!-- your answer -->


---

## 2. The signal and the sleeping process (20 points)

Your characters spend nearly all their time waiting. Describe exactly what one
of your characters is doing while it waits, and what happens, step by step,
when the dungeon's signal arrives.

Your handler runs *instead of* the code that was waiting. What does
`SA_RESTART` change about that? What could go wrong if a handler is still
running when the next signal arrives?

<!-- your answer -->


---

## 3. Holding the door (30 points)

Trace the treasure room from the moment the dungeon sends `SEMAPHORE_SIGNAL` to
the moment the door closes. For each semaphore, give its value at each step and
say which process changed it, with which call.

Then answer both:

- What would the dungeon have seen if one of your characters posted its lever
  too early, before the Rogue had all four letters?
- What would it have seen if neither ever posted?

*"I called `sem_wait` and then `sem_post`" earns very little here.* Show the
sequence, and who is waiting on whom.

<!-- your answer -->


---

## 4. The race at the start (15 points)

`game` creates the shared memory, starts three processes, and then the dungeon
starts. If one of those processes reads `dungeon->running` before the dungeon
has set it, it sees `false`.

What does *your* code do in that window? Describe one ordering of events in
which a launcher like yours could lose the whole run, and say what in your code
prevents it, or admit that nothing does.

<!-- your answer -->


---

## Sources

If you used anything beyond the README, the OSTEP chapters and the manual
pages, such as a blog post, a classmate you talked it through with, or an AI
assistant that explained a concept, list it here. Citing is never penalised. Not citing
is.

<!-- your sources -->
