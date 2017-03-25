pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
-- scumm-8 game template
-- paul nicholas



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
							wait_for_message()
							change_room(rooms.first_room, 1)
							print_line("cozy fireplaces...",90,20,8,1)
							wait_for_message()
							print_line("(just look at it!)",90,20,8,1)
							wait_for_message()

							-- part 2
							printh("a")
							change_room(rooms.second_room, 1)
							print_line("strange looking aliens...",30,20,8,1)
							
							printh("b")

							put_actor_at(actors.purp_tentacle, 130, actors.purp_tentacle.y, rooms.second_room)
							walk_to(actors.purp_tentacle, 
								actors.purp_tentacle.x-50, 
								actors.purp_tentacle.y)

							wait_for_message()
							say_line(actors.purp_tentacle, "what did you call me?!")
							wait_for_message()

							-- part 3
							change_room(rooms.back_garden, 1)
							print_line("and even swimming pools!",90,20,8,1)
							
							camera_at(200)
							camera_pan_to(64)
							wait_for_camera()

							print_line("quack!",45,60,10,1)
							wait_for_message()

							-- part 4
							change_room(rooms.outside_room, 1)
							
							-- outro
							break_time(25)
							change_room(rooms.title_room, 1)
							camera_at(0)
						
							--break_time()
							print_line("coming soon...;to a pico-8 near you!",64,45,8,1)
							wait_for_message()
							fades(1,1)
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
						wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("ouch! it's hot!;*stupid fire*")
						wait_for_message()
					end,
					talkto = function()
						say_line("'hi fire...'")
						wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
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
							wait_for_message()
							say_line(actors.purp_tentacle, "sure")
							wait_for_message()
							me.owner = actors.purp_tentacle
							break_time(30)
							say_line(actors.purp_tentacle, "here ya go...")
							wait_for_message()
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
									wait_for_message()
									change_room(rooms.second_room, 1)
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
									change_room(rooms.first_room, 1)
									-- wait for a bit, then appear in room1
									break_time(50)
									put_actor_at(selected_actor, 115, 44, rooms.first_room)
									walk_to(selected_actor, 
										selected_actor.x-10, 
										selected_actor.y)
									say_line("intruder!!!")
									do_anim(actors.main_actor, anim_face, actors.purp_tentacle)
									wait_for_message()
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
						wait_for_message()
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
						wait_for_message()
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
							wait_for_message()
							
							if selected_sentence.num == 1 then
								say_line(me, "you are in paul's game")
								wait_for_message()

							elseif selected_sentence.num == 2 then
								say_line(me, "it's complicated...")
								wait_for_message()

							elseif selected_sentence.num == 3 then
								say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
								wait_for_message()

							elseif selected_sentence.num == 4 then
								say_line(me, "ok bye!")
								wait_for_message()
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


























