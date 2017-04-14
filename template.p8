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
-- now 7595 tokens (after stairs, door teleports, b4 tweak to pathfinding)
-- now 7646 tokens (after b4 tweak to pathfinding)


-- debugging
show_debuginfo = true
show_collision = false
show_pathfinding = true
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
							put_at(purp_tentacle, 130, purp_tentacle.y, rm_kitchen)
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

			obj_bucket = {		
				data = [[
					name = bucket
					state = state_open
					x=240
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
					use = function(me, noun2)
						if noun2 == obj_fire then
							put_at(obj_fire, 0, 0, rm_void)
							put_at(obj_key, 88, 32, rm_library)
							say_line("the fire's out now")
						elseif noun2 == obj_pool then
							say_line("let's fill this up...")
							me.state = "state_closed"
							me.name = "full bucket"
							say_line("that's better!")
						end
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
				obj_front_door,
				obj_bucket
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
					put_at(selected_actor, 144, 36, rm_outside)
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


		rm_hall = {
			data = [[
				map = {32,24,55,31}
				col_replace = {5,2}
			]],
			objects = {
				obj_front_door_inside,
				obj_inside_stairs,
				obj_hall_rail,
				obj_hall_exit_landing,
				obj_hall_door_library,
				obj_hall_door_kitchen,
			},
			enter = function(me)
				-- todo: anything here?
			end,
			exit = function(me)
				-- todo: anything here?
			end,
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
					state_open=128
					use_dir = face_back
					classes = { class_door }
					lighting = 1
				]],
				init = function(me)  
					me.target_door = obj_hall_door_library
				end
			}

			obj_lightswitch = {		
				data = [[
					name=light switch
					state=state_here
					x=56
					y=23
					w=1
					h=1
					state_here=125
					lighting=0.6
				]],
				verbs = {
					use = function(me)
						if me.on then
							rm_library.lighting = 0.25
							obj_library_door_hall.state = "state_open"
							obj_lightswitch.lighting = 0.6
							me.on = false
						else
							rm_library.lighting = 1
							obj_library_door_hall.state = ""
							obj_lightswitch.lighting = 1
							me.on = true
						end
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
					use_pos={97,42}
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
				dependent_on_state = "state_open",
				verbs = {
					walkto = function(me)
						change_room(rm_title, 1)
					end
				}
			}

			obj_book = {		
				data = [[
					name=loose book
					state=state_gone
					x=136
					y=16
					w=1
					h=1
					state_gone=80
					state_here=65
					use_pos={144,40}
					classes = {class_pickupable}
				]],
				verbs = {
					lookat = function(me)
						if me.state == "state_gone" then
							say_line("this book sticks out")
						else
							say_line("it's a secret lock that was hidden behind the book")
						end
					end,
					pull = function(me)
						me.state = "state_here"
						me.name = "secret lock"
					end,
					pickup = function(me)
						me.verbs.pull(me)
					end
				}
			}

			obj_key = {		
				data = [[
					name=gold key
					state=state_gone
					x=1
					y=1
					z=30
					w=1
					h=1
					state_gone=32
					state_here=173
					use_with=true
					classes = {class_pickupable}
				]],
				verbs = {
					lookat = function(me)
						say_line("it's a gold key")
					end,
					pickup = function(me)
						me.state = "state_here"
						pickup_obj(me)
					end,
					use = function(me, noun2)
						if (noun2 == obj_book) then
							put_at(me, 0,0, rm_void)
							obj_library_secret_panel.state = "state_open"
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
				lighting=0.25
			]],
			objects = {
				obj_library_door_hall,
				obj_lightswitch,
				obj_fire,
				obj_library_door_secret,
				obj_library_secret_panel,
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
			enter = function(me)
				start_script(me.scripts.tentacle_guard, true) -- bg script
			end,
			exit = function(me)
				stop_script(me.scripts.tentacle_guard)
			end,
			scripts = {	  -- scripts that are at room-level
				tentacle_guard = function()
					while true do
						if proximity(main_actor, obj_back_door) < 40 
						 and not purp_tentacle.alerting
						 and purp_tentacle.in_room == selected_actor.in_room then
							purp_tentacle.alerting = true
							purp_tentacle.stopped_player = true
							cutscene(2,
								function()
									stop_actor(selected_actor)
									say_line(purp_tentacle, "stop!:come back here!", true)
									walk_to(selected_actor, purp_tentacle.x-8, purp_tentacle.y)
									do_anim(selected_actor, "anim_face", purp_tentacle)
									purp_tentacle.alerting = false
								end
							)
						end
						break_time(10)
					end
				end,
			},
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

			obj_pool = {		
				data = [[
					name=swimming pool
					x=96
					y=48
					w=3
					h=2
					use_pos = pos_above
					use_dir = face_front
				]],
				verbs = {
					walkto = function(me)
						say_line("i can't swim!")
					end,
					lookat = function(me)
						say_line("lovely and crystal clear...:definitely filled with water")
					end,
				}
			}

		rm_garden = {
			data = [[
				map = {104,24,127,31}
			]],
			objects = {
				obj_garden_door_kitchen,
				obj_pool,
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
					cutscene(
						2, -- quick-cut
						function()
							open_door(door1)
							break_time(10)
							put_at(selected_actor,0,0,rm_void)
							close_door(door1)
							camera_pan_to(door2)
							wait_for_camera()
							open_door(door1, door2)
							break_time(10)
							come_out_door(door1, door2)
							close_door(door1,door2)
							camera_follow(selected_actor)
						end)
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
					map(58,16, 40,28, 6,4, 0x80)
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
				scripts = {
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
				},
				verbs = {
					use = function(me)
						if script_running(me.scripts.spin_top) then
							stop_script(me.scripts.spin_top)
							me.state = 1
						else
							start_script(me.scripts.spin_top)
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
					classes = {class_openable}
				]],
				verbs = {
					open = function(me)
						me.state = "state_open"
					end,
					close = function(me)
						me.state = "state_closed"
					end,

						-- if not me.done_cutscene then
						-- 	cutscene(
						-- 		1, -- no verbs 
						-- 		function()
						-- 			me.done_cutscene = true
						-- 			-- cutscene code
						--	 			me.state = "state_open"
						-- 			me.z = -2
						-- 			print_line("*bang*",40,20,8,1)
						-- 			change_room(rm_kitchen, 1)
						-- 			selected_actor = purp_tentacle
						-- 			walk_to(selected_actor, 
						-- 				selected_actor.x+10, 
						-- 				selected_actor.y)
						-- 			say_line("what was that?!")
						-- 			say_line("i'd better check...")
						-- 			walk_to(selected_actor, 
						-- 				selected_actor.x-10, 
						-- 				selected_actor.y)
						-- 			change_room(rm_hall, 1)
						-- 			-- wait for a bit, then appear in room1
						-- 			break_time(50)
						-- 			put_at(selected_actor, 115, 44, rm_hall)
						-- 			walk_to(selected_actor, 
						-- 				selected_actor.x-10, 
						-- 				selected_actor.y)
						-- 			say_line("intruder!!!")
						-- 			do_anim(main_actor, "anim_face", purp_tentacle)
						-- 		end,
						-- 		-- override for cutscene
						-- 		function()
						-- 			--if cutscene_curr.skipped then
						-- 			--d("override!")
						-- 			change_room(rm_hall)
						-- 			put_at(purp_tentacle, 105, 44, rm_hall)
						-- 			stop_talking()
						-- 			do_anim(main_actor, "anim_face", purp_tentacle)
						-- 		end
						-- 	)
						-- end --if
						-- (code here will not run, as room change nuked "local" scripts)
				}
			}

			obj_floppy_disk = {	
				data = [[
					name=pico-8
					x=60
					y=44
					w=1
					h=1
					state=state_here
					state_here=189
					trans_col=11
					use_with=true
					classes={class_pickupable}
				]],
				verbs = {
					lookat = function(me)
						say_line("it's a licenced copy of pico-8:\"a fantasy console for making, sharing and playing tiny games and other computer programs\":sounds like fun!")
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
					use = function(me, noun2)
						if (noun2 == obj_computer) then
							say_line("there's already a disk inserted")
						end
					end,
					give = function(me, noun2)
						if noun2 == purp_tentacle then
							say_line("do you like programming?")
							say_line(purp_tentacle, "yes, why?")
							say_line("give pico-8 a go, see what you can make")
							me.owner = purp_tentacle
							say_line(purp_tentacle, "this is perfect!", true)
							say_line(purp_tentacle, "thank you very much:i shall start making a game right now...")
							stop_script(rm_kitchen.scripts.tentacle_guard)
							walk_to(purp_tentacle, obj_kitchen_door_hall.x+4, obj_kitchen_door_hall.y+30)
							put_at(purp_tentacle, 0,0, rm_void)
						else
							say_line("i might need this")
						end
					end,
				}
			}


		rm_computer = {
			data = [[
				map = {64,16}
			]],
			objects = {
				obj_computer_door_landing,
				obj_computer,
				obj_cursor,
				obj_spinning_top,
				obj_window,
				obj_floppy_disk,
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
				-- load embedded gfx flags (from sfx area)
				reload(0x3000,0x3a00,0x100)

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
				put_at(selected_actor, 212, 60, rm_mi_dock)

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

		-- obj_switch_tent = {		
		-- 	data = [[
		-- 		name=purple tentacle
		-- 		state=state_here
		-- 		state_here=170
		-- 		trans_col=15
		-- 		x=1
		-- 		y=1
		-- 		w=1
		-- 		h=1
		-- 	]],
		-- 	verbs = {
		-- 		use = function(me)
		-- 			selected_actor = purp_tentacle
		-- 			camera_follow(purp_tentacle)
		-- 		end
		-- 	}
		-- }

		-- obj_switch_player= {		
		-- 	data = [[
		-- 		name=humanoid
		-- 		state=state_here
		-- 		state_here=209
		-- 		trans_col=11
		-- 		x=1
		-- 		y=1
		-- 		w=1
		-- 		h=1
		-- 	]],
		-- 	verbs = {
		-- 		use = function(me)
		-- 			selected_actor = main_actor
		-- 			camera_follow(main_actor)
		-- 		end
		-- 	}
		-- }

		-- obj_duck = {		
		-- 	data = [[
		-- 		name=rubber duck
		-- 		state=state_here
		-- 		state_here=142
		-- 		trans_col=12
		-- 		x=1
		-- 		y=1
		-- 		w=1
		-- 		h=1
		-- 		classes = {class_pickupable}
		-- 	]],
		-- 	verbs = {
		-- 		pickup = function(me)
		-- 			pickup_obj(me)
		-- 		end,
		-- 	}
		-- }


	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_key
			-- obj_switch_player,
			-- obj_switch_tent
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
			x = 140
			y = 52
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
							(not me.stopped_player and "" or "why did you stop me?"),
							(me.asked_where and "" or "where am i?"),
							--"who are you?",
							(me.asked_woodchuck and "" or "how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?"),
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
									say_line(me, "i need your help:i'm so bored...:please can you give me something i can play with for ages?")
									me.asked_why_stop = true

								elseif selected_sentence.num == 2 then
									say_line(me, "you are in paul's demo scumm-8 game, i think!")
									me.asked_where = true

								-- elseif selected_sentence.num == 3 then
								-- 	say_line(me, "it's complicated...")

								elseif selected_sentence.num == 3 then
									say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
									me.asked_woodchuck = true

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
	-- pickup_obj(obj_switch_tent, main_actor)
	-- pickup_obj(obj_switch_player, purp_tentacle)
	
	--  pickup_obj(obj_bucket, main_actor)
	--  obj_bucket.state = "state_closed"
	
	-- set which actor the player controls by default
	selected_actor = main_actor
	
	-- init actor
	--put_at(selected_actor, 100, 48, rm_kitchen)
	--put_at(selected_actor, 160, 48, rm_hall)
	--put_at(selected_actor, 16, 48, rm_computer)
	--put_at(selected_actor, 110, 38, rm_garden)
	put_at(selected_actor, 110, 38, rm_library)
	
	-- make camera follow player
	-- (setting now, will be re-instated after cutscene)
	camera_follow(selected_actor)

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	--change_room(rm_title, 1) -- iris fade
	--room_curr = rm_kitchen
	--room_curr = rm_hall
	--room_curr = rm_computer
	--room_curr = rm_garden
	room_curr = rm_library
end


-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)




function shake(cl) if cl then
cm=1 end cn=cl end function co(cp) local cq=nil if has_flag(cp.classes,"class_talkable") then
cq="talkto"elseif has_flag(cp.classes,"class_openable") then if cp.state=="state_closed"then
cq="open"else cq="close"end else cq="lookat"end for cr in all(verbs) do cs=get_verb(cr) if cs[2]==cq then cq=cr break end
end return cq end function ct(cu,cv,cw) local cx=has_flag(cv.classes,"class_actor") if cu=="walkto"then
return elseif cu=="pickup"then if cx then
say_line"i don't need them"else say_line"i don't need that"end elseif cu=="use"then if cx then
say_line"i can't just *use* someone"end if cw then
if has_flag(cw.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif cu=="give"then if cx then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif cu=="lookat"then if cx then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif cu=="open"then if cx then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif cu=="close"then if cx then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif cu=="push"or cu=="pull"then if cx then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif cu=="talkto"then if cx then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cy) cz=da(cy) db=nil dc=nil end function camera_follow(dd) stop_script(de) dc=dd db=nil de=function() while dc do if dc.in_room==room_curr then
cz=da(dc) end yield() end end start_script(de,true) if dc.in_room!=room_curr then
change_room(dc.in_room,1) end end function camera_pan_to(cy) db=da(cy) dc=nil de=function() while(true) do if cz==db then
db=nil return elseif db>cz then cz+=0.5 else cz-=0.5 end yield() end end start_script(de,true) end function wait_for_camera() while script_running(de) do yield() end end function cutscene(type,df,dg) dh={di=type,dj=cocreate(df),dk=dg,dl=dc} add(dm,dh) dn=dh break_time() end function dialog_set(dp) for msg in all(dp) do dialog_add(msg) end end function dialog_add(msg) if not dq then dq={dr={},ds=false} end
dt=du(msg,32) dv=dw(dt) dx={num=#dq.dr+1,msg=msg,dt=dt,dy=dv} add(dq.dr,dx) end function dialog_start(col,dz) dq.col=col dq.dz=dz dq.ds=true selected_sentence=nil end function dialog_hide() dq.ds=false end function dialog_clear() dq.dr={} selected_sentence=nil end function dialog_end() dq=nil end function get_use_pos(cp) local ea=cp.use_pos local x=cp.x local y=cp.y if type(ea)=="table"then
x=ea[1] y=ea[2] elseif ea=="pos_left"then if cp.eb then
x-=(cp.w*8+4) y+=1 else x-=2 y+=((cp.h*8)-2) end elseif ea=="pos_right"then x+=(cp.w*8) y+=((cp.h*8)-2) elseif ea=="pos_above"then x+=((cp.w*8)/2)-4 y-=2 elseif ea=="pos_center"then x+=((cp.w*8)/2) y+=((cp.h*8)/2)-4 elseif ea=="pos_infront"or ea==nil then x+=((cp.w*8)/2)-4 y+=(cp.h*8)+2 end return{x=x,y=y} end function do_anim(dd,ec,ed) ee={"face_front","face_left","face_back","face_right"} if ec=="anim_face"then
if type(ed)=="table"then
ef=atan2(dd.x-ed.x,ed.y-dd.y) eg=93*(3.1415/180) ef=eg-ef eh=ef*360 eh=eh%360 if eh<0 then eh+=360 end
ed=4-flr(eh/90) ed=ee[ed] end face_dir=ei[dd.face_dir] ed=ei[ed] while face_dir!=ed do if face_dir<ed then
face_dir+=1 else face_dir-=1 end dd.face_dir=ee[face_dir] dd.flip=(dd.face_dir=="face_left") break_time(10) end end end function open_door(ej,ek) if ej.state=="state_open"then
say_line"it's already open"else ej.state="state_open"if ek then ek.state="state_open"end
end end function close_door(ej,ek) if ej.state=="state_closed"then
say_line"it's already closed"else ej.state="state_closed"if ek then ek.state="state_closed"end
end end function come_out_door(el,em,en) if em==nil then
eo("target door does not exist") return end if el.state=="state_open"then
ep=em.in_room if ep!=room_curr then
change_room(ep,en) end local eq=get_use_pos(em) er(selected_actor,eq.x,eq.y,ep) es={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if em.use_dir then
et=es[em.use_dir] else et=1 end selected_actor.face_dir=et selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eu,bk) if bk==1 then
ev=0 else ev=50 end while true do ev+=bk*2 if ev>50
or ev<0 then return end if eu==1 then
ew=min(ev,32) end yield() end end function change_room(ep,eu) if ep==nil then
eo("room does not exist") return end stop_script(ex) if eu and room_curr then
fades(eu,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ey={} ez() room_curr=ep if not dc
or dc.in_room!=room_curr then cz=0 end stop_talking() if eu then
ex=function() fades(eu,-1) end start_script(ex,true) else ew=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(cu,fa) if not fa
or not fa.verbs then return false end if type(cu)=="table"then
if fa.verbs[cu[1]] then return true end
else if fa.verbs[cu] then return true end
end return false end function pickup_obj(cp,dd) dd=dd or selected_actor add(dd.cj,cp) cp.owner=dd del(cp.in_room.objects,cp) end function start_script(fb,fc,fd,fe) local dj=cocreate(fb) local scripts=ey if fc then
scripts=ff end add(scripts,{fb,dj,fd,fe}) end function script_running(fb) for fg in all({ey,ff}) do for fh,fi in pairs(fg) do if fi[1]==fb then
return fi end end end return false end function stop_script(fb) fi=script_running(fb) if fi then
del(ey,fi) del(ff,fi) end end function break_time(fj) fj=fj or 1 for x=1,fj do yield() end end function wait_for_message() while fk!=nil do yield() end end function say_line(dd,msg,fl,fm) if type(dd)=="string"then
msg=dd dd=selected_actor end fn=dd.y-(dd.h)*8+4 fo=dd print_line(msg,dd.x,fn,dd.col,1,fl,fm) end function stop_talking() fk,fo=nil,nil end function print_line(msg,x,y,col,fp,fl,fm) local col=col or 7 local fp=fp or 0 if fp==1 then
fq=min(x-cz,127-(x-cz)) else fq=127-(x-cz) end local fr=max(flr(fq/2),16) local fs=""for ft=1,#msg do local fu=sub(msg,ft,ft) if fu==":"then
fs=sub(msg,ft+1) msg=sub(msg,1,ft-1) break end end local dt=du(msg,fr) local dv=dw(dt) fv=x-cz if fp==1 then
fv-=((dv*4)/2) end fv=max(2,fv) fn=max(18,y) fv=min(fv,127-(dv*4)-1) fk={fw=dt,x=fv,y=fn,col=col,fp=fp,fx=(#msg)*8,dy=dv,fl=fl} if#fs>0 then
fy=fo wait_for_message() fo=fy print_line(fs,x,y,col,fp,fl) end if not fm then
wait_for_message() end end function put_at(cp,x,y,fz) if fz then
if not has_flag(cp.classes,"class_actor") then
if cp.in_room then del(cp.in_room.objects,cp) end
add(fz.objects,cp) cp.owner=nil end cp.in_room=fz end cp.x,cp.y=x,y end function stop_actor(dd) dd.ga=0 ez() end function walk_to(dd,x,y) local gb=gc(dd) local gd=flr(x/8)+room_curr.map[1] local ge=flr(y/8)+room_curr.map[2] local gf={gd,ge} local gg=gh(gb,gf) dd.ga=1 for gi in all(gg) do local gj=(gi[1]-room_curr.map[1])*8+4 local gk=(gi[2]-room_curr.map[2])*8+4 local gl=sqrt((gj-dd.x)^2+(gk-dd.y)^2) local gm=dd.walk_speed*(gj-dd.x)/gl local gn=dd.walk_speed*(gk-dd.y)/gl if dd.ga==0 then
return end if gl>5 then
dd.flip=(gm<0) if abs(gm)<0.4 then
if gn>0 then
dd.go=dd.walk_anim_front dd.face_dir="face_front"else dd.go=dd.walk_anim_back dd.face_dir="face_back"end else dd.go=dd.walk_anim_side dd.face_dir="face_right"if dd.flip then dd.face_dir="face_left"end
end for ft=0,gl/dd.walk_speed do dd.x+=gm dd.y+=gn yield() end end end dd.ga=2 end function wait_for_actor(dd) dd=dd or selected_actor while dd.ga!=2 do yield() end end function proximity(cv,cw) if cv.in_room==cw.in_room then
local gl=sqrt((cv.x-cw.x)^2+(cv.y-cw.y)^2) return gl else return 1000 end end gp=16 cz,db,de,cm=0,nil,nil,0 gq,gr,gs,gt=63.5,63.5,0,1 gu={7,12,13,13,12,7} gv={{spr=208,x=75,y=gp+60},{spr=240,x=75,y=gp+72}} ei={face_front=1,face_left=2,face_back=3,face_right=4} function gw(cp) local gx={} for fh,cr in pairs(cp) do add(gx,fh) end return gx end function get_verb(cp) local cu={} local gx=gw(cp[1]) add(cu,gx[1]) add(cu,cp[1][gx[1]]) add(cu,cp.text) return cu end function ez() gy=get_verb(verb_default) gz,ha,o,hb,hc=nil,nil,nil,false,""end ez() fk=nil dq=nil dn=nil fo=nil ff={} ey={} dm={} hd={} ew,ew=0,0 he=0 function _init() if enable_mouse then poke(0x5f2d,1) end
hf() start_script(startup_script,true) end function _update60() hg() end function _draw() hh() end function hg() if selected_actor and selected_actor.dj
and not coresume(selected_actor.dj) then selected_actor.dj=nil end hi(ff) if dn then
if dn.dj
and not coresume(dn.dj) then if dn.di!=3
and dn.dl then camera_follow(dn.dl) selected_actor=dn.dl end del(dm,dn) if#dm>0 then
dn=dm[#dm] else if dn.di!=2 then
he=3 end dn=nil end end else hi(ey) end hj() hk() hl,hm=1.5-rnd(3),1.5-rnd(3) hl=flr(hl*cm) hm=flr(hm*cm) if not cn then
cm*=0.90 if cm<0.05 then cm=0 end
end end function hh() rectfill(0,0,127,127,0) camera(cz+hl,0+hm) clip(0+ew-hl,gp+ew-hm,128-ew*2-hl,64-ew*2) hn() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,gp-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,gp-8,8) end if show_debuginfo then
print("x: "..flr(gq+cz).." y:"..gr-gp,80,gp-8,8) end ho() if dq
and dq.ds then hp() hq() return end if he>0 then
he-=1 return end if not dn then
hr() end if(not dn
or dn.di==2) and he==0 then hs() else end if not dn then
hq() end end function hj() if dn then
if btnp(4) and btnp(5) and dn.dk then
dn.dj=cocreate(dn.dk) dn.dk=nil return end return end if btn(0) then gq-=1 end
if btn(1) then gq+=1 end
if btn(2) then gr-=1 end
if btn(3) then gr+=1 end
if btnp(4) then ht(1) end
if btnp(5) then ht(2) end
if enable_mouse then
hu,hv=stat(32)-1,stat(33)-1 if hu!=hw then gq=hu end
if hv!=hx then gr=hv end
if stat(34)>0 then
if not hy then
ht(stat(34)) hy=true end else hy=false end hw=hu hx=hv end gq=mid(0,gq,127) gr=mid(0,gr,127) end function ht(hz) local ia=gy if not selected_actor then
return end if dq and dq.ds then
if ib then
selected_sentence=ib end return end if ic then
gy=get_verb(ic) elseif id then if hz==1 then
if(gy[2]=="use"or gy[2]=="give")
and gz then ha=id else gz=id end elseif ie then gy=get_verb(ie) gz=id gw(gz) hr() end elseif ig then if ig==gv[1] then
if selected_actor.ih>0 then
selected_actor.ih-=1 end else if selected_actor.ih+2<flr(#selected_actor.cj/4) then
selected_actor.ih+=1 end end return end if gz!=nil
and not hb then if gy[2]=="use"or gy[2]=="give"then
if ha then
elseif gz.use_with and gz.owner==selected_actor then return end end hb=true selected_actor.dj=cocreate(function() if(not gz.owner
and(not has_flag(gz.classes,"class_actor") or gy[2]!="use")) or ha then ii=ha or gz ij=get_use_pos(ii) walk_to(selected_actor,ij.x,ij.y) if selected_actor.ga!=2 then return end
use_dir=ii if ii.use_dir then use_dir=ii.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gy,gz) then
start_script(gz.verbs[gy[1]],false,gz,ha) else if has_flag(gz.classes,"class_door") then
if gy[1]=="walkto"then
come_out_door(gz,gz.target_door) elseif gy[1]=="open"then open_door(gz,gz.target_door) elseif gy[1]=="close"then close_door(gz,gz.target_door) end else ct(gy[2],gz,ha) end end ez() end) coresume(selected_actor.dj) elseif gr>gp and gr<gp+64 then hb=true selected_actor.dj=cocreate(function() walk_to(selected_actor,gq+cz,gr-gp) ez() end) coresume(selected_actor.dj) end end function hk() if not room_curr then
return end ic,ie,id,ib,ig=nil,nil,nil,nil,nil if dq
and dq.ds then for fg in all(dq.dr) do if ik(fg) then
ib=fg end end return end il() for cp in all(room_curr.objects) do if(not cp.classes
or(cp.classes and not has_flag(cp.classes,"class_untouchable"))) and(not cp.dependent_on or cp.dependent_on.state==cp.dependent_on_state) then im(cp,cp.w*8,cp.h*8,cz,io) else cp.ip=nil end if ik(cp) then
if not id
or(not cp.z and id.z<0) or(cp.z and id.z and cp.z>id.z) then id=cp end end iq(cp) end for fh,dd in pairs(actors) do if dd.in_room==room_curr then
im(dd,dd.w*8,dd.h*8,cz,io) iq(dd) if ik(dd)
and dd!=selected_actor then a("hover actor!") id=dd end end end if selected_actor then
for cr in all(verbs) do if ik(cr) then
ic=cr end end for ir in all(gv) do if ik(ir) then
ig=ir end end for fh,cp in pairs(selected_actor.cj) do if ik(cp) then
id=cp if gy[2]=="pickup"and id.owner then
gy=nil end end if cp.owner!=selected_actor then
del(selected_actor.cj,cp) end end if gy==nil then
gy=get_verb(verb_default) end if id then
ie=co(id) end end end function il() hd={} for x=-64,64 do hd[x]={} end end function iq(cp) fn=-1 if cp.is then
fn=cp.y else fn=cp.y+(cp.h*8) end it=flr(fn) if cp.z then
it=cp.z end add(hd[it],cp) end function hn() if not room_curr then
print("-error-  no current room set",5+cz,5+gp,8,0) return end rectfill(0,gp,127,gp+64,room_curr.iu or 0) for z=-64,64 do if z==0 then
iv(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,gp,room_curr.iw,room_curr.ix) pal() else it=hd[z] for cp in all(it) do if not has_flag(cp.classes,"class_actor") then
if cp.states
or(cp.state and cp[cp.state] and cp[cp.state]>0) and(not cp.dependent_on or cp.dependent_on.state==cp.dependent_on_state) and not cp.owner or cp.draw then iy(cp) end else if cp.in_room==room_curr then
iz(cp) end end ja(cp) end end end end function iv(cp) if cp.col_replace then
jb=cp.col_replace pal(jb[1],jb[2]) end if cp.lighting then
jc(cp.lighting) elseif cp.in_room and cp.in_room.lighting then jc(cp.in_room.lighting) end end function iy(cp) iv(cp) if cp.draw then
cp.draw(cp) else jd=1 if cp.repeat_x then jd=cp.repeat_x end
for h=0,jd-1 do local je=0 if cp.states then
je=cp.states[cp.state] else je=cp[cp.state] end jf(je,cp.x+(h*(cp.w*8)),cp.y,cp.w,cp.h,cp.trans_col,cp.flip_x) end end pal() end function iz(dd) jg=ei[dd.face_dir] if dd.ga==1
and dd.go then dd.jh+=1 if dd.jh>dd.frame_delay then
dd.jh=1 dd.ji+=1 if dd.ji>#dd.go then dd.ji=1 end
end jj=dd.go[dd.ji] else jj=dd.idle[jg] end iv(dd) jf(jj,dd.eb,dd.is,dd.w,dd.h,dd.trans_col,dd.flip,false) if fo
and fo==dd and fo.talk then if dd.jk<7 then
jj=dd.talk[jg] jf(jj,dd.eb,dd.is+8,1,1,dd.trans_col,dd.flip,false) end dd.jk+=1 if dd.jk>14 then dd.jk=1 end
end pal() end function hr() jl=""jm=12 jn=gy[2] if not hb then
if gy then
jl=gy[3] end if gz then
jl=jl.." "..gz.name if jn=="use"then
jl=jl.." with"elseif jn=="give"then jl=jl.." to"end end if ha then
jl=jl.." "..ha.name elseif id and id.name!=""and(not gz or(gz!=id)) and(not id.owner or jn!=get_verb(verb_default)[2]) then jl=jl.." "..id.name end hc=jl else jl=hc jm=7 end print(jo(jl),jp(jl),gp+66,jm) end function ho() if fk then
jq=0 for jr in all(fk.fw) do js=0 if fk.fp==1 then
js=((fk.dy*4)-(#jr*4))/2 end jt(jr,fk.x+js,fk.y+jq,fk.col,0,fk.fl) jq+=6 end fk.fx-=1 if fk.fx<=0 then
stop_talking() end end end function hs() fv,fn,ju=0,75,0 for cr in all(verbs) do jv=verb_maincol if ie
and cr==ie then jv=verb_defcol end if cr==ic then jv=verb_hovcol end
cs=get_verb(cr) print(cs[3],fv,fn+gp+1,verb_shadcol) print(cs[3],fv,fn+gp,jv) cr.x=fv cr.y=fn im(cr,#cs[3]*4,5,0,0) ja(cr) if#cs[3]>ju then ju=#cs[3] end
fn+=8 if fn>=95 then
fn=75 fv+=(ju+1.0)*4 ju=0 end end if selected_actor then
fv,fn=86,76 jw=selected_actor.ih*4 jx=min(jw+8,#selected_actor.cj) for jy=1,8 do rectfill(fv-1,gp+fn-1,fv+8,gp+fn+8,1) cp=selected_actor.cj[jw+jy] if cp then
cp.x,cp.y=fv,fn iy(cp) im(cp,cp.w*8,cp.h*8,0,0) ja(cp) end fv+=11 if fv>=125 then
fn+=12 fv=86 end jy+=1 end for ft=1,2 do jz=gv[ft] if ig==jz then pal(verb_maincol,7) end
jf(jz.spr,jz.x,jz.y,1,1,0) im(jz,8,7,0,0) ja(jz) pal() end end end function hp() fv,fn=0,70 for fg in all(dq.dr) do if fg.dy>0 then
fg.x,fg.y=fv,fn im(fg,fg.dy*4,#fg.dt*5,0,0) jv=dq.col if fg==ib then jv=dq.dz end
for jr in all(fg.dt) do print(jo(jr),fv,fn+gp,jv) fn+=5 end ja(fg) fn+=2 end end end function hq() col=gu[gt] pal(7,col) spr(224,gq-4,gr-3,1,1,0) pal() gs+=1 if gs>7 then
gs=1 gt+=1 if gt>#gu then gt=1 end
end end function jf(ka,x,y,w,h,kb,flip_x,kc) set_trans_col(kb,true) spr(ka,x,gp+y,w,h,flip_x,kc) end function set_trans_col(kb,cl) palt(0,false) palt(kb,true) if kb and kb>0 then
palt(0,false) end end function hf() for fz in all(rooms) do kd(fz) if(#fz.map>2) then
fz.iw=fz.map[3]-fz.map[1]+1 fz.ix=fz.map[4]-fz.map[2]+1 else fz.iw=16 fz.ix=8 end for cp in all(fz.objects) do kd(cp) cp.in_room=fz cp.h=cp.h or 0 if cp.init then
cp.init(cp) end end end for ke,dd in pairs(actors) do kd(dd) dd.ga=2 dd.jh=1 dd.jk=1 dd.ji=1 dd.cj={} dd.ih=0 end end function ja(cp) local kf=cp.ip if show_collision
and kf then rect(kf.x,kf.y,kf.kg,kf.kh,8) end end function hi(scripts) for fi in all(scripts) do if fi[2] and not coresume(fi[2],fi[3],fi[4]) then
del(scripts,fi) fi=nil end end end function jc(ki) if ki then ki=1-ki end
local gi=flr(mid(0,ki,1)*100) local kj={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kk=1,15 do col=kk kl=(gi+(kk*1.46))/22 for fh=1,kl do col=kj[col] end pal(kk,col) end end function da(cy) if type(cy)=="table"then
cy=cy.x end return mid(0,cy-64,(room_curr.iw*8)-128) end function gc(cp) local gd=flr(cp.x/8)+room_curr.map[1] local ge=flr(cp.y/8)+room_curr.map[2] return{gd,ge} end function km(gd,ge) local kn=mget(gd,ge) local ko=fget(kn,0) return ko end function du(msg,fr) local dt={} local kp=""local kq=""local fu=""local kr=function(ks) if#kq+#kp>ks then
add(dt,kp) kp=""end kp=kp..kq kq=""end for ft=1,#msg do fu=sub(msg,ft,ft) kq=kq..fu if fu==" "
or#kq>fr-1 then kr(fr) elseif#kq>fr-1 then kq=kq.."-"kr(fr) elseif fu==";"then kp=kp..sub(kq,1,#kq-1) kq=""kr(0) end end kr(fr) if kp!=""then
add(dt,kp) end return dt end function dw(dt) dv=0 for jr in all(dt) do if#jr>dv then dv=#jr end
end return dv end function has_flag(cp,kt) for bl in all(cp) do if bl==kt then
return true end end return false end function im(cp,w,h,ku,kv) x=cp.x y=cp.y if has_flag(cp.classes,"class_actor") then
cp.eb=x-(cp.w*8)/2 cp.is=y-(cp.h*8)+1 x=cp.eb y=cp.is end cp.ip={x=x,y=y+gp,kg=x+w-1,kh=y+h+gp-1,ku=ku,kv=kv} end function gh(kw,kx) local ky,kz,la,lb,lc={},{},{},nil,nil ld(ky,kw,0) kz[le(kw)]=nil la[le(kw)]=0 while#ky>0 and#ky<1000 do local lf=ky[#ky] del(ky,ky[#ky]) lg=lf[1] if le(lg)==le(kx) then
break end local lh={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local li=lg[1]+x local lj=lg[2]+y if abs(x)!=abs(y) then lk=1 else lk=1.4 end
if li>=room_curr.map[1] and li<=room_curr.map[1]+room_curr.iw
and lj>=room_curr.map[2] and lj<=room_curr.map[2]+room_curr.ix and km(li,lj) and((abs(x)!=abs(y)) or km(li,lg[2]) or km(li-x,lj)) then add(lh,{li,lj,lk}) end end end end for ll in all(lh) do local lm=le(ll) local ln=la[le(lg)]+ll[3] if not la[lm]
or ln<la[lm] then la[lm]=ln local h=max(abs(kx[1]-ll[1]),abs(kx[2]-ll[2])) local lo=ln+h ld(ky,ll,lo) kz[lm]=lg if not lb
or h<lb then lb=h lc=lm lp=ll end end end end local gg={} lg=kz[le(kx)] if lg then
add(gg,kx) elseif lc then lg=kz[lc] add(gg,lp) end if lg then
local lq=le(lg) local lr=le(kw) while lq!=lr do add(gg,lg) lg=kz[lq] lq=le(lg) end for ft=1,#gg/2 do local lt=gg[ft] local lu=#gg-(ft-1) gg[ft]=gg[lu] gg[lu]=lt end end return gg end function ld(lv,cy,gi) if#lv>=1 then
add(lv,{}) for ft=(#lv),2,-1 do local ll=lv[ft-1] if gi<ll[2] then
lv[ft]={cy,gi} return else lv[ft]=ll end end lv[1]={cy,gi} else add(lv,{cy,gi}) end end function le(lw) return((lw[1]+1)*16)+lw[2] end function eo(msg) print_line("-error-;"..msg,5+cz,5,8,0) end function kd(cp) local dt=lx(cp.data,"\n") for jr in all(dt) do local pairs=lx(jr,"=") if#pairs==2 then
cp[pairs[1]]=ly(pairs[2]) else printh("invalid data line") end end end function lx(fg,lz) local ma={} local jw=0 local mb=0 for ft=1,#fg do local mc=sub(fg,ft,ft) if mc==lz then
add(ma,sub(fg,jw,mb)) jw=0 mb=0 elseif mc!=" "and mc!="\t"then mb=ft if jw==0 then jw=ft end
end end if jw+mb>0 then
add(ma,sub(fg,jw,mb)) end return ma end function ly(md) local me=sub(md,1,1) local ma=nil if md=="true"then
ma=true elseif md=="false"then ma=false elseif mf(me) then if me=="-"then
ma=sub(md,2,#md)*-1 else ma=md+0 end elseif me=="{"then local lt=sub(md,2,#md-1) ma=lx(lt,",") mg={} for cy in all(ma) do cy=ly(cy) add(mg,cy) end ma=mg else ma=md end return ma end function mf(jb) for a=1,13 do if jb==sub("0123456789.-+",a,a) then
return true end end end function jt(mh,x,y,mi,mj,fl) if not fl then mh=jo(mh) end
for mk=-1,1 do for ml=-1,1 do print(mh,x+mk,y+ml,mj) end end print(mh,x,y,mi) end function jp(fg) return 63.5-flr((#fg*4)/2) end function mm(fg) return 61 end function ik(cp) if not cp.ip
or dn then return false end ip=cp.ip if(gq+ip.ku>ip.kg or gq+ip.ku<ip.x)
or(gr>ip.kh or gr<ip.y) then return false else return true end end function jo(fg) local a=""local jr,jb,lv=false,false for ft=1,#fg do local ir=sub(fg,ft,ft) if ir=="^"then
if jb then a=a..ir end
jb=not jb elseif ir=="~"then if lv then a=a..ir end
lv,jr=not lv,not jr else if jb==jr and ir>="a"and ir<="z"then
for kk=1,26 do if ir==sub("abcdefghijklmnopqrstuvwxyz",kk,kk) then
ir=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kk,kk) break end end end a=a..ir jb,lv=false,false end end return a end









__gfx__
0000000000000000000000000000000044444444440000004444444477777777f9e9f9f9ddd5ddd5bbbbbbbb5500000010101010000000000000000000000000
00000000000000000000000000000000444444404400000044444444777777779eee9f9fdd5ddd5dbbbbbbbb5555000001010101000000000000000000000000
00800800000000000000000000000000aaaaaa00aaaa000005aaaaaa77777777feeef9f9d5ddd5ddbbbbbbbb5555550010101010000000000000000000000000
0008800055555555ddddddddeeeeeeee999990009999000005999999777777779fef9fef5ddd5dddbbbbbbbb5555555501010101000000000000000000000000
0008800055555555ddddddddeeeeeeee44440000444444000005444477777777f9f9feeeddd5ddd5bbbbbbbb5555555510101010000000000000000000000000
0080080055555555ddddddddeeeeeeee444000004444440000054444777777779f9f9eeedd5ddd5dbbbbbbbb5555555501010101000000000000000000000000
0000000055555555ddddddddeeeeeeeeaa000000aaaaaaaa000005aa77777777f9f9feeed5ddd5ddbbbbbbbb5555555510101010000000000000000000000000
0000000055555555ddddddddeeeeeeee900000009999999900000599777777779f9f9fef5ddd5dddbbbbbbbb5555555501010101000000000000000000000000
0000000077777755666666ddbbbbbbee888888553333333313131344666666665888858866666666cbcbcbcb0000005510101044000000000000000088845888
00000000777755556666ddddbbbbeeee88888855333333333131314466666666588885881c1c1c1cbcbcbcbc0000555501010144000000000000000088845888
000010007755555566ddddddbbeeeeee88887777333333331313aaaa6666666655555555c1c1c1c1cbcbcbcb005555551010aaaa000000000000000088845888
0000c00055555555ddddddddeeeeeeee88886666333333333131999966666666888588881c1c1c1cbcbcbcbc5555555501019999000000000000000088845888
001c7c1055555555ddddddddeeeeeeee8855555533333333134444446666666688858888c1c1c1c1cbcbcbcb5555555510444444000000000000000088845888
0000c00055555555ddddddddeeeeeeee88555555333333333144444466666666555555551c1c1c1cbcbcbcbc5555555501444444000000000000000088845888
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
9f00d70000c00065000000000000000070000007700000077070000000000707bcbcbc40040cbcbc888888888888888888888888d50000004ffffff44ffffff4
9f2ed728b3c55565000000000000000070000007700000077007000000007007cbcbc4444440cbcb888888888888888888888888d51000004f4444944f444494
9f2ed728b3c50565000000000000000070000007700000077000600000060007bcbc440000440cbc888888888888888888888888d51000004f4444944f444494
9f2ed728b3c50565000000000000000070000007700000077000600000060007cbc44022220440cb888666666666688888866666d51000004f4444944f444494
9f2ed728b3c55565000000000000000070000007700000077000600000060007bc4402555540440c888600000000688888860000d51000004f4444944f444494
9f2ed728b3c55565000000000000000070000007700000077000600000060007c4402500aa54040b888600000000688888860b00d51000004f4444944f444494
4444444444444444000000000000000077777777777777777777600000067777b4405aaaaaa50440888600000000688888860000d51000004f4444944f444494
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
44494944166666650000000056666651d6dd6dd60000000044494444444494444424a00000024504555555555555555588944488006660004f4444944f499444
444949441d6dd6d5000000005d6dd651d6dd6dd6000000004449444444449444ff24a0000002450f555555555555555588944488006760004f4444944f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494444424a00000024504555555555555555588944488006560004f44449444444400
444949441666666500000000566666516dd6dd6d0000000044494444444494444424a00000024504555555555555555588944488006660004f44449444440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994444424a00000024504555555555555555588944488000000004f44449444000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444444424a00000024504555555555555555588944488000000004f44449400000000
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccffffffff
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccf666677f
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccc7cccccc7
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaccccd776666d
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000caaaccccf676650f
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
aaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccff7665ff
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fff76fffffffffff
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fff76ffff666677f
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fbbbbccf75555557
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000bbbcccc8d776666d
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fccccc8ff676650f
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffffffff000000000000000000000000fccc888ff676650f
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000fff22fff000000000000000000000000fff00ffff676650f
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ff0020ff000000000000000000000000fff00fffff7665ff
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ff2302ffff2302ff0000000000007aa0fff76fff00000094
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ffb33bffffb33bff00000000000070a0fff76fff00000944
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff000000000000aaa0f8888bbf00009440
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ff2222ffff2222ff00000000000a4440888bbbbc00094400
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff0000000000a40000fbbbbbcf00044000
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000f2b33b2ff2b33b2f000000000a400000fbbbcccf00400000
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000f22bb22ff2b33b2f0000000074a90000fff00fff94000000
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000f222222ff22bb22f00000000007a0000fff00fff44000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f222222f00000000000000000066060bfff76fffcccccccc
00000000000000000000000000000000000000000000000000000000000000000000000000000000f22bb22f000000000000000000660600fff76fffc000000c
00000000000000000000000000000000000000000000000000000000000000000000000000000000f2b33b2f000000000000000000666600fcccc88fc0c00c0c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022b33b22000000000000000000000000ccc8888bc00cc00c
00000000000000000000000000000000000000000000000000000000000000000000000000000000222bb222000000000000000007777770f88888bfc00cc00c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022222222000000000000000007777770f888bbbfc0c00c0c
0000000000000000000000000000000000000000000000000000000000000000000000000000000022222222000000000000000007777770fff00fffc000000c
00000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbb000000000000000008888880fff00fffcccccccc
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
0001010101010100000000010000000000010101010101000000000101000000000101010101010101010101000000000001010101010100000000000000000000000000000000000000808000000000000000000000000000008080000000000000000000008080000000008000000000000000000000000000010180000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000002000000000000000000001010101010101010101010101010101010101010101010101010101010101010101010101010101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000002000000000100002020202020202020202020202020202020202020202020202020202020202020202020202020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010103030303030303030303030303030303030303030303030303030303030303030303030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202020202020202020202020202020204040404040404040404040404040404040404040404040404040404040404040404040404040404
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030305050505050505050505050505050505050505050505050505050505050505050505050505050505
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404040404040404040404040404040415151515151515151515151515151515151615151515151515151515151515151515151515151515
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000505050505050505050505050505050539393939393939393939393939393939393a39393939393939393939393939393939393939393939
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000606060606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017191a000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000270a2a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001718072a0000000000000000000000000000000000000000000000001718191a0000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070a072a00000000000000000000000000000000000000000000000027070a2a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707191a00000000000000000000000000000000000000001718071b072a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707382a0000000000000000000000000000000000001718280a0a072b2a1718191a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707072a0000000000000000000000000000000000003737270707073b2a270a072a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021222122212221222122212221222122212221222122212221223233323332333233323332333233
00000000000000000020000000000020070707171717171717171717170707070707071a1a1a1a1a1a1a405040501a1a1a1a1a1a1a070707484900004a4b000007070709090909090909090909070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00200000000000000000000000100000070707171717171717171717170707070707071a1a1a1a1a1a1a504050401a1a1a1a1a1a1a070707585900005a5b000007070709000009090909444509070707070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00000020000000000000000000000000070007171717171717171717170700070700071a1a1a001a1a1a405040501a1a1a001a1a1a070007686966676c6c666707000709000009090909545509070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
000000000000000000000000000000000700071717171717171717171707000707000762626200626262666766676262620062626207000778797c002e1f3e7c07000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000000000070007171717171717171717170700070700077474740074747476777677747474007474740700076a6b002e1f3e2a0007000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000002000070111313131313131313131312101070701113131313131313131313131313131313131312101077a7b001f3e2a000007011131313131313131313131212807070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
00000000001000000020000000000000113131313131313131313131313131211131313131313125151515151515153531313131313131210000003e2c00000011313131313125151535313131313121113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
2000000000000000000020000000000031313131313131313131313131313131292929292929292929292929292929292626292929292929143434343424000031313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
00000010000020000000000061626262626262626262626262626263000000100707071a48491a1a1a1a0c0c0c0c1c2b2a1a1a1a1a070707070707504050405040504040405040504050405040070707171717090909090909090909090909090909090909171717000000100000616262626262626262626262626200000010
00200000000000100000002071447144714473004e71447344734473000020000707071a58591a1a1a1a0c0c0c1c2b2a1a1a1a1a1a07070707070740504050405040504050405040504050405007070717171709090909090909444444450909090909090917171700200000002071447474744473b271447474447400002000
20000000002000000020000071647164716473005e71647364736473200000000700071a68691a1a1a1a0c0c1c2b2a1a4e001a1a1a070007070707504050005050504050405040004000405040070707170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f
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
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000100000000000000000000000000000000000000014000100000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10001000014000140001400014001c4011c4011c0611c0611c0611c061000000000004124041243b65b3b65b00000000003f77f3f77f114011140100000000000000000000086490824800000000000000000000
010101011000110001114011140101701017010170c0170c000000000004124041243b6543065b10640192003f77f3f77f1164919641000000000000000000001864909248000400020000400004000140001400
1111111111061110611c0611c0611c0611c061000000000004124041243b2200045b102501a2003f77f3f77f2125a2a2510000000000000000000018649092480000808000000000000000001000011000110001
1c1c1c1c1140c1140c0170c0170c00000000000412404124041000000000000000003f77f3f77f2125a2a25100000000000000000000086490824800008080000100001000014000140001400014001c4011c401
c1c1c1c11c0611c061000000000004124041240000000000102501a2003f77f3f77f2125a2a251000000000000000000000867f08248000400020000000000001000010000100011000111401114010170101701
00000000000000000004124041240000000000102501a2003f77f3f77f2125a2a251000000000000000000003853707248000000000000400004000140001400014000140011061110611c0611c0611c0611c061
444444440412404124000000000000000000003f77f3f77f2125a2a251000000000000000000003753737148000000000000000000000000100001100011000111401114011140c1140c0170c0170c0000000000
00bbbbbb000000000000000000003f77f3f77f2125a2a251000000000000000000003f53737348000000000008248082481d76d1d76d11401114011c0611c0611c0611c0611c0611c0613b65b3b65b3b65b3b224
bbbbbbbb3b65b3b65b00000000002125a2a251000000000000000000003f53737348000000000008248082481d76d1d76d11401114010170c0170c0170c0170c0170c0170c3b65b3b65b3b65b04100000003b65b
0001010000000000002125a2a251000000000000000000001f52030348000000100008248082481d76d1d76d11401114011c0611c0611c0611c0611c0611c0613b65b3b65b3b22400000000000045b3b65b3b65b
a1aaaa1a2125a2a251000000000000000000001852000248000000c00008248082481d76d1d76d11401114010170c0170c2170e2170e2170e2170e3b65b3b65b041000000000000000003b65b3b65b0000000000
000000000000000000000000000018100002480040c0770008248082481d76d1d76d11401114011c0611c0612c0622c0622e0722e0723b65b3b224000000000000000000000045b3b65b10000100002125a2a251
0000000000000000000800800248000000c00008248082481d76d1d76d11401114010170c0170c2231e2231e227491921e3b65b0410000000000000000000000000003b65b00401010002125a2a2510000000000
888787880863807248000000100008248082481d76d1d76d11401114012c0622c06229442294421e25a2a6423b2240000000000000000000000000000000045b00000000002125a2a25100000000000000000000
00000000000000000008248082481d76d1d76d11401114012e37e2e37e19649196492925a2a259041000000000000000000000000000000000000000000000002125a2a251000000000000000000000800800048
49490049114010050111020114013c16c0736c1c26e2836e19649196493b65b3b65b3b6540000000000000003b65b3b65b000003065b114011140108649092480864909248086490924808649092480000000000
1010101009544095440c36c0c36c0e37c0e37c19649196493b65b3b65b3b6540000000000000003b65b3b65b000003065b01000000011864f0f2481864f0f2481864f0f2481864f0f24800000000001000110001
cccccccc0c7370c7370c35c0c35c19649196493b65b3b65b3b6540000000000000003b65b3b65b000003065b01400000011967f0f2481867f0f2481867f0f2481867f0f2480000c0000039500014000140001400
77cc99cc0e37c0e37c19649196493b65b3b65b3b6540000000000000003b65b3b65b000003065b01400000010864f0f2480964f0f2480964f0f2480964f0f2480000000000004311000139101100013753c0c36c
9999999919649196493b65b3b65b3b6540000000000000003b65b3b65b000003065b014000000108637082480863708248086370824808637082480000000000004400000000430000000c36c0c36c0e37c0e37c
bbbbbbbb3b65b3b65b3b6540000000000000003b65b3b65b000003065b014000000138537072483853707248385370724838537072480000000000000200000000440000000c36c375372c37e2c25a1964919649
bb4b00003b6540000000000000003b65b3b65b000003065b014000000138537373483853707248381370724838537072480000000000000211c061000211c0610c36c0c36c0c36c0c36c19649196493b65b3b65b
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

