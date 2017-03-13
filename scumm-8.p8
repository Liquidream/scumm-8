pico-8 cartridge // http://www.pico-8.com
version 10
__lua__

-- scumm-8
-- paul nicholas

-- python c:\users\pauln\owncloud\dev\pico-8\picotool\p8tool luamin c:\users\pauln\owncloud\games\pico-8\carts\git_repos\scumm-8\scumm-8.p8

-- ### luamin fixes ###
--  da=type
--	"\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92"


-- debugging
show_debuginfo = false
show_collision = false
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
first_room = {
	map = {
		x = 0,
		y = 0,
		w = 16,	-- default these?
		h = 8	-- 
	},
	--sounds = {},
	--costumes = {},
	enter = function(me)
		-- animate fireplace
		d("scr:"..type(me.scripts.anim_fire))
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
			trans_col = 0,
			--use_pos (defaults to spr bottom)
			use_dir = face_back,
			use_pos = pos_infront,

			dependent_on = "front_door",	-- object is dependent on the state of another
			dependent_on_state = states.closed,

			verbs = {
				lookat = function()
					say_line(selected_actor, "it's a nice, warm fire...")
					wait_for_message()
					break_time(10)
					do_anim(selected_actor, anim_turn, face_front)
					say_line(selected_actor, "ouch! it's hot!;*stupid fire*")
					wait_for_message()
				end,
				talkto = function()
					say_line(selected_actor, "'hi fire...'")
					wait_for_message()
					break_time(10)
					do_anim(selected_actor, anim_turn, face_front)
					say_line(selected_actor, "the fire didn't say hello back;burn!!")
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
			states = { -- states are spr values
			  79, -- states.closed
				0   -- states.open
			},
			flip_x = false, -- used for flipping the sprite
			flip_y = false,
			w = 1,	-- relates to spr or map cel, depending on above
			h = 4,  --
			use_pos = pos_right,
			verbs = {
				walkto = function(me)
					d("me = "..type(me))
					if state_of(me) == states.open then
						-- go to new room!
						come_out_door(second_room.objects.back_door, second_room)
					else
						say_line(selected_actor, "the door is closed")
					end
				end,
				open = function(me)
					if (isnull(me)) d("me is null!")
					d("me = "..me.name)
					if state_of(me) == states.open then
						say_line(selected_actor, "it's already open!")
					else
						set_state(me, states.open)
					end
				end,
				close = function(me)
					set_state(me, states.closed)
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
			verbs = {
				walkto = function()
					-- go to new room!
					come_out_door(second_room.objects.kitchen_door_hall, second_room) -- ()
				end
			}
		},
		bat = {
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
						say_line(selected_actor, "it is a bucket in my pocket")
					else
						say_line(selected_actor, "it is a bucket")
					end
				end,
				pickup = function(me)
					d("b4 pickup")
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
			state = states.closed,
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
							change_room(second_room)
							selected_actor = actors.purp_tentacle
							walk_to(selected_actor, 
								selected_actor.x+10, 
								selected_actor.y)
							say_line(selected_actor, "what was that?!")
							wait_for_message()
							say_line(selected_actor, "i'd better check...")
							wait_for_message()
							walk_to(selected_actor, 
								selected_actor.x-10, 
								selected_actor.y)
							change_room(first_room)
							-- wait for a bit, then appear in room1
							break_time(50)
							selected_actor.x = 115
							selected_actor.y = 44
							selected_actor.in_room = first_room
							walk_to(selected_actor, 
								selected_actor.x-10, 
								selected_actor.y)
							say_line(selected_actor, "intruder!!!")
							wait_for_message()
						end
					)
				end
			}
		}
	}
}

second_room = {
	map = {
		x = 16,
		y = 0,
		w = 24,	-- default these?
		h = 8	-- 
	},
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
			verbs = {
				walkto = function()
					-- go to new room!
					come_out_door(first_room.objects.hall_door_kitchen, first_room)
				end
			}
		},
		back_door = {
			name = "back door",
			--dependent_on = "closet-door",
			--dependent_on_state = states.closed,
			state = states.closed,
			x = 22*8, -- (*8 to use map cell pos)
			y = 2*8,
			states = {
				-- states are spr values
				79, -- closed
				0   -- open
			},
			flip_x = true, -- used for flipping the sprite
			flip_y = false,
			w = 1,	-- relates to spr or map cel, depending on above
			h = 4,  --
			use_pos = pos_left,
			verbs = {
				walkto = function(me)
					d("me = "..type(me))
					if state_of(me) == states.open then
						-- go to new room!
						come_out_door(first_room.objects.front_door, first_room)
					else
						say_line(selected_actor, "the door is closed")
					end
				end,
				open = function(me)
					d("me = "..me.name)
					if state_of(me) == states.open then
						say_line(selected_actor, "it's already open!")
					else
						set_state(me, states.open)
					end
				end,
				close = function(me)
					set_state(me, states.closed)
				end
			}
		},
	},
}

