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


-- ========================
-- scumm-8 enums/constants
-- 

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


-- ========================
-- room definitions
--
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
							pause(50)
							println("in a galaxy not far away...",64,45,8,1)

							room(rooms.first_room, 1)
							shake(true)
							start_script(rooms.first_room.scripts.spin_top, true)
							println("cozy fireplaces...",90,20,8,1)
							println("(just look at it!)",90,20,8,1)
							shake(false)

							-- part 2
							room(rooms.second_room, 1)
							println("strange looking aliens...",30,20,8,1,false,true)
							put_actor_at(actors.purp, 130, actors.purp.y, rooms.second_room)
							walk_to(actors.purp, 
								actors.purp.x-30, 
								actors.purp.y)
							wait_for_actor(actors.purp)
							say(actors.purp, "what did you call me?!")

							-- part 3
							room(rooms.back_garden, 1)
							println("and even swimming pools!",90,20,8,1,false,true)
							camera_at(200)
							camera_pan_to(0)
							wait_for_camera()
							println("quack!",45,60,10,1)

							-- part 4
							room(rooms.outside_room, 1)

					--[[		-- outro
							--pause(25)
							room(rooms.title_room, 1)
							
							println("coming soon...:to a pico-8 near you!",64,45,8,1)
							fades(1,1)	-- fade out
							pause(100)
							]]
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
		  start_script(me.scripts.tentacle_guard)
		end,
		exit = function(me)
			-- pause fireplace while not in room
			stop_script(me.scripts.anim_fire)
			stop_script(me.scripts.tentacle_guard)
		end,
		lighting = 0.75, -- lighting level current room
		scripts = {	  -- scripts that are at room-level
			anim_fire = function()
				while true do
					for f=1,3 do
						set_state("fire", f)
						pause(8)
					end
				end
			end,
			spin_top = function()
				dir=-1				
				while true do	
					for x=1,3 do					
						for f=1,3 do
							set_state("spinning top", f)
							pause(4)
						end
						-- move top
						top = find_object("spinning top")
						top.x -= dir					
					end	
					dir *= -1
				end				
			end,
			tentacle_guard = function()
				while true do
					d("tentacle guarding---...")
					if proximity(actors.main_actor, actors.purp) < 30 then
						say(actors.purp, "halt!!!", true)
					end
					pause(10)
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
						say("it's a nice, warm fire...")
						pause(10)
						do_anim(selected_actor, anim_face, face_front)
						say("ouch! it's hot!:*stupid fire*")
					end,
					talkto = function()
						say("'hi fire...'")
						pause(10)
						do_anim(selected_actor, anim_face, face_front)
						say("the fire didn't say hello back:burn!!")
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
							exit(rooms.outside_room.objects.front_door)
						else
							say("the door is closed")
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
						exit(rooms.second_room.objects.kitchen_door_hall) --, second_room) -- ()
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
							say("it is a bucket in my pocket")
						else
							say("it is a bucket")
						end
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
					give = function(me, noun2)
						if noun2 == actors.purp then
							say("can you fill this up for me?")							
							say(actors.purp, "sure")							
							me.owner = actors.purp
							pause(30)
							say(actors.purp, "here ya go...")							
							me.state = state_closed
							me.name = "full bucket"
							pickup_obj(me)
						else
							say("i might need this")
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
									println("*bang*",40,20,8,1)
									room(rooms.second_room, 1)
									selected_actor = actors.purp
									walk_to(selected_actor, 
										selected_actor.x+10, 
										selected_actor.y)
									say("what was that?!")
									say("i'd better check...")
									walk_to(selected_actor, 
										selected_actor.x-10, 
										selected_actor.y)
									room(rooms.first_room, 1)
									-- wait for a bit, then appear in room1
									pause(50)
									put_actor_at(selected_actor, 115, 44, rooms.first_room)
									walk_to(selected_actor, 
										selected_actor.x-10, 
										selected_actor.y)
									say("intruder!!!")
									do_anim(actors.main_actor, anim_face, actors.purp)
								end,
								-- override for cutscene
								function()
									--if cutscene_curr.skipped then
									--d("override!")
									room(rooms.first_room)
									put_actor_at(actors.purp, 105, 44, rooms.first_room)
									stop_talking()
									do_anim(actors.main_actor, anim_face, actors.purp)
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
						exit(rooms.first_room.objects.hall_door_kitchen)
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
							exit(rooms.back_garden.objects.garden_door_kitchen)
						else
							say("the door is closed")
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
			-- ========================
			-- initialise game in first room entry...
			-- 
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
						say("let's do this")
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
							exit(rooms.first_room.objects.front_door) --, first_room)
						else
							say("the door is closed")
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
						exit(rooms.second_room.objects.back_door)
					end
				}
			}
		},
	},

}

