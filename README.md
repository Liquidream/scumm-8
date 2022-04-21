![SCUMM-8](https://i.imgur.com/uB6Igai.png) 
## What is SCUMM-8?
SCUMM-8 is a "demake" of the [SCUMM](https://en.wikipedia.org/wiki/SCUMM) engine (which powered most of the classic LucasArts adventure games, such as Monkey Island and Maniac Mansion) for the [PICO-8 Fantasy Console](http://www.lexaloffle.com/pico-8.php), created by [Paul Nicholas](https://www.liquidream.co.uk/).

[![Made With PICO-8](https://img.shields.io/badge/Made%20With-PICO--8-ff004d.svg?style=flat&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAlUlEQVQ4jWP8v5gBFTxOR%2BVXPfuPwp8SxIjCt%2BBG4TIxUBkMfgNZGIyi0IRmoobZxxeo0rcPocp%2FEEEJ08HvZaobyPj%2FjTpqmLAeJM2EtgMo3MHvZeqnw9X%2FXVHSUdhnP5Qw%2Fc%2B7CUVDS%2BsWFH6QpuyIT4cMT8xQBJI%2B1aHwj1%2F3RgnTVJbrKGH29egxFPWD38tUNxAAun4liexlTtMAAAAASUVORK5CYII%3D)](https://www.lexaloffle.com/pico-8.php)

See below for some games powered by SCUMM-8:

| [Return of the SCUMM](http://www.lexaloffle.com/bbs/?tid=29176)     | [H A L L O W EƎ N](https://liquidream.itch.io/hallowe3n)       | [CODE-8](https://gamejolt.com/games/code-8/340837)      | [Perfectly Normal Apartment](https://nextlevelbanana.itch.io/perfectly-normal-apartment)
|  :---: |  :---:  |  :---:  | :---:  |
| ![SCUMM-8](https://i.imgur.com/FcE49f5.gif) |  ![H A L L O W EƎ N](https://i.imgur.com/XpLWuVb.gif)      | ![CODE-8](https://i.imgur.com/CfwaNOn.gif)  | ![Perfectly Normal Apartment](https://i.imgur.com/V8V2uLC.gif) | 
| [(Play Online)](http://www.lexaloffle.com/bbs/?tid=29176)     | [(Play Online)](https://liquidream.itch.io/hallowe3n)       | [(Play Online)](https://gamejolt.com/games/code-8/340837)      | [(Play Online)](https://nextlevelbanana.itch.io/perfectly-normal-apartment)      |

While it is heavily "inspired" by the SCUMM engine, it isn't a true replica (for that you'll want good ol' [SCUMM-VM](https://en.wikipedia.org/wiki/ScummVM)).  However, SCUMM-8 attempts to stay as true as possible to the [original SCUMM command reference](https://web.archive.org/web/20180226005830/http://wilmunder.com/Arics_World/Games.html).
> *"Cool, so does that mean I can play those old LucasArts games in PICO-8?!"*

Er... no. SCUMM-8 cannot play those original games, just that it is intended to provide similar functionality within the (very limited) world of PICO-8.

> *"It don't work mate, waited forever and 'Monkey Island' never loaded!"*

Wow, really? You still here?! OK, once again. Think of SCUMM-8 as an even more retro "mini-me" version of the classic SCUMM engine. Most of the features are planned, but the experience will be... shall we say... "cut down".

> *"Got it. . . . so what about 'Day of the Tentacle' then?"*

\*sigh\* . . .  "Look behind you! It's a three-headed monkey!" . . . \*runs away\*

## Current Features
- [x] Multiple Rooms (Up to 32+ per cart)
- [x] Pathfinding for walking
- [x] Dialogs between Actors
- [x] Cut-scenes
- [x] Camera system (pan-to, follow, static)
- [x] Room transitions ("iris", cut)
- [x] Customisable Verbs
- [x] Fake 3D depth "Auto-Scaling" of Actors
- [x] Z-plane ordering of objects/actors
- [x] Custom scaling for Actors/Objects
- [x] Global-level (background) & Room-level scripts
- [x] Game start-up script
- [x] Object dependencies
- [x] Replace Color (to allow re-use of room/object gfx)
- [x] Adjustable Room Brightness Levels
- [x] Screen "shake" effect
- [x] Proximity (between Actors/Objects)
- [x] Animations for Actors and Objects
- [x] Multiple font sizes/styles

## Getting Started
Please see the [SCUMM-8 Wiki](https://github.com/Liquidream/scumm-8/wiki) for details on how to get started creating your own SCUMM-8 game, as well as the the full API reference.

## Building

Using Python 3:
```console
python build.py
```

This will output scumm-8.min.lua, containing the minified engine code which you can copy to your own cart. It will also output new copies of game.p8 and template.p8, which should be committed to the repository.

## Thanks & Useful Resources
A big thanks to [Aric Wilmunder](https://web.archive.org/web/20180226005830/http://wilmunder.com/Arics_World/Games.html) (ex-LucasArts developer) for sharing valuable SCUMM documentation. 
Particularly the **[SCUMM Tutorial](https://web.archive.org/web/20160721004826/http://www.wilmunder.com/Arics_World/Games_files/SCUMM%20Tutorial%200.1.pdf)** (1991), the example room from which was the first room I actually created in SCUMM-8 (minus the cool Sam & Max gfx, of course)

Thanks also to Dan Sanderson for his [picotool](https://github.com/dansanderson/picotool) - specifically his minifying tool (luamin), which enabled me to squeeze MUCH more code under PICO-8's limits.

Shoutout to **@PixelArtM**, whose [PICO-8 mockup](https://twitter.com/PixelArtM/status/758735822426284036) inspired me to wonder whether this could *actually* be pulled off within the virtual console's limits (and then later used SCUMM-8 to make said mockup [a reality!](https://twitter.com/PixelArtM/status/857193912229933056))

Some other great SCUMM resources I found along the way include the following:
- [Ron Gilbert's post about "SCUMM Script"](http://www.pagetable.com/?p=614)
- [The SCUMM Diary: Stories behind one of the greatest game engines ever made](http://www.gamasutra.com/view/feature/196009/the_scumm_diary_stories_behind_.php)
- [Ron Gilbert - Maniac Mansion postmortem from 2011 (Video)](https://youtu.be/WD64ExGHBWE)
- [ScummC - A Scumm Compiler (by Alban Bedel)](https://github.com/AlbanBedel/scummc)
  - (Particularly the OpenQuest example)
- [Ron Gilbert's post about "Puzzle Dependency Charts"](http://grumpygamer.com/puzzle_dependency_charts)

## Donation
As you can imagine, this project has taken **MANY HOURS** of spare time to develop.  
So, if this project helped you out (and you're in a position to do so), feel free to buy me a drink! :coffee: :blush:

[![paypal](https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=334Y2ZXWUJMBQ)
