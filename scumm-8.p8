pico-8 cartridge // http://www.pico-8.com
version 10
__lua__

-- scumm-8
-- paul nicholas

-- python c:\users\pauln\owncloud\dev\pico-8\picotool\p8tool luamin c:\users\pauln\owncloud\games\pico-8\carts\git_repos\scumm-8\scumm-8.p8

-- ### luamin fixes ###
--	"\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92"

-- was 6439 tokens

-- ==================================================
-- token saving todo's:
-- [x] change cam from object to separate variables
-- [x] change cursor from object to separate variables
-- [x] change hover_curr from object to separate variables
-- [ ] 
-- [ ] 
-- ==================================================

-- debugging
show_debuginfo = true
show_collision = true
show_perfinfo = true
enable_mouse = true
d = printh

-- game verbs (used in room definitions and ui)
verbs = {
	--{verb = verb_ref_name}, text = display_name ....bounds{},x,y...
	{ { open = "open" }, text = "open" },
	{ { close = "close" }, text = "close" },
	{ { give = "give" }, text = "give" },
	{ { pickup = "pickup" }, text = "pick-up" },
	{ { lookat = "lookat" }, text = "look-at" },
	{ { talkto = "talkto" }, text = "talk-to" },
	{ { push = "push" }, text = "push" },
	{ { pull = "pull" }, text = "pull"},
	{ { use = "use" }, text = "use"}
}
-- verb to use when just clicking aroung (e.g. move actor)
verb_default = {
	{ walkto = "walkto" }, text = "walk to"
} 


verb_maincol = 12  -- main color (lt blue)
verb_hovcol = 7   -- hover color (white)
verb_shadcol = 1   -- shadow (dk blue)
verb_defcol = 10    -- default action (yellow)

-- object states
states = {
	closed = 1,
	off = 1,
	gone = 1,
	open = 2,
	on = 2,
	here = 2
}

-- prepositions { " ", " in", " with", " on", " to" },   // english
--[[void resetsentence()
{
		variables[variablesentenceverb.value] = variables[variablebackupverb.value];
		variables[variablesentenceobject1.value] = 0;
		variables[variablesentenceobject2.value] = 0;
		variables[variablesentencepreposition.value] = 0;
}]]

-- object classes (bitflags)
class_untouchable = 1 -- will not register when the cursor moves over it. the object is invisible to the user.
class_pickupable = 2  -- can be placed in actor inventory
class_talkable = 4		-- can talk to actor/object
class_giveable = 8		-- can be given to an actor/object
class_openable = 16   -- can be opened/closed
class_actor = 32      -- is an actor/person

cut_noverbs = 1 		-- this removes the interface during the cut-scene.
cut_hidecursor = 2  -- this turns off the cursor during the cut-scene.
--cut_no_follow = 4  -- this disables the follow-camera being reinstated

-- actor constants
face_front = 1	-- states for actor direction
face_left = 2   -- (not sprite #'s)
face_back = 3		
face_right = 4
--
pos_infront = 1 
pos_behind = 3
pos_left = 2
pos_right = 4
pos_inside = 5

-- actor animations
anim_face = 1	 -- position the actor immediately to the direction indicated
anim_turn = 2  -- show the turning stages of animation


-- #######################################################
-- room definitions
-- 
rooms = {

	first_room = {
		map_x = 0,
		map_y = 0,
		col_replace = { 
			{ 7, 15 }, 
			-- { 4, 5 }, 
			-- { 6, 8 } 
		},
		--sounds = {},
		enter = function(me)
			-- animate fireplace
			--d("scr:"..type(me.scripts.anim_fire))
			start_script(me.scripts.anim_fire, true) -- bg script
		end,
		exit = function(me)
			-- todo: anything here?
			stop_script(me.scripts.anim_fire)
		end,
		lighting = 0, -- state of lights in current room
		scripts = {	  -- scripts that are at room-level
			anim_fire = function()
				while true do
					for f=1,3 do
						set_state("fire", f)
						break_time(8)
					end
				end
			end,
			spin_top = function()
				while true do	
					for f=1,3 do
						set_state("spinning top", f)
						break_time(8)
					end
				end
			end		
		},
		objects = {
			fire = {
				name = "fire",
				state = 1, --"frame1",
				x = 8*8, -- (*8 to use map cell pos)
				y = 4*8,
				states = {145, 146, 147},
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				--trans_col = 0,
				--use_pos (defaults to spr bottom)
				use_dir = face_back,
				use_pos = pos_infront,

				dependent_on = "front door",	-- object is dependent on the state of another
				dependent_on_state = states.closed,

				verbs = {
					lookat = function()
						say_line("it's a nice, warm fire...")
						wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_turn, face_front)
						say_line("ouch! it's hot!;*stupid fire*")
						wait_for_message()
					end,
					talkto = function()
						say_line("'hi fire...'")
						wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_turn, face_front)
						say_line("the fire didn't say hello back;burn!!")
						wait_for_message()
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
				}
			},
			front_door = {
				name = "front door",
				class = class_openable,
				state = states.closed,
				x = 1*8, -- (*8 to use map cell pos)
				y = 2*8,
				elevation = -10, -- force to always be bg
				states = { -- states are spr values
					143, -- states.closed
					0   -- states.open
				},
				--flip_x = false, -- used for flipping the sprite
				--flip_y = false,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 4,  --
				use_pos = pos_right,
				use_dir = face_left,
				verbs = {
					walkto = function(me)
						if state_of(me) == states.open then
							-- go to new room!
							come_out_door(rooms.outside_room.objects.front_door) --, outside_room)
						else
							say_line("the door is closed")
						end
					end,
					open = function(me)
						open_door(me, rooms.outside_room.objects.front_door)
					end,
					close = function(me)
						close_door(me, rooms.outside_room.objects.front_door)
					end
				}
			},
			hall_door_kitchen = {
				name = "kitchen",
				state = states.open,
				x = 14 *8, -- (*8 to use map cell pos)
				y = 2 *8,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 4,  --
				use_pos = pos_left,
				use_dir = face_right,
				verbs = {
					walkto = function()
						-- go to new room!
						come_out_door(rooms.second_room.objects.kitchen_door_hall) --, second_room) -- ()
					end
				}
			},
			bucket = {
				name = "bucket",
				class = class_pickupable,
				state = states.open,
				x = 13 *8, -- (*8 to use map cell pos)
				y = 6 *8,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				states = { -- states are spr values
					207,  -- closed
					223 -- open
				},
				trans_col=15,
				--owner (set on pickup)
				--[dependent-on object-name being object-state]
				verbs = {
					lookat = function(me)
						if owner_of(me) == selected_actor then
							say_line("it is a bucket in my pocket")
						else
							say_line("it is a bucket")
						end
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
					--[[use = function(me, noun2)
						if (noun2.name == "window") then
							set_state("window", states.open)
						end
					end]]
				}
			},
			spinning_top = {
				name = "spinning top",
				state = 1,
				x = 2*8, -- (*8 to use map cell pos)
				y = 6*8,
				states = { 192, 193, 194 },
				col_replace = { -- replace colors (orig,new)
					{ 12, 7 } 
				},
				trans_col=15,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				verbs = {
					push = function(me)
						if script_running(room_curr.scripts.spin_top) then
							stop_script(room_curr.scripts.spin_top)
							set_state(me, 1)
						else
							start_script(room_curr.scripts.spin_top)
						end
					end,
					pull = function(me)
						stop_script(room_curr.scripts.spin_top)
						set_state(me, 1)
					end
				}
			},
			window = {
				name = "window",
				class = class_openable,
				state = states.closed,
				use_dir = face_back,

				-- todo: make this calculated, by closed walkable pos!
				use_pos = { x = 5 *8, y = (7 *8)+1},

				x = 4*8, -- (*8 to use map cell pos)
				y = 1*8,
				w = 2,	-- relates to spr or map cel, depending on above
				h = 2,  --
				states = {  -- states are spr values
					132, -- closed
					134  -- open
				},
				verbs = {
					open = function(me)
						cutscene(cut_noverbs + cut_hidecursor, 
							function()
								-- todo: cutscene code
								print_line("*creak*",40,20,8,1)
								wait_for_message()
								change_room(rooms.second_room)
								selected_actor = actors.purp_tentacle
								walk_to(selected_actor, 
									selected_actor.x+10, 
									selected_actor.y)
								say_line("what was that?!")
								wait_for_message()
								say_line("i'd better check...")
								wait_for_message()
								walk_to(selected_actor, 
									selected_actor.x-10, 
									selected_actor.y)
								change_room(rooms.first_room)
								-- wait for a bit, then appear in room1
								break_time(50)
								selected_actor.x = 115
								selected_actor.y = 44
								selected_actor.in_room = rooms.first_room
								walk_to(selected_actor, 
									selected_actor.x-10, 
									selected_actor.y)
								say_line("intruder!!!")
								wait_for_message()
							end
						)
					end
				}
			}
		}
	},

	second_room = {
		map_x = 16,
		map_y = 0,
		map_x1 = 39, 	-- map coordinates to draw to (x,y)
		map_y1 = 7,
		enter = function()
			-- todo: anything here?
		end,
		exit = function()
			-- todo: anything here?
		end,
		scripts = {	  -- scripts that are at room-level
		},
		objects = {
			kitchen_door_hall = {
				name = "hall",
				state = states.open,
				x = 1 *8, -- (*8 to use map cell pos)
				y = 2 *8,
				w = 1,	-- relates to spr
				h = 4,  --
				use_pos = pos_right,
				use_dir = face_left,
				verbs = {
					walkto = function()
						-- go to new room!
						come_out_door(rooms.first_room.objects.hall_door_kitchen) --, first_room)
					end
				}
			},
			back_door = {
				name = "back door",
				class = class_openable,
				state = states.closed,
				x = 22*8, -- (*8 to use map cell pos)
				y = 2*8,
				elevation = -10, -- force to always be bg
				states = {
					-- states are spr values
					143, -- closed
					0   -- open
				},
				flip_x = true, -- used for flipping the sprite
				w = 1,	-- relates to spr or map cel, depending on above
				h = 4,  --
				use_pos = pos_left,
				use_dir = face_right,
				verbs = {
					walkto = function(me)
						if state_of(me) == states.open then
							-- go to new room!
							come_out_door(rooms.first_room.objects.front_door) --, first_room)
						else
							say_line("the door is closed")
						end
					end,
					open = function(me)
						open_door(me, rooms.first_room.objects.front_door)
					end,
					close = function(me)
						close_door(me, rooms.first_room.objects.front_door)
					end
				}
			},
		},
	},
	
	outside_room = {
		map_x = 16,
		map_y = 8,
		map_x1 = 47, 	-- map coordinates to draw to (x,y)
		map_y1 = 15,
		enter = function(me)
			-- todo: anything here?
		end,
		exit = function(me)
			-- todo: anything here?
		end,
		scripts = {	  -- scripts that are at room-level
		},
		objects = {
			rail_left = {
				class = class_untouchable,
				x = 10*8, -- (*8 to use map cell pos)
				y = 3*8,
				state = 1,
				states = { 111 },
				w = 1,	-- relates to spr or map cel, depending on above
				h = 2,  --
				repeat_x = 8		-- repeat/tile the sprite in x dir
			},
			rail_right= {
				class = class_untouchable,
				x = 22*8, -- (*8 to use map cell pos)
				y = 3*8,
				state = 1,
				states = { 111 },
				w = 1,	-- relates to spr or map cel, depending on above
				h = 2,  --
				repeat_x = 8		-- repeat/tile the sprite in x dir
			},
			front_door = {
				name = "front door",
				class = class_openable,
				state = states.closed,
				x = 19*8, -- (*8 to use map cell pos)
				y = 1*8,
				states = {
					-- states are spr values
					142, -- closed
					0   -- open
				},
				flip_x = true, -- used for flipping the sprite
				w = 1,	-- relates to spr or map cel, depending on above
				h = 3,  --
				use_pos = pos_infront,
				use_dir = face_back,
				verbs = {
					walkto = function(me)
						if state_of(me) == states.open then
							-- go to new room!
							come_out_door(rooms.first_room.objects.front_door) --, first_room)
						else
							say_line("the door is closed")
						end
					end,
					open = function(me)
						open_door(me, rooms.first_room.objects.front_door)
					end,
					close = function(me)
						close_door(me, rooms.first_room.objects.front_door)
					end
				}
			},
		},
	}


}