-- ========================
-- actor definitions
-- 
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

	purp = {
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
					say("it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(cut_noverbs, function()
						--do_anim(actors.purp, anim_face, selected_actor)
						say(me,"what do you want?")
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
						while not selected_sentence do pause() end
						-- chosen options
						dialog_hide()

						cutscene(cut_noverbs, function()
							say(selected_sentence.msg)
							
							if selected_sentence.num == 1 then
								say(me, "you are in paul's game")

							elseif selected_sentence.num == 2 then
								say(me, "it's complicated...")

							elseif selected_sentence.num == 3 then
								say(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")

							elseif selected_sentence.num == 4 then
								say(me, "ok bye!")
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

-- ========================
-- script overloads
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	

	room(rooms.title_room, 1) -- iris fade	
	--room(rooms.first_room, 1) -- iris fade	
	--room(rooms.outside_room, 1) -- iris fade
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
			say("i don't need them")
		else
			say("i don't need that")
		end

	elseif verb == "use" then
		if has_flag(obj1.class, class_actor) then
			say("i can't just *use* someone")
		end
		if obj2 then
			if has_flag(obj2.class, class_actor) then
				say("i can't use that on someone!")
			else
				say("that doesn't work")
			end
		end

	elseif verb == "give" then
		if has_flag(obj1.class, class_actor) then
			say("i don't think i should be giving this away")
		else
			say("i can't do that")
		end

	elseif verb == "lookat" then
		if has_flag(obj1.class, class_actor) then
			say("i think it's alive")
		else
			say("looks pretty ordinary")
		end

	elseif verb == "open" then
		if has_flag(obj1.class, class_actor) then
			say("they don't seem to open")
		else
			say("it doesn't seem to open")
		end

	elseif verb == "close" then
		if has_flag(obj1.class, class_actor) then
			say(s"they don't seem to close")
		else
			say("it doesn't seem to close")
		end

	elseif verb == "push" or verb == "pull" then
		if has_flag(obj1.class, class_actor) then
			say("moving them would accomplish nothing")
		else
			say("it won't budge!")
		end

	elseif verb == "talkto" then
		if has_flag(obj1.class, class_actor) then
			say("erm... i don't think they want to talk")
		else
			say("i am not talking to that!")
		end

	else
		say("hmm. no.")
	end
end 


-- (end of customisable game content)




















-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)



function shake(cb) if cb then
cc=1 end cd=cb end function camera_at(ce) cf=cg(ce) ch=nil ci=nil end function camera_follow(cj) ci=cj ch=nil ck=function() while ci do if ci.in_room==room_curr then
cf=cg(ci) end yield() end end start_script(ck,true) end function camera_pan_to(ce) ch=cg(ce) ci=nil ck=function() while(true) do if cf==ch then
ch=nil return elseif ch>cf then cf+=0.5 else cf-=0.5 end yield() end end start_script(ck,true) end function wait_for_camera() while script_running(ck) do yield() end end function cutscene(cl,cm,cn) co={cl=cl,cp=cocreate(cm),cq=cn,cr=ci} add(cs,co) ct=co pause() end function dialog_add(msg) if not cu then cu={cv={},cw=false} end
cx=cy(msg,32) cz=da(cx) db={num=#cu.cv+1,msg=msg,cx=cx,dc=cz} add(cu.cv,db) end function dialog_start(col,dd) cu.col=col cu.dd=dd cu.cw=true selected_sentence=nil end function dialog_hide() cu.cw=false end function dialog_clear() cu.cv={} selected_sentence=nil end function dialog_end() cu=nil end function get_use_pos(bt) de=bt.use_pos if type(de)=="table"then
x=de.x-cf y=de.y-df elseif not de or de==pos_infront then x=bt.x+((bt.w*8)/2)-cf-4 y=bt.y+(bt.h*8)+2 elseif de==pos_left then if bt.dg then
x=bt.x-cf-(bt.w*8+4) y=bt.y+1 else x=bt.x-cf-2 y=bt.y+((bt.h*8)-2) end elseif de==pos_right then x=bt.x+(bt.w*8)-cf y=bt.y+((bt.h*8)-2) end return{x=x,y=y} end function do_anim(cj,dh,di) if dh==anim_face then
if type(di)=="table"then
dj=atan2(cj.x-di.x,di.y-cj.y) dk=93*(3.1415/180) dj=dk-dj dl=dj*(1130.938/3.1415) dl=dl%360 if(dl<0) then dl+=360 end
di=4-flr(dl/90) end while cj.face_dir!=di do if cj.face_dir<di then
cj.face_dir+=1 else cj.face_dir-=1 end cj.flip=(cj.face_dir==face_left) pause(10) end end end function open_door(dm,dn) if state_of(dm)==state_open then
say("it's already open") else set_state(dm,state_open) if dn then set_state(dn,state_open) end
end end function close_door(dm,dn) if state_of(dm)==state_closed then
say("it's already closed") else set_state(dm,state_closed) if dn then set_state(dn,state_closed) end
end end function exit(dp,dq) dr=dp.in_room room(dr,dq) ds=get_use_pos(dp) put_actor_at(selected_actor,ds.x,ds.y,dr) if dp.use_dir then
dt=dp.use_dir+2 if dt>4 then
dt-=4 end else dt=1 end selected_actor.face_dir=dt end function fades(du,v) if v==1 then
dv=0 else dv=50 end while true do dv+=v*2 if dv>50
or dv<0 then return end if du==1 then
dw=min(dv,32) end yield() end end function room(dr,du) stop_script(dx) if du and room_curr then
fades(du,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end dy={} dz() room_curr=dr if not ci
or ci.in_room!=room_curr then cf=0 end stop_talking() if du then
dx=function() fades(du,-1) end start_script(dx,true) else dw=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(bx,ea) if not ea then return false end
if not ea.verbs then return false end
if type(bx)=="table"then
if ea.verbs[bx[1]] then return true end
else if ea.verbs[bx] then return true end
end return false end function pickup_obj(eb) bt=find_object(eb) if bt
then add(selected_actor.ec,bt) bt.owner=selected_actor del(bt.in_room.objects,bt) end end function owner_of(eb) bt=find_object(eb) if bt then
return bt.owner end end function state_of(eb,state) bt=find_object(eb) if bt then
return bt.state end end function set_state(eb,state) bt=find_object(eb) if bt then
bt.state=state end end function find_object(name) if type(name)=="table"then return name end
for ed,bt in pairs(room_curr.objects) do if bt.name==name then return bt end
end end function start_script(ee,ef,eg,bj) local cp=cocreate(ee) if ef then
add(eh,{ee,cp,eg,bj}) else add(dy,{ee,cp,eg,bj}) end end function script_running(ee) for ed,ei in pairs(dy) do if(ei[1]==ee) then
return ei end end for ed,ei in pairs(eh) do if(ei[1]==ee) then
return ei end end return false end function stop_script(ee) ei=script_running(ee) if ei then
del(dy,ei) del(eh,ei) end end function pause(ej) ej=ej or 1 for x=1,ej do yield() end end function wait_for_message() while ek!=nil do yield() end end function say(cj,msg,el,em) if type(cj)=="string"then
msg=cj cj=selected_actor end en=cj.y-(cj.h)*8+4 eo=cj println(msg,cj.x,en,cj.col,1,el,em) end function stop_talking() ek=nil eo=nil end function println(msg,x,y,col,ep,el,em) local col=col or 7 local ep=ep or 0 local cx={} local eq=""local er=""cz=0 es=min(x-cf,et-(x-cf)) eu=max(flr(es/2),16) er=""for ev=1,#msg do eq=sub(msg,ev,ev) if eq==":"then
er=sub(msg,ev+1) msg=sub(msg,1,ev-1) break end end cx=cy(msg,eu) cz=da(cx) if ep==1 then
ew=x-cf-((cz*4)/2) end ew=max(2,ew) en=max(18,y) ew=min(ew,et-(cz*4)-1) ek={ex=cx,x=ew,y=en,col=col,ep=ep,ey=(#msg)*8,dc=cz,el=el} if(#er>0) then
ez=eo wait_for_message() eo=ez println(er,x,y,col,ep,el) end if not em then
wait_for_message() end end function put_actor_at(cj,x,y,fa) if fa then cj.in_room=fa end
cj.x=x cj.y=y end function walk_to(cj,x,y) x=x+cf fb=fc(cj) fd=flr(x/8)+room_curr.map_x fe=flr(y/8)+room_curr.map_y ff={fd,fe} fg=fh(fb,ff) fi=fc({x=x,y=y}) if fj(fi[1],fi[2]) then
add(fg,fi) end for fk in all(fg) do fl=(fk[1]-room_curr.map_x)*8+4 fm=(fk[2]-room_curr.map_y)*8+4 local fn=sqrt((fl-cj.x)^2+(fm-cj.y)^2) local fo=cj.speed*(fl-cj.x)/fn local fp=cj.speed*(fm-cj.y)/fn if fn>1 then
cj.fq=1 cj.flip=(fo<0) cj.face_dir=face_right if(cj.flip) then cj.face_dir=face_left end
for ev=0,fn/cj.speed do cj.x=cj.x+fo cj.y=cj.y+fp yield() end end end cj.fq=2 end function wait_for_actor(cj) cj=cj or selected_actor while cj.fq!=2 do yield() end end function proximity(by,bz) if type(by)=="string"then
by=find_object(by) end if type(by)=="string"then
bz=find_object(bz) end if by.in_room==bz.in_room then
local fn=sqrt((by.x-bz.x)^2+(by.y-bz.y)^2) return fn else return 1000 end end et=127 fr=127 df=16 cf=0 ch=nil ck=nil cc=0 fs=et/2 ft=fr/2 fu=0 fv={7,12,13,13,12,7} fw=1 fx={{spr=16,x=75,y=df+60},{spr=48,x=75,y=df+72}} fy=0 fz=0 ga=false room_curr=nil gb=nil gc=nil gd=nil ge=""gf=false ek=nil cu=nil ct=nil eo=nil dw=0 gg=0 eh={} dy={} cs={} gh={} function _init() if enable_mouse then poke(0x5f2d,1) end
gi() start_script(startup_script,true) end function _update60() gj() end function _draw() gk() end function gj() if selected_actor and selected_actor.cp and not coresume(selected_actor.cp) then
selected_actor.cp=nil end gl(eh) if ct then
if ct.cp and not coresume(ct.cp) then
if not has_flag(ct.cl,cut_no_follow) and
ct.cr then camera_follow(ct.cr) selected_actor=ct.cr end del(cs,ct) ct=nil if#cs>0 then
ct=cs[#cs] end end else gl(dy) end gm() gn() go=1.5-rnd(3) gp=1.5-rnd(3) go*=cc gp*=cc if not cd then
cc*=0.90 if cc<0.05 then cc=0 end
end end function gk() rectfill(0,0,et,fr,0) camera(cf+go,0+gp) clip(0+dw,df+dw,et+1-dw*2,64-dw*2) gq() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,df-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,df-8,8) end if show_debuginfo then
print("x: "..fs.." y:"..ft-df,80,df-8,8) end gr() if cu and cu.cw then
gs() gt() return end if gu==ct then
else gu=ct return end if not ct then
gv() end if(not ct
or not has_flag(ct.cl,cut_noverbs)) and(gu==ct) then gw() else end gu=ct if not ct then
gt() end end function gm() if ct then
if btnp(4) and btnp(5) and ct.cq then
ct.cp=cocreate(ct.cq) ct.cq=nil return end return end if btn(0) then fs-=1 end
if btn(1) then fs+=1 end
if btn(2) then ft-=1 end
if btn(3) then ft+=1 end
if btnp(4) then gx(1) end
if btnp(5) then gx(2) end
if enable_mouse then
if stat(32)-1!=fy then fs=stat(32)-1 end
if stat(33)-1!=fz then ft=stat(33)-1 end
if stat(34)>0 then
if not ga then
gx(stat(34)) ga=true end else ga=false end fy=stat(32)-1 fz=stat(33)-1 end fs=max(fs,0) fs=min(fs,127) ft=max(ft,0) ft=min(ft,127) end function gx(gy) local gz=gb if not selected_actor then
return end if cu and cu.cw then
if ha then
selected_sentence=ha end return end if hb then
gb=get_verb(hb) elseif hc then if gy==1 then
if(gb[2]=="use"or gb[2]=="give")
and gc then gd=hc else gc=hc end elseif hd then gb=get_verb(hd) gc=hc he(gc) gv() end elseif hf then if hf==fx[1] then
if selected_actor.hg>0 then
selected_actor.hg-=1 end else if selected_actor.hg+2<flr(#selected_actor.ec/4) then
selected_actor.hg+=1 end end return end if gc!=nil
and not gf then if gb[2]=="use"or gb[2]=="give"then
if gd then
else return end end gf=true selected_actor.cp=cocreate(function(cj,bt,bx,bj) if not bt.owner
or bj then hh=bj or bt hi=get_use_pos(hh) walk_to(selected_actor,hi.x,hi.y) if selected_actor.fq!=2 then return end
use_dir=hh if hh.use_dir then use_dir=hh.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(bx,bt) then
start_script(bt.verbs[bx[1]],false,bt,bj) else unsupported_action(bx[2],bt,bj) end dz() end) coresume(selected_actor.cp,selected_actor,gc,gb,gd) elseif(ft>df and ft<df+64) then gf=true selected_actor.cp=cocreate(function(x,y) walk_to(selected_actor,x,y) dz() end) coresume(selected_actor.cp,fs,ft-df) end end function gn() hb=nil hd=nil hc=nil ha=nil hf=nil if cu and cu.cw then
for ca in all(cu.cv) do if hj(ca) then
ha=ca end end return end hk() for ed,bt in pairs(room_curr.objects) do if(not bt.class
or(bt.class and bt.class!=class_untouchable)) and(not bt.dependent_on or find_object(bt.dependent_on).state==bt.dependent_on_state) then hl(bt,bt.w*8,bt.h*8,cf,hm) else bt.hn=nil end if hj(bt) then
if not hc
or(not bt.z and hc.z<0) or(bt.z and hc.z and bt.z>hc.z) then hc=bt end end ho(bt) end for ed,cj in pairs(actors) do if cj.in_room==room_curr then
hl(cj,cj.w*8,cj.h*8,cf,hm) ho(cj) if hj(cj)
and cj!=selected_actor then hc=cj end end end if selected_actor then
for bv in all(verbs) do if hj(bv) then
hb=bv end end for hp in all(fx) do if hj(hp) then
hf=hp end end for ed,bt in pairs(selected_actor.ec) do if hj(bt) then
hc=bt if gb[2]=="pickup"and hc.owner then
gb=nil end end if bt.owner!=selected_actor then
del(selected_actor.ec,bt) end end if gb==nil then
gb=get_verb(verb_default) end if hc then
hd=find_default_verb(hc) end end end function hk() gh={} for x=-64,64 do gh[x]={} end end function ho(bt) en=-1 if bt.hq then
en=bt.y else en=bt.y+(bt.h*8) end hr=flr(en-df) if bt.z then hr=bt.z end
add(gh[hr],bt) end function gq() for z=-64,64 do if z==0 then
hs(room_curr) map(room_curr.map_x,room_curr.map_y,0,df,room_curr.ht,room_curr.hu) pal() else hr=gh[z] for bt in all(hr) do if not has_flag(bt.class,class_actor) then
if(bt.states)
and bt.states[bt.state] and(bt.states[bt.state]>0) and(not bt.dependent_on or find_object(bt.dependent_on).state==bt.dependent_on_state) and not bt.owner then hv(bt) end else if(bt.in_room==room_curr) then
hw(bt) end end hx(bt) end end end end function hs(bt) for hy in all(bt.col_replace) do pal(hy[1],hy[2]) end if bt.lighting then
hz(bt.lighting) elseif bt.in_room then hz(bt.in_room.lighting) end end function hv(bt) hs(bt) ia=1 if bt.repeat_x then ia=bt.repeat_x end
for h=0,ia-1 do ib(bt.states[bt.state],bt.x+(h*(bt.w*8)),bt.y,bt.w,bt.h,bt.trans_col,bt.flip_x) end pal() end function hw(cj) if cj.fq==1
and cj.walk_anim then cj.ic+=1 if cj.ic>5 then
cj.ic=1 cj.id+=1 if cj.id>#cj.walk_anim then cj.id=1 end
end ie=cj.walk_anim[cj.id] else ie=cj.idle[cj.face_dir] end hs(cj) ib(ie,cj.dg,cj.hq,cj.w,cj.h,cj.trans_col,cj.flip,false) if eo
and eo==cj then if cj.ig<7 then
ie=cj.talk[cj.face_dir] ib(ie,cj.dg,cj.hq+8,1,1,cj.trans_col,cj.flip,false) end cj.ig+=1 if cj.ig>14 then cj.ig=1 end
end pal() end function gv() ih=""ii=12 if not gf then
if gb then
ih=gb[3] end if gc then
ih=ih.." "..gc.name if gb[2]=="use"then
ih=ih.." with"elseif gb[2]=="give"then ih=ih.." to"end end if gd then
ih=ih.." "..gd.name elseif hc and hc.name!=""and(not gc or(gc!=hc)) then ih=ih.." "..hc.name end ge=ih else ih=ge ii=7 end print(ij(ih),ik(ih),df+66,ii) end function gr() if ek then
il=0 for im in all(ek.ex) do io=0 if ek.ep==1 then
io=((ek.dc*4)-(#im*4))/2 end ip(im,ek.x+io,ek.y+il,ek.col,0,ek.el) il+=6 end ek.ey-=1 if(ek.ey<=0) then
stop_talking() end end end function gw() ew=0 en=75 iq=0 for bv in all(verbs) do ir=verb_maincol if hd
and(bv==hd) then ir=verb_defcol end if bv==hb then ir=verb_hovcol end
bw=get_verb(bv) print(bw[3],ew,en+df+1,verb_shadcol) print(bw[3],ew,en+df,ir) bv.x=ew bv.y=en hl(bv,#bw[3]*4,5,0,0) hx(bv) if#bw[3]>iq then iq=#bw[3] end
en=en+8 if en>=95 then
en=75 ew=ew+(iq+1.0)*4 iq=0 end end if selected_actor then
ew=86 en=76 is=selected_actor.hg*4 it=min(is+8,#selected_actor.ec) for iu=1,8 do rectfill(ew-1,df+en-1,ew+8,df+en+8,1) bt=selected_actor.ec[is+iu] if bt then
bt.x=ew bt.y=en hv(bt) hl(bt,bt.w*8,bt.h*8,0,0) hx(bt) end ew+=11 if ew>=125 then
en+=12 ew=86 end iu+=1 end for ev=1,2 do iv=fx[ev] if hf==iv then pal(verb_maincol,7) end
ib(iv.spr,iv.x,iv.y,1,1,0) hl(iv,8,7,0,0) hx(iv) pal() end end end function gs() ew=0 en=70 for ca in all(cu.cv) do ca.x=ew ca.y=en hl(ca,ca.dc*4,#ca.cx*5,0,0) ir=cu.col if ca==ha then ir=cu.dd end
for im in all(ca.cx) do print(ij(im),ew,en+df,ir) en+=5 end hx(ca) en+=2 end end function gt() col=fv[fw] pal(7,col) spr(32,fs-4,ft-3,1,1,0) pal() fu+=1 if fu>7 then
fu=1 fw+=1 if(fw>#fv) then fw=1 end
end end function ib(iw,x,y,w,h,ix,flip_x,iy) palt(0,false) palt(ix,true) spr(iw,x,df+y,w,h,flip_x,iy) palt(ix,false) palt(0,true) end function gi() for iz,fa in pairs(rooms) do if fa.map_x1 then
fa.ht=fa.map_x1-fa.map_x+1 fa.hu=fa.map_y1-fa.map_y+1 else fa.ht=16 fa.hu=8 end for ja,bt in pairs(fa.objects) do bt.in_room=fa end end for jb,cj in pairs(actors) do cj.fq=2 cj.ic=1 cj.ig=1 cj.id=1 cj.ec={} cj.hg=0 end end function hx(bt) if show_collision and bt.hn then
rect(bt.hn.x,bt.hn.y,bt.hn.jc,bt.hn.jd,8) end end function gl(scripts) for ei in all(scripts) do if ei[2] and not coresume(ei[2],ei[3],ei[4]) then
del(scripts,ei) ei=nil end end end function hz(je) if je then je=1-je end
local fk=flr(mid(0,je,1)*100) jf={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jg=1,15 do col=jg jh=(fk+(jg*1.46))/22 for ed=1,jh do col=jf[col] end pal(jg,col) end end function cg(ce) if type(ce)=="table"then
ce=ce.x end return mid(0,ce-64,(room_curr.ht*8)-et-1) end function ji(x,y) fd=flr(x/8)+room_curr.map_x fe=flr(y/8)+room_curr.map_y jj=fj(fd,fe) return jj end function fc(bt) fd=flr(bt.x/8)+room_curr.map_x fe=flr(bt.y/8)+room_curr.map_y return{fd,fe} end function fj(fd,fe) jk=mget(fd,fe) jj=fget(jk,0) return jj end function he(bt) jl={} for ed,bv in pairs(bt) do add(jl,ed) end return jl end function get_verb(bt) bx={} jl=he(bt[1]) add(bx,jl[1]) add(bx,bt[1][jl[1]]) add(bx,bt.text) return bx end function cy(msg,eu) local cx={} local jm=""local jn=""local eq=""local jo=function(jp) if#jn+#jm>jp then
add(cx,jm) jm=""end jm=jm..jn jn=""end for ev=1,#msg do eq=sub(msg,ev,ev) jn=jn..eq if(eq==" ")
or(#jn>eu-1) then jo(eu) elseif#jn>eu-1 then jn=jn.."-"jo(eu) elseif eq==";"then jm=jm..sub(jn,1,#jn-1) jn=""jo(0) end end jo(eu) if jm!=""then
add(cx,jm) end return cx end function da(cx) cz=0 for im in all(cx) do if#im>cz then cz=#im end
end return cz end function has_flag(bt,jq) if band(bt,jq)!=0 then return true end
return false end function dz() gb=get_verb(verb_default) gc=nil gd=nil n=nil gf=false ge=""end function hl(bt,w,h,jr,js) x=bt.x y=bt.y if has_flag(bt.class,class_actor) then
bt.dg=bt.x-(bt.w*8)/2 bt.hq=bt.y-(bt.h*8)+1 x=bt.dg y=bt.hq end bt.hn={x=x,y=y+df,jc=x+w-1,jd=y+h+df-1,jr=jr,js=js} end function fh(jt,ju) jv={} jw(jv,jt,0) jx={} jx[jy(jt)]=nil jz={} jz[jy(jt)]=0 while#jv>0 and#jv<1000 do local ba=jv[#jv] del(jv,jv[#jv]) ka=ba[1] if jy(ka)==jy(ju) then
break end local kb={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else kc=ka[1]+x kd=ka[2]+y if abs(x)!=abs(y) then ke=1 else ke=1.4 end
if kc>=room_curr.map_x and kc<=room_curr.map_x+room_curr.ht
and kd>=room_curr.map_y and kd<=room_curr.map_y+room_curr.hu and fj(kc,kd) and((abs(x)!=abs(y)) or fj(kc,ka[2]) or fj(kc-x,kd)) then add(kb,{kc,kd,ke}) end end end end for kf in all(kb) do local kg=jy(kf) local kh=jz[jy(ka)]+kf[3] if(jz[kg]==nil) or(kh<jz[kg]) then
jz[kg]=kh local ki=kh+max(abs(ju[1]-kf[1]),abs(ju[2]-kf[2])) jw(jv,kf,ki) jx[kg]=ka end end end fg={} ka=jx[jy(ju)] if ka then
local kj=jy(ka) local kk=jy(jt) while kj!=kk do add(fg,ka) ka=jx[kj] kj=jy(ka) end for ev=1,#fg/2 do local kl=fg[ev] local km=#fg-(ev-1) fg[ev]=fg[km] fg[km]=kl end end return fg end function jw(kn,ce,fk) if#kn>=1 then
add(kn,{}) for ev=(#kn),2,-1 do local kf=kn[ev-1] if fk<kf[2] then
kn[ev]={ce,fk} return else kn[ev]=kf end end kn[1]={ce,fk} else add(kn,{ce,fk}) end end function jy(ko) return((ko[1]+1)*16)+ko[2] end function ip(kp,x,y,kq,kr,el) if not el then kp=ij(kp) end
for ks=-1,1 do for kt=-1,1 do print(kp,x+ks,y+kt,kr) end end print(kp,x,y,kq) end function ik(ca) return(et/2)-flr((#ca*4)/2) end function ku(ca) return(fr/2)-flr(5/2) end function hj(bt) if not bt.hn then return false end
hn=bt.hn if(fs+hn.jr>hn.jc or fs+hn.jr<hn.x)
or(ft>hn.jd or ft<hn.y) then return false else return true end end function ij(ca) local a=""local im,hy,kn=false,false for ev=1,#ca do local hp=sub(ca,ev,ev) if hp=="^"then
if(hy) then a=a..hp end
hy=not hy elseif hp=="~"then if(kn) then a=a..hp end
kn,im=not kn,not im else if hy==im and hp>="a"and hp<="z"then
for jg=1,26 do if hp==sub("abcdefghijklmnopqrstuvwxyz",jg,jg) then
hp=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jg,jg) break end end end a=a..hp hy,kn=false,false end end return a end









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