-- set which room to start the game in 
-- (could be a "pseudo" room for title screen!)
selected_room = first_room
--selected_room = second_room


-- #######################################################
-- actor definitions
-- 

actors = {
	main_actor = { 		-- initialize the actor object
		name = "",
		class = class_actor,
		x = 127/2 - 16,
		y = 127/2 -16,
		w = 1,
		h = 4,
		face_dir = face_front, 	-- direction facing
		idle = {1,3,5,3},	-- sprites for idle (front, left, back, right) - right=flip
		talk = {6,22,21,22},
		walk_anim = {2,3,4,3},
		flip = false, 		-- used for flipping the sprite (left/right dir)
		col = 12,				-- speech text colour
		trans_col = 11,
		speed = 0.75,  	-- walking speed
		moving = 0, 		-- 0=stopped, 1=walking, 2=arrived
		tmr = 1, 				-- internal timer for managing animation
		talk_tmr = 1,
		anim_pos = 1, 	-- used to track anim pos
		inventory = {
			-- object1,
			-- object2
		}
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
		col = 13, --2,				-- speech text colour
		trans_col = 15,
		speed = 0.25,  	-- walking speed
		moving = 0,
		tmr = 1,
		talk_tmr = 1,
		anim_pos = 1,
		use_pos = pos_left,
		--in_room = first_room,
		in_room = second_room,
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
					while (isnull(sentence_curr) or sentence_curr.num != 4) do
						d("start dialog")
						while (true) do
							-- build dialog options
							dialog_add("where am i?")
							dialog_add("who are you?")
							dialog_add("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?")
							dialog_add("nevermind")
							dialog_start(selected_actor.col, 7)
							-- wait for selection
							while isnull(sentence_curr) do break_time(1) end
							break
						end
						-- chosen options
						dialog_end()
						d("here...")
						cutscene(cut_noverbs, function()
							say_line(selected_actor, sentence_curr.msg)
							wait_for_message()
							
							d("sentence num: "..sentence_curr.num)
							if sentence_curr.num == 1 then
								say_line(me,"you are in paul's game")
								wait_for_message()
							elseif sentence_curr.num == 2 then
								say_line(me,"it's complicated...")
								wait_for_message()
							elseif sentence_curr.num == 3 then
								say_line(me,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
								wait_for_message()
							elseif sentence_curr.num == 4 then
								say_line(me,"ok bye!")
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

	--d(default_verb)

	-- now find the full verb definition
	for v in all(verbs) do
		vi = get_verb(v)
		--d("lookin..."..vi[1])
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
			say_line(selected_actor, "i don't need them")
		else
			say_line(selected_actor, "i don't need that")
		end

	elseif verb == "use" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "i can't just *use* someone")
		end
		if obj2 then
			if has_flag(obj2.class, class_actor) then
				say_line(selected_actor, "i can't use that on someone!")
			else
				say_line(selected_actor, "that doesn't work")
			end
		end

	elseif verb == "give" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "i don't think i should be giving this away")
		else
			say_line(selected_actor, "i can't do that")
		end

	elseif verb == "lookat" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "i think it's alive")
		else
			say_line(selected_actor, "looks pretty ordinary")
		end

	elseif verb == "open" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "they don't seem to open")
		else
			say_line(selected_actor, "it doesn't seem to open")
		end

	elseif verb == "close" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "they don't seem to close")
		else
			say_line(selected_actor, "it doesn't seem to close")
		end

	elseif verb == "push" or verb == "pull" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "moving them would accomplish nothing")
		else
			say_line(selected_actor, "it won't budge!")
		end

	elseif verb == "talkto" then
		if has_flag(obj1.class, class_actor) then
			say_line(selected_actor, "erm... i don't think they want to talk")
		else
			say_line(selected_actor, "i am not talking to that!")
		end

	else
		say_line(selected_actor, "hmm. no.")
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

cam = {
	x = 0,
	max = 0, -- the maximum x position the camera can move to in the current room
	min = 0,  -- the minimum x position the camera can move to in the current room
	mode = 0, -- 0=follow, 1=static, 2=pan-to
	following_actor = selected_actor,
	-- pan_to_x=0
	-- pan_to_y=0
}

