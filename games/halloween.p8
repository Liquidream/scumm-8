pico-8 cartridge // http://www.pico-8.com
version 11
__lua__
-- hallowe3n - a point+click game
-- paul nicholas

-- [music]
--  00 = main theme
--  30 = laurie's theme
--  35 = jump scare
--  36 = suspense alert
--  40 = the shape stalks (start)
--  44 = the shape stalks (peak)

-- [sfx]

--  63 = police siren


-- debugging
--show_debuginfo = true
-- show_collision = false
-- show_perfinfo = false
enable_mouse = true
--d = printh



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
	verb_maincol = 13  -- main color (violet)
	verb_hovcol = 8    -- hover color (red)
	verb_shadcol = 0   -- shadow (black)
	verb_defcol = 8   -- default action (red)
end



-- 
-- room & object definitions
-- 
flicker_val = false

-- title "room"
	-- objects
	obj_pumpkin = {		
			data = [[
				name=p
				x=0
				y=0
				w=0
				h=0
			]],
			draw = function(me)
				-- flicker
				pal(9,flr(rnd(2))==0 and 9 or 0)
				-- pumpkin
				set_trans_col(13, true)
				map(100,2,2,14,2,2)
				map(100,4,3,27,2,1)
			end,
		}

	--t=0

	obj_title = {		
			data = [[
				name=t
				x=0
				y=0
				w=0
				h=0
			]],
			draw = function(me)
				if (not rm_title.gameover) print("hallow  n",26,22,9) print("e3",50,22,7)
			end,
		}

	rm_title = {
		data = [[
			map = {0,0}
		]],
		objects = {
			-- obj_pumpkin,
			-- obj_title,
		},
		enter = function(me)
			-- low resolution
			cls()
			poke(0x5f2c,3)
			music(0)
			cutscene(
				3, -- no verbs & no follow, 
				function()
					if not me.gameover then
						print_line("liquidream;presents",32,24,9,1,false,200)
						--print_line("coming to pico8;on oct 31st",20,24,9,1,false,200)
						break_time(60)
						put_at(obj_pumpkin, 5, 5, rm_title)
						break_time(130)
						put_at(obj_title, 5, 5, rm_title)
						break_time(125)
						while true do
							print_line("press start",34,45,7,1,false,50)
							break_time(50)
						end
					else
						-- win game
						put_at(obj_pumpkin, 5, 5, rm_title)
						print_line("the end?",30,24,8,0,true,250)
						change_room(rm_void)
						while true do
							break_time(10) 
						end
					end
				end,
				-- override for cutscene
				function()
					if not me.gameover then
						-- start game
						camera_follow(selected_actor)
					end
				end) -- end cutscene
			end,
	}


