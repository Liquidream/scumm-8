pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- adv-jam-2018
-- paul nicholas


-- debugging
-- show_debuginfo = false
-- show_collision = false
-- show_pathfinding = true
-- show_perfinfo = false
-- d = printh
enable_mouse = true
enable_diag_squeeze = true	-- allow squeeze through diag gap?


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
 ui_cursorspr = 96  -- default cursor sprite
 ui_uparrowspr = 80 -- default up arrow sprite
 ui_dnarrowspr = 112-- default up arrow sprite
 -- default cols to use when animating cursor
 ui_cursor_cols = {7,12,13,13,12,7}
end
-- initial ui setup
reset_ui()

-- 
-- room & object definitions
-- 

obj_alien_hand = {		
   data = [[
    name=alien hand
    state=state_here
    x=46
    y=52
    z=1
    w=1
    h=1
    state_here=62
    use_pos=pos_infront
    use_dir=face_back
    use_with=true
   ]],   
   verbs = {
					lookat = function(me)
       say_line("it looks like a severed alien hand...:ugh!")
					end,
     pickup = function(me)
      pickup_obj(me)
      dset(27,1)
     end,
   }
  }

-- [ crash site ]
 -- objects
  obj_crash_door_map = {		
   data = [[
    name=path
    state=state_open
    x=0
    y=34
    z=1
    w=1
    h=3
    classes={class_door}
    use_pos=pos_center
    use_dir=face_left
   ]],
   init = function(me)
    me.target_door = obj_map_door_crash
   end
  }

  obj_ship = {		
   data = [[
    name=crashed ship
    x=72
    y=40
    w=5
    h=3
   ]],
   scripts = {
    view_my_engine = function()
     change_room(rm_ship_engine,1)
    end
   },
   verbs = {
    lookat = function(me)
     obj_ship.scripts.view_my_engine()
     --say_line("my ship needs to be repaired:the energy crystal has shattered:without it, i have no way to get home!")
    end,
    walkto = function(me)
     obj_ship.scripts.view_my_engine()
    end,
   }
  }


  obj_engine_cover = {		
   data = [[
    name = engine cover
    state = state_closed
    x=76
    y=12
    z=1
    w=2
    h=4
    use_with=true
    classes={class_pickupable}
    use_pos = pos_infront
    use_dir = face_back
   ]],
   draw = function(me)
    -- engine cover
    -- in inventory?
    if me.owner == selected_actor then
     spr(15,me.x,me.y+16,1,1)

    elseif me.in_room == rm_bens_ship_inside then
     spr(43,me.x,me.y+16,2,2)
    else
				 set_trans_col(3, true)
				 map(32,0,40,24,6,6)
    end
   end,
   verbs = {
					lookat = function(me)
						say_line("this engine cover is intact:it would be perfect to fix my ship")
					end,
					pickup = function(me)
						pickup_obj(me)
      dset(25,1)
					end,
     use = function(me, noun2)
						if noun2 == obj_engine then
							put_at(me, 52, 8, rm_ship_engine)
       main_actor.engine_cover_replaced = true -- not same as fixed ship, just cover! 
       dset(23,1) 
       say_line("that's better!")
       -- check to see if we've fixed the ships
       rm_ship_engine.scripts.check_engine()
						end
					end
   }
  }


 rm_crash = {
  data = [[
   map = {16,8,31,15}
   min_autoscale = 0
   autoscale_zoom = 0.75
   col_replace = {11,0}
  ]],
  objects = {
   obj_crash_door_map,
   obj_ship,
  },
  enter = function(me)
   -- switch gfx
  load_gfx_page(1)

   if not me.done_intro then
    -- don't do this again
    me.done_intro = true
    -- set which actor the player controls by default
    selected_actor = main_actor
    -- init actor
    put_at(selected_actor, 60, 60, rm_crash)
    -- make camera follow player
    -- (setting now, will be re-instated after cutscene)
    camera_follow(selected_actor)
   end
   
   if main_actor.fixed_ship then
     me.col_replace = nil
    end
  end,
  exit = function(me)
   -- pause clock while not in room
   --stop_script(me.scripts.anim_clock)
  end,
  scripts = {
  }
 }