cursor = {
  x = screenwidth/2,
  y = screenheight/2,
	lvl = 1, -- for cutscenes (<=0 - disable cursor)
  tmr = 0, -- used to animate cursor col
  cols = {7,12,13,13,12,7},
  colpos = 1 
}
-- keeps reference to currently hovered items
-- e.g. objects, ui elements, etc.
hover_curr = {
	-- verb, 
	-- default_verb,
	-- object, 
	-- dialog sentence
	-- ui_arrow
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

	-- load the initial room
	change_room(selected_room)
end

function _update60()  -- _update()
	gameupdate()
end

function _draw()
	gamedraw()
end

-- update functions

function gameupdate()
	-- process selected_actor threads/actions
	if selected_actor.thread and not coresume(selected_actor.thread) then
		selected_actor.thread = nil
	end

	--d("gameupdate()")

	-- global scripts (always updated - regardless of cutscene)
	for scr_obj in all(global_scripts) do
		--d("update global script!")
		if scr_obj[2] and not coresume(scr_obj[2], scr_obj[3], scr_obj[4]) then
			del(global_scripts, scr_obj)
			scr_obj = nil
		end
	end		


	-- update active cutscene (if any)
	if notnull(cutscene_curr) then
		--d("playing cutscene...")
		if cutscene_curr.thread and not coresume(cutscene_curr.thread) then
			-- cutscene ended, restore prev state	
			if (room_curr != cutscene_curr.paused_room) then change_room(cutscene_curr.paused_room) end
			selected_actor = cutscene_curr.paused_actor
			cam.mode = cutscene_curr.paused_cam_mode
			cam.following_actor = cutscene_curr.paused_cam_following
			-- now delete cutscene
			del(cutscenes, cutscene_curr)
			cutscene_curr = nil
			-- any more cutscenes?
			if (#cutscenes > 0) then
				cutscene_curr = cutscenes[#cutscenes]
			end
			-- add a pause for sys to catch-up??
			--break_time(1)
		end
	else
		-- no cutscene...
		-- update all the active scripts (local + global)
		-- (will auto-remove those that have ended)
	
		-- local
		for scr_obj in all(local_scripts) do
			if scr_obj[2] and not coresume(scr_obj[2], scr_obj[3], scr_obj[4]) then
				del(local_scripts, scr_obj)
				scr_obj = nil
			end
		end
		
	end

	-- player/ui control
	playercontrol()

	-- check for collisions
	checkcollisions()
end


function gamedraw()
	-- clear screen every frame?
	rectfill(0,0,screenwidth, screenheight, 0)

	-- auto-follow camera?
	if cam.mode == 0 then
		--d("cam.x:"..cam.x)
		cam.x = mid(0, selected_actor.x - 64, (room_curr.map.w*8)-screenwidth-1)
	end
	camera(cam.x, 0)

	-- clip room bounds
	clip(0, stage_top, screenwidth, 64)

	-- draw room (bg + objects + actors)
	roomdraw()

	-- reset camera for "static" content
	camera(0,0)
	-- reset clip
	clip()

	if (show_perfinfo) then 
		print("cpu: "..flr(100*stat(1)).."%", 0, stage_top - 16, 8) 
		print("mem: "..flr(stat(0)/1024*100).."%", 0, stage_top - 8, 8)
	end
	if (show_debuginfo) then print("x: "..cursor.x.." y:"..cursor.y, 80, stage_top - 8, 8) end

	-- draw active text
	talking_draw()

	-- no dialog?
	if notnull(dialog_curr) and dialog_curr.visible then
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
	if isnull(cutscene_curr) then
		command_draw()
	end

	-- draw ui and inventory
	if (isnull(cutscene_curr) 
		or not has_flag(cutscene_curr.flags, cut_noverbs))
		-- and not just left a cutscene
		and (cutscene_curr_lastval == cutscene_curr) then
		ui_draw()
	else
		--d("ui skipped")
	end

	-- hack: fix for display issue (see above hack info)
	cutscene_curr_lastval = cutscene_curr

	if isnull(cutscene_curr) 
		or not has_flag(cutscene_curr.flags, cut_hidecursor) then
		cursor_draw()
	end
end


-- handle button inputs
function playercontrol()	
	-- 
	if (btn(0)) then cursor.x = cursor.x - 1 end
	if (btn(1)) then cursor.x = cursor.x + 1 end
	if (btn(2)) then cursor.y = cursor.x - 1 end
	if (btn(3)) then cursor.y = cursor.x + 1 end

	if (btnp(4)) then input_button_pressed(1) end
	if (btnp(5)) then input_button_pressed(2) end

	-- only update position if mouse moved
	if (enable_mouse) then	
		if (stat(32)-1 != last_mouse_x) then cursor.x = stat(32)-1 end	-- mouse xpos
		if (stat(33)-1 != last_mouse_y) then cursor.y = stat(33)-1	end -- mouse ypos
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
	cursor.x = max(cursor.x, 0)
	cursor.x = min(cursor.x, 127)
	cursor.y = max(cursor.y, 0)
	cursor.y = min(cursor.y, 127)
end

-- 1 = z/lmb, 2 = x/rmb, (4=middle)
function input_button_pressed(button_index)	

	local verb_in = verb_curr

	if notnull(dialog_curr) and dialog_curr.visible then
		if notnull(hover_curr.sentence) then
			sentence_curr = hover_curr.sentence
		end
		-- skip remaining
		return
	end


		if hover_curr.verb then
			verb_curr = get_verb(hover_curr.verb)
			d("verb = "..verb_curr[2])

		elseif hover_curr.object then
			-- if valid obj, complete command
			-- else, abort command (clear verb, etc.)
			if button_index == 1 then
				if verb_curr[1] == "use" and notnull(noun1_curr) then
					noun2_curr = hover_curr.object
					d("noun2_curr = "..noun2_curr.name)					
				else
					noun1_curr = hover_curr.object						
					d("noun1_curr = "..noun1_curr.name)
				end

			elseif (notnull(hover_curr.default_verb)) then
				-- perform default verb action (if present)
				verb_curr = get_verb(hover_curr.default_verb)
				noun1_curr = hover_curr.object
				d("n1 tpe:"..type(noun1_curr))
				get_keys(noun1_curr)
				d("name:"..noun1_curr.name)
				-- force repaint of command (to reflect default verb)
				command_draw()
			end
		
		elseif k == "ui_arrow" then
			-- todo: ui arrow clicked...
			--break

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
			if notnull(noun2_curr) then
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
			if isnull(obj.owner) then
				-- walk to use pos and face dir
				if (notnull(obj.use_pos)) then d("obj use_pos="..obj.use_pos) end
				d("obj x="..obj.x..",y="..obj.y)
				d("obj w="..obj.w..",h="..obj.h)
				dest_pos = get_use_pos(obj)
				d("dest_pos x="..dest_pos.x..",y="..dest_pos.y)
				if (notnull(obj.offset_x)) then d("offset x="..obj.offset_x..",y="..obj.offset_y) end
				walk_to(selected_actor, dest_pos.x, dest_pos.y)
				-- default use direction
				use_dir=selected_actor.face_dir
				if (notnull(obj.use_dir) and (verb != verb_default)) then use_dir = obj.use_dir end
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
	elseif (cursor.y > stage_top and cursor.y < stage_top+64) then
		-- in map area
		executing_cmd = true
		-- attempt to walk to target
		selected_actor.thread = cocreate(function(x,y)
			walk_to(selected_actor, x, y)
			-- clear current command
			clear_curr_cmd()
		end)
		coresume(selected_actor.thread, cursor.x, cursor.y - stage_top)
	end

	d("--------------------------------")
end

-- collision detection
function checkcollisions()
	-- reset hover collisions
	hover_curr = {}

	-- are we in dialog mode?
	if notnull(dialog_curr) and dialog_curr.visible then
		for s in all(dialog_curr.sentences) do
			if iscursorcolliding(s) then
				hover_curr.sentence = s
			end
		end
		-- skip remaining collisions
		return
	end

	-- reset zplane info
	reset_zplanes()

	-- check room/object collisions
	for k,obj in pairs(room_curr.objects) do
		if iscursorcolliding(obj) then
			hover_curr.object = obj
		end
		-- capture bounds (even for "invisible", but not untouchable/dependent, objects)
		if (isnull(obj.class)
			 or (notnull(obj.class) and obj.class != class_untouchable))
			and (isnull(obj.dependent_on) 			-- object has a valid dependent state?
			 or find_object(obj.dependent_on).state == obj.dependent_on_state) 
		then
			recalc_bounds(obj, obj.w*8, obj.h*8, cam.x, cam.y)
		else
			-- reset bounds
			obj.bounds = nil
		end
		-- recalc z-plane
		recalc_zplane(obj)
	end

	-- check actor collisions
	for k,actor in pairs(actors) do
		if (actor.in_room == room_curr) then

			recalc_bounds(actor, actor.w*8, actor.h*8, cam.x, cam.y)			

			-- recalc z-plane
			recalc_zplane(actor)
			if iscursorcolliding(actor) then
				hover_curr.object = actor
			end
		end
	end

	-- check ui/inventory collisions
	for v in all(verbs) do
		if iscursorcolliding(v) then
			hover_curr.verb = v
		end
	end

	-- default to walkto (if nothing set)
	if (verb_curr == nil) then
		verb_curr = get_verb(verb_default)
	end

	-- update "default" verb for hovered object (if any)
	if notnull(hover_curr.object) then
		hover_curr.default_verb = find_default_verb(hover_curr.object)
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

	zplane = -1 -- default is not drawn
	
	if (true) then  -- obj is drawable
		-- calculate the correct z-plane
		-- based on x,y pos + elevation
		ypos = -1
		if notnull(obj.offset_y) then
			ypos = obj.y
		else
			ypos = obj.y + (obj.h*8)-4
		end
		zplane = flr(ypos - stage_top)
		if zplane > 0 then
			-- add to "to draw" list at appropriate zplane index
			add(draw_zplanes[zplane],obj)
		end
	end
end

function roomdraw()
	-- draw current room (base layer)
	room_map = room_curr.map
	map(room_map.x, room_map.y, 0, stage_top, room_map.w, room_map.h)
	
	-- debug walkable areas
	if show_collision then
		celx = flr((cursor.x + cam.x) /8) + room_curr.map.x
		cely = flr((cursor.y - stage_top)/8)
		spr_num = mget(celx, cely)
		
		--d("mapa x="..celx..",y="..cely)
		--d("spr:"..spr_num)

		walkable = fget(spr_num,0)
		--d("flg:"..flags)
		if walkable then
			rect((celx-room_curr.map.x)*8, stage_top+(cely*8), (celx-room_curr.map.x)*8+7, stage_top+(cely*8)+7, 11)
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
				if (notnull(obj.states)) 						-- object has a state?
				 and notnull(obj.states[obj.state])
				 and (obj.states[obj.state] > 0)
				 and (isnull(obj.dependent_on) 			-- object has a valid dependent state?
				 	or find_object(obj.dependent_on).state == obj.dependent_on_state)
				 and (isnull(obj.owner)) 						-- object is not "owned"
				then
					-- something to draw
					draw_object(obj)
				end
			else
				-- actor
				if (obj.in_room == room_curr) then
					actor_draw(obj)
				end
			end
			if (show_collision) then rect(obj.bounds.x, obj.bounds.y, obj.bounds.x1, obj.bounds.y1, 8) end
		end
	end
end

-- draw actor(s)
function actor_draw(actor)
 	-- offets
	 
	-- actor.offset_x = actor.x - (actor.w *8) /2
	-- actor.offset_y = actor.y - (actor.h *8) +2

	if (actor.moving == 1) 
	 and notnull(actor.walk_anim) then
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

	sprdraw(sprnum, actor.offset_x, actor.offset_y, 
		actor.w , actor.h, actor.trans_col, 
		actor.flip, false)

	-- talking overlay
	if (notnull(talking_actor) 
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

		--end
	end
end

function command_draw()
	-- draw current command
	command = ""
	cmd_col = 12


	if not executing_cmd then
		if notnull(verb_curr) then
			command = verb_curr[3]
		end
		if notnull(noun1_curr) then
			command = command.." "..noun1_curr.name
		end
		if verb_curr[2] == "use" 
		 and notnull(noun1_curr) then
			command = command.." with"
		end
		if notnull(noun2_curr) then
			command = command.." "..noun2_curr.name
		elseif notnull(hover_curr.object) 
		  and hover_curr.object.name != ""
			-- don't show use object with itself!
			and ( isnull(noun1_curr) or (noun1_curr != hover_curr.object) ) then
			command = command.." "..hover_curr.object.name
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
		if (talking_curr.time_left <=0) then talking_curr = nil talking_actor = nil d("talking actor cleared") end

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
		if notnull(hover_curr.default_verb)
		  and (v == hover_curr.default_verb) then
			txtcol = verb_defcol
		end		
		if (v == hover_curr.verb) then txtcol=verb_hovcol end

		-- get verb info
		vi = get_verb(v)
		print(vi[3], xpos, ypos+stage_top+1, verb_shadcol)  -- shadow
		print(vi[3], xpos, ypos+stage_top, txtcol)  -- main
		
		-- capture bounds
		v.x = xpos
		v.y = ypos
		recalc_bounds(v, #vi[3]*4, 5, 0, 0)
		if (show_collision) then rect(v.bounds.x, v.bounds.y, v.bounds.x1, v.bounds.y1, 8) end
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
	sprdraw(16, 75, stage_top + 60, 1, 1, 0)
	sprdraw(48, 75, stage_top + 73, 1, 1, 0)

	-- draw inventory
	xpos = 86
	ypos = 76
	for ipos=1, 8 do
		-- draw inventory bg
		rectfill(xpos-1, stage_top+ypos-1, xpos+8, stage_top+ypos+8, 1)
		obj = selected_actor.inventory[ipos]
		if type(obj) != 'nil' then
			-- something to draw
			obj.x = xpos
			obj.y = ypos
			-- draw object/sprite
			draw_object(obj)
			-- re-calculate bounds (as pos may have changed)
			recalc_bounds(obj, obj.w*8, obj.h*8, 0, 0)
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
		if (s == hover_curr.sentence) then txtcol=dialog_curr.hlcol end
		
		for l in all(s.lines) do
				print(smallcaps(l), xpos, ypos+stage_top, txtcol)
			ypos = ypos + 5
		end

		if (show_collision) then rect(s.bounds.x, s.bounds.y, s.bounds.x1, s.bounds.y1, 8) end
		
		ypos = ypos + 2

	end
end

-- draw cursor
function cursor_draw()
	col = cursor.cols[cursor.colpos]
	-- switch sprite color accordingly
	pal(7,col)
	spr(32, cursor.x-4, cursor.y-3, 1, 1, 0)
	pal() --reset palette

	cursor.tmr = cursor.tmr + 1
	if (cursor.tmr > 7) then
		--reset timer
		cursor.tmr = 1
		-- move to next color?
		cursor.colpos = cursor.colpos + 1
		if (cursor.colpos > #cursor.cols) then cursor.colpos = 1 end
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
	cursor.lvl = cursor.lvl - 1

	cut = {
		flags = flags,
		thread = cocreate(func),
		paused_room = room_curr,
		paused_actor = selected_actor,
		paused_cam_mode = cam.mode,
		paused_cam_following = cam.following_actor
	}
	add(cutscenes, cut)

	-- set as active cutscene
	cutscene_curr = cut

	-- reset stuff
	cam.mode = 1 --fixed
	cam.x = 0

	-- yield for system catch-up
	break_time(1)
end

function dialog_add(msg)
	if (isnull(dialog_curr)) then dialog_curr={ sentences={}, visible=false} end
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
	-- determine use pos
	if isnull(obj.use_pos) or
		(obj.use_pos == pos_infront) then
		pos.x = obj.x+((obj.w*8)/2)-cam.x-4
		pos.y = obj.y+(obj.h*8) +2

	elseif (obj.use_pos == pos_left) then
		
		if notnull(obj.offset_x) then	-- diff calc for actors
			pos.x = obj.x-cam.x - (obj.w*8+4)
			pos.y = obj.y+1
		else
			pos.x = obj.x-cam.x
			pos.y = obj.y+((obj.h*8) -2)
		end

	elseif (obj.use_pos == pos_right) then
		pos.x = obj.x+(obj.w*8)-cam.x
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

function come_out_door(door_obj, new_room)
	-- todo: switch to new room and...	
	d("door1a x:"..door_obj.x..", y:"..door_obj.y)
	change_room(new_room)
	d("door1b x:"..door_obj.x..", y:"..door_obj.y)
	-- ...auto-position actor at door_obj
	pos = get_use_pos(door_obj)
	d("pos x:"..pos.x..", y:"..pos.y)
	selected_actor.x = pos.x
	selected_actor.y = pos.y

	-- (in opposite use direction)
	do_anim(selected_actor, face_dir, door_obj.use_pos)

	selected_actor.in_room = new_room

end

function change_room(new_room)
d("change_room()...")
	-- switch to new room
	-- execute the exit() script of old room
	if notnull(room_curr) and notnull(room_curr.exit) then
		-- run script directly, so wait to finish
		room_curr.exit(room_curr)
	end
	
	-- stop all active (local) scripts
	local_scripts = {}

	-- clear current command
	clear_curr_cmd()

	-- todo: transition to new room (e.g. iris/swipe)	

	room_curr = new_room

	-- reset camera
	cam.x = 0

	-- execute the enter() script of new room
	if notnull(room_curr.enter) then
		-- run script directly
		d("t2: "..type(room_curr))
		d("scr2:"..type(room_curr.scripts.anim_fire))
		room_curr.enter(room_curr)
	end
end

function valid_verb(verb, object)
	-- check params
	if (isnull(object)) then return false end
	if (isnull(object.verbs)) then return false end
	-- look for verb
	if type(verb) == "table" then
		if notnull(object.verbs[verb[1]]) then return true end
	else
		if (notnull(object.verbs[verb])) then return true end
	end
	-- must not be valid if reached here
	return false
end

function pickup_obj(objname)
	obj = find_object(objname)
	if notnull(obj)
	 and isnull(obj.owner) then
	 	d("adding to inv")
		-- assume selected_actor picked-up at this point
		add(selected_actor.inventory, obj)
		obj.owner = selected_actor
	end
end

function owner_of(objname)
	obj = find_object(objname)
	if notnull(obj) then
		return obj.owner
	end
end

function state_of(objname, state)
	obj = find_object(objname)
	if notnull(obj) then
		return obj.state
	end
end

function set_state(objname, state)
	obj = find_object(objname)
	if notnull(obj) then
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
		if (k == name) then return obj end
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


function draw_object(obj)
	-- draw object (depending on state!)
	sprdraw(obj.states[obj.state], obj.x, obj.y, obj.w, obj.h, obj.trans_col, obj.flip_x)
end

-- walk actor to position
function walk_to(actor, x, y)

	--offset for camera
		x = x + cam.x

	local distance = sqrt((x - actor.x) ^ 2 + (y - actor.y) ^ 2)
	local step_x = actor.speed * (x - actor.x) / distance
	local step_y = actor.speed * (y - actor.y) / distance

	-- abort if we're already there!
	if (distance < 1) then return end

	-- check target position is in walkable block
	celx = flr(x/8) + room_curr.map.x
	cely = flr(y/8)
	d("mapb x="..celx..",y="..cely)
	spr_num = mget(celx, cely)	
	d("spr:"..spr_num)
	
	walkable = fget(spr_num, 0) -- flag 0 = walkable
	-- if it is...
	if walkable then
		d("walkable!")
		actor.moving = 1 --walking
		actor.flip = (step_x<0)

		-- face dir (at end of walk)
		actor.face_dir = face_right
		if (actor.flip) then actor.face_dir = face_left end

		for i = 0, distance/actor.speed do
			--d("walking...")
			actor.x = actor.x + step_x
			actor.y = actor.y + step_y
			yield()
		end
		actor.moving = 2 --arrived
	else
		actor.moving = 0 --stopped
	end
end



-- internal functions -----------------------------------------------


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
	if (notnull(lines)) d(#lines[1])
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
		obj.offset_y = obj.y - (obj.h *8) +2
		--if notnull(obj.offset_x) then
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
	if (isnull(obj.bounds)) then return false end
	bounds=obj.bounds
	if (cursor.x + bounds.cam_off_x > bounds.x1 or cursor.x + bounds.cam_off_x < bounds.x) 
	 or (cursor.y>bounds.y1 or cursor.y<bounds.y) then
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

function isnull(var)
	return (type(var) == 'nil')
end

function notnull(var)
	return (type(var) != 'nil')
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
111111110000000033333333ffffffff7777777766666666cccccccc00000000f9e9f9f9ddd5ddd5555555550000000000000000000000000000000044444444
111111110000000033333333ffffffff7777777766666666cccccccc000000009eee9f9fdd5ddd5d55555555000000000000000000000000000000004ffffff4
111111110000000033333333ffffffff7777777766666666cccccccc00000000feeef9f9d5ddd5dd55555555000000000000000000000000000000004f444494
111111110000000033333333ffffffff7777777766666666cccccccc000000009fef9fef5ddd5ddd55555555000000000000000000000000000000004f444494
111111110000000033333333ffffffff7777777766666666cccccccc00000000f9f9feeeddd5ddd555555555000000000000000000000000000000004f444494
111111110000000033333333ffffffff7777777766666666cccccccc000000009f9f9eeedd5ddd5d55555555000000000000000000000000000000004f444494
111111110000000033333333ffffffff7777777766666666cccccccc00000000f9f9feeed5ddd5dd55555555000000000000000000000000000000004f444494
111111110000000033333333ffffffff7777777766666666cccccccc000000009f9f9fef5ddd5ddd55555555000000000000000000000000000000004f444494
cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f444494
cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f444494
cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f449994
cccccccc0000000000000000dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f994444
cccccccc0000000000000000dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000044444444
cccccccc0000000000000000dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000044444444
cccccccc0000000000000000dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000049a44444
cccccccc0000000000000000dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000049944444
dddddddd0000000055555533ffffffdd77777755666666ddcccccc11000000000000000000000000000000000000000000000000000000000000000044444444
dddddddd0000000055553333ffffdddd777755556666ddddcccc111100000000000000000000000000000000000000000000000000000000000000004444fff4
dddddddd0000000055333333ffdddddd7755555566ddddddcc11111100000000000000000000000000000000000000000000000000000000000000004fff4494
dddddddd0000000053333333dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f444494
dddddddd0000000053333333dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f444494
dddddddd0000000055333333dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f444494
dddddddd0000000055553333dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f444494
dddddddd0000000055555533dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f444494
555555550000000055555555ddffffff55777777dd66666611cccccc00000000000000000000000000000000000000000000000000000000000000004f444494
555555550000000033335555ddddffff55557777dddd66661111cccc00000000000000000000000000000000000000000000000000000000000000004f444994
555555550000000033333355ddddddff55555577dddddd66111111cc00000000000000000000000000000000000000000000000000000000000000004f499444
555555550000000033333335dddddddd55555555dddddddd1111111100000000000000000000000000000000000000000000000000000000000000004f944444
555555550000000033333335dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000044444400
555555550000000033333355dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000044440000
555555550000000033335555dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000044000000
555555550000000055555555dddddddd55555555dddddddd11111111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777555555555555770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770700000000007070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770070000000070070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777776000000677770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000677600000770066000000660070000000000000000000000000000000000000000000000000000000000000000
0000000000000000000a000000000000700006077060000770606000000606070000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700005077050000770506000000605070000000000000000000000000000000000000000000000000000000000000000
0000000000a0a000000aa000000a0a00700000077000000770006000000600070000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000aaaa0000aaa000700000077000000770050000000050070000000000000000000000000000000000000000000000000000000000000000
0000000000a9aa0000a99a0000aa9a00700000077000000770500000000005070000000000000000000000000000000000000000000000000000000000000000
0000000000a99a0000a99a0000a99a00777777777777777775000000000000770000000000000000000000000000000000000000000000000000000000000000
00000000004444000044440000444400555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000
99999999777777777777777777777777700000077776000077777777777777770000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555700000077776000055555555555555550000000000000000000000000000000000000000000000000000000000000000
444444440dd6dd6dd6dd6dd6d6dd6d50700000077776000044444444444444440000000000000000000000000000000000000000000000000000000000000000
ffff4fff0dd6dd6dd6dd6dd6d6dd6d507000000766665555444ffffffffff4440000000000000000000000000000000000000000000000000000000000000000
44494944066666666666666666666650700000070000777644494444444494440000000000000000000000000000000000000000000000000000000000000000
444949440d6dd6dd6dd6dd6ddd6dd65070000007000077764449444aa44494440000000000000000000000000000000000000000000000000000000000000000
444949440d6dd6dd6dd6dd6ddd6dd650777777770000777644494444444494440000000000000000000000000000000000000000000000000000000000000000
44494944066666666666666666666650555555555555666644499999999994440000000000000000000000000000000000000000000000000000000000000000
444949440dd6dd600000000056dd6d50000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
444949440dd6dd650000000056dd6d50000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
44494944066666650000000056666650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
444949440d6dd6d5000000005d6dd650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
444949440d6dd6d5000000005d6dd650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
44494944066666650000000056666650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000000000000
999949990dd6dd650000000056dd6d50000000000000000044499999999994440000000000000000000000000000000000000000000000000000000000000000
444444440dd6dd650000000056dd6d50000000000000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666666f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006cccccc6
bbbcccc8888bbbbcccc8888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d666666d
fccccc8ffbbbbbcff88888bf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fccc888ffbbbcccff888bbbf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
ff5500ffff5500ffff5500ff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fff50ffffff50ffffff50fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff6665ff
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000100000000000000000000000000010000010101010000000000000000000100010101010100000000000000000001000101010101000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
444444484848484848484848484444444545454a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a4a45454500000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
444444480000484848484848484444444545454a4a4a4a4a4a4a848585854a4a4a4a4a4a4a45454500000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44004448000048484848484848440044450045a5a5a5a5a5a5a594a4a495a5a5a5a5a5a5a545004500000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044a0a0a0a0a1a2a3a0a0a0440044450045a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a745004500000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044b0b0b0b0b1b2b3b0b0b0440044450045b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b745004500000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707074544445556560606060606060606060606060606060606075534500000000000000004454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707062424242424242727070707465606060606060606060606060606060606060606060607500000000000000006470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707060606060606060606060606060606060606060606060606000000000000000007070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
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

