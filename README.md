# SCUMM-8
## What is SCUMM-8?
SCUMM-8 is a "demake" of the [SCUMM](https://en.wikipedia.org/wiki/SCUMM) engine (which powered most of the classic LucasArts adventure games, such as Monkey Island and Maniac Mansion) for the [PICO-8 Fantasy Console](http://www.lexaloffle.com/pico-8.php).  

A playable sample game "Revenge of the SCUMM" can be [found here](http://www.lexaloffle.com/bbs/?tid=29176).

![SCUMM-8](http://i.imgur.com/FcE49f5.gif)  ![SCUMM-8](http://i.imgur.com/LO57HFN.gif)  ![SCUMM-8](http://i.imgur.com/3HiP7Jf.gif)

While it is heavily "inspired" by the SCUMM engine, it isn't a true replica (for that you'll want good ol' [SCUMM-VM](https://en.wikipedia.org/wiki/ScummVM)).  However, SCUMM-8 attempts to stay as true as possible to the original SCUMM API.
> *"Cool, so does that mean I can play those old LucasArts games in PICO-8?!"*

Er... no. SCUMM-8 cannot play those original games, just that it is intended to provide similar functionality within the (very limited) world of PICO-8.

> *"It don't work mate, waited forever and 'Monkey Island' never loaded!"*

Wow, really? You still here?! OK, once again. Think of SCUMM-8 as an even more retro "mini-me" version of the classic SCUMM engine. Most of the features are planned, but the experience will be... shall we say... "cut down".

> *"Got it. . . . so what about 'Day of the Tentacle' then?"*

\*sigh\* . . .  "Look behind you! It's a three-headed monkey!" . . . \*runs away\*

## Current Features
- [x] Multiple Rooms (up to 32, technically)
- [x] Pathfinding for walking
- [x] Dialogs between Actors
- [x] Cut-scenes
- [x] Camera system (pan-to, follow, static)
- [x] Room transitions ("iris", cut)
- [x] Customisable Verbs
- [x] Z-plane ordering of objects/actors
- [x] Global-level (background) & Room-level scripts
- [x] Game start-up script
- [x] Object dependencies
- [x] Replace Color (to allow re-use of room/object gfx)
- [x] Adjustable Room Brightness Levels
- [x] Screen "shake" effect
- [x] Proximity (between Actors/Objects)

## Planned Features
- [ ] Game Save/Load

## Getting Started
Please see the [SCUMM-8 Wiki](https://github.com/Liquidream/scumm-8/wiki) for details on how to get started creating your own SCUMM-8 game, as well as the the full API reference.

## Thanks & Useful Resources
A big thanks to [Aric Wilmunder](http://www.wilmunder.com/Arics_World/Games.html) (ex-LucasArts developer) for sharing valuable SCUMM documentation. 
Particularly the **SCUMM Tutorial **(1991), the example room from which was the first room I actually created in SCUMM-8 (minus the cool Sam & Max gfx, of course)

Thanks also to Dan Sanderson for his [picotool](https://github.com/dansanderson/picotool) - specifically his minifying tool (luamin), which enabled me to squeeze MUCH more code under PICO-8's limits.

Shoutout to **PixelArtM**, whose [PICO-8 mockup](https://twitter.com/PixelArtM/status/758735822426284036) inspired me to wonder whether this could *actually* be pulled off within the virtual console's limits (SPOILER: it can... just about! :sweat_smile:)

Some other great SCUMM resources I found along the way include the following:
- [Ron Gilbert's post about "SCUMM Script"](http://www.pagetable.com/?p=614)
- [The SCUMM Diary: Stories behind one of the greatest game engines ever made](http://www.gamasutra.com/view/feature/196009/the_scumm_diary_stories_behind_.php)
- [Ron Gilbert - Maniac Mansion postmortem from 2011 (Video)](https://youtu.be/WD64ExGHBWE)
- [ScummC - A Scumm Compiler (by Alban Bedel)](https://github.com/AlbanBedel/scummc)
  - (Particularly the OpenQuest example)
- [Ron Gilbert's post about "Puzzle Dependency Charts"](http://grumpygamer.com/puzzle_dependency_charts)

## Donation
As you can imagine, this project has taken **MANY HOURS** of my spare time to develop.  
So, if this project helped you out (and you're in a position to do so), feel free to buy me a drink! :coffee: :blush:

[![paypal](https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=334Y2ZXWUJMBQ)
