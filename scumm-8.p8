pico-8 cartridge // http://www.pico-8.com
version 9
__lua__
-- scumm-8
-- paul nicholas

-- ### luamin fixes ###
--	"\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92"

-- token counts:
--   > 6790 (after more token hunting) 
--   > 6832 (after adding "use" object/actor & fix shake crop)
--   > 6904 (before door "targets")

-- debugging
show_debuginfo = true
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


-- [ ground floor ]

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
					classes = {class_openable, class_door}
					use_pos = pos_right
					use_dir = face_left
				]],
				get_target_door = function()  
					return obj_front_door
				end
			}

			obj_hall_exit_landing = {		
				data = [[
					name=upstairs
					state=state_open
					x=88
					y=0
					w=1
					h=2
					use_dir = face_back
					use_pos = pos_center
					classes = {class_door}
				]],
				get_target_door = function()  
					return obj_landing_exit_hall
				end
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
					classes = {class_door}
				]],
				get_target_door = function()  
					return obj_library_door_hall
				end
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
					classes = {class_door}
				]],
				get_target_door = function()  
					return obj_kitchen_door_hall
				end
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
					classes = {class_door}
				]],
				get_target_door = function()  
					return obj_hall_door_library
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
				--dependent_on = obj_front_door_inside,
				--dependent_on_state = "state_open",
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
				--[[verbs = {
				}]]
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
					classes = {class_door}
				]],
				get_target_door = function()  
					return obj_hall_exit_landing
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
				classes = {class_door}
			]],
			get_target_door = function()  
				return obj_computer_door_landing
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
	rm_library,
	rm_landing
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
-- script overloads
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set ui colors
	reset_ui()

	-- set initial inventory (if applicable)
	pickup_obj(obj_switch_tent, main_actor)
	pickup_obj(obj_switch_player, purp_tentacle)

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	--change_room(rm_library, 1) -- iris fade

	selected_actor = main_actor
	put_actor_at(selected_actor,60,60,rm_hall)
	camera_follow(selected_actor)

	change_room(rm_hall, 1) -- iris fade
end


-- (end of customisable game content)































-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)




function shake(enabled)
	if enabled then
		-- enable the camera shake
		cam_shake_amount = 1
	end
	-- enable/disable shake, which will fade out
	cam_shake = enabled
end


-- logic used to determine a "default" verb to use
-- (e.g. when you right-click an object)
function find_default_verb(obj)
  local default_verb = nil

	if has_flag(obj.classes, "class_talkable") then
		default_verb = "talkto"
	elseif has_flag(obj.classes, "class_openable") then
		if obj.state == "state_closed" then
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

	local is_actor = has_flag(obj1.classes, "class_actor") 

	if verb == "walkto" then
		return

	elseif verb == "pickup" then
		if is_actor then
			say_line"i don't need them"
		else
			say_line"i don't need that"
		end

	elseif verb == "use" then
		if is_actor then
			say_line"i can't just *use* someone"
		end
		if obj2 then
			if has_flag(obj2.classes, class_actor) then
				say_line"i can't use that on someone!"
			else
				say_line"that doesn't work"
			end
		end

	elseif verb == "give" then
		if is_actor then
			say_line"i don't think i should be giving this away"
		else
			say_line"i can't do that"
		end

	elseif verb == "lookat" then
		if is_actor then
			say_line"i think it's alive"
		else
			say_line"looks pretty ordinary"
		end

	elseif verb == "open" then
		if is_actor then
			say_line"they don't seem to open"
		else
			say_line"it doesn't seem to open"
		end

	elseif verb == "close" then
		if is_actor then
			say_line"they don't seem to close"
		else
			say_line"it doesn't seem to close"
		end

	elseif verb == "push" or verb == "pull" then
		if is_actor then
			say_line"moving them would accomplish nothing"
		else
			say_line"it won't budge!"
		end

	elseif verb == "talkto" then
		if is_actor then
			say_line"erm... i don't think they want to talk"
		else
			say_line"i am not talking to that!"
		end

	else
		say_line"hmm. no."
	end
end 



function camera_at(val)
	-- point center of camera at...
	cam_x = _center_camera(val)
	-- clear other cam values
	cam_pan_to_x = nil
	cam_following_actor = nil
end

function camera_follow(actor)
	stop_script(cam_script) -- bg script

	-- set target
	cam_following_actor = actor
	-- clear other cam values
	cam_pan_to_x = nil

	cam_script = function()
		-- keep the camera following actor
		-- (until further notice)
		while cam_following_actor do
			-- keep camera within "room" bounds
			if cam_following_actor.in_room == room_curr then
				cam_x = _center_camera(cam_following_actor)
			end
			yield()
		end
	end
	start_script(cam_script, true) -- bg script

	-- auto-switch to room actor resides in
	if cam_following_actor.in_room != room_curr then
		change_room(cam_following_actor.in_room, 1)
	end
end


function camera_pan_to(val)
	-- set target, but keep camera within "room" bounds
	cam_pan_to_x = _center_camera(val)

	-- clear other cam values
	cam_following_actor = nil

	cam_script = function()
		-- update the camera pan until reaches dest
		while (true) do
			if cam_x == cam_pan_to_x then
				-- pan complete
				cam_pan_to_x = nil
				return
			elseif cam_pan_to_x > cam_x then
		  	cam_x += 0.5
			else
				cam_x -= 0.5
			end
			-- don't hog cpu
			yield()
		end
	end
	start_script(cam_script, true) -- bg script
end


function wait_for_camera()
	while script_running(cam_script) do
		yield()
	end
end


function cutscene(flags, func_cutscene, func_override)
	cut = {
		flags = flags,
		thread = cocreate(func_cutscene),
		override = func_override,
		paused_cam_following = cam_following_actor
	}
	add(cutscenes, cut)
	-- set as active cutscene
	cutscene_curr = cut

	-- yield for system catch-up
	-- todo: see if this is still needed!
	break_time()
end

function dialog_set(msg_table)
	for msg in all(msg_table) do
		dialog_add(msg)
	end
end

function dialog_add(msg)
	-- check params
	if not dialog_curr then dialog_curr={ sentences={}, visible=false} end
	-- break msg into lines (if necc.)
	lines = create_text_lines(msg, 32)
	-- find longest line
	longest_line = longest_line_size(lines)
	sentence={
		num = #dialog_curr.sentences+1,
		msg = msg,
		lines = lines,
		char_width = longest_line
	}
	add(dialog_curr.sentences, sentence)
end

function dialog_start(col, hlcol)
	dialog_curr.col = col
	dialog_curr.hlcol = hlcol
	dialog_curr.visible = true
	selected_sentence = nil
end

function dialog_hide()
	dialog_curr.visible = false
end

function dialog_clear()
	dialog_curr.sentences = {}
	selected_sentence = nil
end

function dialog_end()
	dialog_curr=nil
end


