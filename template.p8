pico-8 cartridge // http://www.pico-8.com
version 9
__lua__
-- scumm-8 game template
-- paul nicholas

-- 7004 tokens (5206 is engine!) - leaving 1188 tokens spare
-- now 6979 tokens (1213 spare)
-- now 6758 tokens (after "packing" - 1434 spare)
-- now 6723 tokens (after packing actors)
-- now 6860 tokens (after adding library)
-- now 6906 tokens (after adding "use" object/actor & fix shake crop)
-- now 6805 tokens (after also converting flags/enums to strings)
-- now 6845 tokens (after adding switch chars via inventory)
-- now 6944 tokens (after adding in landing & error reporting)
-- now 6977 tokens (after adding new use_pos & error check for nil doors)
-- now 7489 tokens (after adding mini-game & door classes)

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


function reset_ui()
	verb_maincol = 12  -- main color (lt blue)
	verb_hovcol = 7    -- hover color (white)
	verb_shadcol = 1   -- shadow (dk blue)
	verb_defcol = 10   -- default action (yellow)
end



-- 
-- room & object definitions
-- 

-- title "room"
	-- objects
	rm_title = {
		data = [[
			map = {0,16}
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
				--			change_room(rm_outside, 1)
							

							-- outro
							print_line("coming soon...:to a pico-8 near you!",64,45,8,1)
							fades(1,1)	-- fade out
							break_time(100)
							
						end) -- end cutscene

				end -- if not done intro
		end,
		exit = function()
			-- todo: anything here?
		end,
	}

-- [ ground floor ]

	-- outside (front)
		-- objects
			obj_outside_stairs = {
				data = [[
					x=1
					y=1
					w=1
					h=1
					state=state_here
					state_here=3
					classes = {class_untouchable}
				]],
				draw = function(me)
					-- switch transparency
					set_trans_col(8, true)
					-- draw stairs
					map(56,23, 136,60, 6,1)
				end,
			}

			obj_rail_left = {		
				data = [[
					state=state_here
					x=80
					y=24
					w=1
					h=2
					state_here=47
					trans_col=8
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
					trans_col=8
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
				obj_outside_stairs,
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

			obj_inside_stairs = {
				data = [[
					x=1
					y=1 
					w=1
					h=1
					col_replace={5,2}
					state=state_here
					state_here=3
					classes = {class_untouchable}
				]],
				draw = function(me)
					-- switch transparency
					set_trans_col(8, true)
					-- draw stairs
					map(56,23, 68,52, 6,1)
				end,
			}

			obj_hall_rail = {		
				data = [[
					state=state_here
					x=1
					y=1
					w=1
					h=2
					z=30
					state_here=3
					classes = {class_untouchable}
				]],
				draw = function(me)
					-- switch transparency
					set_trans_col(8, true)
					-- draw stairs
					map(59,19, 100,12, 4,4)
				end,
			}

			obj_hall_exit_landing = {		
				data = [[
					name=upstairs
					state=state_open
					x=106
					y=0
					w=3
					h=2
					use_pos = pos_center
					use_dir = face_back
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_landing_exit_hall)
					end
				}
			}

			obj_hall_door_library = {		
				data = [[
					name=library
					state=state_open
					x=136
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
					x=176
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
						if me.owner == selected_actor then
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
				map = {32,24,55,31}
			]],
			objects = {
				obj_front_door_inside,
				obj_inside_stairs,
				obj_hall_rail,
				obj_hall_exit_landing,
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
					classes = { class_door }
				]],
				init = function(me)  
					me.target_door = obj_hall_door_library
				end
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
				-- dependent_on = obj_front_door_inside,
				-- dependent_on_state = "state_open",
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
					use_pos={140,40}
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
				map = {56,24,79,31}
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
					classes = { class_door }
				]],
				init = function(me)  
					me.target_door = obj_hall_door_kitchen
				end
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
					classes = { class_openable, class_door }
					use_pos = pos_left
					use_dir = face_right
				]],
				init = function(me)  
					me.target_door = obj_garden_door_kitchen
				end
			}

		rm_kitchen = {
			data = [[
				map = {80,24,103,31}
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
					classes = { class_openable, class_door }
					use_dir = face_back
				]],
				init = function(me)  
					me.target_door = obj_back_door
				end
			}

		rm_garden = {
			data = [[
				map = {104,24,127,31}
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

-- [ second floor ]
	-- landing
		-- objects
			obj_rail_left = {		
				data = [[
					state=state_here
					x=0
					y=47
					w=1
					h=2
					state_here=47
					trans_col=8
					repeat_x = 16
					classes = { class_untouchable }
				]],
			}

			obj_rail_right= {		
				data = [[
					state=state_here
					x=144
					y=47
					w=1
					h=2
					state_here=47
					trans_col=8
					repeat_x = 6
					classes = { class_untouchable }
				]],
			}

			obj_landing_exit_hall = {		
				data = [[
					name=hall
					state=state_open
					x=124
					y=56
					w=3
					h=2
					use_pos = pos_center
					use_dir = face_front
					classes = { class_door }
				]],
				init = function(me)  
					me.target_door = obj_hall_exit_landing
				end
			}

		obj_landing_door_computer = {		
			data = [[
				name = computer room
				state = state_open
				x=176
				y=16
				w=1
				h=4
				use_pos = pos_left
				use_dir = face_right
				classes = { class_door }
			]],
			init = function(me)  
				me.target_door = obj_computer_door_landing
			end
		}

		obj_landing_door_room1 = {		
				data = [[
					name = door #1
					state = state_closed
					x=8
					y=16
					z=1
					w=1
					h=4
					state_closed=79
					state_open=0
					classes = {class_openable}
					use_pos = pos_right
					use_dir = face_left
				]],
				verbs = {
					open = function(me)
						rm_landing.scripts.door_teleport(me, obj_landing_door_room3)
					end
				}
			}

		obj_landing_door_room2 = {		
				data = [[
					name = door #2
					state = state_closed
					x=48
					y=16
					z=1
					w=1
					h=3
					state_closed=78
					classes = {class_openable}
					use_pos = pos_infront
					use_dir = face_back
				]],
				verbs = {
					open = function(me)
						rm_landing.scripts.door_teleport(me, obj_landing_door_room3)
					end
				}
			}
		
		obj_landing_door_room3 = {		
				data = [[
					name = door #3
					state = state_closed
					x=136
					y=16
					z=1
					w=1
					h=3
					state_closed=78
					state_open=0
					classes = {class_openable}
					use_pos = pos_infront
					use_dir = face_back
				]],
				verbs = {
					open = function(me)
						rm_landing.scripts.door_teleport(me, obj_landing_door_room1)
					end
				}
			}
		

		rm_landing = {
			data = [[
				map = {32,16,55,31}
			]],
			objects = {
				obj_rail_left,
				obj_rail_right,
				obj_landing_exit_hall,
				obj_landing_door_room1,
				obj_landing_door_room2,
				obj_landing_door_room3,
				obj_landing_door_computer
			},
			enter = function(me)
				
			end,
			exit = function(me)

			end,
			scripts = {	  
				door_teleport = function(door1, door2)
					open_door(door1)
					break_time(10)
					put_actor_at(selected_actor,0,0,rm_void)
					close_door(door1)
					camera_pan_to(door2)
					wait_for_camera()
					open_door(door1, door2)
					break_time(10)
					come_out_door(door1, door2)
					close_door(door1,door2)
					camera_follow(selected_actor)
				end
			},
		}

	-- computer room
		-- objects
			obj_computer_door_landing = {		
				data = [[
					name = first floor
					state=state_open
					x=8
					y=16
					w=1
					h=4
					use_pos = pos_right
					use_dir = face_left
					classes = { class_door }
				]],
				init = function(me)
					me.target_door = obj_landing_door_computer
				end
			}

			obj_computer = {		
				data = [[
					name=computer
					state=state_here
					state_here=1
					x=56
					y=16
					z=1
					w=2
					h=2
					use_pos={64,40}
					use_dir = face_back
				]],
				draw = function(me)
					-- switch transparency
					set_trans_col(8, true)
					-- draw computer + table
					map(58,16, 40,28, 6,4)
				end,
				verbs = {
					lookat = function(me)
						say_line("it's old \"286\" pc-compatible")
					end,
					use = function(me)
						me.played = true
						change_room(rm_mi_title, 1)					
					end
				}
			}

			obj_cursor = {		
				data = [[
					x=56
					y=12
					w=1
					h=1
					trans_col=8
					state=1
					states={74,76}
					classes = {class_untouchable}
				]],
				verbs = {
				}
			}

		rm_computer = {
			data = [[
				map = {64,16}
			]],
			objects = {
				obj_computer_door_landing,
				obj_computer,
				obj_cursor
			},
			enter = function(me)
				-- just exited the game?
				start_script(me.scripts.anim_cursor, true) 

				if obj_computer.played then
					obj_computer.played = false
					cutscene(
						3, -- no verbs & no follow, 
						function()
							-- reset gfx,ui & player (to restore after playing mini-game)
							reload()
							reset_ui()
							selected_actor = main_actor
							camera_follow(selected_actor)
							do_anim(selected_actor, "anim_face", "face_front")
							say_line("well, that was short!:developers are so lazy...")
							--say_line("test")
						end
					) -- end cutscene
				end
			end,
			exit = function(me)
				stop_script(me.scripts.anim_cursor)
			end,
			scripts = {	  
				anim_cursor = function()
					while true do
						for f=1,2 do
							obj_cursor.state = f
							break_time(15)
						end
					end
				end
			},
		}








-- [ monkey island mini-game ]
	-- mi title "room"
		rm_mi_title = {
			data = [[
				map = {72,0}
			]],
			objects = {
			},
			enter = function(me)

				-- load embedded gfx (from sfx area)
				reload(0,0x3b00,0x800)

				-- demo intro
					cutscene(
						3, -- no verbs & no follow, 
						function()

							-- intro
							break_time(50)
							print_line("deep in the caribbean:on the isle of...; ;thimbleweed!",64,45,8,1,true)

							change_room(rm_mi_dock, 1)
							
						end
					) -- end cutscene
			end,
			exit = function()
				-- todo: anything here?
			end,
		}

	-- mi dock
		-- objects
			obj_mi_bg = {		
				data = [[
					x=0
					y=0
					w=1
					h=1
					z=-10
					classes = {class_untouchable}
					state=state_here
					state_here=1
				]],
				draw = function(me)
					map(88,0, 0,16, 40,7)
				end
			}

			obj_mi_poster = {		
				data = [[
					name=poster
					x=32
					y=40
					w=1
					h=1
				]],
				verbs = {
					lookat = function(me)
						say_line("re-elect governor marly.:\"when there's only one candidate, there's only one choice.\"")
					end
				}
			}

			obj_mi_scummdoor = {		
				data = [[
					name = door
					state=state_closed
					x=240
					y=40
					w=1
					h=2
					state_closed=43
					state_open=12
					classes = {class_openable}
					use_dir = face_back
				]],
				verbs = {
					walkto = function(me)
						if me.state == "state_open" then
							-- outro
							change_room(rm_computer, 1)
						else
							say_line("the door is closed")
						end
					end,
					open = function(me)
						open_door(me, obj_front_door_inside)
					end,
					close = function(me)
						close_door(me, obj_front_door_inside)
					end
				}
			}

		rm_mi_dock = {
			data = [[
				map = {88,8,127,15}
				trans_col = 11
			]],
			objects = {
				obj_mi_bg,
				obj_mi_poster,
				obj_mi_scummdoor
			},
			enter = function(me)
				-- 
				-- initialise game in first room entry...
				-- 
				verb_maincol = 11
				verb_hovcol = 10
				verb_shadcol = 0 
				verb_defcol = 10 

				-- set which actor the player controls by default
				selected_actor = mi_actor
				-- init actor
				put_actor_at(selected_actor, 212, 60, rm_mi_dock)

				camera_at(0)
				break_time(30)
				camera_pan_to(212,60)
				wait_for_camera()
				camera_follow(selected_actor)
				
				say_line("this all seems very famililar...")

				camera_follow(selected_actor)
			end,
			exit = function(me)
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


	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_switch_player,
			obj_switch_tent
		},
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_void,
	rm_title,
	rm_outside,
	rm_hall,
	rm_kitchen,
	rm_garden,
	rm_library,
	rm_landing,
	rm_computer,

	rm_mi_title,
	rm_mi_dock
}



--
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
			walk_speed = 0.6
			frame_delay = 5
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
			walk_speed = 0.25
			frame_delay = 5
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

	mi_actor = { 	
		data = [[
			name = guybrush
			w = 1
			h = 2
			idle = { 47, 47, 15, 47 }
			walk_anim_side = { 44, 45, 44, 46 }
			col = 7
			trans_col = 8
			walk_speed = 0.5
			frame_delay = 8
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
		inventory = {
			-- obj_switch_tent
		},
		verbs = {
			-- use = function(me)
			-- 	selected_actor = me
			-- 	camera_follow(me)
			-- end
		}
	}


-- 
-- active actors list
-- 
actors = {
	main_actor,
	purp_tentacle,
	mi_actor
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set ui colors
	reset_ui()

	-- set initial inventory (if applicable)
	pickup_obj(obj_switch_tent, main_actor)
	pickup_obj(obj_switch_player, purp_tentacle)
	
	
	-- set which actor the player controls by default
	selected_actor = main_actor
	-- init actor
	put_actor_at(selected_actor, 16, 48, rm_hall)
	--put_actor_at(selected_actor, 16, 48, rm_computer)
	
	-- make camera follow player
	-- (setting now, will be re-instated after cutscene)
	camera_follow(selected_actor)

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	--change_room(rm_title, 1) -- iris fade
--	change_room(rm_computer, 1) -- iris fade

	room_curr = rm_hall
	--room_curr = rm_computer
end


-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)



function shake(cm) if cm then
cn=1 end co=cm end function cp(cq) local cr=nil if has_flag(cq.classes,"class_talkable") then
cr="talkto"elseif has_flag(cq.classes,"class_openable") then if cq.state=="state_closed"then
cr="open"else cr="close"end else cr="lookat"end for cs in all(verbs) do ct=get_verb(cs) if ct[2]==cr then cr=cs break end
end return cr end function cu(cv,cw,cx) local cy=has_flag(cw.classes,"class_actor") if cv=="walkto"then
return elseif cv=="pickup"then if cy then
say_line"i don't need them"else say_line"i don't need that"end elseif cv=="use"then if cy then
say_line"i can't just *use* someone"end if cx then
if has_flag(cx.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cv=="give"then if cy then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cv=="lookat"then if cy then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cv=="open"then if cy then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cv=="close"then if cy then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cv=="push"or cv=="pull"then if cy then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cv=="talkto"then if cy then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cz) da=db(cz) dc=nil dd=nil end function camera_follow(de) stop_script(df) dd=de dc=nil df=function() while dd do if dd.in_room==room_curr then
da=db(dd) end yield() end end start_script(df,true) if dd.in_room!=room_curr then
change_room(dd.in_room,1) end end function camera_pan_to(cz) dc=db(cz) dd=nil df=function() while(true) do if da==dc then
dc=nil return elseif dc>da then da+=0.5 else da-=0.5 end yield() end end start_script(df,true) end function wait_for_camera() while script_running(df) do yield() end end function cutscene(dg,dh,di) dj={dg=dg,dk=cocreate(dh),dl=di,dm=dd} add(dn,dj) dp=dj break_time() end function dialog_set(dq) for msg in all(dq) do dialog_add(msg) end end function dialog_add(msg) if not dr then dr={ds={},dt=false} end
du=dv(msg,32) dw=dx(du) dy={num=#dr.ds+1,msg=msg,du=du,dz=dw} add(dr.ds,dy) end function dialog_start(col,ea) dr.col=col dr.ea=ea dr.dt=true selected_sentence=nil end function dialog_hide() dr.dt=false end function dialog_clear() dr.ds={} selected_sentence=nil end function dialog_end() dr=nil end function get_use_pos(cq) local eb=cq.use_pos local x=cq.x local y=cq.y if type(eb)=="table"then
x=eb[1] y=eb[2] elseif eb=="pos_left"then if cq.ec then
x-=(cq.w*8+4) y+=1 else x-=2 y+=((cq.h*8)-2) end elseif eb=="pos_right"then x+=(cq.w*8) y+=((cq.h*8)-2) elseif eb=="pos_above"then x+=((cq.w*8)/2)-4 y-=2 elseif eb=="pos_center"then x+=((cq.w*8)/2) y+=((cq.h*8)/2)-4 elseif eb=="pos_infront"or eb==nil then x+=((cq.w*8)/2)-4 y+=(cq.h*8)+2 end return{x=x,y=y} end function do_anim(de,ed,ee) ef={"face_front","face_left","face_back","face_right"} if ed=="anim_face"then
if type(ee)=="table"then
eg=atan2(de.x-ee.x,ee.y-de.y) eh=93*(3.1415/180) eg=eh-eg ei=eg*360 ei=ei%360 if ei<0 then ei+=360 end
ee=4-flr(ei/90) ee=ef[ee] end face_dir=ej[de.face_dir] ee=ej[ee] while face_dir!=ee do if face_dir<ee then
face_dir+=1 else face_dir-=1 end de.face_dir=ef[face_dir] de.flip=(de.face_dir=="face_left") break_time(10) end end end function open_door(ek,el) if ek.state=="state_open"then
say_line"it's already open"else ek.state="state_open"if el then el.state="state_open"end
end end function close_door(ek,el) if ek.state=="state_closed"then
say_line"it's already closed"else ek.state="state_closed"if el then el.state="state_closed"end
end end function come_out_door(em,en,eo) if en==nil then
ep("target door does not exist") return end if em.state=="state_open"then
eq=en.in_room if eq!=room_curr then
change_room(eq,eo) end local er=get_use_pos(en) put_actor_at(selected_actor,er.x,er.y,eq) es={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if en.use_dir then
et=es[en.use_dir] else et=1 end selected_actor.face_dir=et selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eu,bo) if bo==1 then
ev=0 else ev=50 end while true do ev+=bo*2 if ev>50
or ev<0 then return end if eu==1 then
ew=min(ev,32) end yield() end end function change_room(eq,eu) if eq==nil then
ep("room does not exist") return end stop_script(ex) if eu and room_curr then
fades(eu,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ey={} ez() room_curr=eq if not dd
or dd.in_room!=room_curr then da=0 end stop_talking() if eu then
ex=function() fades(eu,-1) end start_script(ex,true) else ew=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cv,fa) if not fa
or not fa.verbs then return false end if type(cv)=="table"then
if fa.verbs[cv[1]] then return true end
else if fa.verbs[cv] then return true end
end return false end function pickup_obj(cq,de) de=de or selected_actor add(de.ck,cq) cq.owner=de del(cq.in_room.objects,cq) end function start_script(fb,fc,fd,be) local dk=cocreate(fb) local scripts=ey if fc then
scripts=fe end add(scripts,{fb,dk,fd,be}) end function script_running(fb) for ff in all({ey,fe}) do for fg,fh in pairs(ff) do if fh[1]==fb then
return fh end end end return false end function stop_script(fb) fh=script_running(fb) if fh then
del(ey,fh) del(fe,fh) end end function break_time(fi) fi=fi or 1 for x=1,fi do yield() end end function wait_for_message() while fj!=nil do yield() end end function say_line(de,msg,fk,fl) if type(de)=="string"then
msg=de de=selected_actor end fm=de.y-(de.h)*8+4 fn=de print_line(msg,de.x,fm,de.col,1,fk,fl) end function stop_talking() fj,fn=nil,nil end function print_line(msg,x,y,col,fo,fk,fl) local col=col or 7 local fo=fo or 0 if fo==1 then
fp=min(x-da,127-(x-da)) else fp=127-(x-da) end local fq=max(flr(fp/2),16) local fr=""for fs=1,#msg do local ft=sub(msg,fs,fs) if ft==":"then
fr=sub(msg,fs+1) msg=sub(msg,1,fs-1) break end end local du=dv(msg,fq) local dw=dx(du) fu=x-da if fo==1 then
fu-=((dw*4)/2) end fu=max(2,fu) fm=max(18,y) fu=min(fu,127-(dw*4)-1) fj={fv=du,x=fu,y=fm,col=col,fo=fo,fw=(#msg)*8,dz=dw,fk=fk} if#fr>0 then
fx=fn wait_for_message() fn=fx print_line(fr,x,y,col,fo,fk) end if not fl then
wait_for_message() end end function put_actor_at(de,x,y,fy) if fy then de.in_room=fy end
de.x,de.y=x,y end function walk_to(de,x,y) local fz=ga(de) local gb=flr(x/8)+room_curr.map[1] local gc=flr(y/8)+room_curr.map[2] local gd={gb,gc} local ge=gf(fz,gd) local gg=ga({x=x,y=y}) if gh(gg[1],gg[2]) then
add(ge,gg) end for gi in all(ge) do local gj=(gi[1]-room_curr.map[1])*8+4 local gk=(gi[2]-room_curr.map[2])*8+4 local gl=sqrt((gj-de.x)^2+(gk-de.y)^2) local gm=de.walk_speed*(gj-de.x)/gl local gn=de.walk_speed*(gk-de.y)/gl if gl>5 then
de.go=1 de.flip=(gm<0) if abs(gm)<0.4 then
if gn>0 then
de.gp=de.walk_anim_front de.face_dir="face_front"else de.gp=de.walk_anim_back de.face_dir="face_back"end else de.gp=de.walk_anim_side de.face_dir="face_right"if de.flip then de.face_dir="face_left"end
end for fs=0,gl/de.walk_speed do de.x+=gm de.y+=gn yield() end end end de.go=2 end function wait_for_actor(de) de=de or selected_actor while de.go!=2 do yield() end end function proximity(cw,cx) if cw.in_room==cx.in_room then
local gl=sqrt((cw.x-cx.x)^2+(cw.y-cx.y)^2) return gl else return 1000 end end gq=16 da,dc,df,cn=0,nil,nil,0 gr,gs,gt,gu=63.5,63.5,0,1 gv={7,12,13,13,12,7} gw={{spr=208,x=75,y=gq+60},{spr=240,x=75,y=gq+72}} ej={face_front=1,face_left=2,face_back=3,face_right=4} function gx(cq) local gy={} for fg,cs in pairs(cq) do add(gy,fg) end return gy end function get_verb(cq) local cv={} local gy=gx(cq[1]) add(cv,gy[1]) add(cv,cq[1][gy[1]]) add(cv,cq.text) return cv end function ez() gz=get_verb(verb_default) ha,hb,o,hc,hd=nil,nil,nil,false,""end ez() fj=nil dr=nil dp=nil fn=nil fe={} ey={} dn={} he={} ew,ew=0,0 


function _init() 
-- reload(0,0,0x800,"mi_temp.p8") -- gfx pg1
-- cstore(0x3b00,0,0x800) -- sfx (last 1/2)
reload(0x3000,0x3000,0x64,"mi_temp.p8") -- gfx flags pg1
cstore(0x4300,0,0x100) -- sfx (last 1/2)

if enable_mouse then poke(0x5f2d,1) end
hf() start_script(startup_script,true) end function _update60() hg() end function _draw() hh() end function hg() if selected_actor and selected_actor.dk
and not coresume(selected_actor.dk) then selected_actor.dk=nil end hi(fe) if dp then
if dp.dk
and not coresume(dp.dk) then if dp.dg!=3
and dp.dm then camera_follow(dp.dm) selected_actor=dp.dm end del(dn,dp) dp=nil if#dn>0 then
dp=dn[#dn] end end else hi(ey) end hj() hk() hl,hm=1.5-rnd(3),1.5-rnd(3) hl=flr(hl*cn) hm=flr(hm*cn) if not co then
cn*=0.90 if cn<0.05 then cn=0 end
end end function hh() rectfill(0,0,127,127,0) camera(da+hl,0+hm) clip(0+ew-hl,gq+ew-hm,128-ew*2-hl,64-ew*2) hn() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,gq-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,gq-8,8) end if show_debuginfo then
print("x: "..flr(gr+da).." y:"..gs-gq,80,gq-8,8) end ho() if dr
and dr.dt then hp() hq() return end if hr==dp then
else hr=dp return end if not dp then
hs() end if(not dp
or dp.dg==2) and(hr==dp) then ht() else end hr=dp if not dp then
hq() end end function hj() if dp then
if btnp(4) and btnp(5) and dp.dl then
dp.dk=cocreate(dp.dl) dp.dl=nil return end return end if btn(0) then gr-=1 end
if btn(1) then gr+=1 end
if btn(2) then gs-=1 end
if btn(3) then gs+=1 end
if btnp(4) then hu(1) end
if btnp(5) then hu(2) end
if enable_mouse then
hv,hw=stat(32)-1,stat(33)-1 if hv!=hx then gr=hv end
if hw!=hy then gs=hw end
if stat(34)>0 then
if not hz then
hu(stat(34)) hz=true end else hz=false end hx=hv hy=hw end gr=mid(0,gr,127) gs=mid(0,gs,127) end function hu(ia) local ib=gz if not selected_actor then
return end if dr and dr.dt then
if ic then
selected_sentence=ic end return end if id then
gz=get_verb(id) elseif ie then if ia==1 then
if(gz[2]=="use"or gz[2]=="give")
and ha then hb=ie else ha=ie end elseif ig then gz=get_verb(ig) ha=ie gx(ha) hs() end elseif ih then if ih==gw[1] then
if selected_actor.ii>0 then
selected_actor.ii-=1 end else if selected_actor.ii+2<flr(#selected_actor.ck/4) then
selected_actor.ii+=1 end end return end if ha!=nil
and not hc then if gz[2]=="use"or gz[2]=="give"then
if hb then
elseif ha.use_with and ha.owner==selected_actor then return end end hc=true selected_actor.dk=cocreate(function() if(not ha.owner
and(not has_flag(ha.classes,"class_actor") or gz[2]!="use")) or hb then ij=hb or ha ik=get_use_pos(ij) walk_to(selected_actor,ik.x,ik.y) if selected_actor.go!=2 then return end
use_dir=ij if ij.use_dir then use_dir=ij.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gz,ha) then
start_script(ha.verbs[gz[1]],false,ha,hb) else if has_flag(ha.classes,"class_door") then
if gz[1]=="walkto"then
come_out_door(ha,ha.target_door) elseif gz[1]=="open"then open_door(ha,ha.target_door) elseif gz[1]=="close"then close_door(ha,ha.target_door) end else cu(gz[2],ha,hb) end end ez() end) coresume(selected_actor.dk) elseif gs>gq and gs<gq+64 then hc=true selected_actor.dk=cocreate(function() walk_to(selected_actor,gr+da,gs-gq) ez() end) coresume(selected_actor.dk) end end function hk() id,ig,ie,ic,ih=nil,nil,nil,nil,nil if dr
and dr.dt then for ff in all(dr.ds) do if il(ff) then
ic=ff end end return end im() for cq in all(room_curr.objects) do if(not cq.classes
or(cq.classes and not has_flag(cq.classes,"class_untouchable"))) and(not cq.dependent_on or cq.dependent_on.state==cq.dependent_on_state) then io(cq,cq.w*8,cq.h*8,da,ip) else cq.iq=nil end if il(cq) then
if not ie
or(not cq.z and ie.z<0) or(cq.z and ie.z and cq.z>ie.z) then ie=cq end end ir(cq) end for fg,de in pairs(actors) do if de.in_room==room_curr then
io(de,de.w*8,de.h*8,da,ip) ir(de) if il(de)
and de!=selected_actor then ie=de end end end if selected_actor then
for cs in all(verbs) do if il(cs) then
id=cs end end for is in all(gw) do if il(is) then
ih=is end end for fg,cq in pairs(selected_actor.ck) do if il(cq) then
ie=cq if gz[2]=="pickup"and ie.owner then
gz=nil end end if cq.owner!=selected_actor then
del(selected_actor.ck,cq) end end if gz==nil then
gz=get_verb(verb_default) end if ie then
ig=cp(ie) end end end function im() he={} for x=-64,64 do he[x]={} end end function ir(cq) fm=-1 if cq.it then
fm=cq.y else fm=cq.y+(cq.h*8) end iu=flr(fm) if cq.z then
iu=cq.z end add(he[iu],cq) end function hn() rectfill(0,gq,127,gq+64,room_curr.iv or 0) for z=-64,64 do if z==0 then
iw(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,gq,room_curr.ix,room_curr.iy) pal() else iu=he[z] for cq in all(iu) do if not has_flag(cq.classes,"class_actor") then
if cq.states
or(cq.state and cq[cq.state] and cq[cq.state]>0) and(not cq.dependent_on or cq.dependent_on.state==cq.dependent_on_state) and not cq.owner then iz(cq) end else if cq.in_room==room_curr then
ja(cq) end end jb(cq) end end end end function iw(cq) if cq.col_replace then
jc=cq.col_replace pal(jc[1],jc[2]) end if cq.lighting then
jd(cq.lighting) elseif cq.in_room then jd(cq.in_room.lighting) end end function iz(cq) iw(cq) if cq.draw then
cq.draw(cq) else je=1 if cq.repeat_x then je=cq.repeat_x end
for h=0,je-1 do local jf=0 if cq.states then
jf=cq.states[cq.state] else jf=cq[cq.state] end jg(jf,cq.x+(h*(cq.w*8)),cq.y,cq.w,cq.h,cq.trans_col,cq.flip_x) end end pal() end function ja(de) jh=ej[de.face_dir] if de.go==1
and de.gp then de.ji+=1 if de.ji>de.frame_delay then
de.ji=1 de.jj+=1 if de.jj>#de.gp then de.jj=1 end
end jk=de.gp[de.jj] else jk=de.idle[jh] end iw(de) jg(jk,de.ec,de.it,de.w,de.h,de.trans_col,de.flip,false) if fn
and fn==de and fn.talk then if de.jl<7 then
jk=de.talk[jh] jg(jk,de.ec,de.it+8,1,1,de.trans_col,de.flip,false) end de.jl+=1 if de.jl>14 then de.jl=1 end
end pal() end function hs() jm=""jn=12 jo=gz[2] if not hc then
if gz then
jm=gz[3] end if ha then
jm=jm.." "..ha.name if jo=="use"then
jm=jm.." with"elseif jo=="give"then jm=jm.." to"end end if hb then
jm=jm.." "..hb.name elseif ie and ie.name!=""and(not ha or(ha!=ie)) and(not ie.owner or jo!=get_verb(verb_default)[2]) then jm=jm.." "..ie.name end hd=jm else jm=hd jn=7 end print(jp(jm),jq(jm),gq+66,jn) end function ho() if fj then
jr=0 for js in all(fj.fv) do jt=0 if fj.fo==1 then
jt=((fj.dz*4)-(#js*4))/2 end ju(js,fj.x+jt,fj.y+jr,fj.col,0,fj.fk) jr+=6 end fj.fw-=1 if fj.fw<=0 then
stop_talking() end end end function ht() fu,fm,jv=0,75,0 for cs in all(verbs) do jw=verb_maincol if ig
and cs==ig then jw=verb_defcol end if cs==id then jw=verb_hovcol end
ct=get_verb(cs) print(ct[3],fu,fm+gq+1,verb_shadcol) print(ct[3],fu,fm+gq,jw) cs.x=fu cs.y=fm io(cs,#ct[3]*4,5,0,0) jb(cs) if#ct[3]>jv then jv=#ct[3] end
fm+=8 if fm>=95 then
fm=75 fu+=(jv+1.0)*4 jv=0 end end if selected_actor then
fu,fm=86,76 jx=selected_actor.ii*4 jy=min(jx+8,#selected_actor.ck) for jz=1,8 do rectfill(fu-1,gq+fm-1,fu+8,gq+fm+8,1) cq=selected_actor.ck[jx+jz] if cq then
cq.x,cq.y=fu,fm iz(cq) io(cq,cq.w*8,cq.h*8,0,0) jb(cq) end fu+=11 if fu>=125 then
fm+=12 fu=86 end jz+=1 end for fs=1,2 do ka=gw[fs] if ih==ka then pal(verb_maincol,7) end
jg(ka.spr,ka.x,ka.y,1,1,0) io(ka,8,7,0,0) jb(ka) pal() end end end function hp() fu,fm=0,70 for ff in all(dr.ds) do if ff.dz>0 then
ff.x,ff.y=fu,fm io(ff,ff.dz*4,#ff.du*5,0,0) jw=dr.col if ff==ic then jw=dr.ea end
for js in all(ff.du) do print(jp(js),fu,fm+gq,jw) fm+=5 end jb(ff) fm+=2 end end end function hq() col=gv[gu] pal(7,col) spr(224,gr-4,gs-3,1,1,0) pal() gt+=1 if gt>7 then
gt=1 gu+=1 if gu>#gv then gu=1 end
end end function jg(kb,x,y,w,h,kc,flip_x,kd) set_trans_col(kc,true) spr(kb,x,gq+y,w,h,flip_x,kd) end function set_trans_col(kc,cm) palt(0,false) palt(kc,true) if kc and kc>0 then
palt(0,false) end end function hf() for fy in all(rooms) do ke(fy) if(#fy.map>2) then
fy.ix=fy.map[3]-fy.map[1]+1 fy.iy=fy.map[4]-fy.map[2]+1 else fy.ix=16 fy.iy=8 end for cq in all(fy.objects) do ke(cq) cq.in_room=fy if cq.init then
cq.init(cq) end end end for kf,de in pairs(actors) do ke(de) de.go=2 de.ji=1 de.jl=1 de.jj=1 de.ck={} de.ii=0 end end function jb(cq) local kg=cq.iq if show_collision
and kg then rect(kg.x,kg.y,kg.kh,kg.ki,8) end end function hi(scripts) for fh in all(scripts) do if fh[2] and not coresume(fh[2],fh[3],fh[4]) then
del(scripts,fh) fh=nil end end end function jd(kj) if kj then kj=1-kj end
local gi=flr(mid(0,kj,1)*100) local kk={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kl=1,15 do col=kl km=(gi+(kl*1.46))/22 for fg=1,km do col=kk[col] end pal(kl,col) end end function db(cz) if type(cz)=="table"then
cz=cz.x end return mid(0,cz-64,(room_curr.ix*8)-128) end function ga(cq) local gb=flr(cq.x/8)+room_curr.map[1] local gc=flr(cq.y/8)+room_curr.map[2] return{gb,gc} end function gh(gb,gc) local kn=mget(gb,gc) local ko=fget(kn,0) return ko end function dv(msg,fq) local du={} local kp=""local kq=""local ft=""local kr=function(ks) if#kq+#kp>ks then
add(du,kp) kp=""end kp=kp..kq kq=""end for fs=1,#msg do ft=sub(msg,fs,fs) kq=kq..ft if ft==" "
or#kq>fq-1 then kr(fq) elseif#kq>fq-1 then kq=kq.."-"kr(fq) elseif ft==";"then kp=kp..sub(kq,1,#kq-1) kq=""kr(0) end end kr(fq) if kp!=""then
add(du,kp) end return du end function dx(du) dw=0 for js in all(du) do if#js>dw then dw=#js end
end return dw end function has_flag(cq,kt) for bp in all(cq) do if bp==kt then
return true end end return false end function io(cq,w,h,ku,kv) x=cq.x y=cq.y if has_flag(cq.classes,"class_actor") then
cq.ec=x-(cq.w*8)/2 cq.it=y-(cq.h*8)+1 x=cq.ec y=cq.it end cq.iq={x=x,y=y+gq,kh=x+w-1,ki=y+h+gq-1,ku=ku,kv=kv} end function gf(kw,kx) local ky,kz,la={},{},{} lb(ky,kw,0) kz[lc(kw)]=nil la[lc(kw)]=0 while#ky>0 and#ky<1000 do local ld=ky[#ky] del(ky,ky[#ky]) le=ld[1] if lc(le)==lc(kx) then
break end local lf={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local lg=le[1]+x local lh=le[2]+y if abs(x)!=abs(y) then li=1 else li=1.4 end
if lg>=room_curr.map[1] and lg<=room_curr.map[1]+room_curr.ix
and lh>=room_curr.map[2] and lh<=room_curr.map[2]+room_curr.iy and gh(lg,lh) and((abs(x)!=abs(y)) or gh(lg,le[2]) or gh(lg-x,lh)) then add(lf,{lg,lh,li}) end end end end for lj in all(lf) do local lk=lc(lj) local ll=la[lc(le)]+lj[3] if la[lk]==nil
or ll<la[lk] then la[lk]=ll local lm=ll+max(abs(kx[1]-lj[1]),abs(kx[2]-lj[2])) lb(ky,lj,lm) kz[lk]=le end end end local ge={} le=kz[lc(kx)] if le then
local ln=lc(le) local lo=lc(kw) while ln!=lo do add(ge,le) le=kz[ln] ln=lc(le) end for fs=1,#ge/2 do local lp=ge[fs] local lq=#ge-(fs-1) ge[fs]=ge[lq] ge[lq]=lp end end return ge end function lb(lr,cz,gi) if#lr>=1 then
add(lr,{}) for fs=(#lr),2,-1 do local lj=lr[fs-1] if gi<lj[2] then
lr[fs]={cz,gi} return else lr[fs]=lj end end lr[1]={cz,gi} else add(lr,{cz,gi}) end end function lc(lt) return((lt[1]+1)*16)+lt[2] end function ep(msg) print_line("-error-;"..msg,5+da,5,8,0) end function ke(cq) local du=lu(cq.data,"\n") for js in all(du) do local pairs=lu(js,"=") if#pairs==2 then
cq[pairs[1]]=lv(pairs[2]) else printh("invalid data line") end end end function lu(ff,lw) local lx={} local jx=0 local ly=0 for fs=1,#ff do local lz=sub(ff,fs,fs) if lz==lw then
add(lx,sub(ff,jx,ly)) jx=0 ly=0 elseif lz!=" "and lz!="\t"then ly=fs if jx==0 then jx=fs end
end end if jx+ly>0 then
add(lx,sub(ff,jx,ly)) end return lx end function lv(ma) local mb=sub(ma,1,1) local lx=nil if ma=="true"then
lx=true elseif ma=="false"then lx=false elseif mc(mb) then if mb=="-"then
lx=sub(ma,2,#ma)*-1 else lx=ma+0 end elseif mb=="{"then local lp=sub(ma,2,#ma-1) lx=lu(lp,",") md={} for cz in all(lx) do cz=lv(cz) add(md,cz) end lx=md else lx=ma end return lx end function mc(jc) for a=1,13 do if jc==sub("0123456789.-+",a,a) then
return true end end end function ju(me,x,y,mf,mg,fk) if not fk then me=jp(me) end
for mh=-1,1 do for mi=-1,1 do print(me,x+mh,y+mi,mg) end end print(me,x,y,mf) end function jq(ff) return 63.5-flr((#ff*4)/2) end function mj(ff) return 61 end function il(cq) if not cq.iq then return false end
iq=cq.iq if(gr+iq.ku>iq.kh or gr+iq.ku<iq.x)
or(gs>iq.ki or gs<iq.y) then return false else return true end end function jp(ff) local a=""local js,jc,lr=false,false for fs=1,#ff do local is=sub(ff,fs,fs) if is=="^"then
if jc then a=a..is end
jc=not jc elseif is=="~"then if lr then a=a..is end
lr,js=not lr,not js else if jc==js and is>="a"and is<="z"then
for kl=1,26 do if is==sub("abcdefghijklmnopqrstuvwxyz",kl,kl) then
is=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kl,kl) break end end end a=a..is jc,lr=false,false end end return a end

















__gfx__
0000000000000000000000000000000044444444440000004444444477777777f9e9f9f9ddd5ddd5bbbbbbbb5500000015151515000000000000000000000000
00000000000000000000000000000000444444404400000044444444777777779eee9f9fdd5ddd5dbbbbbbbb5555000051515151000000000000000000000000
00800800000000000000000000000000aaaaaa00aaaa000005aaaaaa77777777feeef9f9d5ddd5ddbbbbbbbb5555550015151515000000000000000000000000
0008800055555555ddddddddeeeeeeee999990009999000005999999777777779fef9fef5ddd5dddbbbbbbbb5555555551515151000000000000000000000000
0008800055555555ddddddddeeeeeeee44440000444444000005444477777777f9f9feeeddd5ddd5bbbbbbbb5555555515151515000000000000000000000000
0080080055555555ddddddddeeeeeeee444000004444440000054444777777779f9f9eeedd5ddd5dbbbbbbbb5555555551515151000000000000000000000000
0000000055555555ddddddddeeeeeeeeaa000000aaaaaaaa000005aa77777777f9f9feeed5ddd5ddbbbbbbbb5555555515151515000000000000000000000000
0000000055555555ddddddddeeeeeeee900000009999999900000599777777779f9f9fef5ddd5dddbbbbbbbb5555555551515151000000000000000000000000
0000000077777755666666ddbbbbbbee888888553333333313131344666666665888858866666666cbcbcbcb0000005515151544000000000000000088845888
00000000777755556666ddddbbbbeeee88888855333333333131314466666666588885881c1c1c1cbcbcbcbc0000555551515144000000000000000088845888
000010007755555566ddddddbbeeeeee88887777333333331313aaaa6666666655555555c1c1c1c1cbcbcbcb005555551515aaaa000000000000000088845888
0000c00055555555ddddddddeeeeeeee88886666333333333131999966666666888588881c1c1c1cbcbcbcbc5555555551519999000000000000000088845888
001c7c1055555555ddddddddeeeeeeee8855555533333333134444446666666688858888c1c1c1c1cbcbcbcb5555555515444444000000000000000088845888
0000c00055555555ddddddddeeeeeeee88555555333333333144444466666666555555551c1c1c1cbcbcbcbc5555555551444444000000000000000088845888
0000100055555555ddddddddeeeeeeee7777777733333333aaaaaaaa6666666658888588c1c1c1c1cbcbcbcb55555555aaaaaaaa000000000000000088845888
0000000055555555ddddddddeeeeeeee66666666333333339999999966666666588885887c7c7c7cbcbcbcbc5555555599999999000000000000000088845888
0000000055777777dd666666eebbbbbb558888885555555544444444777777777777777755555555444444454444444444444445000000008888888999999999
0000000055557777dddd6666eeeebbbb5588888855553333444444447777777777777777555555554444445c4444444444444458000000008888889444444444
0000000055555577dddddd66eeeeeebb7777888855333333aaaaaaaa777777777777777755555555444445cbaaaaaa4444444588000000008888894888845888
000c000055555555ddddddddeeeeeeee66668888533333339999999977777777777777775555555544445cbc9999994444445888000000008888948888845888
0000000055555555ddddddddeeeeeeee5555558853333333444444447777775555777777555555554445cbcb4444444444458888000000008889488888845888
0000000055555555ddddddddeeeeeeee555555885533333344444444777755555555777755555555445cbcbc4444444444588888000000008894588888845888
0000000055555555ddddddddeeeeeeee7777777755553333aaaaaaaa77555555555555770000000045cbcbcbaa44444445888888000000008944588888845888
0000000055555555ddddddddeeeeeeee6666666655555555999999995555555555555555000000005cbcbcbc9944444458888888000000009484588888845888
0000000055555555ddddddddbbbbbbbb555555555555555544444444cccccccc5555555677777777c77777776555555533333336633333338884588988845888
0000000055555555ddddddddbbbbbbbb555555553333555544444444cccccccc555555677777777ccc7777777655555533333367763333338884589488845888
0000000055555555ddddddddbbbbbbbb7777777733333355aaaaaa50cccccccc55555677777777ccccc777777765555533333677776333338884594488845888
0000000055555555ddddddddbbbbbbbb666666663333333599999950cccccccc5555677777777ccccccc77777776555533336777777633338884944488845888
0000000055555555ddddddddbbbbbbbb555555553333333544445000cccccccc555677777777ccccccccc7777777655533367777777763338889444488845888
0000000055555555ddddddddbbbbbbbb555555553333335544445000cccccccc55677777777ccccccccccc777777765533677777777776338894444488845888
0b03000055555555ddddddddbbbbbbbb7777777733335555aa500000cccccccc5677777777ccccccccccccc77777776536777777777777638944444499999999
b00030b055555555ddddddddbbbbbbbb666666665555555599500000cccccccc677777777ccccccccccccccc7777777667777777777777769444444455555555
0000000000000000000000000000000077777777777777777755555555555577cbcbcb4444cbcbcb888888888888888888888888d00000004444444444444444
9f00d70000000000000000000000000070000007700000077070000000000707bcbcbc40040cbcbc888888888888888888888888d50000004ffffff44ffffff4
9f2ed72800000000000000000000000070000007700000077007000000007007cbcbc4444440cbcb888888888888888888888888d51000004f4444944f444494
9f2ed72800000000000000000000000070000007700000077000600000060007bcbc440000440cbc888888888888888888888888d51000004f4444944f444494
9f2ed72800000000000000000000000070000007700000077000600000060007cbc44022220440cb888666666666688888866666d51000004f4444944f444494
9f2ed72800000000000000000000000070000007700000077000600000060007bc4402555540440c888600000000688888860000d51000004f4444944f444494
9f2ed72800000000000000000000000070000007700000077000600000060007c4402500aa54040b888600000000688888860b00d51000004f4444944f444494
4444444400000000000000000000000077777777777777777777600000067777b4405aaaaaa50440888600000000688888860000d51000004f4444944f444494
0000000000000000000000000000000070000067760000077006600000066007c440aa5555aa0440888600000000688800000000d51000004f4444944f444494
00cd006500000000000a00000000000070000607706000077060600000060607b002a59aa95a2000888600000000688800000000d51000004f9999944f444494
b3cd826500000000000000000000000070000507705000077050600000060507cb4759a5aa95040b888600000000688800000000d5100000444444444f449994
b3cd826500a0a000000aa000000a0a0070000007700000077000600000060007bc475aa5aaa5040c888666666666688800000000d5100000444444444f994444
b3cd826500aaaa0000aaaa0000aaa00070000007700000077005000000005007cb475aa955a5040b888888555588888800000000d510000049a4444444444444
b3cd826500a9aa0000a99a0000aa9a0070000007700000077050000000000507bc4759aaaa95040c866666666666666800000000d51000004994444444444444
b3cd826500a99a0000a99a0000a99a0077777777777777777500000000000077cb47a59aa95a040b866666666555666800000000d51000004444444449a44444
4444444400444400004444000044440055555555555555555555555555555555bc47aa5555aa040c866666666666666800000000d51000004ffffff449944444
9999999977777777777777777777777770000007777600007777777777777777cb4744aaaa44040b4424a0000002450477777777d51000004f44449444444444
5555555555555555555555555555555570000007777600005555555555555555bc4222222222240c4424a0000002450455555555d51000004f4444944444fff4
444444441dd6dd6dd6dd6dd6d6dd6d5170000007777600004444444444444444cb0000000000000b4424a0000002450444444444d51000004f4444944fff4494
ffff4fff1dd6dd6dd6dd6dd6d6dd6d517000000766665555444ffffffffff444b0444444444444004424a0000002450444444444d51000004f4444944f444494
4449494416666666666666666666665170000007000077764449444444449444cb0000000000000b4424a0000002450444444444d51000004f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd65170000007000077764449444aa4449444bc2444444444450c4424a2222222450444444444d51111114f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd65177777777000077764449444444449444cb24aaaaaaaa450b992444444444450944444444d55555554ffffff44f444494
4449494416666666666666666666665155555555555566664449999999999444bc24a0000002450c442440000009450444444444dddddddd444444444f444494
444949441dd6dd600000000056dd6d516dd6dd6d0000000044494444444494449924a00000024509552440555559450588944488000000004f4444944f444494
444949441dd6dd650000000056dd6d51666666660000000044494444444494445524a00000024505555555555555555588944488000000004f4444944f444994
44494944166666650000000056666651d6dd6dd60000000044494444444494444424a00000024504555555555555555588944488000000004f4444944f499444
444949441d6dd6d5000000005d6dd651d6dd6dd6000000004449444444449444ff24a0000002450f555555555555555588944488000000004f4444944f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494444424a00000024504555555555555555588944488000000004f44449444444400
444949441666666500000000566666516dd6dd6d0000000044494444444494444424a00000024504555555555555555588944488000000004f44449444440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994444424a00000024504555555555555555588944488000000004f44449444000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444444424a00000024504555555555555555588944488000000004f44449400000000
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
0001010101010100000000010000000000010101010101000000000101000000000101010101010101010101000000000001010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101010101010101010101010101010101010101010101010101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020202020202020202020202020202020202020202020202020202020202020202020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303030303030303030303030303030303030303030303030303030303030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040404040404040404040404040404040404040404040404040404040404040404040404040404
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005050505050505050505050505050505050505050505050505050505050505050505050505050505
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015151515151515151515151515151515151615151515151515151515151515151515151515151515
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000025252525252525252525252525252525252625252525252525252525252525252525252525252525
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017191a000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000270a2a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001718282a0000000000000000000000000000000000000000000000001718191a0000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000280a282a00000000000000000000000000000000000000000000000027280a2a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828191a00000000000000000000000000000000000000001718281b282a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828382a0000000000000000000000000000000000001718280a0a282b2a1718191a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828282a0000000000000000000000000000000000003737272828283b2a270a282a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021222122212221222122212221222122212221222122212221223233323332333233323332333233
00000000000000000020000000000020070707171717171717171717170707070707071a1a1a1a1a1a1a405040501a1a1a1a1a1a1a070707484900004a4b000007070709090909090909090909070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00200000000000000000000000100000070707171717171717171717170707070707071a1a1a1a1a1a1a504050401a1a1a1a1a1a1a070707585900005a5b000007070709444509090909444509070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00000020000000000000000000000000070007171717171717171717170700070700071a1a1a001a1a1a405040501a1a1a001a1a1a070007686966676c6c666707000709545509090909545509070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
000000000000000000000000000000000700071717171717171717171707000707000762626200626262666766676262620062626207000778797c002e1f3e7c07000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000000000070007171717171717171717170700070700077474740074747476777677747474007474740700076a6b002e1f3e2a0007000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000002000070111313131313131313131312101070701113131313131313131313131313131313131312101077a7b001f3e2a000007011131313131313131313131212807070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
00000000001000000020000000000000113131313131313131313131313131211131313131313125151515151515153531313131313131210000003e2c00000011313131313125151535313131313121113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
2000000000000000000020000000000031313131313131313131313131313131292929292929292929292929292929292626292929292929143434343424000031313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
00000010000020000000000061626262626262626262626262626263000000100707071a48491a1a1a1a0c0c0c0c1c2b2a1a1a1a1a070707070707504050405040504040405040504050405040070707171717090909090909090909090909090909090909171717000000100000616262626262626262626262626200000010
00200000000000100000002071447144714473004e71447344734473000020000707071a58591a1a1a1a0c0c0c1c2b2a1a1a1a1a1a07070707070740504050405040504050405040504050405007070717171709090909090909444444450909090909090917171700200000002071447474744473b271447474447400002000
20000000002000000020000071647164716473005e71647364736473200000000700071a68691a1a1a1a0c0c1c2b2a1a4e001a1a1a070007070707504050005050504050405040004050405040070707170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f
00002000000000002000000062626262626273006e7162626262626300000020070007607879606060600c1c2b6060605e00606060070007070707606060006060606162636060006060606060070707170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f
303030303030303030301b3131313131313131253531313131313131310b3030070007706a6b707070703434347070706e00707070070007070707707070007070707172737070007070707070070707170017767776777677767776777677767776777677170017151515151515151515151515151515151515151515151515
1515151515151515151518181818181818181834341818181818181818181515070111317a7b31313131313131313131313131313121010707271131313131313131313131313131313131313121280717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d15151515
1515151515151515151515151515151515151515151515151515151515151515113131313131312515151515151515353131313131313121113131313131312515151515151515353131313131313121123232323232323232323232323232323232323232323222153c3937373737378e373737373737373737373a3d151515
15151515151515151515151515151515151515151515151515151515151515153131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323232323232323232323c393737373737373737373737373737373737373a3d1515
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
010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10001000014000140001400014001c4011c4011c0611c0611c0611c0612e37e2e37e04124041243b65b3b65b00000000003f77f3f77f114011140100000000000000000000086490824800000000000000000000
010101011000110001114011140101701017010170c0170c2e37e2e37e04124041243b6543065b10640192003f77f3f77f1164919641000000000000000000001864909248000400020000400004000140001400
1111111111061110611c0611c0611c0611c0612e37e2e37e04124041243b2200045b102501a2003f77f3f77f2125a2a2510000000000000000000018649092480000808000000000000000001000011000110001
1c1c1c1c1140c1140c0170c0170c2e37e2e37e0412404124041000000000000000003f77f3f77f2125a2a25100000000000000000000086490824800008080000100001000014000140001400014001c4011c401
c1c1c1c11c0611c0612e37e2e37e04124041240000000000102501a2003f77f3f77f2125a2a251000000000000000000000867f08248000400020000000000001000010000100011000111401114010170101701
eeeeeeee2e37e2e37e04124041240000000000102501a2003f77f3f77f2125a2a251000000000000000000003853707248000000000000400004000140001400014000140011061110611c0611c0611c0611c061
444444440412404124000000000000000000003f77f3f77f2125a2a251000000000000000000003753737148000000000000000000000000100001100011000111401114011140c1140c0170c0170c2e37e2e37e
00bbbbbb000000000000000000003f77f3f77f2125a2a251000000000000000000003f53737348000000000008248082481d76d1d76d11401114011c0611c0611c0611c0611c0611c0613b65b3b65b3b65b3b224
bbbbbbbb3b65b3b65b00000000002125a2a251000000000000000000003f53737348000000000008248082481d76d1d76d11401114010170c0170c0170c0170c0170c0170c3b65b3b65b3b65b04100000003b65b
0001010000000000002125a2a251000000000000000000001f52030348000000100008248082481d76d1d76d11401114011c0611c0611c0611c0611c0611c0613b65b3b65b3b22400000000000045b3b65b3b65b
a1aaaa1a2125a2a251000000000000000000001852000248000000c00008248082481d76d1d76d11401114010170c0170c2170e2170e2170e2170e3b65b3b65b041000000000000000003b65b3b65b0000000000
000000000000000000000000000018100002480040c0770008248082481d76d1d76d11401114011c0611c0612c0622c0622e0722e0723b65b3b224000000000000000000000045b3b65b10000100002125a2a251
0000000000000000000800800248000000c00008248082481d76d1d76d11401114010170c0170c2231e2231e227491921e3b65b0410000000000000000000000000003b65b00401010002125a2a2510000000000
888787880863807248000000100008248082481d76d1d76d11401114012c0622c06229442294421e25a2a6423b2240000000000000000000000000000000045b00000000002125a2a25100000000000000000000
00000000000000000008248082481d76d1d76d11401114012e37e2e37e19649196492925a2a259041000000000000000000000000000000000000000000000002125a2a251000000000000000000000800800048
49490049114010050111020114013c16c0736c1c26e2836e117011d4011160e2e7093b6540000000000000003b65b3b65b000003065b114011140108649092480864909248086490924808649092480000000000
1010101009544095440c36c0c36c0e37c0e37c1140111401110711e0713b6540000000000000003b65b3b65b000003065b01000000011864f0f2481864f0f2481864f0f2481864f0f24800000000001000110001
cccccccc0c7370c7370c35c0c35c1146d1146d1105a114013b6540000000000000003b65b3b65b000003065b01400000011967f0f2481867f0f2481867f0f2481867f0f2480000c0000039500014000140001400
77cc99cc0e37c0e37c11401114011e4011e05a3b6540000000000000003b65b3b65b000003065b01400000010864f0f2480964f0f2480964f0f2480964f0f2480000000000004311000139101100013753c0c36c
111111110c3611140111071114013b6540000000000000003b65b3b65b000003065b014000000108637082480863708248086370824808637082480000000000004400000000430000000c36c0c36c0e37c0e37c
e111a1ae110511e0513b6540000000000000003b65b3b65b000003065b014000000138537072483853707248385370724838537072480000000000000200000000440000000c36c375372c37e2c25a114010c36c
bb4b00003b6540000000000000003b65b3b65b000003065b014000000138537373483853707248381370724838537072480000000000000211c061000211c0610c36c0c36c0c36c0c36c11401114011140111401
0011000100000000003b65b3b65b000003065b014011100138337373483853627578385363757838337373480c36c0c36c3341333413000000000000000000000140001400000000000010401104013b6543065b
11111111117011d4011160e2e709010000000138337373483f137275782f5373657838337373480c36c0c36c3341333413000000000000000000001000110001000000000011401114013b6543065b1040111400
11aa1111110711e071010001000138775393480f200092480f6250924838779303480c36c0c36c334133341300000000000000d1d3000140001400000000000011001110013b6543065b10402124001146d1146d
01000010010000000108625002480820000248086250024818520002480c36c0c36c3341333413000001076d01461114001000110001000000000011401114013b6543065b1000f0f40011401114011e4011e05a
8800808808620002480820000248086250024818100002480c36c0c36c33413334131076d1d40110700000010140001400000000000010401104013b6543065b0042f1f1000c3611140111071114010100000001
588500881852000048185200004808008002480c36c0c36c33413334131d4010100010000000001000110001000000000011401114013b6543065b10401114001140111401110511e05101000000010820000248
78880085185280004838538062480c36c0c36c3341333413010000000000000000000140001400000000000011001110013b6543065b1040111020114010c36c217012127a010000000108200002482814800038
6680608818638062480c36c0c36c3341333413000000000000000000001000110001000000000011401114013b6543065b1000101500114011140111401114010100000001082361514808008281480800818148
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