-- set which room to start the game in 
-- (could be a "pseudo" room for title screen!)
--selected_room = rooms.first_room
--selected_room = rooms.second_room
selected_room = rooms.outside_room


-- #######################################################
-- actor definitions
-- 

actors = {
	main_actor = { 		-- initialize the actor object
		--name = "",
		class = class_actor,
		x = 127/2 + 80,
		y = 127/2 -24,
		w = 1,
		h = 4,
		face_dir = face_front, 	-- direction facing
		idle = { 1, 3, 5, 3},	-- sprites for idle (front, left, back, right) - right=flip
		talk = { 6, 22, 21, 22},
		walk_anim = { 2, 3, 4, 3},
		--flip = false, 		-- used for flipping the sprite (left/right dir)
		col = 12,				-- speech text colour
		trans_col = 11,
		speed = 0.6,  	-- walking speed
	},
	purp_tentacle = {
		name = "purple tentacle",
		class = class_talkable + class_actor,
		x = 127/2 - 24,
		y = 127/2 -16,
		w = 1,
		h = 3,
		face_dir = face_front,
		idle = { 30, 30, 30, 30 },
		talk = { 47, 47, 47, 47 },
		col = 13,    		-- speech text colour
		trans_col = 15,
		speed = 0.25,  	-- walking speed
		use_pos = pos_left,
		--in_room = rooms.first_room,
		in_room = rooms.second_room,
		verbs = {
				lookat = function()
					say_line(selected_actor, "it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(cut_noverbs, function()
						--actorface( actor1, actor2 )
						say_line(me,"what do you want?")
						wait_for_message()
					end)
					-- dialog loop
					while (not sentence_curr or sentence_curr.num != 4) do
						--d("start dialog")
						while (true) do
							-- build dialog options
							dialog_add("where am i?")
							dialog_add("who are you?")
							dialog_add("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?")
							dialog_add("nevermind")
							dialog_start(selected_actor.col, 7)
							-- wait for selection
							while not sentence_curr do break_time() end
							break
						end
						-- chosen options
						dialog_end()
						cutscene(cut_noverbs, function()
							say_line(sentence_curr.msg)
							wait_for_message()
							
							d("sentence num: "..sentence_curr.num)
							if sentence_curr.num == 1 then
								say_line(me, "you are in paul's game")
								wait_for_message()
							elseif sentence_curr.num == 2 then
								say_line(me, "it's complicated...")
								wait_for_message()
							elseif sentence_curr.num == 3 then
								say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
								wait_for_message()
							elseif sentence_curr.num == 4 then
								say_line(me, "ok bye!")
								wait_for_message()
								return -- exit dialog loop
							end
						end)
					end --dialog loop
				end
			}
	}
}

-- set which actor the player controls by default
selected_actor = actors.main_actor


-- logic used to determine a "default" verb to use
-- (e.g. when you right-click an object)
function find_default_verb(obj)
  local default_verb = nil

	if has_flag(obj.class, class_talkable) then
		default_verb = "talkto"
	elseif has_flag(obj.class, class_openable) then
		if obj.state == states.closed then
			default_verb = "open"
		else
			default_verb = "close"
		end
	else
		default_verb = "lookat"
	end

	-- now find the full verb definition
	for v in all(verbs) do
		vi = get_verb(v)
		if (vi[2] == default_verb) then default_verb=v break end
	end
	return default_verb
end

-- actions to perform when object doesn't have an entry for verb
function unsupported_action(verb, obj1, obj2)
	d("verb:"..verb.." , obj:"..obj1.name)

	if verb == "walkto" then
		return

	elseif verb == "pickup" then
		if has_flag(obj1.class, class_actor) then
			say_line("i don't need them")
		else
			say_line("i don't need that")
		end

	elseif verb == "use" then
		if has_flag(obj1.class, class_actor) then
			say_line("i can't just *use* someone")
		end
		if obj2 then
			if has_flag(obj2.class, class_actor) then
				say_line("i can't use that on someone!")
			else
				say_line("that doesn't work")
			end
		end

	elseif verb == "give" then
		if has_flag(obj1.class, class_actor) then
			say_line("i don't think i should be giving this away")
		else
			say_line("i can't do that")
		end

	elseif verb == "lookat" then
		if has_flag(obj1.class, class_actor) then
			say_line("i think it's alive")
		else
			say_line("looks pretty ordinary")
		end

	elseif verb == "open" then
		if has_flag(obj1.class, class_actor) then
			say_line("they don't seem to open")
		else
			say_line("it doesn't seem to open")
		end

	elseif verb == "close" then
		if has_flag(obj1.class, class_actor) then
			say_line(s"they don't seem to close")
		else
			say_line("it doesn't seem to close")
		end

	elseif verb == "push" or verb == "pull" then
		if has_flag(obj1.class, class_actor) then
			say_line("moving them would accomplish nothing")
		else
			say_line("it won't budge!")
		end

	elseif verb == "talkto" then
		if has_flag(obj1.class, class_actor) then
			say_line("erm... i don't think they want to talk")
		else
			say_line("i am not talking to that!")
		end

	else
		say_line("hmm. no.")
	end