-- [ ship's engine "room" ]
 -- objects
  obj_engine_door_back = {		
   data = [[
    name = crash site
    state = state_open
    x=0
    y=0
    z=-10
    w=16
    h=16
    classes = {class_door}
    use_pos = pos_center
    use_dir = face_front
   ]],
   verbs = {
    walkto = function(me)
     put_at(selected_actor,86,61,rm_crash)
     change_room(rm_crash,1)
    end,
   }
  }

 obj_engine = {		
   data = [[
    name = engine
    state = state_closed
    x=46
    y=14
    z=1
    w=5
    h=5
    use_pos = pos_infront
    use_dir = face_back
   ]],   
   verbs = {
					lookat = function(me)
      if main_actor.fixed_ship then
       say_line("the engine is ready for take-off!")
      else
						 say_line("it's what's left of my ship's engine")
      end
					end,
   }
  }

	rm_ship_engine = {
			data = [[
				map = {16,0,31,7}
			]],
			objects = {
    obj_engine_door_back,
    obj_engine,
  --  obj_engine_cover,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(3)

    -- check to see if we've fixed the ships
    me.scripts.check_engine()

    -- initial cutscene?
    if not main_actor.engine_cover_replaced 
     and obj_engine_cover.owner != selected_actor
     and obj_crystal.owner != selected_actor then
     cutscene(
      3, -- no verbs & no follow, 
      function()
       break_time(100)
       say_line("my ship needs to be repaired:the engine cover is missing...:and the energy crystal has shattered...:without them, i have no way to get home!")
       change_room(rm_crash, 1)
      end	
     ) -- cutscene
    end
   end,
			exit = function(me)
				-- todo: anything here?
			end,
   scripts= {
				check_engine = function()
     if main_actor.engine_cover_replaced
      and main_actor.crystal_replaced then
       -- fixed ship!!
       main_actor.fixed_ship = true
       dset(20,1)
       say_line("yes, my ship is fixed!")
     end
    end
   }
		}





-- [ map "room" ]
 -- objects
  obj_map_door_crash = {		
    data = [[
     name=my spaceship
     state=state_open
     x=50
     y=40
     z=1
     w=1
     h=1
     classes={class_door}
     use_pos=pos_left
     use_dir=face_right
    ]],
    init = function(me)
     me.target_door = obj_crash_door_map
    end
   }

  obj_map_door_graves = {		
    data = [[
     name=graves
     state=state_open
     x=26
     y=-2
     z=1
     w=2
     h=2
     classes={class_door}
     use_pos={29,12}
     use_dir=face_back
    ]],
    init = function(me)
     me.target_door = obj_graves_door_map
    end
   }
  
  obj_map_door_cave = {		
    data = [[
     name=crystal cave
     state=state_open
     x=3
     y=52
     z=1
     w=2
     h=1
     classes={class_door}
     use_pos={15,60}
     use_dir=face_back
    ]],
    init = function(me)
     me.target_door = obj_cave_door_map
    end
   }

  obj_map_signal = {		
   data = [[
    name=signal generator
    state=state_open
    x=104
    y=9
    z=1
    w=2
    h=1
    use_pos={111,16}
    use_dir=face_back
   ]],
   draw = function(me)
    if not main_actor.disabled_signal then
     line(112,9+16,112,0+16, flr(rnd(2))==0 and 8 or 9)
    end
   end,
   verbs = {
					walkto = function(me)
						if not main_actor.disabled_signal then
       dset(10,2) -- signal generator
       load("_game-pt2")
      else
       say_line("i'd better not, it's crawling with aliens!")
      end
					end,
				}
   }
  
  obj_map_alienbase = {		
    data = [[
     name=alien base
     state=state_open
     x=106
     y=26
     z=1
     w=3
     h=3
     classes={class_door}
     use_pos={108,34}
     use_dir=face_back
    ]],
   verbs = {
					walkto = function(me)
						--printh("load disk 2!!!")
      --set flag for entered/exited door
      dset(10,3) -- alien base (outside)
      load("_game-pt2")
					end,
				}
   }

  obj_map_bridge = {		
    data = [[
     name=bridge
     state=state_open
     x=61
     y=8
     z=1
     w=1
     h=1
     classes={class_untouchable}
     use_pos=pos_center
     use_dir=face_back
     alerting=false
    ]]
   }

	rm_map = {
			data = [[
				map = {32,8,47,15}
			]],
			objects = {
    obj_map_door_crash,
    obj_map_door_graves,
    obj_map_door_cave,
    obj_map_bridge,
    obj_map_signal,
    obj_map_alienbase,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(5)
    selected_actor.scale=0.2
    selected_actor.walk_speed=2
    -- bg script
    start_script(me.scripts.bridge_guard, true) 
			end,
			exit = function(me)
				selected_actor.scale=nil
    selected_actor.walk_speed=0.6
    stop_script(me.scripts.bridge_guard)
			end,
   scripts = {	  -- scripts that are at room-level
				bridge_guard = function()
					while true do
      --printh("prox:"..proximity(main_actor, obj_map_bridge))
						if proximity(main_actor, obj_map_bridge) <=6 
      and not main_actor.fixed_ship
      and not obj_map_bridge.alerting then
							-- warn player to fix ship first
       obj_map_bridge.alerting = true
       cutscene(2,
								function()
         stop_actor(selected_actor)
         say_line("i think i should fix my ship before i go exploring!")
         walk_to(selected_actor,42,11)
         obj_map_bridge.alerting = false
        end
							)
						end
						break_time(10)
					end
				end,
			},
		}


-- [ graveyard ]
 -- objects
  obj_graves_door_map = {		
   data = [[
    name = path
    state = state_open
    x=0
    y=34
    z=1
    w=1
    h=4
    classes = {class_door}
    use_pos = pos_center
    use_dir = face_left
   ]],
   init = function(me)  
    me.target_door = obj_map_door_graves
   end
  }

  obj_graves_door_bencrash = {		
   data = [[
    name = large crashed ship
    state = state_open
    x=16
    y=4
    z=1
    w=3
    h=5
    classes = {class_door}
    use_pos = {30,38}
    use_dir = face_back
   ]],
   init = function(me)  
    me.target_door = obj_benship_door_bencrash
   end
  }

  obj_graves = {		
   data = [[
    name=unmarked graves
    x=56
    y=36
    w=4
    h=3
    use_dir=face_right
   ]],
   verbs = {
    lookat = function(me)
     say_line("two graves...:with space helmets for headstones:i wonder who they were?")
    end
   }
  }

	rm_graves = {
			data = [[
				map = {32,8,47,15}
    autoscale_zoom = 0.75
			]],
			objects = {
				obj_graves_door_map,
    obj_graves_door_bencrash,
    obj_graves,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(2)
			end,
			exit = function(me)
				-- todo: anything here?
			end,
		}


-- [ inside ben's ship ]
 -- objects
  obj_benship_door_bencrash = {		
   data = [[
    name = outside
    state = state_open
    x=58
    y=14
    z=1
    w=1
    h=4
    classes = {class_door}
    use_pos = pos_right
    use_dir = face_left
   ]],
   init = function(me)  
    me.target_door = obj_graves_door_bencrash
   end
  }

  obj_holobase = {		
   data = [[
    name=hologram viewer
    state=state_here
    x=104
    y=48
    z=1
    w=2
    h=1
    state_here=217
    use_pos=pos_left
    use_dir=face_right
   ]],
   verbs = {
					use = function(me)
      rm_bens_ship_inside.scripts.play_holo()
     end,
     lookat = function(me)
      rm_bens_ship_inside.scripts.play_holo()
     end
				}
  }

  obj_holo_overlay = {		
   data = [[
    name=
    state=state_here
    x=107
    y=32
    z=-1
    w=1
    h=1
    classes = {class_untouchable}
   ]],
   draw = function(me)
    for x=1,8 do
     local y=rnd(32)+30
     line(me.x,y,me.x+9,y,0) 
    end
   end,
  }


	rm_bens_ship_inside = {
			data = [[
				map = {48,8,67,15}
			]],
			objects = {
    obj_benship_door_bencrash,
    obj_holobase,
    obj_holo_overlay,
    obj_engine_cover,
    obj_alien_hand,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(4)
			end,
			exit = function(me)
    -- check for ben cutscene
    if main_actor.played_holo 
     and main_actor.ben_cutscene == 0 then
     --printh("doing cutscene!")
    
     cutscene(
						3, -- no verbs & no follow, 
						function()
        dset(21,0.5)
       --fades(1,1)	-- fade out
       change_room(rm_void)
       --fades(1,-1)
       print_line("meanwhile...",64,45,7,1,true)
       --fades(1,1)	-- fade out
       load("_game-pt2")
      end
					) -- end cutscene
    end -- if not cutscene
			end,
   scripts = {
    play_holo = function()
     cutscene(
      3, -- no verbs & no follow, 
      function()
       main_actor.played_holo = true

       say_line(selected_actor, "lets see what this does...",false,100)

       ben_holo_actor.lighting=0
       put_at(ben_holo_actor, 112,46, rm_bens_ship_inside)
       obj_holo_overlay.z=50
       selected_actor = ben_holo_actor

       while ben_holo_actor.lighting<1 do
        ben_holo_actor.lighting+=.01
        break_time(1)
       end
       break_time(25)
       
       say_line("this is the log of captain ben octavi:our ship crashed and i am the sole survivor")
       break_time(40)
       say_line("i am in great danger:something is trying to break through the ship's hull:i don't know what it wants, but-:oh no!:it's here...")
       
       
       while ben_holo_actor.lighting>0 do
        ben_holo_actor.lighting-=.02
        break_time(1)
       end

       selected_actor = main_actor
       put_at(ben_holo_actor, 0,0, rm_void)
       obj_holo_overlay.z=-1
      end
     ) -- end cutscene
    end
   }
		}


-- [ cave ]
 -- objects
  obj_cave_door_map = {		
   data = [[
    name=path
    state=state_open
    x=16
    y=8
    z=1
    w=15
    h=5
    classes={class_door}
    use_pos={45,40}
    use_dir=face_back
   ]],
   init = function(me)  
    me.target_door = obj_map_door_cave
   end
  }

  obj_crystal = {		
   data = [[
    name=crystal
    state=state_open
    x=15
    y=48
    z=1
    w=1
    h=1
    state_open=31
    use_with=true
    use_dir=face_left
   ]],
   draw = function(me)
    -- in inventory?
    pal()
    set_trans_col(14, true)   
    if me.in_room == rm_cave 
       or me.owner == selected_actor then
     spr(31,me.x,me.y+16,1,1)
    else
				 map(38,0,56,39,2,2)
    end
   end,
   verbs = {
    lookat = function(me)
     say_line("an energy crystal:just what i need to power my spaceship!")
    end,
    pickup = function(me)
     say_line("*ugh*:*ughhhh*:it won't even budge!")
    end,
    use = function(me, noun2)
     if noun2 == obj_engine then
      me.z=-2
      put_at(me, 0, 0, rm_ship_engine)
      main_actor.crystal_replaced = true
      dset(24,1)
      say_line("now we have power!")

      -- check to see if we've fixed the ships
      rm_ship_engine.scripts.check_engine()
     end
    end
   }
  }

   obj_boulder = {		
   data = [[
    name=boulder
    state=state_here
    x=78
    y=52
    z=1
    w=1
    h=1
    state_here=46
    trans_col=3
    use_pos=pos_infront
    use_dir=face_back
    use_with=true
   ]],   
   verbs = {
					lookat = function(me)
       say_line("it looks heavy...;and indestructible")
					end,
     pickup = function(me)
      pickup_obj(me)
      dset(29,1)
     end,
   }
  }

 
 rm_cave = {
			data = [[
				map = {32,8,47,15}
    autoscale_zoom = 0.75
			]],
			objects = {
				obj_cave_door_map,
    obj_crystal,
    obj_boulder,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(6)
    -- crystal gone?
    if obj_crystal.in_room != me then
     me.col_replace = {3,1}
    end
    -- auto walk
				start_script(function()
     --printh("autowalk")
     break_time(1)
     --put_at(selected_actor, 52,40)
					walk_to(selected_actor, 70, 58)
				end)
			end,
			exit = function(me)
				-- todo: anything here?
			end,
		}
  
--
-- [ "the void" (room) ]
-- a place to put objects/actors when not in a room	
	-- objects
  obj_lasertool = {		
   data = [[
    name = laser tool
    state = state_open
    x=0
    y=0
    w=1
    h=1
    state_open=47
    trans_col=0
    use_with=true
    classes = {class_pickupable}
   ]],
   verbs = {
    lookat = function(me)
     say_line("it's my trusty laser tool:cuts through anything!")
    end,
    -- pickup = function(me)
    --  pickup_obj(me)
    -- end,
    use = function(me, noun2)
     if noun2 == obj_crystal then
      cutscene(2,
       function()
        say_line("let's get that crystal...:*dink*")
        pickup_obj(obj_crystal, selected_actor)
        dset(26,1)
        rm_cave.col_replace = {3,1}
        say_line("there we go!")
       end)
     end
    end
   }
  }

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
   obj_lasertool,
		},
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_void,
 rm_map,
	rm_crash,
 rm_ship_engine,
 rm_graves,
 rm_bens_ship_inside,
 rm_ben_engine,
 rm_cave,
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
			idle = { 65, 69, 71, 69 }
			talk = { 90, 91, 92, 91 }
			walk_anim_side = { 68, 69, 70, 69 }
			walk_anim_front = { 66, 65, 67, 65 }
			walk_anim_back = { 72, 71, 73, 71 }
			col = 7
			trans_col = 11
			walk_speed = 0.6
			frame_delay = 5
			classes = {class_actor}
			face_dir = face_front
		]],
		-- sprites for directions (front, left, back, right) - note: right=left-flipped
		inventory = {
			--obj_switch_tent
		},
		verbs = {
			use = function(me)
				selected_actor = me
				camera_follow(me)
			end
		}
	}


 ben_holo_actor = {
   data = [[
    name = hologram
    x = 0
    y = 0
    w = 1
    h = 4
    idle = { 10, 10, 10, 10 }
    talk = { 27, 27, 27, 27 }
    col = 12
    trans_col = 3
    walk_speed = 0.4
    frame_delay = 5
    classes = {class_actor}
    face_dir = face_front
    use_pos = {98,50}
    scale=1
   ]],
   in_room = rm_void,
   inventory = {
   },
   verbs = {
    lookat = function(me)
     --say_line("")
    end
   }
  }

-- 
-- active actors list
-- 
actors = {
	main_actor,
	ben_holo_actor,
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()
 cartdata("pn_code8")

 -- data slots (0..63)
 -- 00) selected_player (unused for now)
 -- 01) player inventory #1
 -- 02) player inventory #2
 -- ...
 -- 10) entered-door (for switching rooms across carts)
 --  > 0 = unset
 --  > 1 = bridge (unused)
 --  > 2 = signal generator
 --  > 3 = alien base (outside)
 --  > ...
 -- 11) selected_player (unused for now)
 -- 12) 
 -- > ...
 -- (game state flags)
 -- 20) fixed ship (1/0)
 -- 21) cutscene of ben in cell (1/0)
 -- 22) signal disabled
 -- 23) engine cover repaired
 -- 24) new crystals installed
 -- 25) picked-up engine cover
 -- 26) picked-up crystals
 -- 27) picked-up alien hand
 -- 28) released ben
 -- 29) picked-up boulder

 -- ####################################################################
 -- test!!!
 -- ####################################################################
 -- dset(20,0) -- 
 -- dset(25,1) -- 
 --  dset(26,1) -- 
 -- ####################################################################
 
-- for d=10,30 do
--  printh("dget("..d..")="..dget(d))
-- end

 -- permanent inventory?
 pickup_obj(obj_lasertool, main_actor)


 -- game states
 if (dget(20)==1) main_actor.fixed_ship = true
 main_actor.ben_cutscene = dget(21)
 if (dget(22)==1) main_actor.disabled_signal = true
 if (dget(23)==1) main_actor.engine_cover_replaced = true -- not same as fixed ship, just cover!
 if (dget(24)==1) main_actor.crystal_replaced = true
 if (dget(25)==1 and not main_actor.engine_cover_replaced) pickup_obj(obj_engine_cover, main_actor)
 if (dget(26)==1 and not main_actor.crystal_replaced) pickup_obj(obj_crystal, main_actor)
 -- ben released + alien hand states
 if (dget(28)==1) then
  main_actor.released_ben = true
  put_at(obj_alien_hand, 0,0, rm_void)
 end
 if (dget(27)==1 and not main_actor.released_ben) pickup_obj(obj_alien_hand, main_actor)
 if (dget(29)==1 and not main_actor.disabled_signal) pickup_obj(obj_boulder, main_actor)


 -- repair state
 if (main_actor.engine_cover_replaced) put_at(obj_engine_cover, 0, 0, rm_ship_engine)
 if (main_actor.crystal_replaced) put_at(obj_crystal, 0, 0, rm_ship_engine)

 -- ####################################################################
 -- test!!!
 -- ####################################################################
 --dset(10,0)
 --main_actor.fixed_ship = true
 --pickup_obj(obj_engine_cover, main_actor)
 --pickup_obj(obj_crystal, main_actor)
 -- ####################################################################

