pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
-- scumm-8 game template
-- paul nicholas

-- 7004 tokens (5206 is engine!) - leaving 1188 tokens spare
-- now 6979 tokens (1213 spare)
-- now 6758 tokens (after "packing" - 1434 spare)
-- now 6723 tokens (after packing Actors)
-- now 6860 tokens (after adding library)
-- now 6906 tokens (after adding "use" object/actor & fix shake crop)


-- debugging
show_debuginfo = false
show_collision = false
--show_pathfinding = true
show_perfinfo = false
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



-- 
-- object definitions (new way!)
-- 

	obj_fire = {		
		-- poss diff types (s_data, n_data, arr_data)?
		data = [[
			name=fire
			x=88
			y=32
			w=1
			h=1
			state=1
			states={81,82,83}
			lighting = 1
		]],
		dependent_on = obj_front_door_inside,
		dependent_on_state = state_open,
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
			end
		}
	}

	obj_front_door_inside = {		
		data = [[
			name = front door
			state = 1
			x=8
			y=16
			z=1
			w=1
			h=4
			states={79,0}
		]],
		class = class_openable,
		use_pos = pos_right,
		use_dir = face_left,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_front_door)
			end,
			open = function(me)
				open_door(me, obj_front_door)
			end,
			close = function(me)
				close_door(me, obj_front_door)
			end
		}
	}

	obj_hall_door_kitchen = {		
		data = [[
			name = kitchen
			state = 2
			x=112
			y=16
			w=1
			h=4
		]],
		use_pos = pos_left,
		use_dir = face_right,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_kitchen_door_hall)
			end
		}
	}

	obj_bucket = {		
		data = [[
			name = bucket
			state = 2
			x=104
			y=48
			w=1
			h=1
			states={143,159}
			trans_col=15
			use_with=true
		]],
		class = class_pickupable,
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
				if noun2 == purp_tentacle then
					say_line("can you fill this up for me?")
					say_line(purp_tentacle, "sure")
					me.owner = purp_tentacle
					say_line(purp_tentacle, "here ya go...")
					me.state = state_closed
					me.name = "full bucket"
					pickup_obj(me)
				else
					say_line("i might need this")
				end
			end,
			use = function(me, noun2)
				if (noun2 == obj_window) then
					obj_window.state = state_open
				end
			end
		}
	}

	obj_spinning_top = {		
		data = [[
			name=spinning top
			state=1
			x=16
			y=48
			w=1
			h=1
			states={158,174,190}
			col_replace={12,7}
			trans_col=15
		]],
		verbs = {
			use = function(me)
				if script_running(room_curr.scripts.spin_top) then
					stop_script(room_curr.scripts.spin_top)
					me.state = 1
				else
					start_script(room_curr.scripts.spin_top)
				end
			end
		}
	}

	obj_window = {		
		data = [[
			name=window
			state=1
			x=32
			y=8
			w=2
			h=2
			states={68,70}
			use_pos={40,57}
		]],
		class = class_openable,
		verbs = {
			open = function(me)
				if not me.done_cutscene then
					cutscene(cut_noverbs, 
						function()
							me.done_cutscene = true
							-- cutscene code
							me.state = state_open
							me.z = -2
							print_line("*bang*",40,20,8,1)
							change_room(second_room, 1)
							selected_actor = purp_tentacle
							walk_to(selected_actor, 
								selected_actor.x+10, 
								selected_actor.y)
							say_line("what was that?!")
							say_line("i'd better check...")
							walk_to(selected_actor, 
								selected_actor.x-10, 
								selected_actor.y)
							change_room(first_room, 1)
							-- wait for a bit, then appear in room1
							break_time(50)
							put_actor_at(selected_actor, 115, 44, first_room)
							walk_to(selected_actor, 
								selected_actor.x-10, 
								selected_actor.y)
							say_line("intruder!!!")
							do_anim(main_actor, anim_face, purp_tentacle)
						end,
						-- override for cutscene
						function()
							--if cutscene_curr.skipped then
							--d("override!")
							change_room(first_room)
							put_actor_at(purp_tentacle, 105, 44, first_room)
							stop_talking()
							do_anim(main_actor, anim_face, purp_tentacle)
						end
					)
				end
				-- (code here will not run, as room change nuked "local" scripts)
			end
		}
	}



-- 

	obj_kitchen_door_hall = {		
		data = [[
			name = hall
			state=2
			x=8
			y=16
			w=1
			h=4
		]],
		use_pos = pos_right,
		use_dir = face_left,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_hall_door_kitchen)
			end
		}
	}

	obj_back_door = {		
		data = [[
			name=back door
			state=1
			x=176
			y=16
			z=1
			w=1
			h=4
			states={79,0}
			flip_x=true
		]],
		class = class_openable,
		use_pos = pos_left,
		use_dir = face_right,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_garden_door_kitchen)
			end,
			open = function(me)
				open_door(me, obj_garden_door_kitchen)
			end,
			close = function(me)
				close_door(me, obj_garden_door_kitchen)
			end
		}
	}

-- ----

	obj_rail_left = {		
		data = [[
			state=1
			x=80
			y=24
			w=1
			h=2
			states={47}
			repeat_x = 8
		]],
		class = class_untouchable
	}

	obj_rail_right = {		
		data = [[
			state=1
			x=176
			y=24
			w=1
			h=2
			states={47}
			repeat_x = 8
		]],
		class = class_untouchable
	}

	obj_front_door = {		
		data = [[
			name = front door
			state=1
			x=152
			y=8
			w=1
			h=3
			states={78,0}
			flip_x = true
		]],
		class = class_openable,
		use_dir = face_back,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_front_door_inside)
			end,
			open = function(me)
				open_door(me, obj_front_door_inside)
			end,
			close = function(me)
				close_door(me, obj_front_door_inside)
			end
		}
	}

	obj_garden_door_kitchen = {		
		data = [[
			name=kitchen
			state=1
			x=104
			y=8
			w=1
			h=3
			states={78,0}
		]],
		use_dir = face_back,
		class = class_openable,
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_back_door)
			end,
			open = function(me)
				open_door(me, obj_back_door)
			end,
			close = function(me)
				close_door(me, obj_back_door)
			end
		}
	}

	obj_library_secret_panel = {		
		data = [[
			state=1
			x=120
			y=16
			z=-1
			w=1
			h=3
			states={80,80}
		]],
		class = class_untouchable,
		use_dir = face_back,
		verbs = {
		}
	}

	obj_library_door_secret = {		
		data = [[
			name=secret passage
			state=1
			x=120
			y=16
			z=-10
			w=1
			h=3
			states={77}
		]],
		dependent_on = obj_library_secret_panel,
		dependent_on_state = 2,
		use_dir = face_back,
		verbs = {
			walkto = function(me)
				change_room(title_room, 1)
			end
		}
	}

	obj_book = {		
		data = [[
			name=loose book
			state=1
			x=140
			y=16
			w=1
			h=1
			use_pos={140,60}
		]],
		class = class_pickupable,
		verbs = {
			lookat = function(me)
				say_line("this book sticks out")
			end,
			pull = function(me)
				if obj_library_secret_panel.state != 2 then
					obj_library_secret_panel.state=2
					shake(true)
					while (obj_library_secret_panel.y > -8) do
						obj_library_secret_panel.y -= 1
						break_time(10)
					end
					shake(false)
				end
			end,
		}
	}

	obj_duck = {		
		data = [[
			name=rubber duck
			state=1
			states={142}
			trans_col=12
			x=1
			y=1
			w=1
			h=1
		]],
		class = class_pickupable,
		verbs = {
			pickup = function(me)
				pickup_obj(me)
			end,
		}
	}


