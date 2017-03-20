# SCUMM-8
## What is SCUMM-8?
SCUMM-8 is a PICO-8 "demake" of the [SCUMM](https://en.wikipedia.org/wiki/SCUMM) engine that powered most of the classic LucasArts adventure games, such as Monkey Island and Maniac Mansion.  
However, it is only (heavily) inspired by the SCUMM engine, not a true replica - for that you'll want good ol' [SCUMM-VM](https://en.wikipedia.org/wiki/ScummVM).
#### *"Cool, so does that mean I can play those games in PICO-8?!"*
Er... no. SCUMM-8 cannot play the old games, just that it is intended to provide similar functionality within the (very limited) world of PICO-8.
#### *"It don't work mate, waited forever and 'Monkey Island' never loaded!"*
Wow, really? You still here?! OK, once again. Think of SCUMM-8 as an even more retro "mini-me" version of the classic SCUMM engine. Most of the features are planned, but the experience will be... shall we say... "cut down".
#### *"Got it. . . . so what about 'Day of the Tentacle' then?"*
\*sigh\* . . .  "Look behind you! It's a three-headed monkey!" . . . \*runs away\*

## Current Features
- [x] Multiple Rooms (up to 32, technically)
- [x] Pathfinding for walking
- [x] Dialogs between Actors
- [x] Cut-scenes
- [x] Camera system (pan-to, follow, static)
- [x] Customisable Verbs
- [x] Z-plane ordering of objects/actors
- [x] Global-level (background) & Room-level scripts
- [x] Game start-up script
- [x] Object dependencies
- [x] Replace Color (to allow re-use of room/object gfx)

## Planned Features
- [ ] Cut-scene transitions
- [ ] Game Save/Load

## Thanks & Useful Resources
A big thanks to [Aric Wilmunder](http://www.wilmunder.com/Arics_World/Games.html) (ex-LucasArts developer) for sharing valuable SCUMM documentation. 
Particularly the **SCUMM Tutorial **(1991), the example room from which was the first room I actually created in SCUMM-8 (minus the cool Sam & Max gfx, of course)

Some other great SCUMM resources I found along the way include the following:
- [Ron Gilbert's post about "SCUMM Script"](http://www.pagetable.com/?p=614)
- [ScummC - A Scumm Compiler (by Alban Bedel)](https://github.com/AlbanBedel/scummc)
 - (Particularly the OpenQuest example)
- [Ron Gilbert - Maniac Mansion postmortem in 2011 (Video)](https://youtu.be/wNpjGvJwyL8)
- [Ron Gilbert's post about "Puzzle Dependency Charts"](http://grumpygamer.com/puzzle_dependency_charts)