-- still controlling player
  selected_actor = main_actor
  camera_follow(selected_actor)

 music(1)

 -- check for first/direct load (e.g. not from disk_2)
 if dget(10)==0 then
  -- #################################
  -- test
  -- main_actor.fixed_ship = true
  --  pickup_obj(obj_boulder, main_actor)
  --dset(29,1)
   --dset(20,1)
  -- main_actor.played_holo=true
  -- put_at(selected_actor,50,50,rm_bens_ship_inside)
  -- change_room(rm_bens_ship_inside,1)

  -- start of game
  change_room(rm_crash,1)


 elseif dget(10)==1 then
  --printh("back from cut 1")
  come_out_door(obj_benship_door_bencrash, obj_graves_door_bencrash, 1)

 else
  
  -- check starting room/door
  if dget(10)==2 then
   -- crash
   --printh("crash")
   come_out_door(obj_map_door_crash, obj_crash_door_map)
   
  elseif dget(10)==3 then
   -- graves
   --printh("graves")
   come_out_door(obj_map_door_graves, obj_graves_door_map)
  
  elseif dget(10)==7 then
   -- cave
   --printh("cave")
   come_out_door(obj_map_door_cave, obj_cave_door_map)
  end
  
 end -- if not cutscene


 -- ####################################################################
 -- test!!!
 -- ####################################################################

 -- ####################################################################


 --change_room(rm_crash,1) -- iris fade

 -- for any other room
 -- selected_actor = main_actor
 -- put_at(selected_actor, 48, 46, rm_map)
 -- camera_follow(selected_actor)
 
 -- change_room(rm_map) -- iris fade
end



















-- 
-- px8 related
--

req_gfx_num = -1
curr_gfx_num = -1

function load_gfx_page(gfx_num)
   req_gfx_num = gfx_num
end


-- decompression

function remap(i,w,h)
 local sx=flr((i/64)%(w/8))
 local sy=flr((i/64)/(w/8))
 local x=(i%8)
 local y=flr(flr(i%64)/8)
 return (sx*8+x)+(sy*8+y)*w
end

function decomp(src, px,py,xget,xset)

 local pn={}
 src-=1 
 local bit=256
 local b=0
 
 function getval(bits)
  val=0
  for i=0,bits-1 do

   --get next bit from stream
   if (bit==256) then
    bit=1
    src+=1
    byte=peek(src)
   end
   if band(byte,bit)>0 then
    val+=shl(1,i)
   end
   bit*=2
   
  end
  return val
 end
 
 -- read header
 
 local w = getval(8)
 local h = getval(8)
 local cbits = getval(3)
 local rmp = getval(1) 
 local maxci = getval(8)
 local bpp = getval(3)+1
 local clist={}
 for i=0,maxci do
  clist[i]=getval(bpp)
 end
 
 -- spans
 
 local i = 0
 local span = 0
 
 while (i < w*h) do

  -- span length 
  local bl = 1
  while getval(1)==0 do
   bl += 1 end
  
  local minv=shl(1,bl-1)
  if (bl==1) minv=0
  
  local len=
   getval(max(1,bl-1))+minv+1

  for j=0,len-1 do
  
   local i1 = i
   
   if (rmp==1) i1=remap(i,w,h)
   
   x = px+(i1)%w
   y = py+flr(i1/w)
   
   -- predict colour
   
   local t=xget(x+0,y-1)/16
   local l=xget(x-1,y+0)*16
   if (y==py) t=0
   if (x==px) l=0
   
   pc=pn[t+l] or pn[t] or pn[l]
   
   if (span%2 == 0) then
    -- raw literal
    
    local index=0
    
    repeat
     v=getval(cbits)
     index += v
    until (v < shl(1,cbits)-1)
    
    local pindex=999
    for i=0,maxci do
     if (pc==clist[i]) pindex=i
    end
    
    if (pindex <= index) index+=1
    
    col = clist[index]
    
    -- move to front
    for i=index,1,-1 do
     clist[i]=clist[i-1]
    end
    clist[0] = col
    
   else
    -- predicted

    col = pc
    
   end
   
   xset(x,y,col)
      
   -- adjust predictions
   
   pn[t]=col
   pn[l]=col
   pn[t+l]=col
   
   i += 1
  end
  span += 1
  
 end
 

end


function load_gfx(index,x,y)

 local offset=0x0000 -- screen memory
 for i=0,index-1 do
  offset += peek(offset+0) + peek(offset+1)*256 + 2
 end

 decomp(offset+2,x,y,pget,pset)