-- 
-- room definitions
-- 

	title_room = {
		data = [[
			map = {0,8}
		]],
		objects = {
		},
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

		--[[					change_room(first_room, 1)
							shake(true)
							start_script(first_room.scripts.spin_top,false,true)
							print_line("cozy fireplaces...",90,20,8,1)
							print_line("(just look at it!)",90,20,8,1)
							shake(false)]]

							-- part 2
							change_room(second_room, 1)
							print_line("strange looking aliens...",30,20,8,1,false,true)
							put_actor_at(purp_tentacle, 130, purp_tentacle.y, second_room)
							walk_to(purp_tentacle, 
								purp_tentacle.x-30, 
								purp_tentacle.y)
							wait_for_actor(purp_tentacle)
							say_line(purp_tentacle, "what did you call me?!")

							-- part 3
							change_room(back_garden, 1)
							print_line("and even swimming pools!",90,20,8,1,false,true)
							camera_at(200)
							camera_pan_to(0)
							wait_for_camera()
							print_line("quack!",45,60,10,1)

							-- part 4
							change_room(outside_room, 1)
							
--[[
							-- outro
							--break_time(25)
							change_room(title_room, 1)
						

							fades(1,1)	-- fade out
							break_time(100)]]
							
						end) -- end cutscene

				end -- if not done intro
		end,
		exit = function()
			-- todo: anything here?
		end,
	}


	outside_room = {
		data = [[
			map = {0,24,31,31}
		]],
		objects = {
			obj_rail_left,
			obj_rail_right,
			obj_front_door
		},
		enter = function(me)
			-- 
			-- initialise game in first room entry...
			-- 
			if not me.done_intro then
				-- don't do this again
				me.done_intro = true
				-- set which actor the player controls by default
				selected_actor = main_actor
				-- init actor
				put_actor_at(selected_actor, 144, 36, outside_room)
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
	}


	first_room = {
		data = [[
			map = {0,0}
			lighting = 1
		]],
		objects = {
			obj_front_door_inside,
			obj_hall_door_kitchen,
			obj_bucket,
			obj_spinning_top,
			obj_window,
			--obj_ztest
		},
		enter = function(me)
			
			start_script(me.scripts.tentacle_guard, true) -- bg script
		end,
		exit = function(me)
			
			stop_script(me.scripts.tentacle_guard)
		end,
		scripts = {	  -- scripts that are at room-level
			spin_top = function()
				dir=-1				
				while true do	
					for x=1,3 do					
						for f=1,3 do
							obj_spinning_top.state = f
							break_time(4)
						end
						-- move top
						--top = find_object("spinning top")
						obj_spinning_top.x -= dir					
					end	
					dir *= -1
				end				
			end,
			tentacle_guard = function()
				while true do
					--d("tentacle guarding...")
					if proximity(main_actor, purp_tentacle) < 30 then
						say_line(purp_tentacle, "halt!!!", true)
					end
					break_time(10)
				end
			end
		},
	}

	second_room = {
		data = [[
			map = {16,0,39,7}
		]],
		objects = {
			obj_kitchen_door_hall,
			obj_back_door
		},
		enter = function()
				-- todo: anything here?
		end,
		exit = function()
			-- todo: anything here?
		end,
	}

	back_garden = {
		data = [[
			map = {40,0,63,7}
		]],
		objects = {
			obj_garden_door_kitchen
		},
		enter = function()
				-- todo: anything here?
		end,
		exit = function()
			-- todo: anything here?
		end,
	}

	rm_library = {
		data = [[
			map = {16,8,39,15}
			trans_col = 10
			col_replace={7,4}
		]],
		objects = {
			obj_fire,
			obj_library_door_secret,
			obj_library_secret_panel,
			obj_duck,
			obj_book
		},
		enter = function(me)
			-- animate fireplace
			start_script(me.scripts.anim_fire, true) -- bg script
			d("z:"..obj_library_secret_panel.z)
			d("type:"..type(obj_library_secret_panel.z))
		end,
		exit = function(me)
			-- pause fireplace while not in room
			stop_script(me.scripts.anim_fire)
		end,
		scripts = {
			anim_fire = function()
				while true do
					for f=1,3 do
						obj_fire.state = f
						break_time(8)
					end
				end
			end
		}
	}
	



rooms = {
	title_room,
	outside_room,
	first_room,
	second_room,
	back_garden,
	rm_library
}




-- ================================================================
-- actor definitions
-- 

	-- initialize the player's actor object
	main_actor = { 	
		data = [[
			name = humanoid
			w = 1
			h = 4
			idle = { 193, 197, 199, 197 }
			talk = { 218, 219, 220, 219 }
			walk_anim_side = { 196, 197, 198, 197 }
			walk_anim_front = { 194, 193, 195, 193 }
			walk_anim_back = { 200, 199, 201, 199 }
			col = 12
			trans_col = 11
			speed = 0.6
		]],	
		--name = "",
		class = class_actor,
		face_dir = face_front, 	-- default direction facing
		-- sprites for idle (front, left, back, right) - right=flip
		verbs = {
			use = function(me)
				selected_actor = me
				camera_follow(me)
			end
		}
	}

	purp_tentacle = {
		data = [[
			name = purple tentacle
			x = 40
			y = 48
			w = 1
			h = 3
			idle = { 154, 154, 154, 154 }
			talk = { 171, 171, 171, 171 }
			col = 11
			trans_col = 15
			speed = 0.25
		]],
		class = class_talkable + class_actor,
		face_dir = face_front,
		use_pos = pos_left,
		--in_room = rooms.first_room,
		in_room = second_room,
		verbs = {
				lookat = function()
					say_line("it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(cut_noverbs, function()
						--do_anim(purp_tentacle, anim_face, selected_actor)
						say_line(me,"what do you want?")
					end)

					-- dialog loop start
					while (true) do
						-- build dialog options
						dialog_set({ 
							(me.asked_where and "" or "where am i?"),
							"who are you?",
							"how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?",
							"nevermind"
						})
						dialog_start(selected_actor.col, 7)

						-- wait for selection
						while not selected_sentence do break_time() end
						-- chosen options
						dialog_hide()

						cutscene(cut_noverbs, function()
							say_line(selected_sentence.msg)
							
							if selected_sentence.num == 1 then
								say_line(me, "you are in paul's game")
								me.asked_where = true

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
				end, -- talkto
				use = function(me)
					selected_actor = me
					camera_follow(me)
				end
			}
	}

actors = {
	main_actor,
	purp_tentacle
}

-- 
-- script overloads
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)

	--change_room(rm_library, 1) -- iris fade
	change_room(title_room, 1) -- iris fade