end 












-- #######################################################
-- internal scumm-8 workings
-- 


-- global vars
screenwidth = 127
screenheight = 127
stage_top = 16

-- offset to display speech above actors (dist in px from their feet)
text_offset = (selected_actor.h-1)*8

cam_x = 0
cam_max = 0 	-- the maximum x position the camera can move to in the current room
cam_min = 0  	-- the minimum x position the camera can move to in the current room
cam_mode = 0 	-- 0=follow, 1=static, 2=pan-to
cam_following_actor = selected_actor

--[[
cam = {
	x = 0,
	max = 0, -- the maximum x position the camera can move to in the current room
	min = 0,  -- the minimum x position the camera can move to in the current room
	mode = 0, -- 0=follow, 1=static, 2=pan-to
	following_actor = selected_actor,
	-- pan_to_x=0
	-- pan_to_y=0
}]]

cursor_x = screenwidth / 2
cursor_y = screenheight / 2
cursor_lvl = 1 	-- for cutscenes (<=0 - disable cursor)
cursor_tmr = 0 	-- used to animate cursor col
cursor_cols = {7,12,13,13,12,7}
cursor_colpos = 1

--[[cursor = {
  x = screenwidth/2,
  y = screenheight/2,
	lvl = 1, -- for cutscenes (<=0 - disable cursor)
  tmr = 0, -- used to animate cursor col
  cols = {7,12,13,13,12,7},
  colpos = 1 
}]]

-- keeps reference to currently hovered items
-- e.g. objects, ui elements, etc.
--hover_curr...
	-- verb, 
	-- default_verb,
	-- object, 
	-- dialog sentence
	-- ui_arrow

ui_arrows = {
	{ spr = 16, x = 75, y = stage_top + 60 },
	{ spr = 48, x = 75, y = stage_top + 72 }
}


last_mouse_x = 0
last_mouse_y = 0
-- wait for button release before repeating action
ismouseclicked = false

room_curr = nil			-- contains the current room definition
verb_curr = nil 		--verb_default
noun1_curr = nil 		-- main/first object in command
noun2_curr = nil 		-- holds whatever is used after the preposition (e.g. "with <noun2>")
cmd_curr = "" 			-- contains last displayed or actioned command
executing_cmd = false
talking_curr = nil 	-- currently displayed speech {x,y,col,lines...}
dialog_curr = nil   -- currently displayed dialog options to pick
sentence_curr = nil -- selected dialog sentence
cutscene_curr = nil -- currently active cutscene
talking_actor = nil -- currently talking actor

global_scripts = {}	-- table of scripts that are at game-level (background)
local_scripts = {}	-- table of scripts that are actively running
cutscenes = {} 			-- table of scripts for the active cutscene(s)
draw_zplanes = {}		-- table of tables for each of the (8) zplanes for drawing depth

-- game loop

function _init()
	-- use mouse input?
	if (enable_mouse) then poke(0x5f2d, 1) end

	-- init actor
	selected_actor.in_room = selected_room

	-- init all the rooms
	game_init()

	-- load the initial room
	change_room(selected_room)
end

function _update60()  -- _update()
	game_update()
end

function _draw()
	game_draw()
end

-- update functions

