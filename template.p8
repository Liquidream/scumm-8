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

			-- demo intro
		
			if not me.done_intro then
				-- don't do this again
				me.done_intro = true
			
					cutscene(cut_noverbs + cut_no_follow, 
						function()

							-- intro
							break_time(50)
							print_line("in a galaxy not far away...",64,45,8,1)

							change_room(rooms.first_room, 1)
							shake(true)
							start_script(rooms.first_room.scripts.spin_top, true)
							print_line("cozy fireplaces...",90,20,8,1)
							print_line("(just look at it!)",90,20,8,1)
							shake(false)

							-- part 2
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
							camera_pan_to(0)
							wait_for_camera()
							print_line("quack!",45,60,10,1)

							-- part 4
							change_room(rooms.outside_room, 1)

							-- outro
							--break_time(25)
							change_room(rooms.title_room, 1)
							
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
		-- col_replace = { 
		-- 	{ 7, 15 }, 
		-- 	-- { 4, 5 }, 
		-- 	-- { 6, 8 } 
		-- },
		enter = function(me)
			-- animate fireplace
			start_script(me.scripts.anim_fire, true) -- bg script
		end,
		exit = function(me)
			-- pause fireplace while not in room
			stop_script(me.scripts.anim_fire)
		end,
		lighting = 0.5, -- lighting level current room
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
		},
		objects = {
			fire = {
				name = "fire",
				state = 1,
				x = 8 *8, -- (*8 to use map cell pos)
				y = 4 *8,
				states = {145, 146, 147},
				w = 1,	-- relates to spr or map cel, depending on above
				h = 1,  --
				lighting = 1, -- lighting level for object
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
						say_line("ouch! it's hot!:*stupid fire*")
						--wait_for_message()
					end,
					talkto = function()
						say_line("'hi fire...'")
						--wait_for_message()
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("the fire didn't say hello back:burn!!")
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
									set_state(me, state_open)
									print_line("*bang*",40,20,8,1)
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





















-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(by) if by then
bz=1 end ca=by end function camera_at(cb) cc=cd(cb) ce=nil cf=nil end function camera_follow(cg) cf=cg ce=nil ch=function() while cf do if cf.in_room==room_curr then
cc=cd(cf) end yield() end end start_script(ch,true) end function camera_pan_to(cb) ce=cd(cb) cf=nil ch=function() while(true) do if cc==ce then
ce=nil return elseif ce>cc then cc+=0.5 else cc-=0.5 end yield() end end start_script(ch,true) end function wait_for_camera() while script_running(ch) do yield() end end function cutscene(ci,cj,ck) cl={ci=ci,cm=cocreate(cj),cn=ck,co=cf} add(cp,cl) cq=cl break_time() end function dialog_add(msg) if not cr then cr={cs={},ct=false} end
cu=cv(msg,32) cw=cx(cu) cy={num=#cr.cs+1,msg=msg,cu=cu,cz=cw} add(cr.cs,cy) end function dialog_start(col,da) cr.col=col cr.da=da cr.ct=true selected_sentence=nil end function dialog_hide() cr.ct=false end function dialog_clear() cr.cs={} selected_sentence=nil end function dialog_end() cr=nil end function get_use_pos(bq) db=bq.use_pos if type(db)=="table"then
x=db.x-cc y=db.y-dc elseif not db or db==pos_infront then x=bq.x+((bq.w*8)/2)-cc-4 y=bq.y+(bq.h*8)+2 elseif db==pos_left then if bq.dd then
x=bq.x-cc-(bq.w*8+4) y=bq.y+1 else x=bq.x-cc-2 y=bq.y+((bq.h*8)-2) end elseif db==pos_right then x=bq.x+(bq.w*8)-cc y=bq.y+((bq.h*8)-2) end return{x=x,y=y} end function do_anim(cg,de,df) if de==anim_face then
if type(df)=="table"then
dg=atan2(cg.x-df.x,df.y-cg.y) dh=93*(3.1415/180) dg=dh-dg di=dg*(1130.938/3.1415) di=di%360 if(di<0) then di+=360 end
df=4-flr(di/90) end while cg.face_dir!=df do if cg.face_dir<df then
cg.face_dir+=1 else cg.face_dir-=1 end cg.flip=(cg.face_dir==face_left) break_time(10) end end end function open_door(dj,dk) if state_of(dj)==state_open then
say_line("it's already open") else set_state(dj,state_open) if dk then set_state(dk,state_open) end
end end function close_door(dj,dk) if state_of(dj)==state_closed then
say_line("it's already closed") else set_state(dj,state_closed) if dk then set_state(dk,state_closed) end
end end function come_out_door(dl,dm) dn=dl.in_room change_room(dn,dm) dp=get_use_pos(dl) put_actor_at(selected_actor,dp.x,dp.y,dn) if dl.use_dir then
dq=dl.use_dir+2 if dq>4 then
dq-=4 end else dq=1 end selected_actor.face_dir=dq end function fades(dr,ba) if ba==1 then
ds=0 else ds=50 end while true do ds+=ba*2 if ds>50
or ds<0 then return end if dr==1 then
dt=min(ds,32) end yield() end end function change_room(dn,dr) stop_script(du) if dr and room_curr then
fades(dr,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end dv={} dw() room_curr=dn if not cf
or cf.in_room!=room_curr then cc=0 end stop_talking() if dr then
du=function() fades(dr,-1) end start_script(du,true) else dt=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(bu,dx) if not dx then return false end
if not dx.verbs then return false end
if type(bu)=="table"then
if dx.verbs[bu[1]] then return true end
else if dx.verbs[bu] then return true end
end return false end function pickup_obj(dy) bq=find_object(dy) if bq
then add(selected_actor.dz,bq) bq.owner=selected_actor del(bq.in_room.objects,bq) end end function owner_of(dy) bq=find_object(dy) if bq then
return bq.owner end end function state_of(dy,state) bq=find_object(dy) if bq then
return bq.state end end function set_state(dy,state) bq=find_object(dy) if bq then
bq.state=state end end function find_object(name) if type(name)=="table"then return name end
for ea,bq in pairs(room_curr.objects) do if bq.name==name then return bq end
end end function start_script(eb,ec,ed,bh) local cm=cocreate(eb) if ec then
add(ee,{eb,cm,ed,bh}) else add(dv,{eb,cm,ed,bh}) end end function script_running(eb) for ea,ef in pairs(dv) do if(ef[1]==eb) then
return ef end end for ea,ef in pairs(ee) do if(ef[1]==eb) then
return ef end end return false end function stop_script(eb) ef=script_running(eb) if ef then
del(dv,ef) del(ee,ef) end end function break_time(eg) eg=eg or 1 for x=1,eg do yield() end end function wait_for_message() while eh!=nil do yield() end end function say_line(cg,msg,ei) if type(cg)=="string"then
msg=cg cg=selected_actor end ej=cg.y-(cg.h)*8+4 ek=cg print_line(msg,cg.x,ej,cg.col,1,ei) end function stop_talking() eh=nil ek=nil end function print_line(msg,x,y,col,el,ei) local col=col or 7 local el=el or 0 local cu={} local em=""local en=""cw=0 eo=min(x-cc,ep-(x-cc)) eq=max(flr(eo/2),16) en=""for er=1,#msg do em=sub(msg,er,er) if em==":"then
en=sub(msg,er+1) msg=sub(msg,1,er-1) break end end cu=cv(msg,eq) cw=cx(cu) if el==1 then
es=x-cc-((cw*4)/2) end es=max(2,es) ej=max(18,y) es=min(es,ep-(cw*4)-1) eh={et=cu,x=es,y=ej,col=col,el=el,eu=(#msg)*8,cz=cw} if(#en>0) then
ev=ek wait_for_message() ek=ev print_line(en,x,y,col,el) end if not ei then
wait_for_message() end end function put_actor_at(cg,x,y,ew) if ew then cg.in_room=ew end
cg.x=x cg.y=y end function walk_to(cg,x,y) x=x+cc ex=ey(cg) ez=flr(x/8)+room_curr.map_x fa=flr(y/8)+room_curr.map_y fb={ez,fa} fc=fd(ex,fb) fe=ey({x=x,y=y}) if ff(fe[1],fe[2]) then
add(fc,fe) end for fg in all(fc) do fh=(fg[1]-room_curr.map_x)*8+4 fi=(fg[2]-room_curr.map_y)*8+4 local fj=sqrt((fh-cg.x)^2+(fi-cg.y)^2) local fk=cg.speed*(fh-cg.x)/fj local fl=cg.speed*(fi-cg.y)/fj if fj>1 then
cg.fm=1 cg.flip=(fk<0) cg.face_dir=face_right if(cg.flip) then cg.face_dir=face_left end
for er=0,fj/cg.speed do cg.x=cg.x+fk cg.y=cg.y+fl yield() end end end cg.fm=2 end function wait_for_actor(cg) cg=cg or selected_actor while cg.fm!=2 do yield() end end ep=127 fn=127 dc=16 cc=0 ce=nil ch=nil bz=0 fo=ep/2 fp=fn/2 fq=0 fr={7,12,13,13,12,7} fs=1 ft={{spr=16,x=75,y=dc+60},{spr=48,x=75,y=dc+72}} fu=0 fv=0 fw=false room_curr=nil fx=nil fy=nil fz=nil ga=""gb=false eh=nil cr=nil cq=nil ek=nil dt=0 gc=0 ee={} dv={} cp={} gd={} function _init() if enable_mouse then poke(0x5f2d,1) end
ge() start_script(startup_script,true) end function _update60() gf() end function _draw() gg() end function gf() if selected_actor and selected_actor.cm and not coresume(selected_actor.cm) then
selected_actor.cm=nil end gh(ee) if cq then
if cq.cm and not coresume(cq.cm) then
if not has_flag(cq.ci,cut_no_follow) and
cq.co then camera_follow(cq.co) selected_actor=cq.co end del(cp,cq) cq=nil if#cp>0 then
cq=cp[#cp] end end else gh(dv) end gi() gj() gk=1.5-rnd(3) gl=1.5-rnd(3) gk*=bz gl*=bz if not ca then
bz*=0.90 if bz<0.05 then bz=0 end
end end function gg() rectfill(0,0,ep,fn,0) camera(cc+gk,0+gl) clip(0+dt,dc+dt,ep+1-dt*2,64-dt*2) gm() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dc-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dc-8,8) end if show_debuginfo then
print("x: "..fo.." y:"..fp-dc,80,dc-8,8) end gn() if cr and cr.ct then
go() gp() return end if gq==cq then
else gq=cq return end if not cq then
gr() end if(not cq
or not has_flag(cq.ci,cut_noverbs)) and(gq==cq) then gs() else end gq=cq if not cq then
gp() end end function gi() if cq then
if btnp(4) and btnp(5) and cq.cn then
cq.cm=cocreate(cq.cn) cq.cn=nil return end return end if btn(0) then fo-=1 end
if btn(1) then fo+=1 end
if btn(2) then fp-=1 end
if btn(3) then fp+=1 end
if btnp(4) then gt(1) end
if btnp(5) then gt(2) end
if enable_mouse then
if stat(32)-1!=fu then fo=stat(32)-1 end
if stat(33)-1!=fv then fp=stat(33)-1 end
if stat(34)>0 then
if not fw then
gt(stat(34)) fw=true end else fw=false end fu=stat(32)-1 fv=stat(33)-1 end fo=max(fo,0) fo=min(fo,127) fp=max(fp,0) fp=min(fp,127) end function gt(gu) local gv=fx if not selected_actor then
return end if cr and cr.ct then
if gw then
selected_sentence=gw end return end if gx then
fx=get_verb(gx) elseif gy then if gu==1 then
if(fx[2]=="use"or fx[2]=="give")
and fy then fz=gy else fy=gy end elseif gz then fx=get_verb(gz) fy=gy ha(fy) gr() end elseif hb then if hb==ft[1] then
if selected_actor.hc>0 then
selected_actor.hc-=1 end else if selected_actor.hc+2<flr(#selected_actor.dz/4) then
selected_actor.hc+=1 end end return end if(fy!=nil) then
if fx[2]=="use"or fx[2]=="give"then
if fz then
else return end end gb=true selected_actor.cm=cocreate(function(cg,bq,bu,bh) if not bq.owner
or bh then hd=bh or bq he=get_use_pos(hd) walk_to(selected_actor,he.x,he.y) if selected_actor.fm!=2 then return end
use_dir=hd if hd.use_dir then use_dir=hd.use_dir a("overide usedir") end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(bu,bq) then
start_script(bq.verbs[bu[1]],false,bq,bh) else unsupported_action(bu[2],bq,bh) end dw() end) coresume(selected_actor.cm,selected_actor,fy,fx,fz) elseif(fp>dc and fp<dc+64) then gb=true selected_actor.cm=cocreate(function(x,y) walk_to(selected_actor,x,y) dw() end) coresume(selected_actor.cm,fo,fp-dc) end end function gj() gx=nil gz=nil gy=nil gw=nil hb=nil if cr and cr.ct then
for bx in all(cr.cs) do if hf(bx) then
gw=bx end end return end hg() for ea,bq in pairs(room_curr.objects) do if(not bq.class
or(bq.class and bq.class!=class_untouchable)) and(not bq.dependent_on or find_object(bq.dependent_on).state==bq.dependent_on_state) then hh(bq,bq.w*8,bq.h*8,cc,hi) else bq.hj=nil end if hf(bq) then
gy=bq end hk(bq) end for ea,cg in pairs(actors) do if cg.in_room==room_curr then
hh(cg,cg.w*8,cg.h*8,cc,hi) hk(cg) if hf(cg)
and cg!=selected_actor then gy=cg end end end if selected_actor then
for bs in all(verbs) do if hf(bs) then
gx=bs end end for hl in all(ft) do if hf(hl) then
hb=hl end end for ea,bq in pairs(selected_actor.dz) do if hf(bq) then
gy=bq if fx[2]=="pickup"and gy.owner then
fx=nil end end if bq.owner!=selected_actor then
del(selected_actor.dz,bq) end end if fx==nil then
fx=get_verb(verb_default) end if gy then
gz=find_default_verb(gy) end end end function hg() gd={} for x=1,64 do gd[x]={} end end function hk(bq) ej=-1 if bq.hm then
ej=bq.y else ej=bq.y+(bq.h*8) end hn=flr(ej-dc) if bq.elevation then hn+=bq.elevation end
add(gd[hn],bq) end function gm() ho(room_curr) map(room_curr.map_x,room_curr.map_y,0,dc,room_curr.hp,room_curr.hq) pal() for hr=1,64 do hn=gd[hr] for bq in all(hn) do if not has_flag(bq.class,class_actor) then
if(bq.states)
and bq.states[bq.state] and(bq.states[bq.state]>0) and(not bq.dependent_on or find_object(bq.dependent_on).state==bq.dependent_on_state) and not bq.owner then hs(bq) end else if(bq.in_room==room_curr) then
ht(bq) end end hu(bq) end end end function ho(bq) for hv in all(bq.col_replace) do pal(hv[1],hv[2]) end if bq.lighting then
hw(bq.lighting) elseif bq.in_room then hw(bq.in_room.lighting) end end function hs(bq) ho(bq) hx=1 if bq.repeat_x then hx=bq.repeat_x end
for h=0,hx-1 do hy(bq.states[bq.state],bq.x+(h*(bq.w*8)),bq.y,bq.w,bq.h,bq.trans_col,bq.flip_x) end pal() end function ht(cg) if cg.fm==1
and cg.walk_anim then cg.hz+=1 if cg.hz>5 then
cg.hz=1 cg.ia+=1 if cg.ia>#cg.walk_anim then cg.ia=1 end
end ib=cg.walk_anim[cg.ia] else ib=cg.idle[cg.face_dir] end ho(cg) hy(ib,cg.dd,cg.hm,cg.w,cg.h,cg.trans_col,cg.flip,false) if ek
and ek==cg then if cg.ic<7 then
ib=cg.talk[cg.face_dir] hy(ib,cg.dd,cg.hm+8,1,1,cg.trans_col,cg.flip,false) end cg.ic+=1 if cg.ic>14 then cg.ic=1 end
end pal() end function gr() id=""ie=12 if not gb then
if fx then
id=fx[3] end if fy then
id=id.." "..fy.name if fx[2]=="use"then
id=id.." with"elseif fx[2]=="give"then id=id.." to"end end if fz then
id=id.." "..fz.name elseif gy and gy.name!=""and(not fy or(fy!=gy)) then id=id.." "..gy.name end ga=id else id=ga ie=7 end print(ig(id),ih(id),dc+66,ie) end function gn() if eh then
ii=0 for ij in all(eh.et) do ik=0 if eh.el==1 then
ik=((eh.cz*4)-(#ij*4))/2 end il(ij,eh.x+ik,eh.y+ii,eh.col) ii+=6 end eh.eu-=1 if(eh.eu<=0) then
stop_talking() end end end function gs() es=0 ej=75 im=0 for bs in all(verbs) do io=verb_maincol if gz
and(bs==gz) then io=verb_defcol end if bs==gx then io=verb_hovcol end
bt=get_verb(bs) print(bt[3],es,ej+dc+1,verb_shadcol) print(bt[3],es,ej+dc,io) bs.x=es bs.y=ej hh(bs,#bt[3]*4,5,0,0) hu(bs) if#bt[3]>im then im=#bt[3] end
ej=ej+8 if ej>=95 then
ej=75 es=es+(im+1.0)*4 im=0 end end if selected_actor then
es=86 ej=76 ip=selected_actor.hc*4 iq=min(ip+8,#selected_actor.dz) for ir=1,8 do rectfill(es-1,dc+ej-1,es+8,dc+ej+8,1) bq=selected_actor.dz[ip+ir] if bq then
bq.x=es bq.y=ej hs(bq) hh(bq,bq.w*8,bq.h*8,0,0) hu(bq) end es+=11 if es>=125 then
ej+=12 es=86 end ir+=1 end for er=1,2 do is=ft[er] if hb==is then pal(verb_maincol,7) end
hy(is.spr,is.x,is.y,1,1,0) hh(is,8,7,0,0) hu(is) pal() end end end function go() es=0 ej=70 for bx in all(cr.cs) do bx.x=es bx.y=ej hh(bx,bx.cz*4,#bx.cu*5,0,0) io=cr.col if bx==gw then io=cr.da end
for ij in all(bx.cu) do print(ig(ij),es,ej+dc,io) ej+=5 end hu(bx) ej+=2 end end function gp() col=fr[fs] pal(7,col) spr(32,fo-4,fp-3,1,1,0) pal() fq+=1 if fq>7 then
fq=1 fs+=1 if(fs>#fr) then fs=1 end
end end function hy(it,x,y,w,h,iu,flip_x,iv) palt(0,false) palt(iu,true) spr(it,x,dc+y,w,h,flip_x,iv) pal() end function ge() for iw,ew in pairs(rooms) do if ew.map_x1 then
ew.hp=ew.map_x1-ew.map_x+1 ew.hq=ew.map_y1-ew.map_y+1 else ew.hp=16 ew.hq=8 end for ix,bq in pairs(ew.objects) do bq.in_room=ew end end for iy,cg in pairs(actors) do cg.fm=2 cg.hz=1 cg.ic=1 cg.ia=1 cg.dz={} cg.hc=0 end end function hu(bq) if show_collision and bq.hj then
rect(bq.hj.x,bq.hj.y,bq.hj.iz,bq.hj.ja,8) end end function gh(scripts) for ef in all(scripts) do if ef[2] and not coresume(ef[2],ef[3],ef[4]) then
del(scripts,ef) ef=nil end end end function hw(jb) if jb then jb=1-jb end
local fg=flr(mid(0,jb,1)*100) jc={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jd=1,15 do col=jd je=(fg+(jd*1.46))/22 for ea=1,je do col=jc[col] end pal(jd,col) end end function cd(cb) if type(cb)=="table"then
cb=cb.x end return mid(0,cb-64,(room_curr.hp*8)-ep-1) end function jf(x,y) ez=flr(x/8)+room_curr.map_x fa=flr(y/8)+room_curr.map_y jg=ff(ez,fa) return jg end function ey(bq) ez=flr(bq.x/8)+room_curr.map_x fa=flr(bq.y/8)+room_curr.map_y return{ez,fa} end function ff(ez,fa) jh=mget(ez,fa) jg=fget(jh,0) return jg end function ha(bq) ji={} for ea,bs in pairs(bq) do add(ji,ea) end return ji end function get_verb(bq) bu={} ji=ha(bq[1]) add(bu,ji[1]) add(bu,bq[1][ji[1]]) add(bu,bq.text) return bu end function cv(msg,eq) local cu={} local jj=""local jk=""local em=""local jl=function(jm) if#jk+#jj>jm then
add(cu,jj) jj=""end jj=jj..jk jk=""end for er=1,#msg do em=sub(msg,er,er) jk=jk..em if(em==" ")
or(#jk>eq-1) then jl(eq) elseif#jk>eq-1 then jk=jk.."-"jl(eq) elseif em==";"then jj=jj..sub(jk,1,#jk-1) jk=""jl(0) end end jl(eq) if jj!=""then
add(cu,jj) end return cu end function cx(cu) cw=0 for ij in all(cu) do if#ij>cw then cw=#ij end
end return cw end function has_flag(bq,jn) if band(bq,jn)!=0 then return true end
return false end function dw() fx=get_verb(verb_default) fy=nil fz=nil n=nil gb=false ga=""end function hh(bq,w,h,jo,jp) x=bq.x y=bq.y if has_flag(bq.class,class_actor) then
bq.dd=bq.x-(bq.w*8)/2 bq.hm=bq.y-(bq.h*8)+1 x=bq.dd y=bq.hm end bq.hj={x=x,y=y+dc,iz=x+w-1,ja=y+h+dc-1,jo=jo,jp=jp} end function fd(jq,jr) js={} jt(js,jq,0) ju={} ju[jv(jq)]=nil jw={} jw[jv(jq)]=0 while#js>0 and#js<1000 do local bb=js[#js] del(js,js[#js]) jx=bb[1] if jv(jx)==jv(jr) then
break end local jy={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else jz=jx[1]+x ka=jx[2]+y if abs(x)!=abs(y) then kb=1 else kb=1.4 end
if jz>=room_curr.map_x and jz<=room_curr.map_x+room_curr.hp
and ka>=room_curr.map_y and ka<=room_curr.map_y+room_curr.hq and ff(jz,ka) and((abs(x)!=abs(y)) or ff(jz,jx[2]) or ff(jz-x,ka)) then add(jy,{jz,ka,kb}) end end end end for kc in all(jy) do local kd=jv(kc) local ke=jw[jv(jx)]+kc[3] if(jw[kd]==nil) or(ke<jw[kd]) then
jw[kd]=ke local kf=ke+max(abs(jr[1]-kc[1]),abs(jr[2]-kc[2])) jt(js,kc,kf) ju[kd]=jx end end end fc={} jx=ju[jv(jr)] if jx then
local kg=jv(jx) local kh=jv(jq) while kg!=kh do add(fc,jx) jx=ju[kg] kg=jv(jx) end for er=1,#fc/2 do local ki=fc[er] local kj=#fc-(er-1) fc[er]=fc[kj] fc[kj]=ki end end return fc end function jt(kk,cb,fg) if#kk>=1 then
add(kk,{}) for er=(#kk),2,-1 do local kc=kk[er-1] if fg<kc[2] then
kk[er]={cb,fg} return else kk[er]=kc end end kk[1]={cb,fg} else add(kk,{cb,fg}) end end function jv(kl) return((kl[1]+1)*16)+kl[2] end function il(km,x,y,kn,ko) local kn=kn or 7 local ko=ko or 0 km=ig(km) for kp=-1,1 do for kq=-1,1 do print(km,x+kp,y+kq,ko) end end print(km,x,y,kn) end function ih(bx) return(ep/2)-flr((#bx*4)/2) end function kr(bx) return(fn/2)-flr(5/2) end function hf(bq) if not bq.hj then return false end
hj=bq.hj if(fo+hj.jo>hj.iz or fo+hj.jo<hj.x)
or(fp>hj.ja or fp<hj.y) then return false else return true end end function ig(bx) local a=""local ij,hv,kk=false,false for er=1,#bx do local hl=sub(bx,er,er) if hl=="^"then
if(hv) then a=a..hl end
hv=not hv elseif hl=="~"then if(kk) then a=a..hl end
kk,ij=not kk,not ij else if hv==ij and hl>="a"and hl<="z"then
for jd=1,26 do if hl==sub("abcdefghijklmnopqrstuvwxyz",jd,jd) then
hl=sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\",jd,jd) break end end end a=a..hl hv,kk=false,false end end return a end



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