end


-- (end of customisable game content)




















-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)





function shake(by) if by then
bz=1 end ca=by end function cb(cc) local cd=nil if has_flag(cc.class,class_talkable) then
cd="talkto"elseif has_flag(cc.class,class_openable) then if cc.state==state_closed then
cd="open"else cd="close"end else cd="lookat"end for ce in all(verbs) do cf=get_verb(ce) if cf[2]==cd then cd=ce break end
end return cd end function cg(ch,ci,cj) if ch=="walkto"then
return elseif ch=="pickup"then if has_flag(ci.class,class_actor) then
say_line"i don't need them"else say_line"i don't need that"end elseif ch=="use"then if has_flag(ci.class,class_actor) then
say_line"i can't just *use* someone"end if cj then
if has_flag(cj.class,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif ch=="give"then if has_flag(ci.class,class_actor) then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif ch=="lookat"then if has_flag(ci.class,class_actor) then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif ch=="open"then if has_flag(ci.class,class_actor) then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif ch=="close"then if has_flag(ci.class,class_actor) then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif ch=="push"or ch=="pull"then if has_flag(ci.class,class_actor) then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif ch=="talkto"then if has_flag(ci.class,class_actor) then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(ck) cl=cm(ck) cn=nil co=nil end function camera_follow(cp) stop_script(cq) co=cp cn=nil cq=function() while co do if co.in_room==room_curr then
cl=cm(co) end yield() end end start_script(cq,true) end function camera_pan_to(ck) cn=cm(ck) co=nil cq=function() while(true) do if cl==cn then
cn=nil return elseif cn>cl then cl+=0.5 else cl-=0.5 end yield() end end start_script(cq,true) end function wait_for_camera() while script_running(cq) do yield() end end function cutscene(cr,cs,ct) cu={cr=cr,cv=cocreate(cs),cw=ct,cx=co} add(cy,cu) cz=cu break_time() end function dialog_set(da) for msg in all(da) do dialog_add(msg) end end function dialog_add(msg) if not db then db={dc={},dd=false} end
de=df(msg,32) dg=dh(de) di={num=#db.dc+1,msg=msg,de=de,dj=dg} add(db.dc,di) end function dialog_start(col,dk) db.col=col db.dk=dk db.dd=true selected_sentence=nil end function dialog_hide() db.dd=false end function dialog_clear() db.dc={} selected_sentence=nil end function dialog_end() db=nil end function get_use_pos(cc) dl=cc.use_pos if type(dl)=="table"then
x=dl[1]-cl y=dl[2]-dm elseif not dl or dl==pos_infront then x=cc.x+((cc.w*8)/2)-cl-4 y=cc.y+(cc.h*8)+2 elseif dl==pos_left then if cc.dn then
x=cc.x-cl-(cc.w*8+4) y=cc.y+1 else x=cc.x-cl-2 y=cc.y+((cc.h*8)-2) end elseif dl==pos_right then x=cc.x+(cc.w*8)-cl y=cc.y+((cc.h*8)-2) end return{x=x,y=y} end function do_anim(cp,dp,dq) if dp==anim_face then
if type(dq)=="table"then
dr=atan2(cp.x-dq.x,dq.y-cp.y) ds=93*(3.1415/180) dr=ds-dr dt=dr*360 dt=dt%360 if dt<0 then dt+=360 end
dq=4-flr(dt/90) end while cp.face_dir!=dq do if cp.face_dir<dq then
cp.face_dir+=1 else cp.face_dir-=1 end cp.flip=(cp.face_dir==face_left) break_time(10) end end end function open_door(du,dv) if du.state==state_open then
say_line"it's already open"else du.state=state_open if dv then dv.state=state_open end
end end function close_door(du,dv) if du.state==state_closed then
say_line"it's already closed"else du.state=state_closed if dv then dv.state=state_closed end
end end function come_out_door(dw,dx,dy) if dw.state==state_open then
dz=dx.in_room change_room(dz,dy) local ea=get_use_pos(dx) put_actor_at(selected_actor,ea.x,ea.y,dz) if dx.use_dir then
eb=dx.use_dir+2 if eb>4 then
eb-=4 end else eb=1 end selected_actor.face_dir=eb if selected_actor.face_dir==2 then
selected_actor.flip=true end else say_line("the door is closed") end end function fades(ec,bs) if bs==1 then
ed=0 else ed=50 end while true do ed+=bs*2 if ed>50
or ed<0 then return end if ec==1 then
ee=min(ed,32) end yield() end end function change_room(dz,ec) stop_script(ef) if ec and room_curr then
fades(ec,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end eg={} eh() room_curr=dz if not co
or co.in_room!=room_curr then cl=0 end stop_talking() if ec then
ef=function() fades(ec,-1) end start_script(ef,true) else ee=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(ch,ei) if not ei
or not ei.verbs then return false end if type(ch)=="table"then
if ei.verbs[ch[1]] then return true end
else if ei.verbs[ch] then return true end
end return false end function pickup_obj(cc) add(selected_actor.ej,cc) cc.owner=selected_actor del(cc.in_room.objects,cc) end function start_script(ek,el,em,t) local cv=cocreate(ek) local scripts=eg if el then
scripts=en end add(scripts,{ek,cv,em,t}) end function script_running(ek) for eo in all({eg,en}) do for ep,eq in pairs(eo) do if eq[1]==ek then
return eq end end end return false end function stop_script(ek) eq=script_running(ek) if eq then
del(eg,eq) del(en,eq) end end function break_time(er) er=er or 1 for x=1,er do yield() end end function wait_for_message() while es!=nil do yield() end end function say_line(cp,msg,et,eu) if type(cp)=="string"then
msg=cp cp=selected_actor end ev=cp.y-(cp.h)*8+4 ew=cp print_line(msg,cp.x,ev,cp.col,1,et,eu) end function stop_talking() es,ew=nil,nil end function print_line(msg,x,y,col,ex,et,eu) local col=col or 7 local ex=ex or 0 local ey=min(x-cl,127-(x-cl)) local ez=max(flr(ey/2),16) local fa=""for fb=1,#msg do local fc=sub(msg,fb,fb) if fc==":"then
fa=sub(msg,fb+1) msg=sub(msg,1,fb-1) break end end local de=df(msg,ez) local dg=dh(de) if ex==1 then
fd=x-cl-((dg*4)/2) end fd=max(2,fd) ev=max(18,y) fd=min(fd,127-(dg*4)-1) es={fe=de,x=fd,y=ev,col=col,ex=ex,ff=(#msg)*8,dj=dg,et=et} if#fa>0 then
fg=ew wait_for_message() ew=fg print_line(fa,x,y,col,ex,et) end if not eu then
wait_for_message() end end function put_actor_at(cp,x,y,fh) if fh then cp.in_room=fh end
cp.x,cp.y=x,y end function walk_to(cp,x,y) x+=cl local fi=fj(cp) local fk=flr(x/8)+room_curr.map[1] local fl=flr(y/8)+room_curr.map[2] local fm={fk,fl} local fn=fo(fi,fm) local fp=fj({x=x,y=y}) if fq(fp[1],fp[2]) then
add(fn,fp) end for fr in all(fn) do local fs=(fr[1]-room_curr.map[1])*8+4 local ft=(fr[2]-room_curr.map[2])*8+4 local fu=sqrt((fs-cp.x)^2+(ft-cp.y)^2) local fv=cp.speed*(fs-cp.x)/fu local fw=cp.speed*(ft-cp.y)/fu if fu>5 then
cp.fx=1 cp.flip=(fv<0) if abs(fv)<0.4 then
if fw>0 then
cp.fy=cp.walk_anim_front cp.face_dir=face_front else cp.fy=cp.walk_anim_back cp.face_dir=face_back end else cp.fy=cp.walk_anim_side cp.face_dir=face_right if cp.flip then cp.face_dir=face_left end
end for fb=0,fu/cp.speed do cp.x+=fv cp.y+=fw yield() end end end cp.fx=2 end function wait_for_actor(cp) cp=cp or selected_actor while cp.fx!=2 do yield() end end function proximity(ci,cj) if ci.in_room==cj.in_room then
local fu=sqrt((ci.x-cj.x)^2+(ci.y-cj.y)^2) return fu else return 1000 end end dm=16 cl,cn,cq,bz=0,nil,nil,0 fz,ga,gb,gc=63.5,63.5,0,1 gd={7,12,13,13,12,7} ge={{spr=208,x=75,y=dm+60},{spr=240,x=75,y=dm+72}} function gf(cc) local gg={} for ep,ce in pairs(cc) do add(gg,ep) end return gg end function get_verb(cc) local ch={} local gg=gf(cc[1]) add(ch,gg[1]) add(ch,cc[1][gg[1]]) add(ch,cc.text) return ch end function eh() gh=get_verb(verb_default) gi,gj,o,gk,gl=nil,nil,nil,false,""end eh() es=nil db=nil cz=nil ew=nil en={} eg={} cy={} gm={} ee,ee=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gn() start_script(startup_script,true) end function _update60() go() end function _draw() gp() end function go() if selected_actor and selected_actor.cv
and not coresume(selected_actor.cv) then selected_actor.cv=nil end gq(en) if cz then
if cz.cv
and not coresume(cz.cv) then if not has_flag(cz.cr,cut_no_follow)
and cz.cx then camera_follow(cz.cx) selected_actor=cz.cx end del(cy,cz) cz=nil if#cy>0 then
cz=cy[#cy] end end else gq(eg) end gr() gs() gt,gu=1.5-rnd(3),1.5-rnd(3) gt=flr(gt*bz) gu=flr(gu*bz) if not ca then
bz*=0.90 if bz<0.05 then bz=0 end
end end function gp() rectfill(0,0,127,127,0) camera(cl+gt,0+gu) clip(0+ee-gt,dm+ee-gu,128-ee*2-gt,64-ee*2) gv() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dm-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dm-8,8) end if show_debuginfo then
print("x: "..fz.." y:"..ga-dm,80,dm-8,8) end gw() if db
and db.dd then gx() gy() return end if gz==cz then
else gz=cz return end if not cz then
ha() end if(not cz
or not has_flag(cz.cr,cut_noverbs)) and(gz==cz) then hb() else end gz=cz if not cz then
gy() end end function gr() if cz then
if btnp(4) and btnp(5) and cz.cw then
cz.cv=cocreate(cz.cw) cz.cw=nil return end return end if btn(0) then fz-=1 end
if btn(1) then fz+=1 end
if btn(2) then ga-=1 end
if btn(3) then ga+=1 end
if btnp(4) then hc(1) end
if btnp(5) then hc(2) end
if enable_mouse then
hd,he=stat(32)-1,stat(33)-1 if hd!=hf then fz=hd end
if he!=hg then ga=he end
if stat(34)>0 then
if not hh then
hc(stat(34)) hh=true end else hh=false end hf=hd hg=he end fz=mid(0,fz,127) ga=mid(0,ga,127) end function hc(hi) local hj=gh if not selected_actor then
return end if db and db.dd then
if hk then
selected_sentence=hk end return end if hl then
gh=get_verb(hl) elseif hm then if hi==1 then
if(gh[2]=="use"or gh[2]=="give")
and gi then gj=hm else gi=hm end elseif hn then gh=get_verb(hn) gi=hm gf(gi) ha() end elseif ho then if ho==ge[1] then
if selected_actor.hp>0 then
selected_actor.hp-=1 end else if selected_actor.hp+2<flr(#selected_actor.ej/4) then
selected_actor.hp+=1 end end return end if gi!=nil
and not gk then if gh[2]=="use"or gh[2]=="give"then
if gj then
elseif gi.use_with and gi.owner==selected_actor then return end end gk=true selected_actor.cv=cocreate(function() if(not gi.owner
and not has_flag(gi.class,class_actor)) or gj then hq=gj or gi hr=get_use_pos(hq) walk_to(selected_actor,hr.x,hr.y) if selected_actor.fx!=2 then return end
use_dir=hq if hq.use_dir then use_dir=hq.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(gh,gi) then
start_script(gi.verbs[gh[1]],false,gi,gj) else cg(gh[2],gi,gj) end eh() end) coresume(selected_actor.cv) elseif ga>dm and ga<dm+64 then gk=true selected_actor.cv=cocreate(function() walk_to(selected_actor,fz,ga-dm) eh() end) coresume(selected_actor.cv) end end function gs() hl,hn,hm,hk,ho=nil,nil,nil,nil,nil if db
and db.dd then for eo in all(db.dc) do if hs(eo) then
hk=eo end end return end ht() for cc in all(room_curr.objects) do if(not cc.class
or(cc.class and cc.class!=class_untouchable)) and(not cc.dependent_on or cc.dependent_on.state==cc.dependent_on_state) then hu(cc,cc.w*8,cc.h*8,cl,hv) else cc.hw=nil end if hs(cc) then
if not hm
or(not cc.z and hm.z<0) or(cc.z and hm.z and cc.z>hm.z) then hm=cc end end hx(cc) end for ep,cp in pairs(actors) do if cp.in_room==room_curr then
hu(cp,cp.w*8,cp.h*8,cl,hv) hx(cp) if hs(cp)
and cp!=selected_actor then hm=cp end end end if selected_actor then
for ce in all(verbs) do if hs(ce) then
hl=ce end end for hy in all(ge) do if hs(hy) then
ho=hy end end for ep,cc in pairs(selected_actor.ej) do if hs(cc) then
hm=cc if gh[2]=="pickup"and hm.owner then
gh=nil end end if cc.owner!=selected_actor then
del(selected_actor.ej,cc) end end if gh==nil then
gh=get_verb(verb_default) end if hm then
hn=cb(hm) end end end function ht() gm={} for x=-64,64 do gm[x]={} end end function hx(cc) ev=-1 if cc.hz then
ev=cc.y else ev=cc.y+(cc.h*8) end ia=flr(ev-dm) if cc.z then
ia=cc.z else end add(gm[ia],cc) end function gv() rectfill(0,dm,127,dm+64,room_curr.ib or 0) for z=-64,64 do if z==0 then
ic(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,dm,room_curr.id,room_curr.ie) pal() else ia=gm[z] for cc in all(ia) do if not has_flag(cc.class,class_actor) then
if cc.states
and cc.states[cc.state] and cc.states[cc.state]>0 and(not cc.dependent_on or cc.dependent_on.state==cc.dependent_on_state) and not cc.owner then ig(cc) end else if cc.in_room==room_curr then
ih(cc) end end ii(cc) end end end end function ic(cc) if cc.col_replace then
ij=cc.col_replace pal(ij[1],ij[2]) end if cc.lighting then
ik(cc.lighting) elseif cc.in_room then ik(cc.in_room.lighting) end end function ig(cc) ic(cc) il=1 if cc.repeat_x then il=cc.repeat_x end
for h=0,il-1 do im(cc.states[cc.state],cc.x+(h*(cc.w*8)),cc.y,cc.w,cc.h,cc.trans_col,cc.flip_x) end pal() end function ih(cp) if cp.fx==1
and cp.fy then cp.io+=1 if cp.io>5 then
cp.io=1 cp.ip+=1 if cp.ip>#cp.fy then cp.ip=1 end
end iq=cp.fy[cp.ip] else iq=cp.idle[cp.face_dir] end ic(cp) im(iq,cp.dn,cp.hz,cp.w,cp.h,cp.trans_col,cp.flip,false) if ew
and ew==cp then if cp.ir<7 then
iq=cp.talk[cp.face_dir] im(iq,cp.dn,cp.hz+8,1,1,cp.trans_col,cp.flip,false) end cp.ir+=1 if cp.ir>14 then cp.ir=1 end
end pal() end function ha() is=""it=12 if not gk then
if gh then
is=gh[3] end if gi then
is=is.." "..gi.name if gh[2]=="use"then
is=is.." with"elseif gh[2]=="give"then is=is.." to"end end if gj then
is=is.." "..gj.name elseif hm and hm.name!=""and(not gi or(gi!=hm)) then is=is.." "..hm.name end gl=is else is=gl it=7 end print(iu(is),iv(is),dm+66,it) end function gw() if es then
iw=0 for ix in all(es.fe) do iy=0 if es.ex==1 then
iy=((es.dj*4)-(#ix*4))/2 end iz(ix,es.x+iy,es.y+iw,es.col,0,es.et) iw+=6 end es.ff-=1 if es.ff<=0 then
stop_talking() end end end function hb() fd,ev,ja=0,75,0 for ce in all(verbs) do jb=verb_maincol if hn
and ce==hn then jb=verb_defcol end if ce==hl then jb=verb_hovcol end
cf=get_verb(ce) print(cf[3],fd,ev+dm+1,verb_shadcol) print(cf[3],fd,ev+dm,jb) ce.x=fd ce.y=ev hu(ce,#cf[3]*4,5,0,0) ii(ce) if#cf[3]>ja then ja=#cf[3] end
ev+=8 if ev>=95 then
ev=75 fd+=(ja+1.0)*4 ja=0 end end if selected_actor then
fd,ev=86,76 jc=selected_actor.hp*4 jd=min(jc+8,#selected_actor.ej) for je=1,8 do rectfill(fd-1,dm+ev-1,fd+8,dm+ev+8,1) cc=selected_actor.ej[jc+je] if cc then
cc.x,cc.y=fd,ev ig(cc) hu(cc,cc.w*8,cc.h*8,0,0) ii(cc) end fd+=11 if fd>=125 then
ev+=12 fd=86 end je+=1 end for fb=1,2 do jf=ge[fb] if ho==jf then pal(verb_maincol,7) end
im(jf.spr,jf.x,jf.y,1,1,0) hu(jf,8,7,0,0) ii(jf) pal() end end end function gx() fd,ev=0,70 for eo in all(db.dc) do if eo.dj>0 then
eo.x,eo.y=fd,ev hu(eo,eo.dj*4,#eo.de*5,0,0) jb=db.col if eo==hk then jb=db.dk end
for ix in all(eo.de) do print(iu(ix),fd,ev+dm,jb) ev+=5 end ii(eo) ev+=2 end end end function gy() col=gd[gc] pal(7,col) spr(224,fz-4,ga-3,1,1,0) pal() gb+=1 if gb>7 then
gb=1 gc+=1 if gc>#gd then gc=1 end
end end function im(jg,x,y,w,h,jh,flip_x,ji) palt(0,false) palt(jh,true) spr(jg,x,dm+y,w,h,flip_x,ji) palt(jh,false) palt(0,true) end function gn() for fh in all(rooms) do jj(fh) if(#fh.map>2) then
fh.id=fh.map[3]-fh.map[1]+1 fh.ie=fh.map[4]-fh.map[2]+1 else fh.id=16 fh.ie=8 end for cc in all(fh.objects) do jj(cc) cc.in_room=fh end end for jk,cp in pairs(actors) do jj(cp) cp.fx=2 cp.io=1 cp.ir=1 cp.ip=1 cp.ej={} cp.hp=0 end end function ii(cc) local jl=cc.hw if show_collision
and jl then rect(jl.x,jl.y,jl.jm,jl.jn,8) end end function gq(scripts) for eq in all(scripts) do if eq[2] and not coresume(eq[2],eq[3],eq[4]) then
del(scripts,eq) eq=nil end end end function ik(jo) if jo then jo=1-jo end
local fr=flr(mid(0,jo,1)*100) local jp={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jq=1,15 do col=jq jr=(fr+(jq*1.46))/22 for ep=1,jr do col=jp[col] end pal(jq,col) end end function cm(ck) if type(ck)=="table"then
ck=ck.x end return mid(0,ck-64,(room_curr.id*8)-128) end function fj(cc) local fk=flr(cc.x/8)+room_curr.map[1] local fl=flr(cc.y/8)+room_curr.map[2] return{fk,fl} end function fq(fk,fl) local js=mget(fk,fl) local jt=fget(js,0) return jt end function df(msg,ez) local de={} local ju=""local jv=""local fc=""local jw=function(jx) if#jv+#ju>jx then
add(de,ju) ju=""end ju=ju..jv jv=""end for fb=1,#msg do fc=sub(msg,fb,fb) jv=jv..fc if fc==" "
or#jv>ez-1 then jw(ez) elseif#jv>ez-1 then jv=jv.."-"jw(ez) elseif fc==";"then ju=ju..sub(jv,1,#jv-1) jv=""jw(0) end end jw(ez) if ju!=""then
add(de,ju) end return de end function dh(de) dg=0 for ix in all(de) do if#ix>dg then dg=#ix end
end return dg end function has_flag(cc,jy) if band(cc,jy)!=0 then return true end
return false end function hu(cc,w,h,jz,ka) x=cc.x y=cc.y if has_flag(cc.class,class_actor) then
cc.dn=x-(cc.w*8)/2 cc.hz=y-(cc.h*8)+1 x=cc.dn y=cc.hz end cc.hw={x=x,y=y+dm,jm=x+w-1,jn=y+h+dm-1,jz=jz,ka=ka} end function fo(kb,kc) local kd,ke,kf={},{},{} kg(kd,kb,0) ke[kh(kb)]=nil kf[kh(kb)]=0 while#kd>0 and#kd<1000 do local ki=kd[#kd] del(kd,kd[#kd]) kj=ki[1] if kh(kj)==kh(kc) then
break end local kk={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kl=kj[1]+x local km=kj[2]+y if abs(x)!=abs(y) then kn=1 else kn=1.4 end
if kl>=room_curr.map[1] and kl<=room_curr.map[1]+room_curr.id
and km>=room_curr.map[2] and km<=room_curr.map[2]+room_curr.ie and fq(kl,km) and((abs(x)!=abs(y)) or fq(kl,kj[2]) or fq(kl-x,km)) then add(kk,{kl,km,kn}) end end end end for ko in all(kk) do local kp=kh(ko) local kq=kf[kh(kj)]+ko[3] if kf[kp]==nil
or kq<kf[kp] then kf[kp]=kq local kr=kq+max(abs(kc[1]-ko[1]),abs(kc[2]-ko[2])) kg(kd,ko,kr) ke[kp]=kj end end end local fn={} kj=ke[kh(kc)] if kj then
local ks=kh(kj) local kt=kh(kb) while ks!=kt do add(fn,kj) kj=ke[ks] ks=kh(kj) end for fb=1,#fn/2 do local ku=fn[fb] local kv=#fn-(fb-1) fn[fb]=fn[kv] fn[kv]=ku end end return fn end function kg(kw,ck,fr) if#kw>=1 then
add(kw,{}) for fb=(#kw),2,-1 do local ko=kw[fb-1] if fr<ko[2] then
kw[fb]={ck,fr} return else kw[fb]=ko end end kw[1]={ck,fr} else add(kw,{ck,fr}) end end function kh(kx) return((kx[1]+1)*16)+kx[2] end function jj(cc) local de=ky(cc.data,"\n") for ix in all(de) do local pairs=ky(ix,"=") if#pairs==2 then
cc[pairs[1]]=kz(pairs[2]) else printh("invalid data line") end end end function ky(eo,la) local lb={} local jc=0 local lc=0 for fb=1,#eo do local ld=sub(eo,fb,fb) if ld==la then
add(lb,sub(eo,jc,lc)) jc=0 lc=0 elseif ld!=" "and ld!="\t"then lc=fb if jc==0 then jc=fb end
end end if jc+lc>0 then
add(lb,sub(eo,jc,lc)) end return lb end function kz(le) local lf=sub(le,1,1) local lb=nil if le=="true"then
lb=true elseif le=="false"then lb=false elseif lg(lf) then if lf=="-"then
lb=sub(le,2,#le)*-1 else lb=le+0 end elseif lf=="{"then local ku=sub(le,2,#le-1) lb=ky(ku,",") lh={} for ck in all(lb) do ck=kz(ck) add(lh,ck) end lb=lh else lb=le end return lb end function lg(ij) for a=1,13 do if ij==sub("0123456789.-+",a,a) then
return true end end end function iz(li,x,y,lj,lk,et) if not et then li=iu(li) end
for ll=-1,1 do for lm=-1,1 do print(li,x+ll,y+lm,lk) end end print(li,x,y,lj) end function iv(eo) return 63.5-flr((#eo*4)/2) end function ln(eo) return 61 end function hs(cc) if not cc.hw then return false end
hw=cc.hw if(fz+hw.jz>hw.jm or fz+hw.jz<hw.x)
or(ga>hw.jn or ga<hw.y) then return false else return true end end function iu(eo) local a=""local ix,ij,kw=false,false for fb=1,#eo do local hy=sub(eo,fb,fb) if hy=="^"then
if ij then a=a..hy end
ij=not ij elseif hy=="~"then if kw then a=a..hy end
kw,ix=not kw,not ix else if ij==ix and hy>="a"and hy<="z"then
for jq=1,26 do if hy==sub("abcdefghijklmnopqrstuvwxyz",jq,jq) then
hy=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jq,jq) break end end end a=a..hy ij,kw=false,false end end return a end










__gfx__
0000000000000000000000000000000000000000000000000000000077777777f9e9f9f9ddd5ddd5bbbbbbbb5500000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000777777779eee9f9fdd5ddd5dbbbbbbbb5555000000000000000000000000000000000000
0080080000000000000000000000000000000000000000000000000077777777feeef9f9d5ddd5ddbbbbbbbb5555550000000000000000000000000000000000
0008800055555555ddddddddeeeeeeee000000000000000000000000777777779fef9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0008800055555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeeddd5ddd5bbbbbbbb5555555500000000000000000000000000000000
0080080055555555ddddddddeeeeeeee000000000000000000000000777777779f9f9eeedd5ddd5dbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeed5ddd5ddbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee000000000000000000000000777777779f9f9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0000000077777755666666ddbbbbbbee333333553333333300000000666666665888858866666666000000000000005500000000000000000000000000045000
00000000777755556666ddddbbbbeeee33333355333333330000000066666666588885881c1c1c1c000000000000555500000000000000000000000000045000
000010007755555566ddddddbbeeeeee3333666633333333000000006666666655555555c1c1c1c1000000000055555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33336666333333330000000066666666888588881c1c1c1c000000005555555500000000000000000000000000045000
001c7c1055555555ddddddddeeeeeeee3355555533333333000000006666666688858888c1c1c1c1000000005555555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33555555333333330000000066666666555555551c1c1c1c000000005555555500000000000000000000000000045000
0000100055555555ddddddddeeeeeeee6666666633333333000000006666666658888588c1c1c1c1000000005555555500000000000000000000000000045000
0000000055555555ddddddddeeeeeeee66666666333333330000000066666666588885887c7c7c7c000000005555555500000000000000000000000000045000
0000000055777777dd666666eebbbbbb553333335555555500000000000000000000000000000000000000000000000000000000000000000000000099999999
0000000055557777dddd6666eeeebbbb553333335555333300000000000000000000000000000000000000000000000000000000000000000000000044444444
0000000055555577dddddd66eeeeeebb666633335533333300000000000000000000000000000000000000000000000000000000000000000000000000045000
000c000055555555ddddddddeeeeeeee666633335333333300000000000000000000000000000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee555555335333333300000000000000000000000000000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee555555335533333300000000000000000000000000000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee666666665555333300000000000000000000000000000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee666666665555555500000000000000000000000000000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddbbbbbbbb555555555555555500000000cccccccc5555555677777777c77777776555555533333336633333330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333555500000000cccccccc555555677777777ccc7777777655555533333367763333330000000000045000
0000000055555555ddddddddbbbbbbbb666666663333335500000000cccccccc55555677777777ccccc777777765555533333677776333330000000000045000
0000000055555555ddddddddbbbbbbbb666666663333333500000000cccccccc5555677777777ccccccc77777776555533336777777633330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333333500000000cccccccc555677777777ccccccccc7777777655533367777777763330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333335500000000cccccccc55677777777ccccccccccc777777765533677777777776330000000000045000
0b03000055555555ddddddddbbbbbbbb666666663333555500000000cccccccc5677777777ccccccccccccc77777776536777777777777630000000099999999
b00030b055555555ddddddddbbbbbbbb666666665555555500000000cccccccc677777777ccccccccccccccc7777777667777777777777760000000055555555
00000000000000000000000000000000777777777777777777555555555555770000000000000000000000000000000000000000d00000004444444444444444
9f00d700000000000000000000000000700000077000000770700000000007070000000000000000000000000000000000000000d50000004ffffff44ffffff4
9f2ed728000000000000000000000000700000077000000770070000000070070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
44444444000000000000000000000000777777777777777777776000000677770000000000000000000000000000000000000000d51000004f4444944f444494
00000000000000000000000000000000700000677600000770066000000660070000000000000000000000000000000000000000d51000004f4444944f444494
00cd006500000000000a000000000000700006077060000770606000000606070000000000000000000000000000000000000000d51000004f9999944f444494
b3cd8265000000000000000000000000700005077050000770506000000605070000000000000000000000000000000000000000d5100000444444444f449994
b3cd826500a0a000000aa000000a0a00700000077000000770006000000600070000000000000000000000000000000000000000d5100000444444444f994444
b3cd826500aaaa0000aaaa0000aaa000700000077000000770050000000050070000000000000000000000000000000000000000d510000049a4444444444444
b3cd826500a9aa0000a99a0000aa9a00700000077000000770500000000005070000000000000000000000000000000000000000d51000004994444444444444
b3cd826500a99a0000a99a0000a99a00777777777777777775000000000000770000000000000000000000000000000000000000d51000004444444449a44444
44444444004444000044440000444400555555555555555555555555555555550000000000000000000000000000000000000000d51000004ffffff449944444
99999999777777777777777777777777700000077776000077777777777777770000000000000000000000000000000000000000d51000004f44449444444444
55555555555555555555555555555555700000077776000055555555555555550000000000000000000000000000000000000000d51000004f4444944444fff4
444444441dd6dd6dd6dd6dd6d6dd6d51700000077776000044444444444444440000000000000000000000000000000000000000d51000004f4444944fff4494
ffff4fff1dd6dd6dd6dd6dd6d6dd6d517000000766665555444ffffffffff4440000000000000000000000000000000000000000d51000004f4444944f444494
44494944166666666666666666666651700000070000777644494444444494440000000000000000000000000000000000000000d51000004f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd65170000007000077764449444aa44494440000000000000000000000000000000000000000d51111114f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd651777777770000777644494444444494440000000000000000000000000000000000000000d55555554ffffff44f444494
44494944166666666666666666666651555555555555666644499999999994440000000000000000000000000000000000000000dddddddd444444444f444494
444949441dd6dd600000000056dd6d516dd6dd6d000000004449444444449444000000000000000000000000000000000000000000000000000000004f444494
444949441dd6dd650000000056dd6d5166666666000000004449444444449444000000000000000000000000000000000000000000000000000000004f444994
44494944166666650000000056666651d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f499444
444949441d6dd6d5000000005d6dd651d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494440000000000000000000000000000000000000000000000000000000044444400
444949441666666500000000566666516dd6dd6d0000000044494444444494440000000000000000000000000000000000000000000000000000000044440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994440000000000000000000000000000000000000000000000000000000044000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccffffffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccf666677f
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccc7cccccc7
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaccccd776666d
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000caaaccccf676650f
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccff7665ff
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fff76fffffffffff
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fff76ffff666677f
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fbbbbccf75555557
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000bbbcccc8d776666d
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fccccc8ff676650f
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fccc888ff676650f
00000000000000000000000000000000000000000000000000000000000000000000000000000000fff22fff000000000000000000000000fff00ffff676650f
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff0020ff000000000000000000000000fff00fffff7665ff
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2302ffff2302ff0000000000000000fff76fff00000094
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffb33bffffb33bff0000000000000000fff76fff00000944
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff0000000000000000f8888bbf00009440
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2222ffff2222ff0000000000000000888bbbbc00094400
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff0000000000000000fbbbbbcf00044000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f2b33b2ff2b33b2f0000000000000000fbbbcccf00400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f22bb22ff2b33b2f0000000000000000fff00fff94000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f222222ff22bb22f0000000000000000fff00fff44000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f222222f000000000000000000000000fff76fffcccccccc
00000000000000000000000000000000000000000000000000000000000000000000000000000000f22bb22f000000000000000000000000fff76fffc000000c
00000000000000000000000000000000000000000000000000000000000000000000000000000000f2b33b2f000000000000000000000000fcccc88fc0c00c0c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022b33b22000000000000000000000000ccc8888bc00cc00c
00000000000000000000000000000000000000000000000000000000000000000000000000000000222bb222000000000000000000000000f88888bfc00cc00c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022222222000000000000000000000000f888bbbfc0c00c0c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022222222000000000000000000000000fff00fffc000000c
00000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbb000000000000000000000000fff00fffcccccccc
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000
00000000b444449bb444449bb444449bb494449bb494449bb494449bb999449bb999449bb999449b000000000000000000000000000000000000000000000000
00000000444044494440444944404449494444494944444949444449944444499444444994444449000000000000000000000000000000000000000000000000
00000000404000044040000440400004494400044944000449440004944444449444444494444444000000000000000000000000000000000000000000000000
0000000004ffff0004ffff0004ffff000440fffb0440fffb0440fffb444444444444444444444444000000000000000000000000000000000000000000000000
000000000f9ff9f00f9ff9f00f9ff9f004f0f9fb04f0f9fb04f0f9fb444444444444444444444444000000000000000000000000000000000000000000000000
000cc0000f5ff5f00f5ff5f00f5ff5f000fff5fb00fff5fb00fff5fb4444444044444440444444400f5ff5f000fff5fb44444440000000000000000000000000
00c11c004ffffff44ffffff44ffffff440ffffff40ffffff40ffffff0444444404444444044444444ffffff440ffffff04444444000000000000000000000000
0c1001c0bff44ffbbff44ffbbff44ffbb0fffff4b0fffff4b0fffff4b044444bb044444bb044444bbff44ffbb0fffff4b044444b000000000000000000000000
ccc00cccb6ffff6bb6ffff6bb6ffff6bb6fffffbb6fffffbb6fffffbb044444bb044444bb044444bb6ffff6bb6fffffbb044444b000000000000000000000000
00c00c00bbfddfbbbbfddfbbbbfddfbbbb6fffdbbb6fffdbbb6fffdbbb0000bbbb0000bbbb0000bbbbf00fbbbb6ff00bbb0000bb000000000000000000000000
00c00c00bbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbf00fbbbbbff00bbbbffbbb000000000000000000000000
00cccc00bdc55cdbbdc55cdbbdc55cdbbbddcbbbbbbddbbbbbddcbbbbddddddbbddddddbbddddddbbbbffbbbbbbbbffbbddddddb000000000000000000000000
00111100dcc55ccddcc55ccddcc55ccdb1ccdcbbbb1ccdbbb1ccdcbbdccccccddccccccddccccccdbbbbbbbbbbbbbbbbdccccccd000000000000000000000000
00070000c1c66c1cc1c66c1dd1c66c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1cc1cccc1dd1cccc1c000000000000000000000000000000000000000000000000
00070000c1c55c1cc1c55c1dd1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1cc1cccc1dd1cccc1c000000000000000000000000000000000000000000000000
00070000c1c55c1ccc155c1dd1c551ccb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1ccc1ccc1dd1ccc1cc000000000000000000000000000000000000000000000000
77707770c1c55c1ccc155c1dd1c551ccb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1ccc1ccc1dd1ccc1cc000000000000000000000000000000000000000000000000
00070000d1cddc1dbc1ddcdbbdcdd1cbb1dddcbbbb1dddbbb1dddcbbd1cccc1dbc1cccdbbdccc1cb000000000000000000000000000000000000000000000000
00070000fe1111efbfe1112bb2111efbbbff11bbbb2ff1bbbbff11bbfe1111efbfe1112bb2111efb000000000000000000000000000000000000000000000000
00070000bf1111fbbff111ebbe111ffbbbfe11bbbb2fe1bbbbfe11bbbf1111fbbff111ebbe111ffb000000000000000000000000000000000000000000000000
00000000bb1121bbbb1121bbbb1121bbbb2111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00cccc00bb1121bbbb1121bbbb1121bbbb1111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00c11c00bb1121bbbb1121bbbb1121bbbb1111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00c00c00bb1121bbbb1121bbbb1121bbbb1112bbbb2111bbbb21111bbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
ccc00cccbb1121bbbb1121bbbb1121bbbb1112bbbb2111bbbb22111bbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
1c1001c1bb1121bbbb1121bbbb1121bbb111122bbb2111bbb222111bbb1211bbbb121cbbbbc211bb000000000000000000000000000000000000000000000000
01c00c10bb1121bbbb1121bbbb1121bbc111222bbb2111bbb22211ccbb1211bbbb12cc7bb7cc11bb000000000000000000000000000000000000000000000000
001cc100bbccccbbbb77c77bb77c77bb7ccc222bbbccccbbb222cc77bbccccbbbbcc677bb776ccbb000000000000000000000000000000000000000000000000
00011000b776677bbbbb677bb776bbbbb7776666bb6777bbb66677bbb776677bbb77bbbbbbbb77bb000000000000000000000000000000000000000000000000
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
0001010100000000000000010000000000010101010100000000000100000000000101010101000000000000000000000001010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0707070808080808080808080807070717171709090909090909090909090909090909090917171700000010000061626262626262626262626262620000001046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
0707070800000808080808080807070717171709090909090909444444450909090909090917171700200000002071447474744473b27144747444740000200046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
07000708000008080808080808070007170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
07000760606060616263606060070007170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
0700077070707071727370707007000717001776777677767776777677767776777677767717001715151515151515151515151515151515151515151515151546004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
0701113131313131313131313121010717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d1515151546405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
11313131251515151515153531313121123232323232323232323232323232323232323232323222153c3937373737378e373737373737373737373a3d15151550707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
313131313131313131313131313131313232323232323232323232323232323232323232323232323c393737373737373737373737373737373737373a3d151570707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
0000000000000000002000000000002007070750405040504050404040504050405040504007070762626263001f00104646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0020000000000000000000000010000007070740504050405040504050405040504050405007070744734473001f20004646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0000002000000000000000000000000007000750405040505050405040504000405040504007000764736473201f00004600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000007000760606060606060616263606000606060606007000762626263001f00204600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000007000770707070707070717273707000707070707007000731313131310b30304600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000200007011131313131313131313131313131313131313121010718181818181815154640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
0000000000100000002000000000000011313131313131251515151515151535313131313131312115151515151515155070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
2000000000000000000020000000000031313131313131313131313131313131313131313131313115151515151515157070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
000000100000200000001f0061626262626262626262626262626263001f0010464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
002000000000001000001f2071447144714473004e71447344734473001f2000464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
200000000020000000201f0071647164716473005e71647364736473201f0000460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
000020000000000020001f0062626262626273006e71626262626263001f0020460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
303030303030303030301b3131313131313131253531313131313131310b3030460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
1515151515151515151518181818181818183434343418181818181818181515464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
1515151515151515151515151515151515143434343424151515151515151515507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
1515151515151515151515151515151515151515151515151515151515151515707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
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

