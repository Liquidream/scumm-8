pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
-- scumm-8
-- paul nicholas

-- ### luamin command
-- python c:\users\pauln\owncloud\dev\pico-8\picotool\p8tool luamin c:\users\pauln\owncloud\games\pico-8\carts\git_repos\scumm-8\scumm-8.p8

-- ### luamin fixes ###
--	"\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92"

-- was  6439 tokens (b4 pathfinding)
-- then 6500 tokens (after pathfinding & token hunting)
-- then 6673 tokens (after adding transitions, camera pan/follow, turn-to-face, etc)


-- debugging
show_debuginfo = false
show_collision = false
--show_pathfinding = true
show_perfinfo = false
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
verb_hovcol = 7    -- hover color (white)
verb_shadcol = 1   -- shadow (dk blue)
verb_defcol = 10   -- default action (yellow)


-- ================================================================
-- scumm-8 enums/constants
-- ================================================================

-- object states
state_closed = 1
state_open = 2
state_off = 1
state_on = 2
state_gone = 1
state_here = 2

-- object classes (bitflags)
class_untouchable = 1 -- will not register when the cursor moves over it. the object is invisible to the user.
class_pickupable = 2  -- can be placed in actor inventory
class_talkable = 4		-- can talk to actor/object
class_giveable = 8		-- can be given to an actor/object
class_openable = 16   -- can be opened/closed
class_actor = 32      -- is an actor/person

cut_noverbs = 1 		-- this removes the interface during the cut-scene.
cut_no_follow = 4   -- this disables the follow-camera being reinstated after cut-scene.

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
anim_face = 1	 -- face actor in a direction (show the turning stages of animation)


