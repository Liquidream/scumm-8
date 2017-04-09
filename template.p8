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

		rm_landing = {
			data = [[
				map = {32,16,55,31}
			]],
			objects = {
				obj_landing_exit_hall
			},
			enter = function(me)
				
			end,
			exit = function(me)

			end,
			scripts = {	  
			},
		}

	-- computer room
		-- objects
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




function shake(cf) if cf then
cg=1 end ch=cf end function ci(cj) local ck=nil if has_flag(cj.classes,"class_talkable") then
ck="talkto"elseif has_flag(cj.classes,"class_openable") then if cj.state=="state_closed"then
ck="open"else ck="close"end else ck="lookat"end for cl in all(verbs) do cm=get_verb(cl) if cm[2]==ck then ck=cl break end
end return ck end function cn(co,cp,cq) local cr=has_flag(cp.classes,"class_actor") if co=="walkto"then
return elseif co=="pickup"then if cr then
say_line"i don't need them"else say_line"i don't need that"end elseif co=="use"then if cr then
say_line"i can't just *use* someone"end if cq then
if has_flag(cq.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif co=="give"then if cr then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif co=="lookat"then if cr then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif co=="open"then if cr then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif co=="close"then if cr then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif co=="push"or co=="pull"then if cr then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif co=="talkto"then if cr then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cs) ct=cu(cs) cv=nil cw=nil end function camera_follow(cx) stop_script(cy) cw=cx cv=nil cy=function() while cw do if cw.in_room==room_curr then
ct=cu(cw) end yield() end end start_script(cy,true) if cw.in_room!=room_curr then
change_room(cw.in_room,1) end end function camera_pan_to(cs) cv=cu(cs) cw=nil cy=function() while(true) do if ct==cv then
cv=nil return elseif cv>ct then ct+=0.5 else ct-=0.5 end yield() end end start_script(cy,true) end function wait_for_camera() while script_running(cy) do yield() end end function cutscene(cz,da,db) dc={cz=cz,dd=cocreate(da),de=db,df=cw} add(dg,dc) dh=dc break_time() end function dialog_set(di) for msg in all(di) do dialog_add(msg) end end function dialog_add(msg) if not dj then dj={dk={},dl=false} end
dm=dn(msg,32) dp=dq(dm) dr={num=#dj.dk+1,msg=msg,dm=dm,ds=dp} add(dj.dk,dr) end function dialog_start(col,dt) dj.col=col dj.dt=dt dj.dl=true selected_sentence=nil end function dialog_hide() dj.dl=false end function dialog_clear() dj.dk={} selected_sentence=nil end function dialog_end() dj=nil end function get_use_pos(cj) local du=cj.use_pos local x=cj.x-ct local y=cj.y if type(du)=="table"then
x=du[1] y=du[2] elseif du=="pos_left"then if cj.dv then
x-=(cj.w*8+4) y+=1 else x-=2 y+=((cj.h*8)-2) end elseif du=="pos_right"then x+=(cj.w*8) y+=((cj.h*8)-2) elseif du=="pos_above"then x+=((cj.w*8)/2)-4 y-=2 elseif du=="pos_center"then x+=((cj.w*8)/2) y+=((cj.h*8)/2)-4 elseif du=="pos_infront"or du==nil then x+=((cj.w*8)/2)-4 y+=(cj.h*8)+2 end return{x=x,y=y} end function do_anim(cx,dw,dx) dy={"face_front","face_left","face_back","face_right"} if dw=="anim_face"then
if type(dx)=="table"then
dz=atan2(cx.x-dx.x,dx.y-cx.y) ea=93*(3.1415/180) dz=ea-dz eb=dz*360 eb=eb%360 if eb<0 then eb+=360 end
dx=4-flr(eb/90) dx=dy[dx] end face_dir=ec[cx.face_dir] dx=ec[dx] while face_dir!=dx do if face_dir<dx then
face_dir+=1 else face_dir-=1 end cx.face_dir=dy[face_dir] cx.flip=(cx.face_dir=="face_left") break_time(10) end end end function open_door(ed,ee) if ed.state=="state_open"then
say_line"it's already open"else ed.state="state_open"if ee then ee.state="state_open"end
end end function close_door(ed,ee) if ed.state=="state_closed"then
say_line"it's already closed"else ed.state="state_closed"if ee then ee.state="state_closed"end
end end function come_out_door(ef,eg,eh) if eg==nil then
ei("exit door does not exist") return end if ef.state=="state_open"then
ej=eg.in_room change_room(ej,eh) local ek=get_use_pos(eg) put_actor_at(selected_actor,ek.x,ek.y,ej) el={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if eg.use_dir then
em=el[eg.use_dir] else em=1 end selected_actor.face_dir=em selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(en,bp) if bp==1 then
eo=0 else eo=50 end while true do eo+=bp*2 if eo>50
or eo<0 then return end if en==1 then
ep=min(eo,32) end yield() end end function change_room(ej,en) if ej==nil then
ei("room does not exist") return end stop_script(eq) if en and room_curr then
fades(en,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end er={} es() room_curr=ej if not cw
or cw.in_room!=room_curr then ct=0 end stop_talking() if en then
eq=function() fades(en,-1) end start_script(eq,true) else ep=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(co,et) if not et
or not et.verbs then return false end if type(co)=="table"then
if et.verbs[co[1]] then return true end
else if et.verbs[co] then return true end
end return false end function pickup_obj(cj,cx) cx=cx or selected_actor add(cx.cd,cj) cj.owner=cx del(cj.in_room.objects,cj) end function start_script(eu,ev,ew,bg) local dd=cocreate(eu) local scripts=er if ev then
scripts=ex end add(scripts,{eu,dd,ew,bg}) end function script_running(eu) for ey in all({er,ex}) do for ez,fa in pairs(ey) do if fa[1]==eu then
return fa end end end return false end function stop_script(eu) fa=script_running(eu) if fa then
del(er,fa) del(ex,fa) end end function break_time(fb) fb=fb or 1 for x=1,fb do yield() end end function wait_for_message() while fc!=nil do yield() end end function say_line(cx,msg,fd,fe) if type(cx)=="string"then
msg=cx cx=selected_actor end ff=cx.y-(cx.h)*8+4 fg=cx print_line(msg,cx.x,ff,cx.col,1,fd,fe) end function stop_talking() fc,fg=nil,nil end function print_line(msg,x,y,col,fh,fd,fe) local col=col or 7 local fh=fh or 0 if fh==1 then
fi=min(x-ct,127-(x-ct)) else fi=127-(x-ct) end local fj=max(flr(fi/2),16) local fk=""for fl=1,#msg do local fm=sub(msg,fl,fl) if fm==":"then
fk=sub(msg,fl+1) msg=sub(msg,1,fl-1) break end end local dm=dn(msg,fj) local dp=dq(dm) fn=x-ct if fh==1 then
fn-=((dp*4)/2) end fn=max(2,fn) ff=max(18,y) fn=min(fn,127-(dp*4)-1) fc={fo=dm,x=fn,y=ff,col=col,fh=fh,fp=(#msg)*8,ds=dp,fd=fd} if#fk>0 then
fq=fg wait_for_message() fg=fq print_line(fk,x,y,col,fh,fd) end if not fe then
wait_for_message() end end function put_actor_at(cx,x,y,fr) if fr then cx.in_room=fr end
cx.x,cx.y=x,y end function walk_to(cx,x,y) x+=ct local fs=ft(cx) local fu=flr(x/8)+room_curr.map[1] local fv=flr(y/8)+room_curr.map[2] local fw={fu,fv} local fx=fy(fs,fw) local fz=ft({x=x,y=y}) if ga(fz[1],fz[2]) then
add(fx,fz) end for gb in all(fx) do local gc=(gb[1]-room_curr.map[1])*8+4 local gd=(gb[2]-room_curr.map[2])*8+4 local ge=sqrt((gc-cx.x)^2+(gd-cx.y)^2) local gf=cx.walk_speed*(gc-cx.x)/ge local gg=cx.walk_speed*(gd-cx.y)/ge if ge>5 then
cx.gh=1 cx.flip=(gf<0) if abs(gf)<0.4 then
if gg>0 then
cx.gi=cx.walk_anim_front cx.face_dir="face_front"else cx.gi=cx.walk_anim_back cx.face_dir="face_back"end else cx.gi=cx.walk_anim_side cx.face_dir="face_right"if cx.flip then cx.face_dir="face_left"end
end for fl=0,ge/cx.walk_speed do cx.x+=gf cx.y+=gg yield() end end end cx.gh=2 end function wait_for_actor(cx) cx=cx or selected_actor while cx.gh!=2 do yield() end end function proximity(cp,cq) if cp.in_room==cq.in_room then
local ge=sqrt((cp.x-cq.x)^2+(cp.y-cq.y)^2) return ge else return 1000 end end gj=16 ct,cv,cy,cg=0,nil,nil,0 gk,gl,gm,gn=63.5,63.5,0,1 go={7,12,13,13,12,7} gp={{spr=208,x=75,y=gj+60},{spr=240,x=75,y=gj+72}} ec={face_front=1,face_left=2,face_back=3,face_right=4} function gq(cj) local gr={} for ez,cl in pairs(cj) do add(gr,ez) end return gr end function get_verb(cj) local co={} local gr=gq(cj[1]) add(co,gr[1]) add(co,cj[1][gr[1]]) add(co,cj.text) return co end function es() gs=get_verb(verb_default) gt,gu,n,gv,gw=nil,nil,nil,false,""end es() fc=nil dj=nil dh=nil fg=nil ex={} er={} dg={} gx={} ep,ep=0,0 



function _init() 

	--reload(0,0,0x800,"mi_temp.p8") -- gfx pg1
	--cstore(0x3b00,0,0x800) -- sfx (last 1/2)
 	--reload(0,0x3b00,0x800) -- gfx pg1 (from end of sfx)




if enable_mouse then poke(0x5f2d,1) end
gy() start_script(startup_script,true) end function _update60() gz() end function _draw() ha() end function gz() if selected_actor and selected_actor.dd
and not coresume(selected_actor.dd) then selected_actor.dd=nil end hb(ex) if dh then
if dh.dd
and not coresume(dh.dd) then if dh.cz!=3
and dh.df then camera_follow(dh.df) selected_actor=dh.df end del(dg,dh) dh=nil if#dg>0 then
dh=dg[#dg] end end else hb(er) end hc() hd() he,hf=1.5-rnd(3),1.5-rnd(3) he=flr(he*cg) hf=flr(hf*cg) if not ch then
cg*=0.90 if cg<0.05 then cg=0 end
end end function ha() rectfill(0,0,127,127,0) camera(ct+he,0+hf) clip(0+ep-he,gj+ep-hf,128-ep*2-he,64-ep*2) hg() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,gj-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,gj-8,8) end if show_debuginfo then
print("x: "..flr(gk+ct).." y:"..gl-gj,80,gj-8,8) end hh() if dj
and dj.dl then hi() hj() return end if hk==dh then
else hk=dh return end if not dh then
hl() end if(not dh
or dh.cz==2) and(hk==dh) then hm() else end hk=dh if not dh then
hj() end end function hc() if dh then
if btnp(4) and btnp(5) and dh.de then
dh.dd=cocreate(dh.de) dh.de=nil return end return end if btn(0) then gk-=1 end
if btn(1) then gk+=1 end
if btn(2) then gl-=1 end
if btn(3) then gl+=1 end
if btnp(4) then hn(1) end
if btnp(5) then hn(2) end
if enable_mouse then
ho,hp=stat(32)-1,stat(33)-1 if ho!=hq then gk=ho end
if hp!=hr then gl=hp end
if stat(34)>0 then
if not hs then
hn(stat(34)) hs=true end else hs=false end hq=ho hr=hp end gk=mid(0,gk,127) gl=mid(0,gl,127) end function hn(ht) local hu=gs if not selected_actor then
return end if dj and dj.dl then
if hv then
selected_sentence=hv end return end if hw then
gs=get_verb(hw) elseif hx then if ht==1 then
if(gs[2]=="use"or gs[2]=="give")
and gt then gu=hx else gt=hx end elseif hy then gs=get_verb(hy) gt=hx gq(gt) hl() end elseif hz then if hz==gp[1] then
if selected_actor.ia>0 then
selected_actor.ia-=1 end else if selected_actor.ia+2<flr(#selected_actor.cd/4) then
selected_actor.ia+=1 end end return end if gt!=nil
and not gv then if gs[2]=="use"or gs[2]=="give"then
if gu then
elseif gt.use_with and gt.owner==selected_actor then return end end gv=true selected_actor.dd=cocreate(function() if(not gt.owner
and(not has_flag(gt.classes,"class_actor") or gs[2]!="use")) or gu then ib=gu or gt ic=get_use_pos(ib) walk_to(selected_actor,ic.x,ic.y) if selected_actor.gh!=2 then return end
use_dir=ib if ib.use_dir then use_dir=ib.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gs,gt) then
start_script(gt.verbs[gs[1]],false,gt,gu) else cn(gs[2],gt,gu) end es() end) coresume(selected_actor.dd) elseif gl>gj and gl<gj+64 then gv=true selected_actor.dd=cocreate(function() walk_to(selected_actor,gk,gl-gj) es() end) coresume(selected_actor.dd) end end function hd() hw,hy,hx,hv,hz=nil,nil,nil,nil,nil if dj
and dj.dl then for ey in all(dj.dk) do if id(ey) then
hv=ey end end return end ie() for cj in all(room_curr.objects) do if(not cj.classes
or(cj.classes and not has_flag(cj.classes,"class_untouchable"))) and(not cj.dependent_on or cj.dependent_on.state==cj.dependent_on_state) then ig(cj,cj.w*8,cj.h*8,ct,ih) else cj.ii=nil end if id(cj) then
if not hx
or(not cj.z and hx.z<0) or(cj.z and hx.z and cj.z>hx.z) then hx=cj end end ij(cj) end for ez,cx in pairs(actors) do if cx.in_room==room_curr then
ig(cx,cx.w*8,cx.h*8,ct,ih) ij(cx) if id(cx)
and cx!=selected_actor then hx=cx end end end if selected_actor then
for cl in all(verbs) do if id(cl) then
hw=cl end end for ik in all(gp) do if id(ik) then
hz=ik end end for ez,cj in pairs(selected_actor.cd) do if id(cj) then
hx=cj if gs[2]=="pickup"and hx.owner then
gs=nil end end if cj.owner!=selected_actor then
del(selected_actor.cd,cj) end end if gs==nil then
gs=get_verb(verb_default) end if hx then
hy=ci(hx) end end end function ie() gx={} for x=-64,64 do gx[x]={} end end function ij(cj) ff=-1 if cj.il then
ff=cj.y else ff=cj.y+(cj.h*8) end im=flr(ff) if cj.z then
im=cj.z end add(gx[im],cj) end function hg() rectfill(0,gj,127,gj+64,room_curr.io or 0) for z=-64,64 do if z==0 then
ip(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,gj,room_curr.iq,room_curr.ir) pal() else im=gx[z] for cj in all(im) do if not has_flag(cj.classes,"class_actor") then
if cj.states
or(cj.state and cj[cj.state] and cj[cj.state]>0) and(not cj.dependent_on or cj.dependent_on.state==cj.dependent_on_state) and not cj.owner then is(cj) end else if cj.in_room==room_curr then
it(cj) end end iu(cj) end end end end function ip(cj) if cj.col_replace then
iv=cj.col_replace pal(iv[1],iv[2]) end if cj.lighting then
iw(cj.lighting) elseif cj.in_room then iw(cj.in_room.lighting) end end function is(cj) ip(cj) if cj.draw then
cj.draw(cj) return end ix=1 if cj.repeat_x then ix=cj.repeat_x end
for h=0,ix-1 do local iy=0 if cj.states then
iy=cj.states[cj.state] else iy=cj[cj.state] end iz(iy,cj.x+(h*(cj.w*8)),cj.y,cj.w,cj.h,cj.trans_col,cj.flip_x) end pal() end function it(cx) ja=ec[cx.face_dir] if cx.gh==1
and cx.gi then cx.jb+=1 if cx.jb>cx.frame_delay then
cx.jb=1 cx.jc+=1 if cx.jc>#cx.gi then cx.jc=1 end
end jd=cx.gi[cx.jc] else jd=cx.idle[ja] end ip(cx) iz(jd,cx.dv,cx.il,cx.w,cx.h,cx.trans_col,cx.flip,false) if fg
and fg==cx and fg.talk then if cx.je<7 then
jd=cx.talk[ja] iz(jd,cx.dv,cx.il+8,1,1,cx.trans_col,cx.flip,false) end cx.je+=1 if cx.je>14 then cx.je=1 end
end pal() end function hl() jf=""jg=12 jh=gs[2] if not gv then
if gs then
jf=gs[3] end if gt then
jf=jf.." "..gt.name if jh=="use"then
jf=jf.." with"elseif jh=="give"then jf=jf.." to"end end if gu then
jf=jf.." "..gu.name elseif hx and hx.name!=""and(not gt or(gt!=hx)) and(not hx.owner or jh!=get_verb(verb_default)[2]) then jf=jf.." "..hx.name end gw=jf else jf=gw jg=7 end print(ji(jf),jj(jf),gj+66,jg) end function hh() if fc then
jk=0 for jl in all(fc.fo) do jm=0 if fc.fh==1 then
jm=((fc.ds*4)-(#jl*4))/2 end jn(jl,fc.x+jm,fc.y+jk,fc.col,0,fc.fd) jk+=6 end fc.fp-=1 if fc.fp<=0 then
stop_talking() end end end function hm() fn,ff,jo=0,75,0 for cl in all(verbs) do jp=verb_maincol if hy
and cl==hy then jp=verb_defcol end if cl==hw then jp=verb_hovcol end
cm=get_verb(cl) print(cm[3],fn,ff+gj+1,verb_shadcol) print(cm[3],fn,ff+gj,jp) cl.x=fn cl.y=ff ig(cl,#cm[3]*4,5,0,0) iu(cl) if#cm[3]>jo then jo=#cm[3] end
ff+=8 if ff>=95 then
ff=75 fn+=(jo+1.0)*4 jo=0 end end if selected_actor then
fn,ff=86,76 jq=selected_actor.ia*4 jr=min(jq+8,#selected_actor.cd) for js=1,8 do rectfill(fn-1,gj+ff-1,fn+8,gj+ff+8,1) cj=selected_actor.cd[jq+js] if cj then
cj.x,cj.y=fn,ff is(cj) ig(cj,cj.w*8,cj.h*8,0,0) iu(cj) end fn+=11 if fn>=125 then
ff+=12 fn=86 end js+=1 end for fl=1,2 do jt=gp[fl] if hz==jt then pal(verb_maincol,7) end
iz(jt.spr,jt.x,jt.y,1,1,0) ig(jt,8,7,0,0) iu(jt) pal() end end end function hi() fn,ff=0,70 for ey in all(dj.dk) do if ey.ds>0 then
ey.x,ey.y=fn,ff ig(ey,ey.ds*4,#ey.dm*5,0,0) jp=dj.col if ey==hv then jp=dj.dt end
for jl in all(ey.dm) do print(ji(jl),fn,ff+gj,jp) ff+=5 end iu(ey) ff+=2 end end end function hj() col=go[gn] pal(7,col) spr(224,gk-4,gl-3,1,1,0) pal() gm+=1 if gm>7 then
gm=1 gn+=1 if gn>#go then gn=1 end
end end function iz(ju,x,y,w,h,jv,flip_x,jw) palt(0,false) palt(jv,true) spr(ju,x,gj+y,w,h,flip_x,jw) palt(jv,false) palt(0,true) end function gy() for fr in all(rooms) do jx(fr) if(#fr.map>2) then
fr.iq=fr.map[3]-fr.map[1]+1 fr.ir=fr.map[4]-fr.map[2]+1 else fr.iq=16 fr.ir=8 end for cj in all(fr.objects) do jx(cj) cj.in_room=fr end end for jy,cx in pairs(actors) do jx(cx) cx.gh=2 cx.jb=1 cx.je=1 cx.jc=1 cx.cd={} cx.ia=0 end end function iu(cj) local jz=cj.ii if show_collision
and jz then rect(jz.x,jz.y,jz.ka,jz.kb,8) end end function hb(scripts) for fa in all(scripts) do if fa[2] and not coresume(fa[2],fa[3],fa[4]) then
del(scripts,fa) fa=nil end end end function iw(kc) if kc then kc=1-kc end
local gb=flr(mid(0,kc,1)*100) local kd={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for ke=1,15 do col=ke kf=(gb+(ke*1.46))/22 for ez=1,kf do col=kd[col] end pal(ke,col) end end function cu(cs) if type(cs)=="table"then
cs=cs.x end return mid(0,cs-64,(room_curr.iq*8)-128) end function ft(cj) local fu=flr(cj.x/8)+room_curr.map[1] local fv=flr(cj.y/8)+room_curr.map[2] return{fu,fv} end function ga(fu,fv) local kg=mget(fu,fv) local kh=fget(kg,0) return kh end function dn(msg,fj) local dm={} local ki=""local kj=""local fm=""local kk=function(kl) if#kj+#ki>kl then
add(dm,ki) ki=""end ki=ki..kj kj=""end for fl=1,#msg do fm=sub(msg,fl,fl) kj=kj..fm if fm==" "
or#kj>fj-1 then kk(fj) elseif#kj>fj-1 then kj=kj.."-"kk(fj) elseif fm==";"then ki=ki..sub(kj,1,#kj-1) kj=""kk(0) end end kk(fj) if ki!=""then
add(dm,ki) end return dm end function dq(dm) dp=0 for jl in all(dm) do if#jl>dp then dp=#jl end
end return dp end function has_flag(cj,km) for bq in all(cj) do if bq==km then
return true end end return false end function ig(cj,w,h,kn,ko) x=cj.x y=cj.y if has_flag(cj.classes,"class_actor") then
cj.dv=x-(cj.w*8)/2 cj.il=y-(cj.h*8)+1 x=cj.dv y=cj.il end cj.ii={x=x,y=y+gj,ka=x+w-1,kb=y+h+gj-1,kn=kn,ko=ko} end function fy(kp,kq) local kr,ks,kt={},{},{} ku(kr,kp,0) ks[kv(kp)]=nil kt[kv(kp)]=0 while#kr>0 and#kr<1000 do local kw=kr[#kr] del(kr,kr[#kr]) kx=kw[1] if kv(kx)==kv(kq) then
break end local ky={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kz=kx[1]+x local la=kx[2]+y if abs(x)!=abs(y) then lb=1 else lb=1.4 end
if kz>=room_curr.map[1] and kz<=room_curr.map[1]+room_curr.iq
and la>=room_curr.map[2] and la<=room_curr.map[2]+room_curr.ir and ga(kz,la) and((abs(x)!=abs(y)) or ga(kz,kx[2]) or ga(kz-x,la)) then add(ky,{kz,la,lb}) end end end end for lc in all(ky) do local ld=kv(lc) local le=kt[kv(kx)]+lc[3] if kt[ld]==nil
or le<kt[ld] then kt[ld]=le local lf=le+max(abs(kq[1]-lc[1]),abs(kq[2]-lc[2])) ku(kr,lc,lf) ks[ld]=kx end end end local fx={} kx=ks[kv(kq)] if kx then
local lg=kv(kx) local lh=kv(kp) while lg!=lh do add(fx,kx) kx=ks[lg] lg=kv(kx) end for fl=1,#fx/2 do local li=fx[fl] local lj=#fx-(fl-1) fx[fl]=fx[lj] fx[lj]=li end end return fx end function ku(lk,cs,gb) if#lk>=1 then
add(lk,{}) for fl=(#lk),2,-1 do local lc=lk[fl-1] if gb<lc[2] then
lk[fl]={cs,gb} return else lk[fl]=lc end end lk[1]={cs,gb} else add(lk,{cs,gb}) end end function kv(ll) return((ll[1]+1)*16)+ll[2] end function ei(msg) print_line("-error-;"..msg,5+ct,5,8,0) end function jx(cj) local dm=lm(cj.data,"\n") for jl in all(dm) do local pairs=lm(jl,"=") if#pairs==2 then
cj[pairs[1]]=ln(pairs[2]) else printh("invalid data line") end end end function lm(ey,lo) local lp={} local jq=0 local lq=0 for fl=1,#ey do local lr=sub(ey,fl,fl) if lr==lo then
add(lp,sub(ey,jq,lq)) jq=0 lq=0 elseif lr!=" "and lr!="\t"then lq=fl if jq==0 then jq=fl end
end end if jq+lq>0 then
add(lp,sub(ey,jq,lq)) end return lp end function ln(lt) local lu=sub(lt,1,1) local lp=nil if lt=="true"then
lp=true elseif lt=="false"then lp=false elseif lv(lu) then if lu=="-"then
lp=sub(lt,2,#lt)*-1 else lp=lt+0 end elseif lu=="{"then local li=sub(lt,2,#lt-1) lp=lm(li,",") lw={} for cs in all(lp) do cs=ln(cs) add(lw,cs) end lp=lw else lp=lt end return lp end function lv(iv) for a=1,13 do if iv==sub("0123456789.-+",a,a) then
return true end end end function jn(lx,x,y,ly,lz,fd) if not fd then lx=ji(lx) end
for ma=-1,1 do for mb=-1,1 do print(lx,x+ma,y+mb,lz) end end print(lx,x,y,ly) end function jj(ey) return 63.5-flr((#ey*4)/2) end function mc(ey) return 61 end function id(cj) if not cj.ii then return false end
ii=cj.ii if(gk+ii.kn>ii.ka or gk+ii.kn<ii.x)
or(gl>ii.kb or gl<ii.y) then return false else return true end end function ji(ey) local a=""local jl,iv,lk=false,false for fl=1,#ey do local ik=sub(ey,fl,fl) if ik=="^"then
if iv then a=a..ik end
iv=not iv elseif ik=="~"then if lk then a=a..ik end
lk,jl=not lk,not jl else if iv==jl and ik>="a"and ik<="z"then
for ke=1,26 do if ik==sub("abcdefghijklmnopqrstuvwxyz",ke,ke) then
ik=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",ke,ke) break end end end a=a..ik iv,lk=false,false end end return a end











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
00000020000000000000000000000000070007171717171717171717170700070700071a1a1a4e1a1a1a405040501a1a1a4e1a1a1a070007000000000000000007000709545509090909545509070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000000000070007171717171717171717170700070700076262625e626262666766676262625e626262070007000000000000000007000709090909090909090909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000000000000000000000000070007171717171717171717170700070700077474746e747474767776777474746e7474740700070000000000000000070007090966676c6c66670909070707070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
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

