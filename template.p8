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

			obj_hall_exit_landing = {		
				data = [[
					name=upstairs
					state=state_open
					x=88
					y=0
					w=2
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
					y=56
					w=1
					h=1
					state_here=47
					repeat_x = 10
					classes = {class_untouchable}
				]],
			}

			obj_rail_right= {		
				data = [[
					state=state_here
					x=112
					y=56
					w=1
					h=1
					state_here=47
					repeat_x = 10
					classes = {class_untouchable}
				]],
			}

			obj_landing_exit_hall = {		
				data = [[
					name=hall
					state=state_open
					x=80
					y=56
					w=4
					h=2
					use_pos = pos_center
					use_dir = face_front
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_hall_exit_landing)
					end
				}
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
			]],
			verbs = {
				walkto = function(me)
					come_out_door(me, obj_computer_door_landing)
				end
			}
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
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_landing_door_computer)
					end
				}
			}

			obj_computer = {		
				data = [[
					name=computer
					state=state_here
					x=56
					y=16
					z=1
					w=2
					h=2
					trans_col=8
					state_here=74
					use_pos={64,48}
					use_dir = face_back
				]],
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
					y=16
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
							say_line("well, that was short!;developers are so lazy")
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
						-- outro
						--selected_actor = main_actor
						--camera_follow(selected_actor)
						change_room(rm_computer, 1)
						--change_room(rm_title, 1)
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

				if not me.done_intro then
					-- don't do this again
					me.done_intro = true
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

				end
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
	put_actor_at(selected_actor, 16, 48, rm_computer)
	-- make camera follow player
	-- (setting now, will be re-instated after cutscene)
	camera_follow(selected_actor)
--	change_room(rm_computer, 1) -- iris fade
	

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	--change_room(rm_title, 1) -- iris fade

	room_curr = rm_computer
end


-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(cj) if cj then
ck=1 end cl=cj end function cm(cn) local co=nil if has_flag(cn.classes,"class_talkable") then
co="talkto"elseif has_flag(cn.classes,"class_openable") then if cn.state=="state_closed"then
co="open"else co="close"end else co="lookat"end for cp in all(verbs) do cq=get_verb(cp) if cq[2]==co then co=cp break end
end return co end function cr(cs,ct,cu) local cv=has_flag(ct.classes,"class_actor") if cs=="walkto"then
return elseif cs=="pickup"then if cv then
say_line"i don't need them"else say_line"i don't need that"end elseif cs=="use"then if cv then
say_line"i can't just *use* someone"end if cu then
if has_flag(cu.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cs=="give"then if cv then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cs=="lookat"then if cv then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cs=="open"then if cv then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cs=="close"then if cv then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cs=="push"or cs=="pull"then if cv then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cs=="talkto"then if cv then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cw) cx=cy(cw) cz=nil da=nil end function camera_follow(db) stop_script(dc) da=db cz=nil dc=function() while da do if da.in_room==room_curr then
cx=cy(da) end yield() end end start_script(dc,true) if da.in_room!=room_curr then
change_room(da.in_room,1) end end function camera_pan_to(cw) cz=cy(cw) da=nil dc=function() while(true) do if cx==cz then
cz=nil return elseif cz>cx then cx+=0.5 else cx-=0.5 end yield() end end start_script(dc,true) end function wait_for_camera() while script_running(dc) do yield() end end function cutscene(dd,de,df) dg={dd=dd,dh=cocreate(de),di=df,dj=da} add(dk,dg) dl=dg break_time() end function dialog_set(dm) for msg in all(dm) do dialog_add(msg) end end function dialog_add(msg) if not dn then dn={dp={},dq=false} end
dr=ds(msg,32) dt=du(dr) dv={num=#dn.dp+1,msg=msg,dr=dr,dw=dt} add(dn.dp,dv) end function dialog_start(col,dx) dn.col=col dn.dx=dx dn.dq=true selected_sentence=nil end function dialog_hide() dn.dq=false end function dialog_clear() dn.dp={} selected_sentence=nil end function dialog_end() dn=nil end function get_use_pos(cn) local dy=cn.use_pos local x=cn.x local y=cn.y if type(dy)=="table"then
x=dy[1] y=dy[2] elseif dy=="pos_left"then if cn.dz then
x-=(cn.w*8+4) y+=1 else x-=2 y+=((cn.h*8)-2) end elseif dy=="pos_right"then x+=(cn.w*8) y+=((cn.h*8)-2) elseif dy=="pos_above"then x+=((cn.w*8)/2)-4 y-=2 elseif dy=="pos_center"then x+=((cn.w*8)/2) y+=((cn.h*8)/2)-4 elseif dy=="pos_infront"or dy==nil then x+=((cn.w*8)/2)-4 y+=(cn.h*8)+2 end return{x=x,y=y} end function do_anim(db,ea,eb) ec={"face_front","face_left","face_back","face_right"} if ea=="anim_face"then
if type(eb)=="table"then
ed=atan2(db.x-eb.x,eb.y-db.y) ee=93*(3.1415/180) ed=ee-ed ef=ed*360 ef=ef%360 if ef<0 then ef+=360 end
eb=4-flr(ef/90) eb=ec[eb] end face_dir=eg[db.face_dir] eb=eg[eb] while face_dir!=eb do if face_dir<eb then
face_dir+=1 else face_dir-=1 end db.face_dir=ec[face_dir] db.flip=(db.face_dir=="face_left") break_time(10) end end end function open_door(eh,ei) if eh.state=="state_open"then
say_line"it's already open"else eh.state="state_open"if ei then ei.state="state_open"end
end end function close_door(eh,ei) if eh.state=="state_closed"then
say_line"it's already closed"else eh.state="state_closed"if ei then ei.state="state_closed"end
end end function come_out_door(ej,ek,el) if ek==nil then
em("exit door does not exist") return end if ej.state=="state_open"then
en=ek.in_room if en!=room_curr then
change_room(en,el) end local eo=get_use_pos(ek) put_actor_at(selected_actor,eo.x,eo.y,en) ep={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if ek.use_dir then
eq=ep[ek.use_dir] else eq=1 end selected_actor.face_dir=eq selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(er,bq) if bq==1 then
es=0 else es=50 end while true do es+=bq*2 if es>50
or es<0 then return end if er==1 then
et=min(es,32) end yield() end end function change_room(en,er) if en==nil then
em("room does not exist") return end stop_script(eu) if er and room_curr then
fades(er,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ev={} ew() room_curr=en if not da
or da.in_room!=room_curr then cx=0 end stop_talking() if er then
eu=function() fades(er,-1) end start_script(eu,true) else et=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cs,ex) if not ex
or not ex.verbs then return false end if type(cs)=="table"then
if ex.verbs[cs[1]] then return true end
else if ex.verbs[cs] then return true end
end return false end function pickup_obj(cn,db) db=db or selected_actor add(db.ch,cn) cn.owner=db del(cn.in_room.objects,cn) end function start_script(ey,ez,fa,bh) local dh=cocreate(ey) local scripts=ev if ez then
scripts=fb end add(scripts,{ey,dh,fa,bh}) end function script_running(ey) for fc in all({ev,fb}) do for fd,fe in pairs(fc) do if fe[1]==ey then
return fe end end end return false end function stop_script(ey) fe=script_running(ey) if fe then
del(ev,fe) del(fb,fe) end end function break_time(ff) ff=ff or 1 for x=1,ff do yield() end end function wait_for_message() while fg!=nil do yield() end end function say_line(db,msg,fh,fi) if type(db)=="string"then
msg=db db=selected_actor end fj=db.y-(db.h)*8+4 fk=db print_line(msg,db.x,fj,db.col,1,fh,fi) end function stop_talking() fg,fk=nil,nil end function print_line(msg,x,y,col,fl,fh,fi) local col=col or 7 local fl=fl or 0 if fl==1 then
fm=min(x-cx,127-(x-cx)) else fm=127-(x-cx) end local fn=max(flr(fm/2),16) local fo=""for fp=1,#msg do local fq=sub(msg,fp,fp) if fq==":"then
fo=sub(msg,fp+1) msg=sub(msg,1,fp-1) break end end local dr=ds(msg,fn) local dt=du(dr) fr=x-cx if fl==1 then
fr-=((dt*4)/2) end fr=max(2,fr) fj=max(18,y) fr=min(fr,127-(dt*4)-1) fg={fs=dr,x=fr,y=fj,col=col,fl=fl,ft=(#msg)*8,dw=dt,fh=fh} if#fo>0 then
fu=fk wait_for_message() fk=fu print_line(fo,x,y,col,fl,fh) end if not fi then
wait_for_message() end end function put_actor_at(db,x,y,fv) if fv then db.in_room=fv end
db.x,db.y=x,y end function walk_to(db,x,y) local fw=fx(db) local fy=flr(x/8)+room_curr.map[1] local fz=flr(y/8)+room_curr.map[2] local ga={fy,fz} local gb=gc(fw,ga) local gd=fx({x=x,y=y}) if ge(gd[1],gd[2]) then
add(gb,gd) end for gf in all(gb) do local gg=(gf[1]-room_curr.map[1])*8+4 local gh=(gf[2]-room_curr.map[2])*8+4 local gi=sqrt((gg-db.x)^2+(gh-db.y)^2) local gj=db.walk_speed*(gg-db.x)/gi local gk=db.walk_speed*(gh-db.y)/gi if gi>5 then
db.gl=1 db.flip=(gj<0) if abs(gj)<0.4 then
if gk>0 then
db.gm=db.walk_anim_front db.face_dir="face_front"else db.gm=db.walk_anim_back db.face_dir="face_back"end else db.gm=db.walk_anim_side db.face_dir="face_right"if db.flip then db.face_dir="face_left"end
end for fp=0,gi/db.walk_speed do db.x+=gj db.y+=gk yield() end end end db.gl=2 end function wait_for_actor(db) db=db or selected_actor while db.gl!=2 do yield() end end function proximity(ct,cu) if ct.in_room==cu.in_room then
local gi=sqrt((ct.x-cu.x)^2+(ct.y-cu.y)^2) return gi else return 1000 end end gn=16 cx,cz,dc,ck=0,nil,nil,0 go,gp,gq,gr=63.5,63.5,0,1 gs={7,12,13,13,12,7} gt={{spr=208,x=75,y=gn+60},{spr=240,x=75,y=gn+72}} eg={face_front=1,face_left=2,face_back=3,face_right=4} function gu(cn) local gv={} for fd,cp in pairs(cn) do add(gv,fd) end return gv end function get_verb(cn) local cs={} local gv=gu(cn[1]) add(cs,gv[1]) add(cs,cn[1][gv[1]]) add(cs,cn.text) return cs end function ew() gw=get_verb(verb_default) gx,gy,o,gz,ha=nil,nil,nil,false,""end ew() fg=nil dn=nil dl=nil fk=nil fb={} ev={} dk={} hb={} et,et=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
hc() start_script(startup_script,true) end function _update60() hd() end function _draw() he() end function hd() if selected_actor and selected_actor.dh
and not coresume(selected_actor.dh) then selected_actor.dh=nil end hf(fb) if dl then
if dl.dh
and not coresume(dl.dh) then if dl.dd!=3
and dl.dj then camera_follow(dl.dj) selected_actor=dl.dj end del(dk,dl) dl=nil if#dk>0 then
dl=dk[#dk] end end else hf(ev) end hg() hh() hi,hj=1.5-rnd(3),1.5-rnd(3) hi=flr(hi*ck) hj=flr(hj*ck) if not cl then
ck*=0.90 if ck<0.05 then ck=0 end
end end function he() rectfill(0,0,127,127,0) camera(cx+hi,0+hj) clip(0+et-hi,gn+et-hj,128-et*2-hi,64-et*2) hk() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,gn-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,gn-8,8) end if show_debuginfo then
print("x: "..flr(go+cx).." y:"..gp-gn,80,gn-8,8) end hl() if dn
and dn.dq then hm() hn() return end if ho==dl then
else ho=dl return end if not dl then
hp() end if(not dl
or dl.dd==2) and(ho==dl) then hq() else end ho=dl if not dl then
hn() end end function hg() if dl then
if btnp(4) and btnp(5) and dl.di then
dl.dh=cocreate(dl.di) dl.di=nil return end return end if btn(0) then go-=1 end
if btn(1) then go+=1 end
if btn(2) then gp-=1 end
if btn(3) then gp+=1 end
if btnp(4) then hr(1) end
if btnp(5) then hr(2) end
if enable_mouse then
hs,ht=stat(32)-1,stat(33)-1 if hs!=hu then go=hs end
if ht!=hv then gp=ht end
if stat(34)>0 then
if not hw then
hr(stat(34)) hw=true end else hw=false end hu=hs hv=ht end go=mid(0,go,127) gp=mid(0,gp,127) end function hr(hx) local hy=gw if not selected_actor then
return end if dn and dn.dq then
if hz then
selected_sentence=hz end return end if ia then
gw=get_verb(ia) elseif ib then if hx==1 then
if(gw[2]=="use"or gw[2]=="give")
and gx then gy=ib else gx=ib end elseif ic then gw=get_verb(ic) gx=ib gu(gx) hp() end elseif id then if id==gt[1] then
if selected_actor.ie>0 then
selected_actor.ie-=1 end else if selected_actor.ie+2<flr(#selected_actor.ch/4) then
selected_actor.ie+=1 end end return end if gx!=nil
and not gz then if gw[2]=="use"or gw[2]=="give"then
if gy then
elseif gx.use_with and gx.owner==selected_actor then return end end gz=true selected_actor.dh=cocreate(function() if(not gx.owner
and(not has_flag(gx.classes,"class_actor") or gw[2]!="use")) or gy then ig=gy or gx ih=get_use_pos(ig) walk_to(selected_actor,ih.x,ih.y) if selected_actor.gl!=2 then return end
use_dir=ig if ig.use_dir then use_dir=ig.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gw,gx) then
start_script(gx.verbs[gw[1]],false,gx,gy) else cr(gw[2],gx,gy) end ew() end) coresume(selected_actor.dh) elseif gp>gn and gp<gn+64 then gz=true selected_actor.dh=cocreate(function() walk_to(selected_actor,go+cx,gp-gn) ew() end) coresume(selected_actor.dh) end end function hh() ia,ic,ib,hz,id=nil,nil,nil,nil,nil if dn
and dn.dq then for fc in all(dn.dp) do if ii(fc) then
hz=fc end end return end ij() for cn in all(room_curr.objects) do if(not cn.classes
or(cn.classes and not has_flag(cn.classes,"class_untouchable"))) and(not cn.dependent_on or cn.dependent_on.state==cn.dependent_on_state) then ik(cn,cn.w*8,cn.h*8,cx,il) else cn.im=nil end if ii(cn) then
if not ib
or(not cn.z and ib.z<0) or(cn.z and ib.z and cn.z>ib.z) then ib=cn end end io(cn) end for fd,db in pairs(actors) do if db.in_room==room_curr then
ik(db,db.w*8,db.h*8,cx,il) io(db) if ii(db)
and db!=selected_actor then ib=db end end end if selected_actor then
for cp in all(verbs) do if ii(cp) then
ia=cp end end for ip in all(gt) do if ii(ip) then
id=ip end end for fd,cn in pairs(selected_actor.ch) do if ii(cn) then
ib=cn if gw[2]=="pickup"and ib.owner then
gw=nil end end if cn.owner!=selected_actor then
del(selected_actor.ch,cn) end end if gw==nil then
gw=get_verb(verb_default) end if ib then
ic=cm(ib) end end end function ij() hb={} for x=-64,64 do hb[x]={} end end function io(cn) fj=-1 if cn.iq then
fj=cn.y else fj=cn.y+(cn.h*8) end ir=flr(fj) if cn.z then
ir=cn.z end add(hb[ir],cn) end function hk() rectfill(0,gn,127,gn+64,room_curr.is or 0) for z=-64,64 do if z==0 then
it(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,gn,room_curr.iu,room_curr.iv) pal() else ir=hb[z] for cn in all(ir) do if not has_flag(cn.classes,"class_actor") then
if cn.states
or(cn.state and cn[cn.state] and cn[cn.state]>0) and(not cn.dependent_on or cn.dependent_on.state==cn.dependent_on_state) and not cn.owner then iw(cn) end else if cn.in_room==room_curr then
ix(cn) end end iy(cn) end end end end function it(cn) if cn.col_replace then
iz=cn.col_replace pal(iz[1],iz[2]) end if cn.lighting then
ja(cn.lighting) elseif cn.in_room then ja(cn.in_room.lighting) end end function iw(cn) it(cn) if cn.draw then
cn.draw(cn) return end jb=1 if cn.repeat_x then jb=cn.repeat_x end
for h=0,jb-1 do local jc=0 if cn.states then
jc=cn.states[cn.state] else jc=cn[cn.state] end jd(jc,cn.x+(h*(cn.w*8)),cn.y,cn.w,cn.h,cn.trans_col,cn.flip_x) end pal() end function ix(db) je=eg[db.face_dir] if db.gl==1
and db.gm then db.jf+=1 if db.jf>db.frame_delay then
db.jf=1 db.jg+=1 if db.jg>#db.gm then db.jg=1 end
end jh=db.gm[db.jg] else jh=db.idle[je] end it(db) jd(jh,db.dz,db.iq,db.w,db.h,db.trans_col,db.flip,false) if fk
and fk==db and fk.talk then if db.ji<7 then
jh=db.talk[je] jd(jh,db.dz,db.iq+8,1,1,db.trans_col,db.flip,false) end db.ji+=1 if db.ji>14 then db.ji=1 end
end pal() end function hp() jj=""jk=12 jl=gw[2] if not gz then
if gw then
jj=gw[3] end if gx then
jj=jj.." "..gx.name if jl=="use"then
jj=jj.." with"elseif jl=="give"then jj=jj.." to"end end if gy then
jj=jj.." "..gy.name elseif ib and ib.name!=""and(not gx or(gx!=ib)) and(not ib.owner or jl!=get_verb(verb_default)[2]) then jj=jj.." "..ib.name end ha=jj else jj=ha jk=7 end print(jm(jj),jn(jj),gn+66,jk) end function hl() if fg then
jo=0 for jp in all(fg.fs) do jq=0 if fg.fl==1 then
jq=((fg.dw*4)-(#jp*4))/2 end jr(jp,fg.x+jq,fg.y+jo,fg.col,0,fg.fh) jo+=6 end fg.ft-=1 if fg.ft<=0 then
stop_talking() end end end function hq() fr,fj,js=0,75,0 for cp in all(verbs) do jt=verb_maincol if ic
and cp==ic then jt=verb_defcol end if cp==ia then jt=verb_hovcol end
cq=get_verb(cp) print(cq[3],fr,fj+gn+1,verb_shadcol) print(cq[3],fr,fj+gn,jt) cp.x=fr cp.y=fj ik(cp,#cq[3]*4,5,0,0) iy(cp) if#cq[3]>js then js=#cq[3] end
fj+=8 if fj>=95 then
fj=75 fr+=(js+1.0)*4 js=0 end end if selected_actor then
fr,fj=86,76 ju=selected_actor.ie*4 jv=min(ju+8,#selected_actor.ch) for jw=1,8 do rectfill(fr-1,gn+fj-1,fr+8,gn+fj+8,1) cn=selected_actor.ch[ju+jw] if cn then
cn.x,cn.y=fr,fj iw(cn) ik(cn,cn.w*8,cn.h*8,0,0) iy(cn) end fr+=11 if fr>=125 then
fj+=12 fr=86 end jw+=1 end for fp=1,2 do jx=gt[fp] if id==jx then pal(verb_maincol,7) end
jd(jx.spr,jx.x,jx.y,1,1,0) ik(jx,8,7,0,0) iy(jx) pal() end end end function hm() fr,fj=0,70 for fc in all(dn.dp) do if fc.dw>0 then
fc.x,fc.y=fr,fj ik(fc,fc.dw*4,#fc.dr*5,0,0) jt=dn.col if fc==hz then jt=dn.dx end
for jp in all(fc.dr) do print(jm(jp),fr,fj+gn,jt) fj+=5 end iy(fc) fj+=2 end end end function hn() col=gs[gr] pal(7,col) spr(224,go-4,gp-3,1,1,0) pal() gq+=1 if gq>7 then
gq=1 gr+=1 if gr>#gs then gr=1 end
end end function jd(jy,x,y,w,h,jz,flip_x,ka) palt(0,false) palt(jz,true) spr(jy,x,gn+y,w,h,flip_x,ka) palt(jz,false) palt(0,true) end function hc() for fv in all(rooms) do kb(fv) if(#fv.map>2) then
fv.iu=fv.map[3]-fv.map[1]+1 fv.iv=fv.map[4]-fv.map[2]+1 else fv.iu=16 fv.iv=8 end for cn in all(fv.objects) do kb(cn) cn.in_room=fv end end for kc,db in pairs(actors) do kb(db) db.gl=2 db.jf=1 db.ji=1 db.jg=1 db.ch={} db.ie=0 end end function iy(cn) local kd=cn.im if show_collision
and kd then rect(kd.x,kd.y,kd.ke,kd.kf,8) end end function hf(scripts) for fe in all(scripts) do if fe[2] and not coresume(fe[2],fe[3],fe[4]) then
del(scripts,fe) fe=nil end end end function ja(kg) if kg then kg=1-kg end
local gf=flr(mid(0,kg,1)*100) local kh={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for ki=1,15 do col=ki kj=(gf+(ki*1.46))/22 for fd=1,kj do col=kh[col] end pal(ki,col) end end function cy(cw) if type(cw)=="table"then
cw=cw.x end return mid(0,cw-64,(room_curr.iu*8)-128) end function fx(cn) local fy=flr(cn.x/8)+room_curr.map[1] local fz=flr(cn.y/8)+room_curr.map[2] return{fy,fz} end function ge(fy,fz) local kk=mget(fy,fz) local kl=fget(kk,0) return kl end function ds(msg,fn) local dr={} local km=""local kn=""local fq=""local ko=function(kp) if#kn+#km>kp then
add(dr,km) km=""end km=km..kn kn=""end for fp=1,#msg do fq=sub(msg,fp,fp) kn=kn..fq if fq==" "
or#kn>fn-1 then ko(fn) elseif#kn>fn-1 then kn=kn.."-"ko(fn) elseif fq==";"then km=km..sub(kn,1,#kn-1) kn=""ko(0) end end ko(fn) if km!=""then
add(dr,km) end return dr end function du(dr) dt=0 for jp in all(dr) do if#jp>dt then dt=#jp end
end return dt end function has_flag(cn,kq) for br in all(cn) do if br==kq then
return true end end return false end function ik(cn,w,h,kr,ks) x=cn.x y=cn.y if has_flag(cn.classes,"class_actor") then
cn.dz=x-(cn.w*8)/2 cn.iq=y-(cn.h*8)+1 x=cn.dz y=cn.iq end cn.im={x=x,y=y+gn,ke=x+w-1,kf=y+h+gn-1,kr=kr,ks=ks} end function gc(kt,ku) local kv,kw,kx={},{},{} ky(kv,kt,0) kw[kz(kt)]=nil kx[kz(kt)]=0 while#kv>0 and#kv<1000 do local la=kv[#kv] del(kv,kv[#kv]) lb=la[1] if kz(lb)==kz(ku) then
break end local lc={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local ld=lb[1]+x local le=lb[2]+y if abs(x)!=abs(y) then lf=1 else lf=1.4 end
if ld>=room_curr.map[1] and ld<=room_curr.map[1]+room_curr.iu
and le>=room_curr.map[2] and le<=room_curr.map[2]+room_curr.iv and ge(ld,le) and((abs(x)!=abs(y)) or ge(ld,lb[2]) or ge(ld-x,le)) then add(lc,{ld,le,lf}) end end end end for lg in all(lc) do local lh=kz(lg) local li=kx[kz(lb)]+lg[3] if kx[lh]==nil
or li<kx[lh] then kx[lh]=li local lj=li+max(abs(ku[1]-lg[1]),abs(ku[2]-lg[2])) ky(kv,lg,lj) kw[lh]=lb end end end local gb={} lb=kw[kz(ku)] if lb then
local lk=kz(lb) local ll=kz(kt) while lk!=ll do add(gb,lb) lb=kw[lk] lk=kz(lb) end for fp=1,#gb/2 do local lm=gb[fp] local ln=#gb-(fp-1) gb[fp]=gb[ln] gb[ln]=lm end end return gb end function ky(lo,cw,gf) if#lo>=1 then
add(lo,{}) for fp=(#lo),2,-1 do local lg=lo[fp-1] if gf<lg[2] then
lo[fp]={cw,gf} return else lo[fp]=lg end end lo[1]={cw,gf} else add(lo,{cw,gf}) end end function kz(lp) return((lp[1]+1)*16)+lp[2] end function em(msg) print_line("-error-;"..msg,5+cx,5,8,0) end function kb(cn) local dr=lq(cn.data,"\n") for jp in all(dr) do local pairs=lq(jp,"=") if#pairs==2 then
cn[pairs[1]]=lr(pairs[2]) else printh("invalid data line") end end end function lq(fc,lt) local lu={} local ju=0 local lv=0 for fp=1,#fc do local lw=sub(fc,fp,fp) if lw==lt then
add(lu,sub(fc,ju,lv)) ju=0 lv=0 elseif lw!=" "and lw!="\t"then lv=fp if ju==0 then ju=fp end
end end if ju+lv>0 then
add(lu,sub(fc,ju,lv)) end return lu end function lr(lx) local ly=sub(lx,1,1) local lu=nil if lx=="true"then
lu=true elseif lx=="false"then lu=false elseif lz(ly) then if ly=="-"then
lu=sub(lx,2,#lx)*-1 else lu=lx+0 end elseif ly=="{"then local lm=sub(lx,2,#lx-1) lu=lq(lm,",") ma={} for cw in all(lu) do cw=lr(cw) add(ma,cw) end lu=ma else lu=lx end return lu end function lz(iz) for a=1,13 do if iz==sub("0123456789.-+",a,a) then
return true end end end function jr(mb,x,y,mc,md,fh) if not fh then mb=jm(mb) end
for me=-1,1 do for mf=-1,1 do print(mb,x+me,y+mf,md) end end print(mb,x,y,mc) end function jn(fc) return 63.5-flr((#fc*4)/2) end function mg(fc) return 61 end function ii(cn) if not cn.im then return false end
im=cn.im if(go+im.kr>im.ke or go+im.kr<im.x)
or(gp>im.kf or gp<im.y) then return false else return true end end function jm(fc) local a=""local jp,iz,lo=false,false for fp=1,#fc do local ip=sub(fc,fp,fp) if ip=="^"then
if iz then a=a..ip end
iz=not iz elseif ip=="~"then if lo then a=a..ip end
lo,jp=not lo,not jp else if iz==jp and ip>="a"and ip<="z"then
for ki=1,26 do if ip==sub("abcdefghijklmnopqrstuvwxyz",ki,ki) then
ip=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",ki,ki) break end end end a=a..ip iz,lo=false,false end end return a end













__gfx__
0000000000000000000000000000000000000000440000004444444477777777f9e9f9f9ddd5ddd5bbbbbbbb5500000000000000000000000000000000000000
00000000000000000000000000000000000000004400000044444444777777779eee9f9fdd5ddd5dbbbbbbbb5555000000000000000000000000000000000000
0080080000000000000000000000000000000000aaaa000005aaaaaa77777777feeef9f9d5ddd5ddbbbbbbbb5555550000000000000000000000000000000000
0008800055555555ddddddddeeeeeeee000000009999000005999999777777779fef9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0008800055555555ddddddddeeeeeeee00000000444444000005444477777777f9f9feeeddd5ddd5bbbbbbbb5555555500000000000000000000000000000000
0080080055555555ddddddddeeeeeeee000000004444440000054444777777779f9f9eeedd5ddd5dbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee00000000aaaaaaaa000005aa77777777f9f9feeed5ddd5ddbbbbbbbb5555555500000000000000000000000000000000
0000000055555555ddddddddeeeeeeee000000009999999900000599777777779f9f9fef5ddd5dddbbbbbbbb5555555500000000000000000000000000000000
0000000077777755666666ddbbbbbbee333333553333333300000044666666665888858866666666cbcbcbcb0000005500000000000000000000000000045000
00000000777755556666ddddbbbbeeee33333355333333330000004466666666588885881c1c1c1cbcbcbcbc0000555500000000000000000000000000045000
000010007755555566ddddddbbeeeeee33336666333333330000aaaa6666666655555555c1c1c1c1cbcbcbcb0055555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33336666333333330000999966666666888588881c1c1c1cbcbcbcbc5555555500000000000000000000000000045000
001c7c1055555555ddddddddeeeeeeee3355555533333333004444446666666688858888c1c1c1c1cbcbcbcb5555555500000000000000000000000000045000
0000c00055555555ddddddddeeeeeeee33555555333333330044444466666666555555551c1c1c1cbcbcbcbc5555555500000000000000000000000000045000
0000100055555555ddddddddeeeeeeee6666666633333333aaaaaaaa6666666658888588c1c1c1c1cbcbcbcb5555555500000000000000000000000000045000
0000000055555555ddddddddeeeeeeee66666666333333339999999966666666588885887c7c7c7cbcbcbcbc5555555500000000000000000000000000045000
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
0000000055555555ddddddddbbbbbbbb6666666633333355aaaaaa50cccccccc55555677777777ccccc777777765555533333677776333330000000000045000
0000000055555555ddddddddbbbbbbbb666666663333333599999950cccccccc5555677777777ccccccc77777776555533336777777633330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333333544445000cccccccc555677777777ccccccccc7777777655533367777777763330000000000045000
0000000055555555ddddddddbbbbbbbb555555553333335544445000cccccccc55677777777ccccccccccc777777765533677777777776330000000000045000
0b03000055555555ddddddddbbbbbbbb6666666633335555aa500000cccccccc5677777777ccccccccccccc77777776536777777777777630000000099999999
b00030b055555555ddddddddbbbbbbbb666666665555555599500000cccccccc677777777ccccccccccccccc7777777667777777777777760000000055555555
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
444949441dd6dd600000000056dd6d516dd6dd6d0000000044494444444494449924a00000024509552440555559450555944455000000004f4444944f444494
444949441dd6dd650000000056dd6d51666666660000000044494444444494445524a00000024505555555555555555555944455000000004f4444944f444994
44494944166666650000000056666651d6dd6dd60000000044494444444494444424a00000024504555555555555555555944455000000004f4444944f499444
444949441d6dd6d5000000005d6dd651d6dd6dd6000000004449444444449444ff24a0000002450f555555555555555555944455000000004f4444944f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494444424a00000024504555555555555555555944455000000004f44449444444400
444949441666666500000000566666516dd6dd6d0000000044494444444494444424a00000024504555555555555555555944455000000004f44449444440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994444424a00000024504555555555555555555944455000000004f44449444000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444444424a00000024504555555555555555555944455000000004f44449400000000
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
0001010100010100000000010000000000010101010101000000000100000000000101010101010101000000000000000101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000002000000000000000000001010101010101010101010101010101010101010101010101010101010101010101010101010101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000002000000000100002020202020202020202020202020202020202020202020202020202020202020202020202020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010103030303030303030303030303030303030303030303030303030303030303030303030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202020202020202020202020202020204040404040404040404040404040404040404040404040404040404040404040404040404040404
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030305050505050505050505050505050505050505050505050505050505050505050505050505050505
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040404040404040404040404040415151515151515151515151515151515151615151515151515151515151515151515151515151515
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000505050505050505050505050505050525252525252525252525252525252525252625252525252525252525252525252525252525252525
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000606060606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017191a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000027292a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001718282a0000000000000000000000000000000000000000000000001718191a0000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002829282a0000000000000000000000000000000000000000000000002728292a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828191a00000000000000000000000000000000000000001718281b282a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828382a0000000000000000000000000000000000001718282929282b2a1718191a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828282a0000000000000000000000000000000000003737272828283b2a2729282a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030313031303130313031303130313031303130303130313030303233323332333233323332333233
00000000000000000020000000000020070707171717171717171717170707070707071a1a1a1a1a1a1a405040501a1a1a1a1a1a1a070707000000000000000007070709090909090909090909070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00200000000000000000000000100000070707171717171717171717170707070707071a1a1a1a1a1a1a504050401a1a1a1a1a1a1a070707000000000000000007070709444509090909444509070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00000020000000000000000000000000070007171717171717171717170700070700071a1a1a001a1a1a405040501a1a1a001a1a1a070007000000000000000007000709545509090909545509070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007070007626262006262626667666762626200626262070007000000000000000007000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000000000070007171717171717171717170700070700077474740074747476777677747474007474740700070000000000000000070007090966676c6c66670909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000200007011131313131313131313131210107070111313131313131313131313131313131313131210107000000000000000007011131317c313131317c3131212807070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
0000000000100000002000000000000011313131313131313131313131313121113131313131312515151515151515353131313131313121000000000000000011313131313125151535313131313121113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
2000000000000000000020000000000031313131313131313131313131313131313131313131313131313131313131313131313131313131000000000000000031313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
000000100000200000001f0061626262626262626262626262626263001f00100707071a48491a1a000000000605001a1a1a1a1a1a070707070707504050405040504040405040504050405040070707171717090909090909090909090909090909090909171717000000100000616262626262626262626262626200000010
002000000000001000001f2071447144714473004e71447344734473001f20000707071a58591a1a000000000006051a1a1a1a1a1a07070707070740504050405040504050405040504050405007070717171709090909090909444444450909090909090917171700200000002071447474744473b271447474447400002000
200000000020000000201f0071647164716473005e71647364736473201f00000700071a68691a1a000000162636001a4e001a1a1a070007070707504050005050504050405040004050405040070707170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f
000020000000000020001f0062626262626273006e71626262626263001f0020070007607879606000001626360000605e00606060070007070707606060006060606162636060006060606060070707170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f
303030303030303030301b3131313131313131253531313131313131310b3030070007706a6b707000162636000000706e00707070070007070707707070007070707172737070007070707070070707170017767776777677767776777677767776777677170017151515151515151515151515151515151515151515151515
1515151515151515151518181818181818183434343418181818181818181515070111317a7b31313131313131313131313131313121010707271131313131313131313131313131313131313121280717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d15151515
1515151515151515151515151515151515143434343424151515151515151515113131313131312515151515151515353131313131313121113131313131312515151515151515353131313131313121123232323232323232323232323232323232323232323222153c3937373737378e373737373737373737373a3d151515
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
10001000014000140001400014001c4011c4011c0611c0611c0611c061000000000000000000003b65b3b65b00000000000000000000114011140100000000000000000000086490824800000000000000000000
010101011000110001114011140101701017010170c0170c000000000000000000003b6543065b000000000000000000001164919641000000000000000000001864909248000400020000400004000140001400
1111111111061110611c0611c0611c0611c061000000000000000000003b2200045b000000000000000000002125a2a2510000000000000000000018649092480000808000000000000000001000011000110001
1c1c1c1c1140c1140c0170c0170c000000000000000000000410000000000000000000000000002125a2a25100000000000000000000086490824800008080000100001000014000140001400014001c4011c401
c1c1c1c11c0611c061000000000000000000000000000000000000000000000000002125a2a251000000000000000000000867f08248000400020000000000001000010000100011000111401114010170101701
00000000000000000000000000000000000000000000000000000000002125a2a251000000000000000000003853707248000000000000400004000140001400014000140011061110611c0611c0611c0611c061
0000000000000000000000000000000000000000000000002125a2a251000000000000000000003753737148000000000000000000000000100001100011000111401114011140c1140c0170c0170c0000000000
00bbbbbb0000000000000000000000000000002125a2a251000000000000000000003f5373734800000000000000000000000000000000000000001c0611c0611c0611c0611c0611c0613b65b3b65b3b65b3b224
bbbbbbbb3b65b3b65b00000000002125a2a251000000000000000000003f5373734800000000000000000000000000000000000000000170c0170c0170c0170c0170c0170c3b65b3b65b3b65b04100000003b65b
0001010000000000002125a2a251000000000000000000001f5203034800000010000000000000000000000000000000001c0611c0611c0611c0611c0611c0613b65b3b65b3b22400000000000045b3b65b3b65b
a1aaaa1a2125a2a251000000000000000000001852000248000000c0000000000000000000000000000000000170c0170c2170e2170e2170e2170e3b65b3b65b041000000000000000003b65b3b65b0000000000
000000000000000000000000000018100002480040c077000000000000000000000000000000001c0611c0612c0622c0622e0722e0723b65b3b224000000000000000000000045b3b65b10000100002125a2a251
0000000000000000000800800248000000c0000000000000000000000000000000000170c0170c2231e2231e227491921e3b65b0410000000000000000000000000003b65b00401010002125a2a2510000000000
88878788086380724800000010000000000000000000000000000000002c0622c06229442294421e25a2a6423b2240000000000000000000000000000000045b00000000002125a2a25100000000000000000000
0000000000000000000000000000000000000000000000002e37e2e37e19649196492925a2a259041000000000000000000000000000000000000000000000002125a2a251000000000000000000000800800048
00000000000000000000000000003c16c0736c1c26e2836e117011d4011160e2e7093b6540000000000000000000000000000003065b114011140108649092480864909248086490924808649092480000000000
0000000000000000000c36c0c36c0e37c0e37c1140111401110711e0713b6540000000000000001064019200000003065b01000000011864f0f2481864f0f2481864f0f2481864f0f24800000000000000000000
cccccccc0c7370c7370c35c0c35c1146d1146d1105a114013b654000000000000000102501a200000003065b01400000011967f0f2481867f0f2481867f0f2481867f0f2480000c0000000000000000000000000
77cc99cc0e37c0e37c11401114011e4011e05a3b6540000000000000000000000000000003065b01400000010864f0f2480964f0f2480964f0f2480964f0f2480000000000000000000000000000003753c0c36c
111111110c3611140111071114013b654000000000000000102501a200000003065b014000000108637082480863708248086370824808637082480000000000000000000000000000000c36c0c36c0e37c0e37c
e111a1ae110511e0513b654000000000000000102501a200000003065b014000000138537072483853707248385370724838537072480000000000000000000000000000000c36c375372c37e2c25a114010c36c
bb4b00003b6540000000000000000000000000000003065b014000000138537373483853707248381370724838537072480000000000000000000000000000000c36c0c36c0c36c0c36c11401114011140111401
0011000100000000000000000000000003065b0140111001383373734838536275783853637578383373734811401005011102011401000000000000000000000140001400000000000000000000003b6543065b
0000000000000000000000000000010000000138337373483f137275782f53736578383373734809544004440954409544000000000000000000001000110001000000000000000000003b6543065b1040111400
000000000000000000010001000138775393480f200092480f6250924838779303481000110001100011000100000000000000d1d3000140001400000000000000000000003b6543065b10402124000000000000
010000100100000001086250024808200002480862500248185200024839500014000140001400000001076d01461114001000110001000000000000000000003b6543065b1000f0f40000000000000000000000
880080880862000248082000024808625002481810000248004311000139101100011076d1d40110700000010140001400000000000000000000003b6543065b0042f1f100000000000000000000000100000001
58850088185200004818520000480800800248004400000000430000001d4010100010000000001000110001000000000000000000003b6543065b10401114000000000000000000000001000000010820000248
788800851852800048385380624800020000000044000000010000000000000000000140001400000000000000000000003b6543065b104011102000000000000000000000010000000108200002482814800038
668060881863806248000211c061000211c061000000000000000000001000110001000000000000000000003b6543065b1000101500000000000000000000000100000001082361514808008281480800818148
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