-- [ hospital - ground floor ]
	-- cell
		-- objects
			obj_cell_door_ward = {		
				data = [[
					name = ward
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
					me.target_door = obj_ward_door_cell
				end
			}

		rm_cell = {
				data = [[
					map = {112,0,127,7}
					col_replace = {11,0}
				]],
				objects = {
					obj_cell_door_ward,
				},
				enter = function(me)
					if not me.done_intro then
						me.done_intro = true
						-- restore resolution
						poke(0x5f2c,0)
						-- laurie's theme
						safe_music(30)
						cutscene(
							3, -- no verbs & no follow, 
							function()
								say_line"ouch! my head hurts...:where am i?:i don't remember how i got here!"
							end
						) -- end cutscene
					end
				end,
			}


	-- ward
		-- objects
			obj_ward_door_reception = {		
				data = [[
					name = reception
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
					me.target_door = obj_reception_door_ward
				end
			}

			obj_ward_door_cell= {		
				data = [[
					name=correction cell
					state=state_open
					x=272
					y=16
					w=1
					h=3
					use_dir = face_back
					classes = { class_door }
				]],
				init = function(me)
					me.target_door = obj_cell_door_ward
				end
			}

		rm_ward = {
				data = [[
					map = {88,8,127,15}
					col_replace = {11,0}
				]],
				objects = {
					obj_ward_door_reception,
					obj_ward_door_cell,
				},
				enter = function(me)
					-- move ghost?
					start_script(function()
						if ghost_actor.in_room == me then
							-- play suspense sfx
							safe_music(36)
							-- move ghost
							ghost_actor.walk_speed = 1
							walk_to(ghost_actor, 30, 52)
							put_at(ghost_actor, 0, 0, rm_void)
						end
					end)
					-- update lights, etc.?
					start_script(function()
						if ghost_actor.in_room == me then
							-- play suspense sfx
							safe_music(36)
						end
						-- flicker lights
						while true do
							me.col_replace = flicker_val and {13,0} or nil
							break_time()
						end
					end)
				end,
			}


	-- reception
		-- objects
			obj_radio = {		
				data = [[
					name=radio
					x=64
					y=24
					w=1
					h=1
					state = state_here
					state_here = 174
					use_pos = {72,48}
					use_dir = face_back
					col = 8
					col_replace = {8,0}
				]],
				verbs = {
					lookat = function(me)
						say_line"it's a radio"
						--say_line("it's a written note from the nurse...:\"just gone to investigate strange noise...\":\"i'll be right back\"")
					end,
					use = function(me)
						if not me.broken then
							-- play radio
							me.col_replace = nil
							say_line(obj_radio, "\"...serial killer is on the loose:if you see anything suspicious:contact fbi agents;ray and reyes on 555...\":*pop*:*silence*")
							me.broken = true
							me.col_replace = {8,0}
							do_anim(selected_actor, "anim_face", "face_front")
							say_line"the radio just when dead:i wonder if that person i saw was the killer?"
						else
							say_line"it's completely broken:i'll have to find the phone number to call another way..."
						end
					end
				}
			}


			obj_reception_door_outside = {		
				data = [[
					name = outside
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
					me.target_door = obj_outside_door_reception
				end
			}

			obj_reception_door_ward = {		
				data = [[
					name = ward
					state=state_open
					x=112
					y=16
					w=1
					h=4
					use_pos = pos_left
					use_dir = face_right
					classes = { class_door }
				]],
				init = function(me)  
					me.target_door = obj_ward_door_reception
				end
			}

		rm_reception = {
				data = [[
					map = {112,16,127,23}
					col_replace = {11,0}
				]],
				objects = {
					obj_reception_door_outside,
					obj_reception_door_ward,
					obj_radio,
				},
			}


-- [ outside ]
		-- objects
		obj_front_door = {		
				data = [[
					name = front door
					state=state_closed
					x=88
					y=8
					w=1
					h=3
					state_closed=78
					flip_x = true 
					classes = {class_openable,class_door}
					use_dir = face_back
				]],
				init = function(me)
					me.target_door = obj_front_door_inside
				end
			}

		obj_outside_door_reception = {		
				data = [[
					name = reception
					state=state_open
					x=944
					y=8
					w=1
					h=3 
					classes = {class_door}
					use_dir = face_back
				]],
				init = function(me)
					me.target_door = obj_reception_door_outside
				end
			}

		obj_body_floor = {		
			data = [[
				name=dead body
				state=state_here
				x=0
				y=0
				w=4
				h=1
				state_here=202
				trans_col = 11
				use_pos = pos_left
				use_dir = face_front
			]],
			verbs = {
				lookat = function(me)
					if (me.in_room == rm_outside) say_line"his name tag says \"vitaliy\":looks like he was going to a party...:sadly, he didn't make it"
					if (me.in_room == rm_basement) say_line"she's...:...dead!"
				end
			}
		}
		
		obj_sign_hospital = {		
				data = [[
					name = sign
					state=state_here
					x=832
					y=24
					w=5
					h=1
					use_pos = {857,42}
				]],
				draw = function(me)
					outline_text("hospital",me.x+5,me.y+17,8,0,true)
					--print("hospital",me.x+5,me.y+17,8)
				end,
				verbs = {
					lookat = function(me)
						say_line"\"smith's grove mental hospital\":doesn't sound like a friendly place to me!"
					end
				}
			}
		
		obj_sign_town = {		
				data = [[
					name = sign
					state=state_here
					x=209
					y=24
					w=5
					h=1
					use_pos = {230,42}
				]],
				draw = function(me)
					print("welcome",me.x+5,me.y+17,0)
				end,
				verbs = {
					lookat = function(me)
						say_line"\"welcome to haddonfield\""
					end
				}
			}

		obj_trees = {		
				data = [[
					name = sign
					state=state_here
					x=270
					y=16
					w=1
					h=3
					classes = {class_untouchable}
				]],
				draw = function(me)
					srand(0)
					palt(0,false)
					palt(11,true)
					for xx=1,100 do
						spr(12, me.x+rnd(500), me.y+rnd(10), 1,4, flr(rnd(2))==0)
					end
				end,
			}

		rm_outside = {
				data = [[
					map = {0,24,127,31}
					col_replace = {11,0}
				]],
				objects = {
					obj_front_door,
					obj_outside_door_reception,
					obj_body_floor,
					obj_sign_hospital,
					obj_sign_town,
					obj_trees,
				},
				enter = function(me)
					-- put body here
					put_at(obj_body_floor, 495, 54, rm_outside)
					obj_body_floor.flip_x = true
				end,
			}


-- [ house - ground floor ]
	-- hall
		-- objects
			obj_front_door_inside = {		
				data = [[
					name = outside
					state = state_closed
					x=8
					y=16
					z=1
					w=1
					h=4
					trans_col = 1
					state_closed=79
					classes = {class_openable,class_door}
					use_pos = pos_right
					use_dir = face_left
				]],
				init = function(me)  
					me.target_door = obj_front_door
				end
			}

			obj_hall_door_livingroom = {		
				data = [[
					name=living room
					state=state_open
					x=40
					y=16
					w=1
					h=3
					use_dir = face_back
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_livingroom_door_hall)
					end
				}
			}

			obj_hall_exit_landing = {		
				data = [[
					name=upstairs
					state=state_open
					x=120
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

			obj_hall_door_basement = {		
				data = [[
					name=basement
					state=state_open
					x=144
					y=16
					w=1
					h=3
					use_dir = face_back
					classes = {class_door}
				]],
				init = function(me)  
					me.target_door = obj_basement_exit_hall
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
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_kitchen_door_hall)
					end
				}
			}

		obj_hall_brokenmirror = {		
				data = [[
					name = broken mirror
					state=state_here
					x=56
					y=16
					w=1
					h=4
				]],
				verbs = {
					lookat = function(me)
						say_line"the mirror has been smashed...:but why?"
					end
				}
			}

		obj_phone= {		
			data = [[
				name = telephone
				state = state_here
				state_here = 115
				x = 120
				y = 24
				w = 1
				h = 1
				col = 8
				use_pos = {122,43}
				use_dir = face_back
			]],
			verbs = {
				pickup = function(me)
					phone_talk(me)
				end,
				use = function(me)
					phone_talk(me)
				end,
				talkto = function(me)
					phone_talk(me)
				end,
			}
		}

		function phone_talk(me)
			cutscene(
				1, -- no verbs
				function()
					say_line"who should i dial?"
				end)

			-- dialog loop start
			while (true) do
				-- build dialog options
				dialog_set({ 
					((obj_tv.fixed and not me.dialed_police) and "dial the police on 555-57458" or ""),
					(me.asked_voicemail and "" or "dial voicemail"),
					(obj_tv.looked_at and "dial hint-line 3000" or ""),
					"hang up"
				})
				dialog_start(verb_maincol, verb_hovcol)

				-- wait for selection
				while not selected_sentence do break_time() end
				-- chosen options
				dialog_hide()

				cutscene(
					1, -- no verbs
					function()
						if (selected_sentence.num != 4) say_line"dialing..."
						
						if selected_sentence.num == 1 then
							say_line"hello, i'm at the doyle's house:the killer has definitely been here...:there are bodies everywhere!"
							say_line(obj_phone, "\"ok, stay where you are, we're on our way\":\"but be careful, the killer could still be in the house!\"")
							camera_follow(obj_landing_door_masterbedroom)
							break_time(100)
							obj_landing_door_masterbedroom.state = "state_open"
							safe_music(36)
							break_time(100)
							camera_follow(selected_actor)
							me.dialed_police = true
							
						elseif selected_sentence.num == 2 then
							say_line(obj_phone, "\"you have 1 saved message\":\"message 1...\":\"laurie? laurie are you there?! get out now! the killer is heading your wa-\":*click*:*dialtone...*")

						elseif selected_sentence.num == 3 then
							say_line(obj_phone, "\"welcome to the hintline 3000\"")
							if not obj_tv.fixed then 
								say_line(obj_phone, "\"having telly trouble?\":\"have you tried looking upstairs for a hanger?\"")
							else
								say_line(obj_phone, "\"our lines are closed now;you're on your own!\"")
							end
							
						elseif selected_sentence.num == 4 then
							dialog_end()
							return
						end
					end)

				dialog_clear()

			end --dialog loop
		end

		rm_hall = {
			data = [[
				map = {0,16,23,23}
				col_replace = {11,0}
			]],
			objects = {
				obj_front_door_inside,
				obj_hall_door_livingroom,
				obj_hall_exit_landing,
				obj_hall_door_basement,
				obj_hall_door_kitchen,
				obj_phone,
				obj_hall_brokenmirror,
			},
			enter = function(me)
				-- allow 1sq diagonal movement
				enable_diag_squeeze = true
				-- auto walk?
				start_script(function()
					if selected_actor.y < 10 then
						walk_to(selected_actor, 80, 42)
					end
				end)
			end,
			exit = function(me)
				-- disable 1sq diagonal movement
				enable_diag_squeeze = false
			end,
		}

	-- basement
		-- objects
			obj_basement_exit_hall = {		
				data = [[
					name=hallway
					state=state_open
					x=56
					y=0
					w=3
					h=2
					use_pos = pos_center
					use_dir = face_back
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_hall_door_basement)
					end
				}
			}


		rm_basement = {
			data = [[
				map = {40,16,55,23}
				col_replace = {11,0}
			]],
			objects = {
				obj_basement_exit_hall
			},
			enter = function(me)
				-- allow 1sq diagonal movement
				enable_diag_squeeze = true
				-- put body here
				put_at(obj_body_floor, 60, 46, me)
				obj_body_floor.flipped = false
				-- auto walk
				start_script(function()
					if not me.seen_body then
						-- play suspense sfx
						safe_music(35)
						me.seen_body = true
					end
					walk_to(selected_actor, 40, 42)
				end)
			end,
			exit = function(me)
				-- disable 1sq diagonal movement
				enable_diag_squeeze = false
			end,
		}


	-- living room
		-- objects		
			 obj_livingroom_door_hall = {
				data = [[
					name=hallway
					state=state_open
					x=8
					y=24
					w=1
					h=3
					use_pos = pos_right
					use_dir = face_left
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_hall_door_livingroom)
					end
				}
			}

			obj_tv = {		
				data = [[
					name=tv
					x=88
					y=30
					w=2
					h=1
					z=-1
					state=1
					use_pos={88,40}
					use_dir = face_back
				]],
				scripts = {
				},
				draw = function(me)
					if obj_tv.fixed then
						rectfill(me.x+2,me.y+16,me.x+12,me.y+24,flicker_val and 0 or verb_hovcol)
					else
						for i=1,100 do
							pset(me.x+rnd(10)+2, me.y+rnd(10)+16, (flr(rnd(2)) == 0) and 0 or verb_maincol)
						end
					end
				end,
				verbs = {
					lookat = function(me)
						me.looked_at = true
						if me.fixed then
							say_line"\"...the killer is still at large:he is wearing a white mask:the number to dial is;555-57458\":\"we now return to our feature film...\":john carpenter's \"the thing\""
						else
							say_line"the aerial is missing:i need to find some wire:...or a hanger"
						end						
					end
				}
			}


		rm_livingroom = {
			data = [[
				map = {24,16,39,23}
				col_replace = {11,0}
			]],
			objects = {
				obj_livingroom_door_hall,
				obj_tv,
				obj_key,
			},
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

			obj_kitchen_door_pantry = {		
				data = [[
					name = pantry
					state = state_closed
					x=112
					y=16
					w=1
					h=4
					trans_col = 1
					state_closed=79
					flip_x=true
					classes = {class_openable,class_door}
					use_pos = pos_left
					use_dir = face_right
				]],
				init = function(me)
					me.target_door = obj_pantry_door_kitchen
				end
			}

		rm_kitchen = {
				data = [[
					map = {56,16,71,22}
					col_replace = {11,0}
				]],
				objects = {
					obj_kitchen_door_hall,
					obj_kitchen_door_pantry,
				},
				enter = function(me)
					if not me.seen_blood then
						-- don't do this again
						me.seen_blood = true
						start_script(function()
							cutscene(
								3, -- no verbs & no follow, 
								function()
									-- play suspense sfx
									safe_music(36)
									-- say something
									break_time(50)
									say_line"oh my..."
									break_time(20)
									say_line"what happened?!"
								end
							) -- cutscene
						end) -- script
					end -- seen blood
				end,
			}

	-- pantry
		-- objects
		obj_pantry_door_kitchen = {		
				data = [[
					name = kitchen
					state=state_open
					x=32
					y=16
					w=1
					h=4
					use_pos = pos_right
					use_dir = face_left
					classes = { class_door }
				]],
				init = function(me)  
					me.target_door = obj_kitchen_door_pantry
				end,
			}



		obj_body_pantry = {		
				data = [[
					name=body
					state=state_here
					x=72
					y=16
					w=2
					h=3
					z=-1
					state_here=206
					trans_col = 11
					use_pos = {64,44}
					use_dir = face_right
				]],
				verbs = {
					lookat = function(me)
						say_line"he's definitely dead!"
					end
				}
			}


		
			blood_y = 42

			obj_blood_pantry = {		
				data = [[
					name=pool of blood
					x=64
					y=48
					w=3
					h=1
					z=-1
					state=1
					use_pos = {64,44}
					use_dir = face_front
				]],
				draw = function(me)
					spr(206)
					if (blood_y < 70) pset(77,blood_y,8)
					blood_y += 1.5
					if (blood_y > 150) blood_y = 42
				end,
				verbs = {
					lookat = function(me)
						say_line"ugh... gross!"
					end
				}
			}
			
		rm_pantry = {
				data = [[
					map = {72,16,87,22}
					col_replace = {11,0}
				]],
				objects = {
					obj_pantry_door_kitchen,
					obj_body_pantry,
					obj_blood_pantry,
				},
				enter = function(me)
					if not me.seen_body_pantry then
						-- don't do this again
						me.seen_body_pantry = true
						start_script(function()
							cutscene(
								3, -- no verbs & no follow, 
								function()
								-- play jump scare sfx
								safe_music(35)
								break_time(50)
								say_line(selected_actor,"*gulp*",false,150)
							end) -- cutscene
						end) -- script
					end
				end,
			}


-- [ house - upper floor ]
	-- landing
		-- objects-- 
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

		obj_landing_door_spareroom = {		
				data = [[
					name=spare room
					state=state_open
					x=48
					y=16
					w=1
					h=3
					use_dir = face_back
					classes = {class_door}
				]],
				init = function(me)  
					me.target_door = obj_spareroom_exit_landing
				end
			}

		obj_landing_door_smallbedroom = {		
				data = [[
					name=small bedroom
					state=state_open
					x=120
					y=16
					w=1
					h=3
					use_dir = face_back
					classes = {class_door}
				]],
				init = function(me)  
					me.target_door = obj_smallbedroom_exit_landing
				end
			}

		obj_landing_door_masterbedroom = {		
				data = [[
					name = master bedroom
					state = state_closed
					x=160
					y=16
					w=1
					h=4
					trans_col = 1
					state_closed=79
					flip_x=true
					use_pos = pos_left
					use_dir = face_right
				]],
				verbs = {
					walkto = function(me)
						if me.state == "state_open" then
							come_out_door(me, obj_masterbedroom_door_landing)
						else
							say_line"the door is closed"
						end
					end
				}
			}

		rm_landing = {
				data = [[
					map = {0,8,21,15}
				]],
				objects = {
					obj_landing_exit_hall,
					obj_landing_door_spareroom,
					obj_landing_door_smallbedroom,
					obj_landing_door_masterbedroom
				},
			}

	-- spare room
		-- objects		
			obj_spareroom_exit_landing = {
				data = [[
					name=landing
					state=state_open
					x=8
					y=24
					w=1
					h=3
					use_pos = pos_right
					use_dir = face_left
					classes = {class_door}
				]],
				init = function(me)
					me.target_door = obj_landing_door_spareroom
				end
			}

		rm_spareroom = {
			data = [[
				map = {40,8,55,15}
				col_replace = {11,0}
			]],
			objects = {
				obj_spareroom_exit_landing,
			},
			enter = function(me)
				if not me.seen_blood then
					-- don't do this again
					me.seen_blood = true
					-- play suspense
					safe_music(36)
				end
			end,
		}

	-- small bedroom
		-- objects		
		obj_smallbedroom_exit_landing = {
			data = [[
				name=landing
				state=state_open
				x=8
				y=24
				w=1
				h=3
				use_pos = pos_right
				use_dir = face_left
				classes = {class_door}
			]],
			init = function(me)
				me.target_door = obj_landing_door_smallbedroom
			end
		}

		function walk_to_wardrobe(me)
			if me.state == "state_closed" then 
				say_line"the door is closed"
			else
				say_line"i can't fit in there!"
			end
		end

		obj_smallbedroom_door_wardrobe1 = {		
				data = [[
					name = wardrobe
					state = state_closed
					x=32
					y=16
					z=1
					w=1
					h=3
					state_closed=78
					classes = {class_openable,class_door}
					use_pos = {28,40}
					use_dir = face_back
					flip_x = true
					trans_col = 1
				]],
				verbs = {
					walkto = walk_to_wardrobe
				}
			}

		obj_smallbedroom_door_wardrobe2 = {		
				data = [[
					name = wardrobe
					state = state_closed
					x=48
					y=16
					z=1
					w=1
					h=3
					state_closed=78
					classes = {class_openable,class_door}
					use_pos = {44,40}
					use_dir = face_back
					flip_x = true
					trans_col = 1
				]],
				verbs = {
					walkto = walk_to_wardrobe
				}
			}


		obj_hanger = {		
			data = [[
				name = wire hanger
				state = state_here
				state_here = 143
				x = 48
				y = 17
				w = 1
				h = 1
				z = 10
				classes={class_pickupable}
				use_pos = {44,40}
				use_with=true
			]],
			dependent_on = obj_smallbedroom_door_wardrobe2,
			dependent_on_state = "state_open",
			verbs = {
				lookat = function(me)
					say_line"it's a wire coat hanger"
				end,
				pickup = function(me)
					pickup_obj(me)
				end,
				use = function(me, noun2)
					if (noun2 == obj_tv) then
						put_at(me, -9,0, rm_void)
						-- fix telly (scary moment)
						cutscene(
						3, -- no verbs & no follow, 
						function()
							say_line"ok, let's see if we can fix this..."
							-- show ghost
							put_at(ghost_actor, 12, 50, rm_livingroom)
							-- play suspense
							safe_music(36)
							break_time(300)
							-- play stalking
							safe_music(40)
							ghost_actor.walk_speed = 0.1
							walk_to(ghost_actor, 50,58)
							wait_for_actor(ghost_actor)
							say_line"almost got it..."
							walk_to(ghost_actor, 84,45)
							wait_for_actor(ghost_actor)
							-- fixed
							put_at(ghost_actor, 0, 0, rm_void)
							obj_tv.fixed = true
							rm_livingroom.col_replace = {11,13}
							-- laurie's theme
							safe_music(30)
							say_line"fixed it!"
							-- play tv's "look" code
							obj_tv.verbs.lookat(obj_tv)
						end
					) -- end cutscene
					end
				end,
			}
		}

		rm_smallbedroom = {
			data = [[
				map = {24,8,39,15}
				col_replace = {11,0}
			]],
			objects = {
				obj_smallbedroom_exit_landing,
				obj_smallbedroom_door_wardrobe1,
				obj_smallbedroom_door_wardrobe2,
				obj_hanger,
			},
		}

	-- master bedroom
		-- objects-- 
		obj_masterbedroom_door_landing = {
				data = [[
					name=landing
					state=state_open
					x=8
					y=24
					w=1
					h=3
					use_pos = pos_right
					use_dir = face_left
				]],
				verbs = {
					walkto = function(me)
						come_out_door(me, obj_landing_door_masterbedroom)
					end
				}
			}

		rm_bedroom_master = {
				data = [[
					map = {56,8,71,15}
				]],
				objects = {
					obj_masterbedroom_door_landing,
				},
				enter = function(me)
					-- start finale
					start_script(function()
							
						cutscene(
							3, -- no verbs & no follow, 
							function()
								break_time(100)
								say_line"look, an unbroken mirror!"
								walk_to(selected_actor, 60,42)
								wait_for_actor(selected_actor)
								change_room(rm_end, 1)
							end	
						) -- cutscene

					end)

				end,
			}


-- [ end "room" ]
	-- objects
	obj_custom_reveal = {		
			data = [[
				name=
				x=8
				y=2
				w=3
				h=3
				z=-1
			]],
			draw = function(me)
				local col=police_cols[col_index]
				-- mirror
				rect(35-xxx/2,10,105-xxx/2,69,police_cols[col_index+1])
				rect(32-xxx/2,7,108-xxx/2,72,police_cols[col_index+1])
				-- reflection
				clip(35-xxx/2,10,70,70)
				palt(11,true)
				pal(8,col)
				--pal(13,col) --mask
				pal(9,0)
				map(105,0,29.9+xxx,20,6,6)
				-- silhouette
				clip()
				palt(11,true)
				pal(13,0)
				pal(9,0)
				pal(8,col)
				palt(0,false)
				map(105,0,30-xxx,20,6,8)
			end,
		}

	rm_end = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_custom_reveal,
		},
		enter = function(me)
			police_cols = {13,13,8,12,13,13,13,1,2,13}
			col_delay = 1
			col_index = 1
			xxx = 0
			cutscene(
				3, -- no verbs & no follow, 
				function()
					
					break_time(100)
					print_line("oh my god...", 64,3,8,1)
					while xxx<19.9 do
					--for x=0,20,.125 do
						xxx+=.125
						break_time()
					end
					
					-- play jump scare sfx
					safe_music(35)					
					print_line("i'm the killer!", 64,3,8,1,true,200)
					break_time(50)
					print_line("now i remember,;i went back to the hospital", 64,3,8,1,false)
					print_line("i used shock therapy;to forget...", 64,3,8,1,false)
					print_line("to forget what i did", 64,3,8,1,false)
					--start playing sirens
					sfx(63)
					-- police flash
					start_script(function()
						while true do
							col_delay += 1
							if col_delay > 2 then
								col_delay = 0
								col_index += 1
								if (col_index > #police_cols) col_index=1
							end
							break_time()
						end
					end, true)
					print_line("oh no...;what have i done?", 64,3,8,1,false)
					print_line("i've lead them right to me!", 64,3,8,1,false)					
					break_time(130)					
					-- show end titles
					rm_title.gameover = true
					change_room(rm_title)
				end) -- end cutscene
				
		end,
	}



-- "the void" (room)
-- a place to put objects/actors when not in a room	
	-- objects
	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_pumpkin,
			obj_title,
		},
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_void,
	rm_title,
	rm_cell,
	rm_ward,
	rm_reception,
	rm_outside,
	rm_hall,
	rm_basement,
	rm_livingroom,
	rm_kitchen,
	rm_pantry,
	rm_landing,
	rm_spareroom,
	rm_smallbedroom,
	rm_bedroom_master,
	rm_end
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
			col = 8
			trans_col = 11
			col_replace = {8,13}
			walk_speed = 0.5
			frame_delay = 5
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
		inventory = {
		},
		verbs = {
		}
	}

	ghost_actor = { 	
		data = [[
			name = ghost?
			w = 1
			h = 4
			idle = { 193, 193, 193, 193 }
			talk = { 218, 218, 218, 218 }
			walk_anim_side = { 194, 197, 195, 196 }
			walk_anim_front = { 194, 197, 195, 196 }
			walk_anim_back = { 194, 197, 195, 196 }
			col = 8
			trans_col = 11
			col_replace = {13,0}
			walk_speed = 0.1
			frame_delay = 2
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
	}

-- 
-- active actors list
-- 
actors = {
	main_actor,
	ghost_actor
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set ui colors
	reset_ui()


	--extcmd "rec"

	selected_actor = main_actor

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	change_room(rm_title, 1) -- iris fade
	--change_room(rm_end, 1) -- iris fade

	put_at(selected_actor, 82, 44, rm_cell)
	--put_at(selected_actor, 272, 40, rm_ward)
	--put_at(selected_actor, 30, 42, rm_reception)
	--put_at(selected_actor, 50, 42, rm_outside)
	--put_at(selected_actor, 500, 42, rm_outside)
	--put_at(selected_actor, 900, 42, rm_outside)
	--put_at(selected_actor, 110, 52, rm_hall)
	--put_at(selected_actor, 80, 48, rm_livingroom)
	--put_at(selected_actor, 30, 42, rm_kitchen)
	--put_at(selected_actor, 40, 48, rm_pantry)
	--put_at(selected_actor, 120, 42, rm_landing)
	--put_at(selected_actor, 20, 52, rm_smallbedroom)
	--camera_follow(selected_actor)

	-- starting inventory
	--obj_tv.fixed = true
	--safe_music(30)

	--pickup_obj(obj_hanger, main_actor)
	-- pickup_obj(obj_knife, main_actor)
	-- pickup_obj(obj_torch, main_actor)

	put_at(ghost_actor, 272, 50, rm_ward)
	
	flicker_delay = 0
	flicker_target = 0
	start_script(flicker, true) -- bg script
end


function flicker()
	while true do
		flicker_delay += 1
		if flicker_delay >= flicker_target then
			flicker_val = flr(rnd(2))==0
			flicker_delay = 0
			flicker_target = rnd(5)+3
		end
		break_time()
	end
end

last_music_num = -1

function safe_music(music_num)
	if (music_num != last_music_num) music(music_num)
end

-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)

function shake(bq) if bq then
br=1 end bs=bq end function bt(bu) local bv=nil if has_flag(bu.classes,"class_talkable") then
bv="talkto"elseif has_flag(bu.classes,"class_openable") then if bu.state=="state_closed"then
bv="open"else bv="close"end else bv="lookat"end for bw in all(verbs) do bx=get_verb(bw) if bx[2]==bv then bv=bw break end
end return bv end function by(bz,ca,cb) local cc=has_flag(ca.classes,"class_actor") if bz=="walkto"then
return elseif bz=="pickup"then if cc then
say_line"i don't need them"else say_line"i don't need that"end elseif bz=="use"then if cc then
say_line"i can't just *use* someone"end if cb then
if has_flag(cb.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif bz=="give"then if cc then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif bz=="lookat"then if cc then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif bz=="open"then if cc then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif bz=="close"then if cc then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif bz=="push"or bz=="pull"then if cc then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif bz=="talkto"then if cc then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cd) ce=cf(cd) cg=nil ch=nil end function camera_follow(ci) stop_script(cj) ch=ci cg=nil cj=function() while ch do if ch.in_room==room_curr then
ce=cf(ch) end yield() end end start_script(cj,true) if ch.in_room!=room_curr then
change_room(ch.in_room,1) end end function camera_pan_to(cd) cg=cf(cd) ch=nil cj=function() while(true) do if ce==cg then
cg=nil return elseif cg>ce then ce+=0.5 else ce-=0.5 end yield() end end start_script(cj,true) end function wait_for_camera() while script_running(cj) do yield() end end function cutscene(type,ck,cl) cm={cn=type,co=cocreate(ck),cp=cl,cq=ch} add(cr,cm) cs=cm break_time() end function dialog_set(ct) for msg in all(ct) do dialog_add(msg) end end function dialog_add(msg) if not cu then cu={cv={},cw=false} end
cx=cy(msg,32) cz=da(cx) db={num=#cu.cv+1,msg=msg,cx=cx,dc=cz} add(cu.cv,db) end function dialog_start(col,dd) cu.col=col cu.dd=dd cu.cw=true selected_sentence=nil end function dialog_hide() cu.cw=false end function dialog_clear() cu.cv={} selected_sentence=nil end function dialog_end() cu=nil end function get_use_pos(bu) local de=bu.use_pos local x=bu.x local y=bu.y if type(de)=="table"then
x=de[1] y=de[2] elseif de=="pos_left"then if bu.df then
x-=(bu.w*8+4) y+=1 else x-=2 y+=((bu.h*8)-2) end elseif de=="pos_right"then x+=(bu.w*8) y+=((bu.h*8)-2) elseif de=="pos_above"then x+=((bu.w*8)/2)-4 y-=2 elseif de=="pos_center"then x+=((bu.w*8)/2) y+=((bu.h*8)/2)-4 elseif de=="pos_infront"or de==nil then x+=((bu.w*8)/2)-4 y+=(bu.h*8)+2 end return{x=x,y=y} end function do_anim(ci,dg,dh) di={"face_front","face_left","face_back","face_right"} if dg=="anim_face"then
if type(dh)=="table"then
dj=atan2(ci.x-dh.x,dh.y-ci.y) dk=93*(3.1415/180) dj=dk-dj dl=dj*360 dl=dl%360 if dl<0 then dl+=360 end
dh=4-flr(dl/90) dh=di[dh] end face_dir=dm[ci.face_dir] dh=dm[dh] while face_dir!=dh do if face_dir<dh then
face_dir+=1 else face_dir-=1 end ci.face_dir=di[face_dir] ci.flip=(ci.face_dir=="face_left") break_time(10) end end end function open_door(dn,dp) if dn.state=="state_open"then
say_line"it's already open"else dn.state="state_open"if dp then dp.state="state_open"end
end end function close_door(dn,dp) if dn.state=="state_closed"then
say_line"it's already closed"else dn.state="state_closed"if dp then dp.state="state_closed"end
end end function come_out_door(dq,dr,ds) if dr==nil then
dt("target door does not exist") return end if dq.state=="state_open"then
du=dr.in_room if du!=room_curr then
change_room(du,ds) end local dv=get_use_pos(dr) put_at(selected_actor,dv.x,dv.y,du) dw={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if dr.use_dir then
dx=dw[dr.use_dir] else dx=1 end selected_actor.face_dir=dx selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(dy,bd) if bd==1 then
dz=0 else dz=50 end while true do dz+=bd*2 if dz>50
or dz<0 then return end if dy==1 then
ea=min(dz,32) end yield() end end function change_room(du,dy) if du==nil then
dt("room does not exist") return end stop_script(eb) if dy and room_curr then
fades(dy,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ec={} ed() room_curr=du if not ch
or ch.in_room!=room_curr then ce=0 end stop_talking() if dy then
eb=function() fades(dy,-1) end start_script(eb,true) else ea=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(bz,ee) if not ee
or not ee.verbs then return false end if type(bz)=="table"then
if ee.verbs[bz[1]] then return true end
else if ee.verbs[bz] then return true end
end return false end function pickup_obj(bu,ci) ci=ci or selected_actor add(ci.bo,bu) bu.owner=ci del(bu.in_room.objects,bu) end function start_script(ef,eg,eh,ei) local co=cocreate(ef) local scripts=ec if eg then
scripts=ej end add(scripts,{ef,co,eh,ei}) end function script_running(ef) for ek in all({ec,ej}) do for el,em in pairs(ek) do if em[1]==ef then
return em end end end return false end function stop_script(ef) em=script_running(ef) if em then
del(ec,em) del(ej,em) end end function break_time(en) en=en or 1 for x=1,en do yield() end end function wait_for_message() while eo!=nil do yield() end end function say_line(ci,msg,ep,eq) if type(ci)=="string"then
msg=ci ci=selected_actor end er=ci.y-(ci.h)*8+4 es=ci print_line(msg,ci.x,er,ci.col,1,ep,eq) end function stop_talking() eo,es=nil,nil end function print_line(msg,x,y,col,et,ep,eq) local col=col or 7 local et=et or 0 if et==1 then
eu=min(x-ce,127-(x-ce)) else eu=127-(x-ce) end local ev=max(flr(eu/2),16) local ew=""for ex=1,#msg do local ey=sub(msg,ex,ex) if ey==":"then
ew=sub(msg,ex+1) msg=sub(msg,1,ex-1) break end end local cx=cy(msg,ev) local cz=da(cx) ez=x-ce if et==1 then
ez-=((cz*4)/2) end ez=max(2,ez) er=max(18,y) ez=min(ez,127-(cz*4)-1) eo={fa=cx,x=ez,y=er,col=col,et=et,fb=eq or(#msg)*8,dc=cz,ep=ep} if#ew>0 then
fc=es wait_for_message() es=fc print_line(ew,x,y,col,et,ep) end wait_for_message() end function put_at(bu,x,y,fd) if fd then
if not has_flag(bu.classes,"class_actor") then
if bu.in_room then del(bu.in_room.objects,bu) end
add(fd.objects,bu) bu.owner=nil end bu.in_room=fd end bu.x,bu.y=x,y end function stop_actor(ci) ci.fe=0 ed() end function walk_to(ci,x,y) local ff=fg(ci) local fh=flr(x/8)+room_curr.map[1] local fi=flr(y/8)+room_curr.map[2] local fj={fh,fi} local fk=fl(ff,fj) ci.fe=1 for fm in all(fk) do local fn=(fm[1]-room_curr.map[1])*8+4 local fo=(fm[2]-room_curr.map[2])*8+4 local fp=sqrt((fn-ci.x)^2+(fo-ci.y)^2) local fq=ci.walk_speed*(fn-ci.x)/fp local fr=ci.walk_speed*(fo-ci.y)/fp if ci.fe==0 then
return end if fp>5 then
ci.flip=(fq<0) if abs(fq)<0.4 then
if fr>0 then
ci.fs=ci.walk_anim_front ci.face_dir="face_front"else ci.fs=ci.walk_anim_back ci.face_dir="face_back"end else ci.fs=ci.walk_anim_side ci.face_dir="face_right"if ci.flip then ci.face_dir="face_left"end
end for ex=0,fp/ci.walk_speed do ci.x+=fq ci.y+=fr yield() end end end ci.fe=2 end function wait_for_actor(ci) ci=ci or selected_actor while ci.fe!=2 do yield() end end function proximity(ca,cb) if ca.in_room==cb.in_room then
local fp=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fp else return 1000 end end ft=16 ce,cg,cj,br=0,nil,nil,0 fu,fv,fw,fx=63.5,63.5,0,1 fy={7,12,13,13,12,7} fz={{spr=208,x=75,y=ft+60},{spr=240,x=75,y=ft+72}} dm={face_front=1,face_left=2,face_back=3,face_right=4} function ga(bu) local gb={} for el,bw in pairs(bu) do add(gb,el) end return gb end function get_verb(bu) local bz={} local gb=ga(bu[1]) add(bz,gb[1]) add(bz,bu[1][gb[1]]) add(bz,bu.text) return bz end function ed() gc=get_verb(verb_default) gd,ge,o,gf,gg=nil,nil,nil,false,""end ed() eo=nil cu=nil cs=nil es=nil ej={} ec={} cr={} gh={} ea,ea=0,0 gi=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gj() start_script(startup_script,true) end function _update60() gk() end function _draw() gl() end function gk() if selected_actor and selected_actor.co
and not coresume(selected_actor.co) then selected_actor.co=nil end gm(ej) if cs then
if cs.co
and not coresume(cs.co) then if cs.cn!=3
and cs.cq then camera_follow(cs.cq) selected_actor=cs.cq end del(cr,cs) if#cr>0 then
cs=cr[#cr] else if cs.cn!=2 then
gi=3 end cs=nil end end else gm(ec) end gn() go() gp,gq=1.5-rnd(3),1.5-rnd(3) gp=flr(gp*br) gq=flr(gq*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gl() rectfill(0,0,127,127,0) camera(ce+gp,0+gq) clip(0+ea-gp,ft+ea-gq,128-ea*2-gp,64-ea*2) gr() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,ft-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,ft-8,8) end if show_debuginfo then
print("x: "..flr(fu+ce).." y:"..fv-ft,80,ft-8,8) end gs() if cu
and cu.cw then gt() gu() return end if gi>0 then
gi-=1 return end if not cs then
gv() end if(not cs
or cs.cn==2) and gi==0 then gw() else end if not cs then
gu() end end function gn() if cs then
if(btnp(5) or stat(34)>0)
and cs.cp then cs.co=cocreate(cs.cp) cs.cp=nil return end return end if btn(0) then fu-=1 end
if btn(1) then fu+=1 end
if btn(2) then fv-=1 end
if btn(3) then fv+=1 end
if btnp(4) then gx(1) end
if btnp(5) then gx(2) end
if enable_mouse then
gy,gz=stat(32)-1,stat(33)-1 if gy!=ha then fu=gy end
if gz!=hb then fv=gz end
if stat(34)>0 then
if not hc then
gx(stat(34)) hc=true end else hc=false end ha=gy hb=gz end fu=mid(0,fu,127) fv=mid(0,fv,127) end function gx(hd) local he=gc if not selected_actor then
return end if cu and cu.cw then
if hf then
selected_sentence=hf end return end if hg then
gc=get_verb(hg) elseif hh then if hd==1 then
if(gc[2]=="use"or gc[2]=="give")
and gd then ge=hh else gd=hh end elseif hi then gc=get_verb(hi) gd=hh ga(gd) gv() end elseif hj then if hj==fz[1] then
if selected_actor.hk>0 then
selected_actor.hk-=1 end else if selected_actor.hk+2<flr(#selected_actor.bo/4) then
selected_actor.hk+=1 end end return end if gd!=nil
then if gc[2]=="use"or gc[2]=="give"then
if ge then
elseif gd.use_with and gd.owner==selected_actor then return end end gf=true selected_actor.co=cocreate(function() if(not gd.owner
and(not has_flag(gd.classes,"class_actor") or gc[2]!="use")) or ge then hl=ge or gd hm=get_use_pos(hl) walk_to(selected_actor,hm.x,hm.y) if selected_actor.fe!=2 then return end
use_dir=hl if hl.use_dir then use_dir=hl.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gc,gd) then
start_script(gd.verbs[gc[1]],false,gd,ge) else if has_flag(gd.classes,"class_door") then
if gc[2]=="walkto"then
come_out_door(gd,gd.target_door) elseif gc[2]=="open"then open_door(gd,gd.target_door) elseif gc[2]=="close"then close_door(gd,gd.target_door) end else by(gc[2],gd,ge) end end ed() end) coresume(selected_actor.co) elseif fv>ft and fv<ft+64 then gf=true selected_actor.co=cocreate(function() walk_to(selected_actor,fu+ce,fv-ft) ed() end) coresume(selected_actor.co) end end function go() if not room_curr then
return end hg,hi,hh,hf,hj=nil,nil,nil,nil,nil if cu
and cu.cw then for ek in all(cu.cv) do if hn(ek) then
hf=ek end end return end ho() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hp(bu,bu.w*8,bu.h*8,ce,hq) else bu.hr=nil end if hn(bu) then
if not hh
or(not bu.z and hh.z<0) or(bu.z and hh.z and bu.z>hh.z) then hh=bu end end hs(bu) end for el,ci in pairs(actors) do if ci.in_room==room_curr then
hp(ci,ci.w*8,ci.h*8,ce,hq) hs(ci) if hn(ci)
and ci!=selected_actor then hh=ci end end end if selected_actor then
for bw in all(verbs) do if hn(bw) then
hg=bw end end for ht in all(fz) do if hn(ht) then
hj=ht end end for el,bu in pairs(selected_actor.bo) do if hn(bu) then
hh=bu if gc[2]=="pickup"and hh.owner then
gc=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if gc==nil then
gc=get_verb(verb_default) end if hh then
hi=bt(hh) end end end function ho() gh={} for x=-64,64 do gh[x]={} end end function hs(bu) er=-1 if bu.hu then
er=bu.y else er=bu.y+(bu.h*8) end hv=flr(er) if bu.z then
hv=bu.z end add(gh[hv],bu) end function gr() if not room_curr then
print("-error-  no current room set",5+ce,5+ft,8,0) return end rectfill(0,ft,127,ft+64,room_curr.hw or 0) for z=-64,64 do if z==0 then
hx(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,ft,room_curr.hy,room_curr.hz) pal() else hv=gh[z] for bu in all(hv) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then ia(bu) end else if bu.in_room==room_curr then
ib(bu) end end ic(bu) end end end end function hx(bu) if bu.col_replace then
id=bu.col_replace pal(id[1],id[2]) end if bu.lighting then
ie(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ie(bu.in_room.lighting) end end function ia(bu) hx(bu) if bu.draw then
bu.draw(bu) else ig=1 if bu.repeat_x then ig=bu.repeat_x end
for h=0,ig-1 do local ih=0 if bu.states then
ih=bu.states[bu.state] else ih=bu[bu.state] end ii(ih,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x) end end pal() end function ib(ci) ij=dm[ci.face_dir] if ci.fe==1
and ci.fs then ci.ik+=1 if ci.ik>ci.frame_delay then
ci.ik=1 ci.il+=1 if ci.il>#ci.fs then ci.il=1 end
end im=ci.fs[ci.il] else im=ci.idle[ij] end hx(ci) ii(im,ci.df,ci.hu,ci.w,ci.h,ci.trans_col,ci.flip,false) if es
and es==ci and es.talk then if ci.io<7 then
im=ci.talk[ij] ii(im,ci.df,ci.hu+8,1,1,ci.trans_col,ci.flip,false) end ci.io+=1 if ci.io>14 then ci.io=1 end
end pal() end function gv() ip=""iq=verb_maincol ir=gc[2] if gc then
ip=gc[3] end if gd then
ip=ip.." "..gd.name if ir=="use"then
ip=ip.." with"elseif ir=="give"then ip=ip.." to"end end if ge then
ip=ip.." "..ge.name elseif hh and hh.name!=""and(not gd or(gd!=hh)) and(not hh.owner or ir!=get_verb(verb_default)[2]) then ip=ip.." "..hh.name end gg=ip if gf then
ip=gg iq=verb_hovcol end print(is(ip),it(ip),ft+66,iq) end function gs() if eo then
iu=0 for iv in all(eo.fa) do iw=0 if eo.et==1 then
iw=((eo.dc*4)-(#iv*4))/2 end outline_text(iv,eo.x+iw,eo.y+iu,eo.col,0,eo.ep) iu+=6 end eo.fb-=1 if eo.fb<=0 then
stop_talking() end end end function gw() ez,er,ix=0,75,0 for bw in all(verbs) do iy=verb_maincol if hi
and bw==hi then iy=verb_defcol end if bw==hg then iy=verb_hovcol end
bx=get_verb(bw) print(bx[3],ez,er+ft+1,verb_shadcol) print(bx[3],ez,er+ft,iy) bw.x=ez bw.y=er hp(bw,#bx[3]*4,5,0,0) ic(bw) if#bx[3]>ix then ix=#bx[3] end
er+=8 if er>=95 then
er=75 ez+=(ix+1.0)*4 ix=0 end end if selected_actor then
ez,er=86,76 iz=selected_actor.hk*4 ja=min(iz+8,#selected_actor.bo) for jb=1,8 do rectfill(ez-1,ft+er-1,ez+8,ft+er+8,verb_shadcol) bu=selected_actor.bo[iz+jb] if bu then
bu.x,bu.y=ez,er ia(bu) hp(bu,bu.w*8,bu.h*8,0,0) ic(bu) end ez+=11 if ez>=125 then
er+=12 ez=86 end jb+=1 end for ex=1,2 do jc=fz[ex] if hj==jc then pal(verb_maincol,verb_hovcol) end
ii(jc.spr,jc.x,jc.y,1,1,0) hp(jc,8,7,0,0) ic(jc) pal() end end end function gt() ez,er=0,70 for ek in all(cu.cv) do if ek.dc>0 then
ek.x,ek.y=ez,er hp(ek,ek.dc*4,#ek.cx*5,0,0) iy=cu.col if ek==hf then iy=cu.dd end
for iv in all(ek.cx) do print(is(iv),ez,er+ft,iy) er+=5 end ic(ek) er+=2 end end end function gu() col=fy[fx] pal(7,col) spr(224,fu-4,fv-3,1,1,0) pal() fw+=1 if fw>7 then
fw=1 fx+=1 if fx>#fy then fx=1 end
end end function ii(jd,x,y,w,h,je,flip_x,jf) set_trans_col(je,true) spr(jd,x,ft+y,w,h,flip_x,jf) end function set_trans_col(je,bq) palt(0,false) palt(je,true) if je and je>0 then
palt(0,false) end end function gj() for fd in all(rooms) do jg(fd) if(#fd.map>2) then
fd.hy=fd.map[3]-fd.map[1]+1 fd.hz=fd.map[4]-fd.map[2]+1 else fd.hy=16 fd.hz=8 end for bu in all(fd.objects) do jg(bu) bu.in_room=fd bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for jh,ci in pairs(actors) do jg(ci) ci.fe=2 ci.ik=1 ci.io=1 ci.il=1 ci.bo={} ci.hk=0 end end function ic(bu) local ji=bu.hr if show_collision
and ji then rect(ji.x,ji.y,ji.jj,ji.jk,8) end end function gm(scripts) for em in all(scripts) do if em[2] and not coresume(em[2],em[3],em[4]) then
del(scripts,em) em=nil end end end function ie(jl) if jl then jl=1-jl end
local fm=flr(mid(0,jl,1)*100) local jm={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jn=1,15 do col=jn jo=(fm+(jn*1.46))/22 for el=1,jo do col=jm[col] end pal(jn,col) end end function cf(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hy*8)-128) end function fg(bu) local fh=flr(bu.x/8)+room_curr.map[1] local fi=flr(bu.y/8)+room_curr.map[2] return{fh,fi} end function jp(fh,fi) local jq=mget(fh,fi) local jr=fget(jq,0) return jr end function cy(msg,ev) local cx={} local js=""local jt=""local ey=""local ju=function(jv) if#jt+#js>jv then
add(cx,js) js=""end js=js..jt jt=""end for ex=1,#msg do ey=sub(msg,ex,ex) jt=jt..ey if ey==" "
or#jt>ev-1 then ju(ev) elseif#jt>ev-1 then jt=jt.."-"ju(ev) elseif ey==";"then js=js..sub(jt,1,#jt-1) jt=""ju(0) end end ju(ev) if js!=""then
add(cx,js) end return cx end function da(cx) cz=0 for iv in all(cx) do if#iv>cz then cz=#iv end
end return cz end function has_flag(bu,jw) for be in all(bu) do if be==jw then
return true end end return false end function hp(bu,w,h,jx,jy) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.df=x-(bu.w*8)/2 bu.hu=y-(bu.h*8)+1 x=bu.df y=bu.hu end bu.hr={x=x,y=y+ft,jj=x+w-1,jk=y+h+ft-1,jx=jx,jy=jy} end function fl(jz,ka) local kb,kc,kd,ke,kf={},{},{},nil,nil kg(kb,jz,0) kc[kh(jz)]=nil kd[kh(jz)]=0 while#kb>0 and#kb<1000 do local ki=kb[#kb] del(kb,kb[#kb]) kj=ki[1] if kh(kj)==kh(ka) then
break end local kk={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kl=kj[1]+x local km=kj[2]+y if abs(x)!=abs(y) then kn=1 else kn=1.4 end
if kl>=room_curr.map[1] and kl<=room_curr.map[1]+room_curr.hy
and km>=room_curr.map[2] and km<=room_curr.map[2]+room_curr.hz and jp(kl,km) and((abs(x)!=abs(y)) or jp(kl,kj[2]) or jp(kl-x,km) or enable_diag_squeeze) then add(kk,{kl,km,kn}) end end end end for ko in all(kk) do local kp=kh(ko) local kq=kd[kh(kj)]+ko[3] if not kd[kp]
or kq<kd[kp] then kd[kp]=kq local h=max(abs(ka[1]-ko[1]),abs(ka[2]-ko[2])) local kr=kq+h kg(kb,ko,kr) kc[kp]=kj if not ke
or h<ke then ke=h kf=kp ks=ko end end end end local fk={} kj=kc[kh(ka)] if kj then
add(fk,ka) elseif kf then kj=kc[kf] add(fk,ks) end if kj then
local kt=kh(kj) local ku=kh(jz) while kt!=ku do add(fk,kj) kj=kc[kt] kt=kh(kj) end for ex=1,#fk/2 do local kv=fk[ex] local kw=#fk-(ex-1) fk[ex]=fk[kw] fk[kw]=kv end end return fk end function kg(kx,cd,fm) if#kx>=1 then
add(kx,{}) for ex=(#kx),2,-1 do local ko=kx[ex-1] if fm<ko[2] then
kx[ex]={cd,fm} return else kx[ex]=ko end end kx[1]={cd,fm} else add(kx,{cd,fm}) end end function kh(ky) return((ky[1]+1)*16)+ky[2] end function dt(msg) print_line("-error-;"..msg,5+ce,5,8,0) end function jg(bu) local cx=kz(bu.data,"\n") for iv in all(cx) do local pairs=kz(iv,"=") if#pairs==2 then
bu[pairs[1]]=la(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function kz(ek,lb) local lc={} local iz=0 local ld=0 for ex=1,#ek do local le=sub(ek,ex,ex) if le==lb then
add(lc,sub(ek,iz,ld)) iz=0 ld=0 elseif le!=" "and le!="\t"then ld=ex if iz==0 then iz=ex end
end end if iz+ld>0 then
add(lc,sub(ek,iz,ld)) end return lc end function la(lf) local lg=sub(lf,1,1) local lc=nil if lf=="true"then
lc=true elseif lf=="false"then lc=false elseif lh(lg) then if lg=="-"then
lc=sub(lf,2,#lf)*-1 else lc=lf+0 end elseif lg=="{"then local kv=sub(lf,2,#lf-1) lc=kz(kv,",") li={} for cd in all(lc) do cd=la(cd) add(li,cd) end lc=li else lc=lf end return lc end function lh(id) for a=1,13 do if id==sub("0123456789.-+",a,a) then
return true end end end function outline_text(lj,x,y,lk,ll,ep) if not ep then lj=is(lj) end
for lm=-1,1 do for ln=-1,1 do print(lj,x+lm,y+ln,ll) end end print(lj,x,y,lk) end function it(ek) return 63.5-flr((#ek*4)/2) end function lo(ek) return 61 end function hn(bu) if not bu.hr
or cs then return false end hr=bu.hr if(fu+hr.jx>hr.jj or fu+hr.jx<hr.x)
or(fv>hr.jk or fv<hr.y) then return false else return true end end function is(ek) local a=""local iv,id,kx=false,false for ex=1,#ek do local ht=sub(ek,ex,ex) if ht=="^"then
if id then a=a..ht end
id=not id elseif ht=="~"then if kx then a=a..ht end
kx,iv=not kx,not iv else if id==iv and ht>="a"and ht<="z"then
for jn=1,26 do if ht==sub("abcdefghijklmnopqrstuvwxyz",jn,jn) then
ht=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jn,jn) break end end end a=a..ht id,kx=false,false end end return a end








__gfx__
00000000bb8000dddddddddd090ddddddddddd8bbbb8b00000000000bbb80000d0d0d0d0ddddddd000000dddddd00000bd0bbd0b000000000dddddd000000000
00000000bbb000dddddddddd9990ddddddddd08bbbb8b800000000ddb88000000d0d0d0dd0d0d0d00000dddddddd0000bbd0d0d000000000d000000d00000000
00700700bbb0000dddddddd09990dddddddddd8bbbbbb800000000dd80000000ddd0d0d0d0d0d0d0000ddd0000ddd000d0bd0d0b0000000d00000000d0000000
00077000bbb8080dd0ddddddd99ddddddddddd8bbbbbbb8000000000000000000d0d0d0dd0d0d0d00dddd000000dddd0bd0dd0bd000000d000d00d000d000000
00077000bbb88000dd000ddddddddd0dddddd0bbbbbbbb800000000d00000000d0d0d0d0d0d0d0d0dddd00d00000ddddbbdd0bd0000000d0000000000d000000
00700700bbb80000dd00ddddddddddd00dddd00bbbbbbb8000000ddd000000000d0ddd0dd0d0d0d0dd000d00d00000ddd0bd0d0b000000d000d00d000d000000
00000000bbbb0000dddddddd000ddddddddd08b8bbbbbb8000dddddd00000000d0d0d0d0d0d0d0d0dd00d00d000000ddbd0dd0bb000000d0000000000d000000
00000000bbbb80000ddddd0000000ddddddd0bbbbbbbbb800dddddd0000000000d0d0d0dddddddd0dd0000d0000000ddbbdd0bbb000000d00dddddd00d000000
bbbbbbbbbb0000ddddddddddddddddddddddd00bbbbbb800dddd0bbb00008bbb0d0d0d0d00000800dd000d000000d0ddd0bd0dd00000000dddddddddd0000000
bbbbbbbbb08000ddddddddddddddddddddddd008bbbb8000ddd08bbb0000088bdddddddd00800800dd00d000000d00ddbdddd00b0000000dddddddddd0000000
bbbbbbbbb000000ddddd9999dddd99ddddddd00bbbb80000d0008bbb00000008d0d0d0d000800800dd00000000d000ddd0bd0bdd0000000d00000000d0000000
bbbbbbbbb800000ddd999999dddd99990dddd00bbbb80000000d8bbb00000000dddddddd00800000dd0000000d0000ddbd0ddd000000000d00000000d0000000
bbbbbbbbb800000dd999999ddddd99990dddd00bbb80000000dd8bbb000000000d0d0d0d00000800dd000000d000d0ddbbdd00bb0000000d00000000d0000000
bbbbbbbbb880800dd9999dddddddd99900dddd8b8800000000dd8bbb00000000dddddddd00800000dd000000000000ddd0bd0bdd0000000d00000000d0000000
bbbbbbbbbb80880ddddddddddddddddddddddd0b0000000000dd8bbb00000000d0d0d0d000000000ddddddddddddddddbd0ddd000000000d00000000d0000000
bbbbbbbbbb0000dddddddddddddddddddddddd8b0000000000dd8bbb00000000dddddddd00800000ddddddddddddddddbbdd00bb0000000d00000000d0000000
00000000bbbbb000000ddddddddddddd00000bbb0ddd00ddddddd8bb90000000d0dd00d00dddddddddddddddddddddd0bbbd0bbd000000000dddddd000000000
08000000bbbb80000dddddddddddddddd0000bbb00ddddd0ddddd08b090000000d0d000d0dddddddddddddddddddddd0d0bd0bbd000000ddd000000ddd000000
08000000bbb80000dddddddddddddddddd000b8b0000dd00dddd000800909009d0dd00d00dddddddddddddddddddddd0bddd0bdd00000d000000000000d00000
08000080bb000000ddddddddddddddddddd080bb0000000dddddd000009999990d0d000d0dddddddddddddddddddddd0bb0d0dd00000d00000d00d00000d0000
008000808b00000dddddddddddddddddddd000bb000000dddddd000000099999d0dd00d00dddddddddddddddddddddd0bbbddd0b000000000000000000000000
00088080b000000ddddddddddddddddddddd00bb00000000ddd00000000090090d0d000d0dddddddddddddddddddddd0d0bd0bbb0ddd0000000000000000ddd0
00000880b00000dddddddddddddddddddddd00bb00000000dd00000000000000d0dd00d00dddddddddddddddddddddd0bd0d0bbbd000d00000d00d00000d000d
00888880bb0000ddddddddddddddddddddddd0b80000000000000000000000000d0d0d0d000000000000000000000000bbdd0bbbd0000d000000000000d0000d
bbbbbbbbbbbbbbbbbbbbbb0008088bbbbbbbbbbbddddd00dbbbbbbbb0000000000000000008888000000080000008000bbbd0bbd0d000d000000000000d000d0
bbbbbbbbbbbbbbbbbbbb8bb000000bbbbbbbbbbb000dddddbbbbbbbb0000000900800000008008000880880000008000bbbd0dd000d000000000000000000d00
bbbbbbbbbbbbbbbbbbb80000000008bbbbbbbbbb0000ddddbbbbbbbb0090099000800000008008000808080000008000bbbdd0bb00d00dddddddddddddd00d00
bbbbbbbbbbbbbbbbbb00000000000008bbbbbbbbddd000008bbbbbbb9999990000800000008008000808080000080000bbbd0bbb00d0d00000000000000d0d00
bbbbbbbbbbbbbbbbb8000000000000000bbbbbbbdddd00008bbbbbbb9999900000800000008880000800080000080000bbbd0bbb00d0d00000000000000d0d00
bbbbbbbbbbbbbbbb0000000000000000008bbbbb000000008bbbbbbb0090000000800000008000000800080000000000bbbd0bbb00d0dddddddddddddddd0d00
bbbbbb88bbbbbb0000000000000000000008bbbb0000000008bbbbbb0000000000808800008000000800080000000000bbbbbbbb00d000000000000000000d00
bbbb8800bbbbbb00000000ddddddd0000008bbbb000000000088bbbb0000000000880000008000000800000000800000bbbbbbbb00d000000000000000000d00
00000000000000000000000000000000dddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000
000dddd00000000000000000000000000000000000000000d000000dd000000d0000000000000000000000000000000000000000000000000dddddd00dddddd0
dd0000000000000000000000000000000dd0dd0dd0dd0d00d000000dd000000d0000800000000000000000888008888888880000000000000d0000d00d0000d0
000dddd000000000dddddd00000000000dd0dd0dd0dd0d00d000000dd000000d0000000000080000000888888888888888888800000000000d0000d00d0000d0
dd0dddd00000000dd0d0d0dd000000000000000000000000d000000dd000000d0000000000000000800888888888888888888888000000000d0000d00d0000d0
dd0dddd0000000d0d0d0d0d0d00000000d0dd0dddd0dd000d000000dd000000d0080000000000000000000888888888888888800000000000d0000d00d0000d0
00000000000000d0d00000d0d00000000d0dd0dddd0dd000d000000dd000000d0000000000000000000000000000088880000000000008800d0000d00d0000d0
dddddddd000000d00ddddd00d00000000000000000000000dddddddddddddddd0000000000000000000080800000000000000000000008000d0000d00d0000d0
0000000000000000ddddddd0000000000dd0dd0000dd0d00d00000dddd00000d0000000000000000dddddddd0d00000000000000dddddddd0d0000d00d0000d0
0000d000000000ddddddddddd00000000dd0dd0000dd0d00d0000d0dd0d0000d0000000000000000dddddddd0dd0d00000000000dd8d8ddd0dddddd00d0000d0
d000dd0000000d00000000000d0000000000000000000000d0000d0dd0d0000d0000000000000000dddddddd0d0dd00000000000d88ddddd000000000d00ddd0
d0d0dd000000d0000000000000d000000d0dd0d00d0dd000d000000dd000000d000000bbbbbbb0000000000000dd00000000d000d888dddd000000000ddd0000
d0d0d0d00000000000000000000000000d0dd0d00d0dd000d000000dd000000d0000000b000b0000dddddddd0ddd0000000ddd00d888dddd0dd0000000000000
d0d0d0d00000ddddddddddddddd000000000000000000000d000000dd000000d00000000b0b00000dddddddd0dd000d00000d000d888dddd0dd0000000000000
d0d0d00d000dd0d0d0d0d0d0d0dd00000dd0dd0000dd0d00dddddddddddddddd0dddddddddddddd0dddddddd0dd00ddd00000000dd88dddd000000000dd00000
d0d0d00d00d0d0d0d0d0d0d0d0d0d0000dd0dd0000dd0d0000000000000000000dd00000000dd0d0000000000000000000000000dd8ddddd0dddddd00dd00000
0000000000d0d0d0d0d0d0d0d0d0d000ddddddddddddddd000000000000000000d0000000000ddd00d000d000000000000000000dd8ddddd0d0000d000000000
dddddddd00d0d0d0d0d0d0d0d0d0d00000000000d00d00d0dddddddddddddddd0d0000000000d0d0ddd0d000000000d000000000dd8ddddd0d0000d00000ddd0
0000000000d0ddddddddddddddd0d000d0dd0dd0d00d00d000000000000000000d0000000000ddd00dddd0000000d00d00000000dd8ddddd0d0000d00ddd00d0
ddddddd000d0d0d0d0d0d0d0d0d0d000d0dd0dd0d00d00d0000dddddddddd0000d0000000000ddd00000d0ddddd0000d000d0000dddddddd0d0000d00d0000d0
d00000d000d0d0d0d0d0d0d0d0d0d00000000000d00d00d0000d00000000d0000d0000000000ddd00000ddd00dd00d0000000000dd8ddddd0d0000d00d0000d0
d00000d000d0ddddddddddddddd0d0000dd0dd0dd00d00d0000d000dd000d0000d0000000000ddd00dd0d0000000dd0000000000dddddddd0d0000d00d0000d0
d00000d000d00000000000000000d0000dd0dd0dd00d00d0000d00000000d0000dd00000000dddd0ddddd0d0000dd00000000000dd8ddddd0dddddd00d0000d0
d00000d000d00000000000000000d00000000000ddddddd0000dddddddddd0000dddddddddddddd0d000dddd0d00d00000000000dddddddd000000000d0000d0
d00000d0000008000000880000000000ddddddd000000000000d00000000d000d000000dd0dd00d00000d00d0000000000000000000000000dd0dd0d0d0000d0
d00000d0008008000088000000888800d00000d0dddddddd000d00000000d000d000000d0d0d0d0d0000d00000dddd000000000000000000000000000d000dd0
d00000d0008008000080000008800880d00d00d000000000000d00000000d000d000000dd0dd00d0000000000dd00dd00000000000ddd000d0dd0dd00d0dd000
d00000d0008088000080000008088080ddddddd0000ddddd000d00000000d000d000000d0d0d0d0d0ddddddd0d0dd0d00000000000d8d000d0dd0dd00dd00000
d00000d0008808000088800000800800d00000d0000d0000000d00000000d000d000000dd0d0d0d000ddddd000d00d000000000000d0d0000000000000000000
d00000d0008008000080000008800880d00000d0000d000d000d00000000d000d000000d0d0d0d0d00ddddd00dd00dd00000000000ddd0000dd0dd0d00000000
ddddddd0008008000080080008888880d00000d0000d0000000dddddddddd000ddddddddd0d0d0d000ddddd00dddddd00d0d0000000000000dd0dd0d00000000
00000000008000000088800000000000ddddddd0000ddddd0000000000000000000000000d0d0d0d000ddd0000000000d000d0d0000000000000000000000000
dddddd0000ddddddddddddd0dddddddd0000000d0d000000ddddddddaaaaaaaaddddddddd0d0d0d000000000dddd00000dddddd00dddddd000000000000dd000
dddd00000000dddddddddd0d0ddddddd00000d00000d0000ddddddddaaaaaaaadddddddd0d0d0d0d00000000dddd00000dddddd00d00d0d00000000000d00d00
dd000000000000ddddd0d0d0d0dddddd000d000000000d0000000000aaaaaaaaddddddddd0d0d0d000000000dddd0000d0dddd000dd0ddd00000000000000d00
0000000000000000dd0d0d0d0d0d0ddd0d0000000000000dddddddddaaaaaaaadddddddd0d0d0d0d00000000dddd000000dddd000d0d00d000000000000dd000
0000000000000000d0d0d0d0d0d0d0dd0000000000000000ddddddddaaaaaaaaddddddddd0d0d0d0000000000000ddddd0dddd000dd0d0d0000000000dd00dd0
00000000000000000d0d0d0d0d0d0d0d000000000000000000000000aaaaaaaadddddddd0d0d0d0d000000000000ddddd0dddd000d0d00d000000000d000000d
0000000000000000d0d0d0d0d0d0d0d00000000000000000ddddddddaaaaaaaaddddddddd0d0d0d0000000000000ddddd0dddd000d00d8d000000000dddddddd
00000000000000000d0d0d0d0d0d0d0d0000000000000000ddddddddaaaaaaaadddddddd0d0d0d0d000000000000dddd00dddd000dddddd00000000000000000
dddddddddddddddddddddddddddddddd0000000000000000d0d00dddddd0d0d0dddddddd0000000d000000000dddddddd0dddd00000000000000000000dd0000
dddddddddddddddddddddddddddddddd00000000000000000d0d0dddddd00d0ddddddddd00000d00000000000dddddddd0dddd0000000000000000000ddd0000
dddddddddddddddddddddddddddddddd0000000000000000d000000000000000dddddddd000d0000000000000000ddddd0dddd000000000000000000dddd0000
dddddddddddddddddddddddddddddddd00000000000000000d0dddddddddd00ddddddddd0d00000000000000ddd0dddd00dddd00dddddddd00000000ddddd000
dddddd0000dddddddddddddddddddddd0000000d0d000000d00dddddddddd0d0ddddddddd0d0d0d0d0000000ddd0ddddd0dddd00dddddddd00000000000dd800
dddd00000000dddddddddd0d0ddddddd00000d00000d00000000000000000000dddddd0d0d0d0d0d00d000d0ddd00000d0dddd0000000000000000000000ddd0
dd000000000000ddddddd0d0d0d0dddd000d000000000d000dddddddddddddd0ddddd0d0d0d0d0d0d000d000ddddd0ddd0dddd00000000000000000000000ddd
0000000000000000dd0d0d0d0d0d0d0d0d0000000000000d0dddddddddddddd0dd0d0d0d0d0d0d0d00d000d0ddddd0dd00dddd000000000000000000000000dd
000000000000000000000000d0d0d0d00000000000000000ddddddddddddddd00000000000000000000000000dddd0ddd0dddd00000000000000d000bbbbbb0d
0000000000000000000000000d0d0d0d00000000000000000d0d0d0d0d0d0d0ddddddddd00000000000000000dddd0dd00dddd000000000000000d00bbbbb0d0
d0d0d0d00000000000000000d0d0d0d0d000000000000000ddddddddddddd0d0dddddddd00dddd0dddd0000000000000d0dddd0000000000000000d0bbbb0d0b
0000000000000000000000000d0d0d0d000000000000000dd0d0d0d0d0dd0d0ddddddddd00dddd0dddd00000ddd0dddd00dddd0000000000ddddddddbbb0ddd0
0000000000000000d0d0d0d0d0d0d0d00000000000000000ddddddddddd0d0d0dddddddd0000000000000000ddd0dddd0dddddd000000000d000d00dbb0dd880
00000000000000000d0d0d0d0d0d0d0d00000000000000000d0d0d0d0d0d0d0ddddddddddddd0dddd0000000000000000dddddd000000000d000ddddb0ddd800
0000000000000000d0d0d0d0d0d0d0d0d000000000000000ddddddddd0d0d0d0dddddddddddd0dddd00000000dddd0dd00000000ddddddddd000dd8d0d8800bb
00000000000000000d0d0d0d0d0d0d0d000000000000000dd0d0d0d00d0d0d0d0000000000000000000000000dddd0dd0d0d0d0d0d0d0d0dddddddddd800bbbb
00000000dddddddd00000000000000000000000000000000000000dddd0000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d000d0000d000d00000000ddd0
0000dddddddddddddddd00000000000000000000000000000000000d0d000000000000dddd0000000d0d0d0ddddddddd0ddddddd00d0000d00d0d0000000d0d0
00dddddddddddddddddddd0000000000d0000000000000000000dddddddd000000000dddddd00000d0d0d0d0ddddddd0dddddddddddddddd0d000d000000ddd0
0dddddddddddddddddddddd000000000000000000000000d00000d0dd0d000000000dddddddd00000d0d0d0ddddddd0ddddddddd0000d000d000d0d0000d0000
0dddddddddddddddddddddd000000000000000000000000000dddddddddddd00000dddddddddd000d0d0d0d00000d000000000000000d000dd0d0d0d00d00000
00dddddddddddddddddddd00000000000000000000000000000d0d0d0d0d0d0000dddddddddddd00dddd0ddddddd0ddddddddddddddddddd0dd0d0d00d000000
0000dddddddddddddddd000000000000d000000000000000dddddddddddddddd0dddddddddddddd0dddd0ddddddd0ddddddddddd00d0000d00dd0d00ddd00000
00000000dddddddd000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0dd0d0d0d00000000000000000dddd0ddddddd0ddddddddddd00d0000d000dd0000dd00000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbb0ddddd0bbbb
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0d0000d0b0000000bbbbbbbb000bbbb0d00000d0bbb
00000000bb0000bbbb0000bbbb0000bbbb0000bbbb0000bbbb0000bbbb0000bbbb0000bbbb0000bbbbbb0d00d00d00dddddd0000000000d0bbb0d000000d0bbb
00000000b0dddd0bb0dddd0bb0dddd0bb0dddd0bb0dddd0bb0dddd0bb0dddd0bb0dddd0bb0dddd0bbbbb0d0000000000000d0d0ddddd0dd0bbb0d0000000d0bb
000000000d0000d00d0000d00d0000d00d0000db0d0000db0d0000db0d0000db0d0000db0d0000dbbbbb0d0000000000000d0d0ddddd0d00bbb0d00d0000d0bb
00000000d000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bbbbb0d00000000dddddd000000000000bbbb0d000d00d0bb
00000000d000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bbbbbb0d00000db0000000000bbbbbbbbbbbbbbb0db000d0b
00000000d080080bd080080bd080080bd0000800d0000800d0000800d000000bd000000bd000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0d00d0b
000dd000d000000bd000000bd000000bd0000000d0000000d0000000d000000bd000000bd000000bd000000bd0000000d000000b00000000bbbbbbbbb0d00d0b
00d00d00d000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000bd000000b00000000bbbbbdd888d00d0b
0d0000d0d00dd00bd00dd00bd00dd00b0d000ddb0d000ddb0d000ddbd000000bd000000bd000000bd00dd00b0d000ddbd000000b00000000bbbbb88db0d00d0b
ddd00ddd0d0000bb0d0000bb0d0000bb0d00000b0d00000b0d00000b0d0000bb0d0000bb0d0000bb0d0dd0bb0d000ddb0d0000bb00000000bbbbbbbbb0d00d0b
00d00d00b0dddbbbb0dddbbbb0dddbbbb0d000bbb0d000bbb0d000bbb0d00dbbb0d00dbbb0d00dbbbd0000bbb0d0000bb0d00dbb00000000bbbbbbbbb0dddd0b
00d00d00b000000bb000000bb00000bbbb0d0bbbbb0d0bbbbb0d0bbbb00dd00bb00dd00bb00dd00bb0ddd0bbbb0d000bb00dd00b00000000bbbbbbbbb000000b
00dddd000dd00dd00dd00dd00dd00dd000d00bbbb0d000bbb0d00bbb0dd00dd00dd00dd00dd00dd0bb000bbbbbb00bbb0dd00dd000000000bbbbbbbbbb0dd0bb
00000000d0d00d00d0d00d0000d00d0d0d00d0bbb0d00d0b0d00d0bbd000000dd000000dd000000dbbbbbbbbbbbbbbbbd000000d00000000bbbbbbbbbb0000bb
00080000d000000dd000000dd000000d0d00d0bbb0d00d0b0d00d0bbd000000dd000000dd000000d0000000000000000000000000000000000000000bb0dd0bb
00080000d000000dd000000dd000000d0d00d0bbb0d00d0b0d00d0bbd000000dd000000dd000000d0000000000000000000000000000000000000000bb0dd0bb
00080000d000000dd000000dd000000d0d00d0bbb0d00d0b0d00d0bbd000000dd000000dd000000d0000000000000000000000000000000000000000bb0dd0bb
88808880d000000dd000000dd000000d0d00d0bbb0d00d0b0d00d0bbd000000d0d00000dd00000d00000000000000000000000000000000000000000bb0dd0bb
00080000d000000d0d000000000000d00dddd0bbb0dddd0b0dddd0bbd000000d0d000000000000d00000000000000000000000000000000000000000bb0dd0bb
00080000d000000db000000bb000000b000000bbb000000b0000000bd000000d0000000bb00000000000000000000000000000000000000000000000bb0000bb
0008000000dd0d00bdd00d0bb0dd0ddbb0dd000bbb0dd0bbb0dd000b00d0dd000dd0dd0bb0d00dd00000000000000000000000000000000000000000b00dd0bb
00000000d0dd0d0db0000d0bb0dd000bb0000d0bbb0000bbb0000d0bd0d0dd0db000dd0bb0d0000b0000000000000000000000000000000000000000b0dd00bb
00dddd0000dd0d00b0dd0d0bb0dd0d0bb0dddd0bbb0dd0bbb0dddd0b00d0dd00b0d0dd0bb0d0dd0b000000000000000000000000d0d0d0d0ddddddddd0d0d0d0
00d00d00b0dd0d0bb0dd0d0bb0dd0d0bb0dddd0bbb0dd0bbbb0ddd0bb0d0dd0bb0d0dd0bb0d0dd0b0000000000000000000000000d0ddddddddddddddddd0d0d
00d00d00b0dd0d0bb0dd0d0bb0dd0d0bb0ddd0bbbb0dd0bbbb0dddd0b0d0dd0bb0d0dd0bb0d0dd0b000000000000000000000000d0ddddddddddddddddddddd0
ddd00dddb0dd0d0bb0dd0d0bb0dd0d0bb0ddd0bbbb0dd0bbb000ddd0b0d0dd0bb0d0dd0bb0d0dd0b0000000000000000000000000ddddddddddddddddddddddd
0d0000d0b0dd0d0bb0dd0d0bb0dd0d0b0dddd0dbbb0dd0bb0dd0ddd0b0d0dd0bb0d0dd0bb0d0dd0b000000000000000000000000ddddddddddddddddddddddd0
00d00d00b0dd0d0bb0dd0d0dd0dd0d0bdddd00dbbb0dd0bb0dd0dd00b0d0dd0bb0d0dd0dd0d0dd0b0000000000000000000000000ddddddddddddddddddddd0d
000dd000b000000bb00000dddd00000bd000000bbb00000b000000ddb000000bb0000dd00dd0000b000000000000000000000000d0d0ddddddddddddddddd0d0
000000000dd00dd0bbdd0dd00ddd0dbb0ddd0dddbb0dddd0ddd0ddd00dd00dd00dd000000000ddd00000000000000000000000000d0d0d0ddddddddd0d0d0d0d
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
00000000000099999999000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099999999000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999999999900000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999999999900000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999999000000000000000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999999000000000000000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000009900000000000000000000000000009900990099999900990000009900000000999900990099007777770077777700999900000000
00000000000000000000009900000000000000000000000000009900990099999900990000009900000000999900990099007777770077777700999900000000
00000000000000000000999999000000000000000000000000009900990099009900990000009900000099009900990099007700000000007700990099000000
00000000000000000000999999000000000000000000000000009900990099009900990000009900000099009900990099007700000000007700990099000000
00000000000000000000999999000000000000000000000000009999990099999900990000009900000099009900990099007777000000777700990099000000
00000000000000000000999999000000000000000000000000009999990099999900990000009900000099009900990099007777000000777700990099000000
00000000000000000000009999000000000000000000000000009900990099009900990000009900000099009900999999007700000000007700990099000000
00000000000000000000009999000000000000000000000000009900990099009900990000009900000099009900999999007700000000007700990099000000
00000000000000000000000000000000000000000000000000009900990099009900999999009999990099990000999999007777770077777700990099000000
00000000000000000000000000000000000000000000000000009900990099009900999999009999990099990000999999007777770077777700990099000000
00000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000990000000000000000000000000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000990000000000000000000000000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009900990000990000990000999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009900990000990000990000999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000990000990000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000990000990000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000077777700777777007777770000777700007777000000000000777700777777007777770077777700777777000000000000000000
00000000000000000000000077777700777777007777770000777700007777000000000000777700777777007777770077777700777777000000000000000000
00000000000000000000000077007700770077007777000077000000770000000000000077000000007700007700770077007700007700000000000000000000
00000000000000000000000077007700770077007777000077000000770000000000000077000000007700007700770077007700007700000000000000000000
00000000000000000000000077777700777700007700000000007700000077000000000000007700007700007777770077770000007700000000000000000000
00000000000000000000000077777700777700007700000000007700000077000000000000007700007700007777770077770000007700000000000000000000
00000000000000000000000077000000770077007777770077770000777700000000000077770000007700007700770077007700007700000000000000000000
00000000000000000000000077000000770077007777770077770000777700000000000077770000007700007700770077007700007700000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808000000000000000000000000000000000010000000000000000008080000000000100000000000000008000000001010000000000
0101010101010100000000000000000000000000010101010101010000000001010101010000010001000000000100010101010000000101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010100000000010101
__map__
0000000000000000000000000000000000000000000000000000008a8a8a8a8a8a8a8a8a8a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000103132333410008a8a8aa48a8a8a8a8a8a8a8aa58a8a8a
0000000000000000000000000000000000000000000000000000008a8a8a948485958a8a8a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102122232410008a8a8aa48a8a8a8a8a8a8a8aa58a8a8a
000000000000000000000000000000000000000000000000008a008a94848a46478a85958a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012130000001011121314100000888aa48a8ab85a5a5ab98aa58a8a8a
000000000000000000000000000000000000000000000000008a00848aa9aa56578a8a8a850000008a000000000000000000000000008a00000000000000000000000000008a00000000000000000000000000000000000000000000000000000000000002030000001001020304100000888aa48a7d9c4142439c8aa58a8a8a
000000000000000000000000000000008a00000000008a00008a00b7b3b365b3b35859b3b600000000000000008a00000000008a00000000000000008a00000000008a000000000000008a0000000000008a00000000008a0000000000000000008a00002737008a001005253516100000888ab4b3b39c5152539cb3b58a8a8a
000000000000000000000000000000000000000000000000009484a1a1a1a1a1a16869a1a1859500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030158a062636000098999aa1a1a1616263a1a1a185958a
00000000000000000000000000000000000000000000000084a1a1b8a8a8a1a1a1a1a1a1a1a1a185000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008a078a8a8a8a178a84a1a1a1a1a1a1a1a1a1a1a1a1a1a185
000000000000000000000000000000000000000000000000a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008a8a8a8a8a8a8a8aa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
888888080808080808080808080808080808088888888a8a8888888a8a8a8a8a8a8a8a8a8a8888888888888a8a8a8a8a8a8a8a8a8a8888888888888a8a8a8a8a8a8a8a8a8a8888888888888a8a8a8a8a8a8a8a8a8a8888888888888aa9aa8a8a8a8a8a8a8a8a8a8aa9aa8a8a8a8a8a00008a8a8a8a8a8a8a8a8a8a8a8a888888
888888080808080808080808080808080808088888888a8a8888888a8a8a8a8a8a8a8a8a8a8888888888888a717238398a3a723b8a8888888888888a46478a0a0b8a46478a8888888888888a8a8a8a8a8a8a8a8a8a8888888888888a8a8a8a0909098a8a0909098a8a0909098a8a0909098a8a8a717238388a4464458a888888
888888080808a40808088a6b080808a4080808888a888a8a8800888aa04ea04e8a8a8a8a8a8888888800888a198a8a8a8a8a8a8a8a8888888800888a5657b31a1bb356578a8888888800888a4e4e4e4e8a8a8a8a8a8888888800889d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9d9a8a198aa9aa20548a558a888888
888888080808a40808085b8a080808a4080808888a888a8a8800888a8a5e8a5e8a0d0e0f6a8888888800888a8a4464458a8a8a8a8a885d888800888a8a8a666766672d2e2f8888888800888a5e5e5e5e8a6a8a8a8a8888888800888a8a8a8a414243a9aa4142438a8a414243a9aa4142438a8a8a8a8a8a8a8a548a558a888888
888888080808b40808080808080808b4080808888a888a8a8800888ab36eb36e8a5152537a8888888800888a8a548a558a8a8a8a8a886d888800888a8a8a761f1d773d3e3f8888888800888a6e6e6e6e8a7a2d2e2f888888880088b3b3b3b3515253b3b3515253b3b3515253b3b3515253b3b3b3b3b3b3b3b354b355b3888888
889080a1a1a1a1a1a1a16b6ba1a1a1a1a1a1a181a0888a8a88a282a3a3a3a3a3a3616263a383938888a282a3a3a3a3a3a3a3a3a3a383938888a282a3a3a3a3a3a3a3a3a3a383938888a282a3a3a3a3a3a3a33d3e3f83938888a080a1a1a1a1616263a1a1616263a1a1616263a1a1616263a1a1a1a1a1a1a1a1a1a1a1a1819188
80a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1818a8a82a3a3a3a3a3a3a3a3a3a3a3a3a3a38382a3a3a3a3a3a3a3a3a3a3a3a3a3a38382a3a3a3a3a3fdfefeffa3a3a3a3a38382a3a3a3a3a3a3a3a3a3a3a3a3a3a38380a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a181
8989898989898989898989898989898ab6a7898989898a8aa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
8a8a8a080808080808088a8a8a8a8a8ab6a70808088888888888888a8a8a8a8a8a8a8a8a8a8888888a8a8aa48a8a8a8ab6a78989898a8a8a888888898989898989898989898888888a8a8a8a8a8aa48aa58a8a8a000000008a8a8a008a8a8a008a8a8a008a8a8a0000000000000000008a8a8aa9aa8a8a8aa9aa8a8a8a888888
8a8a8a080808080808088a8a8aadadb6a7080808088888888888888a8a46478a8a46478a8a8888888a8a8aa48a8a8ab6a7898989898a8a8a888888894647898989894647898888888a8a8a8a8a8a4040408a8a8a8a8a8a8a8a8a8a00008a8a008a8a8a00008a8a0000000000000000008a8a8aa4098a098a8a098a098a888888
8a888a08088a088a08088a8ab6a708080808a408088800888800888a8a56578a8a56578a8a8888888a8a8aa48a8ab6a789898989898a8a8a888a888b56578b8b8b8b56578b888a888a8a8a8a888a4040408a8a8a8a8a8a8a8a008a00008a8a008a008a00008a8a0000000000000000008a888a9d9d9d9d9d9d9d9d9d9d888a88
8a888a08088a085b08088ab6a760608a6060a460608800888800888a6a8a8a8a8a8a8a58598888888a8a8aa48ab6a78989898989898a8a8a888a8866676667666766676667888a5d8a8a8a8a888a4040408a8a8a8a8a8a8a8a008a00008a00008a008a00008a000000000000000000008a888a6a8a8a508a8a8a8a8a74888a88
8a888a08088a0808089686869770708c7070b47070880088880088b37ab32d2e2e2fb368698888888a8a8a968686978989898989898a8a8a888a8876777677767776777677888a6d8a8a8a8a888ab4b3b58a8a8a8a008a8a8a008a00008a8a008a008a00008a8a0000000000000000008a888a7ab3b36060606060b374888a88
8a98999aa1a1a16ba1a1a1a1a1a1a1a1a1a1a1a1a181a08888a282a3a3a33d3e3e3fa379798393888a9484a1a1a1a1a1a1a1a1a1a185958a88a080a1a1a1a1a1a1a1a1a1a181a0888a8a8a8a98999a9aa185958a8a8a008a8a00000000008a8a8a00000000008a8a00000000000000008a98999aa1a17070707070a1a181a088
84a1a1a1a1a1a1a1a1a1a1a1b8a8a8a8b9a1a1a1a1a1a18182a3a3a3a3a3a3a3a3a3a3a3a3a3a38384a1a1a1a148494a4b4ca1a1a1a1a18580a1a1a1a1a14a4b4ca149a14948a1818a8a8a84a1a1a1a14a4b4c858a8a8a8a000000000000008a000000000000008a000000000000000084a1a1a1a1a1a1a1a1a1a1a1a1a1a181
a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a18a8aa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a18a8a8aa1a1a1a1a1a1a1a1a18a8a8a8a000000000000000000000000000000000000000000000000a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
8a8a6c5c5a5a5a5a5a8c5a5a5a5a8c5a5a5a5a5a8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a8a8a8a6c8a5c8a8a8a6c8a8a5c88098809880988889b8809880988098809
8a6c8a8a5a6565655a9c5a8a4e5a9c5a6565655a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a6c8a8a8a8a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a6c8a8a6c8a8a6c8a8a5c8a8a880988098809888a4e8809880988098809
7c7c7c7c5a6565655a9c5a8a5e5a9c5a6565655a7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c9b88889b8888888a5e8888888888888888
a3a3a3a35a5a5a5a5a9c5a8a6e5a9c5a5a5a5a5aa3a3a3a3a3a3292a2a2a2ba3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3292a2a2a2ba3a3ab9b88888888888a6e9bab9b8888889b88
a3a3a3a3a3a3a3a3a3ac96868697aca3a3a3a3a3a3a3a3a3a3a3a328a328a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a328a328a3a3a3a3a3a3a3a3a396868697a3a3a3a3a3a3a3
bbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbabababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababcbbbcbbbcbbbcbbbcbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbbbcbb
a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a19a9a9a9a9aa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a19a9a9a9a9a494a4b4c4849a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1
__sfx__
011a0000310552a0552a055310552a0552a055310552a055320552a055310552a0552a055310552a0552a055310552a055320552a055310552a0552a055310552a0552a055310552a055320552a055310552a055
011a00002a055310552a0552a055310552a055320552a0553005529055290553005529055290553005529055310552905530055290552905530055290552905530055290553105529055310552a0552a05531055
011a00002a0552a055310552a055320552a055310552a0552a055310552a0552a055310552a055320552a05530055290552905530055290552905530055290553105529055300552905529055300552905529055
011a0000300552905531055290552f05528055280552f05528055280552f0552805530055280552f05528055280552f05528055280552f0552805530055280552e05527055270552e05527055270552e05527055
011a00002f055270552e05527055270552e05527055270552e055270552f055270552f05528055280552f05528055280552f0552805530055280552f05528055280552f05528055280552f055280553005528055
011a00002e05527055270552e05527055270552e055270552f055270552e05527055270552e05527055270552e055270552f055270552a05523055230552a05523055230552a055230552b055230552a05523055
011a0000230552a05523055230552a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a055
011a000023055230552a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a0552305523055
011a0000000000000000000000000000000000000000000000000000000000000000320052a005310052a0052a005310052a0052a005310052a005320052a005310552a0552a055310552a0552a055310552a055
011a0000320052a005310052a0052a005310052a0052a005310052a005320052a005310552a0552a055310552a0552a055310552a055320552a055310552a0552a055310552a0552a055310552a055320552a055
011a0000310552a0552a055310552a0552a055310552a055320552a055310552a0552a055310552a0552a055310552a055320552a055300552905529055300552905529055300552905531055290553005529055
011a00002905530055290552905530055290553105529055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00002a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a05523055230552a055230552b055230552a05523055230552a05523055230552a05523055
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b043000000b04300000
010d00043853538535385353853538505385053850538505385053850538505385053850538505385053850538505385053850538505385053850538505385053850538505385053850538505385053850538505
011a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a0000064200641106410064100b4000b4000b4000b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a00001742017411174101741017400174001740017400174001740017400174001740017400174001740017400174001740017400174001740017400174000000000000000000000000000000000000000000
011a00000b4400b4310b4210b4110b4100b4100247002470024600245102441024310242102411024100241004470044700446104451044410443104421044110441004410064700647006461064510644106431
011a00001744017431174211741117410174101747017470174611745117441174311742117411174101741017470174701746117451174411743117421174111741017410174701747017461174511744117431
011a0000024600245102441024310242102411024100241004470044700446104451044410443104421044110441004410064700647006461064510644106431064210641106410064100b4700b4700b4610b451
011a00001746017451174411743117421174111741017410174701747017461174511744117431174211741117410174101747017470174611745117441174311742117411174101741017470174701746117451
011a000003470034700346103451034410343103421034110341003410000000000000000000000000000000000000000000000000000b4700b4700b4610b4510b4410b4310b4210b4110b4100b4100247002470
011a00000040000400004000040000400004000040000400124001240012400124001240012400124001240012400124001540015400124701247012460124511244112431124211241112410124101547015470
011a00001546015451154411543115421154111541015410164701647016460164511644116431164211641116410164100010000100001000010000100001000010000100001000010012470124701246012451
011a00001244012431124211241112410124101547015470154611545115441154311542115411154101541016470164701646016451164411643116421164111641016410000000000000000000000000000000
011a00001240012400124001240010470104701046110451104411043110421104111041010410104701047010461104511044110431104211041110410104101447014470144611445114441144311442114411
011a00001441014410144100000000000000000000000000000000000000000000001047010470104611045110441104311042110411104101041010470104701046110451104411043110421104111041010410
011a00001447014470144611445114441144311442114411144101441000400004000040000400004000040000400004000040000400174701747017461174511744117431174211741117410174101747017470
011a00000341003410034100000000000000000000000000000000000000000000000447004470044600445104441044310442104411044100441007470074700746107451074410743107421074110741007410
011a00000000000000000000000004470044700446004451044410443104421044110441004410074700747007461074510744107431074210741107410074100347003470034610345103441034310342103411
011a00000637006370063610635106341063310632106311063110631106301063010630006300063000630006300063000630006300063000630006300063000630006300063000630006300063010630006300
011a00001217012170121611215112141121311212112111121111211112101121010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
011a00000030000300003000030000300003000030000300063000630006300063000630006300063000630006300063000630006300063700637006360063510634106331063210631106310063100637006370
011a00000636006351063410633106321063110631006310054700547005460054510544105431054210541105410054100640006400064000640006400064000640006400064000640006370063700636006351
011a00000634006331063210631106310063100637006370063610635106341063310632106311063100631005470054700546005451054410543105421054110541005410000000000000000000000000000000
010a00002a2302a2212a2012a2002a2302a2212a201242002a2302a2212a2012a2002a2302a2212a201242002a2302a2212a2012a2002a2302a2212a201242002a2302a2212a2012a2002a2302a2212a20124200
010a00200647006471064010640006400004001240012400064001240012400124001240006400064000640006470064000647006401004000040006400064000040006400064000040000400004000040000400
010a00201207012071120011200006000000001200012000060001200012000120001200006000060001200012070120001207012001000000000006000060000000006000060000000000000000000000000000
010e10203407237072360723607236062360623606236052360523605236042360423603236032360223602236012360123601236012360123601236012360123601236012360123601236012360123601236012
010e10203601236012360123601236012360123601236012360123601236012360123601236012360123601236012360123601236012360123601236012360123601236012360123601236012360123600136002
012b00000b5000b5000b5000b5000e5000e5000e5000e50006570065710657106561065510653106511065001257012551125311251115570155511553115511165701655116531165110f5700f5510f5310f511
012b00002602500000260252600026025000002602500000260250000026025000002602500000260250000026025000002602500000260250000026025000002502500000250250000025025000002502500000
012b00001f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251e0251d0251e0251d0251e0251d0251e0251d025
012b00002602500000260250000026025000002602500000260250000026025000002602500000260250000026025000002602500000260250000026025000002502500000250250000025025000002502500000
012b00001f0251e0251f0251e0251f0251e0251f0251e0251e0251d0251e0251d0251e0251d0251e0251d0251d0251c0251d0251c0251d0251c0251d0251c0251c0251b0251c0251b0251c0251b0251c0251b025
012b00002602500000260250000026025000002602500000250250000025025000002502500000250250000024025000002402500000240250000024025000002302500000230250000023025000002302500000
012b00001d0251c0251d0251c0251d0251c0251d0251c0251c0251b0251c0251b0251c0251b0251c0251b02518025170251802517025180251702518025170251702516025170251602517025160251702516025
012b0000125001250012500125001550015500155001550000500005000050000500005000050000500005001257012551125311251115570155511553115511165701655116531165110f5700f5510f5310f511
012b00001257012551125311251115570155511553115511165701655116531165110f5700f5510f5310f5111057010551105311051113570135511353113511145701455114531145110d5700d5510d5310d511
012b0000240250000024025000002402500000240250000023025000002302500000230250000023025000001f025000001f025000001f025000001f025000001e025000001e025000001e025000001e02500000
012b00001057010551105311051113570135511353113511145701455114531145110d5700d5510d5310d5110b5700b5510b5310b5110e5700e5510e5310e5110f5700f5510f5310f51108570085510853108511
012b0000180251702518025170251802517025180251702517025160251702516025170251602517025160251f0251e0251f0251e0001f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e025
012b00001f025000001f025000001f025000001f025000001e025000001e025000001e025000001e0250000026025000002602500000260250000026025000002602500000260250000026025000002602500000
012b00000b5700b5510b5310b5110e5700e5510e5310e5110f5700f5510f5310f511085700855108531085110b5000b5000b5000b5000e5000e5000e5000e5000657006571065710656106551065310651106500
012b00001f0251e0251f0251e0001f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251f0251e0251e0251d0251e0251d0251e0251d0251e0251d025
013c00002b00132021320213202132021300212f0212d0212b02132021320213202132021300212f0112d0112b0012b00032000320003200032000300002f0002d0002b000320003200000000000000000000000
__music__
01 001e1528
00 011f1529
00 0220152a
00 03211525
00 04221524
00 0523151d
00 061c151b
00 071a1519
02 0c181517
00 41424344
00 48424344
00 49424344
00 4a424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 32333777
01 34353878
00 36393a78
00 3b3c3d78
02 3e313078
02 26272627
00 2e424344
02 2f424344
00 41424344
00 41424344
00 2c2d4344
00 2c2d4344
00 2c2d4344
00 2c2d4344
03 2c2d2b44
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

