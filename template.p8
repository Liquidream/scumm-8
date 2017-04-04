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
-- now 6805 tokens (after also converting flags/enums to strings)
-- now 6792 tokens (after made cutscene flags = numbers)

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



-- 
-- object definitions
-- 

	obj_fire = {
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
		dependent_on_state = "state_open",
		verbs = {
			lookat = function()
				say_line("it's a nice, warm fire...")
				break_time(10)
				do_anim(selected_actor, "anim_face", "face_front")
				say_line("ouch! it's hot!:*stupid fire*")
			end,
			talkto = function()
				say_line("'hi fire...'")
				break_time(10)
				do_anim(selected_actor, "anim_face", "face_front")
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
			state = state_closed
			x=8
			y=16
			z=1
			w=1
			h=4
			state_closed=79
			classes = {class_openable}
			use_pos = pos_right
			use_dir = face_left
		]],
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
			state = state_open
			x=112
			y=16
			w=1
			h=4
			use_pos = pos_left
			use_dir = face_right
		]],
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_kitchen_door_hall)
			end
		}
	}

	obj_bucket = {		
		data = [[
			name = bucket
			state = state_open
			x=104
			y=48
			w=1
			h=1
			state_closed=143
			state_open = 159
			trans_col=15
			use_with=true
			classes = {class_pickupable}
		]],
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
					me.state = "state_closed"
					me.name = "full bucket"
					pickup_obj(me)
				else
					say_line("i might need this")
				end
			end,
			use = function(me, noun2)
				if (noun2 == obj_window) then
					obj_window.state = "state_open"
				end
			end
		}
	}

	obj_spinning_top = {		
		data = [[
			name=spinning top
			x=16
			y=48
			w=1
			h=1
			state=1
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
			state=state_closed
			x=32
			y=8
			w=2
			h=2
			state_closed=68
			state_open=70
			use_pos={40,57}
			classes = {class_openable}
		]],
		verbs = {
			open = function(me)
				if not me.done_cutscene then
					cutscene(
						1, -- no verbs 
						function()
							me.done_cutscene = true
							-- cutscene code
							me.state = "state_open"
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
							do_anim(main_actor, "anim_face", purp_tentacle)
						end,
						-- override for cutscene
						function()
							--if cutscene_curr.skipped then
							--d("override!")
							change_room(first_room)
							put_actor_at(purp_tentacle, 105, 44, first_room)
							stop_talking()
							do_anim(main_actor, "anim_face", purp_tentacle)
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
			state=state_open
			x=8
			y=16
			w=1
			h=4
			use_pos = pos_right
			use_dir = face_left
		]],
		verbs = {
			walkto = function(me)
				come_out_door(me, obj_hall_door_kitchen)
			end
		}
	}

	obj_back_door = {		
		data = [[
			name=back door
			state=state_closed
			x=176
			y=16
			z=1
			w=1
			h=4
			state_closed=79
			flip_x=true
			classes = {class_openable}
			use_pos = pos_left
			use_dir = face_right
		]],
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
			state=state_here
			x=80
			y=24
			w=1
			h=2
			state_here=47
			repeat_x = 8
			classes = {class_untouchable}
		]],
	}

	obj_rail_right = {		
		data = [[
			state=state_here
			x=176
			y=24
			w=1
			h=2
			state_here=47
			repeat_x = 8
			classes = {class_untouchable}
		]],
	}

	obj_front_door = {		
		data = [[
			name = front door
			state=state_closed
			x=152
			y=8
			w=1
			h=3
			state_closed=78
			flip_x = true
			classes = {class_openable}
			use_dir = face_back
		]],
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
			state=state_closed
			x=104
			y=8
			w=1
			h=3
			state_closed=78
			classes = {class_openable}
			use_dir = face_back
		]],
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
			state=state_closed
			x=120
			y=16
			z=-1
			w=1
			h=3
			state_closed=80
			state_open=80
			classes = {class_untouchable}
			use_dir = face_back
		]],
		verbs = {
		}
	}

	obj_library_door_secret = {		
		data = [[
			name=secret passage
			state=state_closed
			x=120
			y=16
			z=-10
			w=1
			h=3
			state_closed=77
			use_dir = face_back
			dependent_on_state = state_open
		]],
		dependent_on = obj_library_secret_panel,
		--dependent_on_state = state_open,
		verbs = {
			walkto = function(me)
				change_room(title_room, 1)
			end
		}
	}

	obj_book = {		
		data = [[
			name=loose book
			x=140
			y=16
			w=1
			h=1
			use_pos={140,60}
			classes = {class_pickupable}
		]],
		verbs = {
			lookat = function(me)
				say_line("this book sticks out")
			end,
			pull = function(me)
				if obj_library_secret_panel.state != "state_open" then
					obj_library_secret_panel.state="state_open"
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
			state=state_here
			state_here=142
			trans_col=12
			x=1
			y=1
			w=1
			h=1
			classes = {class_pickupable}
		]],
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
			
					cutscene(
						3, -- no verbs & no follow, 
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
				cutscene(
					1, -- no verbs
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
			obj_window
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
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
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
			classes = {class_actor,class_talkable}
			face_dir = face_front
			use_pos = pos_left
		]],
		in_room = second_room,
		verbs = {
				lookat = function()
					say_line("it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(
						1, -- no verbs
						function()
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

						cutscene(
							1, -- no verbs
							function()
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
bz=1 end ca=by end function cb(cc) local cd=nil if has_flag(cc.classes,"class_talkable") then
cd="talkto"elseif has_flag(cc.classes,"class_openable") then if cc.state=="state_closed"then
cd="open"else cd="close"end else cd="lookat"end for ce in all(verbs) do cf=get_verb(ce) if cf[2]==cd then cd=ce break end
end return cd end function cg(ch,ci,cj) local ck=has_flag(ci.classes,"class_actor") if ch=="walkto"then
return elseif ch=="pickup"then if ck then
say_line"i don't need them"else say_line"i don't need that"end elseif ch=="use"then if ck then
say_line"i can't just *use* someone"end if cj then
if has_flag(cj.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif ch=="give"then if ck then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif ch=="lookat"then if ck then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif ch=="open"then if ck then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif ch=="close"then if ck then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif ch=="push"or ch=="pull"then if ck then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif ch=="talkto"then if ck then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cl) cm=cn(cl) co=nil cp=nil end function camera_follow(cq) stop_script(cr) cp=cq co=nil cr=function() while cp do if cp.in_room==room_curr then
cm=cn(cp) end yield() end end start_script(cr,true) end function camera_pan_to(cl) co=cn(cl) cp=nil cr=function() while(true) do if cm==co then
co=nil return elseif co>cm then cm+=0.5 else cm-=0.5 end yield() end end start_script(cr,true) end function wait_for_camera() while script_running(cr) do yield() end end function cutscene(cs,ct,cu) cv={cs=cs,cw=cocreate(ct),cx=cu,cy=cp} add(cz,cv) da=cv break_time() end function dialog_set(db) for msg in all(db) do dialog_add(msg) end end function dialog_add(msg) if not dc then dc={dd={},de=false} end
df=dg(msg,32) dh=di(df) dj={num=#dc.dd+1,msg=msg,df=df,dk=dh} add(dc.dd,dj) end function dialog_start(col,dl) dc.col=col dc.dl=dl dc.de=true selected_sentence=nil end function dialog_hide() dc.de=false end function dialog_clear() dc.dd={} selected_sentence=nil end function dialog_end() dc=nil end function get_use_pos(cc) dm=cc.use_pos if type(dm)=="table"then
x=dm[1]-cm y=dm[2]-dn elseif not dm or dm=="pos_infront"then x=cc.x+((cc.w*8)/2)-cm-4 y=cc.y+(cc.h*8)+2 elseif dm=="pos_left"then if cc.dp then
x=cc.x-cm-(cc.w*8+4) y=cc.y+1 else x=cc.x-cm-2 y=cc.y+((cc.h*8)-2) end elseif dm=="pos_right"then x=cc.x+(cc.w*8)-cm y=cc.y+((cc.h*8)-2) end return{x=x,y=y} end function do_anim(cq,dq,dr) ds={"face_front","face_left","face_back","face_right"} if dq=="anim_face"then
if type(dr)=="table"then
dt=atan2(cq.x-dr.x,dr.y-cq.y) du=93*(3.1415/180) dt=du-dt dv=dt*360 dv=dv%360 if dv<0 then dv+=360 end
dr=4-flr(dv/90) dr=ds[dr] end face_dir=dw[cq.face_dir] dr=dw[dr] while face_dir!=dr do if face_dir<dr then
face_dir+=1 else face_dir-=1 end cq.face_dir=ds[face_dir] cq.flip=(cq.face_dir=="face_left") break_time(10) end end end function open_door(dx,dy) if dx.state=="state_open"then
say_line"it's already open"else dx.state="state_open"if dy then dy.state="state_open"end
end end function close_door(dx,dy) if dx.state=="state_closed"then
say_line"it's already closed"else dx.state="state_closed"if dy then dy.state="state_closed"end
end end function come_out_door(dz,ea,eb) if dz.state=="state_open"then
ec=ea.in_room change_room(ec,eb) local ed=get_use_pos(ea) put_actor_at(selected_actor,ed.x,ed.y,ec) ee={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if ea.use_dir then
ef=ee[ea.use_dir] else ef=1 end selected_actor.face_dir=ef selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eg,bs) if bs==1 then
eh=0 else eh=50 end while true do eh+=bs*2 if eh>50
or eh<0 then return end if eg==1 then
ei=min(eh,32) end yield() end end function change_room(ec,eg) stop_script(ej) if eg and room_curr then
fades(eg,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ek={} el() room_curr=ec if not cp
or cp.in_room!=room_curr then cm=0 end stop_talking() if eg then
ej=function() fades(eg,-1) end start_script(ej,true) else ei=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(ch,em) if not em
or not em.verbs then return false end if type(ch)=="table"then
if em.verbs[ch[1]] then return true end
else if em.verbs[ch] then return true end
end return false end function pickup_obj(cc) add(selected_actor.en,cc) cc.owner=selected_actor del(cc.in_room.objects,cc) end function start_script(eo,ep,eq,t) local cw=cocreate(eo) local scripts=ek if ep then
scripts=er end add(scripts,{eo,cw,eq,t}) end function script_running(eo) for es in all({ek,er}) do for et,eu in pairs(es) do if eu[1]==eo then
return eu end end end return false end function stop_script(eo) eu=script_running(eo) if eu then
del(ek,eu) del(er,eu) end end function break_time(ev) ev=ev or 1 for x=1,ev do yield() end end function wait_for_message() while ew!=nil do yield() end end function say_line(cq,msg,ex,ey) if type(cq)=="string"then
msg=cq cq=selected_actor end ez=cq.y-(cq.h)*8+4 fa=cq print_line(msg,cq.x,ez,cq.col,1,ex,ey) end function stop_talking() ew,fa=nil,nil end function print_line(msg,x,y,col,fb,ex,ey) local col=col or 7 local fb=fb or 0 local fc=min(x-cm,127-(x-cm)) local fd=max(flr(fc/2),16) local fe=""for ff=1,#msg do local fg=sub(msg,ff,ff) if fg==":"then
fe=sub(msg,ff+1) msg=sub(msg,1,ff-1) break end end local df=dg(msg,fd) local dh=di(df) if fb==1 then
fh=x-cm-((dh*4)/2) end fh=max(2,fh) ez=max(18,y) fh=min(fh,127-(dh*4)-1) ew={fi=df,x=fh,y=ez,col=col,fb=fb,fj=(#msg)*8,dk=dh,ex=ex} if#fe>0 then
fk=fa wait_for_message() fa=fk print_line(fe,x,y,col,fb,ex) end if not ey then
wait_for_message() end end function put_actor_at(cq,x,y,fl) if fl then cq.in_room=fl end
cq.x,cq.y=x,y end function walk_to(cq,x,y) x+=cm local fm=fn(cq) local fo=flr(x/8)+room_curr.map[1] local fp=flr(y/8)+room_curr.map[2] local fq={fo,fp} local fr=fs(fm,fq) local ft=fn({x=x,y=y}) if fu(ft[1],ft[2]) then
add(fr,ft) end for fv in all(fr) do local fw=(fv[1]-room_curr.map[1])*8+4 local fx=(fv[2]-room_curr.map[2])*8+4 local fy=sqrt((fw-cq.x)^2+(fx-cq.y)^2) local fz=cq.speed*(fw-cq.x)/fy local ga=cq.speed*(fx-cq.y)/fy if fy>5 then
cq.gb=1 cq.flip=(fz<0) if abs(fz)<0.4 then
if ga>0 then
cq.gc=cq.walk_anim_front cq.face_dir="face_front"else cq.gc=cq.walk_anim_back cq.face_dir="face_back"end else cq.gc=cq.walk_anim_side cq.face_dir="face_right"if cq.flip then cq.face_dir="face_left"end
end for ff=0,fy/cq.speed do cq.x+=fz cq.y+=ga yield() end end end cq.gb=2 end function wait_for_actor(cq) cq=cq or selected_actor while cq.gb!=2 do yield() end end function proximity(ci,cj) if ci.in_room==cj.in_room then
local fy=sqrt((ci.x-cj.x)^2+(ci.y-cj.y)^2) return fy else return 1000 end end dn=16 cm,co,cr,bz=0,nil,nil,0 gd,ge,gf,gg=63.5,63.5,0,1 gh={7,12,13,13,12,7} gi={{spr=208,x=75,y=dn+60},{spr=240,x=75,y=dn+72}} dw={face_front=1,face_left=2,face_back=3,face_right=4} function gj(cc) local gk={} for et,ce in pairs(cc) do add(gk,et) end return gk end function get_verb(cc) local ch={} local gk=gj(cc[1]) add(ch,gk[1]) add(ch,cc[1][gk[1]]) add(ch,cc.text) return ch end function el() gl=get_verb(verb_default) gm,gn,o,go,gp=nil,nil,nil,false,""end el() ew=nil dc=nil da=nil fa=nil er={} ek={} cz={} gq={} ei,ei=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gr() start_script(startup_script,true) end function _update60() gs() end function _draw() gt() end function gs() if selected_actor and selected_actor.cw
and not coresume(selected_actor.cw) then selected_actor.cw=nil end gu(er) if da then
if da.cw
and not coresume(da.cw) then if da.cs!=3
and da.cy then camera_follow(da.cy) selected_actor=da.cy end del(cz,da) da=nil if#cz>0 then
da=cz[#cz] end end else gu(ek) end gv() gw() gx,gy=1.5-rnd(3),1.5-rnd(3) gx=flr(gx*bz) gy=flr(gy*bz) if not ca then
bz*=0.90 if bz<0.05 then bz=0 end
end end function gt() rectfill(0,0,127,127,0) camera(cm+gx,0+gy) clip(0+ei-gx,dn+ei-gy,128-ei*2-gx,64-ei*2) gz() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dn-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dn-8,8) end if show_debuginfo then
print("x: "..gd.." y:"..ge-dn,80,dn-8,8) end ha() if dc
and dc.de then hb() hc() return end if hd==da then
else hd=da return end if not da then
he() end if(not da
or da.cs==2) and(hd==da) then hf() else end hd=da if not da then
hc() end end function gv() if da then
if btnp(4) and btnp(5) and da.cx then
da.cw=cocreate(da.cx) da.cx=nil return end return end if btn(0) then gd-=1 end
if btn(1) then gd+=1 end
if btn(2) then ge-=1 end
if btn(3) then ge+=1 end
if btnp(4) then hg(1) end
if btnp(5) then hg(2) end
if enable_mouse then
hh,hi=stat(32)-1,stat(33)-1 if hh!=hj then gd=hh end
if hi!=hk then ge=hi end
if stat(34)>0 then
if not hl then
hg(stat(34)) hl=true end else hl=false end hj=hh hk=hi end gd=mid(0,gd,127) ge=mid(0,ge,127) end function hg(hm) local hn=gl if not selected_actor then
return end if dc and dc.de then
if ho then
selected_sentence=ho end return end if hp then
gl=get_verb(hp) elseif hq then if hm==1 then
if(gl[2]=="use"or gl[2]=="give")
and gm then gn=hq else gm=hq end elseif hr then gl=get_verb(hr) gm=hq gj(gm) he() end elseif hs then if hs==gi[1] then
if selected_actor.ht>0 then
selected_actor.ht-=1 end else if selected_actor.ht+2<flr(#selected_actor.en/4) then
selected_actor.ht+=1 end end return end if gm!=nil
and not go then if gl[2]=="use"or gl[2]=="give"then
if gn then
elseif gm.use_with and gm.owner==selected_actor then return end end go=true selected_actor.cw=cocreate(function() if(not gm.owner
and(not has_flag(gm.classes,"class_actor") or gl[2]!="use")) or gn then hu=gn or gm hv=get_use_pos(hu) walk_to(selected_actor,hv.x,hv.y) if selected_actor.gb!=2 then return end
use_dir=hu if hu.use_dir then use_dir=hu.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gl,gm) then
start_script(gm.verbs[gl[1]],false,gm,gn) else cg(gl[2],gm,gn) end el() end) coresume(selected_actor.cw) elseif ge>dn and ge<dn+64 then go=true selected_actor.cw=cocreate(function() walk_to(selected_actor,gd,ge-dn) el() end) coresume(selected_actor.cw) end end function gw() hp,hr,hq,ho,hs=nil,nil,nil,nil,nil if dc
and dc.de then for es in all(dc.dd) do if hw(es) then
ho=es end end return end hx() for cc in all(room_curr.objects) do if(not cc.classes
or(cc.classes and not has_flag(cc.classes,"class_untouchable"))) and(not cc.dependent_on or cc.dependent_on.state==cc.dependent_on_state) then hy(cc,cc.w*8,cc.h*8,cm,hz) else cc.ia=nil end if hw(cc) then
if not hq
or(not cc.z and hq.z<0) or(cc.z and hq.z and cc.z>hq.z) then hq=cc end end ib(cc) end for et,cq in pairs(actors) do if cq.in_room==room_curr then
hy(cq,cq.w*8,cq.h*8,cm,hz) ib(cq) if hw(cq)
and cq!=selected_actor then hq=cq end end end if selected_actor then
for ce in all(verbs) do if hw(ce) then
hp=ce end end for ic in all(gi) do if hw(ic) then
hs=ic end end for et,cc in pairs(selected_actor.en) do if hw(cc) then
hq=cc if gl[2]=="pickup"and hq.owner then
gl=nil end end if cc.owner!=selected_actor then
del(selected_actor.en,cc) end end if gl==nil then
gl=get_verb(verb_default) end if hq then
hr=cb(hq) end end end function hx() gq={} for x=-64,64 do gq[x]={} end end function ib(cc) ez=-1 if cc.id then
ez=cc.y else ez=cc.y+(cc.h*8) end ie=flr(ez-dn) if cc.z then
ie=cc.z end add(gq[ie],cc) end function gz() rectfill(0,dn,127,dn+64,room_curr.ig or 0) for z=-64,64 do if z==0 then
ih(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,dn,room_curr.ii,room_curr.ij) pal() else ie=gq[z] for cc in all(ie) do if not has_flag(cc.classes,"class_actor") then
if cc.states
or(cc.state and cc[cc.state] and cc[cc.state]>0) and(not cc.dependent_on or cc.dependent_on.state==cc.dependent_on_state) and not cc.owner then ik(cc) end else if cc.in_room==room_curr then
il(cc) end end im(cc) end end end end function ih(cc) if cc.col_replace then
io=cc.col_replace pal(io[1],io[2]) end if cc.lighting then
ip(cc.lighting) elseif cc.in_room then ip(cc.in_room.lighting) end end function ik(cc) ih(cc) iq=1 if cc.repeat_x then iq=cc.repeat_x end
for h=0,iq-1 do local ir=0 if cc.states then
ir=cc.states[cc.state] else ir=cc[cc.state] end is(ir,cc.x+(h*(cc.w*8)),cc.y,cc.w,cc.h,cc.trans_col,cc.flip_x) end pal() end function il(cq) it=dw[cq.face_dir] if cq.gb==1
and cq.gc then cq.iu+=1 if cq.iu>5 then
cq.iu=1 cq.iv+=1 if cq.iv>#cq.gc then cq.iv=1 end
end iw=cq.gc[cq.iv] else iw=cq.idle[it] end ih(cq) is(iw,cq.dp,cq.id,cq.w,cq.h,cq.trans_col,cq.flip,false) if fa
and fa==cq then if cq.ix<7 then
iw=cq.talk[it] is(iw,cq.dp,cq.id+8,1,1,cq.trans_col,cq.flip,false) end cq.ix+=1 if cq.ix>14 then cq.ix=1 end
end pal() end function he() iy=""iz=12 if not go then
if gl then
iy=gl[3] end if gm then
iy=iy.." "..gm.name if gl[2]=="use"then
iy=iy.." with"elseif gl[2]=="give"then iy=iy.." to"end end if gn then
iy=iy.." "..gn.name elseif hq and hq.name!=""and(not gm or(gm!=hq)) then iy=iy.." "..hq.name end gp=iy else iy=gp iz=7 end print(ja(iy),jb(iy),dn+66,iz) end function ha() if ew then
jc=0 for jd in all(ew.fi) do je=0 if ew.fb==1 then
je=((ew.dk*4)-(#jd*4))/2 end jf(jd,ew.x+je,ew.y+jc,ew.col,0,ew.ex) jc+=6 end ew.fj-=1 if ew.fj<=0 then
stop_talking() end end end function hf() fh,ez,jg=0,75,0 for ce in all(verbs) do jh=verb_maincol if hr
and ce==hr then jh=verb_defcol end if ce==hp then jh=verb_hovcol end
cf=get_verb(ce) print(cf[3],fh,ez+dn+1,verb_shadcol) print(cf[3],fh,ez+dn,jh) ce.x=fh ce.y=ez hy(ce,#cf[3]*4,5,0,0) im(ce) if#cf[3]>jg then jg=#cf[3] end
ez+=8 if ez>=95 then
ez=75 fh+=(jg+1.0)*4 jg=0 end end if selected_actor then
fh,ez=86,76 ji=selected_actor.ht*4 jj=min(ji+8,#selected_actor.en) for jk=1,8 do rectfill(fh-1,dn+ez-1,fh+8,dn+ez+8,1) cc=selected_actor.en[ji+jk] if cc then
cc.x,cc.y=fh,ez ik(cc) hy(cc,cc.w*8,cc.h*8,0,0) im(cc) end fh+=11 if fh>=125 then
ez+=12 fh=86 end jk+=1 end for ff=1,2 do jl=gi[ff] if hs==jl then pal(verb_maincol,7) end
is(jl.spr,jl.x,jl.y,1,1,0) hy(jl,8,7,0,0) im(jl) pal() end end end function hb() fh,ez=0,70 for es in all(dc.dd) do if es.dk>0 then
es.x,es.y=fh,ez hy(es,es.dk*4,#es.df*5,0,0) jh=dc.col if es==ho then jh=dc.dl end
for jd in all(es.df) do print(ja(jd),fh,ez+dn,jh) ez+=5 end im(es) ez+=2 end end end function hc() col=gh[gg] pal(7,col) spr(224,gd-4,ge-3,1,1,0) pal() gf+=1 if gf>7 then
gf=1 gg+=1 if gg>#gh then gg=1 end
end end function is(jm,x,y,w,h,jn,flip_x,jo) palt(0,false) palt(jn,true) spr(jm,x,dn+y,w,h,flip_x,jo) palt(jn,false) palt(0,true) end function gr() for fl in all(rooms) do jp(fl) if(#fl.map>2) then
fl.ii=fl.map[3]-fl.map[1]+1 fl.ij=fl.map[4]-fl.map[2]+1 else fl.ii=16 fl.ij=8 end for cc in all(fl.objects) do jp(cc) cc.in_room=fl end end for jq,cq in pairs(actors) do jp(cq) cq.gb=2 cq.iu=1 cq.ix=1 cq.iv=1 cq.en={} cq.ht=0 end end function im(cc) local jr=cc.ia if show_collision
and jr then rect(jr.x,jr.y,jr.js,jr.jt,8) end end function gu(scripts) for eu in all(scripts) do if eu[2] and not coresume(eu[2],eu[3],eu[4]) then
del(scripts,eu) eu=nil end end end function ip(ju) if ju then ju=1-ju end
local fv=flr(mid(0,ju,1)*100) local jv={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jw=1,15 do col=jw jx=(fv+(jw*1.46))/22 for et=1,jx do col=jv[col] end pal(jw,col) end end function cn(cl) if type(cl)=="table"then
cl=cl.x end return mid(0,cl-64,(room_curr.ii*8)-128) end function fn(cc) local fo=flr(cc.x/8)+room_curr.map[1] local fp=flr(cc.y/8)+room_curr.map[2] return{fo,fp} end function fu(fo,fp) local jy=mget(fo,fp) local jz=fget(jy,0) return jz end function dg(msg,fd) local df={} local ka=""local kb=""local fg=""local kc=function(kd) if#kb+#ka>kd then
add(df,ka) ka=""end ka=ka..kb kb=""end for ff=1,#msg do fg=sub(msg,ff,ff) kb=kb..fg if fg==" "
or#kb>fd-1 then kc(fd) elseif#kb>fd-1 then kb=kb.."-"kc(fd) elseif fg==";"then ka=ka..sub(kb,1,#kb-1) kb=""kc(0) end end kc(fd) if ka!=""then
add(df,ka) end return df end function di(df) dh=0 for jd in all(df) do if#jd>dh then dh=#jd end
end return dh end function has_flag(cc,ke) for bt in all(cc) do if bt==ke then
return true end end return false end function hy(cc,w,h,kf,kg) x=cc.x y=cc.y if has_flag(cc.classes,"class_actor") then
cc.dp=x-(cc.w*8)/2 cc.id=y-(cc.h*8)+1 x=cc.dp y=cc.id end cc.ia={x=x,y=y+dn,js=x+w-1,jt=y+h+dn-1,kf=kf,kg=kg} end function fs(kh,ki) local kj,kk,kl={},{},{} km(kj,kh,0) kk[kn(kh)]=nil kl[kn(kh)]=0 while#kj>0 and#kj<1000 do local ko=kj[#kj] del(kj,kj[#kj]) kp=ko[1] if kn(kp)==kn(ki) then
break end local kq={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kr=kp[1]+x local ks=kp[2]+y if abs(x)!=abs(y) then kt=1 else kt=1.4 end
if kr>=room_curr.map[1] and kr<=room_curr.map[1]+room_curr.ii
and ks>=room_curr.map[2] and ks<=room_curr.map[2]+room_curr.ij and fu(kr,ks) and((abs(x)!=abs(y)) or fu(kr,kp[2]) or fu(kr-x,ks)) then add(kq,{kr,ks,kt}) end end end end for ku in all(kq) do local kv=kn(ku) local kw=kl[kn(kp)]+ku[3] if kl[kv]==nil
or kw<kl[kv] then kl[kv]=kw local kx=kw+max(abs(ki[1]-ku[1]),abs(ki[2]-ku[2])) km(kj,ku,kx) kk[kv]=kp end end end local fr={} kp=kk[kn(ki)] if kp then
local ky=kn(kp) local kz=kn(kh) while ky!=kz do add(fr,kp) kp=kk[ky] ky=kn(kp) end for ff=1,#fr/2 do local la=fr[ff] local lb=#fr-(ff-1) fr[ff]=fr[lb] fr[lb]=la end end return fr end function km(lc,cl,fv) if#lc>=1 then
add(lc,{}) for ff=(#lc),2,-1 do local ku=lc[ff-1] if fv<ku[2] then
lc[ff]={cl,fv} return else lc[ff]=ku end end lc[1]={cl,fv} else add(lc,{cl,fv}) end end function kn(ld) return((ld[1]+1)*16)+ld[2] end function jp(cc) local df=le(cc.data,"\n") for jd in all(df) do local pairs=le(jd,"=") if#pairs==2 then
cc[pairs[1]]=lf(pairs[2]) else printh("invalid data line") end end end function le(es,lg) local lh={} local ji=0 local li=0 for ff=1,#es do local lj=sub(es,ff,ff) if lj==lg then
add(lh,sub(es,ji,li)) ji=0 li=0 elseif lj!=" "and lj!="\t"then li=ff if ji==0 then ji=ff end
end end if ji+li>0 then
add(lh,sub(es,ji,li)) end return lh end function lf(lk) local ll=sub(lk,1,1) local lh=nil if lk=="true"then
lh=true elseif lk=="false"then lh=false elseif lm(ll) then if ll=="-"then
lh=sub(lk,2,#lk)*-1 else lh=lk+0 end elseif ll=="{"then local la=sub(lk,2,#lk-1) lh=le(la,",") ln={} for cl in all(lh) do cl=lf(cl) add(ln,cl) end lh=ln else lh=lk end return lh end function lm(io) for a=1,13 do if io==sub("0123456789.-+",a,a) then
return true end end end function jf(lo,x,y,lp,lq,ex) if not ex then lo=ja(lo) end
for lr=-1,1 do for lt=-1,1 do print(lo,x+lr,y+lt,lq) end end print(lo,x,y,lp) end function jb(es) return 63.5-flr((#es*4)/2) end function lu(es) return 61 end function hw(cc) if not cc.ia then return false end
ia=cc.ia if(gd+ia.kf>ia.js or gd+ia.kf<ia.x)
or(ge>ia.jt or ge<ia.y) then return false else return true end end function ja(es) local a=""local jd,io,lc=false,false for ff=1,#es do local ic=sub(es,ff,ff) if ic=="^"then
if io then a=a..ic end
io=not io elseif ic=="~"then if lc then a=a..ic end
lc,jd=not lc,not jd else if io==jd and ic>="a"and ic<="z"then
for jw=1,26 do if ic==sub("abcdefghijklmnopqrstuvwxyz",jw,jw) then
ic=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jw,jw) break end end end a=a..ic io,lc=false,false end end return a end






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

