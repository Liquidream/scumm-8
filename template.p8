pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
-- scumm-8 game template
-- paul nicholas

-- 7004 tokens (5206 is engine!) - leaving 1188 tokens "spare"
-- now 6979 tokens (1213 spare)

-- debugging
show_debuginfo = false
show_collision = false
--show_pathfinding = true
show_perfinfo = true
enable_mouse = true
d = printh



-- game verbs (used in room definitions and ui)
verbs = {
	--{verb = verb_ref_name}, text = display_name
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
-- 

-- object states
state_closed, state_open, state_off, state_on, state_gone, state_here  = 1, 2, 1, 2, 1, 2

-- object classes (bitflags)
class_untouchable = 1 -- will not register when the cursor moves over it. the object is invisible to the user.
class_pickupable = 2  -- can be placed in actor inventory
class_talkable = 4		-- can talk to actor/object
class_giveable = 8		-- can be given to an actor/object
class_openable = 16   -- can be opened/closed
class_actor = 32      -- is an actor/person

cut_noverbs = 1 		-- this removes the interface during the cut-scene.
cut_no_follow = 4   -- this disables the follow-camera being reinstated after cut-scene.

-- actor constants - states for actor direction (not sprite #'s)
face_front, face_left, face_back, face_right = 1, 2, 3, 4
--
pos_infront, pos_behind, pos_left, pos_right, pos_inside = 1, 3, 2, 4, 5

-- actor animations
anim_face = 1	 -- face actor in a direction (show the turning stages of animation)


-- ================================================================
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

			--[[				selected_actor = actors.main_actor
							camera_follow(selected_actor)
							put_actor_at(selected_actor, 60, 50, rooms.first_room)
							change_room(rooms.first_room, 1)
							]]


							-- intro
							break_time(50)
							print_line("in a galaxy not far away...",64,45,8,1)

							change_room(rooms.first_room, 1)
							shake(true)
							start_script(rooms.first_room.scripts.spin_top,false,true)
							print_line("cozy fireplaces...",90,20,8,1)
							print_line("(just look at it!)",90,20,8,1)
							shake(false)

							-- part 2
							local purp = actors.purp_tentacle
							change_room(rooms.second_room, 1)
							print_line("strange looking aliens...",30,20,8,1,false,true)
							put_actor_at(purp, 130, purp.y, rooms.second_room)
							walk_to(purp, 
								purp.x-30, 
								purp.y)
							wait_for_actor(purp)
							say_line(purp, "what did you call me?!")

							-- part 3
							change_room(rooms.back_garden, 1)
							print_line("and even swimming pools!",90,20,8,1,false,true)
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
		bg_col = 12,
		col_replace = { 
		-- 	{ 7, 15 }, 
		-- 	-- { 4, 5 }, 
		-- 	-- { 6, 8 } 
		},
		enter = function(me)
			-- animate fireplace
			start_script(me.scripts.anim_fire, true) -- bg script

			start_script(me.scripts.tentacle_guard, true) -- bg script
			
		end,
		exit = function(me)
			-- pause fireplace while not in room
			stop_script(me.scripts.anim_fire)
		end,
		lighting = 0.75, -- lighting level current room
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
			end,
			tentacle_guard = function()
				while true do
					--d("tentacle guarding...")
					if proximity(actors.main_actor, actors.purp_tentacle) < 30 then
						say_line(actors.purp_tentacle, "halt!!!", true)
					end
					break_time(10)
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
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("ouch! it's hot!:*stupid fire*")
					end,
					talkto = function()
						say_line("'hi fire...'")
						break_time(10)
						do_anim(selected_actor, anim_face, face_front)
						say_line("the fire didn't say hello back:burn!!")
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
				z = 1, -- force to always be bg (0=bg layer)
				--elevation = -10, -- force to always be bg
				states = { -- states are spr values
					143, -- state_closed
					0   -- state_open
				},
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
							say_line(actors.purp_tentacle, "sure")
							me.owner = actors.purp_tentacle
							say_line(actors.purp_tentacle, "here ya go...")
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
				x = 2*8,
				y = 6*8,
				states = { 192, 193, 194 },
				col_replace = { -- replace colors (orig,new)
					{ 12, 7 } 
				},
				trans_col=15,
				w = 1,
				h = 1,
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
			ztest = {
				name = "ztest",
				state = state_closed,
				x = 4.5*8,
				y = 1*8,
				z = -1,
				w = 1,
				h = 4,
				states = {
					1, -- closed
				},
				trans_col = 11
			},
			window = {
				name = "window",
				class = class_openable,
				state = state_closed,

				-- todo: make this calculated, by closed walkable pos!
				use_pos = { x = 5 *8, y = (7 *8)+1},

				x = 4*8, 
				y = 1*8,
				--z = -2,
				w = 2,
				h = 2,  --
				states = { 
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
									me.z = -2
									print_line("*bang*",40,20,8,1)
									change_room(rooms.second_room, 1)
									selected_actor = actors.purp_tentacle
									walk_to(selected_actor, 
										selected_actor.x+10, 
										selected_actor.y)
									say_line("what was that?!")
									say_line("i'd better check...")
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
		map_y1 = 8,
		enter = function()
			-- todo: anything here?
		end,
		exit = function()
			-- todo: anything here?
		end,
		scripts = {
		},
		objects = {
			kitchen_door_hall = {
				name = "hall",
				state = state_open,
				x = 1 *8, 
				y = 2 *8,
				w = 1,
				h = 4,
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
				z = 1, -- force to always be bg (0=bg layer)
				states = {
					143, -- closed
					0   -- open
				},
				flip_x = true, -- used for flipping the sprite
				w = 1,	
				h = 4, 
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
		map_x1 = 47,
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
		scripts = {	
		},
		objects = {
			rail_left = {
				class = class_untouchable,
				x = 10 *8,
				y = 3 *8,
				state = 1,
				states = { 111 },
				w = 1,
				h = 2, 
				repeat_x = 8		-- repeat/tile the sprite in x dir
			},
			rail_right= {
				class = class_untouchable,
				x = 22 *8, -- (*8 to use map cell pos)
				y = 3 *8,
				state = 1,
				states = { 111 },
				w = 1,
				h = 2, 
				repeat_x = 8		-- repeat/tile the sprite in x dir
			},
			front_door = {
				name = "front door",
				class = class_openable,
				state = state_closed,
				x = 19 *8,
				y = 1 *8,
				states = {
					142, -- closed
					0   -- open
				},
				flip_x = true,
				w = 1,
				h = 3,
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
-- 
actors = {
	-- initialize the player's actor object
	main_actor = { 		
		name = "",
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
		x = 40,
		y = 48,
		w = 1,
		h = 3,
		face_dir = face_front,
		-- sprites for idle (front, left, back, right) - right=flip
		idle = { 30, 30, 30, 30 },
		talk = { 47, 47, 47, 47 },
		col = 11,    		-- speech text colour
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
							
							if selected_sentence.num == 1 then
								say_line(me, "you are in paul's game")

							elseif selected_sentence.num == 2 then
								say_line(me, "it's complicated...")

							elseif selected_sentence.num == 3 then
								say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")

							elseif selected_sentence.num == 4 then
								say_line(me, "ok bye!")
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


-- (end of customisable game content)

















-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)



function shake(bu) if bu then
bv=1 end bw=bu end function bx(by) local bz=nil if has_flag(by.class,class_talkable) then
bz="talkto"elseif has_flag(by.class,class_openable) then if by.state==state_closed then
bz="open"else bz="close"end else bz="lookat"end for ca in all(verbs) do cb=get_verb(ca) if cb[2]==bz then bz=ca break end
end return bz end function cc(cd,ce,cf) if cd=="walkto"then
return elseif cd=="pickup"then if has_flag(ce.class,class_actor) then
say_line"i don't need them"else say_line"i don't need that"end elseif cd=="use"then if has_flag(ce.class,class_actor) then
say_line"i can't just *use* someone"end if cf then
if has_flag(cf.class,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cd=="give"then if has_flag(ce.class,class_actor) then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cd=="lookat"then if has_flag(ce.class,class_actor) then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cd=="open"then if has_flag(ce.class,class_actor) then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cd=="close"then if has_flag(ce.class,class_actor) then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cd=="push"or cd=="pull"then if has_flag(ce.class,class_actor) then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cd=="talkto"then if has_flag(ce.class,class_actor) then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cg) ch=ci(cg) cj=nil ck=nil end function camera_follow(cl) ck=cl cj=nil cm=function() while ck do if ck.in_room==room_curr then
ch=ci(ck) end yield() end end start_script(cm,true) end function camera_pan_to(cg) cj=ci(cg) ck=nil cm=function() while(true) do if ch==cj then
cj=nil return elseif cj>ch then ch+=0.5 else ch-=0.5 end yield() end end start_script(cm,true) end function wait_for_camera() while script_running(cm) do yield() end end function cutscene(cn,co,cp) cq={cn=cn,cr=cocreate(co),cs=cp,ct=ck} add(cu,cq) cv=cq break_time() end function dialog_add(msg) if not cw then cw={cx={},cy=false} end
cz=da(msg,32) db=dc(cz) dd={num=#cw.cx+1,msg=msg,cz=cz,de=db} add(cw.cx,dd) end function dialog_start(col,df) cw.col=col cw.df=df cw.cy=true selected_sentence=nil end function dialog_hide() cw.cy=false end function dialog_clear() cw.cx={} selected_sentence=nil end function dialog_end() cw=nil end function get_use_pos(by) dg=by.use_pos if type(dg)=="table"then
x=dg.x-ch y=dg.y-dh elseif not dg or dg==pos_infront then x=by.x+((by.w*8)/2)-ch-4 y=by.y+(by.h*8)+2 elseif dg==pos_left then if by.di then
x=by.x-ch-(by.w*8+4) y=by.y+1 else x=by.x-ch-2 y=by.y+((by.h*8)-2) end elseif dg==pos_right then x=by.x+(by.w*8)-ch y=by.y+((by.h*8)-2) end return{x=x,y=y} end function do_anim(cl,dj,dk) if dj==anim_face then
if type(dk)=="table"then
dl=atan2(cl.x-dk.x,dk.y-cl.y) dm=93*(3.1415/180) dl=dm-dl dn=dl*360 dn=dn%360 if dn<0 then dn+=360 end
dk=4-flr(dn/90) end while cl.face_dir!=dk do if cl.face_dir<dk then
cl.face_dir+=1 else cl.face_dir-=1 end cl.flip=(cl.face_dir==face_left) break_time(10) end end end function open_door(dp,dq) if state_of(dp)==state_open then
say_line"it's already open"else set_state(dp,state_open) if dq then set_state(dq,state_open) end
end end function close_door(dp,dq) if state_of(dp)==state_closed then
say_line"it's already closed"else set_state(dp,state_closed) if dq then set_state(dq,state_closed) end
end end function come_out_door(dr,ds) dt=dr.in_room change_room(dt,ds) local du=get_use_pos(dr) put_actor_at(selected_actor,du.x,du.y,dt) if dr.use_dir then
dv=dr.use_dir+2 if dv>4 then
dv-=4 end else dv=1 end selected_actor.face_dir=dv end function fades(dw,ba) if ba==1 then
dx=0 else dx=50 end while true do dx+=ba*2 if dx>50
or dx<0 then return end if dw==1 then
dy=min(dx,32) end yield() end end function change_room(dt,dw) stop_script(dz) if dw and room_curr then
fades(dw,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ea={} eb() room_curr=dt if not ck
or ck.in_room!=room_curr then ch=0 end stop_talking() if dw then
dz=function() fades(dw,-1) end start_script(dz,true) else dy=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cd,ec) if not ec
or not ec.verbs then return false end if type(cd)=="table"then
if ec.verbs[cd[1]] then return true end
else if ec.verbs[cd] then return true end
end return false end function pickup_obj(ed) local by=find_object(ed) if by then
add(selected_actor.ee,by) by.owner=selected_actor del(by.in_room.objects,by) end end function owner_of(ed) by=find_object(ed) if by then
return by.owner end end function state_of(ed,state) by=find_object(ed) if by then
return by.state end end function set_state(ed,state) by=find_object(ed) if by then
by.state=state end end function find_object(name) if type(name)=="table"then return name end
for ef,by in pairs(room_curr.objects) do if by.name==name then return by end
end end function start_script(eg,eh,ei,bk) local cr=cocreate(eg) local scripts=ea if eh then
scripts=ej end add(scripts,{eg,cr,ei,bk}) end function script_running(eg) for ek in all({ea,ej}) do for ef,el in pairs(ek) do if el[1]==eg then
return el end end end return false end function stop_script(eg) el=script_running(eg) if el then
del(ea,el) del(ej,el) end end function break_time(em) em=em or 1 for x=1,em do yield() end end function wait_for_message() while en!=nil do yield() end end function say_line(cl,msg,eo,ep) if type(cl)=="string"then
msg=cl cl=selected_actor end eq=cl.y-(cl.h)*8+4 er=cl print_line(msg,cl.x,eq,cl.col,1,eo,ep) end function stop_talking() en,er=nil,nil end function print_line(msg,x,y,col,es,eo,ep) local col=col or 7 local es=es or 0 local et=min(x-ch,127-(x-ch)) local eu=max(flr(et/2),16) local ev=""for ew=1,#msg do local ex=sub(msg,ew,ew) if ex==":"then
ev=sub(msg,ew+1) msg=sub(msg,1,ew-1) break end end local cz=da(msg,eu) local db=dc(cz) if es==1 then
ey=x-ch-((db*4)/2) end ey=max(2,ey) eq=max(18,y) ey=min(ey,127-(db*4)-1) en={ez=cz,x=ey,y=eq,col=col,es=es,fa=(#msg)*8,de=db,eo=eo} if#ev>0 then
fb=er wait_for_message() er=fb print_line(ev,x,y,col,es,eo) end if not ep then
wait_for_message() end end function put_actor_at(cl,x,y,fc) if fc then cl.in_room=fc end
cl.x,cl.y=x,y end function walk_to(cl,x,y) x+=ch local fd=fe(cl) local ff=flr(x/8)+room_curr.map_x local fg=flr(y/8)+room_curr.map_y local fh={ff,fg} local fi=fj(fd,fh) local fk=fe({x=x,y=y}) if fl(fk[1],fk[2]) then
add(fi,fk) end for fm in all(fi) do local fn=(fm[1]-room_curr.map_x)*8+4 local fo=(fm[2]-room_curr.map_y)*8+4 local fp=sqrt((fn-cl.x)^2+(fo-cl.y)^2) local fq=cl.speed*(fn-cl.x)/fp local fr=cl.speed*(fo-cl.y)/fp if fp>1 then
cl.fs=1 cl.flip=(fq<0) cl.face_dir=face_right if cl.flip then cl.face_dir=face_left end
for ew=0,fp/cl.speed do cl.x+=fq cl.y+=fr yield() end end end cl.fs=2 end function wait_for_actor(cl) cl=cl or selected_actor while cl.fs!=2 do yield() end end function proximity(ce,cf) if type(ce)=="string"then
ce=find_object(ce) end if type(cf)=="string"then
cf=find_object(cf) end if ce.in_room==cf.in_room then
local fp=sqrt((ce.x-cf.x)^2+(ce.y-cf.y)^2) return fp else return 1000 end end dh=16 ch,cj,cm,bv=0,nil,nil,0 ft,fu,fv,fw=63.5,63.5,0,1 fx={7,12,13,13,12,7} fy={{spr=16,x=75,y=dh+60},{spr=48,x=75,y=dh+72}} function fz(by) local ga={} for ef,ca in pairs(by) do add(ga,ef) end return ga end function get_verb(by) local cd={} local ga=fz(by[1]) add(cd,ga[1]) add(cd,by[1][ga[1]]) add(cd,by.text) return cd end function eb() gb=get_verb(verb_default) gc,gd,n,ge,gf=nil,nil,nil,false,""end eb() en=nil cw=nil cv=nil er=nil ej={} ea={} cu={} gg={} dy,dy=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gh() start_script(startup_script,true) end function _update60() gi() end function _draw() gj() end function gi() if selected_actor and selected_actor.cr
and not coresume(selected_actor.cr) then selected_actor.cr=nil end gk(ej) if cv then
if cv.cr
and not coresume(cv.cr) then if not has_flag(cv.cn,cut_no_follow)
and cv.ct then camera_follow(cv.ct) selected_actor=cv.ct end del(cu,cv) cv=nil if#cu>0 then
cv=cu[#cu] end end else gk(ea) end gl() gm() gn,go=1.5-rnd(3),1.5-rnd(3) gn*=bv go*=bv if not bw then
bv*=0.90 if bv<0.05 then bv=0 end
end end function gj() rectfill(0,0,127,127,0) camera(ch+gn,0+go) clip(0+dy,dh+dy,128-dy*2,64-dy*2) gp() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dh-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dh-8,8) end if show_debuginfo then
print("x: "..ft.." y:"..fu-dh,80,dh-8,8) end gq() if cw
and cw.cy then gr() gs() return end if gt==cv then
else gt=cv return end if not cv then
gu() end if(not cv
or not has_flag(cv.cn,cut_noverbs)) and(gt==cv) then gv() else end gt=cv if not cv then
gs() end end function gl() if cv then
if btnp(4) and btnp(5) and cv.cs then
cv.cr=cocreate(cv.cs) cv.cs=nil return end return end if btn(0) then ft-=1 end
if btn(1) then ft+=1 end
if btn(2) then fu-=1 end
if btn(3) then fu+=1 end
if btnp(4) then gw(1) end
if btnp(5) then gw(2) end
if enable_mouse then
gx,gy=stat(32)-1,stat(33)-1 if gx!=gz then ft=gx end
if gy!=ha then fu=gy end
if stat(34)>0 then
if not hb then
gw(stat(34)) hb=true end else hb=false end gz=gx ha=gy end ft=mid(0,ft,127) fu=mid(0,fu,127) end function gw(hc) local hd=gb if not selected_actor then
return end if cw and cw.cy then
if he then
selected_sentence=he end return end if hf then
gb=get_verb(hf) elseif hg then if hc==1 then
if(gb[2]=="use"or gb[2]=="give")
and gc then gd=hg else gc=hg end elseif hh then gb=get_verb(hh) gc=hg fz(gc) gu() end elseif hi then if hi==fy[1] then
if selected_actor.hj>0 then
selected_actor.hj-=1 end else if selected_actor.hj+2<flr(#selected_actor.ee/4) then
selected_actor.hj+=1 end end return end if gc!=nil
and not ge then if gb[2]=="use"or gb[2]=="give"then
if gd then
else return end end ge=true selected_actor.cr=cocreate(function() if not gc.owner
or gd then hk=gd or gc hl=get_use_pos(hk) walk_to(selected_actor,hl.x,hl.y) if selected_actor.fs!=2 then return end
use_dir=hk if hk.use_dir then use_dir=hk.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(gb,gc) then
start_script(gc.verbs[gb[1]],false,gc,gd) else cc(gb[2],gc,gd) end eb() end) coresume(selected_actor.cr) elseif fu>dh and fu<dh+64 then ge=true selected_actor.cr=cocreate(function() walk_to(selected_actor,ft,fu-dh) eb() end) coresume(selected_actor.cr) end end function gm() hf,hh,hg,he,hi=nil,nil,nil,nil,nil if cw
and cw.cy then for ek in all(cw.cx) do if hm(ek) then
he=ek end end return end hn() for ef,by in pairs(room_curr.objects) do if(not by.class
or(by.class and by.class!=class_untouchable)) and(not by.dependent_on or find_object(by.dependent_on).state==by.dependent_on_state) then ho(by,by.w*8,by.h*8,ch,hp) else by.hq=nil end if hm(by) then
if not hg
or(not by.z and hg.z<0) or(by.z and hg.z and by.z>hg.z) then hg=by end end hr(by) end for ef,cl in pairs(actors) do if cl.in_room==room_curr then
ho(cl,cl.w*8,cl.h*8,ch,hp) hr(cl) if hm(cl)
and cl!=selected_actor then hg=cl end end end if selected_actor then
for ca in all(verbs) do if hm(ca) then
hf=ca end end for hs in all(fy) do if hm(hs) then
hi=hs end end for ef,by in pairs(selected_actor.ee) do if hm(by) then
hg=by if gb[2]=="pickup"and hg.owner then
gb=nil end end if by.owner!=selected_actor then
del(selected_actor.ee,by) end end if gb==nil then
gb=get_verb(verb_default) end if hg then
hh=bx(hg) end end end function hn() gg={} for x=-64,64 do gg[x]={} end end function hr(by) eq=-1 if by.ht then
eq=by.y else eq=by.y+(by.h*8) end hu=flr(eq-dh) if by.z then hu=by.z end
add(gg[hu],by) end function gp() rectfill(0,dh,127,dh+64,room_curr.r or 0) for z=-64,64 do if z==0 then
hv(room_curr) map(room_curr.map_x,room_curr.map_y,0,dh,room_curr.hw,room_curr.hx) pal() else hu=gg[z] for by in all(hu) do if not has_flag(by.class,class_actor) then
if by.states
and by.states[by.state] and by.states[by.state]>0 and(not by.dependent_on or find_object(by.dependent_on).state==by.dependent_on_state) and not by.owner then hy(by) end else if by.in_room==room_curr then
hz(by) end end ia(by) end end end end function hv(by) for ib in all(by.col_replace) do pal(ib[1],ib[2]) end if by.lighting then
ic(by.lighting) elseif by.in_room then ic(by.in_room.lighting) end end function hy(by) hv(by) id=1 if by.repeat_x then id=by.repeat_x end
for h=0,id-1 do ie(by.states[by.state],by.x+(h*(by.w*8)),by.y,by.w,by.h,by.trans_col,by.flip_x) end pal() end function hz(cl) if cl.fs==1
and cl.walk_anim then cl.ig+=1 if cl.ig>5 then
cl.ig=1 cl.ih+=1 if cl.ih>#cl.walk_anim then cl.ih=1 end
end ii=cl.walk_anim[cl.ih] else ii=cl.idle[cl.face_dir] end hv(cl) ie(ii,cl.di,cl.ht,cl.w,cl.h,cl.trans_col,cl.flip,false) if er
and er==cl then if cl.ij<7 then
ii=cl.talk[cl.face_dir] ie(ii,cl.di,cl.ht+8,1,1,cl.trans_col,cl.flip,false) end cl.ij+=1 if cl.ij>14 then cl.ij=1 end
end pal() end function gu() ik=""il=12 if not ge then
if gb then
ik=gb[3] end if gc then
ik=ik.." "..gc.name if gb[2]=="use"then
ik=ik.." with"elseif gb[2]=="give"then ik=ik.." to"end end if gd then
ik=ik.." "..gd.name elseif hg and hg.name!=""and(not gc or(gc!=hg)) then ik=ik.." "..hg.name end gf=ik else ik=gf il=7 end print(im(ik),io(ik),dh+66,il) end function gq() if en then
ip=0 for iq in all(en.ez) do ir=0 if en.es==1 then
ir=((en.de*4)-(#iq*4))/2 end is(iq,en.x+ir,en.y+ip,en.col,0,en.eo) ip+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gv() ey,eq,it=0,75,0 for ca in all(verbs) do iu=verb_maincol if hh
and ca==hh then iu=verb_defcol end if ca==hf then iu=verb_hovcol end
cb=get_verb(ca) print(cb[3],ey,eq+dh+1,verb_shadcol) print(cb[3],ey,eq+dh,iu) ca.x=ey ca.y=eq ho(ca,#cb[3]*4,5,0,0) ia(ca) if#cb[3]>it then it=#cb[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(it+1.0)*4 it=0 end end if selected_actor then
ey,eq=86,76 iv=selected_actor.hj*4 iw=min(iv+8,#selected_actor.ee) for ix=1,8 do rectfill(ey-1,dh+eq-1,ey+8,dh+eq+8,1) by=selected_actor.ee[iv+ix] if by then
by.x,by.y=ey,eq hy(by) ho(by,by.w*8,by.h*8,0,0) ia(by) end ey+=11 if ey>=125 then
eq+=12 ey=86 end ix+=1 end for ew=1,2 do iy=fy[ew] if hi==iy then pal(verb_maincol,7) end
ie(iy.spr,iy.x,iy.y,1,1,0) ho(iy,8,7,0,0) ia(iy) pal() end end end function gr() ey,eq=0,70 for ek in all(cw.cx) do ek.x,ek.y=ey,eq ho(ek,ek.de*4,#ek.cz*5,0,0) iu=cw.col if ek==he then iu=cw.df end
for iq in all(ek.cz) do print(im(iq),ey,eq+dh,iu) eq+=5 end ia(ek) eq+=2 end end function gs() col=fx[fw] pal(7,col) spr(32,ft-4,fu-3,1,1,0) pal() fv+=1 if fv>7 then
fv=1 fw+=1 if fw>#fx then fw=1 end
end end function ie(iz,x,y,w,h,ja,flip_x,jb) palt(0,false) palt(ja,true) spr(iz,x,dh+y,w,h,flip_x,jb) palt(ja,false) palt(0,true) end function gh() for jc,fc in pairs(rooms) do if fc.map_x1 then
fc.hw=fc.map_x1-fc.map_x+1 fc.hx=fc.map_y1-fc.map_y+1 else fc.hw=16 fc.hx=8 end for jd,by in pairs(fc.objects) do by.in_room=fc end end for je,cl in pairs(actors) do cl.fs=2 cl.ig=1 cl.ij=1 cl.ih=1 cl.ee={} cl.hj=0 end end function ia(by) local jf=by.hq if show_collision
and jf then rect(jf.x,jf.y,jf.jg,jf.jh,8) end end function gk(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ic(ji) if ji then ji=1-ji end
local fm=flr(mid(0,ji,1)*100) local jj={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jk=1,15 do col=jk jl=(fm+(jk*1.46))/22 for ef=1,jl do col=jj[col] end pal(jk,col) end end function ci(cg) if type(cg)=="table"then
cg=cg.x end return mid(0,cg-64,(room_curr.hw*8)-128) end function fe(by) local ff=flr(by.x/8)+room_curr.map_x local fg=flr(by.y/8)+room_curr.map_y return{ff,fg} end function fl(ff,fg) local jm=mget(ff,fg) local jn=fget(jm,0) return jn end function da(msg,eu) local cz={} local jo=""local jp=""local ex=""local jq=function(jr) if#jp+#jo>jr then
add(cz,jo) jo=""end jo=jo..jp jp=""end for ew=1,#msg do ex=sub(msg,ew,ew) jp=jp..ex if ex==" "
or#jp>eu-1 then jq(eu) elseif#jp>eu-1 then jp=jp.."-"jq(eu) elseif ex==";"then jo=jo..sub(jp,1,#jp-1) jp=""jq(0) end end jq(eu) if jo!=""then
add(cz,jo) end return cz end function dc(cz) db=0 for iq in all(cz) do if#iq>db then db=#iq end
end return db end function has_flag(by,js) if band(by,js)!=0 then return true end
return false end function ho(by,w,h,jt,ju) x=by.x y=by.y if has_flag(by.class,class_actor) then
by.di=x-(by.w*8)/2 by.ht=y-(by.h*8)+1 x=by.di y=by.ht end by.hq={x=x,y=y+dh,jg=x+w-1,jh=y+h+dh-1,jt=jt,ju=ju} end function fj(jv,jw) local jx,jy,jz={},{},{} ka(jx,jv,0) jy[kb(jv)]=nil jz[kb(jv)]=0 while#jx>0 and#jx<1000 do local bb=jx[#jx] del(jx,jx[#jx]) kc=bb[1] if kb(kc)==kb(jw) then
break end local kd={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local ke=kc[1]+x local kf=kc[2]+y if abs(x)!=abs(y) then kg=1 else kg=1.4 end
if ke>=room_curr.map_x and ke<=room_curr.map_x+room_curr.hw
and kf>=room_curr.map_y and kf<=room_curr.map_y+room_curr.hx and fl(ke,kf) and((abs(x)!=abs(y)) or fl(ke,kc[2]) or fl(ke-x,kf)) then add(kd,{ke,kf,kg}) end end end end for kh in all(kd) do local ki=kb(kh) local kj=jz[kb(kc)]+kh[3] if jz[ki]==nil
or kj<jz[ki] then jz[ki]=kj local kk=kj+max(abs(jw[1]-kh[1]),abs(jw[2]-kh[2])) ka(jx,kh,kk) jy[ki]=kc end end end local fi={} kc=jy[kb(jw)] if kc then
local kl=kb(kc) local km=kb(jv) while kl!=km do add(fi,kc) kc=jy[kl] kl=kb(kc) end for ew=1,#fi/2 do local kn=fi[ew] local ko=#fi-(ew-1) fi[ew]=fi[ko] fi[ko]=kn end end return fi end function ka(kp,cg,fm) if#kp>=1 then
add(kp,{}) for ew=(#kp),2,-1 do local kh=kp[ew-1] if fm<kh[2] then
kp[ew]={cg,fm} return else kp[ew]=kh end end kp[1]={cg,fm} else add(kp,{cg,fm}) end end function kb(kq) return((kq[1]+1)*16)+kq[2] end function is(kr,x,y,ks,kt,eo) if not eo then kr=im(kr) end
for ku=-1,1 do for kv=-1,1 do print(kr,x+ku,y+kv,kt) end end print(kr,x,y,ks) end function io(ek) return 63.5-flr((#ek*4)/2) end function kw(ek) return 61 end function hm(by) if not by.hq then return false end
hq=by.hq if(ft+hq.jt>hq.jg or ft+hq.jt<hq.x)
or(fu>hq.jh or fu<hq.y) then return false else return true end end function im(ek) local a=""local iq,ib,kp=false,false for ew=1,#ek do local hs=sub(ek,ew,ew) if hs=="^"then
if ib then a=a..hs end
ib=not ib elseif hs=="~"then if kp then a=a..hs end
kp,iq=not kp,not iq else if ib==iq and hs>="a"and hs<="z"then
for jk=1,26 do if hs==sub("abcdefghijklmnopqrstuvwxyz",jk,jk) then
hs=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jk,jk) break end end end a=a..hs ib,kp=false,false end end return a end










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