end









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
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cd) cam_x=ce(cd) cf=nil cg=nil end function camera_follow(ch) stop_script(ci) cg=ch cf=nil ci=function() while cg do if cg.in_room==room_curr then
cam_x=ce(cg) end yield() end end start_script(ci,true) if cg.in_room!=room_curr then
change_room(cg.in_room,1) end end function camera_pan_to(cd) cf=ce(cd) cg=nil ci=function() while(true) do if cam_x==cf then
cf=nil return elseif cf>cam_x then cam_x+=0.5 else cam_x-=0.5 end yield() end end start_script(ci,true) end function wait_for_camera() while script_running(ci) do yield() end end function cutscene(type,cj,ck) cl={cm=type,cn=cocreate(cj),co=ck,cp=cg} add(cq,cl) cr=cl break_time() end function dialog_set(cs) for msg in all(cs) do dialog_add(msg) end end function dialog_add(msg) if not ct then ct={cu={},cv=false} end
cw=cx(msg,32) cy=cz(cw) da={num=#ct.cu+1,msg=msg,cw=cw,db=cy} add(ct.cu,da) end function dialog_start(col,dc) ct.col=col ct.dc=dc ct.cv=true selected_sentence=nil end function dialog_hide() ct.cv=false end function dialog_clear() ct.cu={} selected_sentence=nil end function dialog_end() ct=nil end function get_use_pos(bu) local dd=bu.use_pos local x=bu.x local y=bu.y if type(dd)=="table"then
x=dd[1] y=dd[2] elseif dd=="pos_left"then if bu.de then
x-=(bu.w*8+4) y+=1 else x-=2 y+=((bu.h*8)-2) end elseif dd=="pos_right"then x+=(bu.w*8) y+=((bu.h*8)-2) elseif dd=="pos_above"then x+=((bu.w*8)/2)-4 y-=2 elseif dd=="pos_center"then x+=((bu.w*8)/2) y+=((bu.h*8)/2)-4 elseif dd=="pos_infront"or dd==nil then x+=((bu.w*8)/2)-4 y+=(bu.h*8)+2 end return{x=x,y=y} end function do_anim(ch,df,dg) dh={"face_front","face_left","face_back","face_right"} if df=="anim_face"then
if type(dg)=="table"then
di=atan2(ch.x-dg.x,dg.y-ch.y) dj=93*(3.1415/180) di=dj-di dk=di*360 dk=dk%360 if dk<0 then dk+=360 end
dg=4-flr(dk/90) dg=dh[dg] end face_dir=dl[ch.face_dir] dg=dl[dg] while face_dir!=dg do if face_dir<dg then
face_dir+=1 else face_dir-=1 end ch.face_dir=dh[face_dir] ch.flip=(ch.face_dir=="face_left") break_time(10) end end end function open_door(dm,dn) if dm.state=="state_open"then
say_line"it's already open"else dm.state="state_open"if dn then dn.state="state_open"end
end end function close_door(dm,dn) if dm.state=="state_closed"then
say_line"it's already closed"else dm.state="state_closed"if dn then dn.state="state_closed"end
end end function come_out_door(dp,dq,dr) if dq==nil then
ds("target door does not exist") return end if dp.state=="state_open"then
dt=dq.in_room if dt!=room_curr then
change_room(dt,dr) end local du=get_use_pos(dq) put_at(selected_actor,du.x,du.y,dt) dv={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if dq.use_dir then
dw=dv[dq.use_dir] else dw=1 end selected_actor.face_dir=dw selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(dx,bd) if bd==1 then
dy=0 else dy=50 end while true do dy+=bd*2 if dy>50
or dy<0 then return end if dx==1 then
dz=min(dy,32) end yield() end end function change_room(dt,dx) if dt==nil then
ds("room does not exist") return end stop_script(ea) if dx and room_curr then
fades(dx,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end eb={} ec() room_curr=dt if not cg
or cg.in_room!=room_curr then cam_x=0 end stop_talking() if dx then
ea=function() fades(dx,-1) end start_script(ea,true) else dz=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(bz,ed) if not ed
or not ed.verbs then return false end if type(bz)=="table"then
if ed.verbs[bz[1]] then return true end
else if ed.verbs[bz] then return true end
end return false end function pickup_obj(bu,ch) ch=ch or selected_actor add(ch.bo,bu) bu.owner=ch del(bu.in_room.objects,bu) end function start_script(ee,ef,eg,eh) local cn=cocreate(ee) local scripts=eb if ef then
scripts=ei end add(scripts,{ee,cn,eg,eh}) end function script_running(ee) for ej in all({eb,ei}) do for ek,el in pairs(ej) do if el[1]==ee then
return el end end end return false end function stop_script(ee) el=script_running(ee) if el then
del(eb,el) del(ei,el) end end function break_time(em) em=em or 1 for x=1,em do yield() end end function wait_for_message() while en!=nil do yield() end end function say_line(ch,msg,eo,ep) if type(ch)=="string"then
msg=ch ch=selected_actor end eq=ch.y-(ch.h)*8+4 er=ch print_line(msg,ch.x,eq,ch.col,1,eo,ep) end function stop_talking() en,er=nil,nil end function print_line(msg,x,y,col,es,eo,ep) local col=col or 7 local es=es or 0 if es==1 then
et=min(x-cam_x,127-(x-cam_x)) else et=127-(x-cam_x) end local eu=max(flr(et/2),16) local ev=""for ew=1,#msg do local ex=sub(msg,ew,ew) if ex==":"then
ev=sub(msg,ew+1) msg=sub(msg,1,ew-1) break end end local cw=cx(msg,eu) local cy=cz(cw) ey=x-cam_x if es==1 then
ey-=((cy*4)/2) end ey=max(2,ey) eq=max(18,y) ey=min(ey,127-(cy*4)-1) en={ez=cw,x=ey,y=eq,col=col,es=es,fa=ep or(#msg)*8,db=cy,eo=eo} if#ev>0 then
fb=er wait_for_message() er=fb print_line(ev,x,y,col,es,eo) end wait_for_message() end function put_at(bu,x,y,fc) if fc then
if not has_flag(bu.classes,"class_actor") then
if bu.in_room then del(bu.in_room.objects,bu) end
add(fc.objects,bu) bu.owner=nil end bu.in_room=fc end bu.x,bu.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=mid(room_curr.min_autoscale or 0.15,ch.y/40,1) fm*=(room_curr.autoscale_zoom or 1) local fn=ch.walk_speed*(ch.scale or fm) local fo=(fl[1]-room_curr.map[1])*8+4 local fp=(fl[2]-room_curr.map[2])*8+4 local fq=sqrt((fo-ch.x)^2+(fp-ch.y)^2) local fr=fn*(fo-ch.x)/fq local fs=fn*(fp-ch.y)/fq if ch.fd==0 then
return end if fq>5 then
ch.flip=(fr<0) if abs(fr)<fn/2 then
if fs>0 then
ch.ft=ch.walk_anim_front ch.face_dir="face_front"else ch.ft=ch.walk_anim_back ch.face_dir="face_back"end else ch.ft=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end for ew=0,fq/fn do ch.x+=fr ch.y+=fs yield() end end end ch.fd=2 end function wait_for_actor(ch) ch=ch or selected_actor while ch.fd!=2 do yield() end end function proximity(ca,cb) if ca.in_room==cb.in_room then
local fq=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fq else return 1000 end end fu=16 cam_x,cf,ci,br=0,nil,nil,0 fv,fw,fx,fy=63.5,63.5,0,1 fz={{spr=ui_uparrowspr,x=75,y=fu+60},{spr=ui_dnarrowspr,x=75,y=fu+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function ga(bu) local gb={} for ek,bw in pairs(bu) do add(gb,ek) end return gb end function get_verb(bu) local bz={} local gb=ga(bu[1]) add(bz,gb[1]) add(bz,bu[1][gb[1]]) add(bz,bu.text) return bz end function ec() gc=get_verb(verb_default) gd,ge,o,gf,gg=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gh={} dz,dz=0,0 gi=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gj() start_script(startup_script,true) end function _update60() gk() end function _draw() gl() end function gk() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gm(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gi=3 end cr=nil end end else gm(eb) end gn() go() gp,gq=1.5-rnd(3),1.5-rnd(3) gp=flr(gp*br) gq=flr(gq*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gl() rectfill(0,0,127,127,0) camera(cam_x+gp,0+gq) clip(0+dz-gp,fu+dz-gq,128-dz*2-gp,64-dz*2) gr() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fu-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fu-8,8) end if show_debuginfo then
print("x: "..flr(fv+cam_x).." y:"..fw-fu,80,fu-8,8) end gs() if ct
and ct.cv then gt() gu() return end if gi>0 then
gi-=1 return end if not cr then
gv() end if(not cr
or cr.cm==2) and gi==0 then gw() else end if not cr then
gu() end end function gx() if stat(34)>0 then
if not gy then
gy=true end else gy=false end end function gn() if en and not gy then
if(btnp(4) or stat(34)==1) then
en.fa=0 gy=true return end end if cr then
if(btnp(5) or stat(34)==2)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end gx() return end if btn(0) then fv-=1 end
if btn(1) then fv+=1 end
if btn(2) then fw-=1 end
if btn(3) then fw+=1 end
if btnp(4) then gz(1) end
if btnp(5) then gz(2) end
if enable_mouse then
ha,hb=stat(32)-1,stat(33)-1 if ha!=hc then fv=ha end
if hb!=hd then fw=hb end
if stat(34)>0 and not gy then
gz(stat(34)) end hc=ha hd=hb gx() end fv=mid(0,fv,127) fw=mid(0,fw,127) end function gz(he) local hf=gc if not selected_actor then
return end if ct and ct.cv then
if hg then
selected_sentence=hg end return end if hh then
gc=get_verb(hh) elseif hi then if he==1 then
if(gc[2]=="use"or gc[2]=="give")
and gd then ge=hi else gd=hi end elseif hj then gc=get_verb(hj) gd=hi ga(gd) gv() end elseif hk then if hk==fz[1] then
if selected_actor.hl>0 then
selected_actor.hl-=1 end else if selected_actor.hl+2<flr(#selected_actor.bo/4) then
selected_actor.hl+=1 end end return end if gd!=nil
then if gc[2]=="use"or gc[2]=="give"then
if ge then
elseif gd.use_with and gd.owner==selected_actor then return end end gf=true selected_actor.cn=cocreate(function() if(not gd.owner
and(not has_flag(gd.classes,"class_actor") or gc[2]!="use")) or ge then hm=ge or gd hn=get_use_pos(hm) walk_to(selected_actor,hn.x,hn.y) if selected_actor.fd!=2 then return end
use_dir=hm if hm.use_dir then use_dir=hm.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gc,gd) then
start_script(gd.verbs[gc[1]],false,gd,ge) else if has_flag(gd.classes,"class_door") then
if gc[2]=="walkto"then
come_out_door(gd,gd.target_door) elseif gc[2]=="open"then open_door(gd,gd.target_door) elseif gc[2]=="close"then close_door(gd,gd.target_door) end else by(gc[2],gd,ge) end end ec() end) coresume(selected_actor.cn) elseif fw>fu and fw<fu+64 then gf=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fv+cam_x,fw-fu) ec() end) coresume(selected_actor.cn) end end function go() if not room_curr then
return end hh,hj,hi,hg,hk=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if ho(ej) then
hg=ej end end return end hp() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hq(bu,bu.w*8,bu.h*8,cam_x,hr) else bu.hs=nil end if ho(bu) then
if not hi
or(not bu.z and hi.z<0) or(bu.z and hi.z and bu.z>hi.z) then hi=bu end end ht(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hq(ch,ch.w*8,ch.h*8,cam_x,hr) ht(ch) if ho(ch)
and ch!=selected_actor then hi=ch end end end if selected_actor then
for bw in all(verbs) do if ho(bw) then
hh=bw end end for hu in all(fz) do if ho(hu) then
hk=hu end end for ek,bu in pairs(selected_actor.bo) do if ho(bu) then
hi=bu if gc[2]=="pickup"and hi.owner then
gc=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if gc==nil then
gc=get_verb(verb_default) end if hi then
hj=bt(hi) end end end function hp() gh={} for x=-64,64 do gh[x]={} end end function ht(bu) eq=-1 if bu.hv then
eq=bu.y else eq=bu.y+(bu.h*8) end hw=flr(eq) if bu.z then
hw=bu.z end add(gh[hw],bu) end function gr() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fu,8,0) return end rectfill(0,fu,127,fu+64,room_curr.hx or 0) for z=-64,64 do if z==0 then
hy(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fu,room_curr.hz,room_curr.ia) pal() else hw=gh[z] for bu in all(hw) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then ib(bu) end else if bu.in_room==room_curr then
ic(bu) end end id(bu) end end end end function hy(bu) if bu.col_replace then
ie=bu.col_replace pal(ie[1],ie[2]) end if bu.lighting then
ig(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ig(bu.in_room.lighting) end end function ib(bu) hy(bu) if bu.draw then
bu.draw(bu) else ih=1 if bu.repeat_x then ih=bu.repeat_x end
for h=0,ih-1 do local ii=0 if bu.states then
ii=bu.states[bu.state] else ii=bu[bu.state] end ij(ii,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x,bu.scale) end end pal() end function ic(ch) ik=dl[ch.face_dir] if ch.fd==1
and ch.ft then ch.il+=1 if ch.il>ch.frame_delay then
ch.il=1 ch.im+=1 if ch.im>#ch.ft then ch.im=1 end
end io=ch.ft[ch.im] else io=ch.idle[ik] end hy(ch) local fm=mid(room_curr.min_autoscale or 0,(ch.y+12)/64,1) fm*=(room_curr.autoscale_zoom or 1) local scale=ch.scale or fm local ip=(8*ch.h) local iq=(8*ch.w) local ir=ip-(ip*scale) local is=iq-(iq*scale) ij(io,ch.de+flr(is/2),ch.hv+ir,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if er
and er==ch and er.talk then if ch.it<7 then
io=ch.talk[ik] ij(io,ch.de+flr(is/2),ch.hv+flr(8*scale)+ir,1,1,ch.trans_col,ch.flip,false,scale) end ch.it+=1 if ch.it>14 then ch.it=1 end
end pal() end function gv() iu=""iv=verb_maincol iw=gc[2] if gc then
iu=gc[3] end if gd then
iu=iu.." "..gd.name if iw=="use"then
iu=iu.." with"elseif iw=="give"then iu=iu.." to"end end if ge then
iu=iu.." "..ge.name elseif hi and hi.name!=""and(not gd or(gd!=hi)) and(not hi.owner or iw!=get_verb(verb_default)[2]) then iu=iu.." "..hi.name end gg=iu if gf then
iu=gg iv=verb_hovcol end print(ix(iu),iy(iu),fu+66,iv) end function gs() if en then
iz=0 for ja in all(en.ez) do jb=0 if en.es==1 then
jb=((en.db*4)-(#ja*4))/2 end outline_text(ja,en.x+jb,en.y+iz,en.col,0,en.eo) iz+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gw() ey,eq,jc=0,75,0 for bw in all(verbs) do jd=verb_maincol if hj
and bw==hj then jd=verb_defcol end if bw==hh then jd=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fu+1,verb_shadcol) print(bx[3],ey,eq+fu,jd) bw.x=ey bw.y=eq hq(bw,#bx[3]*4,5,0,0) id(bw) if#bx[3]>jc then jc=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(jc+1.0)*4 jc=0 end end if selected_actor then
ey,eq=86,76 je=selected_actor.hl*4 jf=min(je+8,#selected_actor.bo) for jg=1,8 do rectfill(ey-1,fu+eq-1,ey+8,fu+eq+8,verb_shadcol) bu=selected_actor.bo[je+jg] if bu then
bu.x,bu.y=ey,eq ib(bu) hq(bu,bu.w*8,bu.h*8,0,0) id(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end jg+=1 end for ew=1,2 do jh=fz[ew] if hk==jh then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ij(jh.spr,jh.x,jh.y,1,1,0) hq(jh,8,7,0,0) id(jh) pal() end end end function gt() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hq(ej,ej.db*4,#ej.cw*5,0,0) jd=ct.col if ej==hg then jd=ct.dc end
for ja in all(ej.cw) do print(ix(ja),ey,eq+fu,jd) eq+=5 end id(ej) eq+=2 end end end function gu() col=ui_cursor_cols[fy] pal(7,col) spr(ui_cursorspr,fv-4,fw-3,1,1,0) pal() fx+=1 if fx>7 then
fx=1 fy+=1 if fy>#ui_cursor_cols then fy=1 end
end end function ij(ji,x,y,w,h,jj,flip_x,jk,scale) set_trans_col(jj,true) local jl=8*(ji%16) local jm=8*flr(ji/16) local jn=8*w local jo=8*h local jp=scale or 1 local jq=jn*jp local jr=jo*jp sspr(jl,jm,jn,jo,x,fu+y,jq,jr,flip_x,jk) end function set_trans_col(jj,bq) palt(0,false) palt(jj,true) if jj and jj>0 then
palt(0,false) end end function gj() for fc in all(rooms) do js(fc) if(#fc.map>2) then
fc.hz=fc.map[3]-fc.map[1]+1 fc.ia=fc.map[4]-fc.map[2]+1 else fc.hz=16 fc.ia=8 end for bu in all(fc.objects) do js(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for jt,ch in pairs(actors) do js(ch) ch.fd=2 ch.il=1 ch.it=1 ch.im=1 ch.bo={} ch.hl=0 end end function id(bu) local ju=bu.hs if show_collision
and ju then rect(ju.x,ju.y,ju.jv,ju.jw,8) end end function gm(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ig(jx) if jx then jx=1-jx end
local fl=flr(mid(0,jx,1)*100) local jy={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jz=1,15 do col=jz ka=(fl+(jz*1.46))/22 for ek=1,ka do col=jy[col] end pal(jz,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hz*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function kb(fg,fh) local kc=mget(fg,fh) local kd=fget(kc,0) return kd end function cx(msg,eu) local cw={} local ke=""local kf=""local ex=""local kg=function(kh) if#kf+#ke>kh then
add(cw,ke) ke=""end ke=ke..kf kf=""end for ew=1,#msg do ex=sub(msg,ew,ew) kf=kf..ex if ex==" "
or#kf>eu-1 then kg(eu) elseif#kf>eu-1 then kf=kf.."-"kg(eu) elseif ex==";"then ke=ke..sub(kf,1,#kf-1) kf=""kg(0) end end kg(eu) if ke!=""then
add(cw,ke) end return cw end function cz(cw) cy=0 for ja in all(cw) do if#ja>cy then cy=#ja end
end return cy end function has_flag(bu,ki) for be in all(bu) do if be==ki then
return true end end return false end function hq(bu,w,h,kj,kk) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.hv=y-(bu.h*8)+1 x=bu.de y=bu.hv end bu.hs={x=x,y=y+fu,jv=x+w-1,jw=y+h+fu-1,kj=kj,kk=kk} end function fk(kl,km) local kn,ko,kp,kq,kr={},{},{},nil,nil ks(kn,kl,0) ko[kt(kl)]=nil kp[kt(kl)]=0 while#kn>0 and#kn<1000 do local ku=kn[#kn] del(kn,kn[#kn]) kv=ku[1] if kt(kv)==kt(km) then
break end local kw={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kx=kv[1]+x local ky=kv[2]+y if abs(x)!=abs(y) then kz=1 else kz=1.4 end
if kx>=room_curr.map[1] and kx<=room_curr.map[1]+room_curr.hz
and ky>=room_curr.map[2] and ky<=room_curr.map[2]+room_curr.ia and kb(kx,ky) and((abs(x)!=abs(y)) or kb(kx,kv[2]) or kb(kx-x,ky) or enable_diag_squeeze) then add(kw,{kx,ky,kz}) end end end end for la in all(kw) do local lb=kt(la) local lc=kp[kt(kv)]+la[3] if not kp[lb]
or lc<kp[lb] then kp[lb]=lc local h=max(abs(km[1]-la[1]),abs(km[2]-la[2])) local ld=lc+h ks(kn,la,ld) ko[lb]=kv if not kq
or h<kq then kq=h kr=lb le=la end end end end local fj={} kv=ko[kt(km)] if kv then
add(fj,km) elseif kr then kv=ko[kr] add(fj,le) end if kv then
local lf=kt(kv) local lg=kt(kl) while lf!=lg do add(fj,kv) kv=ko[lf] lf=kt(kv) end for ew=1,#fj/2 do local lh=fj[ew] local li=#fj-(ew-1) fj[ew]=fj[li] fj[li]=lh end end return fj end function ks(lj,cd,fl) if#lj>=1 then
add(lj,{}) for ew=(#lj),2,-1 do local la=lj[ew-1] if fl<la[2] then
lj[ew]={cd,fl} return else lj[ew]=la end end lj[1]={cd,fl} else add(lj,{cd,fl}) end end function kt(lk) return((lk[1]+1)*16)+lk[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function js(bu) local cw=ll(bu.data,"\n") for ja in all(cw) do local pairs=ll(ja,"=") if#pairs==2 then
bu[pairs[1]]=lm(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function ll(ej,ln) local lo={} local je=0 local lp=0 for ew=1,#ej do local lq=sub(ej,ew,ew) if lq==ln then
add(lo,sub(ej,je,lp)) je=0 lp=0 elseif lq!=" "and lq!="\t"then lp=ew if je==0 then je=ew end
end end if je+lp>0 then
add(lo,sub(ej,je,lp)) end return lo end function lm(lr) local lt=sub(lr,1,1) local lo=nil if lr=="true"then
lo=true elseif lr=="false"then lo=false elseif lu(lt) then if lt=="-"then
lo=sub(lr,2,#lr)*-1 else lo=lr+0 end elseif lt=="{"then local lh=sub(lr,2,#lr-1) lo=ll(lh,",") lv={} for cd in all(lo) do cd=lm(cd) add(lv,cd) end lo=lv else lo=lr end return lo end function lu(ie) for a=1,13 do if ie==sub("0123456789.-+",a,a) then
return true end end end function outline_text(lw,x,y,lx,ly,eo) if not eo then lw=ix(lw) end
for lz=-1,1 do for ma=-1,1 do print(lw,x+lz,y+ma,ly) end end print(lw,x,y,lx) end function iy(ej) return 63.5-flr((#ej*4)/2) end function mb(ej) return 61 end function ho(bu) if not bu.hs
or cr then return false end hs=bu.hs if(fv+hs.kj>hs.jv or fv+hs.kj<hs.x)
or(fw>hs.jw or fw<hs.y) then return false else return true end end function ix(ej) local a=""local ja,ie,lj=false,false for ew=1,#ej do local hu=sub(ej,ew,ew) if hu=="^"then
if ie then a=a..hu end
ie=not ie elseif hu=="~"then if lj then a=a..hu end
lj,ja=not lj,not ja else if ie==ja and hu>="a"and hu<="z"then
for jz=1,26 do if hu==sub("abcdefghijklmnopqrstuvwxyz",jz,jz) then
hu=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jz,jz) break end end end a=a..hu ie,lj=false,false end end return a end















-- hijack draw method
scumm_draw = _draw

function _draw()
--function _update60() 
 -- check for gfx change
 if req_gfx_num != curr_gfx_num then
  --printh("gfx update!!!!!!")
  -- reset to compressed sprite data
  reload()
  -- decompress core gfx page to screen
  load_gfx(0,0,0)
  -- decompress requested gfx page to screen
  load_gfx(req_gfx_num,0,64)
  -- copy screen to sprite sheet
  memcpy(0x0000,0x6000,0x2000)
  -- load sprite flags
  load_spr_flags(req_gfx_num)
  -- save value
  curr_gfx_num = req_gfx_num
 end


 -- call original scumm-8 _draw()
 scumm_draw()

 -- call original game_draw()
 --gj()
 -- call original game_update()
 --gi()
end


function load_spr_flags(index)
 
 -- temp override!!!
 -- if (index==2)index=0
 -- if (index==6)index=1

 --printh("load sprite flags - index: "..index)

 local flag_target_start = 0x42ff - ((index+1) * 0x80) 

 -- for i=flag_target_start, flag_target_start+0x7f,0x1 do  
 --  printh(">sfx mem ("..i..") = "..peek(i))
 -- end

 reload(0x3080, flag_target_start, 0x80)

  -- for i=0x30ff,0x3080,-0x1 do
  --  printh(">spr mem ("..i..") = "..peek(i))
  -- end
end




__gfx__
8a3008049f0389866db2bf5471ac008e72028a5b474389e455708eb30fa7d86e86ac1c484f1df7f74aee359af868e3ca49b32fd108f78c309edc93ecaf9fb424
2ae75ae2dc568bdea02e29c45a8b7dca479bac96a098b08e7ff6ffeb1c4ff52e79a4552dff699439aac59e3a82eeff6df8239fb4acffcb5ed9a7b565b5faa546
ca4dc40bae108e7af5bf79cfb4757892ff5a8afa785e6caaf17a82891596ffbb65103c3e65daff7d88620745222effeff9ca51992adff77d5c27446bdfffe448
bb9aff6d881cff84dff25a3522209ff31b4575e4dfb365e772b7f27579ae3727155a2afba2dfffb8800021aedf2a1a12d7588884a8962ca0957baf1cfef74438
cf0974dc71dcdc5ea3555fb9e4183ef34fff75a18882cef7c9e8343dff8deb735a259afa379cb9554aa7975111c013fff0b12937c24286c35ac17a0910dff3c6
0e7fff6dffb47618cfffba2a101c4daae8407bb0447a6557428bd502a3f43a651b101d97a8ba26302a3f41755c60447aaaa2616302a9aaaa858d0886aaaa2616
b708fb00bf0030df7898f1d133183dc1587a1592af3ae54a14a02df93adfffa8dffb4216b7e7158af357adfa15512dfc19df07fd1d8ce3fbc0ddf4d96fb64558
4f3746f3cdfed7f8c8f5684df4d55edf85e5d25c6f94f7367aa3df59cffb5ff4dbacbf1bcba5a87f32ff6ce4d85f3ff9aba97f1bcba5a87f19fb1d4d49bf55ff
1cef156d2c6fa8f721a1d488f90578ee93a16ee1ee61a191f234778ee93a16ee1ee96a191f234543c5f77694fef512573952c402ec3b88c5c3c20c5a00182785
1e6a492a0d0a34effbe9efa47ffe5dd651949dfbfec4ae7ffdf7aafdfcff3bbff7affbf7f8ba6d35cdf5ae43d7bef7afeae7eefe27f7b7f7ea6ff7f7b9e6def6
7f7eaeb55ffaf37ba7dfdf35ff4dfbfcd5ad57befd7ddfe9e3a65b34e5bfe778bbfe7ee7b6df35bb9afbbf977cbf361c5f75faf7f7e71df1cdf54a6dfe75dfa6
78e9b75fbbeff6ae7afbf39be7f75535bb493424bf75f7edfeefddfbb97f77fbaf7effdfb7aa3a7a15f7dda49baefdfebaf1d8bfbddfcf5deffef63dd58adfaa
bdfbf35baae74bf9ef37befb35ff1a38e0040bffc119ef32481e45d26796e93ea25fefd78ceff77eeae86e857f2222f9806a64b3ae74eabcdbe7934fcb77a3ee
e0de937fc54fd3678cc9a75d3efd1d129bff76f5e72d8efc97a8ef8652ae4fe16f7f1d6ca74a77f1dc5ea32d7eae9af4deec5dfdcd3215f5a63f3569a65a8c7e
58beb38bc9bb4fc3a17d945a64b3ae744b4f9cfc3e2f5519a24ab34b37ee9b86bcf877554a45a09004f3e33008049d0b7bea380a4c517d000968092518eac50a
e9b47530afa604b1700c06725cde048c3e0d0c934c1a55575379845820fc2a93fc3e492ac1f1875e4cf618784a41592a68d86e54abc7270a48635868c705d1d7
86a4b96218d75d96877872e46219baa2b274aa3cabb45068e892860ca1114c129a18fa47e261015b46e7bcc454e083f0b0843f088f4d8f50898e1de30d69b743
06e1a7ae84b209beee65e346654f9f30bb5fca6b46c506b0d09606c7ef474f16d182b39e8f9206a2a9c1a0813dc92e2a16f13127a4180571c849257542c73865
cfa2f3d835e29050ab04c58b8605129a192e9e4268fa3e438826575f49f64f0da49452947111ac7d3c7ae96845f45d93d4be4c44a4beba221f9a0faf198779a2
29f386a0a250ea8a92aa50cb2066a4ba8ba092c755738b5ddac14c1035c146a02389ae1998349005a96a92a435a1c51d0e40a92b05435ac50e8f454685418255
1945a414621496850a51b3ca4f3545d10f436701fc234420212b1a65e34e0b04e550fdfa8374cefc93d3c625a37a0b0593c4827c57aa4f8374fc76106f3ceda2
704bd750ce103549357da35515183204e68d0a30fb093785a891090549290d0d492035070d9243ca1d062c24f0b09140d48a86850648d190cb87aad4066d38a4
9aa0aa8ac12afa8412b80574ffaa0912e386f5ca0cb80b3ef3eebf3fc9ce9ba25ca4aae526ff3fadbef4c6621d2e3baaa211dfe981fbfe531b65fdb8dca98003
10f4daaf7b21302dd7880424f3c4dd0daf092a1060ff97a419f5a6a4175559ea6557c9801dc9a454329c3548049859e9b41909046aa2279ac948baaa475937c9
8086e4543005f25a02358cf09f7a2549246ff11dffd36f3755eb05df9416d7e194ffb3a3eec3acd925b452605a454358cf927adfd54a34c78c5ae45505d1dd57
4bddaaba9ae8b32a88dbedf3be9eda445f9d7afc7cf3d3aeb745ade27ad75937ecdbae45d3712dc8774eebb59b9ffee6a7ba9ffe36d74afa0908034407a0b101
5880ac1b1043958efb2542011840c05f93921b331543d49c0743c20e92a558d93f9b0031ffb11d3cef35690b04caeff775ffd5acd344859bfdd75e1805aff0fe
f84cd9bb302927d210b551692541784a410fe41741a1857aef8606632943a434cecfbaba57be56941031363008049b0b7bbea845912800be1220d0eba861ca78
8c643012ce543c7108e7eee2534d2a18e58ee1d08e68430e0f350515eec946a459a493f4190588184a090bc1b18c0b02a72914c5ab88bcbea377d5968885652d
450fdaf8bf8a3273e964a500440fb0653e543c3045ed7470ccab3ca74aaae7ec551b1a3ae9a821386e011e94839044c7ce2e5c42a49272549465daa7e5942b59
b51551dc5d57c925baea6ec15a3a41c9a25f45f79fa65d5d8469b719bb3ef849bf552916dae4925e835848602c00f80d41a3430d30f20cf6a101d8d07c924206
90d08934358e0c498608bee3a3470e7f6dfcdd07325969ba37e04ce7c2537e8bf5f7392d5b25fde5ab847e8abab2016880ca9fabe9e09ca255941926794255eb
a359e4984253f8cafde6976ba9e8a52c6827260981193dde547e2f455d5e2586a0863478e0a41ec1b0c20280d09161015c30b6860668586084f0670a50f1e147
013a0d02718c5f70caef2bf745755c25840b54ff3c2aef51c5a0fc147fdd47a8f2ab8e0a78e0ba207a86ff1f0d78e0070d28dcdf3ad14fe8b306f0eab2468501
d1d147a0d1a18c15e837536186412206347025e09c388efba0f5430bb74b0f14751a15860c692ec3741a1ce094170c017025ffa83585a09dff8c8bc65aef5bac
baaaea24e92a04211ce3593f82a9cff5b97ff8e3cef78d08a24300d0baff79adfaff97e044df7fb74aabfcff73657ff86f164f7675df84f7d1b7fb8b8632daeb
e3d7f35d54ff0ffb14b2ad74b36f7dd94de4f14478bc156dfb76b02326049506ef77091255369bbe3fba7a82584492df78c16122bc7759eeea51784758d1a1c4
49ab2ea3c3ea34aa8eea54343a10bcf0e342503287a0d8305785864dd75a2b596a20b557415410358d0b00b865183c6a94249288507289a24c046890a50da09d
5121ef123df09e8401e50c96ec1f0ccea835e65aa275fb5da6d837ba75bbc3e17ac6878d0d1f4158e41219042c2749f5eea6c46bbc122cda83585a8be55351aa
7eae6aa4dd88aabeaa69c37a82c3caa0d09a243c2045f7880ec1f41221cba4964241749a8c091867eca4796047a1e8243a08528e1743d08024a1b4254482755f
82a960f1c60d122090483775d5e0d4f225d5eab6718e93d4da5541095e7e822fb58c8b51220b0c9261751845c68507a4c68c0d1a14414865380d593541ad1be0
e41b8ae8350a414816924343c20ce0092008049803bb688a1fd005f82430e9063430925418a1a1c404534c0e08524378606b00b2430320e80d8306c4106c5890
d0ea86e04e1e3430680d8685027a1851a146ac10748684048920eb6ef0b2094a18d18210558d4103604d3424345021a1a1a177718038c0842d0ca04a4930e80b
930cab492430ab7a6c3abe259a87868647d57080c3e43e0d0d0d0dc3a0d602e3e3c60c01821a18c1881a18010948684a10b5a7a6e258686864fab8687e45a0d0
d0d86e0d0d08ab78aab9e5ca47d5438f68a579be0d87a0d04a78d0866d18318b10350310b551d00be956a3a28e305a191a1a1a1a1a1e10df14db868686868545
8b20973440441c7c18b1897850a50d78d0b08b2032e04c93073438a082350ca1f92e0d186181d86cde15a06a0a61d2a1451826850510dc371aa860e61d06e0b0
ce04a0b180107541d08d60cdda08438808a205e088f820ca3470c418318d3502708d8006b08e306a28310540a60e4e10bc0910d6f181bf860718c9605d74371d
0492a12509a868d92e092034371d8bc36f35e4188f0150678414fe74d21159a8ef74ed684d4a99a9c39a51c963e4af27de94d4d88e0574abfbba5df04fe9f8bd
dfaaf778f509e20fc3a6d8e5f71d187d86840a63a151dc7a084a8f092cf0b2ce16e98db4c20bd11ae7a4ae3a7ba19b22bdccc29daab555b4bfd44664da489477
77ecebdd5d5ec22faaac4c05acf25dd1faefd74cb44a868684b3ea34544cf99a4d0b38f50c8af1fd02d58f58a4a91924f1eb066eeaeeab87868a8841d0fc5b9d
1b2e309e2c76f98f58f503b5f457429a841b309e2cf22fda2b2192a1a1e1a1a3ce18570d1c734a2a06a0c07e3c24a04797a08636111522714aeeaae8a322d192
a1e1a1ab0a53ed51c634438a5a0eefb1bcd045f2c418aaa02206d30ae0098004c78a4008049d0380922f45bbef1e0021684a0ee09a28835c40c5545c25c92aba
27a835c5c4063a7196c253d559b517a8b51b617a8f22d85a607f122b8d04935e269641a93749de40fbd5a473fd5da6770c2ed0c0f5c2c207eb04c203188885a2
21441518dcd8eb1d6471d2e14c22741a50c8e0b129242c25a8a69937945075caa221692cb85a090b4175125caa271dfaed8a44cc0d7a4d557a653b2a3aa9dbcc
415579ec9bc9e7371ddc9428da55eaee3d9e54413731446df84bbaac8aa5aac7492468d714ef1616af59df7bd4ffb779a493e4125478519f0b0f087a7454c247
1d2e58f06e1a5cb0f1c7081829b8948485554a0b159a4571b2a54a868d5cafa683d245bf711d16fd46ff6737a119bdc8d7caaa4a763bdc5ba22ffdc7f2f332db
d39e919ae15faf5d9f545787aff54eef3b7bdcadaa84ff3616519ffad7527f5d2f56775ba377ddf9ae7fc553ad8519644504b185f78684a0d0d0d84ffbf77430
2ce9303aff344daff5a3b089eff9aae4fff5c4023795a851d0d5cf84071d2e5434b870daa88af2223ce0d0b70f5ce2a730fd2a162121a5c4d092a5cdefd9a3a1
59219d85d86c51fa6655ba1d7baff75ff3dfed19bdffd4f76adbf6fb7f4fd5d89a772dcfcedfe9a93efff12e8dd7a49ad442c24a1562fef49431bf22fb1df774
eb853ad3c9bff709417e0d82ac17a0906aff79eb181fefbadd14fa2076850efff7ff798faab85155694844aff74d2dca92fb2b2cab346a262ea5e2a55c7a098f
fbd241aa98c24f2a54b84a827163061a8fdfbafdfe6b6dfbaa4e6ede1bb9d777bb75fa65bad7155ff32f6b9effd5a7377794ebf2df252ffef7fbb8f37bb7a9df
d63af9ff3ff7d3aef67966d776af77337ef676ffd3aef623bb1be860abe1c416272190c9f71b2e543440a2410fdf7a1df8cfa7f6fbb77e73c607e9bbaa33bd76
6b0e04b93a0cb0c908ba031036a30e62ffb5355da86815a222ff33325736daf835420cfef783d444e73216f1678d3c207555dfa01ddd1136e06743d4c4ba5ca1
69cdf7dce9dca7b13fbcd2b7fb59ed9add9acd88cad7ca275e90b96e6a83f49ae8cc99e6b1f2d3fa6b63dfe9e7dfad36d55af935cd3c802df7092a12f8a88042
87d6ef3ff22f7aaaeea6d343ffe32a5a27ec9fb55d6779fc8df6e556783584cd512de27f49b7589286acdb47eafe4f98c6b39857c6e4107475892ce945434307
41ea6028007702a20eef0b70a7f71d721a2a12a701119413d0458ca2022fd519412938d12a38d0d0d0b077bfcddf2fb1ea925d9c9650d5b64a1a351b64b8c351
f89490760d9a5da735b69a16e64a579cb9166e8ad7eb882840c2f82d380b6621935a82f16144552557a42416928055ca0aa0d0b1630288203309382d7f9aaae9
5b23df7b9ffecda61fd3fb33e49a5d454a471bfd6d7fdcd3292ff3b88cd75355e986e9a98c4cf265450296d927679a47e2985a952b5dade65dc4a8e456305dce
7ba52b5da6731d516537dba3796aba270250c828d1c18470c918f588035bff1beae840401017fe4930ad06e3c4a74e2058a82dacffbdba6b66ca027213cd7495
577659b8686868e3e472dd6ce2618c9251098410374100374081475771d0d0d01d94241d7ec17325437379bd9aaafd47a042ddc54343434aba424157ac173f54
37379be455df6a3500c800008008049f0b2a60bb9c56f8714d82554b0cb51813c643d424269b532158a0763c249299127e864f8fc9d2a47d55d5f1586acba225
9403bba279c1657dfbd7229d8bbf3a39e5f9c7fb9adfb3db54e76fe29b365afe7aafcf9bf924e3a096c2dc409ffbe4a29e254925b2d55ff2de4afa9e9a93d29f
d174ff7a659a35ae3b79dd7f49cebda9c0a937c575da659fa5b6fbc5723caff178511aa29c9c59b0215df55df2d835554203a03a4630111b6eab190264151a5d
ffe5373164c6d85395eaa1b5d7a415a09ca21175268875a25674ba65265b67552245e3bb94c2b26f52584ac1310a92ac92f4358485614687e41d41b1437e4928
a435e4948201fc34c0905a87a0b1292c687630120492c3a4be27a3e43e1393cfb4175559477be5117bb3dcc4ab9dd63337b9be3532caff3d9fef75d7d9e47a7b
cdc51ba3484d9d674d59255940557cf6e4121575848ef7adf75595d39b15ba1db588584a229392ae61ff1ba72f7979644edf7effcc8dc59e7e25ba9af57cd271
d7e37a0154ff93aeae5f49aa93f435a977aff7dfffa39411512d7a3c47488ff5ffb505b456ac7f1a35a4e968b87aebbf6d76759389e19fb881c34ae27faff339
ff73cf72f6fbf5d5e1fba19ef865ff037a23db2eaadc87b3e6dbcaea8a08c0e09497494ceaaef674ac5d45d090b419ef46f529a45b0d5dfdfae25b7d7b4c6d24
37fe2ba755e69eedceb9945dd31ddadc18168402f5c20b70b940234389031c9291a0d068efa69a391a9ac574aa88baaa3757269bbf45113d26fd3ee6fdc757ae
df01f7d75d77ba5f9bfe22f36dfb092ce417a0bd55eaa035884122baa94bffd9ba655abd848cb8e3eeae8418faefa8f924b67ad870c026b1036072309c948b49
25327deff0255e38bf0b036c465ba55985b261a19243d440fffa01fbfb3b433bebff9bb4777579eabb92795b7ddce7a47e0b1c47c83e8c6dea756fee809dda5b
59e9d2f2945999652e2fdcbf98479de7b577925b29d494cc5786c6ccce4bcf4bd11104486ecb7d513987c18537c68685e492543948d343ce1d9647e01d94ba65
d443a4241ce1afef7a92aa319d37b88a49bab72255aa486ea68401fb2ecb1fc588aceb7ba5c0fdbff58adfa7edbd19cec7f35b47b99cfbce5c9b549674dcf35d
eb77cdfa29edb51dfd4d064ff1aff9b1de753a71ff7185736d1fe0894e0d0d04f5c6b3dd74cff2b25a4d4d2dfddefa47626bdea2d5a72d6b136bcf37ee67a798
519ba3a4422759d0fdde93d71b11f8088046644908808fb4a5b99ce55b6af55d2c37e493ec92d8b7d54a49cedb5deb5fb99cc59222b672bbbbebbbde4577aabe
4f49e42fffdff79dcad2f8a7df84b69fff777fab7eabef633b92d5562a829d27568aa9aa098f735befd965adfde6bef47396777719d9d8c3667ee939ab5f6dfa
5159a8aa82f41ce4ab8c1641a2e4190aea37b21901d493d82f41e9a5ce12d69de555a998c6e4c76b6928a6cbd177d71125092a3a9e42ba5f4f8abec9bffbaff1
9eff0649af4d4acdfe79eddf6d77e625f4dff13d1eaa8e2b0d09cbe279250c8714a2a50a3bfcf1bfe7575afd294d5efdc9bff76dbffef22ffe7f7e5fcdfa65b9
57644c789062228e55bad403f47540590925f9e488f7d6e821e422d49862db5d6ab2a6277e8e4927bb8584a0b0b144434479be83d2bbf71dbb65552fbbd45522
a2b05892c598c4499844984113aef7effd6aaaff75d5afff5554edb7fcfdbcce6d777cbcb4d4eda72dd64411bbfeee469f79c455e2afc9808c8a31f825d54a21
e492da2a8820e17a4390521a1f3e7a14ecc0a8512b54a0d92559c151f827634924275c4a06483a98bcefb9b25ffacdb8f547b744be21796db25b474a7bbaba5c
9c37faef9e17ff3d778d7198bbe45772dd9a4fbff1b924ccfbc44bf77dffd7be3a7ba5fd5dbe77df4c82f557ff7aa74aaa21bb462215bee71bbcf5775a26a442
85bff4a3dbc5c89f793f9c29effeff5dc52de44cff5c941fa573b76397147b2f6d31d1cf3789b2575a21262043115a6e69d849492f0a685e8f5719870b3c6c93
2b5c92759e435c44ff22f4ffbadabbbe3dfffeae66feccee5d55d6a9261e15b4fe1240c961de1de1de1b44802fae53f91da018211fa29a4baada493584639eeb
25a7bbc2b884a5d55525b28a05bca2654c5c5226c29c1d4f05ccf7dfbeedff77bea40ac08ef4451a9a2491e46cf75555afdd5e6a17a46749983a2259ed299e43
9693e654d29eeba739e63dffb7166e9ff7ed9b4fcb8f6f977e9a9eec4fffbfffebfddf4dbab46aacf7bea44fb6cfdae5d2efecce6d675286ee7a2567031cb5d7
1223f75f52ebfeefcab457b2fbe69b1d168d93fe6ee737695377daeddcb9eb9535d5755da44acdd802a23f2fe7bfe52596b1167b764eb332d5a49774682d4786
435e435e42013e8c55af55aaa21a1d9c98354121907a1294e3a921105220ac9358db853b1ac2c3e163c346890f0b8407a1af2f5d2190a45da6aaa4a458561a42
1295a45d96ca0e3d0993ac3234b27299aeab22929005588ae632d2d9b6dfb6195e945baec1b0cec9b592f07245eebff78cf04effecaee01f76d3a06a743038db
e37212d7fda45587fb43f515f850d5eeae4fdfddf2edfbdfc9f5d455190d09cf79a417151a822bac655c24c92e22592229f3bed296b39a905249871d4441b945
d4729555241615492549361b2e95257577aefebdffdaeaebc77d7caaaab6baf2dc6d5b4edded8bddfaea65bcfd7f44f9dfa311fbd42fc5559c51b035ed752ee7
fd2757aad5aadf67a65a42f9b22c4725f6731bddd7fdbafa15afdc971984862341a7d542521848f04f16121561c3ec358d011420bc145a41a9290d435a0b1292
72141ca07a43a0401890d86a00a45008049e0380e69b92a43f75c008186858905495837a83d850630eb163c203243434666ad6e7a3a75b183438c0d416302018
4a839aa35ab00e5d7002d800a4d0210ec605fea8dea05ba444b4424ec178684884115b868840b36382aed5d67be9e83982d5ba5d2f4b966629da031a14f0d0d0
b83430eb0a3035eb88b5524a1167ce5a39a6ba0a7ef62237355dcd6bc5eebfd1af5c41c688288ee22f794370a4973b0a04e4b85901f731250158f49242fc9483
46420228f12249587acfa255be35be9e4186927e96c9486e1450ad0b051c3fc97c18f156185c948e5718665e8e35ab49e4503ec9342a4494896addce5cd94a01
1b1a0b97a435eb65aaa65b156e3fbc4332dc254edcdf5ab9c725effeb9cd8f572587ae5e2226eb5f25d8826a497d92dc94050814a4924343d88005a9c0a83812
db1ad3a9de45c3d26f2648669c3a46386c5d9a61e860bfca02acfdc29f5be67193bdaaa9a45279479af7dbfad75adb217081759f6df7e84b4155beff72dff13a
fffdcbdff93cee0fe8a609244faff3659b5ae98da6dbe9675ffb5ff9eab84555fe7b4ffd98efee13fb59aabf5a1485ff4f0b70192bf2aa9ce5ffdf75fee2fe6c
a7f56ff78a4df743cccf925f79a8a7def7dccedef7fb7be3dd99ef6bf1fdff0be86663bff6ba542b6effd796fefdf9a557a564d9f5e8f769a9cf7ff7fdef9eff
df75fafd5f7a7ae74a51dffdf7967ffb4ffb350b4efc1a37f49ef789c6422df221f5eff3fb79e7ffdf7dbddf375565d327657e7ff36fdf71b767e2efc13f1beb
242c35851ba28dfda253b284e83f543c3434389a68d0d0d0b0b0c983b2e25abedff75a259e5db9eca11105ec92d793d3ac3b6ffb59ddeb95bd22bb7f4467f673
9335d2acbb9d75adc570328814d9df66bcb5abd594f9f6ddc5755f259e22bbac2aace6f6e72af7ffeffefb4df7ae2e3f77cdf7fffeef6aee95709a242eefddf2
f3ef78b2d9afa8dd72a925a822d7eb425fdd790dfaae412558459cf19bed35edb2f9e77f4a5e35950615d3fca3af42fda4e5236ed3eeedd92db55a603abe761f
aa407ecdb4e144a42424cc9fecadb5ed7fed4e93eebccfa6ff5cbd3fbfbf3224d492541e124ef23e44e6298f222faf496697aa8698a93ede8482abb4ed4de84f
fb34e0b09834796a112ef511aaff78512dffeda21bab89429f261a93c2c2069f2610a13c20eb8ff22620e32bf944c9c4554a773bdb3b5dbbd7a3962fd7597b64
4c4dbaaaf2236a2d3d4da2b68bff132ea15f4fcfccdffe3b192d51d084838a87c3e41a5784b885f44ad9b9394b94967be93aefaed5703b793c488856d4242827
6201e352f06687f4c8fdbbb9df67e39e95ab631ca80695dfda7b51dea8f5f1baf6d446be62f63ea85f6aaa941bea90398562d7bf9e417658294a9afbac9e7325
54442014783cebf7dfcc31faaaaa9a2dbac58808307a22a8b5745dbc924258405f37c1e5670cf12282430fc047493b18d00980d0853d496a4fff70e79482c2d1
954979ba793d188b077e801f76efa3a4f4b3113793068229e827496c301f1da2bffbab654c639d475e4562db22da4923d8a0355e86864e48daaa3b3290d9ec71
aeb1b5e9643d49350b3c3e937656ea3e147a41743585071e1c486e43585ec1640827496e4178666cf7966224701257ade2d5440d9688ca51e0c7385021218414
40530c130e320414ff3ce0c772fc725a2ab0c3ca454ea6a958949c35c10d50c5fb0b129f2634450d6551d8288393559e49ba303445955190b0b28abe12df5543
a2d09161cf06800505172121a83a96848cc97414d0dc18a15f1afff71be5dfbafc5dbd4edbf6e5df77f69e66b1d592e409cb43edd6064552492012c7ee693d42
ea82f01184a9408feb39b5a3bb5dee69498cd4d920251cd570000000000000000000000000000000000000000000000000000000000000000000000000000000
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
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777777777777777777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777777777777777777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774444444477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774ffffff477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f44449477777777cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb
777777774f44449477777777bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc
777777774f4444947777777799999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
777777774f4444947777777722222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
777777774f4499947777777744444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
777777774f99444477777777fff444449fff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fffffff4fff
77777777444444447777777744444044494949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
77777777444444447777777744404000044949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
7777777749a44444777777774404ffff004949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774994444477777777440f9ff9f04949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774444444477777777440f5ff5f04949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774444fff477777777444ffffff44949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774fff449477777777444ff44ff44949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f444494777777774446ffff644949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f444494777777774449fddf444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f4444947777777744494ff4444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944
777777774f44449477777777999dc55cd99949999999499999994999999949999999499999994999999949999999499999994999999949999999499999994999
777777774f4444947777777744dcc55ccd4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
777777774f4444947777772222c1c66c1c2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
777777774f4449947777222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774f4994447722222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774f9444442222222222c1c55c1c22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
77777777444444222222222222d1cddc1d22222222222222222222ccc2ccc2222222222222222222222222222222222222222222222222222222222222222222
77777777444422222222222222fe1111ef22222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777774422222222222222222f1111f222222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
777777772222222222222222222211212222222222222222222222222c2222222222222222222222222222222222222222222222222222222222222222222222
77777722222222222222222222221121222222222222222222222222222222223333333333333333333333333333333333333333333333333333333322222222
77772222222222222222222222221121222222222222222222222222222233333333333333333333333333333333333333333333333333333333333333332222
77222222222222222222222222221121222222222222276222222222223333333333333333333333333333333333333333333333333333333333333333333322
22222222222222222222222222221121222222222222276222222222233333333333333333333333333333333333333333333333333333333333333333333332
2222222222222222222222222222112122222222222bbbb772222222233333333333333333333333333333333333333333333333333333333333333333333332
222222222222222222222222222211212222222222bbb77778222222223333333333333333333333333333333333333333333333333333333333333333333322
2222222222222222222222222222cccc222222222227777782222222222233333333333333333333333333333333333333333333333333333333333333332222
22222222222222222222222222277667722222222227778882222222222222223333333333333333333333333333333333333333333333333333333322222222
22222222222222222222222222222222222222222222200222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222200222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c0c0ccc0c000c0c00000ccc00cc0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c0c0c0c0c000cc0000000c00c0c0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccc0ccc0c000c0c000000c00c0c0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ccc0c0c0ccc0c0c000000c00cc00000000000000000000000000000000000000000000000000000
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
0cc0ccc0c0c0ccc000000000ccc0ccc0c000c0c00000ccc00cc00000c0c00cc0ccc00000000ccc00ccc001111111111011111111110111111111101111111111
c1101c10c0c0c110000000001c10c1c0c000c0c000001c10c1c00000c0c0c110c11000000001c1001c1001111111111011111111110111111111101111111111
c0000c00c0c0cc00000000000c00ccc0c000cc10ccc00c00c0c00000c0c0ccc0cc00000000001c00c10001111111111011111111110111111111101111111111
c0c00c00ccc0c100000000000c00c1c0c000c1c011100c00c0c00000c0c011c0c1000000000001cc100001111111111011111111110111111111101111111111
ccc0ccc01c10ccc0000000000c00c0c0ccc0c0c000000c00cc1000001cc0cc10ccc0000000000011000001111111111011111111110111111111101111111111
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
4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010001000000000101010101000000000000000101010000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000000000008080818283848586878889808080808ad1d2d3d4d5d6d7d800000000000000000000000000000000000000000000000007070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
000000000000000000000000000000008b8c8d8e8f909192939495969798999adadbdcdddedfe0e117171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
000000000000000000000000000000009b808080809c9d9d9d9d9e9a9a9a9a9ae2e3e4e4e5e6313117171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
000000000000000000000000000000009fa0a1a2a3a49d9d9d9da59a9a9a9aa6e7e8e4e4e9ea313117171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
000000000000000000000000000000009a9a9a9a9aa79d9d9d9da8a9aaabacadebecedeeeff0313117171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
000000000000000000000000000000009a9a9a9a9aaeaf9d9db0b1adadb2b3b4f1f2f3f4f5f6313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
00000000000000000000000000000000b5b6b7b8b9babbbcbdbebfc0c1c2c3c4313131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
00000000000000000000000000000000c5c6c7c8c9cacbccc3c4cecfd09d9d9d313131313131313131313131313131313232323232323232323232323232323231313131313132313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
00000000000000000000000000000000808182838485868788898a8b8c8d8e8f808182838485868788898a8b8c8d8e8f8182838485868781888181818189818a8b8c818d328132320808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00000000000000000000000000000000909192939495969798999a9b9c9d9e9f909192939495969798999a9b9c9d9e9f8e8f909192939481958181818181079617979899328132320808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
00000000000000000000000000000000a0a1a2a3a4a5a6a7a8a9aaabacadaeafa0a1a2a3a4a5a6a7a8a9aaabacadaeaf9a9b9c9d9e9fa0a1a28181818181818117a4a5a6328132320808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000081828384850000000000b0b1b2b3b4b5b6b7b8b9babbbcbdbebfb0b1b2b3b4b5b6b7b8b9babbbcbdbebfa7a8a9aaabac81adae818181818181818100b281323232320808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
00000000000091929394950000000000c0c1c2c3c4c5c6c7c8c9cacbcccdcecfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfb3b3b4b5b6b7b8b9babbbcbde2e2e2e2e281c081323232320808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
000000000000a1a2a3a4a50000000000d0d1d2d3d4d5d6d7d8d9dadbdcdddedfd0d1d2d3d4d5d6d7d8d9dadbdcdddedf81c1c2c3c4c5c6c7c8c9cae2cbcccde2e2cf8181328132323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
000000000000b1b2b3b4b50000000000e0e1e2e3e4e5e6e7e8e9eaebecedeeefe0e1e2e3e4e5e6e7e8e9eaebecedeeef81d0d1d2d3e2e2e2d4d5d6d7d88181e2e2e2e2e2323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
000000000000868788898a0000000000f0f1f2f3f4f5f6f7f8f9fafbfcfdfefff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff8181dbdcdde2e2e2e2dedfe2e2e2e0e2e2e2e1e2fc3232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070808171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
07000717171717170a0a17171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717170a0a171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717170a17171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
1131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
3131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
0000000000000000000000000000000007070717171717171717171717070707000000000000000000000000000000000000000000070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0000000000000000000000000000000007070717171717171717171717070707000000000000000000000000000000000000000000070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0000000000000000000000000000000007000717171717171717171717070007000000000000000000000000000000000000000000070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007000000000000000000000000000000000000000000070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007000000000000000000000000000000000000000000070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007011131313131313131313131210107000000000000000000000000000000000d0d0d0d0d0d0d07000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
0000000000000000000000000000000011313131313131313131313131310000000000000000000000000000000000000d0d0d0d0d0d0d0d000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff31313131313131313131313131313131f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff0d0d0d0d0d0d0d0d000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
__sfx__
0106021224020240172b0202b01732325320102b0272b01030020300172b2252b0173201132017240202401732425320172b0002b0000e0000000000000000000000000000000000000000000000000000000000
010200200c7700c7700c7700b7710b7700c7710c7700c7700c7700c7700c7700c7720c7700c7720c7700c7700c7700c7720a7710a7720c7710c7700c7700c7700c7700c7700c7700c7700c7700b7710c7710c770
0101000c00700187111a7111b7111d711207112271124711287112b7112e71132711377113c7113f7113f7113f7113e7003e7013d7013c7013b70139701387013670134701317012d7012a70126701237011e701
011e000b0c5750c1500c1400c1300c1200c1100c1100c1100c1750c1750c5750c1000c1000c1000c1000c10000100001000010000100001000010000100001000010000100001000010000100001000010000100
010a021224020246242b0202b01732325320102b0272b01030020300172b2252b5173221432317240202451732425322172b0002b0000e0000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019000000a9140a9210a9310a9410a9310a9210a0150a9140a9210a9310a9410a9310a9210a0150a9140a9210a9310a9410a9310a9210a0150a9140a9210a9310a9410a9310a9210a0150a9140a9210a9110a015
0190000e0c8140c81518a150e8140e81518a140c8140c8120c81519a150e8140e8120e8151ba14000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019000111a71518a141c5141c5101c5151a7141a7101a71518a141c5141c5101c5151551415512155151a7141a712000000000000000000000000000000000000000000000000000000000000000000000000000
0190000007914079210793107941079310792107911070150c9140c9210c9310c9410c9310c9210c9110c0150e9140e9210e9310e9410e9310e9210e9110e0150c9140c9210c9310c9410c9310c9210c9110c015
019000111971518a141b5141b5101b51519714197101971518a141b5141b5101b5151451414512145151971419712000000000000000000000000000000000000000000000000000000000000000000000000000
0190000e0d8140d81518a150f8140f8150b0040d8140d8120d81518a150f8140f8120f81524a15010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000
01900000069140692106931069410693106921060150b9140b9210b9310b9410b9310b9210b0150d9140d9210d9310d9410d9310d9210d0150f9140f9210f9310f9410f9310f9210f0150a9140a9210a9110a914
017800090eb200eb2002b200eb200eb200eb200eb200eb2002b200cb000cb000cb000cb000cb000cb0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b00
0178010915b1515b1415b1515b1421b1521b1415b1515b1415b1513b0413b0513b0413b0513b0413b0513b0407b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b00
017800090cb200cb2000b200cb200cb200cb200cb200cb2000b200cb000cb000cb000cb000cb000cb0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b00
0178010915b1514b1414b1514b1420b1520b1414b1514b1414b1513b0413b0513b0413b0513b0413b0513b0407b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b0007b00
0178000e0dc140dc1518a150f5140fc1516014160150dc120dc1518a150fc140fc120fc150f0140100001000000000000000000000000000000000000000000000000000000000000000000000000007b0007b00
0190000e0dc140dc1518a150fc140fc150b0040dc140dc120dc1518a150fc140fc120fc1524a15010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000
014000100951409510095120951209511095150050000500165141651016512165121651216515005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000
000001010000000000004000000000000000000000000000000000000000400014000140000000000000000000000014000140001400014000000000000000000000000000000000000000000000000000000000
010100000140001400014000100000000000000000001000000000000000000004000100000000000000040000000000000000000000010000000000000000000100000000000000000001000000000000000000
000000000000000000000000000000000000000100000000000000000000000000000140001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140001400014000100001000000000040001400014000000000000
0000000001400000000000000000000000000000000000000000000000000000000000000000000000000c0002410000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000084400e055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000140001400014000100000000000000000000400014000140001400010000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010000000000000000000000000004000140001400014000140001400000000000000400014000140001400014000140000000000000040001400014000140001400000000000000000000000000000000
0000000001400014000140000c0002410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000cf00080000e055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 08090a44
00 0b090a44
00 080d0c44
02 0e0d0c44
01 0f101444
02 11121344
01 0f151444
02 11151344

