pico-8 cartridge // http://www.pico-8.com
version 9
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



-- debugging
show_debuginfo = true
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


-- 
-- room & object definitions
-- 



-- title "room"
	-- objects
	rm_title = {
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
		--[[					break_time(50)
							print_line("in a galaxy not far away...",64,45,8,1)]]
		--[[			change_room(rm_hall, 1)
							shake(true)
							start_script(rm_hall.scripts.spin_top,false,true)
							print_line("cozy fireplaces...",90,20,8,1)
							print_line("(just look at it!)",90,20,8,1)
							shake(false)]]

		--[[					-- part 2
							change_room(rm_kitchen, 1)
							print_line("strange looking aliens...",30,20,8,1,false,true)
							put_actor_at(purp_tentacle, 130, purp_tentacle.y, rm_kitchen)
							walk_to(purp_tentacle, 
								purp_tentacle.x-30, 
								purp_tentacle.y)
							wait_for_actor(purp_tentacle)
							say_line(purp_tentacle, "what did you call me?!")

							-- part 3
							change_room(rm_garden, 1)
							print_line("and even swimming pools!",90,20,8,1,false,true)
							camera_at(200)
							camera_pan_to(0)
							wait_for_camera()
							print_line("quack!",45,60,10,1)]]

							-- part 4
							change_room(rm_outside, 1)
							

							-- outro
							-- change_room(rm_title, 1)

							-- fades(1,1)	-- fade out
							-- break_time(100)
							
						end) -- end cutscene

				end -- if not done intro
		end,
		exit = function()
			-- todo: anything here?
		end,
	}
-- outside (front)
	-- objects
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
					--camera_follow(purp_tentacle)
				end,
				close = function(me)
					close_door(me, obj_front_door_inside)
				end
			}
		}

	rm_outside = {
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
				put_actor_at(selected_actor, 144, 36, rm_outside)
				-- make camera follow player
				-- (setting now, will be re-instated after cutscene)
				camera_follow(selected_actor)
				-- do cutscene
				-- cutscene(
				-- 	1, -- no verbs
				-- 	-- cutscene code (hides ui, etc.)
				-- 	function()
				-- 		camera_at(0)
				-- 		camera_pan_to(selected_actor)
				-- 		wait_for_camera()
				-- 		say_line("let's do this")
				-- 	end
				-- )
			end
		end,
		exit = function(me)
			-- todo: anything here?
		end,
	}

