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
			obj_landing_exit_hall = {		
				data = [[
					name=hall
					state=state_open
					x=80
					y=56
					w=3
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
					open_door(door1, door2)
					camera_pan_to(door2)
					wait_for_camera()
					come_out_door(door1, door2)
					close_door(door1, door2)
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

	-- title "room"
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
--[[
							-- intro
							break_time(50)
							print_line("deep in the caribbean:on the isle of...; ;thimbleweed!",64,45,8,1,true)
]]
							change_room(rm_mi_dock, 1)
							
						end
					) -- end cutscene
			end,
			exit = function()
				-- todo: anything here?
			end,
		}

	-- dock
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
					
				

					--[[camera_at(0)
					break_time(30)
					camera_pan_to(212,60)
					wait_for_camera()
					camera_follow(selected_actor)
					
					say_line("this all seems very famililar...")]]

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



function shake(cg) if cg then
ch=1 end ci=cg end function cj(ck) local cl=nil if has_flag(ck.classes,"class_talkable") then
cl="talkto"elseif has_flag(ck.classes,"class_openable") then if ck.state=="state_closed"then
cl="open"else cl="close"end else cl="lookat"end for cm in all(verbs) do cn=get_verb(cm) if cn[2]==cl then cl=cm break end
end return cl end function co(cp,cq,cr) local cs=has_flag(cq.classes,"class_actor") if cp=="walkto"then
return elseif cp=="pickup"then if cs then
say_line"i don't need them"else say_line"i don't need that"end elseif cp=="use"then if cs then
say_line"i can't just *use* someone"end if cr then
if has_flag(cr.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cp=="give"then if cs then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cp=="lookat"then if cs then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cp=="open"then if cs then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cp=="close"then if cs then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cp=="push"or cp=="pull"then if cs then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cp=="talkto"then if cs then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(ct) cu=cv(ct) cw=nil cx=nil end function camera_follow(cy) stop_script(cz) cx=cy cw=nil cz=function() while cx do if cx.in_room==room_curr then
cu=cv(cx) end yield() end end start_script(cz,true) if cx.in_room!=room_curr then
change_room(cx.in_room,1) end end function camera_pan_to(ct) cw=cv(ct) cx=nil cz=function() while(true) do if cu==cw then
cw=nil return elseif cw>cu then cu+=0.5 else cu-=0.5 end yield() end end start_script(cz,true) end function wait_for_camera() while script_running(cz) do yield() end end function cutscene(da,db,dc) dd={da=da,de=cocreate(db),df=dc,dg=cx} add(dh,dd) di=dd break_time() end function dialog_set(dj) for msg in all(dj) do dialog_add(msg) end end function dialog_add(msg) if not dk then dk={dl={},dm=false} end
dn=dp(msg,32) dq=dr(dn) ds={num=#dk.dl+1,msg=msg,dn=dn,dt=dq} add(dk.dl,ds) end function dialog_start(col,du) dk.col=col dk.du=du dk.dm=true selected_sentence=nil end function dialog_hide() dk.dm=false end function dialog_clear() dk.dl={} selected_sentence=nil end function dialog_end() dk=nil end function get_use_pos(ck) local dv=ck.use_pos local x=ck.x-cu local y=ck.y if type(dv)=="table"then
x=dv[1] y=dv[2] elseif dv=="pos_left"then if ck.dw then
x-=(ck.w*8+4) y+=1 else x-=2 y+=((ck.h*8)-2) end elseif dv=="pos_right"then x+=(ck.w*8) y+=((ck.h*8)-2) elseif dv=="pos_above"then x+=((ck.w*8)/2)-4 y-=2 elseif dv=="pos_center"then x+=((ck.w*8)/2) y+=((ck.h*8)/2)-4 elseif dv=="pos_infront"or dv==nil then x+=((ck.w*8)/2)-4 y+=(ck.h*8)+2 end return{x=x,y=y} end function do_anim(cy,dx,dy) dz={"face_front","face_left","face_back","face_right"} if dx=="anim_face"then
if type(dy)=="table"then
ea=atan2(cy.x-dy.x,dy.y-cy.y) eb=93*(3.1415/180) ea=eb-ea ec=ea*360 ec=ec%360 if ec<0 then ec+=360 end
dy=4-flr(ec/90) dy=dz[dy] end face_dir=ed[cy.face_dir] dy=ed[dy] while face_dir!=dy do if face_dir<dy then
face_dir+=1 else face_dir-=1 end cy.face_dir=dz[face_dir] cy.flip=(cy.face_dir=="face_left") break_time(10) end end end function open_door(ee,ef) if ee.state=="state_open"then
say_line"it's already open"else ee.state="state_open"if ef then ef.state="state_open"end
end end function close_door(ee,ef) if ee.state=="state_closed"then
say_line"it's already closed"else ee.state="state_closed"if ef then ef.state="state_closed"end
end end function come_out_door(eg,eh,ei) if eh==nil then
ej("exit door does not exist") return end if eg.state=="state_open"then
ek=eh.in_room if eg.in_room!=eh.in_room then
change_room(ek,ei) end local el=get_use_pos(eh) put_actor_at(selected_actor,el.x,el.y,ek) em={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if eh.use_dir then
en=em[eh.use_dir] else en=1 end selected_actor.face_dir=en selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eo,bq) if bq==1 then
ep=0 else ep=50 end while true do ep+=bq*2 if ep>50
or ep<0 then return end if eo==1 then
eq=min(ep,32) end yield() end end function change_room(ek,eo) if ek==nil then
ej("room does not exist") return end stop_script(er) if eo and room_curr then
fades(eo,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end es={} et() room_curr=ek if not cx
or cx.in_room!=room_curr then cu=0 end stop_talking() if eo then
er=function() fades(eo,-1) end start_script(er,true) else eq=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cp,eu) if not eu
or not eu.verbs then return false end if type(cp)=="table"then
if eu.verbs[cp[1]] then return true end
else if eu.verbs[cp] then return true end
end return false end function pickup_obj(ck,cy) cy=cy or selected_actor add(cy.ce,ck) ck.owner=cy del(ck.in_room.objects,ck) end function start_script(ev,ew,ex,bh) local de=cocreate(ev) local scripts=es if ew then
scripts=ey end add(scripts,{ev,de,ex,bh}) end function script_running(ev) for ez in all({es,ey}) do for fa,fb in pairs(ez) do if fb[1]==ev then
return fb end end end return false end function stop_script(ev) fb=script_running(ev) if fb then
del(es,fb) del(ey,fb) end end function break_time(fc) fc=fc or 1 for x=1,fc do yield() end end function wait_for_message() while fd!=nil do yield() end end function say_line(cy,msg,fe,ff) if type(cy)=="string"then
msg=cy cy=selected_actor end fg=cy.y-(cy.h)*8+4 fh=cy print_line(msg,cy.x,fg,cy.col,1,fe,ff) end function stop_talking() fd,fh=nil,nil end function print_line(msg,x,y,col,fi,fe,ff) local col=col or 7 local fi=fi or 0 if fi==1 then
fj=min(x-cu,127-(x-cu)) else fj=127-(x-cu) end local fk=max(flr(fj/2),16) local fl=""for fm=1,#msg do local fn=sub(msg,fm,fm) if fn==":"then
fl=sub(msg,fm+1) msg=sub(msg,1,fm-1) break end end local dn=dp(msg,fk) local dq=dr(dn) fo=x-cu if fi==1 then
fo-=((dq*4)/2) end fo=max(2,fo) fg=max(18,y) fo=min(fo,127-(dq*4)-1) fd={fp=dn,x=fo,y=fg,col=col,fi=fi,fq=(#msg)*8,dt=dq,fe=fe} if#fl>0 then
fr=fh wait_for_message() fh=fr print_line(fl,x,y,col,fi,fe) end if not ff then
wait_for_message() end end function put_actor_at(cy,x,y,fs) if fs then cy.in_room=fs end
cy.x,cy.y=x,y end function walk_to(cy,x,y) x+=cu local ft=fu(cy) local fv=flr(x/8)+room_curr.map[1] local fw=flr(y/8)+room_curr.map[2] local fx={fv,fw} local fy=fz(ft,fx) local ga=fu({x=x,y=y}) if gb(ga[1],ga[2]) then
add(fy,ga) end for gc in all(fy) do local gd=(gc[1]-room_curr.map[1])*8+4 local ge=(gc[2]-room_curr.map[2])*8+4 local gf=sqrt((gd-cy.x)^2+(ge-cy.y)^2) local gg=cy.walk_speed*(gd-cy.x)/gf local gh=cy.walk_speed*(ge-cy.y)/gf if gf>5 then
cy.gi=1 cy.flip=(gg<0) if abs(gg)<0.4 then
if gh>0 then
cy.gj=cy.walk_anim_front cy.face_dir="face_front"else cy.gj=cy.walk_anim_back cy.face_dir="face_back"end else cy.gj=cy.walk_anim_side cy.face_dir="face_right"if cy.flip then cy.face_dir="face_left"end
end for fm=0,gf/cy.walk_speed do cy.x+=gg cy.y+=gh yield() end end end cy.gi=2 end function wait_for_actor(cy) cy=cy or selected_actor while cy.gi!=2 do yield() end end function proximity(cq,cr) if cq.in_room==cr.in_room then
local gf=sqrt((cq.x-cr.x)^2+(cq.y-cr.y)^2) return gf else return 1000 end end gk=16 cu,cw,cz,ch=0,nil,nil,0 gl,gm,gn,go=63.5,63.5,0,1 gp={7,12,13,13,12,7} gq={{spr=208,x=75,y=gk+60},{spr=240,x=75,y=gk+72}} ed={face_front=1,face_left=2,face_back=3,face_right=4} function gr(ck) local gs={} for fa,cm in pairs(ck) do add(gs,fa) end return gs end function get_verb(ck) local cp={} local gs=gr(ck[1]) add(cp,gs[1]) add(cp,ck[1][gs[1]]) add(cp,ck.text) return cp end function et() gt=get_verb(verb_default) gu,gv,o,gw,gx=nil,nil,nil,false,""end et() fd=nil dk=nil di=nil fh=nil ey={} es={} dh={} gy={} eq,eq=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gz() start_script(startup_script,true) end function _update60() ha() end function _draw() hb() end function ha() if selected_actor and selected_actor.de
and not coresume(selected_actor.de) then selected_actor.de=nil end hc(ey) if di then
if di.de
and not coresume(di.de) then if di.da!=3
and di.dg then camera_follow(di.dg) selected_actor=di.dg end del(dh,di) di=nil if#dh>0 then
di=dh[#dh] end end else hc(es) end hd() he() hf,hg=1.5-rnd(3),1.5-rnd(3) hf=flr(hf*ch) hg=flr(hg*ch) if not ci then
ch*=0.90 if ch<0.05 then ch=0 end
end end function hb() rectfill(0,0,127,127,0) camera(cu+hf,0+hg) clip(0+eq-hf,gk+eq-hg,128-eq*2-hf,64-eq*2) hh() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,gk-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,gk-8,8) end if show_debuginfo then
print("x: "..flr(gl+cu).." y:"..gm-gk,80,gk-8,8) end hi() if dk
and dk.dm then hj() hk() return end if hl==di then
else hl=di return end if not di then
hm() end if(not di
or di.da==2) and(hl==di) then hn() else end hl=di if not di then
hk() end end function hd() if di then
if btnp(4) and btnp(5) and di.df then
di.de=cocreate(di.df) di.df=nil return end return end if btn(0) then gl-=1 end
if btn(1) then gl+=1 end
if btn(2) then gm-=1 end
if btn(3) then gm+=1 end
if btnp(4) then ho(1) end
if btnp(5) then ho(2) end
if enable_mouse then
hp,hq=stat(32)-1,stat(33)-1 if hp!=hr then gl=hp end
if hq!=hs then gm=hq end
if stat(34)>0 then
if not ht then
ho(stat(34)) ht=true end else ht=false end hr=hp hs=hq end gl=mid(0,gl,127) gm=mid(0,gm,127) end function ho(hu) local hv=gt if not selected_actor then
return end if dk and dk.dm then
if hw then
selected_sentence=hw end return end if hx then
gt=get_verb(hx) elseif hy then if hu==1 then
if(gt[2]=="use"or gt[2]=="give")
and gu then gv=hy else gu=hy end elseif hz then gt=get_verb(hz) gu=hy gr(gu) hm() end elseif ia then if ia==gq[1] then
if selected_actor.ib>0 then
selected_actor.ib-=1 end else if selected_actor.ib+2<flr(#selected_actor.ce/4) then
selected_actor.ib+=1 end end return end if gu!=nil
and not gw then if gt[2]=="use"or gt[2]=="give"then
if gv then
elseif gu.use_with and gu.owner==selected_actor then return end end gw=true selected_actor.de=cocreate(function() if(not gu.owner
and(not has_flag(gu.classes,"class_actor") or gt[2]!="use")) or gv then ic=gv or gu id=get_use_pos(ic) walk_to(selected_actor,id.x,id.y) if selected_actor.gi!=2 then return end
use_dir=ic if ic.use_dir then use_dir=ic.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gt,gu) then
start_script(gu.verbs[gt[1]],false,gu,gv) else co(gt[2],gu,gv) end et() end) coresume(selected_actor.de) elseif gm>gk and gm<gk+64 then gw=true selected_actor.de=cocreate(function() walk_to(selected_actor,gl,gm-gk) et() end) coresume(selected_actor.de) end end function he() hx,hz,hy,hw,ia=nil,nil,nil,nil,nil if dk
and dk.dm then for ez in all(dk.dl) do if ie(ez) then
hw=ez end end return end ig() for ck in all(room_curr.objects) do if(not ck.classes
or(ck.classes and not has_flag(ck.classes,"class_untouchable"))) and(not ck.dependent_on or ck.dependent_on.state==ck.dependent_on_state) then ih(ck,ck.w*8,ck.h*8,cu,ii) else ck.ij=nil end if ie(ck) then
if not hy
or(not ck.z and hy.z<0) or(ck.z and hy.z and ck.z>hy.z) then hy=ck end end ik(ck) end for fa,cy in pairs(actors) do if cy.in_room==room_curr then
ih(cy,cy.w*8,cy.h*8,cu,ii) ik(cy) if ie(cy)
and cy!=selected_actor then hy=cy end end end if selected_actor then
for cm in all(verbs) do if ie(cm) then
hx=cm end end for il in all(gq) do if ie(il) then
ia=il end end for fa,ck in pairs(selected_actor.ce) do if ie(ck) then
hy=ck if gt[2]=="pickup"and hy.owner then
gt=nil end end if ck.owner!=selected_actor then
del(selected_actor.ce,ck) end end if gt==nil then
gt=get_verb(verb_default) end if hy then
hz=cj(hy) end end end function ig() gy={} for x=-64,64 do gy[x]={} end end function ik(ck) fg=-1 if ck.im then
fg=ck.y else fg=ck.y+(ck.h*8) end io=flr(fg) if ck.z then
io=ck.z end add(gy[io],ck) end function hh() rectfill(0,gk,127,gk+64,room_curr.ip or 0) for z=-64,64 do if z==0 then
iq(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,gk,room_curr.ir,room_curr.is) pal() else io=gy[z] for ck in all(io) do if not has_flag(ck.classes,"class_actor") then
if ck.states
or(ck.state and ck[ck.state] and ck[ck.state]>0) and(not ck.dependent_on or ck.dependent_on.state==ck.dependent_on_state) and not ck.owner then it(ck) end else if ck.in_room==room_curr then
iu(ck) end end iv(ck) end end end end function iq(ck) if ck.col_replace then
iw=ck.col_replace pal(iw[1],iw[2]) end if ck.lighting then
ix(ck.lighting) elseif ck.in_room then ix(ck.in_room.lighting) end end function it(ck) iq(ck) if ck.draw then
ck.draw(ck) return end iy=1 if ck.repeat_x then iy=ck.repeat_x end
for h=0,iy-1 do local iz=0 if ck.states then
iz=ck.states[ck.state] else iz=ck[ck.state] end ja(iz,ck.x+(h*(ck.w*8)),ck.y,ck.w,ck.h,ck.trans_col,ck.flip_x) end pal() end function iu(cy) jb=ed[cy.face_dir] if cy.gi==1
and cy.gj then cy.jc+=1 if cy.jc>cy.frame_delay then
cy.jc=1 cy.jd+=1 if cy.jd>#cy.gj then cy.jd=1 end
end je=cy.gj[cy.jd] else je=cy.idle[jb] end iq(cy) ja(je,cy.dw,cy.im,cy.w,cy.h,cy.trans_col,cy.flip,false) if fh
and fh==cy and fh.talk then if cy.jf<7 then
je=cy.talk[jb] ja(je,cy.dw,cy.im+8,1,1,cy.trans_col,cy.flip,false) end cy.jf+=1 if cy.jf>14 then cy.jf=1 end
end pal() end function hm() jg=""jh=12 ji=gt[2] if not gw then
if gt then
jg=gt[3] end if gu then
jg=jg.." "..gu.name if ji=="use"then
jg=jg.." with"elseif ji=="give"then jg=jg.." to"end end if gv then
jg=jg.." "..gv.name elseif hy and hy.name!=""and(not gu or(gu!=hy)) and(not hy.owner or ji!=get_verb(verb_default)[2]) then jg=jg.." "..hy.name end gx=jg else jg=gx jh=7 end print(jj(jg),jk(jg),gk+66,jh) end function hi() if fd then
jl=0 for jm in all(fd.fp) do jn=0 if fd.fi==1 then
jn=((fd.dt*4)-(#jm*4))/2 end jo(jm,fd.x+jn,fd.y+jl,fd.col,0,fd.fe) jl+=6 end fd.fq-=1 if fd.fq<=0 then
stop_talking() end end end function hn() fo,fg,jp=0,75,0 for cm in all(verbs) do jq=verb_maincol if hz
and cm==hz then jq=verb_defcol end if cm==hx then jq=verb_hovcol end
cn=get_verb(cm) print(cn[3],fo,fg+gk+1,verb_shadcol) print(cn[3],fo,fg+gk,jq) cm.x=fo cm.y=fg ih(cm,#cn[3]*4,5,0,0) iv(cm) if#cn[3]>jp then jp=#cn[3] end
fg+=8 if fg>=95 then
fg=75 fo+=(jp+1.0)*4 jp=0 end end if selected_actor then
fo,fg=86,76 jr=selected_actor.ib*4 js=min(jr+8,#selected_actor.ce) for jt=1,8 do rectfill(fo-1,gk+fg-1,fo+8,gk+fg+8,1) ck=selected_actor.ce[jr+jt] if ck then
ck.x,ck.y=fo,fg it(ck) ih(ck,ck.w*8,ck.h*8,0,0) iv(ck) end fo+=11 if fo>=125 then
fg+=12 fo=86 end jt+=1 end for fm=1,2 do ju=gq[fm] if ia==ju then pal(verb_maincol,7) end
ja(ju.spr,ju.x,ju.y,1,1,0) ih(ju,8,7,0,0) iv(ju) pal() end end end function hj() fo,fg=0,70 for ez in all(dk.dl) do if ez.dt>0 then
ez.x,ez.y=fo,fg ih(ez,ez.dt*4,#ez.dn*5,0,0) jq=dk.col if ez==hw then jq=dk.du end
for jm in all(ez.dn) do print(jj(jm),fo,fg+gk,jq) fg+=5 end iv(ez) fg+=2 end end end function hk() col=gp[go] pal(7,col) spr(224,gl-4,gm-3,1,1,0) pal() gn+=1 if gn>7 then
gn=1 go+=1 if go>#gp then go=1 end
end end function ja(jv,x,y,w,h,jw,flip_x,jx) palt(0,false) palt(jw,true) spr(jv,x,gk+y,w,h,flip_x,jx) palt(jw,false) palt(0,true) end function gz() for fs in all(rooms) do jy(fs) if(#fs.map>2) then
fs.ir=fs.map[3]-fs.map[1]+1 fs.is=fs.map[4]-fs.map[2]+1 else fs.ir=16 fs.is=8 end for ck in all(fs.objects) do jy(ck) ck.in_room=fs end end for jz,cy in pairs(actors) do jy(cy) cy.gi=2 cy.jc=1 cy.jf=1 cy.jd=1 cy.ce={} cy.ib=0 end end function iv(ck) local ka=ck.ij if show_collision
and ka then rect(ka.x,ka.y,ka.kb,ka.kc,8) end end function hc(scripts) for fb in all(scripts) do if fb[2] and not coresume(fb[2],fb[3],fb[4]) then
del(scripts,fb) fb=nil end end end function ix(kd) if kd then kd=1-kd end
local gc=flr(mid(0,kd,1)*100) local ke={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kf=1,15 do col=kf kg=(gc+(kf*1.46))/22 for fa=1,kg do col=ke[col] end pal(kf,col) end end function cv(ct) if type(ct)=="table"then
ct=ct.x end return mid(0,ct-64,(room_curr.ir*8)-128) end function fu(ck) local fv=flr(ck.x/8)+room_curr.map[1] local fw=flr(ck.y/8)+room_curr.map[2] return{fv,fw} end function gb(fv,fw) local kh=mget(fv,fw) local ki=fget(kh,0) return ki end function dp(msg,fk) local dn={} local kj=""local kk=""local fn=""local kl=function(km) if#kk+#kj>km then
add(dn,kj) kj=""end kj=kj..kk kk=""end for fm=1,#msg do fn=sub(msg,fm,fm) kk=kk..fn if fn==" "
or#kk>fk-1 then kl(fk) elseif#kk>fk-1 then kk=kk.."-"kl(fk) elseif fn==";"then kj=kj..sub(kk,1,#kk-1) kk=""kl(0) end end kl(fk) if kj!=""then
add(dn,kj) end return dn end function dr(dn) dq=0 for jm in all(dn) do if#jm>dq then dq=#jm end
end return dq end function has_flag(ck,kn) for br in all(ck) do if br==kn then
return true end end return false end function ih(ck,w,h,ko,kp) x=ck.x y=ck.y if has_flag(ck.classes,"class_actor") then
ck.dw=x-(ck.w*8)/2 ck.im=y-(ck.h*8)+1 x=ck.dw y=ck.im end ck.ij={x=x,y=y+gk,kb=x+w-1,kc=y+h+gk-1,ko=ko,kp=kp} end function fz(kq,kr) local ks,kt,ku={},{},{} kv(ks,kq,0) kt[kw(kq)]=nil ku[kw(kq)]=0 while#ks>0 and#ks<1000 do local kx=ks[#ks] del(ks,ks[#ks]) ky=kx[1] if kw(ky)==kw(kr) then
break end local kz={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local la=ky[1]+x local lb=ky[2]+y if abs(x)!=abs(y) then lc=1 else lc=1.4 end
if la>=room_curr.map[1] and la<=room_curr.map[1]+room_curr.ir
and lb>=room_curr.map[2] and lb<=room_curr.map[2]+room_curr.is and gb(la,lb) and((abs(x)!=abs(y)) or gb(la,ky[2]) or gb(la-x,lb)) then add(kz,{la,lb,lc}) end end end end for ld in all(kz) do local le=kw(ld) local lf=ku[kw(ky)]+ld[3] if ku[le]==nil
or lf<ku[le] then ku[le]=lf local lg=lf+max(abs(kr[1]-ld[1]),abs(kr[2]-ld[2])) kv(ks,ld,lg) kt[le]=ky end end end local fy={} ky=kt[kw(kr)] if ky then
local lh=kw(ky) local li=kw(kq) while lh!=li do add(fy,ky) ky=kt[lh] lh=kw(ky) end for fm=1,#fy/2 do local lj=fy[fm] local lk=#fy-(fm-1) fy[fm]=fy[lk] fy[lk]=lj end end return fy end function kv(ll,ct,gc) if#ll>=1 then
add(ll,{}) for fm=(#ll),2,-1 do local ld=ll[fm-1] if gc<ld[2] then
ll[fm]={ct,gc} return else ll[fm]=ld end end ll[1]={ct,gc} else add(ll,{ct,gc}) end end function kw(lm) return((lm[1]+1)*16)+lm[2] end function ej(msg) print_line("-error-;"..msg,5+cu,5,8,0) end function jy(ck) local dn=ln(ck.data,"\n") for jm in all(dn) do local pairs=ln(jm,"=") if#pairs==2 then
ck[pairs[1]]=lo(pairs[2]) else printh("invalid data line") end end end function ln(ez,lp) local lq={} local jr=0 local lr=0 for fm=1,#ez do local lt=sub(ez,fm,fm) if lt==lp then
add(lq,sub(ez,jr,lr)) jr=0 lr=0 elseif lt!=" "and lt!="\t"then lr=fm if jr==0 then jr=fm end
end end if jr+lr>0 then
add(lq,sub(ez,jr,lr)) end return lq end function lo(lu) local lv=sub(lu,1,1) local lq=nil if lu=="true"then
lq=true elseif lu=="false"then lq=false elseif lw(lv) then if lv=="-"then
lq=sub(lu,2,#lu)*-1 else lq=lu+0 end elseif lv=="{"then local lj=sub(lu,2,#lu-1) lq=ln(lj,",") lx={} for ct in all(lq) do ct=lo(ct) add(lx,ct) end lq=lx else lq=lu end return lq end function lw(iw) for a=1,13 do if iw==sub("0123456789.-+",a,a) then
return true end end end function jo(ly,x,y,lz,ma,fe) if not fe then ly=jj(ly) end
for mb=-1,1 do for mc=-1,1 do print(ly,x+mb,y+mc,ma) end end print(ly,x,y,lz) end function jk(ez) return 63.5-flr((#ez*4)/2) end function md(ez) return 61 end function ie(ck) if not ck.ij then return false end
ij=ck.ij if(gl+ij.ko>ij.kb or gl+ij.ko<ij.x)
or(gm>ij.kc or gm<ij.y) then return false else return true end end function jj(ez) local a=""local jm,iw,ll=false,false for fm=1,#ez do local il=sub(ez,fm,fm) if il=="^"then
if iw then a=a..il end
iw=not iw elseif il=="~"then if ll then a=a..il end
ll,jm=not ll,not jm else if iw==jm and il>="a"and il<="z"then
for kf=1,26 do if il==sub("abcdefghijklmnopqrstuvwxyz",kf,kf) then
il=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kf,kf) break end end end a=a..il iw,ll=false,false end end return a end













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
20000000000000000000200000000000313131313131313131313131313131312f2f2f2f2f2f2f2f2f2f3131312f2f2f2f2f2f2f2f2f2f2f000000000000000031313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
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

