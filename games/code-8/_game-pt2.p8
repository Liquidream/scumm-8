pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- adv-jam-2018
-- paul nicholas


-- debugging
show_debuginfo = false
show_collision = false
show_pathfinding = true
show_perfinfo = false
enable_mouse = true
enable_diag_squeeze = true	-- allow squeeze through diag gap?
d = printh
enable_gfx_load = true


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
    use = function(me, noun2)
						if noun2 == obj_lock then
       music(1)
       cutscene(
        1, -- no verbs
        function()
         put_at(me, 0, 0, rm_void)
         put_at(obj_alieninside_celldoor, 0, 0, rm_void)
         main_actor.released_ben = true
         dset(28,1)
         --walk_to(ben_actor, 196,50)
         --wait_for_actor(ben_actor)
         say_line(ben_actor,"thank you for rescuing me:now...:let's get off this rock!")
         fades(1,1) -- fade out

         print_line("congratulations!:you've completed the game:thanks for playing",210,50,7,1,true)
         while true do
          break_time(10) 
         end
         --load("_game-intro")
        end
       )
						end
					end
   }
  }


  obj_boulder = {		
   data = [[
    name=boulder
    state=state_here
    x=51
    y=26
    z=10
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
     use = function(me, noun2)
						if noun2 == obj_signal then
       cutscene(
        1, -- no verbs
        -- cutscene code (hides ui, etc.)
        function()
         say_line("*hmmpf*")
         
         put_at(obj_boulder, 92, 31, rm_signal)
         say_line("yes! it's blocking the alien energy beam")
         break_time(150)
         shake(true)
         say_line("uh-oh...:the blockage is building up energy:i think it's gonna blow!")
         walk_to(selected_actor,90,62)
         
         
               --come_out_door(obj_signal_door_map, obj_map_signal, 1)
         
         alien_actor.flip_x = true
         camera_follow(ben_actor)
         
         shake(false)
         break_time(1)
         say_line(alien_actor, "oh no!:quick everyone, get to the energy beam!")
         
         main_actor.disabled_signal = true
         dset(22,1)
        end)
						end
					end
   }
  }

-- [ map "room" (disk2) ]
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
    verbs = {
					walkto = function(me)
						printh("load disk 1!!!")
      --set flag for entered/exited door
      dset(10,2) -- crash
      load("_game-pt1")
					end,
				}
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
    verbs = {
					walkto = function(me)
						printh("load disk 1!!!")
      --set flag for entered/exited door
      dset(10,3) -- graves
      load("_game-pt1")
					end,
				}
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
    verbs = {
					walkto = function(me)
						printh("load disk 1!!!")
      --set flag for entered/exited door
      dset(10,7) -- cave
      load("_game-pt1")
					end,
				}
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
    classes={class_door}
    use_pos={111,18}
    use_dir=face_back
   ]],
   draw = function(me)
    if not main_actor.disabled_signal then
     line(112,9+16,112,0+16, flr(rnd(2))==0 and 8 or 9)
    end
   end,
   init = function(me)
    me.target_door = obj_signal_door_map
   end,
   verbs = {
    walkto = function(me)
     if not main_actor.disabled_signal then
      come_out_door(me, obj_signal_door_map)
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
    init = function(me)
     me.target_door = obj_alienbase_door_map
    end
   }

	rm_map = {
			data = [[
				map = {32,8,47,15}
			]],
			objects = {
    obj_map_door_crash,
    obj_map_door_graves,
    obj_map_door_cave,
    --obj_map_bridge,
    obj_map_signal,
    obj_map_alienbase,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(5)
    selected_actor.scale=0.2
    selected_actor.walk_speed=2
			end,
			exit = function(me)
				selected_actor.scale=nil
    selected_actor.walk_speed=0.6
			end,
		}


-- [ signal generator ]
 -- objects
  obj_signal_door_map = {		
   data = [[
    name=path
    state=state_open
    x=60
    y=58
    z=1
    w=8
    h=1
    classes={class_door}
    use_pos=pos_center
    use_dir=face_front
   ]],
   init = function(me)  
    me.target_door = obj_map_signal
   end
  }

  obj_signal = {		
   data = [[
    name=energy beam
    x=91
    y=21
    w=1
    h=3
    use_dir=face_back
   ]],
   draw = function(me)
    if obj_boulder.in_room!=rm_signal then
     rectfill(94,36+16,96,0+16, flr(rnd(2))==0 and 8 or 9)
     line(95,36+16,95,0+16, flr(rnd(2))==0 and 8 or 9)
    end
   end,
   verbs = {
    lookat = function(me)
     -- todo: text depends on whether played ben's exposition cutscene...
     say_line("the alien energy beam:it's firing into the atmosphere from below:this is what caused our ships to crash...:i must destory it!")
    end
   }
  }

	rm_signal = {
			data = [[
				map = {32,8,47,15}
    autoscale_zoom = 0.75
			]],
			objects = {
				obj_signal_door_map,
    obj_signal,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(2)
			end,
			exit = function(me)
				-- todo: anything here?
			end,
		}


-- [ outside alien base ]
 -- objects
  obj_alienbase_door_map = {		
   data = [[
    name=path
    state=state_open
    x=135
    y=8
    z=1
    w=1
    h=2
    classes={class_door}
    use_pos=pos_right
    use_dir=face_left
   ]],
   init = function(me)  
    me.target_door = obj_map_alienbase
   end
  }


  obj_alienbase_door_inside = {		
   data = [[
    name=heavy door
    state=state_closed
    x=8
    y=16
    z=1
    w=2
    h=2
    state_closed=206
    use_pos={18,32}
    use_dir=face_back
   ]],
   verbs = {
					walkto = function(me)
      if me.state=="state_open" then
       come_out_door(me, obj_alieninside_door_alienbase)
      else
						 say_line("the door is closed")
      end
					end,
   }
  }

	rm_alien_base_outside = {
			data = [[
				map={0,24,17,31}
    autoscale_zoom=0.75
			]],
			objects = {
    obj_alienbase_door_map,
    obj_alienbase_door_inside,
			},
			enter = function(me)
    -- switch gfx
    load_gfx_page(3)
    -- auto-open door?
    if main_actor.disabled_signal then
     obj_alienbase_door_inside.state="state_open"
     obj_alienbase_door_inside.name="alien base"
    end
    --music(6)
			end,
			exit = function(me)
				-- todo: anything here?
			end,
		}

-- [ outside alien base ]
 -- objects
  obj_alieninside_door_alienbase = {		
   data = [[
    name=outside
    state=state_open
    x=16
    y=24
    z=1
    w=3
    h=3
    classes={class_door}
    use_pos=pos_infront
    use_dir=face_back
   ]],
   init = function(me)  
    me.target_door = obj_alienbase_door_inside
   end
  }

  obj_alieninside_celldoor = {		
   data = [[
    name=cell door
    state=state_closed
    x=200
    y=16
    z=1
    w=2
    h=4
    state_closed=206
    use_pos=pos_right
    use_dir=face_back
   ]],
   init = function(me)  
    me.target_door = obj_alienbase_door_inside
   end
  }


 obj_alien_draw = {
  data = [[
   name = 
   state=state_open
   x=176
   y=36
   z=1
   w=2
   h=4
   use_with=true
   classes={class_pickupable}
   use_pos = pos_infront
   use_dir = face_back
  ]],
  draw = function(me)
   set_trans_col(3, true)
   local xoff=0
   if (alien_actor.flip_x) xoff=12
   if flr(time())%2==0 then
    spr(6,me.x+xoff,me.y,2,4,alien_actor.flip_x)
   else
    spr(8,me.x+xoff,me.y,2,4,alien_actor.flip_x)
   end
  end
 }

 obj_lock = {		
   data = [[
    name=alien lock
    state=state_here
    x=252
    y=30
    w=1
    h=1
    state_here=162
    use_pos=pos_infront
    use_dir=face_back
    trans_col=1
   ]],
   verbs = {
    lookat = function(me)
     say_line("it looks biometric:only an alien can open it")
    end,
   }
  }


	rm_alien_base_inside = {
			data = [[
				map={24,24,57,31}
    min_autoscale=1
			]],
			objects = {
    obj_alieninside_door_alienbase,
    obj_alieninside_celldoor,
    obj_alien_draw,
    obj_lock,
			},
			enter = function(me)
    -- switch gfx
    printh("in rm_alien_base_inside...")
    load_gfx_page(4)

    if selected_actor.disabled_signal then
     put_at(obj_alien_draw,0,0,rm_void)
     put_at(alien_actor,0,0,rm_void)
    end 

    music(6)
    -- make alien color-effect
    --start_script(me.scripts.anim_alien, true) -- bg script
			end,
			exit = function(me)
				-- pause fireplace while not in room
				--stop_script(me.scripts.anim_alien)
			end,
   scripts = {
			}
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
     -- if noun2 == obj_signal then
     --  --say_line("let's get that crystal...:*dink*")
     --  main_actor.disabled_signal = true
     --  dset(22,1)
     -- end
    end
   }
  }

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
   obj_lasertool,
   obj_alien_hand,
   obj_boulder,
		},
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_void,
 --rm_bridge,
 rm_map,
 rm_signal,	
 rm_alien_base_outside,
 rm_alien_base_inside,
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


 alien_actor = {
   data = [[
    name = alien
    x = 192
    y = 52
    w = 2
    h = 4
    idle = { 3, 3, 3, 3 }
    talk = { 28, 28, 28, 28 }
    col = 8
    trans_col = 3
    walk_speed = 0.4
    frame_delay = 5
    classes = {class_actor,class_talkable}
    face_dir = face_front
    use_pos = pos_left
   ]],
   in_room = rm_alien_base_inside,
   inventory = {
   },
 }

 ben_actor = {
   data = [[
    name = ben
    x = 224
    y = 47
    z=-2
    w = 1
    h = 4
    idle = { 1, 1, 1, 1 }
    talk = { 18, 18, 18, 18 }
    col = 12
    trans_col = 3
    walk_speed = 0.4
    frame_delay = 5
    classes = {class_actor,class_talkable}
    face_dir = face_front
    use_pos = pos_left
   ]],
   in_room = rm_alien_base_inside,
   inventory = {
   },
   verbs = {
    talkto = function(me)
					-- dialog loop start
					while (true) do
						-- build dialog options
						dialog_set({ 
							(me.asked_who!=0 and "" or "are you captain ben octavi?"),

       (me.asked_who!=1 and "" or "i am a space trader:i received your distress message"),
       (me.asked_who!=1 and "" or "i'm luke skywalker;i'm here to rescue you"),
       (me.asked_who!=1 and "" or "i am guybrush threepwood, mighty pirate"),

							((me.asked_escape or me.asked_who==1) and "" or "do you know the how to unlock this cell?"),

							"i'll be right back"
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
									say_line(me, "yes i am, who are you?")
									me.asked_who = 1

        -- who
								elseif selected_sentence.num == 2 then
									say_line(me, "well, i'm so glad to see you!")
									me.asked_who = 2
        elseif selected_sentence.num == 3 then
									say_line(me, "you're who?!?")
									me.asked_who = 2
        elseif selected_sentence.num == 4 then
									say_line(me, "guybrush threepwood?:that's the most ridiculous name i've ever heard!")
									me.asked_who = 2


        elseif selected_sentence.num == 5 then
									say_line(me, "i think the alien pressed its hand against the sensor other there")
									me.asked_who = 2


								elseif selected_sentence.num == 6 then
									say_line(me, "please hurry")
									dialog_end()
									return
								end
							end)

						dialog_clear()

					end --dialog loop
				end, -- talkto
    lookat = function(me)
     say_line("it's captain ben octavi:he's alive!")
    end
   } -- verbs
  }

-- 
-- active actors list
-- 
actors = {
	main_actor,
	ben_actor,
 alien_actor,
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()
 cartdata("pn_code8")

 -- for d=10,30 do
 --  printh("dget("..d..")="..dget(d))
 -- end



 -- permanent inventory?
 pickup_obj(obj_lasertool, main_actor)

 music(6)

 -- game states
 if (dget(20)==1) main_actor.fixed_ship = true
 main_actor.ben_cutscene = dget(21)
 if (dget(22)==1) main_actor.disabled_signal = true
 if (dget(23)==1) main_actor.engine_cover_replaced = true -- not same as fixed ship, just cover!
 if (dget(24)==1) main_actor.crystal_replaced = true
 -- ben released + alien hand states
 if (dget(28)==1) then
  main_actor.released_ben = true
  put_at(obj_alien_hand, 0,0, rm_void)
 end
 if dget(27)==1 and not main_actor.released_ben then
  pickup_obj(obj_alien_hand, main_actor)
 end
 if dget(29)==1 and not main_actor.disabled_signal then
  pickup_obj(obj_boulder, main_actor)
 end

 -- still controlling player
 selected_actor = main_actor
 camera_follow(selected_actor)

 -- reset talking state
 ben_actor.asked_who=0

 -- check starting room/door (if came via map)
 local sourcedoor = nil
 local targetdoor = nil
 
 if dget(10)==2 then
  sourcedoor = obj_map_signal
  targetdoor = obj_signal_door_map
  
 elseif dget(10)==3 then
  sourcedoor = obj_map_alienbase
  targetdoor = obj_alienbase_door_map
 
 else
  sourcedoor = obj_map_alienbase
  targetdoor = obj_map_alienbase
 end


 -- check for ben cutscenes
 ---------------------------------
 -- first cutscene
 ---------------------------------
 if main_actor.ben_cutscene == 0.5 then
  printh("doing cutscene 1!")
  
  -- don't do this again
  main_actor.ben_cutscene = 1
  dset(21,1)
  
  change_room(rm_alien_base_inside,1)

  -- do cutscene
  cutscene(
   1, -- no verbs
   -- cutscene code (hides ui, etc.)
   function()
    -- camera_at(0)
    -- camera_pan_to(ben_actor)
    -- wait_for_camera()
    camera_at(ben_actor)
    --say_line(ben_actor,"who are you?:what do you want from me?")
    --say_line(alien_actor,"captain ben,:give us the location of the human base:...or it will hurt!")
    say_line(alien_actor,"give us the location of the human base:or we'll just crash more ships here...:until we find someone who will!")
    say_line(ben_actor,"wait? you are the reason my ship crashed?:i lost two good men in that crash!")
    say_line(alien_actor,"we care not:our energy beam is getting even stronger:now, tell us what we want to know!")
    fades(1,1)	-- fade out
    dset(10,1)
    load("_game-pt1")
   end
  )
 else
  come_out_door(sourcedoor, targetdoor)

  
 end -- if not cutscene

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
1a4008049f0381ac7c8665bb2f5908e3028a5b474377a2519e04ff0d00a237415420a35415868641543a86a123af934b86c93a82210d92a827c14dc1d82a968c
8a4547191a188d7be79e84044f7aacff8790f152a5206a0271a38e00db70e553a82a9270312ff0def35ffb491bffaa3bf5bafffe7d7b734dd94930f39609ef79
3f82bef3fffa5e419eff88cf6c535efffaca0247f95e125eefa959e2759ba9242086c3a41f41634686868684a17c9242c583425a82a493e97460a16346868686
8c825848b186a094937c92a012ff309eb9378a6ef7d2619ef74d5a956846de2745a429a417fa959e27593d412122a4841a44b40c414e2470d18edfeefa3d82ae
ffb82f925594ffd23929aac59e154172b71bfb47ef336cad19b5652ba4da252d6c2b08087fbeb24eff9a9bda9f5a15f5fecd23f03ff3f3e4150d1a10d430cf58
4a0d0f0224343c2e9326044086a17e493e9343434258687011a1a161f825a86e94090a8d0e9343caf7de29b4757892ff5a88c33325d3ca5f3e4150d1a10aaefb
ff72b6546a86ff77d55937446bdff7f448bb9bf5a1138f767dfd49e49800288fff84575e4dfb365eb3de517af5aafc9c5459a8efaa4fffb880042a7ffaa192a1
2dfa01119413d48a095001064685827c92425ac36349800a15c1a1a9242d86c682908819161ac17a09492f891011043a834343584a1d8d052103fb868684fb24
44425c88481ca0010e78efffaa5144416ff17a3e0d4ff1bdfdb925359af57e2973ba845f2fa2228126eff0b12937c24286c35ac17a0910dff3c60e7ff7beff2d
1d09effbb860407a6557428b18be4da6d190e60ea3f964da26103d97a8ba26103d97a8ba26103d9aaaa85850c4355551b0b0896aaaa2616b30cf508d70818ef3
cbf5be8990c96e82c3d8a41df925fab53aa24af374bfffad9effda290b5e7158af357adfa15512dfc19df07fd1d8ce3fbc0ddf4d96fb645584f3746f3cdfed7f
8c8f5684df4d55edf8c975b41bc7cf71b35b3df59cffb5ff4dbacbf1bcba5a87f32ff6ce4d85f3ff9aba97f1bcba5a87f19fb1d4d49bf55ff1cef5aca5e2de51
ff4243a901f31ae0dd3743ccd3cdd24323e568ee0dd3743ccd3cd3d4323e568a868befec29edfb24ae62b48904c976119b878508b410205e0b2cd492541a1478
cff7d3df519bf7fee67b2292bf7fecaaf5df35ff9af9ff767fff3dffdfb7c55be92eef257a9eb5ff3d775ffcdfd5eef6fefc5deffef63ddadfdeefc5d7baef5f
7e65fafbf7aef1b9b5afbbe6dfbfabfd3d74da678cb6fdfe077fdfcdf6daf7a6735f77f3fe87f7c28befae5ffefcf2af38bfb84dafdfaaf5de0d37fae77dffd4
df4f7f727dfefaa6a679278486ffaefcbfddfbbf773fefee75ffcffbf7f4574f43aefab59275dfbfd75f3a17f7bbf9fbadffdfd6abb05bf557bf7f7a655df86f
3df7e6df77aef3470d10806ff9322df74803c9aa5ce2dc37c55aedfbf09dfffecd5d1dc1bee5444e311c4d8674f7a27d5ee5fbc1a7edb3d177786fc9b7e2afe1
b346e4dbae1ffe8e09cdff3bf2f3964f7ec354f74b2157a7f0bfbf8636d32dbbf86e27d19e375f4d7a677eaef6ee198af25b9f92b45b254e3f2c5fd1c5ecd5a7
e1d8be4a253ad15f32a5af4e7e179faa84512dd1ad937fc54b5e7cbba225a258400af1b7000804910b780004e58410d604f10d704f10d704f10d704f10d704f1
0df00e035027a8290521a420a390521a42008ba2d0bc3c2504f9685e16968d0863586a161d08530af0634343434343478e0b08e20af08e30af08e30af08e30af
08e30af0518c0b0d0d0d0d0d08e34208fb0d0d0d0d0d008f8243434343430861ce000804950b73ae28000dff0006d8e019b06d93210a55171a20ac0cdee25ae5
5290b08324c52b00bb1dc1a105786a0d16d1b43002292e12350b5ce0eaa0916937ac9506123505150ac0d081a1415127067455060110c4154920541e92052a84
d092e7e825a17e1a924350f54f0b35c75b8e8ea710cff7e978512b5934e8209e09090e3c24c3145e0224685860afc16980864144850d144e16350c8927a14541
8038b41e1cd43ac1b0c3e93e9c05e935e98084840130e8402935e700ace35ac930925c93a8602f34250e4e82ac1705d45898388090e30c24061a1610ea35c3c2
06b0e7858d0d04a92e41cf090c40d61008049a03fa001b6c45a08620c22430cc34302f0d10eba02d0cb551486430eb06243a0d08d3430ee0d824306f0d08d3f0
9e84a65550ea43c2d0d9a3671d04ba40fba7c161a1671638198fabc5c243ce27d5c2015021a1a1a109804243430ba04bd1a24309f43a0cc2a50c6a7a49af05d1
4b0a3438e70c9da1f1014e6a2a71b00a0af0154255da253015047d86f3af0b185d86860ec41c4c3c204ac383880ce938a68f2835475938affc1c53c43ab1d0b6
89ef59209add86a643e609a3a9a1dcd8686389d9e1c6b530c250af64202ef003ffc1508e68645430a80c87183a86871d470292ec16550e4bb193a0ae92e0ea96
e02aba9e9350243a1ad438da3d15055541d0ce41e107604fd8e0ca64704918dd0558d2a1815438c225438750cc2a1ccc189d868f5ac18457a04e0e2f088604d3
c60650ce10940b1055870caf7f365086f20a01081cf363ff5f1904243434388012ffd66a65b433a700f3500a1c0d0d0d0d0d0d00d8008f7306f000d700d01008
04950be8782b08e304e50a1014460e5211d0862435067b3a1a1a1a1618793a0c982a92438e43c28c41693f0d0e37414f82a827860d96850992428a342b66d9a6
294c20cd6e3ea6c75bc7183addc1a1a1a1a1a1a161d7851a351d0d0d0d415e087b08086e4f089d18c081f92e0d0d0d83d837c93e492d438cea0fa370ed0d0d0d
0d0d0d0a3e0d0d092a147558908e34343434343438acf0b0c2d3c683218486a454246081f0b41a34302e0d1a924358e0d0b414e0d0cb0cf0d1a3435044283d82
f43ec1908d085e5723d1144a386522241d41c863653c200de60003e23742080343ac300a0e73658611d0d0d0d0018008483880d0d0901186860a555427d930f2
00e0e1a1a125438eaa0310b3008008049f0b2a60bb9c56f8714d82554b0cb51813c643d424269b532158a0763c249299127e864f8fc9d2a47d55d5f1586acba2
259403bba279c1657dfbd7229d8bbf3a39e5f9c7fb9adfb3db54e76fe29b365afe7aafcf9bf924e3a096c2dc409ffbe4a29e254925b2d55ff2de4afa9e9a93d2
9fd174ff7a659a35ae3b79dd7f49cebda9c0a937c575da659fa5b6fbc5723caff178511aa29c9c59b0215df55df2d835554203a03a4630111b6eab190264151a
5dffe5373164c6d85395eaa1b5d7a415a09ca21175268875a25674ba65265b67552245e3bb94c2b26f52584ac1310a92ac92f4358485614687e41d41b1437e49
28a435e4948201fc34c0905a87a0b1292c687630120492c3a4be27a3e43e1393cfb4175559477be5117bb3dcc4ab9dd63337b9be3532caff3d9fef75d7d9e47a
7bcdc51ba3484d9d674d59255940557cf6e4121575848ef7adf75595d39b15ba1db588584a229392ae61ff1ba72f7979644edf7effcc8dc59e7e25ba9af57cd2
71d7e37a0154ff93aeae5f49aa93f435a977aff7dfffa39411512d7a3c47488ff5ffb505b456ac7f1a35a4e968b87aebbf6d76759389e19fb881c34ae27faff3
39ff73cf72f6fbf5d5e1fba19ef865ff037a23db2eaadc87b3e6dbcaea8a08c0e09497494ceaaef674ac5d45d090b419ef46f529a45b0d5dfdfae25b7d7b4c6d
2437fe2ba755e69eedceb9945dd31ddadc18168402f5c20b70b940234389031c9291a0d068efa69a391a9ac574aa88baaa3757269bbf45113d26fd3ee6fdc757
aedf01f7d75d77ba5f9bfe22f36dfb092ce417a0bd55eaa035884122baa94bffd9ba655abd848cb8e3eeae8418faefa8f924b67ad870c026b1036072309c948b
4925327deff0255e38bf0b036c465ba55985b261a19243d440fffa01fbfb3b433bebff9bb4777579eabb92795b7ddce7a47e0b1c47c83e8c6dea756fee809dda
5b59e9d2f2945999652e2fdcbf98479de7b577925b29d494cc5786c6ccce4bcf4bd11104486ecb7d513987c18537c68685e492543948d343ce1d9647e01d94ba
65d443a4241ce1afef7a92aa319d37b88a49bab72255aa486ea68401fb2ecb1fc588aceb7ba5c0fdbff58adfa7edbd19cec7f35b47b99cfbce5c9b549674dcf3
5deb77cdfa29edb51dfd4d064ff1aff9b1de753a71ff7185736d1fe0894e0d0d04f5c6b3dd74cff2b25a4d4d2dfddefa47626bdea2d5a72d6b136bcf37ee67a7
98519ba3a4422759d0fdde93d71b11f8088046644908808fb4a5b99ce55b6af55d2c37e493ec92d8b7d54a49cedb5deb5fb99cc59222b672bbbbebbbde4577aa
be4f49e42fffdff79dcad2f8a7df84b69fff777fab7eabef633b92d5562a829d27568aa9aa098f735befd965adfde6bef47396777719d9d8c3667ee939ab5f6d
fa5159a8aa82f41ce4ab8c1641a2e4190aea37b21901d493d82f41e9a5ce12d69de555a998c6e4c76b6928a6cbd177d71125092a3a9e42ba5f4f8abec9bffbaf
f19eff0649af4d4acdfe79eddf6d77e625f4dff13d1eaa8e2b0d09cbe279250c8714a2a50a3bfcf1bfe7575afd294d5efdc9bff76dbffef22ffe7f7e5fcdfa65
b957644c789062228e55bad403f47540590925f9e488f7d6e821e422d49862db5d6ab2a6277e8e4927bb8584a0b0b144434479be83d2bbf71dbb65552fbbd455
22a2b05892c598c4499844984113aef7effd6aaaff75d5afff5554edb7fcfdbcce6d777cbcb4d4eda72dd64411bbfeee469f79c455e2afc9808c8a31f825d54a
21e492da2a8820e17a4390521a1f3e7a14ecc0a8512b54a0d92559c151f827634924275c4a06483a98bcefb9b25ffacdb8f547b744be21796db25b474a7bbaba
5c9c37faef9e17ff3d778d7198bbe45772dd9a4fbff1b924ccfbc44bf77dffd7be3a7ba5fd5dbe77df4c82f557ff7aa74aaa21bb462215bee71bbcf5775a26a4
4285bff4a3dbc5c89f793f9c29effeff5dc52de44cff5c941fa573b76397147b2f6d31d1cf3789b2575a21262043115a6e69d849492f0a685e8f5719870b3c6c
932b5c92759e435c44ff22f4ffbadabbbe3dfffeae66feccee5d55d6a9261e15b4fe1240c961de1de1de1b44802fae53f91da018211fa29a4baada493584639e
eb25a7bbc2b884a5d55525b28a05bca2654c5c5226c29c1d4f05ccf7dfbeedff77bea40ac08ef4451a9a2491e46cf75555afdd5e6a17a46749983a2259ed299e
439693e654d29eeba739e63dffb7166e9ff7ed9b4fcb8f6f977e9a9eec4fffbfffebfddf4dbab46aacf7bea44fb6cfdae5d2efecce6d675286ee7a2567031cb5
d71223f75f52ebfeefcab457b2fbe69b1d168d93fe6ee737695377daeddcb9eb9535d5755da44acdd802a23f2fe7bfe52596b1167b764eb332d5a49774682d47
86435e435e42013e8c55af55aaa21a1d9c98354121907a1294e3a921105220ac9358db853b1ac2c3e163c346890f0b8407a1af2f5d2190a45da6aaa4a458561a
421295a45d96ca0e3d0993ac3234b27299aeab22929005588ae632d2d9b6dfb6195e945baec1b0cec9b592f07245eebff78cf04effecaee01f76d3a06a743038
dbe37212d7fda45587fb43f515f850d5eeae4fdfddf2edfbdfc9f5d455190d09cf79a417151a822bac655c24c92e22592229f3bed296b39a905249871d4441b9
45d4729555241615492549361b2e95257577aefebdffdaeaebc77d7caaaab6baf2dc6d5b4edded8bddfaea65bcfd7f44f9dfa311fbd42fc5559c51b035ed752e
e7fd2757aad5aadf67a65a42f9b22c4725f6731bddd7fdbafa15afdc971984862341a7d542521848f04f16121561c3ec358d011420bc145a41a9290d435a0b12
9272141ca07a43a0401890d86a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000000000000000000000001010101010101010100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0000000000000000000000000000000017171708080a0a080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
000000000000000000000000000000001700170808080a0a0a08080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0000000000000000000000000000000017001708080808080a08080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0000000000000000000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0000000000000000000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
0000000000000000000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
0000000000000000000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313132313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
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
8080808080808182838484848484848484840000000017178080808080808080808080808080808080808080808080808080808080808080808080000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
85858585868587858588898a8b8c8d8484840000000017178080808080808080808080808080808080808080808080808080808080808080808080000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
858e8f8590859185858585929385859495970000000017178181828384818586878585858581818586878585858581818588898585858581818181000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
85c2988585858585999a9b9b9b9b9b9c9dac00000000171781818a8b8c818d8e8f8d8d8d8d81818d8e8f8d8d8d8d81818d8d908d8d8d8d81818181000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
9f9f9f9f9f9f9f9fa0a1a2a3a4a5a6a7a8a80000000017178181918b92818d93948d8d8d8d81818d93948d8d8d8d81818d8d908d8d8d8d81818181000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
aaaaaaacadaeafb0b1b2b3b4b5b5b5b5b5b50000000031318181918b92819596979595959581819596979595959581819598b09595959581818181000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
b6b6b7b8b9babbbcbdb5b5b5b5b5b5b5b5b500000000313180999a9b9c9d8080808080808080808080808080808080808080808080808080808080000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
bebebfc0c1b5b5b5b5b5b5b5b5b5b5b5b5b50000000031319e9f9b9b9ba0a180808080808080808080808080808080808080808080808080808080000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000140001400014000100000000000000000001000000000000000000004000100000000000000040000000000000000000000010000000000000000000100000000000000000001000000000000000000
010101010000000000000000000000000000000100000000000000000000000000000140001400000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000
000000000140001400010000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000400014000100001400
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000
010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400014000140000000000000000000000000000140001400
000000000000000000000000040001400014000140001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000400014000140001400014000140001400014000100000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