-- hall
	-- objects
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

		obj_hall_door_library = {		
			data = [[
				name=library
				state=state_open
				x=48
				y=16
				w=1
				h=3
				use_dir = face_back
			]],
			verbs = {
				walkto = function(me)
					come_out_door(me, obj_library_door_hall)
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
								change_room(rm_kitchen, 1)
								selected_actor = purp_tentacle
								walk_to(selected_actor, 
									selected_actor.x+10, 
									selected_actor.y)
								say_line("what was that?!")
								say_line("i'd better check...")
								walk_to(selected_actor, 
									selected_actor.x-10, 
									selected_actor.y)
								change_room(rm_hall, 1)
								-- wait for a bit, then appear in room1
								break_time(50)
								put_actor_at(selected_actor, 115, 44, rm_hall)
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
								change_room(rm_hall)
								put_actor_at(purp_tentacle, 105, 44, rm_hall)
								stop_talking()
								do_anim(main_actor, "anim_face", purp_tentacle)
							end
						)
					end
					-- (code here will not run, as room change nuked "local" scripts)
				end
			}
		}


	rm_hall = {
		data = [[
			map = {16,16,39,23}
		]],
		objects = {
			obj_front_door_inside,
			obj_hall_door_library,
			obj_hall_door_kitchen,
			obj_bucket,
			obj_spinning_top,
			--obj_window
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

-- library
	-- objects
		
		obj_library_door_hall = {		
			data = [[
				name=hall
				state=state_open
				x=48
				y=16
				w=1
				h=3
				use_dir = face_back
			]],
			verbs = {
				walkto = function(me)
					come_out_door(me, obj_hall_door_library)
				end
			}
		}
		
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
					change_room(rm_title, 1)
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


	rm_library = {
		data = [[
			map = {16,8,39,15}
			trans_col = 10
			col_replace={7,4}
		]],
		objects = {
			obj_library_door_hall,
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
	

-- kitchen
	-- objects
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

	rm_kitchen = {
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


-- back garden
	-- objects
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

	rm_garden = {
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


-- "the void" (room)
-- a place to put objects/actors when not in a room
	
	-- objects

		obj_switch_tent = {		
			data = [[
				name=purple tentacle
				state=state_here
				state_here=170
				trans_col=15
				x=1
				y=1
				w=1
				h=1
			]],
			verbs = {
				use = function(me)
					selected_actor = purp_tentacle
					camera_follow(purp_tentacle)
				end
			}
		}

		obj_switch_player= {		
			data = [[
				name=humanoid
				state=state_here
				state_here=209
				trans_col=11
				x=1
				y=1
				w=1
				h=1
			]],
			verbs = {
				use = function(me)
					selected_actor = main_actor
					camera_follow(main_actor)
				end
			}
		}

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_switch_player,
			obj_switch_tent
		},
	}


-- ----

	

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

	

rooms = {
	rm_void,
	rm_title,
	rm_outside,
	rm_hall,
	rm_kitchen,
	rm_garden,
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
		inventory = {
			obj_switch_tent
		},
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
		in_room = rm_kitchen,
		inventory = {
			obj_switch_player
		},
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
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)

	pickup_obj(obj_switch_tent, main_actor)
	pickup_obj(obj_switch_player, purp_tentacle)
			-- 
	--change_room(rm_library, 1) -- iris fade
	change_room(rm_title, 1) -- iris fade

	room_curr = rm_title
end


-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)





function shake(ce) if ce then
cf=1 end cg=ce end function ch(ci) local cj=nil if has_flag(ci.classes,"class_talkable") then
cj="talkto"elseif has_flag(ci.classes,"class_openable") then if ci.state=="state_closed"then
cj="open"else cj="close"end else cj="lookat"end for ck in all(verbs) do cl=get_verb(ck) if cl[2]==cj then cj=ck break end
end return cj end function cm(cn,co,cp) local cq=has_flag(co.classes,"class_actor") if cn=="walkto"then
return elseif cn=="pickup"then if cq then
say_line"i don't need them"else say_line"i don't need that"end elseif cn=="use"then if cq then
say_line"i can't just *use* someone"end if cp then
if has_flag(cp.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cn=="give"then if cq then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cn=="lookat"then if cq then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cn=="open"then if cq then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cn=="close"then if cq then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cn=="push"or cn=="pull"then if cq then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cn=="talkto"then if cq then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cr) cs=ct(cr) cu=nil cv=nil end function camera_follow(cw) stop_script(cx) cv=cw cu=nil cx=function() while cv do if cv.in_room==room_curr then
cs=ct(cv) end yield() end end start_script(cx,true) if cv.in_room!=room_curr then
change_room(cv.in_room,1) end end function camera_pan_to(cr) cu=ct(cr) cv=nil cx=function() while(true) do if cs==cu then
cu=nil return elseif cu>cs then cs+=0.5 else cs-=0.5 end yield() end end start_script(cx,true) end function wait_for_camera() while script_running(cx) do yield() end end function cutscene(cy,cz,da) db={cy=cy,dc=cocreate(cz),dd=da,de=cv} add(df,db) dg=db break_time() end function dialog_set(dh) for msg in all(dh) do dialog_add(msg) end end function dialog_add(msg) if not di then di={dj={},dk=false} end
dl=dm(msg,32) dn=dp(dl) dq={num=#di.dj+1,msg=msg,dl=dl,dr=dn} add(di.dj,dq) end function dialog_start(col,ds) di.col=col di.ds=ds di.dk=true selected_sentence=nil end function dialog_hide() di.dk=false end function dialog_clear() di.dj={} selected_sentence=nil end function dialog_end() di=nil end function get_use_pos(ci) dt=ci.use_pos if type(dt)=="table"then
x=dt[1]-cs y=dt[2]-du elseif not dt or dt=="pos_infront"then x=ci.x+((ci.w*8)/2)-cs-4 y=ci.y+(ci.h*8)+2 elseif dt=="pos_left"then if ci.dv then
x=ci.x-cs-(ci.w*8+4) y=ci.y+1 else x=ci.x-cs-2 y=ci.y+((ci.h*8)-2) end elseif dt=="pos_right"then x=ci.x+(ci.w*8)-cs y=ci.y+((ci.h*8)-2) end return{x=x,y=y} end function do_anim(cw,dw,dx) dy={"face_front","face_left","face_back","face_right"} if dw=="anim_face"then
if type(dx)=="table"then
dz=atan2(cw.x-dx.x,dx.y-cw.y) ea=93*(3.1415/180) dz=ea-dz eb=dz*360 eb=eb%360 if eb<0 then eb+=360 end
dx=4-flr(eb/90) dx=dy[dx] end face_dir=ec[cw.face_dir] dx=ec[dx] while face_dir!=dx do if face_dir<dx then
face_dir+=1 else face_dir-=1 end cw.face_dir=dy[face_dir] cw.flip=(cw.face_dir=="face_left") break_time(10) end end end function open_door(ed,ee) if ed.state=="state_open"then
say_line"it's already open"else ed.state="state_open"if ee then ee.state="state_open"end
end end function close_door(ed,ee) if ed.state=="state_closed"then
say_line"it's already closed"else ed.state="state_closed"if ee then ee.state="state_closed"end
end end function come_out_door(ef,eg,eh) if ef.state=="state_open"then
ei=eg.in_room change_room(ei,eh) local ej=get_use_pos(eg) put_actor_at(selected_actor,ej.x,ej.y,ei) ek={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if eg.use_dir then
el=ek[eg.use_dir] else el=1 end selected_actor.face_dir=el selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(em,bl) if bl==1 then
en=0 else en=50 end while true do en+=bl*2 if en>50
or en<0 then return end if em==1 then
eo=min(en,32) end yield() end end function change_room(ei,em) stop_script(ep) if em and room_curr then
fades(em,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end eq={} er() room_curr=ei if not cv
or cv.in_room!=room_curr then cs=0 end stop_talking() if em then
ep=function() fades(em,-1) end start_script(ep,true) else eo=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cn,es) if not es
or not es.verbs then return false end if type(cn)=="table"then
if es.verbs[cn[1]] then return true end
else if es.verbs[cn] then return true end
end return false end function pickup_obj(ci,cw) cw=cw or selected_actor add(cw.cc,ci) ci.owner=cw del(ci.in_room.objects,ci) end function start_script(et,eu,ev,bb) local dc=cocreate(et) local scripts=eq if eu then
scripts=ew end add(scripts,{et,dc,ev,bb}) end function script_running(et) for ex in all({eq,ew}) do for ey,ez in pairs(ex) do if ez[1]==et then
return ez end end end return false end function stop_script(et) ez=script_running(et) if ez then
del(eq,ez) del(ew,ez) end end function break_time(fa) fa=fa or 1 for x=1,fa do yield() end end function wait_for_message() while fb!=nil do yield() end end function say_line(cw,msg,fc,fd) if type(cw)=="string"then
msg=cw cw=selected_actor end fe=cw.y-(cw.h)*8+4 ff=cw print_line(msg,cw.x,fe,cw.col,1,fc,fd) end function stop_talking() fb,ff=nil,nil end function print_line(msg,x,y,col,fg,fc,fd) local col=col or 7 local fg=fg or 0 local fh=min(x-cs,127-(x-cs)) local fi=max(flr(fh/2),16) local fj=""for fk=1,#msg do local fl=sub(msg,fk,fk) if fl==":"then
fj=sub(msg,fk+1) msg=sub(msg,1,fk-1) break end end local dl=dm(msg,fi) local dn=dp(dl) if fg==1 then
fm=x-cs-((dn*4)/2) end fm=max(2,fm) fe=max(18,y) fm=min(fm,127-(dn*4)-1) fb={fn=dl,x=fm,y=fe,col=col,fg=fg,fo=(#msg)*8,dr=dn,fc=fc} if#fj>0 then
fp=ff wait_for_message() ff=fp print_line(fj,x,y,col,fg,fc) end if not fd then
wait_for_message() end end function put_actor_at(cw,x,y,fq) if fq then cw.in_room=fq end
cw.x,cw.y=x,y end function walk_to(cw,x,y) x+=cs local fr=fs(cw) local ft=flr(x/8)+room_curr.map[1] local fu=flr(y/8)+room_curr.map[2] local fv={ft,fu} local fw=fx(fr,fv) local fy=fs({x=x,y=y}) if fz(fy[1],fy[2]) then
add(fw,fy) end for ga in all(fw) do local gb=(ga[1]-room_curr.map[1])*8+4 local gc=(ga[2]-room_curr.map[2])*8+4 local gd=sqrt((gb-cw.x)^2+(gc-cw.y)^2) local ge=cw.speed*(gb-cw.x)/gd local gf=cw.speed*(gc-cw.y)/gd if gd>5 then
cw.gg=1 cw.flip=(ge<0) if abs(ge)<0.4 then
if gf>0 then
cw.gh=cw.walk_anim_front cw.face_dir="face_front"else cw.gh=cw.walk_anim_back cw.face_dir="face_back"end else cw.gh=cw.walk_anim_side cw.face_dir="face_right"if cw.flip then cw.face_dir="face_left"end
end for fk=0,gd/cw.speed do cw.x+=ge cw.y+=gf yield() end end end cw.gg=2 end function wait_for_actor(cw) cw=cw or selected_actor while cw.gg!=2 do yield() end end function proximity(co,cp) if co.in_room==cp.in_room then
local gd=sqrt((co.x-cp.x)^2+(co.y-cp.y)^2) return gd else return 1000 end end du=16 cs,cu,cx,cf=0,nil,nil,0 gi,gj,gk,gl=63.5,63.5,0,1 gm={7,12,13,13,12,7} gn={{spr=208,x=75,y=du+60},{spr=240,x=75,y=du+72}} ec={face_front=1,face_left=2,face_back=3,face_right=4} function go(ci) local gp={} for ey,ck in pairs(ci) do add(gp,ey) end return gp end function get_verb(ci) local cn={} local gp=go(ci[1]) add(cn,gp[1]) add(cn,ci[1][gp[1]]) add(cn,ci.text) return cn end function er() gq=get_verb(verb_default) gr,gs,n,gt,gu=nil,nil,nil,false,""end er() fb=nil di=nil dg=nil ff=nil ew={} eq={} df={} gv={} eo,eo=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gw() start_script(startup_script,true) end function _update60() gx() end function _draw() gy() end function gx() if selected_actor and selected_actor.dc
and not coresume(selected_actor.dc) then selected_actor.dc=nil end gz(ew) if dg then
if dg.dc
and not coresume(dg.dc) then if dg.cy!=3
and dg.de then camera_follow(dg.de) selected_actor=dg.de end del(df,dg) dg=nil if#df>0 then
dg=df[#df] end end else gz(eq) end ha() hb() hc,hd=1.5-rnd(3),1.5-rnd(3) hc=flr(hc*cf) hd=flr(hd*cf) if not cg then
cf*=0.90 if cf<0.05 then cf=0 end
end end function gy() rectfill(0,0,127,127,0) camera(cs+hc,0+hd) clip(0+eo-hc,du+eo-hd,128-eo*2-hc,64-eo*2) he() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,du-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,du-8,8) end if show_debuginfo then
print("x: "..gi+cs.." y:"..gj-du,80,du-8,8) end hf() if di
and di.dk then hg() hh() return end if hi==dg then
else hi=dg return end if not dg then
hj() end if(not dg
or dg.cy==2) and(hi==dg) then hk() else end hi=dg if not dg then
hh() end end function ha() if dg then
if btnp(4) and btnp(5) and dg.dd then
dg.dc=cocreate(dg.dd) dg.dd=nil return end return end if btn(0) then gi-=1 end
if btn(1) then gi+=1 end
if btn(2) then gj-=1 end
if btn(3) then gj+=1 end
if btnp(4) then hl(1) end
if btnp(5) then hl(2) end
if enable_mouse then
hm,hn=stat(32)-1,stat(33)-1 if hm!=ho then gi=hm end
if hn!=hp then gj=hn end
if stat(34)>0 then
if not hq then
hl(stat(34)) hq=true end else hq=false end ho=hm hp=hn end gi=mid(0,gi,127) gj=mid(0,gj,127) end function hl(hr) local hs=gq if not selected_actor then
return end if di and di.dk then
if ht then
selected_sentence=ht end return end if hu then
gq=get_verb(hu) elseif hv then if hr==1 then
if(gq[2]=="use"or gq[2]=="give")
and gr then gs=hv else gr=hv end elseif hw then gq=get_verb(hw) gr=hv go(gr) hj() end elseif hx then if hx==gn[1] then
if selected_actor.hy>0 then
selected_actor.hy-=1 end else if selected_actor.hy+2<flr(#selected_actor.cc/4) then
selected_actor.hy+=1 end end return end if gr!=nil
and not gt then if gq[2]=="use"or gq[2]=="give"then
if gs then
elseif gr.use_with and gr.owner==selected_actor then return end end gt=true selected_actor.dc=cocreate(function() if(not gr.owner
and(not has_flag(gr.classes,"class_actor") or gq[2]!="use")) or gs then hz=gs or gr ia=get_use_pos(hz) walk_to(selected_actor,ia.x,ia.y) if selected_actor.gg!=2 then return end
use_dir=hz if hz.use_dir then use_dir=hz.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gq,gr) then
start_script(gr.verbs[gq[1]],false,gr,gs) else cm(gq[2],gr,gs) end er() end) coresume(selected_actor.dc) elseif gj>du and gj<du+64 then gt=true selected_actor.dc=cocreate(function() walk_to(selected_actor,gi,gj-du) er() end) coresume(selected_actor.dc) end end function hb() hu,hw,hv,ht,hx=nil,nil,nil,nil,nil if di
and di.dk then for ex in all(di.dj) do if ib(ex) then
ht=ex end end return end ic() for ci in all(room_curr.objects) do if(not ci.classes
or(ci.classes and not has_flag(ci.classes,"class_untouchable"))) and(not ci.dependent_on or ci.dependent_on.state==ci.dependent_on_state) then id(ci,ci.w*8,ci.h*8,cs,ie) else ci.ig=nil end if ib(ci) then
if not hv
or(not ci.z and hv.z<0) or(ci.z and hv.z and ci.z>hv.z) then hv=ci end end ih(ci) end for ey,cw in pairs(actors) do if cw.in_room==room_curr then
id(cw,cw.w*8,cw.h*8,cs,ie) ih(cw) if ib(cw)
and cw!=selected_actor then hv=cw end end end if selected_actor then
for ck in all(verbs) do if ib(ck) then
hu=ck end end for ii in all(gn) do if ib(ii) then
hx=ii end end for ey,ci in pairs(selected_actor.cc) do if ib(ci) then
hv=ci if gq[2]=="pickup"and hv.owner then
gq=nil end end if ci.owner!=selected_actor then
del(selected_actor.cc,ci) end end if gq==nil then
gq=get_verb(verb_default) end if hv then
hw=ch(hv) end end end function ic() gv={} for x=-64,64 do gv[x]={} end end function ih(ci) fe=-1 if ci.ij then
fe=ci.y else fe=ci.y+(ci.h*8) end ik=flr(fe-du) if ci.z then
ik=ci.z end add(gv[ik],ci) end function he() rectfill(0,du,127,du+64,room_curr.il or 0) for z=-64,64 do if z==0 then
im(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,du,room_curr.io,room_curr.ip) pal() else ik=gv[z] for ci in all(ik) do if not has_flag(ci.classes,"class_actor") then
if ci.states
or(ci.state and ci[ci.state] and ci[ci.state]>0) and(not ci.dependent_on or ci.dependent_on.state==ci.dependent_on_state) and not ci.owner then iq(ci) end else if ci.in_room==room_curr then
ir(ci) end end is(ci) end end end end function im(ci) if ci.col_replace then
it=ci.col_replace pal(it[1],it[2]) end if ci.lighting then
iu(ci.lighting) elseif ci.in_room then iu(ci.in_room.lighting) end end function iq(ci) im(ci) iv=1 if ci.repeat_x then iv=ci.repeat_x end
for h=0,iv-1 do local iw=0 if ci.states then
iw=ci.states[ci.state] else iw=ci[ci.state] end ix(iw,ci.x+(h*(ci.w*8)),ci.y,ci.w,ci.h,ci.trans_col,ci.flip_x) end pal() end function ir(cw) iy=ec[cw.face_dir] if cw.gg==1
and cw.gh then cw.iz+=1 if cw.iz>5 then
cw.iz=1 cw.ja+=1 if cw.ja>#cw.gh then cw.ja=1 end
end jb=cw.gh[cw.ja] else jb=cw.idle[iy] end im(cw) ix(jb,cw.dv,cw.ij,cw.w,cw.h,cw.trans_col,cw.flip,false) if ff
and ff==cw then if cw.jc<7 then
jb=cw.talk[iy] ix(jb,cw.dv,cw.ij+8,1,1,cw.trans_col,cw.flip,false) end cw.jc+=1 if cw.jc>14 then cw.jc=1 end
end pal() end function hj() jd=""je=12 jf=gq[2] if not gt then
if gq then
jd=gq[3] end if gr then
jd=jd.." "..gr.name if jf=="use"then
jd=jd.." with"elseif jf=="give"then jd=jd.." to"end end if gs then
jd=jd.." "..gs.name elseif hv and hv.name!=""and(not gr or(gr!=hv)) and(not hv.owner or jf!=get_verb(verb_default)[2]) then jd=jd.." "..hv.name end gu=jd else jd=gu je=7 end print(jg(jd),jh(jd),du+66,je) end function hf() if fb then
ji=0 for jj in all(fb.fn) do jk=0 if fb.fg==1 then
jk=((fb.dr*4)-(#jj*4))/2 end jl(jj,fb.x+jk,fb.y+ji,fb.col,0,fb.fc) ji+=6 end fb.fo-=1 if fb.fo<=0 then
stop_talking() end end end function hk() fm,fe,jm=0,75,0 for ck in all(verbs) do jn=verb_maincol if hw
and ck==hw then jn=verb_defcol end if ck==hu then jn=verb_hovcol end
cl=get_verb(ck) print(cl[3],fm,fe+du+1,verb_shadcol) print(cl[3],fm,fe+du,jn) ck.x=fm ck.y=fe id(ck,#cl[3]*4,5,0,0) is(ck) if#cl[3]>jm then jm=#cl[3] end
fe+=8 if fe>=95 then
fe=75 fm+=(jm+1.0)*4 jm=0 end end if selected_actor then
fm,fe=86,76 jo=selected_actor.hy*4 jp=min(jo+8,#selected_actor.cc) for jq=1,8 do rectfill(fm-1,du+fe-1,fm+8,du+fe+8,1) ci=selected_actor.cc[jo+jq] if ci then
ci.x,ci.y=fm,fe iq(ci) id(ci,ci.w*8,ci.h*8,0,0) is(ci) end fm+=11 if fm>=125 then
fe+=12 fm=86 end jq+=1 end for fk=1,2 do jr=gn[fk] if hx==jr then pal(verb_maincol,7) end
ix(jr.spr,jr.x,jr.y,1,1,0) id(jr,8,7,0,0) is(jr) pal() end end end function hg() fm,fe=0,70 for ex in all(di.dj) do if ex.dr>0 then
ex.x,ex.y=fm,fe id(ex,ex.dr*4,#ex.dl*5,0,0) jn=di.col if ex==ht then jn=di.ds end
for jj in all(ex.dl) do print(jg(jj),fm,fe+du,jn) fe+=5 end is(ex) fe+=2 end end end function hh() col=gm[gl] pal(7,col) spr(224,gi-4,gj-3,1,1,0) pal() gk+=1 if gk>7 then
gk=1 gl+=1 if gl>#gm then gl=1 end
end end function ix(js,x,y,w,h,jt,flip_x,ju) palt(0,false) palt(jt,true) spr(js,x,du+y,w,h,flip_x,ju) palt(jt,false) palt(0,true) end function gw() for fq in all(rooms) do jv(fq) if(#fq.map>2) then
fq.io=fq.map[3]-fq.map[1]+1 fq.ip=fq.map[4]-fq.map[2]+1 else fq.io=16 fq.ip=8 end for ci in all(fq.objects) do jv(ci) ci.in_room=fq end end for jw,cw in pairs(actors) do jv(cw) cw.gg=2 cw.iz=1 cw.jc=1 cw.ja=1 cw.cc={} cw.hy=0 end end function is(ci) local jx=ci.ig if show_collision
and jx then rect(jx.x,jx.y,jx.jy,jx.jz,8) end end function gz(scripts) for ez in all(scripts) do if ez[2] and not coresume(ez[2],ez[3],ez[4]) then
del(scripts,ez) ez=nil end end end function iu(ka) if ka then ka=1-ka end
local ga=flr(mid(0,ka,1)*100) local kb={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kc=1,15 do col=kc kd=(ga+(kc*1.46))/22 for ey=1,kd do col=kb[col] end pal(kc,col) end end function ct(cr) if type(cr)=="table"then
cr=cr.x end return mid(0,cr-64,(room_curr.io*8)-128) end function fs(ci) local ft=flr(ci.x/8)+room_curr.map[1] local fu=flr(ci.y/8)+room_curr.map[2] return{ft,fu} end function fz(ft,fu) local ke=mget(ft,fu) local kf=fget(ke,0) return kf end function dm(msg,fi) local dl={} local kg=""local kh=""local fl=""local ki=function(kj) if#kh+#kg>kj then
add(dl,kg) kg=""end kg=kg..kh kh=""end for fk=1,#msg do fl=sub(msg,fk,fk) kh=kh..fl if fl==" "
or#kh>fi-1 then ki(fi) elseif#kh>fi-1 then kh=kh.."-"ki(fi) elseif fl==";"then kg=kg..sub(kh,1,#kh-1) kh=""ki(0) end end ki(fi) if kg!=""then
add(dl,kg) end return dl end function dp(dl) dn=0 for jj in all(dl) do if#jj>dn then dn=#jj end
end return dn end function has_flag(ci,kk) for bm in all(ci) do if bm==kk then
return true end end return false end function id(ci,w,h,kl,km) x=ci.x y=ci.y if has_flag(ci.classes,"class_actor") then
ci.dv=x-(ci.w*8)/2 ci.ij=y-(ci.h*8)+1 x=ci.dv y=ci.ij end ci.ig={x=x,y=y+du,jy=x+w-1,jz=y+h+du-1,kl=kl,km=km} end function fx(kn,ko) local kp,kq,kr={},{},{} ks(kp,kn,0) kq[kt(kn)]=nil kr[kt(kn)]=0 while#kp>0 and#kp<1000 do local ku=kp[#kp] del(kp,kp[#kp]) kv=ku[1] if kt(kv)==kt(ko) then
break end local kw={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kx=kv[1]+x local ky=kv[2]+y if abs(x)!=abs(y) then kz=1 else kz=1.4 end
if kx>=room_curr.map[1] and kx<=room_curr.map[1]+room_curr.io
and ky>=room_curr.map[2] and ky<=room_curr.map[2]+room_curr.ip and fz(kx,ky) and((abs(x)!=abs(y)) or fz(kx,kv[2]) or fz(kx-x,ky)) then add(kw,{kx,ky,kz}) end end end end for la in all(kw) do local lb=kt(la) local lc=kr[kt(kv)]+la[3] if kr[lb]==nil
or lc<kr[lb] then kr[lb]=lc local ld=lc+max(abs(ko[1]-la[1]),abs(ko[2]-la[2])) ks(kp,la,ld) kq[lb]=kv end end end local fw={} kv=kq[kt(ko)] if kv then
local le=kt(kv) local lf=kt(kn) while le!=lf do add(fw,kv) kv=kq[le] le=kt(kv) end for fk=1,#fw/2 do local lg=fw[fk] local lh=#fw-(fk-1) fw[fk]=fw[lh] fw[lh]=lg end end return fw end function ks(li,cr,ga) if#li>=1 then
add(li,{}) for fk=(#li),2,-1 do local la=li[fk-1] if ga<la[2] then
li[fk]={cr,ga} return else li[fk]=la end end li[1]={cr,ga} else add(li,{cr,ga}) end end function kt(lj) return((lj[1]+1)*16)+lj[2] end function jv(ci) local dl=lk(ci.data,"\n") for jj in all(dl) do local pairs=lk(jj,"=") if#pairs==2 then
ci[pairs[1]]=ll(pairs[2]) else printh("invalid data line") end end end function lk(ex,lm) local ln={} local jo=0 local lo=0 for fk=1,#ex do local lp=sub(ex,fk,fk) if lp==lm then
add(ln,sub(ex,jo,lo)) jo=0 lo=0 elseif lp!=" "and lp!="\t"then lo=fk if jo==0 then jo=fk end
end end if jo+lo>0 then
add(ln,sub(ex,jo,lo)) end return ln end function ll(lq) local lr=sub(lq,1,1) local ln=nil if lq=="true"then
ln=true elseif lq=="false"then ln=false elseif lt(lr) then if lr=="-"then
ln=sub(lq,2,#lq)*-1 else ln=lq+0 end elseif lr=="{"then local lg=sub(lq,2,#lq-1) ln=lk(lg,",") lu={} for cr in all(ln) do cr=ll(cr) add(lu,cr) end ln=lu else ln=lq end return ln end function lt(it) for a=1,13 do if it==sub("0123456789.-+",a,a) then
return true end end end function jl(lv,x,y,lw,lx,fc) if not fc then lv=jg(lv) end
for ly=-1,1 do for lz=-1,1 do print(lv,x+ly,y+lz,lx) end end print(lv,x,y,lw) end function jh(ex) return 63.5-flr((#ex*4)/2) end function ma(ex) return 61 end function ib(ci) if not ci.ig then return false end
ig=ci.ig if(gi+ig.kl>ig.jy or gi+ig.kl<ig.x)
or(gj>ig.jz or gj<ig.y) then return false else return true end end function jg(ex) local a=""local jj,it,li=false,false for fk=1,#ex do local ii=sub(ex,fk,fk) if ii=="^"then
if it then a=a..ii end
it=not it elseif ii=="~"then if li then a=a..ii end
li,jj=not li,not jj else if it==jj and ii>="a"and ii<="z"then
for kc=1,26 do if ii==sub("abcdefghijklmnopqrstuvwxyz",kc,kc) then
ii=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kc,kc) break end end end a=a..ii it,li=false,false end end return a end














__gfx__
0000000000000000000000000000000000000000440000004444444477777777f9e9f9f9ddd5ddd5bbbbbbbb5500000000000000000000000000000000000000
00000000000000000000000000000000000000004400000044444444777777779eee9f9fdd5ddd5dbbbbbbbb5555000000000000000000000000000000000000
0080080000000000000000000000000000000000aaaa000055aaaaaa77777777feeef9f9d5ddd5ddbbbbbbbb5555550000000000000000000000000000000000
0008800055555555ddddddddeeeeeeee000000009999000005999999777777779fef9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0008800055555555ddddddddeeeeeeee00000000444444000555444477777777f9f9feeeddd5ddd5bbbbbbbb5555555500000000000000000000000000000000
0080080055555555ddddddddeeeeeeee000000004444440000054444777777779f9f9eeedd5ddd5dbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee00000000aaaaaaaa000555aa77777777f9f9feeed5ddd5ddbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee000000009999999900000599777777779f9f9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0000000077777755666666ddbbbbbbee333333553333333300000044666666665888858866666666000000000000005500000000000000000000000000045000
00000000777755556666ddddbbbbeeee33333355333333330000004466666666588885881c1c1c1c000000000000555500000000000000000000000000045000
000010007755555566ddddddbbeeeeee33336666333333330000aaaa6666666655555555c1c1c1c1000000000055555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33336666333333330000999966666666888588881c1c1c1c000000005555555500000000000000000000000000045000
001c7c1055555555ddddddddeeeeeeee3355555533333333004444446666666688858888c1c1c1c1000000005555555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33555555333333330044444466666666555555551c1c1c1c000000005555555500000000000000000000000000045000
0000100055555555ddddddddeeeeeeee6666666633333333aaaaaaaa6666666658888588c1c1c1c1000000005555555500000000000000000000000000045000
0000000055555555ddddddddeeeeeeee66666666333333339999999966666666588885887c7c7c7c000000005555555500000000000000000000000000045000
0000000055777777dd666666eebbbbbb553333335555555544444444777777777777777700000000000000000000000000000000000000000000000099999999
0000000055557777dddd6666eeeebbbb553333335555333344444444777777777777777700000000000000000000000000000000000000000000000044444444
0000000055555577dddddd66eeeeeebb6666333355333333aaaaaaaa777777777777777700000000000000000000000000000000000000000000000000045000
000c000055555555ddddddddeeeeeeee666633335333333399999999777777777777777700000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee555555335333333344444444777777555577777700000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee555555335533333344444444777755555555777700000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee6666666655553333aaaaaaaa775555555555557700000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddeeeeeeee666666665555555599999999555555555555555500000000000000000000000000000000000000000000000000045000
0000000055555555ddddddddbbbbbbbb555555555555555544444444cccccccc5555555677777777c77777776555555533333336633333330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333555544444444cccccccc555555677777777ccc7777777655555533333367763333330000000000045000
0000000055555555ddddddddbbbbbbbb6666666633333355aaaaaa55cccccccc55555677777777ccccc777777765555533333677776333330000000000045000
0000000055555555ddddddddbbbbbbbb666666663333333599999950cccccccc5555677777777ccccccc77777776555533336777777633330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333333544445550cccccccc555677777777ccccccccc7777777655533367777777763330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333335544445000cccccccc55677777777ccccccccccc777777765533677777777776330000000000045000
0b03000055555555ddddddddbbbbbbbb6666666633335555aa555000cccccccc5677777777ccccccccccccc77777776536777777777777630000000099999999
b00030b055555555ddddddddbbbbbbbb666666665555555599500000cccccccc677777777ccccccccccccccc7777777667777777777777760000000055555555
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
444949441dd6dd600000000056dd6d516dd6dd6d0000000044494444444494440000000000000000000000000000000000000000000000004f4444944f444494
444949441dd6dd650000000056dd6d51666666660000000044494444444494440000000000000000000000000000000000000000000000004f4444944f444994
44494944166666650000000056666651d6dd6dd60000000044494444444494440000000000000000000000000000000000000000000000004f4444944f499444
444949441d6dd6d5000000005d6dd651d6dd6dd60000000044494444444494440000000000000000000000000000000000000000000000004f4444944f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494440000000000000000000000000000000000000000000000004f44449444444400
444949441666666500000000566666516dd6dd6d0000000044494444444494440000000000000000000000000000000000000000000000004f44449444440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994440000000000000000000000000000000000000000000000004f44449444000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444440000000000000000000000000000000000000000000000004f44449400000000
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
0001010100010100000000010000000000010101010101000000000100000000000101010101010101000000000000000001010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0707070808080808080808080807070717171709090909090909090909090909090909090917171700000010000061626262626262626262626262620000001046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
0707070800000808080808080807070717171709090909090909444444450909090909090917171700200000002071447474744473b27144747444740000200046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
07070708000008080808080808070007170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
07070760606060616263606060070007170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
0707077070707071727370707007000717001776777677767776777677767776777677767717001715151515151515151515151515151515151515151515151546004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
0727113131313131313131313121010717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d1515151546405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
11313131251515151515153531313121123232323232323232323232323232323232323232323222153c3937373737378e373737373737373737373a3d15151550707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
313131313131313131313131313131313232323232323232323232323232323232323232323232323c393737373737373737373737373737373737373a3d151570707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
0000000000000000002000000000002007070750405040504050404040504050405040504007070762626263001f00104646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0020000000000000000000000010000007070740504050405040504050405040504050405007070744734473001f20004646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0000002000000000000000000000000007070750405000505050405040504000405040504007070764736473201f00004600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000007070760606000606060616263606000606060606007070762626263001f00204600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000007070770707000707070717273707000707070707007070731313131310b30304600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000200007271131313131313131313131313131313131313121280718181818181815154640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
0000000000100000002000000000000011313131313131251515151515151535313131313131312115151515151515155070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
2000000000000000000020000000000031313131313131313131313131313131313131313131313115151515151515157070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646464848484848484848484846464607070708080808080808080808062605080808080807070748484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
46464648484848484848484848464646070707080808080808080808080b2626080808080807070748484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4600464848484848484848484846004607000708084e00080808080808162626080808080807000748484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004607000760605e00606060606016262636606060606007000748484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004607000770706e0070707070162626361b707070707007000748484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404607011131313131313131313131313131313131313121010770707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706011313131313131251515151515151535313131313131312170707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
7070707070707070707070707070707031313131313131313131313131313131313131313131313170707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
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