function game_update()
	-- process selected_actor threads/actions
	if selected_actor.thread and not coresume(selected_actor.thread) then
		selected_actor.thread = nil
	end

	-- global scripts (always updated - regardless of cutscene)
	update_scripts(global_scripts)

	-- update active cutscene (if any)
	if cutscene_curr then
		--d("playing cutscene...")
		if cutscene_curr.thread and not coresume(cutscene_curr.thread) then
			-- cutscene ended, restore prev state	
			if (room_curr != cutscene_curr.paused_room) then change_room(cutscene_curr.paused_room) end
			selected_actor = cutscene_curr.paused_actor
			cam_mode = cutscene_curr.paused_cam_mode
			cam_following_actor = cutscene_curr.paused_cam_following
			-- now delete cutscene
			del(cutscenes, cutscene_curr)
			cutscene_curr = nil
			-- any more cutscenes?
			if (#cutscenes > 0) then
				cutscene_curr = cutscenes[#cutscenes]
			end
		end
	else
		-- no cutscene...
		-- update all the active scripts (local + global)
		-- (will auto-remove those that have ended)
	
		-- local/room-level scripts
		update_scripts(local_scripts)		
	end

	-- player/ui control
	playercontrol()

	-- check for collisions
	checkcollisions()
end


function game_draw()
	-- clear screen every frame?
	rectfill(0, 0, screenwidth, screenheight, 0)

	-- auto-follow camera?
	if cam_mode == 0 then
		cam_x = mid(0, selected_actor.x - 64, (room_curr.map_w*8)-screenwidth-1)
	end
	camera(cam_x, 0)

	-- clip room bounds
	clip(0, stage_top, screenwidth+1, 64)

	-- draw room (bg + objects + actors)
	room_draw()

	-- reset camera for "static" content
	camera(0,0)
	-- reset clip
	clip()

	if (show_perfinfo) then 
		print("cpu: "..flr(100*stat(1)).."%", 0, stage_top - 16, 8) 
		print("mem: "..flr(stat(0)/1024*100).."%", 0, stage_top - 8, 8)
	end
	if (show_debuginfo) then print("x: "..cursor_x.." y:"..cursor_y-stage_top, 80, stage_top - 8, 8) end

	-- draw active text
	talking_draw()

	-- in dialog mode?
	if dialog_curr and dialog_curr.visible then
		-- draw dialog sentences?
		dialog_draw()
		cursor_draw()
		-- skip rest
		return
	end

 -- --------------------------------------------------------------
 -- hack:
 -- skip draw if just exited a cutscene
 -- as could be going straight into a dialog
 -- (would prefer a better way than this, but couldn't find one!)
 -- --------------------------------------------------------------
	if (cutscene_curr_lastval == cutscene_curr) then
		--d("cut_same")
	else
		--d("cut_diff")
		cutscene_curr_lastval = cutscene_curr
		return
	end
	

	-- draw current command (verb/object)
	if not cutscene_curr then
		command_draw()
	end

	-- draw ui and inventory
	if (not cutscene_curr
		or not has_flag(cutscene_curr.flags, cut_noverbs))
		-- and not just left a cutscene
		and (cutscene_curr_lastval == cutscene_curr) then
		ui_draw()
	else
		--d("ui skipped")
	end

	-- hack: fix for display issue (see above hack info)
	cutscene_curr_lastval = cutscene_curr

	if not cutscene_curr
		--or not has_flag(cutscene_curr.flags, cut_hidecursor) 
		then
		cursor_draw()
	end
end


-- handle button inputs
function playercontrol()	

	-- check for cutscene "skip"
	if cutscene_curr then
		if (btnp(4)) and (btnp(5)) then 
			-- todo: skip cutscene!
		end
		-- either way - don't allow other user actions!
		return
	end

	-- 
	if (btn(0)) then cursor_x = cursor_x - 1 end
	if (btn(1)) then cursor_x = cursor_x + 1 end
	if (btn(2)) then cursor_y = cursor_x - 1 end
	if (btn(3)) then cursor_y = cursor_x + 1 end

	if (btnp(4)) then input_button_pressed(1) end
	if (btnp(5)) then input_button_pressed(2) end

	-- only update position if mouse moved
	if (enable_mouse) then	
		if (stat(32)-1 != last_mouse_x) then cursor_x = stat(32)-1 end	-- mouse xpos
		if (stat(33)-1 != last_mouse_y) then cursor_y = stat(33)-1	end -- mouse ypos
		-- don't repeat action if same press/click
		if (stat(34) > 0) then
			if (not ismouseclicked) then
				input_button_pressed(stat(34))
				ismouseclicked = true
			end
		else
			ismouseclicked = false
		end
		-- store for comparison next cycle
		last_mouse_x = stat(32)-1
		last_mouse_y = stat(33)-1
	end

	-- keep cursor within screen
	cursor_x = max(cursor_x, 0)
	cursor_x = min(cursor_x, 127)
	cursor_y = max(cursor_y, 0)
	cursor_y = min(cursor_y, 127)
end

-- 1 = z/lmb, 2 = x/rmb, (4=middle)
function input_button_pressed(button_index)	

	local verb_in = verb_curr

	-- check for sentence selection
	if dialog_curr and dialog_curr.visible then
		if hover_curr_sentence then
			sentence_curr = hover_curr_sentence
		end
		-- skip remaining
		return
	end


	if hover_curr_verb then
		verb_curr = get_verb(hover_curr_verb)
		d("verb = "..verb_curr[2])

	elseif hover_curr_object then
		-- if valid obj, complete command
		-- else, abort command (clear verb, etc.)
		if button_index == 1 then
			if verb_curr[1] == "use" and noun1_curr then
				noun2_curr = hover_curr_object
				d("noun2_curr = "..noun2_curr.name)					
			else
				noun1_curr = hover_curr_object						
				d("noun1_curr = "..noun1_curr.name)
			end

		elseif hover_curr_default_verb then
			-- perform default verb action (if present)
			verb_curr = get_verb(hover_curr_default_verb)
			noun1_curr = hover_curr_object
			d("n1 tpe:"..type(noun1_curr))
			get_keys(noun1_curr)
			d("name:"..noun1_curr.name)
			-- force repaint of command (to reflect default verb)
			command_draw()
		end
	
	elseif hover_curr_arrow then
		-- todo: ui arrow clicked...
		return

	--[[elseif k == "inv_object" then
		-- todo: inventory object clicked
		break]]
	else
		-- what else could there be? actors!?
	end

	-- attempt to use verb on object
	if (noun1_curr != nil) then
		-- are we starting a 'use' command?
		if verb_curr[2] == "use" then
			if noun2_curr then
				-- 'use' part 2
			else
				-- 'use' part 1 (e.g. "use hammer")
				-- wait for noun2 to be set
				return
			end
		end

		-- execute verb script
		executing_cmd = true
		selected_actor.thread = cocreate(function(actor, obj, verb, noun2)
			if not obj.owner then
				-- walk to use pos and face dir
				--todo: find nearest usepos if none set?
				d("obj x="..obj.x..",y="..obj.y)
				d("obj w="..obj.w..",h="..obj.h)
				dest_pos = get_use_pos(obj)
				d("dest_pos x="..dest_pos.x..",y="..dest_pos.y)
				if (obj.offset_x) then d("offset x="..obj.offset_x..",y="..obj.offset_y) end
				walk_to(selected_actor, dest_pos.x, dest_pos.y)
				-- abort if walk was interrupted
				d(".moving="..selected_actor.moving)
				if selected_actor.moving != 2 then return end
				-- default use direction
				use_dir=selected_actor.face_dir
				if (obj.use_dir and (verb != verb_default)) then use_dir = obj.use_dir end
				-- anim to use dir
				do_anim(selected_actor, anim_turn, use_dir)
			end
			-- does current object support active verb?
			if valid_verb(verb,obj) then
				-- finally, execute verb script
				d("verb_obj_script!")
				d("verb = "..verb[2])
				d("obj = "..obj.name)
				start_script(obj.verbs[verb[1]], false, obj, noun2)
			--elseif verb[2] != verb_default[2] then
			 --	-- e.g. "i don't think that will work"
			--	unsupported_action(verb[2], obj, noun2)
			else
				-- e.g. "i don't think that will work"
				unsupported_action(verb[2], obj, noun2)
			end
			-- clear current command
			clear_curr_cmd()
		end)
		coresume(selected_actor.thread, selected_actor, noun1_curr, verb_curr, noun2_curr)
	elseif (cursor_y > stage_top and cursor_y < stage_top+64) then
		-- in map area
		executing_cmd = true
		-- attempt to walk to target
		selected_actor.thread = cocreate(function(x,y)
			walk_to(selected_actor, x, y)
			-- clear current command
			clear_curr_cmd()
		end)
		coresume(selected_actor.thread, cursor_x, cursor_y - stage_top)
	end

	d("--------------------------------")
end

-- collision detection
function checkcollisions()
	-- reset hover collisions
	hover_curr_verb = nil
	hover_curr_default_verb = nil
	hover_curr_object = nil
	hover_curr_sentence = nil
	hover_curr_arrow = nil

	--hover_curr = {}

	-- are we in dialog mode?
	if dialog_curr and dialog_curr.visible then
		for s in all(dialog_curr.sentences) do
			if iscursorcolliding(s) then
				hover_curr_sentence = s
			end
		end
		-- skip remaining collisions
		return
	end

	-- reset zplane info
	reset_zplanes()

	-- check room/object collisions
	for k,obj in pairs(room_curr.objects) do
		-- capture bounds (even for "invisible", but not untouchable/dependent, objects)
		if (not obj.class
			 or (obj.class and obj.class != class_untouchable))
			and (not obj.dependent_on 			-- object has a valid dependent state?
			 or find_object(obj.dependent_on).state == obj.dependent_on_state) 
		then
			recalc_bounds(obj, obj.w*8, obj.h*8, cam_x, cam_y)
		else
			-- reset bounds
			obj.bounds = nil
		end

		if iscursorcolliding(obj) then
			hover_curr_object = obj
		end
		-- recalc z-plane
		recalc_zplane(obj)
	end

	-- check actor collisions
	for k,actor in pairs(actors) do
		if (actor.in_room == room_curr) then
			recalc_bounds(actor, actor.w*8, actor.h*8, cam_x, cam_y)
			-- recalc z-plane
			recalc_zplane(actor)
			-- are we colliding (ignore self!)
			if iscursorcolliding(actor)
		 	 and actor != selected_actor then
				hover_curr_object = actor
			end
		end
	end

	-- check ui/inventory collisions
	for v in all(verbs) do
		if iscursorcolliding(v) then
			hover_curr_verb = v
		end
	end
	for a in all(ui_arrows) do
		if iscursorcolliding(a) then
			hover_curr_arrow = a
		end
	end
	-- check room/object collisions
	for k,obj in pairs(selected_actor.inventory) do
		if iscursorcolliding(obj) then
			hover_curr_object = obj
		end
	end

	-- default to walkto (if nothing set)
	if (verb_curr == nil) then
		verb_curr = get_verb(verb_default)
	end

	-- update "default" verb for hovered object (if any)
	if hover_curr_object then
		hover_curr_default_verb = find_default_verb(hover_curr_object)
	end
end


function reset_zplanes()
	draw_zplanes = {}
	for x=1,64 do
		draw_zplanes[x] = {}
	end
end

function recalc_zplane(obj)
	-- determine if object is/should be "drawn"
	-- if it should, add it at appropriate z-plane (1-64 = far-near)
  -- else, remove from all zplanes

	--if true then  -- obj is drawable

		-- calculate the correct z-plane
		-- based on x,y pos + elevation
		ypos = -1
		if obj.offset_y then
			ypos = obj.y
		else
			ypos = obj.y + (obj.h*8)
		end
		zplane = flr(ypos - stage_top)

		if obj.elevation then zplane += obj.elevation end

		add(draw_zplanes[zplane],obj)
	--end
end

function room_draw()
	-- draw current room (base layer)
	--room_map = room_curr.map
	-- replace colors?
	for c in all(room_curr.col_replace) do
		pal(c[1], c[2])
	end
	map(room_curr.map_x, room_curr.map_y, 0, stage_top, room_curr.map_w , room_curr.map_h)
	--reset palette
	pal() 
	
	-- debug walkable areas
	if show_collision then
		celx = flr((cursor_x + cam_x) /8) + room_curr.map_x
		cely = flr((cursor_y - stage_top)/8 ) + room_curr.map_y
		spr_num = mget(celx, cely)
		--d("mapa x="..celx..",y="..cely)
		--d("spr:"..spr_num)
		walkable = fget(spr_num,0)

		if walkable then
			rect(
				(celx-room_curr.map_x)*8, 
				stage_top+(cely-room_curr.map_y)*8, 
				(celx-room_curr.map_x)*8+7, 
				stage_top+(cely-room_curr.map_y)*8+7, 11)
		end
	end

	-- draw each zplane, from back to front
	for z = 1,64 do
		zplane = draw_zplanes[z]
		-- draw all objs/actors in current zplane
		for obj in all(zplane) do
			-- object or actor?
			if not has_flag(obj.class, class_actor) then
				-- object
				if (obj.states) 						-- object has a state?
				 and obj.states[obj.state]
				 and (obj.states[obj.state] > 0)
				 and (not obj.dependent_on 			-- object has a valid dependent state?
				 	or find_object(obj.dependent_on).state == obj.dependent_on_state)
				 and not obj.owner   						-- object is not "owned"
				then
					-- something to draw
					object_draw(obj)
				end
			else
				-- actor
				if (obj.in_room == room_curr) then
					actor_draw(obj)
				end
			end
			show_collision_box(obj)
			-- if (show_collision and obj.bounds) then rect(obj.bounds.x, obj.bounds.y, obj.bounds.x1, obj.bounds.y1, 8) end
		end
	end
end

-- draw actor(s)
function actor_draw(actor)

	if (actor.moving == 1) 
	 and actor.walk_anim then
		actor.tmr = actor.tmr + 1
		if (actor.tmr > 5) then
			actor.tmr = 1
			actor.anim_pos = actor.anim_pos + 1
			if (actor.anim_pos > #actor.walk_anim) then actor.anim_pos=1 end
		end
		-- choose walk anim frame
		sprnum = actor.walk_anim[actor.anim_pos]	
	else
		-- idle
		sprnum = actor.idle[actor.face_dir]
	end

	-- replace colors?
	for c in all(actor.col_replace) do
		pal(c[1], c[2])
	end

	sprdraw(sprnum, actor.offset_x, actor.offset_y, 
		actor.w , actor.h, actor.trans_col, 
		actor.flip, false)
	
	-- talking overlay
	if (talking_actor 
	 and talking_actor == actor) then
			--d("talking actor!")
			if (actor.talk_tmr < 7 ) then
				sprnum = actor.talk[actor.face_dir]
				--d("sprnum:"..sprnum)
				--d("facedir:"..actor.face_dir)
				sprdraw(sprnum, actor.offset_x, actor.offset_y +8, 1, 1, 
					actor.trans_col, actor.flip, false)
			end
			actor.talk_tmr = actor.talk_tmr + 1	
			if (actor.talk_tmr > 14) then actor.talk_tmr = 1 end
	end

	--reset palette
	pal()

	--pset(actor.x, actor.y+stage_top, 10)
end

function command_draw()
	-- draw current command
	command = ""
	cmd_col = 12


	if not executing_cmd then
		if verb_curr then
			command = verb_curr[3]
		end
		if noun1_curr then
			command = command.." "..noun1_curr.name
		end
		if verb_curr[2] == "use" 
		 and noun1_curr then
			command = command.." with"
		end
		if noun2_curr then
			command = command.." "..noun2_curr.name
		elseif hover_curr_object 
		  and hover_curr_object.name != ""
			-- don't show use object with itself!
			and ( not noun1_curr or (noun1_curr != hover_curr_object) ) then
			command = command.." "..hover_curr_object.name
		end
		cmd_curr = command
	else
		-- highlight active command
		command = cmd_curr
		cmd_col = 7
	end

	--d(command)

	print(smallcaps(command), 
		hcenter(command), 
		stage_top + 66, cmd_col)
end

function talking_draw()
	-- alignment 
	--   0 = no align
	--   1 = center 
	if type(talking_curr) != 'nil' then
		line_offset_y = 0
		for l in all(talking_curr.msg_lines) do
			line_offset_x=0
			-- center-align line
			if talking_curr.align == 1 then
				line_offset_x = ((talking_curr.char_width*4)-(#l*4))/2
			end
			outline_text(
				l, 
				talking_curr.x + line_offset_x, 
				talking_curr.y + line_offset_y, 
				talking_curr.col)
			line_offset_y += 6
		end
		-- update message lifespan
		talking_curr.time_left = talking_curr.time_left - 1
		-- remove text & reset actor's talk anim
		if (talking_curr.time_left <=0) then 
			talking_curr = nil 
			talking_actor = nil 
			d("talking actor cleared") 
		end
	end
end

-- draw ui and inventory
function ui_draw()
	-- draw verbs
	xpos = 0
	ypos = 75
	col_len=0

	for v in all(verbs) do
		txtcol=verb_maincol

		-- highlight default verb
		if hover_curr_default_verb
		  and (v == hover_curr_default_verb) then
			txtcol = verb_defcol
		end		
		if (v == hover_curr_verb) then txtcol=verb_hovcol end

		-- get verb info
		vi = get_verb(v)
		print(vi[3], xpos, ypos+stage_top+1, verb_shadcol)  -- shadow
		print(vi[3], xpos, ypos+stage_top, txtcol)  -- main
		
		-- capture bounds
		v.x = xpos
		v.y = ypos
		recalc_bounds(v, #vi[3]*4, 5, 0, 0)
		show_collision_box(v)
		--if (show_collision) then rect(v.bounds.x, v.bounds.y, v.bounds.x1, v.bounds.y1, 8) end
		-- auto-size column
		if (#vi[3] > col_len) then col_len = #vi[3] end
		ypos = ypos + 8

		-- move to next column
		if ypos >= 95 then
			ypos = 75
			xpos = xpos + (col_len + 1.0) * 4
			col_len = 0
		end
	end

	-- draw arrows
	for i = 1,2 do
		arrow = ui_arrows[i]
		if hover_curr_arrow == arrow then pal(verb_maincol,7) end
		sprdraw(arrow.spr, arrow.x, arrow.y, 1, 1, 0)
		-- capture bounds
		recalc_bounds(arrow, 8, 7, 0, 0)
		show_collision_box(arrow)
		--if (show_collision) then rect(arrow.bounds.x, arrow.bounds.y, arrow.bounds.x1, arrow.bounds.y1, 8) end
		pal() --reset palette
	end

	-- sprdraw(16, 75, stage_top + 60, 1, 1, 0)
	-- sprdraw(48, 75, stage_top + 73, 1, 1, 0)

	-- draw inventory
	xpos = 86
	ypos = 76
	for ipos=1, 8 do
		-- draw inventory bg
		rectfill(xpos-1, stage_top+ypos-1, xpos+8, stage_top+ypos+8, 1)
		obj = selected_actor.inventory[ipos]
		if obj then
			-- something to draw
			obj.x = xpos
			obj.y = ypos
			-- draw object/sprite
			object_draw(obj)
			-- re-calculate bounds (as pos may have changed)
			recalc_bounds(obj, obj.w*8, obj.h*8, 0, 0)
			show_collision_box(obj)
		end
		xpos = xpos + 11

		if xpos >= 125 then
			ypos = ypos + 12

			xpos=86
		end
		ipos = ipos + 1
	end
end

function dialog_draw()
	-- draw verbs
	xpos = 0
	ypos = 70
	
	for s in all(dialog_curr.sentences) do
		-- capture bounds
		s.x = xpos
		s.y = ypos
		recalc_bounds(s, s.char_width*4, #s.lines*5, 0, 0)

		txtcol=dialog_curr.col
		if (s == hover_curr_sentence) then txtcol=dialog_curr.hlcol end
		
		for l in all(s.lines) do
				print(smallcaps(l), xpos, ypos+stage_top, txtcol)
			ypos = ypos + 5
		end

		show_collision_box(s)
		--if (show_collision) then rect(s.bounds.x, s.bounds.y, s.bounds.x1, s.bounds.y1, 8) end
		
		ypos = ypos + 2

	end
end

-- draw cursor
function cursor_draw()
	col = cursor_cols[cursor_colpos]
	-- switch sprite color accordingly
	pal(7,col)
	spr(32, cursor_x-4, cursor_y-3, 1, 1, 0)
	pal() --reset palette

	cursor_tmr = cursor_tmr + 1
	if (cursor_tmr > 7) then
		--reset timer
		cursor_tmr = 1
		-- move to next color?
		cursor_colpos = cursor_colpos + 1
		if (cursor_colpos > #cursor_cols) then cursor_colpos = 1 end
	end
end

function sprdraw(n, x, y, w, h, transcol, flip_x, flip_y)
	-- switch transparency
 	palt(0, false)
 	palt(transcol, true)
	 -- draw sprite
	spr(n, x, stage_top + y, w, h, flip_x, flip_y) --
	-- restore trans
	palt(transcol, false)
	palt(0, true)
end



-- scumm core functions -------------------------------------------

function cutscene(flags, func)
	-- decrement the cursor level
	cursor_lvl = cursor_lvl - 1

	cut = {
		flags = flags,
		thread = cocreate(func),
		paused_room = room_curr,
		paused_actor = selected_actor,
		paused_cam_mode = cam_mode,
		paused_cam_following = cam_following_actor
	}
	add(cutscenes, cut)

	-- set as active cutscene
	cutscene_curr = cut

	-- reset stuff
	cam_mode = 1 --fixed
	cam_x = 0

	-- yield for system catch-up
	break_time()
end

function dialog_add(msg)
	if not dialog_curr then dialog_curr={ sentences={}, visible=false} end
	-- break msg into lines (if necc.)
	lines = create_text_lines(msg, 32)
	-- find longest line
	longest_line = longest_line_size(lines)
	sentence={
		num = #dialog_curr.sentences+1,
		msg = msg,
		lines = lines,
		char_width = longest_line
	}
	add(dialog_curr.sentences, sentence)
end

function dialog_start(col, hlcol)
	dialog_curr.col = col
	dialog_curr.hlcol = hlcol
	dialog_curr.visible = true
	sentence_curr = nil
end

function dialog_end()
	dialog_curr.visible = false
	dialog_curr=nil
end


function get_use_pos(obj)
	pos = {}
	d("get_use_pos")
	-- first check for specific pos
	if type(obj.use_pos) == "table" then
		d("usr tbl")
		pos.x = obj.use_pos.x-cam_x
		pos.y = obj.use_pos.y-stage_top

	-- determine use pos
	elseif not obj.use_pos or
		(obj.use_pos == pos_infront) then
		pos.x = obj.x+((obj.w*8)/2)-cam_x-4
		pos.y = obj.y+(obj.h*8) +2

	elseif (obj.use_pos == pos_left) then
		
		if obj.offset_x then	-- diff calc for actors
			pos.x = obj.x-cam_x - (obj.w*8+4)
			pos.y = obj.y+1
		else
			pos.x = obj.x-cam_x
			pos.y = obj.y+((obj.h*8) -2)
		end

	elseif (obj.use_pos == pos_right) then
		pos.x = obj.x+(obj.w*8)-cam_x
		pos.y = obj.y+((obj.h*8) -2)
	end

	return pos
end

function do_anim(actor, cmd_type, cmd_value)
	-- is target dir left?
	actor.flip = (cmd_value == face_left)

	if cmd_type == anim_face then
		d(" > anim_face")
		actor.face_dir = cmd_value

	elseif cmd_type == anim_turn then
		d(" > anim_turn")
		while (actor.face_dir != cmd_value) do
			if (actor.face_dir < cmd_value) then
				actor.face_dir = actor.face_dir + 1
			else 
				actor.face_dir = actor.face_dir - 1
			end
			break_time(10)
		end
	end

	-- flip?
	
end

-- open one (or more) doors
function open_door(door_obj1, door_obj2)
	if state_of(door_obj1) == states.open then
		say_line(selected_actor, "it's already open")
	else
		set_state(door_obj1, states.open)
		if door_obj2 then set_state(door_obj2, states.open) end
	end
end

-- close one (or more) doors
function close_door(door_obj1, door_obj2)
	if state_of(door_obj1) == states.closed then
		say_line(selected_actor, "it's already closed")
	else
		set_state(door_obj1, states.closed)
		if door_obj2 then set_state(door_obj2, states.closed) end
	end
end

function come_out_door(door_obj) --, new_room)
	-- switch to new room and...
	new_room = door_obj.in_room
	change_room(new_room)
	-- ...auto-position actor at door_obj
	pos = get_use_pos(door_obj)
	d("pos x:"..pos.x..", y:"..pos.y)
	selected_actor.x = pos.x
	selected_actor.y = pos.y
	-- (in opposite use direction)
	if door_obj.use_dir then
		opp_dir = door_obj.use_dir + 2
		if (opp_dir > 4) then
			opp_dir -= 4
		end
	else
	 opp_dir = 1 -- front
	end
	do_anim(selected_actor, anim_face, opp_dir)

	selected_actor.in_room = new_room
end

function change_room(new_room)
	d("change_room()...")
	-- switch to new room
	-- execute the exit() script of old room
	if room_curr and room_curr.exit then
		-- run script directly, so wait to finish
		room_curr.exit(room_curr)
	end
	
	-- stop all active (local) scripts
	local_scripts = {}

	-- clear current command
	clear_curr_cmd()

	-- todo: transition to new room (e.g. iris/swipe)	

	room_curr = new_room

		-- calc map size
	--room_map = room_curr.map
	if room_curr.map_x1 then
		room_curr.map_w = room_curr.map_x1 - room_curr.map_x + 1
		room_curr.map_h = room_curr.map_y1 - room_curr.map_y + 1
	else
		room_curr.map_w = 16
		room_curr.map_h = 8
	end

	-- reset camera
	cam_x = 0

	-- execute the enter() script of new room
	if room_curr.enter then
		-- run script directly
		d("t2: "..type(room_curr))
		d("scr2:"..type(room_curr.scripts.anim_fire))
		room_curr.enter(room_curr)
	end
end

function valid_verb(verb, object)
	-- check params
	if not object then return false end
	if not object.verbs then return false end
	-- look for verb
	if type(verb) == "table" then
		if object.verbs[verb[1]] then return true end
	else
		if (object.verbs[verb]) then return true end
	end
	-- must not be valid if reached here
	return false
end

function pickup_obj(objname)
	obj = find_object(objname)
	if obj
	 and not obj.owner then
	 	d("adding to inv")
		-- assume selected_actor picked-up at this point
		add(selected_actor.inventory, obj)
		obj.owner = selected_actor
		-- remove it from room
		remove(obj.in_room.objects,obj)
	end
end

function owner_of(objname)
	obj = find_object(objname)
	if obj then
		return obj.owner
	end
end

function state_of(objname, state)
	obj = find_object(objname)
	if obj then
		return obj.state
	end
end

function set_state(objname, state)
	obj = find_object(objname)
	if obj then
		obj.state = state
	end
end

-- find object by ref or name
function find_object(name)
	-- if object passed, just return object!
	if (type(name) == "table") then return name end
	-- else look for object by unique name
	for k,obj in pairs(room_curr.objects) do
		--d("--"..obj.name)
		if (obj.name == name) then return obj end
		--if (k == name) then return obj end
	end
end

function start_script(func, bg, noun1, noun2)	-- me == this
	-- create new thread for script and add to list of local_scripts
	local thread = cocreate(func)
	-- background or local?
	if bg then
		add(global_scripts, {func, thread, noun1, noun2} )
	else
		add(local_scripts, {func, thread, noun1, noun2} )
	end
end

function script_running(func)
	d("script_running()")
	-- find script and stop it running

	-- try local first
	for k,scr_obj in pairs(local_scripts) do
		d("...")
		if (scr_obj[1] == func) then 
			d("found!")
			return true
		end
	end

	-- failing that, try global
	for k,scr_obj in pairs(global_scripts) do
		d("...")
		if (scr_obj[1] == func) then 
			d("found!")
			return true
		end
	end
	-- must not be running
	return false
end

function stop_script(func)
	d("stop_script()")
	-- find script and stop it running

	-- try local first
	for k,scr_obj in pairs(local_scripts) do
		d("...")
		if (scr_obj[1] == func) then 
			d("found!")
			del(local_scripts, scr_obj)
			d("deleted!")
			scr_obj = nil
		end
	end
	-- failing that, try global
	for k,scr_obj in pairs(global_scripts) do
		d("...")
		if (scr_obj[1] == func) then 
			d("found!")
			del(global_scripts, scr_obj)
			d("deleted!")
			scr_obj = nil
		end
	end
end

function break_time(jiffies)
	jiffies = jiffies or 1
	-- draw object (depending on state!)
	for x = 1, jiffies do
		yield()
	end
end

function wait_for_message()
	-- draw object (depending on state!)
	while talking_curr != nil do
		yield()
		--d("wait_for_message")
	end
end

-- uses actor's position and color
function say_line(actor, msg)
	-- check for missing actor
	if type(actor) == "string" then
		-- assume actor ommitted and default to current
		msg = actor
		actor = selected_actor
	end
	-- get pos above actor's head
	ypos = actor.y-text_offset
		-- trigger actor's talk anim
	talking_actor = actor
	d("talking actor set")
	-- call the base print_line to show actor line
	print_line(msg, actor.x, ypos, actor.col, 1)
end


function print_line(msg, x, y, col, align)
	d("print_line")
  -- punctuation...
	--  > ":" new line, shown after text prior expires
	--  > "," new line, shown immediately

	-- todo: an actor's talk animation is not activated as it is with say-line.
	local col=col or 7 		-- default to white
	local align=align or 0	-- default to no align

	d(msg)
	--d("align:"..align)
	--d("x:"..x.." y:"..y)
	-- default max width (unless hit a screen edge)
	local lines={}
	local curchar=""
	local msg_left="" --used for splitting messages with ";"
	
	longest_line=0
	-- auto-wrap
	-- calc max line width based on x-pos/available space
	screen_space = min(x, screenwidth - x)
	-- (or no less than min length)
	max_line_length = max(flr(screen_space/2), 16)

	-- search for ";"'s
	msg_left = ""
	for i = 1, #msg do
		curchar=sub(msg,i,i)
		if curchar == ";" then -- msg break
			d("msg break!")
			-- show msg up to this point
			-- and process the rest as new message
			
			-- next message?
			msg_left = sub(msg,i+1)
			d("msg_left:"..msg_left)
			-- redefine curr msg
			msg = sub(msg,1,i-1)
			break
		end
	end

	lines = create_text_lines(msg, max_line_length, true)

	-- find longest line
	longest_line = longest_line_size(lines)

	-- center-align text block
	if align == 1 then
		xpos = x - ((longest_line*4)/2)
	end

	-- screen bound check
	xpos = max(2,xpos)	-- left
	ypos = max(18,y)    -- top
	xpos = min(xpos, screenwidth - (longest_line*4)-1) -- right

	talking_curr = {
		msg_lines = lines,
		x = xpos,
		y = ypos,
		col = col,
		align = align,
		time_left = (#msg)*8,
		char_width = longest_line
	}

	-- if message was split...
	if (#msg_left > 0) then
	  talking = talking_actor
		wait_for_message()
		talking_actor = talking
		print_line(msg_left, x, y, col, align)
	end
end


function object_draw(obj)
	-- replace colors?
	for c in all(obj.col_replace) do
		pal(c[1], c[2])
	end
	-- allow for repeating
	rx=1
	if obj.repeat_x then rx = obj.repeat_x end
	for h = 0, rx-1 do
		-- draw object (in its state!)
		sprdraw(obj.states[obj.state], obj.x+(h*(obj.w*8)), obj.y, obj.w, obj.h, obj.trans_col, obj.flip_x)
	end
	--reset palette
	pal() 
end

-- walk actor to position
function walk_to(actor, x, y)

	--offset for camera
		x = x + cam_x

	local distance = sqrt((x - actor.x) ^ 2 + (y - actor.y) ^ 2)
	local step_x = actor.speed * (x - actor.x) / distance
	local step_y = actor.speed * (y - actor.y) / distance

	-- abort if we're already there!
	if (distance < 1) then return end

	-- check target position is in walkable block
	walkable = iswalkable(x,y)

	-- if it is...
	if walkable then
		d("walkable!")
		actor.moving = 1 --walking
		actor.flip = (step_x<0)

		-- face dir (at end of walk)
		actor.face_dir = face_right
		if (actor.flip) then actor.face_dir = face_left end

		for i = 0, distance/actor.speed do
			-- check "step" position is "walkable"
			if iswalkable(actor.x + step_x, actor.y + step_y) then
				actor.x = actor.x + step_x
				actor.y = actor.y + step_y
				yield()
			else
				-- hit non-walkable block, stop!
				d("hit nonwalk!")
				actor.moving = 0 --stopped
				-- clear current command
				clear_curr_cmd()
				return
			end
		end
		d("reach dest")
		actor.moving = 2 --arrived
	else
		d("non-walk")
		actor.moving = 2 --stopped
	end
end



-- internal functions -----------------------------------------------

-- initialise all the rooms (e.g. add in parent links)
function game_init()
	for kr,room in pairs(rooms) do
		for ko,obj in pairs(room.objects) do
			obj.in_room = room
		end
	end
	-- init actors with defaults
	for ka,actor in pairs(actors) do
		actor.moving = 2 		-- 0=stopped, 1=walking, 2=arrived
		actor.tmr = 1 				-- internal timer for managing animation
		actor.talk_tmr = 1
		actor.anim_pos = 1 	-- used to track anim pos
		actor.inventory = {
			-- object1,
			-- object2
		}
	end

	-- debug --------------
	for i=1,16 do 
		obj = {
				name = "dummy"..i,
				class = class_pickupable,
				state = 1,
				x = 1, -- (*8 to use map cell pos)
				y = 1 - stage_top,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				states = { 
					239
					--255 
				}
			}
		add(selected_actor.inventory, obj)
		obj.owner = selected_actor
		--[[recalc_bounds(obj, 8, 8, 1, 1)
		show_collision_box(obj)]]
	end

end

function show_collision_box(obj)
	if show_collision and obj.bounds then 
		rect(obj.bounds.x, obj.bounds.y, obj.bounds.x1, obj.bounds.y1, 8) 
	end	
end

function update_scripts(scripts)
	for scr_obj in all(scripts) do
		if scr_obj[2] and not coresume(scr_obj[2], scr_obj[3], scr_obj[4]) then
			del(scripts, scr_obj)
			scr_obj = nil
		end
	end
end

-- returns whether room map cel at position is "walkable"
function iswalkable(x, y)
		celx = flr(x/8) + room_curr.map_x
		cely = flr(y/8) + room_curr.map_y
		--d("mapb x="..celx..",y="..cely)
		spr_num = mget(celx, cely)
		--d("spr:"..spr_num)
		walkable = fget(spr_num,0)
		return walkable
end

function get_keys(obj)
	keys = {}
	for k,v in pairs(obj) do
		--d("k:"..k)
		add(keys,k)
	end
	return keys
end

function get_verb(obj)
	verb = {}
	keys = get_keys(obj[1])
	--[[
	d("1:"..keys[1])
	d("2:"..obj[1][ keys[1] ])
	d("3:"..obj.text )
	]]

	add(verb, keys[1])						-- verb func
	add(verb, obj[1][ keys[1] ])  -- verb ref name
	add(verb, obj.text)						-- verb disp name

	return verb
end


-- auto-break message into lines
function create_text_lines(msg, max_line_length, comma_is_newline)
	local lines={}
	local currline=""
	local curword=""
	local curchar=""
	
	local upt=function(max_length)
		if #curword + #currline > max_length then
			add(lines,currline)
			currline=""
		end
		currline=currline..curword
		curword=""
	end

	for i = 1, #msg do
		curchar=sub(msg,i,i)
		curword=curword..curchar
		if (curchar == " ")
		 or (#curword > max_line_length-1) then
			upt(max_line_length)
		elseif #curword>max_line_length-1 then
			curword=curword.."-"
			upt(max_line_length)
		elseif curchar == "," and comma_is_newline then -- line break
			d("line break!")
			currline=currline..sub(curword,1,#curword-1)
			curword=""
			upt(0)
		end
	end

	upt(max_line_length)
	if currline!="" then
		add(lines,currline)
	end

	return lines
end

-- find longest line
function longest_line_size(lines)
	--if lines d(#lines[1])
	longest_line = 0
	for l in all(lines) do
		if (#l > longest_line) then longest_line = #l end
	end
	return longest_line
end

function has_flag(obj, value)
  if (band(obj, value) != 0) then return true end
  return false
end

function clear_curr_cmd()
	-- reset all command values
	verb_curr = get_verb(verb_default)
	noun1_curr = nil
	noun2_curr = nil
	me = nil
	executing_cmd = false
	cmd_curr = ""
	d("command wiped")
end

function recalc_bounds(obj, w, h, cam_off_x, cam_off_y)
  x = obj.x
	y = obj.y
	-- offset for actors?
	if has_flag(obj.class, class_actor) then
		obj.offset_x = obj.x - (obj.w *8) /2
		obj.offset_y = obj.y - (obj.h *8) +1		
		x = obj.offset_x
		y = obj.offset_y
	end
	obj.bounds = {
		x = x,
		y = y + stage_top,
		x1 = x + w -1,
		y1 = y + h + stage_top -1,
		cam_off_x = cam_off_x,
		cam_off_y = cam_off_y
	}
end

-- library functions -----------------------------------------------

function outline_text(str,x,y,c0,c1)

 local c0=c0 or 7
 local c1=c1 or 0

 str = smallcaps(str)

 print(str,x,y+1,c1)
 print(str,x,y-1,c1)
 print(str,x+1,y,c1)
 print(str,x+1,y+1,c1)
 print(str,x+1,y-1,c1)
 print(str,x-1,y,c1)
 print(str,x-1,y+1,c1)
 print(str,x-1,y-1,c1)

 print(str,x,y,c0)
end

function hcenter(s)
	return (screenwidth / 2)-flr((#s*4)/2)
end

function vcenter(s)
	return (screenheight /2)-flr(5/2)
end

--- collision check
function iscursorcolliding(obj)
	-- check params
	if not obj.bounds then return false end
	bounds=obj.bounds
	if (cursor_x + bounds.cam_off_x > bounds.x1 or cursor_x + bounds.cam_off_x < bounds.x) 
	 or (cursor_y>bounds.y1 or cursor_y<bounds.y) then
		return false
	else
		return true
	end
end

function smallcaps(s)
	local d=""
	local l,c,t=false,false
	for i=1,#s do
		local a=sub(s,i,i)
		if a=="^" then
			if(c) then d=d..a end
				c=not c
			elseif a=="~" then
				if(t) then d=d..a end
				t,l=not t,not l
			else 
				if c==l and a>="a" and a<="z" then
				for j=1,26 do
					if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
						a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
					break
					end
				end
			end
			d=d..a
			c,t=false,false
		end
	end
	return d
end


__gfx__
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0f5ff5f0000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb4ffffff4000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbff44ffb000000000000000000000000000000000000000000000000000000000000000000000000
00000000b444449bb494449bb494449bb494449bb999449bb6ffff6b000000000000000000000000000000000000000000000000000000000000000000000000
000000004440444949444449494444494944444994444449bbf00fbb000000000000000000000000000000000000000000000000000000000000000000000000
000000004040000449440004494400044944000494444444bbf00fbb000000000000000000000000000000000000000000000000000000000000000000000000
0000000004ffff000440fffb0440fffb0440fffb44444444bbbffbbb000000000000000000000000000000000000000000000000000000000000000000000000
000000000f9ff9f004f0f9fb04f0f9fb04f0f9fb44444444bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000
000cc0000f5ff5f000fff5fb00fff5fb00fff5fb4444444000fff5fb00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c11c004ffffff440ffffff40ffffff40ffffff0444444440ffffff00000000000000000000000000000000000000000000000000000000ffffffff00000000
0c1001c0bff44ffbb0fffff4b0fffff4b0fffff4b044444bb0fffff400000000000000000000000000000000000000000000000000000000ffffffff00000000
ccc00cccb6ffff6bb6fffffbb6fffffbb6fffffbb044444bb6fffffb00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c00c00bbfddfbbbb6fffdbbb6fffdbbb6fffdbbb0000bbbb6ff00b00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c00c00bbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbff00b00000000000000000000000000000000000000000000000000000000ffffffff00000000
00cccc00bdc55cdbbbddcbbbbbbddbbbbbddcbbbbddddddbbbbbbffb00000000000000000000000000000000000000000000000000000000fff22fff00000000
00111100dcc55ccdb1ccdcbbbb1ccdbbb1ccdcbbdccccccdbbbbbbbb00000000000000000000000000000000000000000000000000000000ff0020ff00000000
00070000c1c66c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2302ffff2302ff
00070000c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ffb33bffffb33bff
00070000c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff
77707770c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2222ffff2222ff
00070000d1cddc1db1dddcbbbb1dddbbb1dddcbbd1cccc1d0000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff
00070000fe1111efbbff11bbbb2ff1bbbbff11bbfe1111ef0000000000000000000000000000000000000000000000000000000000000000f2b33b2ff2b33b2f
00070000bf1111fbbbfe11bbbb2fe1bbbbfe11bbbf1111fb0000000000000000000000000000000000000000000000000000000000000000f22bb22ff2b33b2f
00000000bb1121bbbb2111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f222222ff22bb22f
00cccc00bb1121bbbb1111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f222222f00000000
00c11c00bb1121bbbb1111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f22bb22f00000000
00c00c00bb1121bbbb1112bbbb2111bbbb21111bbb1211bb0000000000000000000000000000000000000000000000000000000000000000f2b33b2f00000000
ccc00cccbb1121bbbb1112bbbb2111bbbb22111bbb1211bb000000000000000000000000000000000000000000000000000000000000000022b33b2200000000
1c1001c1bb1121bbb111122bbb2111bbb222111bbb1211bb0000000000000000000000000000000000000000000000000000000000000000222bb22200000000
01c00c10bb1121bbc111222bbb2111bbb22211ccbb1211bb00000000000000000000000000000000000000000000000000000000000000002222222200000000
001cc100bbccccbb7ccc222bbbccccbbb222cc77bbccccbb00000000000000000000000000000000000000000000000000000000000000002222222200000000
00011000b776677bb7776666bb6777bbb66677bbb776677b0000000000000000000000000000000000000000000000000000000000000000bbbbbbbb00000000
00000000000000000000000000000000000000000000000077777777f9e9f9f9ddd5ddd5bbbbbbbb550000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000777777779eee9f9fdd5ddd5dbbbbbbbb555500000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777777feeef9f9d5ddd5ddbbbbbbbb555555000000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779fef9fef5ddd5dddbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeeddd5ddd5bbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779f9f9eeedd5ddd5dbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeed5ddd5ddbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779f9f9fef5ddd5dddbbbbbbbb555555550000000000000000000000000000000000000000
77777755666666ddbbbbbbee3333335533333333000000006666666658888588dddddddd00000000000000550000000000000000000000000000000000045000
777755556666ddddbbbbeeee33333355333333330000000066666666588885885555555500000000000055550000000000000000000000000000000000045000
7755555566ddddddbbeeeeee33336666333333330000000066666666555555556666666600000000005555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33336666333333330000000066666666888588886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666888588886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666555555556666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885886666666600000000555555550000000000000000000000000000000000045000
55777777dd666666eebbbbbb55333333555555550000000000000000000000000000000000000000000000000000000000000000000000000000000099999999
55557777dddd6666eeeebbbb55333333555533330000000000000000000000000000000000000000000000000000000000000000000000000000000044444444
55555577dddddd66eeeeeebb66663333553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66663333533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee55555533533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee55555533553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555533330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333355550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333333550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333333350000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333333350000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333333550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333355550000000000000000000000000000000000000000000000000000000000000000000000000b03000099999999
55555555ddddddddbbbbbbbb6666666655555555000000000000000000000000000000000000000000000000000000000000000000000000b00030b055555555
00000000000000000000000000000000777777777777777777555555555555770000000000000000000000000000000000000000000000004444444444444444
00000000000000000000000000000000700000077000000770700000000007070000000000000000000000000000000000000000000000004ffffff44ffffff4
00000000000000000000000000000000700000077000000770070000000070070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000777777777777777777776000000677770000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000677600000770066000000660070000000000000000000000000000000000000000000000004f4444944f444494
0000000000000000000a000000000000700006077060000770606000000606070000000000000000000000000000000000000000000000004f9999944f444494
0000000000000000000000000000000070000507705000077050600000060507000000000000000000000000000000000000000000000000444444444f449994
0000000000a0a000000aa000000a0a0070000007700000077000600000060007000000000000000000000000000000000000000000000000444444444f994444
0000000000aaaa0000aaaa0000aaa0007000000770000007700500000000500700000000000000000000000000000000000000000000000049a4444444444444
0000000000a9aa0000a99a0000aa9a00700000077000000770500000000005070000000000000000000000000000000000000000000000004994444444444444
0000000000a99a0000a99a0000a99a00777777777777777775000000000000770000000000000000000000000000000000000000000000004444444449a44444
00000000004444000044440000444400555555555555555555555555555555550000000000000000000000000000000000000000000000004ffffff449944444
99999999777777777777777777777777700000077776000077777777777777770000000000000000000000000000000000000000000000004f44449444444444
55555555555555555555555555555555700000077776000055555555555555550000000000000000000000000000000000000000000000004f4444944444fff4
444444440dd6dd6dd6dd6dd6d6dd6d50700000077776000044444444444444440000000000000000000000000000000000000000000000004f4444944fff4494
ffff4fff0dd6dd6dd6dd6dd6d6dd6d507000000766665555444ffffffffff4440000000000000000000000000000000000000000000000004f4444944f444494
44494944066666666666666666666650700000070000777644494444444494440000000000000000000000000000000000000000000000004f4444944f444494
444949440d6dd6dd6dd6dd6ddd6dd65070000007000077764449444aa44494440000000000000000000000000000000000000000000000004f4444944f444494
444949440d6dd6dd6dd6dd6ddd6dd650777777770000777644494444444494440000000000000000000000000000000000000000000000004ffffff44f444494
4449494406666666666666666666665055555555555566664449999999999444000000000000000000000000000000000000000000000000444444444f444494
444949440dd6dd600000000056dd6d5000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f444494
444949440dd6dd650000000056dd6d5000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f444994
4449494406666665000000005666665000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f499444
444949440d6dd6d5000000005d6dd65000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f944444
444949440d6dd6d5000000005d6dd650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000044444400
44494944066666650000000056666650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000044440000
999949990dd6dd650000000056dd6d50000000000000000044499999999994440000000000000000000000000000000000000000000000000000000044000000
444444440dd6dd650000000056dd6d50000000000000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666666f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006cccccc6
bbbcccc8888bbbbcccc8888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d666666d
fccccc8ffbbbbbcff88888bf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fccc888ffbbbcccff888bbbf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff6665ff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666666f
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065555556
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d666666d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff6665ff
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000944
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094400
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800808
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080088008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080088008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800808
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010100000000000000010000000000010101010100000000000100000000000101010101000000000000000000000001010101010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4646464747474747474747474746464656565648484848484848484848484848484848484856565600000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4646464700004747474747474746464656565648484848484848848585854848484848484856565600000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
46004647000047474747474747460046560056a5a5a5a5a5a5a594a4a495a5a5a5a5a5a5a556005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
460046a0a0a0a0a1a2a3a0a0a0460046560056a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a756005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
460046b0b0b0b0b1b2b3b0b0b0460046560056b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b756005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4640507070707070707070707060404656415171717171717171717171717171717171717161415600000000000000004454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
5070707064545454545454747070706051717171717171717171717171717171717171717171716100000000000000006470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707071717171717171717171717171717171717171717171717100000000000000007070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
44444449494949494949494949494949000000000000000000005f0058585858585858585858585858585858005f00004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44444449494949494949494949494949000000000000000000005f0058845884588458008e58845884588458005f00004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44004449494949494949494949494949000000000000000000005f0058a458a458a458009e58a458a458a458005f00004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044494949494949494949494949490000000000004500000045005858585858585800ae58585858585858000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044494949494949494949494949497e7e7e7e7e7e7e7e7e7e5a7070707070707070647470707070707070704a7e7e4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707070707054545454545454545454575757575757575773737373575757575757575754544454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707054545454545454545454545454545454545373737373635454545454545454546470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707054545454545454545454545454545454545454545454545454545454545454547070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