function get_use_pos(obj)
	local obj_use_pos = obj.use_pos
	local x = obj.x -- -cam_x
	local y = obj.y

	-- first check for specific pos
	if type(obj_use_pos) == "table" then
		x = obj_use_pos[1] -- -cam_x
		y = obj_use_pos[2] -- -stage_top

	-- determine use pos
	elseif obj_use_pos == "pos_left" then
		-- diff calc for actors
		if obj.offset_x then
			x -= (obj.w*8 +4)
			y += 1
		else
			-- object pos
			x -= 2
			y += ((obj.h*8) -2)
		end

	elseif obj_use_pos == "pos_right" then
		x += (obj.w*8)
		y += ((obj.h*8) -2)
	
	elseif obj_use_pos == "pos_above" then
		x += ((obj.w*8) /2) -4
		y -= 2
	
	elseif obj_use_pos == "pos_center" then
		x += ((obj.w*8) /2)
		y += ((obj.h*8) /2) -4

	elseif obj_use_pos == "pos_infront"
	 or obj_use_pos == nil then
		x += ((obj.w*8) /2) -4
		y += (obj.h*8) +2
	end
	
	return {x=x,y=y}
end


function do_anim(actor, cmd_type, cmd_value)

	dir_nums = {
		"face_front",
		"face_left",
		"face_back",
		"face_right" 
	}

	-- animate turn to face (object/actor or explicit direction)
	if cmd_type == "anim_face" then
		
		-- check if cmd_value is an actor/object, rather than explicit face_dir
		if type(cmd_value) == "table" then
			-- need to calculate face_dir from positions
			angle_rad = atan2(actor.x  - cmd_value.x , cmd_value.y - actor.y)
			-- calc player's angle offset in this
			plr_angle = 93 * (3.1415/180)
			-- adjust for player's angle
			angle_rad = plr_angle - angle_rad

			-- convert radians to degrees
			-- (note: everyone says should be: rad * (180/pi), but
			--        that only seems to give me degrees 0..57? so...)
			degrees = angle_rad * 360 --(1130.938/3.1415)

			-- angle wrap for circle
			degrees = degrees % 360
			if degrees < 0 then degrees += 360 end

			-- set final target face direction to obj/actor
			cmd_value = 4 - flr(degrees/90)

			-- convert final value
			cmd_value = dir_nums[cmd_value]
		end

		face_dir = face_dir_vals[actor.face_dir]
		cmd_value = face_dir_vals[cmd_value]
		
		while face_dir != cmd_value do
			-- turn to target face_dir
			if face_dir < cmd_value then
				face_dir += 1
			else 
				face_dir -= 1
			end
			-- set face dir
			actor.face_dir = dir_nums[face_dir]
			-- is target dir left? flip?
			actor.flip = (actor.face_dir == "face_left")
			break_time(10)
		end


	end
end

-- open one (or more) doors
function open_door(door_obj1, door_obj2)
	if door_obj1.state == "state_open" then
		say_line"it's already open"
	else
		door_obj1.state = "state_open"
		if door_obj2 then door_obj2.state = "state_open" end
	end
end

-- close one (or more) doors
function close_door(door_obj1, door_obj2)
	if door_obj1.state == "state_closed" then
		say_line"it's already closed"
	else
		door_obj1.state = "state_closed"
		if door_obj2 then door_obj2.state = "state_closed" end
	end
end

function come_out_door(from_door, to_door, fade_effect)
	-- check param
	if to_door == nil then
		show_error("target door does not exist")
		return
	end

	if from_door.state == "state_open" then
		-- go to new room!
		new_room = to_door.in_room

		if new_room != room_curr then
			-- switch to new room and...
			change_room(new_room, fade_effect)
		end
	
		-- ...auto-position actor at to_door in new room...
		local pos = get_use_pos(to_door)
		put_actor_at(selected_actor, pos.x, pos.y, new_room)
	
		-- ...in opposite use direction!
		dir_opp = { 
			face_front="face_back", 
			face_left="face_right", 
			face_back="face_front",
			face_right="face_left" 
		}

		if to_door.use_dir then
			opp_dir = dir_opp[to_door.use_dir]
			-- opp_dir = to_door.use_dir + 2
			-- if opp_dir > 4 then
			-- 	opp_dir -= 4
			-- end
		else
			opp_dir = 1 -- front
		end
		selected_actor.face_dir = opp_dir
		-- is target dir left? flip?
		selected_actor.flip = (selected_actor.face_dir == "face_left")

	else
		say_line("the door is closed")
	end
end

function fades(fade, dir) -- 1=down, -1=up
	if dir == 1 then
		fade_amount = 0
	else
		fade_amount = 50
	end

	while true do
		fade_amount += dir*2

		if fade_amount > 50
		 or fade_amount < 0 then
			return
		end

		-- iris down/up
		if fade == 1 then
			fade_iris = min(fade_amount, 32)
		end

		yield()
	end
end