-- ================================================================
-- room definitions
-- ================================================================
rooms = {

	title_room = {
		map_x = 0,
		map_y = 8,
		enter = function(me)

			-- todo: anything here?
			--selected_actor = actors.main_actor
		
			if not me.done_intro then
				-- don't do this again
				me.done_intro = true
			
					cutscene(cut_noverbs + cut_no_follow, 
						function()
							-- intro
							break_time(50)
							print_line("in a galaxy not far away...",64,45,8,1)
							change_room(rooms.first_room, 1)
							print_line("cozy fireplaces...",90,20,8,1)
							print_line("(just look at it!)",90,20,8,1)

							-- part 2
							printh("a")
							change_room(rooms.second_room, 1)
							print_line("strange looking aliens...",30,20,8,1,true)
							put_actor_at(actors.purp_tentacle, 130, actors.purp_tentacle.y, rooms.second_room)
							walk_to(actors.purp_tentacle, 
								actors.purp_tentacle.x-30, 
								actors.purp_tentacle.y)
							wait_for_actor(actors.purp_tentacle)
							say_line(actors.purp_tentacle, "what did you call me?!")

							-- part 3
							change_room(rooms.back_garden, 1)
							print_line("and even swimming pools!",90,20,8,1,true)
							camera_at(200)
							camera_pan_to(64)
							wait_for_camera()
							print_line("quack!",45,60,10,1)

							-- part 4
							change_room(rooms.outside_room, 1)
							
							-- outro
							break_time(25)
							change_room(rooms.title_room, 1)
							camera_at(0)
							
							print_line("coming soon...:to a pico-8 near you!",64,45,8,1)
							fades(1,1)	-- fade out
							break_time(100)
							
						end) -- end cutscene

				end -- if not done intro
		end,
		exit = function()
			-- todo: anything here?
		end,
		scripts = {	  -- scripts that are at room-level
		},
		objects = {

		},
	},

	first_room = {
		map_x = 0,
		map_y = 0,
		col_replace = { 
			{ 7, 15 }, 
			-- { 4, 5 }, 
			-- { 6, 8 } 
		},
		enter = function(me)
			-- animate fireplace
			start_script(me.scripts.anim_fire, true) -- bg script

			start_script(me.scripts.spin_top, true)
		end,
		exit = function(me)
			-- pause fireplace while not in room
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
				dir=-1				
				while true do	
					for x=1,3 do					
						for f=1,3 do
							set_state("spinning top", f)
							break_time(4)
						end
						-- move top
						top = find_object("spinning top")
						top.x -= dir						
					end	
					dir *= -1
				end				
			end
			-- ,watch_tentacle = function()
			-- 	while true do
			-- 		d("watching tentacle...")
			-- 		do_anim(selected_actor, anim_face, actors.purp_tentacle)
			-- 		break_time(10)
			-- 	end
			-- end
		},
		objects = {
			fire = {
				name = "fire",
				state = 1, --"frame1",
				x = 8 *8, -- (*8 to use map cell pos)
				y = 4 *8,
				states = {145, 146, 147},
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				--use_dir = face_back,
				--use_pos = pos_infront,

				-- just as an example
				-- dependent_on = "front door",	-- object is dependent on the state of another
				-- dependent_on_state = state_open,

				verbs = {
					lookat = function()
						say_line("it's a nice, warm fire...")
						--wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("ouch! it's hot!;*stupid fire*")
						--wait_for_message()
					end,
					talkto = function()
						say_line("'hi fire...'")
						--wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("the fire didn't say hello back;burn!!")
						--wait_for_message()
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
				}
			},
			front_door = {
				name = "front door",
				class = class_openable,
				state = state_closed,
				x = 1*8, -- (*8 to use map cell pos)
				y = 2*8,
				elevation = -10, -- force to always be bg
				states = { -- states are spr values
					143, -- state_closed
					0   -- state_open
				},
				--flip_x = false, -- used for flipping the sprite
				--flip_y = false,
				w = 1,	-- relates to spr or map cel, depending on above
				h = 4,  --
				use_pos = pos_right,
				use_dir = face_left,
				verbs = {
					walkto = function(me)
						if state_of(me) == state_open then
							-- go to new room!
							come_out_door(rooms.outside_room.objects.front_door)
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
				state = state_open,
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
				state = state_open,
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
					give = function(me, noun2)
						if noun2 == actors.purp_tentacle then
							say_line("can you fill this up for me?")
							--wait_for_message()
							say_line(actors.purp_tentacle, "sure")
							--wait_for_message()
							me.owner = actors.purp_tentacle
							break_time(30)
							say_line(actors.purp_tentacle, "here ya go...")
							--wait_for_message()
							me.state = state_closed
							me.name = "full bucket"
							pickup_obj(me)
						else
							say_line("i might need this")
						end
					end
					--[[use = function(me, noun2)
						if (noun2.name == "window") then
							set_state("window", state_open)
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
				state = state_closed,
				--use_dir = face_back,

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
						if not me.done_cutscene then
							cutscene(cut_noverbs, 
								function()
									me.done_cutscene = true
									-- cutscene code
									print_line("*bang*",40,20,8,1)
									set_state(me, state_open)
									--wait_for_message()
									change_room(rooms.second_room, 1)
									selected_actor = actors.purp_tentacle
									walk_to(selected_actor, 
										selected_actor.x+10, 
										selected_actor.y)
									say_line("what was that?!")
									--wait_for_message()
									say_line("i'd better check...")
									--wait_for_message()
									walk_to(selected_actor, 
										selected_actor.x-10, 
										selected_actor.y)
									change_room(rooms.first_room, 1)
									-- wait for a bit, then appear in room1
									break_time(50)
									put_actor_at(selected_actor, 115, 44, rooms.first_room)
									walk_to(selected_actor, 
										selected_actor.x-10, 
										selected_actor.y)
									say_line("intruder!!!")
									do_anim(actors.main_actor, anim_face, actors.purp_tentacle)
									--wait_for_message()
								end,
								-- override for cutscene
								function()
									--if cutscene_curr.skipped then
									--d("override!")
									change_room(rooms.first_room)
									put_actor_at(actors.purp_tentacle, 105, 44, rooms.first_room)
									stop_talking()
									do_anim(actors.main_actor, anim_face, actors.purp_tentacle)
								end
							)
						end
						-- (code here will not run, as room change nuked "local" scripts)
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
				state = state_open,
				x = 1 *8, -- (*8 to use map cell pos)
				y = 2 *8,
				w = 1,	-- relates to spr
				h = 4,  --
				use_pos = pos_right,
				use_dir = face_left,
				verbs = {
					walkto = function()
						-- go to new room!
						come_out_door(rooms.first_room.objects.hall_door_kitchen)
					end
				}
			},
			back_door = {
				name = "back door",
				class = class_openable,
				state = state_closed,
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
						if state_of(me) == state_open then
							-- go to new room!
							come_out_door(rooms.back_garden.objects.garden_door_kitchen)
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
			-- =========================================
			-- initialise game in first room entry...
			-- =========================================
			if not me.done_intro then
				-- don't do this again
				me.done_intro = true
				-- set which actor the player controls by default
				selected_actor = actors.main_actor
				-- init actor
				put_actor_at(selected_actor, 144, 36, rooms.outside_room)
				-- make camera follow player
				-- (setting now, will be re-instated after cutscene)
				camera_follow(selected_actor)
				-- do cutscene
				cutscene(cut_noverbs, 
					-- cutscene code (hides ui, etc.)
					function()
						camera_at(0)
						camera_pan_to(selected_actor)
						wait_for_camera()
						say_line("let's do this")
						--wait_for_message()
					end
				)
			end
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
				state = state_closed,
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
				--use_pos = pos_infront,
				use_dir = face_back,
				verbs = {
					walkto = function(me)
						if state_of(me) == state_open then
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

	back_garden = {
		map_x = 40 ,
		map_y = 0,
		map_x1 = 63, 	-- map coordinates to draw to (x,y)
		map_y1 = 7,
		enter = function()
			-- todo: anything here?
			-- camera_at(200)
			-- camera_pan_to(0)
			-- wait_for_camera()
		end,
		exit = function()
			-- todo: anything here?
		end,
		scripts = {	  -- scripts that are at room-level
		},
		objects = {
			garden_door_kitchen = {
				name = "kitchen",
				state = state_open,
				x = 13 *8, -- (*8 to use map cell pos)
				y = 1 *8,
				w = 1,	-- relates to spr
				h = 3,  --
				verbs = {
					walkto = function()
						-- go to new room!
						come_out_door(rooms.second_room.objects.back_door)
					end
				}
			}
		},
	},

}

-- ================================================================
-- actor definitions
-- ================================================================
actors = {
	-- initialize the player's actor object
	main_actor = { 		
		--name = "",
		class = class_actor,
		w = 1,
		h = 4,
		face_dir = face_front, 	-- default direction facing
		-- sprites for idle (front, left, back, right) - right=flip
		idle = { 1, 3, 5, 3},	
		talk = { 6, 22, 21, 22},
		walk_anim = { 2, 3, 4, 3},
		--flip = false, -- used for flipping the sprite (left/right dir)
		col = 12,				-- speech text colour
		trans_col = 11,	-- transparency col in sprites
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
		-- sprites for idle (front, left, back, right) - right=flip
		idle = { 30, 30, 30, 30 },
		talk = { 47, 47, 47, 47 },
		col = 11, --13,    		-- speech text colour
		trans_col = 15, -- transparency col in sprites
		speed = 0.25,  	-- walking speed
		use_pos = pos_left,
		--in_room = rooms.first_room,
		in_room = rooms.second_room,
		verbs = {
				lookat = function()
					say_line("it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(cut_noverbs, function()
						--do_anim(actors.purp_tentacle, anim_face, selected_actor)
						say_line(me,"what do you want?")
						--wait_for_message()
					end)

					-- dialog loop start
					while (true) do
						-- build dialog options
						dialog_add("where am i?")
						dialog_add("who are you?")
						dialog_add("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?")
						dialog_add("nevermind")
						dialog_start(selected_actor.col, 7)

						-- wait for selection
						while not selected_sentence do break_time() end
						-- chosen options
						dialog_hide()

						cutscene(cut_noverbs, function()
							say_line(selected_sentence.msg)
							--wait_for_message()
							
							if selected_sentence.num == 1 then
								say_line(me, "you are in paul's game")
								--wait_for_message()

							elseif selected_sentence.num == 2 then
								say_line(me, "it's complicated...")
								--wait_for_message()

							elseif selected_sentence.num == 3 then
								say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
								--wait_for_message()

							elseif selected_sentence.num == 4 then
								say_line(me, "ok bye!")
								--wait_for_message()
								dialog_end()
								return
							end
						end)

						dialog_clear()

					end --dialog loop
				end -- talkto
			}
	}
}

-- ================================================================
-- script overloads
-- ================================================================

-- this script is execute once on game startup
function startup_script()	
	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	

	change_room(rooms.title_room, 1) -- iris fade	
	--change_room(rooms.first_room, 1) -- iris fade	
	--change_room(rooms.outside_room, 1) -- iris fade
end

-- logic used to determine a "default" verb to use
-- (e.g. when you right-click an object)
function find_default_verb(obj)
  local default_verb = nil

	if has_flag(obj.class, class_talkable) then
		default_verb = "talkto"
	elseif has_flag(obj.class, class_openable) then
		if obj.state == state_closed then
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
		if vi[2] == default_verb then default_verb=v break end
	end
	return default_verb
end

-- actions to perform when object doesn't have an entry for verb
function unsupported_action(verb, obj1, obj2)

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


-- (end of customisable game content)
























-- ################################################################
-- scumm-8 public api functions
-- ================================================================
-- (you should not need to modify anything below here!)
-- ################################################################

function camera_at(val)
	-- check params for obj/actor
	if type(val) == "table" then
		val = val.x
	end
	-- keep camera within "room" bounds
	cam_x = mid(0, val-64, (room_curr.map_w*8)-screenwidth-1 )
	-- clear other cam values
	cam_pan_to_x = nil
	cam_following_actor = nil
end

function camera_follow(actor)
	-- set target
	--d("setting cam follow to:"..type(actor))
	cam_following_actor = actor
	-- clear other cam values
	cam_pan_to_x = nil

	cam_script = function()
		-- keep the camera following actor
		-- (until further notice)
		while cam_following_actor do
			-- keep camera within "room" bounds
			cam_x = mid(0, cam_following_actor.x - 64, (room_curr.map_w*8)-screenwidth-1 )
			yield()
		end
	end
	start_script(cam_script, true) -- bg script
end


function camera_pan_to(val)
	-- check params for obj/actor
	if type(val) == "table" then
		val = val.x
	end

	-- todo: set target (within bounds!)
	cam_pan_to_x = val


	-- clear other cam values
	cam_following_actor = nil

	cam_script = function()
		-- update the camera pan until reaches dest
		while (true) do
			printh("panning...")
			center_view = cam_x + flr(screenwidth/2) +1
			printh("center_view: "..center_view)
			printh("cam_pan_to_x: "..cam_pan_to_x)
			if center_view == cam_pan_to_x then
				-- pan complete
				cam_pan_to_x = nil
				return
			elseif cam_pan_to_x > center_view then
		  	cam_x += 0.5
			else
				cam_x -= 0.5
			end
			-- keep camera within "room" bounds
			cam_x = mid(0, cam_x, (room_curr.map_w*8)-screenwidth-1 )
			yield()
		end
	end

	start_script(cam_script, true) -- bg script
end


function wait_for_camera()
	while script_running(cam_script) do
		yield()
	end
end


function cutscene(flags, func_cutscene, func_override)
	-- decrement the cursor level
	--cursor_lvl = cursor_lvl - 1
			
	cut = {
		flags = flags,
		thread = cocreate(func_cutscene),
		override = func_override,
		-- paused_room = room_curr,
		-- paused_actor = selected_actor,
		paused_cam_following = cam_following_actor
	}
	add(cutscenes, cut)

	-- set as active cutscene
	cutscene_curr = cut

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
	selected_sentence = nil
end

function dialog_hide()
	dialog_curr.visible = false
end

function dialog_clear()
	dialog_curr.sentences = {}
	selected_sentence = nil
end

function dialog_end()
	dialog_curr=nil
end


function get_use_pos(obj)
	obj_use_pos = obj.use_pos

	-- first check for specific pos
	if type(obj_use_pos) == "table" then
		x = obj_use_pos.x-cam_x
		y = obj_use_pos.y-stage_top

	-- determine use pos
	elseif not obj_use_pos or
		obj_use_pos == pos_infront then
		x = obj.x + ((obj.w*8)/2) -cam_x -4
		y = obj.y + (obj.h*8) +2

	elseif obj_use_pos == pos_left then
		-- diff calc for actors
		if obj.offset_x then
			x = obj.x -cam_x - (obj.w*8 +4)
			y = obj.y + 1
		else
			-- object pos
			x = obj.x -cam_x  -2
			y = obj.y + ((obj.h*8) -2)
		end

	elseif obj_use_pos == pos_right then
		x = obj.x + (obj.w*8)-cam_x
		y = obj.y + ((obj.h*8) -2)
	end
	
	return {x=x,y=y}
end


function do_anim(actor, cmd_type, cmd_value)

	-- animate turn to face (object/actor or explicit direction)
	if cmd_type == anim_face then
		
		-- check if cmd_value is an actor/object, rather than explicit face_dir
		if type(cmd_value) == "table" then
			-- need to calculate face_dir from positions
			angle_rad = atan2(actor.x  - cmd_value.x , cmd_value.y - actor.y)
			-- calc player's angle offset in this
			plr_angle = 93 * (3.1415/180)
			-- adjust for player's angle
			angle_rad = plr_angle - angle_rad

			-- convert radians to degrees
			-- (note: everyone says should be: rad * (180/pi), but
			--        that only seems to give me degrees 0..57? so...)
			degrees = angle_rad * (1130.938/3.1415)

			-- angle wrap for circle
			degrees = degrees % 360
			if (degrees < 0) then degrees += 360 end

			-- set final target face direction to obj/actor
			cmd_value = 4 - flr(degrees/90)
		end

		while actor.face_dir != cmd_value do
			-- turn to target face_dir
			if actor.face_dir < cmd_value then
				actor.face_dir += 1
			else 
				actor.face_dir -= 1
			end
			-- is target dir left? flip?
			actor.flip = (actor.face_dir  == face_left)
			break_time(10)
		end
	end
end

-- open one (or more) doors
function open_door(door_obj1, door_obj2)
	if state_of(door_obj1) == state_open then
		say_line("it's already open")
	else
		set_state(door_obj1, state_open)
		if door_obj2 then set_state(door_obj2, state_open) end
	end
end

-- close one (or more) doors
function close_door(door_obj1, door_obj2)
	if state_of(door_obj1) == state_closed then
		say_line("it's already closed")
	else
		set_state(door_obj1, state_closed)
		if door_obj2 then set_state(door_obj2, state_closed) end
	end
end

function come_out_door(door_obj, fade_effect)
	
	new_room = door_obj.in_room

	-- reset camera pos in new room
	-- (if camera following, then this will get re-applied)
	cam_x = 0

	-- switch to new room and...
	change_room(new_room, fade_effect)
	-- ...auto-position actor at door_obj in new room...
	pos = get_use_pos(door_obj)
	put_actor_at(selected_actor, pos.x, pos.y, new_room)

	-- ...in opposite use direction!
	if door_obj.use_dir then
		opp_dir = door_obj.use_dir + 2
		if opp_dir > 4 then
			opp_dir -= 4
		end
	else
	 opp_dir = 1 -- front
	end
	selected_actor.face_dir = opp_dir
	--do_anim(selected_actor, anim_face, opp_dir)
end

function fades(fade, dir) -- 1=down, -1=up
	if dir == 1 then
		fade_amount = 0
	else
		fade_amount = 50
	end

	while true do
		fade_amount += dir*2

		if fade_amount > 50
		 or fade_amount < 0 then
			return
		end

		-- iris down/up
		if fade == 1 then
			fade_iris = min(fade_amount, 32)
		end

		yield()
	end
end

function change_room(new_room, fade)
	printh(">1")
	-- fade down existing room (or skip if first room)
	if fade and room_curr then
		fades(fade, 1)
	end

	printh(">2")

	-- switch to new room
	-- execute the exit() script of old room
	if room_curr and room_curr.exit then
		-- run script directly, so wait to finish
		printh(">2a")
		room_curr.exit(room_curr)
	end
	
printh(">3")

	-- stop all active (local) scripts
	local_scripts = {}

	-- clear current command
	clear_curr_cmd()
	


	printh(">4")

	-- actually change rooms now
	room_curr = new_room

	-- stop everyone talking & remove displayed text
	stop_talking()

	printh(">5")

	-- fade up again?
	-- (use "thread" so that room.enter code is able to 
	--  reposition camera before fade-up, if needed)
	if fade then		
		start_script( function() 
				fades(fade, -1) 
		end, true)
	else
		-- no fade - reset any existing fade
		fade_iris = 0
	end

	-- execute the enter() script of new room
	if room_curr.enter then
		-- run script directly
		room_curr.enter(room_curr)
	end

	printh(">3")
end

function valid_verb(verb, object)
	-- check params
	if not object then return false end
	if not object.verbs then return false end
	-- look for verb
	if type(verb) == "table" then
		if object.verbs[verb[1]] then return true end
	else
		if object.verbs[verb] then return true end
	end
	-- must not be valid if reached here
	return false
end

function pickup_obj(objname)
	obj = find_object(objname)
	if obj
	 --and not obj.owner 
	 then
		-- assume selected_actor picked-up at this point
		add(selected_actor.inventory, obj)
		obj.owner = selected_actor
		-- remove it from room
		del(obj.in_room.objects,obj)
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
	if type(name) == "table" then return name end
	-- else look for object by unique name
	for k,obj in pairs(room_curr.objects) do
		if obj.name == name then return obj end
	end
end

function start_script(func, bg, noun1, noun2)
	-- create new thread for script and add to list of local_scripts (or background scripts)
	local thread = cocreate(func)
	-- background or local?
	if bg then
		add(global_scripts, {func, thread, noun1, noun2} )
	else
		add(local_scripts, {func, thread, noun1, noun2} )
	end
end


function script_running(func)
	-- try local first
	for k,scr_obj in pairs(local_scripts) do
		if (scr_obj[1] == func) then 
			--d("found in local!")
			return scr_obj
		end
	end
	-- failing that, try global
	for k,scr_obj in pairs(global_scripts) do
		if (scr_obj[1] == func) then 
			--d("found in global!")
			return scr_obj
		end
	end
	-- must not be running
	return false
end

function stop_script(func)
	-- find script and stop it running
	scr_obj = script_running(func)
	if scr_obj then
		-- just delete from all scripts (don't bother checking!)
		del(local_scripts, scr_obj)
		del(global_scripts, scr_obj)
	end
end

function break_time(jiffies)
	jiffies = jiffies or 1
	-- wait for cycles specified (min 1 cycle)
	for x = 1, jiffies do
		yield()
	end
end

function wait_for_message()
	while talking_curr != nil do
		yield()
	end
end

-- uses actor's position and color
function say_line(actor, msg, dont_wait_msg)
	-- check for missing actor
	if type(actor) == "string" then
		-- assume actor ommitted and default to current
		msg = actor
		actor = selected_actor
	end

	-- offset to display speech above actors (dist in px from their feet)
	ypos = actor.y - (actor.h)*8 +4  --text_offset
	-- trigger actor's talk anim
	talking_actor = actor
	-- call the base print_line to show actor line
	print_line(msg, actor.x, ypos, actor.col, 1, dont_wait_msg)
end

-- stop everyone talking & remove displayed text
function stop_talking()
	talking_curr = nil 
	talking_actor = nil
end


function print_line(msg, x, y, col, align, dont_wait_msg)
  -- punctuation...
	--  > ":" new line, shown after text prior expires
	--  > ";" new line, shown immediately
	-- note: an actor's talk animation is not activated as it is with say-line.

	local col=col or 7 		-- default to white
	local align=align or 0	-- default to no align

	--d(msg)
	-- default max width (unless hit a screen edge)
	local lines = {}
	local curchar = ""
	local msg_left = "" --used for splitting messages with ";"
	
	longest_line=0
	-- auto-wrap
	-- calc max line width based on x-pos/available space
	screen_space = min(x -cam_x, screenwidth - (x -cam_x))
	-- (or no less than min length)
	max_line_length = max(flr(screen_space/2), 16)

	-- search for ";"'s
	msg_left = ""
	for i = 1, #msg do
		curchar=sub(msg,i,i)
		if curchar == ":" then -- msg break
			--d("msg break!")
			-- show msg up to this point
			-- and process the rest as new message
			
			-- next message?
			msg_left = sub(msg,i+1)
			-- redefine curr msg
			msg = sub(msg,1,i-1)
			break
		end
	end

	lines = create_text_lines(msg, max_line_length) --, true)

	-- find longest line
	longest_line = longest_line_size(lines)

	-- center-align text block
	if align == 1 then
		xpos = x -cam_x - ((longest_line*4)/2)
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


	-- and wait for message?
	if not dont_wait_msg then
		wait_for_message()
	end
end

function put_actor_at(actor, x, y, room)
	if room then actor.in_room = room end
	actor.x = x
	actor.y = y
end

-- walk actor to position
function walk_to(actor, x, y)
		--offset for camera
		x = x + cam_x

		actor_cell_pos = getcellpos(actor)
		celx = flr(x /8) + room_curr.map_x
		cely = flr(y /8) + room_curr.map_y
		target_cell_pos = { celx, cely }

		-- use pathfinding!
		path = find_path(actor_cell_pos, target_cell_pos)

		-- finally, add our destination to list
		final_cell = getcellpos({x=x, y=y})
		if is_cell_walkable(final_cell[1], final_cell[2]) then
			add(path, final_cell)
		end

		for p in all(path) do
			px = (p[1]-room_curr.map_x)*8 + 4
			py = (p[2]-room_curr.map_y)*8 + 4

			local distance = sqrt((px - actor.x) ^ 2 + (py - actor.y) ^ 2)
			local step_x = actor.speed * (px - actor.x) / distance
			local step_y = actor.speed * (py - actor.y) / distance

			-- only walk if we're not already there!
			if distance > 1 then 
				--walking
				actor.moving = 1 
				actor.flip = (step_x<0)
				-- face dir (at end of walk)
				-- todo: add walk front/back at some point
				actor.face_dir = face_right
				if (actor.flip) then actor.face_dir = face_left end

				for i = 0, distance/actor.speed do
					actor.x = actor.x + step_x
					actor.y = actor.y + step_y
					yield()
				end
			end
		end
		--d("reach dest")
		actor.moving = 2 --arrived
end

function wait_for_actor(actor)
	actor = actor or selected_actor
	-- wait for actor to stop moving/turning
	while actor.moving != 2 do
		yield()
	end
end



-- ================================================================
-- internal functions
-- ================================================================

-- global vars
screenwidth = 127
screenheight = 127
stage_top = 16

-- offset to display speech above actors (dist in px from their feet)
--text_offset = (selected_actor.h-1)*8

cam_x = 0
--cam_following_actor = selected_actor
cam_pan_to_x = nil	-- target pos to pad camera to
cam_script = nil	-- active camera logic script (pan-to, follow, etc.)

cursor_x = screenwidth / 2
cursor_y = screenheight / 2
--cursor_lvl = 1 	-- for cutscenes (<=0 - disable cursor)
cursor_tmr = 0 	-- used to animate cursor col
cursor_cols = {7,12,13,13,12,7}
cursor_colpos = 1

ui_arrows = {
	{ spr = 16, x = 75, y = stage_top + 60 },
	{ spr = 48, x = 75, y = stage_top + 72 }
}


last_mouse_x = 0
last_mouse_y = 0
-- wait for button release before repeating action
ismouseclicked = false

room_curr = nil			-- contains the current room definition
verb_curr = nil 		-- contains the active verb to be used (e.g. walk)
noun1_curr = nil 		-- main/first object in command
noun2_curr = nil 		-- holds whatever is used after the preposition (e.g. "with <noun2>")
cmd_curr = "" 			-- contains last displayed or actioned command
executing_cmd = false
talking_curr = nil 	-- currently displayed speech {x,y,col,lines...}
dialog_curr = nil   -- currently displayed dialog options to pick
cutscene_curr = nil -- currently active cutscene
talking_actor = nil -- currently talking actor
fade_iris = 0			  -- depends on effect above

global_scripts = {}	-- table of scripts that are at game-level (background)
local_scripts = {}	-- table of scripts that are actively running
cutscenes = {} 			-- table of scripts for the active cutscene(s)
draw_zplanes = {}		-- table of tables for each of the (8) zplanes for drawing depth

-- game loop

function _init()
	-- use mouse input?
	if enable_mouse then poke(0x5f2d, 1) end

	-- init all the rooms/objects/actors
	game_init()

	-- run any startup script(s)
  start_script(startup_script, true)
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
	if selected_actor and selected_actor.thread and not coresume(selected_actor.thread) then
		selected_actor.thread = nil
	end

	-- global scripts (always updated - regardless of cutscene)
	update_scripts(global_scripts)

	-- update active cutscene (if any)
	if cutscene_curr then
		if cutscene_curr.thread and not coresume(cutscene_curr.thread) then
			-- cutscene ended, restore prev state	
			--if (room_curr != cutscene_curr.paused_room) then change_room(cutscene_curr.paused_room) end
			
			-- restore follow-cam if flag allows (and had a value!)
			if not has_flag(cutscene_curr.flags, cut_no_follow) and
			 cutscene_curr.paused_cam_following then
				camera_follow(cutscene_curr.paused_cam_following)
				-- assume to re-select prev actor
				selected_actor = cutscene_curr.paused_cam_following
			end
			-- now delete cutscene
			del(cutscenes, cutscene_curr)
			cutscene_curr = nil
			-- any more cutscenes?
			if #cutscenes > 0 then
				cutscene_curr = cutscenes[#cutscenes]
			end
		end
	else
		-- no cutscene...
		-- update all the active scripts
		-- (will auto-remove those that have ended)
	
		-- local/room-level scripts
		update_scripts(local_scripts)		
	end

	-- player/ui control
	playercontrol()

	-- check for collisions
	check_collisions()
end


function game_draw()
	-- clear screen every frame?
	rectfill(0, 0, screenwidth, screenheight, 0)

	-- reposition camera
	camera(cam_x, 0)

	-- clip room bounds (also used for "iris" transition)
	clip(
		0 +fade_iris, 
		stage_top +fade_iris, 
		screenwidth+1 -fade_iris*2, 
		64 -fade_iris*2)

	-- draw room (bg + objects + actors)
	room_draw()

	-- reset camera for "static" content (ui, etc.)
	camera(0,0)
	-- reset clip bounds
	clip()

	if show_perfinfo then 
		print("cpu: "..flr(100*stat(1)).."%", 0, stage_top - 16, 8) 
		print("mem: "..flr(stat(0)/1024*100).."%", 0, stage_top - 8, 8)
	end
	if show_debuginfo then 
		print("x: "..cursor_x.." y:"..cursor_y-stage_top, 80, stage_top - 8, 8) 
	end

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
	if cutscene_curr_lastval == cutscene_curr then
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

	-- draw ui and inventory (only if actor selected to use it!)
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

	--if cursor_lvl == 0 then
	if not cutscene_curr then
		cursor_draw()
	end
end


-- handle button inputs
function playercontrol()	

	-- check for cutscene "skip/override"
	-- (or that we have an actor to control!)
	if cutscene_curr then
		if btnp(4) and btnp(5) and cutscene_curr.override then 
			-- skip cutscene!
			cutscene_curr.thread = cocreate(cutscene_curr.override)
			cutscene_curr.override = nil
			--if (enable_mouse) then ismouseclicked = true end
			return
		end
		-- either way - don't allow other user actions!
		return
	end

	-- 
	if btn(0) then cursor_x -= 1 end
	if btn(1) then cursor_x += 1 end
	if btn(2) then cursor_y -= 1 end
	if btn(3) then cursor_y += 1 end

	if btnp(4) then input_button_pressed(1) end
	if btnp(5) then input_button_pressed(2) end

	-- only update position if mouse moved
	if enable_mouse then	
		if stat(32)-1 != last_mouse_x then cursor_x = stat(32)-1 end	-- mouse xpos
		if stat(33)-1 != last_mouse_y then cursor_y = stat(33)-1 end  -- mouse ypos
		-- don't repeat action if same press/click
		if stat(34) > 0 then
			if not ismouseclicked then
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

	-- temp workaround if no actor selected at this point
	if not selected_actor then 
		return
	end

	-- check for sentence selection
	if dialog_curr and dialog_curr.visible then
		if hover_curr_sentence then
			selected_sentence = hover_curr_sentence
			--sentence_curr = hover_curr_sentence
		end
		-- skip remaining
		return
	end


	if hover_curr_verb then
		verb_curr = get_verb(hover_curr_verb)
		--d("verb = "..verb_curr[2])

	elseif hover_curr_object then
		-- if valid obj, complete command
		-- else, abort command (clear verb, etc.)
		if button_index == 1 then
			if (verb_curr[2] == "use" or verb_curr[2] == "give") 
			 and noun1_curr then
				noun2_curr = hover_curr_object
				--d("noun2_curr = "..noun2_curr.name)					
			else
				noun1_curr = hover_curr_object						
				--d("noun1_curr = "..noun1_curr.name)
			end

		elseif hover_curr_default_verb then
			-- perform default verb action (if present)
			verb_curr = get_verb(hover_curr_default_verb)
			noun1_curr = hover_curr_object
			get_keys(noun1_curr)
			-- force repaint of command (to reflect default verb)
			command_draw()
		end

	-- ui arrow clicked
	elseif hover_curr_arrow then
		-- up arrow
		if hover_curr_arrow == ui_arrows[1] then 
			if selected_actor.inv_pos > 0 then
				selected_actor.inv_pos -= 1
			end
		else  -- down arrow
			if selected_actor.inv_pos + 2 < flr(#selected_actor.inventory/4) then
				selected_actor.inv_pos += 1
			end
		end
		return
	--else
		-- what else could there be? actors!?
	end

	-- attempt to use verb on object
	if (noun1_curr != nil) then
		-- are we starting a 'use' command?
		if verb_curr[2] == "use" or verb_curr[2] == "give" then
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
				dest_pos = get_use_pos(obj)
				walk_to(selected_actor, dest_pos.x, dest_pos.y)
				-- abort if walk was interrupted
				if selected_actor.moving != 2 then return end
				-- face object/actor by default
				use_dir = obj
				-- unless a diff dir specified
				if obj.use_dir and verb != verb_default then use_dir = obj.use_dir end
				-- turn to use dir
				do_anim(selected_actor, anim_face, use_dir)
			end
			-- does current object support active verb?
			if valid_verb(verb,obj) then
				-- finally, execute verb script
				start_script(obj.verbs[verb[1]], false, obj, noun2)
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
end

-- collision detection
function check_collisions()
	-- reset hover collisions
	hover_curr_verb = nil
	hover_curr_default_verb = nil
	hover_curr_object = nil
	hover_curr_sentence = nil
	hover_curr_arrow = nil

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
		if actor.in_room == room_curr then
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

	if selected_actor then
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
				-- pickup override for inventory objects
				if verb_curr[2] == "pickup" and hover_curr_object.owner then
					verb_curr = nil
				end
			end
			-- check for disowned objects!
			if obj.owner != selected_actor then 
				del(selected_actor.inventory, obj)
			end
		end

		-- default to walkto (if nothing set)
		if verb_curr == nil then
			verb_curr = get_verb(verb_default)
		end

		-- update "default" verb for hovered object (if any)
		if hover_curr_object then
			hover_curr_default_verb = find_default_verb(hover_curr_object)
		end
	end
end


function reset_zplanes()
	draw_zplanes = {}
	for x=1,64 do
		draw_zplanes[x] = {}
	end
end

function recalc_zplane(obj)
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
end

function room_draw()
	-- draw current room

	-- replace colors?
	replace_colors(room_curr)
	map(room_curr.map_x, room_curr.map_y, 0, stage_top, room_curr.map_w , room_curr.map_h)
	--reset palette
	pal() 
	
	-- ===============================================================
	-- debug walkable areas
	-- ===============================================================
	-- if show_pathfinding then
	-- 	actor_cell_pos = getcellpos(selected_actor)

	-- 	celx = flr((cursor_x + cam_x) /8) + room_curr.map_x
	-- 	cely = flr((cursor_y - stage_top)/8 ) + room_curr.map_y
	-- 	target_cell_pos = { celx, cely }

	-- 	path = find_path(actor_cell_pos, target_cell_pos)

	-- 	-- finally, add our destination to list
	-- 	click_cell = getcellpos({x=(cursor_x + cam_x), y=(cursor_y - stage_top)})
	-- 	if is_cell_walkable(click_cell[1], click_cell[2]) then
	-- 	--if (#path>0) then
	-- 		add(path, click_cell)
	-- 	end

	-- 	for p in all(path) do
	-- 		--d("  > "..p[1]..","..p[2])
	-- 		rect(
	-- 			(p[1]-room_curr.map_x)*8, 
	-- 			stage_top+(p[2]-room_curr.map_y)*8, 
	-- 			(p[1]-room_curr.map_x)*8+7, 
	-- 			stage_top+(p[2]-room_curr.map_y)*8+7, 11)
	-- 	end
	-- end
	-- ===============================================================

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
		end
	end
end

function replace_colors(obj)
	for c in all(obj.col_replace) do
		pal(c[1], c[2])
	end
end


function object_draw(obj)
	-- replace colors?
	replace_colors(obj)
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

-- draw actor(s)
function actor_draw(actor)

	if actor.moving == 1
	 and actor.walk_anim then
		actor.tmr += 1
		if actor.tmr > 5 then
			actor.tmr = 1
			actor.anim_pos += 1
			if actor.anim_pos > #actor.walk_anim then actor.anim_pos=1 end
		end
		-- choose walk anim frame
		sprnum = actor.walk_anim[actor.anim_pos]	
	else
		-- idle
		sprnum = actor.idle[actor.face_dir]
	end

	-- replace colors?
	replace_colors(actor)

	sprdraw(sprnum, actor.offset_x, actor.offset_y, 
		actor.w , actor.h, actor.trans_col, 
		actor.flip, false)
	
	-- talking overlay
	if talking_actor 
	 and talking_actor == actor then
			if actor.talk_tmr < 7  then
				sprnum = actor.talk[actor.face_dir]
				sprdraw(sprnum, actor.offset_x, actor.offset_y +8, 1, 1, 
					actor.trans_col, actor.flip, false)
			end
			actor.talk_tmr += 1	
			if actor.talk_tmr > 14 then actor.talk_tmr = 1 end
	end

	--reset palette
	pal()

	--pset(actor.x, actor.y+stage_top, 8)
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
			if verb_curr[2] == "use" then
				command = command.." with"
			elseif verb_curr[2] == "give" then
				command = command.." to"
			end
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

	print(smallcaps(command), 
		hcenter(command), 
		stage_top + 66, cmd_col)
end

function talking_draw()
	-- alignment 
	--   0 = no align
	--   1 = center 
	if talking_curr then
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
		talking_curr.time_left -= 1
		-- remove text & reset actor's talk anim
		if (talking_curr.time_left <=0) then 
			stop_talking()
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
		if v == hover_curr_verb then txtcol=verb_hovcol end

		-- get verb info
		vi = get_verb(v)
		print(vi[3], xpos, ypos+stage_top+1, verb_shadcol)  -- shadow
		print(vi[3], xpos, ypos+stage_top, txtcol)  -- main
		
		-- capture bounds
		v.x = xpos
		v.y = ypos
		recalc_bounds(v, #vi[3]*4, 5, 0, 0)
		show_collision_box(v)

		-- auto-size column
		if #vi[3] > col_len then col_len = #vi[3] end
		ypos = ypos + 8

		-- move to next column
		if ypos >= 95 then
			ypos = 75
			xpos = xpos + (col_len + 1.0) * 4
			col_len = 0
		end
	end

	if selected_actor then
		-- draw inventory
		xpos = 86
		ypos = 76
		-- determine the inventory "window"
		start_pos = selected_actor.inv_pos*4
		end_pos = min(start_pos+8, #selected_actor.inventory)

		for ipos = 1,8 do
			-- draw inventory bg
			rectfill(xpos-1, stage_top+ypos-1, xpos+8, stage_top+ypos+8, 1)

			obj = selected_actor.inventory[start_pos+ipos]
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
			xpos += 11

			if xpos >= 125 then
				ypos += 12
				xpos=86
			end
			ipos += 1
		end

		-- draw arrows
		for i = 1,2 do
			arrow = ui_arrows[i]
			if hover_curr_arrow == arrow then pal(verb_maincol,7) end
			sprdraw(arrow.spr, arrow.x, arrow.y, 1, 1, 0)
			-- capture bounds
			recalc_bounds(arrow, 8, 7, 0, 0)
			show_collision_box(arrow)
			pal() --reset palette
		end
	end
end

function dialog_draw()
	xpos = 0
	ypos = 70
	
	for s in all(dialog_curr.sentences) do
		-- capture bounds
		s.x = xpos
		s.y = ypos
		recalc_bounds(s, s.char_width*4, #s.lines*5, 0, 0)

		txtcol=dialog_curr.col
		if s == hover_curr_sentence then txtcol=dialog_curr.hlcol end
		
		for l in all(s.lines) do
				print(smallcaps(l), xpos, ypos+stage_top, txtcol)
			ypos += 5
		end

		show_collision_box(s)

		ypos += 2
	end
end

-- draw cursor
function cursor_draw()
	col = cursor_cols[cursor_colpos]
	-- switch sprite color accordingly
	pal(7,col)
	spr(32, cursor_x-4, cursor_y-3, 1, 1, 0)
	pal() --reset palette

	cursor_tmr += 1
	if cursor_tmr > 7 then
		--reset timer
		cursor_tmr = 1
		-- move to next color?
		cursor_colpos += 1
		if (cursor_colpos > #cursor_cols) then cursor_colpos = 1 end
	end
end

function sprdraw(n, x, y, w, h, transcol, flip_x, flip_y)
	-- switch transparency
 	palt(0, false)
 	palt(transcol, true)
	 -- draw sprite
	spr(n, x, stage_top + y, w, h, flip_x, flip_y) --
	-- restore default trans
	pal()
end




-- initialise all the rooms (e.g. add in parent links)
function game_init()
	for kr,room in pairs(rooms) do
		-- init room
		if room.map_x1 then
			room.map_w = room.map_x1 - room.map_x + 1
			room.map_h = room.map_y1 - room.map_y + 1
		else
			room.map_w = 16
			room.map_h = 8
		end
		-- init objects (in room)
		for ko,obj in pairs(room.objects) do
			obj.in_room = room
		end
	end
	-- init actors with defaults
	for ka,actor in pairs(actors) do
		actor.moving = 2 		-- 0=stopped, 1=walking, 2=arrived
		actor.tmr = 1 		  -- internal timer for managing animation
		actor.talk_tmr = 1
		actor.anim_pos = 1 	-- used to track anim pos
		actor.inventory = {
			-- object1,
			-- object2
		}
		actor.inv_pos = 0 	-- pointer to the row to start displaying from
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
		walkable = is_cell_walkable(celx, cely)
		return walkable
end

function getcellpos(obj)
	celx = flr(obj.x/8) + room_curr.map_x
	cely = flr(obj.y/8) + room_curr.map_y
	return { celx, cely }
end

function is_cell_walkable(celx, cely)
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
function create_text_lines(msg, max_line_length) --, comma_is_newline)
	--  > ";" new line, shown immediately
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

		elseif curchar == ";" then 
			-- line break
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
	longest_line = 0
	for l in all(lines) do
		if #l > longest_line then longest_line = #l end
	end
	return longest_line
end

function has_flag(obj, value)
  if band(obj, value) != 0 then return true end
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


-- ================================================================
-- a* pathfinding functions 
-- ================================================================

function find_path(start, goal)
 frontier = {}
 insert(frontier, start, 0)
 came_from = {}
 came_from[vectoindex(start)] = nil
 cost_so_far = {}
 cost_so_far[vectoindex(start)] = 0

 while #frontier > 0 and #frontier < 1000 do
 	-- pop the last element off a table
	local top = frontier[#frontier]
	del(frontier,frontier[#frontier])
	current = top[1]

  if vectoindex(current) == vectoindex(goal) then
   break
  end

  --local neighbours = getneighbours(current)
	local neighbours = {}
	for x = -1, 1 do
		for y = -1, 1 do
			if x == 0 and y == 0 then 
				--continue 
			else
				chk_x = current[1] + x
				chk_y = current[2] + y

				-- diagonals cost more
				if abs(x) != abs(y) then cost=1 else cost=1.4 end
				
				if chk_x >= room_curr.map_x and chk_x <= room_curr.map_x + room_curr.map_w 
				and chk_y >= room_curr.map_y and chk_y <= room_curr.map_y + room_curr.map_h
				and is_cell_walkable(chk_x, chk_y)
				-- squeeze check for corners
				and ((abs(x) != abs(y)) 
						or is_cell_walkable(chk_x, current[2]) 
						or is_cell_walkable(chk_x - x, chk_y)) 
				then
					-- add as valid neighbour
					add( neighbours, {chk_x, chk_y, cost} )
				end
			end
		end
	end
	-- --------------

  for next in all(neighbours) do
   local nextindex = vectoindex(next)
   local new_cost = cost_so_far[vectoindex(current)] + next[3] -- add extra costs here

   if (cost_so_far[nextindex] == nil) or (new_cost < cost_so_far[nextindex]) then
    cost_so_far[nextindex] = new_cost

		-- diagonal movement - assumes diag dist is 1, same as cardinals
		local priority = new_cost +  max(abs(goal[1] - next[1]), abs(goal[2] - next[2]))

    insert(frontier, next, priority)
    came_from[nextindex] = current
   end 
  end
 end

 -- now find goal..
 path = {}
 current = came_from[vectoindex(goal)]
 if current then
	local cindex = vectoindex(current)
	local sindex = vectoindex(start)

	while cindex != sindex do
		add(path, current)
		current = came_from[cindex]
		cindex = vectoindex(current)
	end

	--reverse(path)
	for i=1,#path/2 do
		local temp = path[i]
		local oppindex = #path-(i-1)
		path[i] = path[oppindex]
		path[oppindex] = temp

	end
	--printh("..done")
 end

 return path
end


-- insert into table and sort by priority
function insert(t, val, p)
 if #t >= 1 then
  add(t, {})
  for i=(#t),2,-1 do
   local next = t[i-1]
   if p < next[2] then
    t[i] = {val, p}
    return
   else
    t[i] = next
   end
  end
  t[1] = {val, p}
 else
  add(t, {val, p}) 
 end
end

-- translate a 2d x,y coordinate to a 1d index and back again
function vectoindex(vec)
	return ((vec[1]+1) * 16) + vec[2]
end




-- ================================================================
-- helper functions 
-- ================================================================

function outline_text(str,x,y,c0,c1)
 local c0=c0 or 7
 local c1=c1 or 0
 str = smallcaps(str)
 for xx = -1, 1 do
		for yy = -1, 1 do
			print(str, x+xx, y+yy, c1)
		end
 end
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
	bounds = obj.bounds
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
77777755666666ddbbbbbbee33333355333333330000000066666666588885886666666600000000000000550000000000000000000000000000000000045000
777755556666ddddbbbbeeee33333355333333330000000066666666588885881c1c1c1c00000000000055550000000000000000000000000000000000045000
7755555566ddddddbbeeeeee3333666633333333000000006666666655555555c1c1c1c100000000005555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee33336666333333330000000066666666888588881c1c1c1c00000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee3355555533333333000000006666666688858888c1c1c1c10000000055555555000000000000000000000000001c7c1000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666555555551c1c1c1c00000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee6666666633333333000000006666666658888588c1c1c1c100000000555555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885887c7c7c7c00000000555555550000000000000000000000000000000000045000
55777777dd666666eebbbbbb55333333555555550000000000000000000000000000000000000000000000000000000000000000000000000000000099999999
55557777dddd6666eeeebbbb55333333555533330000000000000000000000000000000000000000000000000000000000000000000000000000000044444444
55555577dddddd66eeeeeebb66663333553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee6666333353333333000000000000000000000000000000000000000000000000000000000000000000000000000c000000045000
55555555ddddddddeeeeeeee55555533533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee55555533553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555533330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb555555555555555500000000cccccccc5555555677777777c7777777655555553333333663333333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333555500000000cccccccc555555677777777ccc777777765555553333336776333333000000000000000000045000
55555555ddddddddbbbbbbbb666666663333335500000000cccccccc55555677777777ccccc77777776555553333367777633333000000000000000000045000
55555555ddddddddbbbbbbbb666666663333333500000000cccccccc5555677777777ccccccc7777777655553333677777763333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333333500000000cccccccc555677777777ccccccccc777777765553336777777776333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333335500000000cccccccc55677777777ccccccccccc77777776553367777777777633000000000000000000045000
55555555ddddddddbbbbbbbb666666663333555500000000cccccccc5677777777ccccccccccccc7777777653677777777777763000000000b03000099999999
55555555ddddddddbbbbbbbb666666665555555500000000cccccccc677777777ccccccccccccccc77777776677777777777777600000000b00030b055555555
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
444949440dd6dd600000000056dd6d506dd6dd6d000000004449444444449444000000000000000000000000000000000000000000000000000000004f444494
444949440dd6dd650000000056dd6d5066666666000000004449444444449444000000000000000000000000000000000000000000000000000000004f444994
44494944066666650000000056666650d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f499444
444949440d6dd6d5000000005d6dd650d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f944444
444949440d6dd6d5000000005d6dd650666666660000000044494444444494440000000000000000000000000000000000000000000000000000000044444400
444949440666666500000000566666506dd6dd6d0000000044494444444494440000000000000000000000000000000000000000000000000000000044440000
999949990dd6dd650000000056dd6d506dd6dd6d0000000044499999999994440000000000000000000000000000000000000000000000000000000044000000
444444440dd6dd650000000056dd6d50666666660000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
fff76ffffff76ffffff76fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccffffffff
fff76ffffff76ffffff76fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccf666677f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccc7cccccc7
bbbcccc8888bbbbcccc8888b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaccccd776666d
fccccc8ffbbbbbcff88888bf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000caaaccccf676650f
fccc888ffbbbcccff888bbbf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
fff00ffffff00ffffff00fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
fff00ffffff00ffffff00fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccff7665ff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666677f
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000075555557
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d776666d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff7665ff
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
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffff9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffffffffffffffffffff
fffffffffffffffffffffffffeeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9e9f9f97755555555555577f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9eee9f9f70700000000007079eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffffffffffffffffffff
fffffffffffffffffffffffffeeef9f97007000000007007feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9fef9fef70006000000600079fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feee7000600000060007f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9eee70006000000600079f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feee7000600000060007f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9fef77776000494449779f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffffffffffffffffffffffff
ffffffff00000000fffffffff9e9f9f97006600494444497f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9eee9f9f70606004944000479eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffff00000000ffffffff
ffffffff00000000fffffffffeeef9f970506000440fff07feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9fef9fef700060004f0f9f079fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffff7fff00000000ffffffff
ffffffff00000000fffffffff9f9feee700500000fff5f07f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffff7fff00000000ffffffff
ffffffff00000000ffffffff9f9f9eee705000040ffffff79f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffff7fff00000000ffffffff
ffffffff00000000fffffffff9f9feee750000000fffff47f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef777f77700000000ffffffff
ffffffff00000000ffffffff9f9f9fef555555556fffff559f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffff7fff00000000ffffffff
ffffffff00000000ffffffff999999999999999996fffd9999999999ffffffffffffffffffffffff999999999999999999999999ffff7fff00000000ffffffff
ffffffff00000000ffffffff555555555555555555ff555555555555555555555555555555555555555555555555555555555555ffff7fff00000000ffffffff
ffffffff00000000ffffffff444444444444444444dd4444444444440dd6dd6dd6dd6dd6d6dd6d50444444444444444444444444ffffffff00000000ffffffff
ffffffff00000000ffffffffffff4fffffff4ffff1ccdfffffff4fff0dd6dd6dd6dd6dd6d6dd6d50ffff4fffffff4fffffff4fff22ffffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd94444494944066666666666666666666650444949444449494444494940020fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd944444949440d6dd6dd6dd6dd6ddd6dd650444949444449494444494942302fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd944444949440d6dd6dd6dd6dd6ddd6dd65044494944444949444449494b33bfffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd94444494944066666666666666666666650444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ddd944444949440dd6dd600000000056dd6d50444949444449494444494942222fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442ff1944444949440dd6dd650000000056dd6d50444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442fe19444449494406666665000000005666665044494944444949444449492b33b2ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440d6dd6d500a0a0005d6dd650444949444449494444494922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440d6dd6d500aaaa005d6dd6504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440666666500a9aa00566666504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff999949999999499992111999999949990dd6dd6500a99a0056dd6d50999949999999499999994922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444444444444444442111444444444440dd6dd650044440056dd6d5044444444444444444444442b33b2ffff00000000ffffffff
ffffffff00000000ffffff555555555555555555521115555555555555555555555555555555555555555555555555555555522b33b22fff00000000ffffffff
ffffffff00000000ffff555555555555555555555211155555555555555555555555555555555555555555555555555555555222bb222fff00000000ffffffff
ffffffff00000000ff55555555555555555555555cccc55555555555555555555555555555555555555555555555555555555222222225ff00000000ffffffff
ffffffff5555555555555555555555555555555556777555555555555555555555555555555555555555555555555555555552222222255555555555ffffffff
ffffffff555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555bbbbbbbb55555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffff55555555555557655555555555555555553333333333333333333333333333333333333333333333335555555555555555555555555555555555ffffff
ffff555555555555555765555555555555553333333333333333333333333333333333333333333333333333333355555555555556666775555555555555ffff
ff555555555555555bbbb775555555555533333333333333333333333333333333333333333333333333333333333355555555557555555755555555555555ff
5555555555555555bbb7777855555555533333333333333333333333333333333333333333333333333333333333333555555555d776666d5555555555555555
55555555555555555777778555555555533333333333333333333333333333333333333333333333333333333333333555555555567665055555555555555555
55555555555555555777888555555555553333333333333333333333333333333333333333333333333333333333335555555555567665055555555555555555
55555555555555555550055555555555555533333333333333333333333333333333333333333333333333333333555555555555567665055555555555555555
55555555555555555550055555555555555555553333333333333333333333333333333333333333333333335555555555555555557665555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c0c0ccc0c000c0c00000ccc00cc00000ccc0c0c0ccc0ccc0c000ccc00000ccc0ccc0cc00ccc0ccc0ccc0c000ccc00000000000000000000
00000000000000000c0c0c0c0c000cc0000000c00c0c00000c0c0c0c0c0c0c0c0c000cc0000000c00cc00c0c00c00c0c0c000c000cc000000000000000000000
00000000000000000ccc0ccc0c000c0c000000c00c0c00000ccc0c0c0cc00ccc0c000c00000000c00c000c0c00c00ccc0c000c000c0000000000000000000000
00000000000000000ccc0c0c0ccc0c0c000000c00cc000000c0000cc0c0c0c000ccc0ccc000000c00ccc0c0c00c00c0c0ccc0ccc0ccc00000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc0ccc0ccc0cc0000000000ccc0ccc00cc0c0c00000c0c0ccc00000ccc0c0c00cc0c0c000000000000001111111111011111111110111111111101111111111
c1c0c1c0c110c1c000000000c1c01c10c110c0c00000c0c0c1c00000c1c0c0c0c110c0c0000000cc000001111111111011111111110111111111101111111111
c0c0ccc0cc00c0c000000000ccc00c00c000cc10ccc0c0c0ccc00000ccc0c0c0ccc0ccc000000c11c00001111111111011111111110111111111101111111111
c0c0c110c100c0c000000000c1100c00c000c1c01110c0c0c1100000c110c0c011c0c1c00000c1001c0001111111111011111111110111111111101111111111
cc10c000ccc0c0c000000000c000ccc01cc0c0c000001cc0c0000000c0001cc0cc10c0c0000ccc00ccc001111111111011111111110111111111101111111111
11001000111010100000000010001110011010100000011010000000100001101100101000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000cccc00001111111111011111111110111111111101111111111
0cc0c0000cc00cc0ccc00000c0000cc00cc0c0c00000ccc0ccc00000ccc0c0c0c000c00000000111100001111111111011111111110111111111101111111111
c110c000c1c0c110c1100000c000c1c0c1c0c0c00000c1c01c100000c1c0c0c0c000c00000000000000001111111111011111111110111111111101111111111
c000c000c0c0ccc0cc000000c000c0c0c0c0cc10ccc0ccc00c000000ccc0c0c0c000c00000000000000000000000000000000000000000000000000000000000
c000c000c0c011c0c1000000c000c0c0c0c0c1c01110c1c00c000000c110c0c0c000c00000000000000000000000000000000000000000000000000000000000
1cc0ccc0cc10cc10ccc00000ccc0cc10cc10c0c00000c0c00c000000c0001cc0ccc0ccc000000000000001111111111011111111110111111111101111111111
01101110110011001110000011101100110010100000101001000000100001101110111000000cccc00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c11c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
0cc0ccc0c0c0ccc000000000aaa0aaa0a000a0a00000aaa00aa00000c0c00cc0ccc00000000ccc00ccc001111111111011111111110111111111101111111111
c1101c10c0c0c110000000001a10a1a0a000a0a000001a10a1a00000c0c0c110c11000000001c1001c1001111111111011111111110111111111101111111111
c0000c00c0c0cc00000000000a00aaa0a000aa10aaa00a00a0a00000c0c0ccc0cc00000000001c00c10001111111111011111111110111111111101111111111
c0c00c00ccc0c100000000000a00a1a0a000a1a011100a00a0a00000c0c011c0c1000000000001cc100001111111111011111111110111111111101111111111
ccc0ccc01c10ccc0000000000a00a0a0aaa0a0a000000a00aa1000001cc0cc10ccc0000000000011000001111111111011111111110111111111101111111111
11101110010011100000000001001010111010100000010011000000011011001110000000000000000001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010100000000000000010000000000010101010100000000000100000000000101010101000000000000000000000001010101010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
464646474747474747474747474646465656564848484848484848484848484848484848485656560000005e0000a1a2a2a2a2a2a2a2a2a2a2a2a2a20000005e46464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
46464647000047474747474747464646565656484848484848488485858548484848484848565656006e0000006eb184b4b4b484b3b2b184b4b484b400006e0046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
46004647000047474747474747460046560056a5a5a5a5a5a5a594a4a495a5a5a5a5a5a5a5560056576f6f6f6f6fb1a4b4b4b4a4b3b2b1a4b4b4a4b46f6f6f6f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
460046a0a0a0a0a1a2a3a0a0a0460046560056a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7560056577f7f7f7f7fa2b4b4b4b4b4b3b2b1b4b4b4b4b47f7f7f7f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
460046b0b0b0b0b1b2b3b0b0b0460046560056b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b756005654545454545454545454545454545454545454545454545446004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404656415171717171717171717171717171717171717161415654547b585858585858585858737373585858587c5454545446405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
50707070645454545454547470707060517171717171717171717171717171717171717171717161547b787676767676ce76767676767676767676797c54545450707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
707070707070707070707070707070707171717171717171717171717171717171717171717171717b78767676767676767676767676767676767676797c545470707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
0000000000000000006e00000000006e0000005e00006e0000005f00a1a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3005f005e4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
006e00000000000000000000005e0000006e00000000005e00005f6eb184b184b184b3008eb184b384b384b3005f6e004646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0000006e0000000000000000000000006e000000006e0000006e5f00b1a4b1a4b1a4b3009eb1a4b3a4b3a4b36e5f00004600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000000006e00000000006e004500a2a2a2a2a2a2b300aeb1a2a2a2a2a2a30000006e4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
000000000000000000000000000000007e7e7e7e7e7e7e7e7e7e5a7070707070707070647470707070707070704a7e7e4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
00000000000000000000000000006e0054545454545454545454575757575757575773737373575757575757575754544640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
00000000005e0000006e00000000000054545454545454545454545454545454545373737373635454545454545454545070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
6e0000000000000000006e000000000054545454545454545454545454545454545454545454545454545454545454547070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
4646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
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