-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function camera_at(by) if type(by)=="table"then
by=by.x end bz=mid(0,by-64,(room_curr.ca*8)-cb-1) cc=nil cd=nil end function camera_follow(ce) cd=ce cc=nil cf=function() while cd do bz=mid(0,cd.x-64,(room_curr.ca*8)-cb-1) yield() end end start_script(cf,true) end function camera_pan_to(by) if type(by)=="table"then
by=by.x end cc=by cd=nil cf=function() while(true) do printh("panning...") cg=bz+flr(cb/2)+1 printh("center_view: "..cg) printh("cam_pan_to_x: "..cc) if cg==cc then
cc=nil return elseif cc>cg then bz+=0.5 else bz-=0.5 end bz=mid(0,bz,(room_curr.ca*8)-cb-1) yield() end end start_script(cf,true) end function wait_for_camera() while script_running(cf) do yield() end end function cutscene(ch,ci,cj) ck={ch=ch,cl=cocreate(ci),cm=cj,cn=cd} add(co,ck) cp=ck break_time() end function dialog_add(msg) if not cq then cq={cr={},cs=false} end
ct=cu(msg,32) cv=cw(ct) cx={num=#cq.cr+1,msg=msg,ct=ct,cy=cv} add(cq.cr,cx) end function dialog_start(col,cz) cq.col=col cq.cz=cz cq.cs=true selected_sentence=nil end function dialog_hide() cq.cs=false end function dialog_clear() cq.cr={} selected_sentence=nil end function dialog_end() cq=nil end function get_use_pos(bq) da=bq.use_pos if type(da)=="table"then
x=da.x-bz y=da.y-db elseif not da or da==pos_infront then x=bq.x+((bq.w*8)/2)-bz-4 y=bq.y+(bq.h*8)+2 elseif da==pos_left then if bq.dc then
x=bq.x-bz-(bq.w*8+4) y=bq.y+1 else x=bq.x-bz-2 y=bq.y+((bq.h*8)-2) end elseif da==pos_right then x=bq.x+(bq.w*8)-bz y=bq.y+((bq.h*8)-2) end return{x=x,y=y} end function do_anim(ce,dd,de) if dd==anim_face then
if type(de)=="table"then
df=atan2(ce.x-de.x,de.y-ce.y) dg=93*(3.1415/180) df=dg-df dh=df*(1130.938/3.1415) dh=dh%360 if(dh<0) then dh+=360 end
de=4-flr(dh/90) end while ce.face_dir!=de do if ce.face_dir<de then
ce.face_dir+=1 else ce.face_dir-=1 end ce.flip=(ce.face_dir==face_left) break_time(10) end end end function open_door(di,dj) if state_of(di)==state_open then
say_line("it's already open") else set_state(di,state_open) if dj then set_state(dj,state_open) end
end end function close_door(di,dj) if state_of(di)==state_closed then
say_line("it's already closed") else set_state(di,state_closed) if dj then set_state(dj,state_closed) end
end end function come_out_door(dk,dl) dm=dk.in_room bz=0 change_room(dm,dl) dn=get_use_pos(dk) put_actor_at(selected_actor,dn.x,dn.y,dm) if dk.use_dir then
dp=dk.use_dir+2 if dp>4 then
dp-=4 end else dp=1 end selected_actor.face_dir=dp end function fades(dq,ba) if ba==1 then
dr=0 else dr=50 end while true do dr+=ba*2 if dr>50
or dr<0 then return end if dq==1 then
ds=min(dr,32) end yield() end end function change_room(dm,dq) printh(">1") if dq and room_curr then
fades(dq,1) end printh(">2") if room_curr and room_curr.exit then
printh(">2a") room_curr.exit(room_curr) end printh(">3") dt={} du() printh(">4") room_curr=dm stop_talking() printh(">5") if dq then
start_script(function() fades(dq,-1) end,true) else ds=0 end if room_curr.enter then
room_curr.enter(room_curr) end printh(">3") end function valid_verb(bu,dv) if not dv then return false end
if not dv.verbs then return false end
if type(bu)=="table"then
if dv.verbs[bu[1]] then return true end
else if dv.verbs[bu] then return true end
end return false end function pickup_obj(dw) bq=find_object(dw) if bq
then add(selected_actor.dx,bq) bq.owner=selected_actor del(bq.in_room.objects,bq) end end function owner_of(dw) bq=find_object(dw) if bq then
return bq.owner end end function state_of(dw,state) bq=find_object(dw) if bq then
return bq.state end end function set_state(dw,state) bq=find_object(dw) if bq then
bq.state=state end end function find_object(name) if type(name)=="table"then return name end
for dy,bq in pairs(room_curr.objects) do if bq.name==name then return bq end
end end function start_script(dz,ea,eb,bh) local cl=cocreate(dz) if ea then
add(ec,{dz,cl,eb,bh}) else add(dt,{dz,cl,eb,bh}) end end function script_running(dz) for dy,ed in pairs(dt) do if(ed[1]==dz) then
return ed end end for dy,ed in pairs(ec) do if(ed[1]==dz) then
return ed end end return false end function stop_script(dz) ed=script_running(dz) if ed then
del(dt,ed) del(ec,ed) end end function break_time(ee) ee=ee or 1 for x=1,ee do yield() end end function wait_for_message() while ef!=nil do yield() end end function say_line(ce,msg) if type(ce)=="string"then
msg=ce ce=selected_actor end eg=ce.y-(ce.h)*8+4 eh=ce print_line(msg,ce.x,eg,ce.col,1) end function stop_talking() ef=nil eh=nil end function print_line(msg,x,y,col,ei) local col=col or 7 local ei=ei or 0 local ct={} local ej=""local ek=""cv=0 el=min(x-bz,cb-(x-bz)) em=max(flr(el/2),16) ek=""for en=1,#msg do ej=sub(msg,en,en) if ej==";"then
ek=sub(msg,en+1) msg=sub(msg,1,en-1) break end end ct=cu(msg,em,true) cv=cw(ct) if ei==1 then
eo=x-bz-((cv*4)/2) end eo=max(2,eo) eg=max(18,y) eo=min(eo,cb-(cv*4)-1) ef={ep=ct,x=eo,y=eg,col=col,ei=ei,eq=(#msg)*8,cy=cv} if(#ek>0) then
er=eh wait_for_message() eh=er print_line(ek,x,y,col,ei) end end function put_actor_at(ce,x,y,es) if es then ce.in_room=es end
ce.x=x ce.y=y end function walk_to(ce,x,y) x=x+bz et=eu(ce) ev=flr(x/8)+room_curr.map_x ew=flr(y/8)+room_curr.map_y ex={ev,ew} ey=ez(et,ex) fa=eu({x=x,y=y}) if fb(fa[1],fa[2]) then
add(ey,fa) end for fc in all(ey) do fd=(fc[1]-room_curr.map_x)*8+4 fe=(fc[2]-room_curr.map_y)*8+4 local ff=sqrt((fd-ce.x)^2+(fe-ce.y)^2) local fg=ce.speed*(fd-ce.x)/ff local fh=ce.speed*(fe-ce.y)/ff if ff>1 then
ce.fi=1 ce.flip=(fg<0) ce.face_dir=face_right if(ce.flip) then ce.face_dir=face_left end
for en=0,ff/ce.speed do ce.x=ce.x+fg ce.y=ce.y+fh yield() end end end ce.fi=2 end cb=127 fj=127 db=16 bz=0 cc=nil cf=nil fk=cb/2 fl=fj/2 fm=0 fn={7,12,13,13,12,7} fo=1 fp={{spr=16,x=75,y=db+60},{spr=48,x=75,y=db+72}} fq=0 fr=0 fs=false room_curr=nil ft=nil fu=nil fv=nil fw=""fx=false ef=nil cq=nil cp=nil eh=nil ds=0 ec={} dt={} co={} fy={} function _init() if enable_mouse then poke(0x5f2d,1) end
fz() start_script(startup_script,true) end function _update60() ga() end function _draw() gb() end function ga() if selected_actor and selected_actor.cl and not coresume(selected_actor.cl) then
selected_actor.cl=nil end gc(ec) if cp then
if cp.cl and not coresume(cp.cl) then
if not has_flag(cp.ch,cut_no_follow) and
cp.cn then camera_follow(cp.cn) selected_actor=cp.cn end del(co,cp) cp=nil if#co>0 then
cp=co[#co] end end else gc(dt) end gd() ge() end function gb() rectfill(0,0,cb,fj,0) camera(bz,0) clip(0+ds,db+ds,cb+1-ds*2,64-ds*2) gf() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,db-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,db-8,8) end if show_debuginfo then
print("x: "..fk.." y:"..fl-db,80,db-8,8) end gg() if cq and cq.cs then
gh() gi() return end if gj==cp then
else gj=cp return end if not cp then
gk() end if(not cp
or not has_flag(cp.ch,cut_noverbs)) and(gj==cp) then gl() else end gj=cp if not cp then
gi() end end function gd() if cp then
if btnp(4) and btnp(5) and cp.cm then
cp.cl=cocreate(cp.cm) cp.cm=nil return end return end if btn(0) then fk-=1 end
if btn(1) then fk+=1 end
if btn(2) then fl-=1 end
if btn(3) then fl+=1 end
if btnp(4) then gm(1) end
if btnp(5) then gm(2) end
if enable_mouse then
if stat(32)-1!=fq then fk=stat(32)-1 end
if stat(33)-1!=fr then fl=stat(33)-1 end
if stat(34)>0 then
if not fs then
gm(stat(34)) fs=true end else fs=false end fq=stat(32)-1 fr=stat(33)-1 end fk=max(fk,0) fk=min(fk,127) fl=max(fl,0) fl=min(fl,127) end function gm(gn) local go=ft if not selected_actor then
return end if cq and cq.cs then
if gp then
selected_sentence=gp end return end if gq then
ft=get_verb(gq) elseif gr then if gn==1 then
if(ft[2]=="use"or ft[2]=="give")
and fu then fv=gr else fu=gr end elseif gs then ft=get_verb(gs) fu=gr gt(fu) gk() end elseif gu then if gu==fp[1] then
if selected_actor.gv>0 then
selected_actor.gv-=1 end else if selected_actor.gv+2<flr(#selected_actor.dx/4) then
selected_actor.gv+=1 end end return end if(fu!=nil) then
if ft[2]=="use"or ft[2]=="give"then
if fv then
else return end end fx=true selected_actor.cl=cocreate(function(ce,bq,bu,bh) if not bq.owner then
gw=get_use_pos(bq) walk_to(selected_actor,gw.x,gw.y) if selected_actor.fi!=2 then return end
use_dir=bq if bq.use_dir and bu!=verb_default then use_dir=bq.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(bu,bq) then
start_script(bq.verbs[bu[1]],false,bq,bh) else unsupported_action(bu[2],bq,bh) end du() end) coresume(selected_actor.cl,selected_actor,fu,ft,fv) elseif(fl>db and fl<db+64) then fx=true selected_actor.cl=cocreate(function(x,y) walk_to(selected_actor,x,y) du() end) coresume(selected_actor.cl,fk,fl-db) end end function ge() gq=nil gs=nil gr=nil gp=nil gu=nil if cq and cq.cs then
for bx in all(cq.cr) do if gx(bx) then
gp=bx end end return end gy() for dy,bq in pairs(room_curr.objects) do if(not bq.class
or(bq.class and bq.class!=class_untouchable)) and(not bq.dependent_on or find_object(bq.dependent_on).state==bq.dependent_on_state) then gz(bq,bq.w*8,bq.h*8,bz,ha) else bq.hb=nil end if gx(bq) then
gr=bq end hc(bq) end for dy,ce in pairs(actors) do if ce.in_room==room_curr then
gz(ce,ce.w*8,ce.h*8,bz,ha) hc(ce) if gx(ce)
and ce!=selected_actor then gr=ce end end end if selected_actor then
for bs in all(verbs) do if gx(bs) then
gq=bs end end for hd in all(fp) do if gx(hd) then
gu=hd end end for dy,bq in pairs(selected_actor.dx) do if gx(bq) then
gr=bq if ft[2]=="pickup"and gr.owner then
ft=nil end end if bq.owner!=selected_actor then
del(selected_actor.dx,bq) end end if ft==nil then
ft=get_verb(verb_default) end if gr then
gs=find_default_verb(gr) end end end function gy() fy={} for x=1,64 do fy[x]={} end end function hc(bq) eg=-1 if bq.he then
eg=bq.y else eg=bq.y+(bq.h*8) end hf=flr(eg-db) if bq.elevation then hf+=bq.elevation end
add(fy[hf],bq) end function gf() hg(room_curr) map(room_curr.map_x,room_curr.map_y,0,db,room_curr.ca,room_curr.hh) pal() for hi=1,64 do hf=fy[hi] for bq in all(hf) do if not has_flag(bq.class,class_actor) then
if(bq.states)
and bq.states[bq.state] and(bq.states[bq.state]>0) and(not bq.dependent_on or find_object(bq.dependent_on).state==bq.dependent_on_state) and not bq.owner then hj(bq) end else if(bq.in_room==room_curr) then
hk(bq) end end hl(bq) end end end function hg(bq) for hm in all(bq.col_replace) do pal(hm[1],hm[2]) end end function hj(bq) hg(bq) hn=1 if bq.repeat_x then hn=bq.repeat_x end
for h=0,hn-1 do ho(bq.states[bq.state],bq.x+(h*(bq.w*8)),bq.y,bq.w,bq.h,bq.trans_col,bq.flip_x) end pal() end function hk(ce) if ce.fi==1
and ce.walk_anim then ce.hp+=1 if ce.hp>5 then
ce.hp=1 ce.hq+=1 if ce.hq>#ce.walk_anim then ce.hq=1 end
end hr=ce.walk_anim[ce.hq] else hr=ce.idle[ce.face_dir] end hg(ce) ho(hr,ce.dc,ce.he,ce.w,ce.h,ce.trans_col,ce.flip,false) if eh
and eh==ce then if ce.hs<7 then
hr=ce.talk[ce.face_dir] ho(hr,ce.dc,ce.he+8,1,1,ce.trans_col,ce.flip,false) end ce.hs+=1 if ce.hs>14 then ce.hs=1 end
end pal() end function gk() ht=""hu=12 if not fx then
if ft then
ht=ft[3] end if fu then
ht=ht.." "..fu.name if ft[2]=="use"then
ht=ht.." with"elseif ft[2]=="give"then ht=ht.." to"end end if fv then
ht=ht.." "..fv.name elseif gr and gr.name!=""and(not fu or(fu!=gr)) then ht=ht.." "..gr.name end fw=ht else ht=fw hu=7 end print(hv(ht),hw(ht),db+66,hu) end function gg() if ef then
hx=0 for hy in all(ef.ep) do hz=0 if ef.ei==1 then
hz=((ef.cy*4)-(#hy*4))/2 end ia(hy,ef.x+hz,ef.y+hx,ef.col) hx+=6 end ef.eq-=1 if(ef.eq<=0) then
stop_talking() end end end function gl() eo=0 eg=75 ib=0 for bs in all(verbs) do ic=verb_maincol if gs
and(bs==gs) then ic=verb_defcol end if bs==gq then ic=verb_hovcol end
bt=get_verb(bs) print(bt[3],eo,eg+db+1,verb_shadcol) print(bt[3],eo,eg+db,ic) bs.x=eo bs.y=eg gz(bs,#bt[3]*4,5,0,0) hl(bs) if#bt[3]>ib then ib=#bt[3] end
eg=eg+8 if eg>=95 then
eg=75 eo=eo+(ib+1.0)*4 ib=0 end end if selected_actor then
eo=86 eg=76 id=selected_actor.gv*4 ie=min(id+8,#selected_actor.dx) for ig=1,8 do rectfill(eo-1,db+eg-1,eo+8,db+eg+8,1) bq=selected_actor.dx[id+ig] if bq then
bq.x=eo bq.y=eg hj(bq) gz(bq,bq.w*8,bq.h*8,0,0) hl(bq) end eo+=11 if eo>=125 then
eg+=12 eo=86 end ig+=1 end for en=1,2 do ih=fp[en] if gu==ih then pal(verb_maincol,7) end
ho(ih.spr,ih.x,ih.y,1,1,0) gz(ih,8,7,0,0) hl(ih) pal() end end end function gh() eo=0 eg=70 for bx in all(cq.cr) do bx.x=eo bx.y=eg gz(bx,bx.cy*4,#bx.ct*5,0,0) ic=cq.col if bx==gp then ic=cq.cz end
for hy in all(bx.ct) do print(hv(hy),eo,eg+db,ic) eg+=5 end hl(bx) eg+=2 end end function gi() col=fn[fo] pal(7,col) spr(32,fk-4,fl-3,1,1,0) pal() fm+=1 if fm>7 then
fm=1 fo+=1 if(fo>#fn) then fo=1 end
end end function ho(ii,x,y,w,h,ij,flip_x,ik) palt(0,false) palt(ij,true) spr(ii,x,db+y,w,h,flip_x,ik) pal() end function fz() for il,es in pairs(rooms) do if es.map_x1 then
es.ca=es.map_x1-es.map_x+1 es.hh=es.map_y1-es.map_y+1 else es.ca=16 es.hh=8 end for im,bq in pairs(es.objects) do bq.in_room=es end end for io,ce in pairs(actors) do ce.fi=2 ce.hp=1 ce.hs=1 ce.hq=1 ce.dx={} ce.gv=0 end end function hl(bq) if show_collision and bq.hb then
rect(bq.hb.x,bq.hb.y,bq.hb.ip,bq.hb.iq,8) end end function gc(scripts) for ed in all(scripts) do if ed[2] and not coresume(ed[2],ed[3],ed[4]) then
del(scripts,ed) ed=nil end end end function ir(x,y) ev=flr(x/8)+room_curr.map_x ew=flr(y/8)+room_curr.map_y is=fb(ev,ew) return is end function eu(bq) ev=flr(bq.x/8)+room_curr.map_x ew=flr(bq.y/8)+room_curr.map_y return{ev,ew} end function fb(ev,ew) it=mget(ev,ew) is=fget(it,0) return is end function gt(bq) iu={} for dy,bs in pairs(bq) do add(iu,dy) end return iu end function get_verb(bq) bu={} iu=gt(bq[1]) add(bu,iu[1]) add(bu,bq[1][iu[1]]) add(bu,bq.text) return bu end function cu(msg,em,iv) local ct={} local iw=""local ix=""local ej=""local iy=function(iz) if#ix+#iw>iz then
add(ct,iw) iw=""end iw=iw..ix ix=""end for en=1,#msg do ej=sub(msg,en,en) ix=ix..ej if(ej==" ")
or(#ix>em-1) then iy(em) elseif#ix>em-1 then ix=ix.."-"iy(em) elseif ej==","and iv then iw=iw..sub(ix,1,#ix-1) ix=""iy(0) end end iy(em) if iw!=""then
add(ct,iw) end return ct end function cw(ct) cv=0 for hy in all(ct) do if#hy>cv then cv=#hy end
end return cv end function has_flag(bq,ja) if band(bq,ja)!=0 then return true end
return false end function du() ft=get_verb(verb_default) fu=nil fv=nil n=nil fx=false fw=""end function gz(bq,w,h,jb,jc) x=bq.x y=bq.y if has_flag(bq.class,class_actor) then
bq.dc=bq.x-(bq.w*8)/2 bq.he=bq.y-(bq.h*8)+1 x=bq.dc y=bq.he end bq.hb={x=x,y=y+db,ip=x+w-1,iq=y+h+db-1,jb=jb,jc=jc} end function ez(jd,je) jf={} jg(jf,jd,0) jh={} jh[ji(jd)]=nil jj={} jj[ji(jd)]=0 while#jf>0 and#jf<1000 do local bb=jf[#jf] del(jf,jf[#jf]) jk=bb[1] if ji(jk)==ji(je) then
break end local jl={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else jm=jk[1]+x jn=jk[2]+y if abs(x)!=abs(y) then jo=1 else jo=1.4 end
if jm>=room_curr.map_x and jm<=room_curr.map_x+room_curr.ca
and jn>=room_curr.map_y and jn<=room_curr.map_y+room_curr.hh and fb(jm,jn) and((abs(x)!=abs(y)) or fb(jm,jk[2]) or fb(jm-x,jn)) then add(jl,{jm,jn,jo}) end end end end for jp in all(jl) do local jq=ji(jp) local jr=jj[ji(jk)]+jp[3] if(jj[jq]==nil) or(jr<jj[jq]) then
jj[jq]=jr local js=jr+max(abs(je[1]-jp[1]),abs(je[2]-jp[2])) jg(jf,jp,js) jh[jq]=jk end end end ey={} jk=jh[ji(je)] if jk then
local jt=ji(jk) local ju=ji(jd) while jt!=ju do add(ey,jk) jk=jh[jt] jt=ji(jk) end for en=1,#ey/2 do local jv=ey[en] local jw=#ey-(en-1) ey[en]=ey[jw] ey[jw]=jv end end return ey end function jg(jx,by,fc) if#jx>=1 then
add(jx,{}) for en=(#jx),2,-1 do local jp=jx[en-1] if fc<jp[2] then
jx[en]={by,fc} return else jx[en]=jp end end jx[1]={by,fc} else add(jx,{by,fc}) end end function ji(jy) return((jy[1]+1)*16)+jy[2] end function ia(jz,x,y,ka,kb) local ka=ka or 7 local kb=kb or 0 jz=hv(jz) for kc=-1,1 do for kd=-1,1 do print(jz,x+kc,y+kd,kb) end end print(jz,x,y,ka) end function hw(bx) return(cb/2)-flr((#bx*4)/2) end function ke(bx) return(fj/2)-flr(5/2) end function gx(bq) if not bq.hb then return false end
hb=bq.hb if(fk+hb.jb>hb.ip or fk+hb.jb<hb.x)
or(fl>hb.iq or fl<hb.y) then return false else return true end end function hv(bx) local a=""local hy,hm,jx=false,false for en=1,#bx do local hd=sub(bx,en,en) if hd=="^"then
if(hm) then a=a..hd end
hm=not hm elseif hd=="~"then if(jx) then a=a..hd end
jx,hy=not jx,not hy else if hm==hy and hd>="a"and hd<="z"then
for kf=1,26 do if hd==sub("abcdefghijklmnopqrstuvwxyz",kf,kf) then
hd=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kf,kf) break end end end a=a..hd hm,jx=false,false end end return a end



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