function change_room(new_room, fade)
	-- check param
	if new_room == nil then
		show_error("room does not exist")
		return
	end

	-- stop any existing fade (shouldn't be any, but just in case!)
	stop_script(fade_script)

	-- fade down existing room (or skip if first room)
	if fade and room_curr then
		fades(fade, 1)
	end
	-- switch to new room
	-- execute the exit() script of old room
	if room_curr and room_curr.exit then
		-- run script directly, so wait to finish
		room_curr.exit(room_curr)
	end

	-- stop all active (local) scripts
	local_scripts = {}

	-- clear current command
	clear_curr_cmd()

	-- actually change rooms now
	room_curr = new_room

	-- reset camera pos in new room (unless camera following)
	if not cam_following_actor 
	 or cam_following_actor.in_room != room_curr then
		cam_x = 0
	end

	-- stop everyone talking & remove displayed text
	stop_talking()

	-- fade up again?
	-- (use "thread" so that room.enter code is able to 
	--  reposition camera before fade-up, if needed)
	if fade then
		-- setup new fade up
		fade_script =  function() 
				fades(fade, -1) 
		end
		start_script(fade_script, true)
	else
		-- no fade - reset any existing fade
		fade_iris = 0
	end

	-- execute the enter() script of new room
	if room_curr.enter then
		-- run script directly
		room_curr.enter(room_curr)
	end
end

function valid_verb(verb, object)
	-- check params
	if not object 
	 or not object.verbs then return false end
	-- look for verb
	if type(verb) == "table" then
		if object.verbs[verb[1]] then return true end
	else
		if object.verbs[verb] then return true end
	end
	-- must not be valid if reached here
	return false
end

function pickup_obj(obj, actor)
		-- use actor spectified, or default to selected
    actor = actor or selected_actor

		add(actor.inventory, obj)
		obj.owner = actor
		-- remove it from room
		del(obj.in_room.objects, obj)
--	end
end


function start_script(func, bg, noun1, noun2)
	-- create new thread for script and add to list of local_scripts (or background scripts)
	local thread = cocreate(func)
	-- background or local?
	local scripts = local_scripts
	if bg then
		scripts = global_scripts
	end
	add(scripts, {func, thread, noun1, noun2} )
end


function script_running(func)
	-- loop through both sets of scripts...
	for s in all( { local_scripts, global_scripts } ) do
		for k,scr_obj in pairs(s) do
			if scr_obj[1] == func then
				return scr_obj
			end
		end
	end
	-- must not be running
	return false
end

function stop_script(func)
	-- find script and stop it running
	scr_obj = script_running(func)
	if scr_obj then
		-- just delete from all scripts (don't bother checking!)
		del(local_scripts, scr_obj)
		del(global_scripts, scr_obj)
	end
end

function break_time(jiffies)
	jiffies = jiffies or 1
	-- wait for cycles specified (min 1 cycle)
	for x = 1, jiffies do
		yield()
	end
end

function wait_for_message()
	while talking_curr != nil do
		yield()
	end
end

-- uses actor's position and color
function say_line(actor, msg, use_caps, dont_wait_msg)
	-- check for missing actor
	if type(actor) == "string" then
		-- assume actor ommitted and default to current
		msg = actor
		actor = selected_actor
	end

	-- offset to display speech above actors (dist in px from their feet)
	ypos = actor.y - (actor.h)*8 +4  --text_offset
	-- trigger actor's talk anim
	talking_actor = actor
	-- call the base print_line to show actor line
	print_line(msg, actor.x, ypos, actor.col, 1, use_caps, dont_wait_msg)
end

-- stop everyone talking & remove displayed text
function stop_talking()
	talking_curr, talking_actor = nil, nil
end


function print_line(msg, x, y, col, align, use_caps, dont_wait_msg)
  -- punctuation...
	--  > ":" new line, shown after text prior expires
	--  > ";" new line, shown immediately
	-- note: an actor's talk animation is not activated as it is with say-line.

	local col=col or 7 		-- default to white
	local align=align or 0	-- default to no align

	-- calc max line width based on x-pos/available space
	if align == 1 then
		screen_space = min(x -cam_x, 127 - (x -cam_x))
	else
		screen_space = 127 - (x -cam_x)
	end
	local max_line_length = max(flr(screen_space/2), 16)

	-- search for ";"'s
	local msg_left = ""
	for i = 1, #msg do
		local curchar=sub(msg,i,i)
		if curchar == ":" then
			-- show msg up to this point
			-- and process the rest as new message
			
			-- next message?
			msg_left = sub(msg, i+1)
			-- redefine curr msg
			msg = sub(msg, 1, i-1)
			break
		end
	end

	local lines = create_text_lines(msg, max_line_length)

	-- find longest line
	local longest_line = longest_line_size(lines)

	-- center-align text block
	xpos = x -cam_x 
	if align == 1 then
		xpos -= ((longest_line*4)/2)
	end

	-- screen bound check
	xpos = max(2, xpos)	 -- left
	ypos = max(18, y)    -- top
	xpos = min(xpos, 127 - (longest_line*4)-1) -- right

	talking_curr = {
		msg_lines = lines,
		x = xpos,
		y = ypos,
		col = col,
		align = align,
		time_left = (#msg)*8,
		char_width = longest_line,
		use_caps = use_caps
	}
	-- if message was split...
	if #msg_left > 0 then
	  talking = talking_actor
		wait_for_message()
		talking_actor = talking
		print_line(msg_left, x, y, col, align, use_caps)
	end

	-- and wait for message?
	if not dont_wait_msg then
		wait_for_message()
	end
end

function put_actor_at(actor, x, y, room)
	if room then actor.in_room = room end
	actor.x, actor.y = x, y
end

-- walk actor to position
function walk_to(actor, x, y)
		--offset for camera
	--	x += cam_x

		local actor_cell_pos = getcellpos(actor)
		local celx = flr(x /8) + room_curr.map[1]
		local cely = flr(y /8) + room_curr.map[2]
		local target_cell_pos = { celx, cely }

		-- use pathfinding!
	  local path = find_path(actor_cell_pos, target_cell_pos)

		-- finally, add our destination to list
		local final_cell = getcellpos({x=x, y=y})
		if is_cell_walkable(final_cell[1], final_cell[2]) then
			add(path, final_cell)
		end

		for p in all(path) do
			local px = (p[1]-room_curr.map[1])*8 + 4
			local py = (p[2]-room_curr.map[2])*8 + 4

			local distance = sqrt((px - actor.x) ^ 2 + (py - actor.y) ^ 2)
			local step_x = actor.walk_speed * (px - actor.x) / distance
			local step_y = actor.walk_speed * (py - actor.y) / distance

			-- only walk if we're not already there!
			if distance > 5 then 
				--walking
				actor.moving = 1 
				actor.flip = (step_x<0)

				-- choose walk anim based on dir
				if abs(step_x) < 0.4 then
					-- vertical walk, which way?
					if step_y > 0 then
						-- towards us
						actor.walk_anim = actor.walk_anim_front
						actor.face_dir = "face_front"
					else
						-- away
						actor.walk_anim = actor.walk_anim_back
						actor.face_dir = "face_back"
					end
				else
					-- horizontal walk
					actor.walk_anim = actor.walk_anim_side
					-- face dir (at end of walk)
					actor.face_dir = "face_right"
					if actor.flip then actor.face_dir = "face_left" end
				end

				for i = 0, distance/actor.walk_speed do
					actor.x += step_x
					actor.y += step_y
					yield()
				end
			end
		end
		actor.moving = 2 --arrived
end

function wait_for_actor(actor)
	actor = actor or selected_actor
	-- wait for actor to stop moving/turning
	while actor.moving != 2 do
		yield()
	end
end

function proximity(obj1, obj2)
	-- calc dist between objects
	if obj1.in_room == obj2.in_room then
		local distance = sqrt((obj1.x - obj2.x) ^ 2 + (obj1.y - obj2.y) ^ 2)
		return distance
	else
		-- not even in same room, so...
		return 1000
	end
end


-- 
-- internal functions
-- 

-- global vars
stage_top = 16
cam_x, cam_pan_to_x, cam_script, cam_shake_amount = 0, nil, nil, 0

cursor_x, cursor_y, cursor_tmr, cursor_colpos = 63.5, 63.5, 0, 1
cursor_cols = {7,12,13,13,12,7}

ui_arrows = {
	{ spr = 208, x = 75, y = stage_top + 60 },
	{ spr = 240, x = 75, y = stage_top + 72 }
}

face_dir_vals = { 
	face_front=1, 
	face_left=2, 
	face_back=3,
	face_right=4 
}


function get_keys(obj)
	local keys = {}
	for k,v in pairs(obj) do
		add(keys,k)
	end
	return keys
end

function get_verb(obj)
	local verb = {}
	local keys = get_keys(obj[1])
--[[	d("1:"..keys[1])
			d("2:"..obj[1][ keys[1] ])
			d("3:"..obj.text ) ]]
	add(verb, keys[1])						-- verb func
	add(verb, obj[1][ keys[1] ])  -- verb ref name
	add(verb, obj.text)						-- verb disp name
	return verb
end

function clear_curr_cmd()
	-- reset all command values
	verb_curr = get_verb(verb_default)
	noun1_curr, noun2_curr, me, executing_cmd, cmd_curr = nil, nil, nil, false, ""
end

clear_curr_cmd()
talking_curr = nil 	-- currently displayed speech {x,y,col,lines...}
dialog_curr = nil   -- currently displayed dialog options to pick
cutscene_curr = nil -- currently active cutscene
talking_actor = nil -- currently talking actor

global_scripts = {}	-- table of scripts that are at game-level (background)
local_scripts = {}	-- table of scripts that are actively running
cutscenes = {} 			-- table of scripts for the active cutscene(s)
draw_zplanes = {}		-- table of tables for each of the (8) zplanes for drawing depth

fade_iris, fade_iris = 0, 0


-- game loop

function _init()

	--reload(0,0,0x800,"mario014.p8") -- gfx pg1
	--cstore(0x3b00,0,0x800) -- sfx (last 1/2)
 	--reload(0,0x3b00,0x800) -- gfx pg1 (from end of sfx)

	
	--reload(0,0x3200,0x1000) -- gfx pg1&2 (from sfx)
	--reload(0,0,0x1000,"mario014.p8") -- gfx pg1&2
	--reload(0,0,0x800,"mario014.p8") -- gfx pg1
	--cstore(0x3200,0,0x1000) -- sfx (start)
	--cstore(0,0,0x800,"out.p8")


	-- use mouse input?
	if enable_mouse then poke(0x5f2d, 1) end

	-- init all the rooms/objects/actors
	game_init()

	-- run any startup script(s)
  start_script(startup_script, true)
end

function _update60()  -- _update()
	game_update()
end

function _draw()
	game_draw()
end


-- update functions

function game_update()
	-- process selected_actor threads/actions
	if selected_actor and selected_actor.thread 
	 and not coresume(selected_actor.thread) then
		selected_actor.thread = nil
	end

	-- global scripts (always updated - regardless of cutscene)
	update_scripts(global_scripts)

	-- update active cutscene (if any)
	if cutscene_curr then
		if cutscene_curr.thread 
		 and not coresume(cutscene_curr.thread) then
			-- cutscene ended, restore prev state	
						
			-- restore follow-cam if flag allows (and had a value!)
			if cutscene_curr.flags != 3 
			--if not has_flag(cutscene_curr.flags, "cut_no_follow") 
			 and cutscene_curr.paused_cam_following 
			then
				camera_follow(cutscene_curr.paused_cam_following)
					-- assume to re-select prev actor
				selected_actor = cutscene_curr.paused_cam_following
			end
			-- now delete cutscene
			del(cutscenes, cutscene_curr)
			cutscene_curr = nil
			-- any more cutscenes?
			if #cutscenes > 0 then
				cutscene_curr = cutscenes[#cutscenes]
			end
		end
	else
		-- no cutscene...
		-- update all the active scripts
		-- (will auto-remove those that have ended)
	
		-- local/room-level scripts
		update_scripts(local_scripts)		
	end

	-- player/ui control
	playercontrol()

	-- check for collisions
	check_collisions()

	-- update camera shake (if active)
	cam_shake_x, cam_shake_y = 1.5-rnd(3), 1.5-rnd(3)
	cam_shake_x = flr(cam_shake_x * cam_shake_amount)
  cam_shake_y = flr(cam_shake_y * cam_shake_amount)
	if not cam_shake then
		cam_shake_amount *= 0.90
 		if cam_shake_amount < 0.05 then cam_shake_amount = 0 end
	end
end


function game_draw()
	-- clear screen every frame
	rectfill(0, 0, 127, 127, 0)

	-- reposition camera (account for shake, if active)
	camera(cam_x+cam_shake_x, 0+cam_shake_y)

	-- clip room bounds (also used for "iris" transition)
	clip(
		0 +fade_iris -cam_shake_x, 
		stage_top +fade_iris -cam_shake_y, 
		128 -fade_iris*2 -cam_shake_x, 
		64 -fade_iris*2)

	-- draw room (bg + objects + actors)
	room_draw()

	-- reset camera and clip bounds for "static" content (ui, etc.)
	camera(0,0)
	clip()

	if show_perfinfo then 
		print("cpu: "..flr(100*stat(1)).."%", 0, stage_top - 16, 8) 
		print("mem: "..flr(stat(0)/1024*100).."%", 0, stage_top - 8, 8)
	end
	if show_debuginfo then 
		print("x: "..flr(cursor_x+cam_x).." y:"..cursor_y-stage_top, 80, stage_top - 8, 8) 
	end

	-- draw active/speech text
	talking_draw()

	-- in dialog mode?
	if dialog_curr 
	 and dialog_curr.visible then
		-- draw dialog sentences?
		dialog_draw()
		cursor_draw()
		-- skip rest
		return
	end

 -- hack:
 -- skip draw if just exited a cutscene
 -- as could be going straight into a dialog
 -- (would prefer a better way than this, but couldn't find one!)
 --
	if cutscene_curr_lastval == cutscene_curr then
		--d("cut_same")
	else
		--d("cut_diff")
		cutscene_curr_lastval = cutscene_curr
		return
	end
	

	-- draw current command (verb/object)
	if not cutscene_curr then
		command_draw()
	end

	-- draw ui and inventory (only if actor selected to use it!)
	if (not cutscene_curr
		or cutscene_curr.flags == 2) -- quick-cut
		--or not has_flag(cutscene_curr.flags, "cut_noverbs"))
		-- and not just left a cutscene
		and (cutscene_curr_lastval == cutscene_curr) then
		ui_draw()
	else
		--d("ui skipped")
	end

	-- hack: fix for display issue (see above hack info)
	cutscene_curr_lastval = cutscene_curr

	if not cutscene_curr then
		cursor_draw()
	end
end


-- handle button inputs
function playercontrol()	

	-- check for cutscene "skip/override"
	-- (or that we have an actor to control!)
	if cutscene_curr then
		if btnp(4) and btnp(5) and cutscene_curr.override then 
			-- skip cutscene!
			cutscene_curr.thread = cocreate(cutscene_curr.override)
			cutscene_curr.override = nil
			--if (enable_mouse) then ismouseclicked = true end
			return
		end
		-- either way - don't allow other user actions!
		return
	end

	-- 
	if btn(0) then cursor_x -= 1 end
	if btn(1) then cursor_x += 1 end
	if btn(2) then cursor_y -= 1 end
	if btn(3) then cursor_y += 1 end

	if btnp(4) then input_button_pressed(1) end
	if btnp(5) then input_button_pressed(2) end

	-- only update position if mouse moved
	if enable_mouse then	
		mouse_x,mouse_y = stat(32)-1, stat(33)-1
		if mouse_x != last_mouse_x then cursor_x = mouse_x end	-- mouse xpos
		if mouse_y!= last_mouse_y then cursor_y = mouse_y end  -- mouse ypos
		-- don't repeat action if same press/click
		if stat(34) > 0 then
			if not ismouseclicked then
				input_button_pressed(stat(34))
				ismouseclicked = true
			end
		else
			ismouseclicked = false
		end
		-- store for comparison next cycle
		last_mouse_x = mouse_x
		last_mouse_y = mouse_y
	end

	-- keep cursor within screen
	cursor_x = mid(0, cursor_x, 127)
	cursor_y = mid(0, cursor_y, 127)
end

-- 1 = z/lmb, 2 = x/rmb, (4=middle)
function input_button_pressed(button_index)	

	local verb_in = verb_curr

	-- abort if no actor selected at this point
	if not selected_actor then 
		return
	end

	-- check for sentence selection
	if dialog_curr and dialog_curr.visible then
		if hover_curr_sentence then
			selected_sentence = hover_curr_sentence
		end
		-- skip remaining
		return
	end


	if hover_curr_verb then
		verb_curr = get_verb(hover_curr_verb)
		--d("verb = "..verb_curr[2])

	elseif hover_curr_object then
		-- if valid obj, complete command
		-- else, abort command (clear verb, etc.)
		if button_index == 1 then
			if (verb_curr[2] == "use" or verb_curr[2] == "give") 
			 and noun1_curr then
				noun2_curr = hover_curr_object
				--d("noun2_curr = "..noun2_curr.name)					
			else
				noun1_curr = hover_curr_object						
				--d("noun1_curr = "..noun1_curr.name)
			end

		elseif hover_curr_default_verb then
			-- perform default verb action (if present)
			verb_curr = get_verb(hover_curr_default_verb)
			noun1_curr = hover_curr_object
			get_keys(noun1_curr)
			-- force repaint of command (to reflect default verb)
			command_draw()
		end

	-- ui arrow clicked
	elseif hover_curr_arrow then
		-- up arrow
		if hover_curr_arrow == ui_arrows[1] then 
			if selected_actor.inv_pos > 0 then
				selected_actor.inv_pos -= 1
			end
		else  -- down arrow
			if selected_actor.inv_pos + 2 < flr(#selected_actor.inventory/4) then
				selected_actor.inv_pos += 1
			end
		end
		return
	--else
		-- what else could there be? actors!?
	end

	-- attempt to use verb on object (if not already executing verb)
	if noun1_curr != nil 
	 and not executing_cmd then
		-- are we starting a 'use' command?
		if verb_curr[2] == "use" or verb_curr[2] == "give" then
			if noun2_curr then
				-- 'use' part 2
			elseif noun1_curr.use_with 
			 and noun1_curr.owner == selected_actor 
			then
				-- 'use' part 1 (e.g. "use hammer")
				-- wait for noun2 to be set
				return
			end
		end

		-- execute verb script
		executing_cmd = true
		selected_actor.thread = cocreate(function() --actor, obj, verb, noun2)
			-- if obj not in inventory (or about to give/use it)...
			if (not noun1_curr.owner 
				   and (not has_flag(noun1_curr.classes, "class_actor")
							or verb_curr[2] != "use"))
			 or noun2_curr 
			then
				-- walk to use pos and face dir
				-- determine which item we're walking to
				walk_obj = noun2_curr or noun1_curr
				--todo: find nearest usepos if none set?
				dest_pos = get_use_pos(walk_obj)
				walk_to(selected_actor, dest_pos.x, dest_pos.y)
				-- abort if walk was interrupted
				if selected_actor.moving != 2 then return end
				-- face object/actor by default
				use_dir = walk_obj
				-- unless a diff dir specified
				if walk_obj.use_dir then use_dir = walk_obj.use_dir end
				-- turn to use dir				
				do_anim(selected_actor, "anim_face", use_dir)
			end
			-- does current object support active verb?
			if valid_verb(verb_curr,noun1_curr) then
				-- finally, execute verb script
				start_script(noun1_curr.verbs[verb_curr[1]], false, noun1_curr, noun2_curr)
			else
				-- check for door
				if has_flag(noun1_curr.classes, "class_door") then
					-- perform default door action
					--start_script(function()
						if verb_curr[1] == "walkto" then
							come_out_door(noun1_curr, noun1_curr.get_target_door())
						elseif verb_curr[1] == "open" then
							open_door(noun1_curr, noun1_curr.target_door)
						elseif verb_curr[1] == "close" then
							close_door(noun1_curr, noun1_curr.target_door)
						end
					--end, false)
				else
					d("7")
					-- e.g. "i don't think that will work"
					unsupported_action(verb_curr[2], noun1_curr, noun2_curr)
				end
				d("8")
			end
			-- clear current command
			clear_curr_cmd()
		end)
		coresume(selected_actor.thread)--, selected_actor, noun1_curr, verb_curr, noun2_curr)
	elseif cursor_y > stage_top and cursor_y < stage_top+64 then
		-- in map area
		executing_cmd = true
		-- attempt to walk to target
		selected_actor.thread = cocreate(function() --(x,y)
			walk_to(selected_actor, cursor_x+cam_x, cursor_y - stage_top)
			--walk_to(selected_actor, x, y)
			-- clear current command
			clear_curr_cmd()
		end)
		coresume(selected_actor.thread) --, cursor_x, cursor_y - stage_top)
	end
end

-- collision detection
function check_collisions()
	-- reset hover collisions
	hover_curr_verb, hover_curr_default_verb, hover_curr_object, hover_curr_sentence, hover_curr_arrow = nil, nil, nil, nil, nil
	-- are we in dialog mode?
	if dialog_curr 
	 and dialog_curr.visible 
	then
		for s in all(dialog_curr.sentences) do
			if iscursorcolliding(s) then
				hover_curr_sentence = s
			end
		end
		-- skip remaining collisions
		return
	end

	-- reset zplane info
	reset_zplanes()

	-- check room/object collisions
	for obj in all(room_curr.objects) do
		-- capture bounds (even for "invisible", but not untouchable/dependent, objects)
		if (not obj.classes
			 or (obj.classes and not has_flag(obj.classes, "class_untouchable")))
			and (not obj.dependent_on 			-- object has a valid dependent state?
			 or obj.dependent_on.state == obj.dependent_on_state) 
		then
			recalc_bounds(obj, obj.w*8, obj.h*8, cam_x, cam_y)
		else
			-- reset bounds
			obj.bounds = nil
		end

		if iscursorcolliding(obj) then
			-- if highest (or first) object in hover "stack"
			if not hover_curr_object
			 or	(not obj.z and hover_curr_object.z < 0) 
			 or	(obj.z and hover_curr_object.z and obj.z > hover_curr_object.z) 
			then
				hover_curr_object = obj
			end
		end
		-- recalc z-plane
		recalc_zplane(obj)
	end

	-- check actor collisions
	for k,actor in pairs(actors) do
		if actor.in_room == room_curr then
			recalc_bounds(actor, actor.w*8, actor.h*8, cam_x, cam_y)
			-- recalc z-plane
			recalc_zplane(actor)
			-- are we colliding (ignore self!)
			if iscursorcolliding(actor)
		 	 and actor != selected_actor then
				hover_curr_object = actor
			end
		end
	end

	if selected_actor then
		-- check ui/inventory collisions
		for v in all(verbs) do
			if iscursorcolliding(v) then
				hover_curr_verb = v
			end
		end
		for a in all(ui_arrows) do
			if iscursorcolliding(a) then
				hover_curr_arrow = a
			end
		end

		-- check room/object collisions
		for k,obj in pairs(selected_actor.inventory) do
			if iscursorcolliding(obj) then
				hover_curr_object = obj
				-- pickup override for inventory objects
				if verb_curr[2] == "pickup" and hover_curr_object.owner then
					verb_curr = nil
				end
			end
			-- check for disowned objects!
			if obj.owner != selected_actor then 
				del(selected_actor.inventory, obj)
			end
		end

		-- default to walkto (if nothing set)
		if verb_curr == nil then
			verb_curr = get_verb(verb_default)
		end

		-- update "default" verb for hovered object (if any)
		if hover_curr_object then
			hover_curr_default_verb = find_default_verb(hover_curr_object)
		end
	end
end


function reset_zplanes()
	draw_zplanes = {}
	for x = -64, 64 do
		draw_zplanes[x] = {}
	end
end

function recalc_zplane(obj)
	-- calculate the correct z-plane
	-- based on x,y pos + elevation
	ypos = -1
	if obj.offset_y then
		ypos = obj.y
	else
		ypos = obj.y + (obj.h*8)
	end
	zplane = flr(ypos) --  - stage_top)

	if obj.z then
		zplane = obj.z
	end

	add(draw_zplanes[zplane],obj)
end

function room_draw()

	-- set room background col (or black by default)
	rectfill(0, stage_top, 127, stage_top+64, room_curr.bg_col or 0)



	-- draw each zplane, from back to front
	for z = -64,64 do

		-- draw bg layer?
		if z == 0 then			
			-- replace colors?
			replace_colors(room_curr)

			if room_curr.trans_col then
				palt(0, false)
				palt(room_curr.trans_col, true)
			end
			map(room_curr.map[1], room_curr.map[2], 0, stage_top, room_curr.map_w, room_curr.map_h)
			--reset palette
			pal()		
		else
			-- draw other layers
			zplane = draw_zplanes[z]
		
			-- draw all objs/actors in current zplane
			for obj in all(zplane) do
				-- object or actor?
				if not has_flag(obj.classes, "class_actor") then
					-- object
					if obj.states	  -- object has a state?
				    or (obj.state
					   and obj[obj.state]
					   and obj[obj.state] > 0)
					 and (not obj.dependent_on 			-- object has a valid dependent state?
						or obj.dependent_on.state == obj.dependent_on_state)
					 and not obj.owner   						-- object is not "owned"
					then
						-- something to draw
						object_draw(obj)
					end
				else
					-- actor
					if obj.in_room == room_curr then
						actor_draw(obj)
					end
				end
				show_collision_box(obj)
			end
		end		
	end

end

function replace_colors(obj)
	-- replace colors (where defined)
	if obj.col_replace then
		c = obj.col_replace
		--for c in all(obj.col_replace) do
			pal(c[1], c[2])
		--end
	end
	-- also apply brightness (default to room-level, if not set)
	if obj.lighting then
		_fadepal(obj.lighting)
	elseif obj.in_room then
		_fadepal(obj.in_room.lighting)
	end
end


function object_draw(obj)
	-- replace colors?
	replace_colors(obj)
	
	-- check for custom draw
	if obj.draw then
		obj.draw(obj)
		return
	end
	
	-- allow for repeating
	rx=1
	if obj.repeat_x then rx = obj.repeat_x end
	for h = 0, rx-1 do
		-- draw object (in its state!)
		local obj_spr = 0
		if obj.states then
			obj_spr = obj.states[obj.state]
		else
			obj_spr = obj[obj.state]
		end
		sprdraw(obj_spr, obj.x+(h*(obj.w*8)), obj.y, obj.w, obj.h, obj.trans_col, obj.flip_x)
	end
	--reset palette
	pal() 
end

-- draw actor(s)
function actor_draw(actor)

	dirnum = face_dir_vals[actor.face_dir]

	if actor.moving == 1
	 and actor.walk_anim 
	then
		actor.tmr += 1
		if actor.tmr > actor.frame_delay then
			actor.tmr = 1
			actor.anim_pos += 1
			if actor.anim_pos > #actor.walk_anim then actor.anim_pos=1 end
		end
		-- choose walk anim frame
		sprnum = actor.walk_anim[actor.anim_pos]	
	else

		-- idle
		sprnum = actor.idle[dirnum]
	end

	-- replace colors?
	replace_colors(actor)

	sprdraw(sprnum, actor.offset_x, actor.offset_y, 
		actor.w , actor.h, actor.trans_col, 
		actor.flip, false)
	
	-- talking overlay
	if talking_actor 
	 and talking_actor == actor 
	 and talking_actor.talk
	then
			if actor.talk_tmr < 7 then
				sprnum = actor.talk[dirnum]
				sprdraw(sprnum, actor.offset_x, actor.offset_y +8, 1, 1, 
					actor.trans_col, actor.flip, false)
			end
			actor.talk_tmr += 1	
			if actor.talk_tmr > 14 then actor.talk_tmr = 1 end
	end

	--reset palette
	pal()
end

function command_draw()
	-- draw current command
	command = ""
	cmd_col = 12
	verb_curr_ref = verb_curr[2] 

	if not executing_cmd then
		if verb_curr then
			command = verb_curr[3]
		end
		if noun1_curr then
			command = command.." "..noun1_curr.name
			if verb_curr_ref == "use" then
				command = command.." with"
			elseif verb_curr_ref == "give" then
				command = command.." to"
			end
		end
		if noun2_curr then
			command = command.." "..noun2_curr.name
		elseif hover_curr_object 
		  and hover_curr_object.name != ""
			-- don't show use object with itself!
			and ( not noun1_curr or (noun1_curr != hover_curr_object) )
			-- or walk-to objs in inventory!
			and ( not hover_curr_object.owner 
							or verb_curr_ref != get_verb(verb_default)[2] )
		then
			command = command.." "..hover_curr_object.name
		end
		cmd_curr = command
	else
		-- highlight active command
		command = cmd_curr
		cmd_col = 7
	end

	print( smallcaps(command), hcenter(command), stage_top + 66, cmd_col )
end

function talking_draw()
	-- alignment 
	--   0 = no align
	--   1 = center 
	if talking_curr then
		line_offset_y = 0
		for l in all(talking_curr.msg_lines) do
			line_offset_x = 0
			-- center-align line
			if talking_curr.align == 1 then
				line_offset_x = ((talking_curr.char_width*4)-(#l*4))/2
			end
			outline_text(
				l, 
				talking_curr.x + line_offset_x, 
				talking_curr.y + line_offset_y, 
				talking_curr.col,
				0,
				talking_curr.use_caps)
			line_offset_y += 6
		end
		-- update message lifespan
		talking_curr.time_left -= 1
		-- remove text & reset actor's talk anim
		if talking_curr.time_left <= 0 then 
			stop_talking()
		end
	end
end

-- draw ui and inventory
function ui_draw()
	-- draw verbs
	xpos, ypos, col_len = 0, 75, 0

	for v in all(verbs) do
		txtcol=verb_maincol

		-- highlight default verb
		if hover_curr_default_verb
		  and v == hover_curr_default_verb then
			txtcol = verb_defcol
		end		
		if v == hover_curr_verb then txtcol=verb_hovcol end

		-- get verb info
		vi = get_verb(v)
		print(vi[3], xpos, ypos+stage_top+1, verb_shadcol)  -- shadow
		print(vi[3], xpos, ypos+stage_top, txtcol)  -- main
		
		-- capture bounds
		v.x = xpos
		v.y = ypos
		recalc_bounds(v, #vi[3]*4, 5, 0, 0)
		show_collision_box(v)

		-- auto-size column
		if #vi[3] > col_len then col_len = #vi[3] end
		ypos += 8

		-- move to next column
		if ypos >= 95 then
			ypos = 75
			xpos += (col_len + 1.0) * 4
			col_len = 0
		end
	end

	if selected_actor then
		-- draw inventory
		xpos, ypos = 86, 76
		-- determine the inventory "window"
		start_pos = selected_actor.inv_pos*4
		end_pos = min(start_pos+8, #selected_actor.inventory)

		for ipos = 1,8 do
			-- draw inventory bg
			rectfill(xpos-1, stage_top+ypos-1, xpos+8, stage_top+ypos+8, 1)

			obj = selected_actor.inventory[start_pos+ipos]
			if obj then
				-- something to draw
				obj.x, obj.y = xpos, ypos
				-- draw object/sprite
				object_draw(obj)
				-- re-calculate bounds (as pos may have changed)
				recalc_bounds(obj, obj.w*8, obj.h*8, 0, 0)
				show_collision_box(obj)
			end
			xpos += 11

			if xpos >= 125 then
				ypos += 12
				xpos = 86
			end
			ipos += 1
		end

		-- draw arrows
		for i = 1,2 do
			arrow = ui_arrows[i]
			if hover_curr_arrow == arrow then pal(verb_maincol,7) end
			sprdraw(arrow.spr, arrow.x, arrow.y, 1, 1, 0)
			-- capture bounds
			recalc_bounds(arrow, 8, 7, 0, 0)
			show_collision_box(arrow)
			pal() --reset palette
		end
	end
end

function dialog_draw()
	xpos, ypos = 0, 70
	
	for s in all(dialog_curr.sentences) do
		if s.char_width > 0 then
			-- capture bounds
			s.x, s.y = xpos, ypos
			recalc_bounds(s, s.char_width*4, #s.lines*5, 0, 0)

			txtcol=dialog_curr.col
			if s == hover_curr_sentence then txtcol=dialog_curr.hlcol end
			
			for l in all(s.lines) do
				print(smallcaps(l), xpos, ypos+stage_top, txtcol)
				ypos += 5
			end

			show_collision_box(s)
			ypos += 2
		end
	end
end

-- draw cursor
function cursor_draw()
	col = cursor_cols[cursor_colpos]
	-- switch sprite color accordingly
	pal(7,col)
	spr(224, cursor_x-4, cursor_y-3, 1, 1, 0)
	pal() --reset palette

	cursor_tmr += 1
	if cursor_tmr > 7 then
		--reset timer
		cursor_tmr = 1
		-- move to next color?
		cursor_colpos += 1
		if cursor_colpos > #cursor_cols then cursor_colpos = 1 end
	end
end

function sprdraw(n, x, y, w, h, transcol, flip_x, flip_y)
	-- switch transparency
 	palt(0, false)
 	palt(transcol, true)
	 -- draw sprite
	spr(n, x, stage_top + y, w, h, flip_x, flip_y) --
	-- restore default trans	
 	palt(transcol, false)
	palt(0, true)
	--pal() -- don't do, affects lighting!
end




-- initialise all the rooms (e.g. add in parent links)
function game_init()

	for room in all(rooms) do
		explode_data(room)
		
		if (#room.map > 2) then
			room.map_w = room.map[3] - room.map[1] + 1
			room.map_h = room.map[4] - room.map[2] + 1
		else
			room.map_w = 16
			room.map_h = 8
		end

		-- init objects (in room)
		for obj in all(room.objects) do
			explode_data(obj)
			obj.in_room = room
		end
	end
	-- init actors with defaults
	for ka,actor in pairs(actors) do
		explode_data(actor)
		actor.moving = 2 		-- 0=stopped, 1=walking, 2=arrived
		actor.tmr = 1 		  -- internal timer for managing animation
		actor.talk_tmr = 1
		actor.anim_pos = 1 	-- used to track anim pos
		actor.inventory = {
			-- obj_switch_player,
			-- obj_switch_tent
		}
		actor.inv_pos = 0 	-- pointer to the row to start displaying from
	end
end

function show_collision_box(obj)
	local obj_bounds = obj.bounds
	if show_collision 
	 and obj_bounds 
	then 
		rect(obj_bounds.x, obj_bounds.y, obj_bounds.x1, obj_bounds.y1, 8) 
	end	
end

function update_scripts(scripts)
	for scr_obj in all(scripts) do
		if scr_obj[2] and not coresume(scr_obj[2], scr_obj[3], scr_obj[4]) then
			del(scripts, scr_obj)
			scr_obj = nil
		end
	end
end

function _fadepal(perc)
 if perc then perc = 1-perc end
 local p=flr(mid(0,perc,1)*100)
 local dpal={0,1,1, 2,1,13,6,
          4,4,9,3, 13,1,13,14}
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col)
 end
end


function _center_camera(val)
	-- check params for obj/actor
	if type(val) == "table" then
		val = val.x
	end
	-- keep camera within "room" bounds
	return mid(0, val-64, (room_curr.map_w*8) -128 )
end



function getcellpos(obj)
	local celx = flr(obj.x/8) + room_curr.map[1] --map_x
	local cely = flr(obj.y/8) + room_curr.map[2] --map_y
	return { celx, cely }
end

function is_cell_walkable(celx, cely)
		local spr_num = mget(celx, cely)
		local walkable = fget(spr_num,0)
		return walkable
end


-- auto-break message into lines
function create_text_lines(msg, max_line_length) --, comma_is_newline)
	--  > ";" new line, shown immediately
	local lines={}
	local currline=""
	local curword=""
	local curchar=""
	
	local upt=function(max_length)
		if #curword + #currline > max_length then
			add(lines,currline)
			currline=""
		end
		currline=currline..curword
		curword=""
	end

	for i = 1, #msg do
		curchar=sub(msg,i,i)
		curword=curword..curchar
		
		if curchar == " "
		 or #curword > max_line_length-1 then
			upt(max_line_length)
		
		elseif #curword>max_line_length-1 then
			curword=curword.."-"
			upt(max_line_length)

		elseif curchar == ";" then 
			-- line break
			currline=currline..sub(curword,1,#curword-1)
			curword=""
			upt(0)
		end
	end

	upt(max_line_length)
	if currline!="" then
		add(lines,currline)
	end

	return lines
end

-- find longest line
function longest_line_size(lines)
	longest_line = 0
	for l in all(lines) do
		if #l > longest_line then longest_line = #l end
	end
	return longest_line
end

function has_flag(obj, value)
	for f in all(obj) do
	 if f == value then 
	 	return true 
	 end
	end
  --if band(obj, value) != 0 then return true end
  return false
end


function recalc_bounds(obj, w, h, cam_off_x, cam_off_y)
  x = obj.x
	y = obj.y
	-- offset for actors?
	if has_flag(obj.classes, "class_actor") then
		obj.offset_x = x - (obj.w *8) /2
		obj.offset_y = y - (obj.h *8) +1		
		x = obj.offset_x
		y = obj.offset_y
	end
	obj.bounds = {
		x = x,
		y = y + stage_top,
		x1 = x + w -1,
		y1 = y + h + stage_top -1,
		cam_off_x = cam_off_x,
		cam_off_y = cam_off_y
	}
end


-- 
-- a* pathfinding functions 
--

function find_path(start, goal)
 local frontier, came_from, cost_so_far = {}, {}, {}
 insert(frontier, start, 0)
 came_from[vectoindex(start)] = nil
 cost_so_far[vectoindex(start)] = 0

 while #frontier > 0 and #frontier < 1000 do
 	-- pop the last element off a table
	local top = frontier[#frontier]
	del(frontier,frontier[#frontier])
	current = top[1]

  if vectoindex(current) == vectoindex(goal) then
   break
  end

  --local neighbours = getneighbours(current)
	local neighbours = {}
	for x = -1, 1 do
		for y = -1, 1 do
			if x == 0 and y == 0 then 
				--continue 
			else
				local chk_x = current[1] + x
				local chk_y = current[2] + y

				-- diagonals cost more
				if abs(x) != abs(y) then cost=1 else cost=1.4 end
				
				if chk_x >= room_curr.map[1] and chk_x <= room_curr.map[1] + room_curr.map_w
				 and chk_y >= room_curr.map[2] and chk_y <= room_curr.map[2] + room_curr.map_h
				 and is_cell_walkable(chk_x, chk_y)
				-- squeeze check for corners
				 and ((abs(x) != abs(y)) 
						or is_cell_walkable(chk_x, current[2]) 
						or is_cell_walkable(chk_x - x, chk_y)) 
				then
					-- add as valid neighbour
					add( neighbours, {chk_x, chk_y, cost} )
				end
			end
		end
	end
	-- --------------

  for next in all(neighbours) do
   local nextindex = vectoindex(next)
   local new_cost = cost_so_far[vectoindex(current)] + next[3] -- add extra costs here

   if cost_so_far[nextindex] == nil
	  or new_cost < cost_so_far[nextindex]
	 then
	 	cost_so_far[nextindex] = new_cost
		-- diagonal movement - assumes diag dist is 1, same as cardinals
		local priority = new_cost +  max(abs(goal[1] - next[1]), abs(goal[2] - next[2]))
    insert(frontier, next, priority)
    came_from[nextindex] = current
   end 
  end
 end

 -- now find goal..
 local path = {}
 current = came_from[vectoindex(goal)]
 if current then
	local cindex = vectoindex(current)
	local sindex = vectoindex(start)

	while cindex != sindex do
		add(path, current)
		current = came_from[cindex]
		cindex = vectoindex(current)
	end

	--reverse(path)
	for i=1,#path/2 do
		local temp = path[i]
		local oppindex = #path-(i-1)
		path[i] = path[oppindex]
		path[oppindex] = temp
	end
 end

 return path
end


-- insert into table and sort by priority
function insert(t, val, p)
 if #t >= 1 then
  add(t, {})
  for i=(#t),2,-1 do
   local next = t[i-1]
   if p < next[2] then
    t[i] = {val, p}
    return
   else
    t[i] = next
   end
  end
  t[1] = {val, p}
 else
  add(t, {val, p}) 
 end
end

-- translate a 2d x,y coordinate to a 1d index and back again
function vectoindex(vec)
	return ((vec[1]+1) * 16) + vec[2]
end




--
-- helper functions 
-- 

function show_error(msg)
	print_line("-error-;"..msg,5+cam_x,5,8,0)
end

function explode_data(obj)
	local lines=split(obj.data, "\n")
	for l in all(lines) do
		--d("curr line = ["..l.."]")
		local pairs=split(l, "=")
		-- todo: check to see if value is an array?
		-- now set actual values
		--d(" > curr pair = ["..pairs[1].."]")
		if #pairs==2 then
			--d("pair1=["..pairs[1].."]  pair2=["..pairs[2].."]")
			obj[pairs[1]] = autotype(pairs[2])
		else
			printh("invalid data line")
		end
	end
end

function split(s, delimiter)
	local retval = {}
	local start_pos = 0
	local last_char_pos = 0

	for i=1,#s do
		local curr_letter = sub(s,i,i)
		if curr_letter == delimiter then
			add(retval, sub(s,start_pos,last_char_pos))
			start_pos = 0
			last_char_pos = 0

		elseif curr_letter != " "
		 and curr_letter != "\t" then
			-- curr letter is useful
			last_char_pos = i
			if start_pos == 0 then start_pos = i end
		end
	end
	-- add remaining content?
	if start_pos + last_char_pos > 0 then 	
		add(retval, sub(s,start_pos,last_char_pos))
	end
	return retval
end

function autotype(str_value)
	local first_letter = sub(str_value,1,1)
	local retval = nil

	if str_value == "true" then
		retval = true
	elseif str_value == "false" then
		retval = false
	elseif is_num_char(first_letter) then
		-- must be number
		if first_letter == "-" then
			retval = sub(str_value,2,#str_value) * -1
		else
			retval = str_value + 0
		end
	elseif first_letter == "{" then
		-- array - so split it
		local temp = sub(str_value,2,#str_value-1)
		retval = split(temp, ",")
		retarray = {}
		for val in all(retval) do
			val = autotype(val)
			add(retarray, val)
		end
		retval = retarray
	else --if first_letter == "\"" then
		-- string - so do nothing
		retval = str_value
	end
	return retval
end

function is_num_char(c)
	for d=1,13 do
		if c==sub("0123456789.-+",d,d) then
			return true
		end
	end
end

function outline_text(str,x,y,c0,c1,use_caps)
 if not use_caps then str = smallcaps(str) end
 for xx = -1, 1 do
		for yy = -1, 1 do
			print(str, x+xx, y+yy, c1)
		end
 end
 print(str,x,y,c0)
end

function hcenter(s)
	return 63.5-flr((#s*4)/2)
end

function vcenter(s)
	return 61 -- (screenheight /2)-flr(5/2)
end


--- collision check
function iscursorcolliding(obj)
	-- check params
	if not obj.bounds then return false end
	bounds = obj.bounds
	if (cursor_x + bounds.cam_off_x > bounds.x1 or cursor_x + bounds.cam_off_x < bounds.x) 
	 or (cursor_y > bounds.y1 or cursor_y < bounds.y) then
		return false
	else
		return true
	end
end

function smallcaps(s)
	local d=""
	local l,c,t=false,false
	for i=1,#s do
		local a=sub(s,i,i)
		if a=="^" then
			if c then d=d..a end
				c=not c
			elseif a=="~" then
				if t then d=d..a end
				t,l=not t,not l
			else 
				if c==l and a>="a" and a<="z" then
				for j=1,26 do
					if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
						a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
					break
					end
				end
			end
			d=d..a
			c,t=false,false
		end
	end
	return d
end


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
0707070808080808080808080807070707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0707070800000808080808080807070707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0707070800000808080808080807000707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0707076060606061626360606007000707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0707077070707071727370707007000707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0727113131313131313131313121010707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
1131313125151515151515353131312111313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
3131313131313131313131313131313131313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
1131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
3131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
0000000000000000002000000000002007070717171717171717171717070707070707080808080808614050405063080808080808070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0020000000000000000000000010000007070717171717171717171717070707070707080808080808715040504073080808080808070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0000002000000000000000000000000007000717171717171717171717070007070007080808000808714050405073080800080808070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007070007626262006262716667666773626200626262070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007070007747474007474717677767773747400747474070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000200007011131313131313131313131210107070111313131313131313131313131313131313131210107000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
0000000000100000002000000000000011313131313131313131313131313121113131313131312515151515151515353131313131313121000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
2000000000000000000020000000000031313131313131313131313131313131312f2f2f2f2f2f2f2f2f3131312f2f2f2f2f2f2f2f2f2f2f000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
000000100000200000001f0061626262626262626262626262626263001f0010070707080808080807000006050007080808080808070707070707504050405040504040405040504050405040070707171717090909090909090909090909090909090909171717000000100000616262626262626262626262626200000010
002000000000001000001f2071447144714473004e71447344734473001f200007070708080808080700000006050708080808080807070707070740504050405040504050405040504050405007070717171709090909090909444444450909090909090917171700200000002071447474744473b271447474447400002000
200000000020000000201f0071647164716473005e71647364736473201f0000070007080808080807000016263607084e00080808070007070707504050005050504050405040004050405040070707170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f
000020000000000020001f0062626262626273006e71626262626263001f0020070007606060606007001626360007605e00606060070007070707606060006060606162636060006060606060070707170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f
303030303030303030301b3131313131313131253531313131313131310b3030070007707070707027162636000028706e00707070070007070707707070007070707172737070007070707070070707170017767776777677767776777677767776777677170017151515151515151515151515151515151515151515151515
151515151515151515151818181818181818343434341818181818181818151507011131313131313131313131313131313131313121010707271131313131313131313131313131313131313121280717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d15151515
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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

