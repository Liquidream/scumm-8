pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- scumm-8
-- paul nicholas

-- [debug flags]
--show_debuginfo = true
-- show_collision = true
-- show_pathfinding = true
-- show_depth = true

-- [game flags]
enable_diag_squeeze = false	-- allow squeeze through diag gap?


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
-- index of the verb to use when clicking items in inventory (e.g. look-at)
verb_default_inventory_index = 5

function reset_ui()
	verb_maincol = 12  -- main color (lt blue)
	verb_hovcol = 7    -- hover color (white)
	verb_shadcol = 1   -- shadow (dk blue)
	verb_defcol = 10   -- default action (yellow)
 ui_cursorspr = 224 -- default cursor sprite
 ui_uparrowspr = 208-- default up arrow sprite
 ui_dnarrowspr = 240-- default up arrow sprite
 -- default cols to use when animating cursor
 ui_cursor_cols = {7,12,13,13,12,7}
end

-- perform initial ui setup
reset_ui()


--
-- room & object definitions
--

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
					classes = {class_door,class_openable}
					use_pos = pos_right
					use_dir = face_left
				]],
				init = function(me)
					me.target_door = obj_front_door
				end
			}


			obj_hall_door_library = {
				data = [[
					name = library
					state = state_open
					x=56
					y=16
					w=1
					h=3
     flip_x = true
     state_closed = 78
					use_dir = face_back
					classes = {class_door,class_openable}
				]],
				init = function(me)
					me.target_door = obj_library_door_hall
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
				init = function(me)
					me.target_door = obj_kitchen_door_hall
				end
			}

			obj_bucket = {
				data = [[
					name = full bucket
					state = state_closed
					x=142
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
						say_line("it's an old bucket")
					end,
					pickup = function(me)
						pickup_obj(me)
					end,
					use = function(me, noun2)
						if noun2 == obj_fire and me.state == "state_closed" then
							put_at(obj_fire, 0, 0, rm_void)
							--put_at(obj_key, 88, 32, rm_library)
							obj_bucket.state = "state_open"
							say_line("the fire's out now")
						end
					end
				}
			}

			obj_spinning_top = {
				data = [[
					name=spinning top
					x=36
					y=37
					w=1
					h=1
					state=state_idle
     state_idle=158
					anim_spin={158,174,190}
     frame_delay=4
					col_replace={12,7}
					trans_col=15
     use_dir = face_front
				]],
				verbs = {
     lookat = function(me)
      -- do cutscene
      cutscene(
       1, -- no verbs
       -- cutscene code (hides ui, etc.)
       function()
        say_line("this is some example dialog")
        break_time(20)
        say_line("with some pauses...")
        break_time(20)
        say_line("you can try skipping next time!")
       end,
       -- override for cutscene
       function()
        stop_talking()
       end
      )
     end,
					use = function(me)
      
						if script_running(room_curr.scripts.spin_top) then
							stop_script(room_curr.scripts.spin_top)
       me.curr_anim = nil      -- stop cycle anim
							me.state = "state_idle" -- go to initial state/frame
						else
							start_script(room_curr.scripts.spin_top, 
                    true) -- bg script, continues executing on room change
						end
					end
				}
			}

		rm_hall = {
			data = [[
				map = {32,24,55,31}
			]],
			objects = {
				obj_front_door_inside,
				obj_hall_door_library,
				obj_hall_door_kitchen,
				obj_spinning_top,
    obj_bucket,
			},
			enter = function(me)
    -- note: this will work for first enter,  but when using doors 
    --       to enter room, door position will override put_at()
				selected_actor = main_actor
    put_at(selected_actor, 30, 55, rm_hall)
				camera_follow(selected_actor)
			end,
			exit = function(me)
				-- todo: anything here?
			end,

   scripts = {	  -- scripts that are at room-level
				spin_top = function()
					dir=-1
     do_anim(obj_spinning_top, obj_spinning_top.anim_spin)
					while true do
						for x=1,3 do
							-- move top
							obj_spinning_top.x -= dir
       break_time(12)
						end
						dir *= -1
					end
				end,
			},
		}

-- library
		-- objects

			obj_library_door_hall = {
				data = [[
					name = hall
					state = state_open
					x=136
					y=16
					w=1
					h=3
     state_closed = 78
					use_dir = face_back
					classes = {class_door,class_openable}
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
					state=state_here
     state_here=81
     anim_fire={81,82,83}     
     frame_delay=8
     use_pos={97,42}
					lighting = 1
				]],
				init = function(me)
     -- animate fireplace
     do_anim(me, me.anim_fire)
    end,
				verbs = {
					lookat = function()
						say_line("it's a nice, warm fire...")
						break_time(10)
						do_anim(selected_actor, "face_towards", "face_front")
						say_line("ouch! it's hot!:*stupid fire*")
					end,
					talkto = function()
						say_line("'hi fire...'")
						break_time(10)
						do_anim(selected_actor, "face_towards", "face_front")
						say_line("the fire didn't say hello back:burn!!")
					end,
					pickup = function(me)
						pickup_obj(me)
					end
				}
			}


		rm_library = {
			data = [[
				map = {56,24,79,31}
				col_replace={7,4}
			]],
			objects = {
				obj_library_door_hall,
				obj_fire,
			},
			enter = function(me)
				-- setup anything necessary on "enter" of room
			end,
			exit = function(me)
    -- tidy-up/stop anything necessary on "exit" of room
				-- note: we don't need to pause fireplace as not using a script
    --       (it's an anim, so if not visible, will not animate)				
			end,			
		}



-- "the void" (room)
-- a place to put objects/actors when not in any visible room

	-- objects

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
		},
	}



--
-- room definitions
--



rooms = {
	rm_void,
	rm_hall,
	rm_library,
}




-- actor definitions
--

-- initialize the player's actor object
main_actor = {
		-- sprite/anim order for directions = front, left, back, right) 
  -- (note: right = left value...flipped!)
		data = [[
			name = humanoid
			w = 1
			h = 4
			idle = { 193, 197, 199, 197 }
			talk = { 218, 219, 220, 219, 0,8, 1,1 }
			walk_anim_side = { 196, 197, 198, 197 }
			walk_anim_front = { 194, 193, 195, 193 }
			walk_anim_back = { 200, 199, 201, 199 }
			col = 12
			trans_col = 11
			walk_speed = 0.5
			frame_delay = 5
			classes = {class_actor}
			face_dir = face_front
		]],
}

purp_tentacle = {
		data = [[
			name = purple tentacle
			x = 88
			y = 51
			w = 1
			h = 3
			idle = { 154, 154, 154, 154 }
			talk = { 171, 171, 171, 171 }
			col = 11
			trans_col = 15
			walk_speed = 0.4
			frame_delay = 5
			classes = {class_actor,class_talkable}
			face_dir = face_front
			use_pos = pos_left
		]],
		in_room = rm_hall,
		verbs = {
				lookat = function()
					say_line("it's a weird looking tentacle, thing!")
				end,
				talkto = function(me)
					cutscene(
						1, -- no verbs
						function()
							--do_anim(purp_tentacle, face_towards, selected_actor)
							say_line(me,"what do you want?")
						end)

					-- dialog loop start
					while (true) do
						-- build dialog options
						dialog_set({
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
									say_line(me, "you are in a demo scumm-8 game, i think!")
									me.asked_where = true

								elseif selected_sentence.num == 2 then
									say_line(me, "a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!")
									me.asked_woodchuck = true

								elseif selected_sentence.num == 3 then
									say_line(me, "ok bye!")
									dialog_end()
									return
								end
							end)

						dialog_clear()

					end --dialog loop
				end, -- talkto
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
	--pickup_obj(obj_bucket, main_actor)

	-- set which room to start the game in
	-- (e.g. could be a "pseudo" room for title screen!)
	change_room(rm_hall, 
              1) -- iris fade

 -- set actor to start in different room
 -- (by default, this is being done in room's startup script)
 -- selected_actor = main_actor
 -- put_at(selected_actor, 51, 41, rm_library)
 -- camera_follow(selected_actor)
 -- change_room(rm_library, 1) -- iris fade


end


-- (end of customisable game content)



-->8
-- scumm-8 core engine

-- ############################
--    you should not need to 
--  modify anything below here
-- ############################

function shake(bc)
bd,be=bc,bc and 1 or be
end
function bf(bg)
local bh="lookat"
if has_flag(bg.classes,"class_talkable") then
bh="talkto"
elseif has_flag(bg.classes,"class_openable") then
if bg.state=="state_closed"then
bh="open"
else
bh="close"
end
end
for bi in all(verbs) do
bj=get_verb(bi)
if bj[2]==bh then bh=bi break end
end
return bh
end
function bk(bl,bm,bn)
local bo=has_flag(bm.classes,"class_actor")
if bl=="walkto"then
return
elseif bl=="pickup"then
say_line(bo and"i don't need them"or"i don't need that")
elseif bl=="use"then
say_line(bo and"i can't just *use* someone"or
((bn and has_flag(bn.classes,class_actor)) and"i can't use that on someone!"or"that doesn't work"))
elseif bl=="give"then
say_line(bo and"i don't think i should be giving this away"or"i can't do that")
elseif bl=="lookat"then
say_line(bo and"i think it's alive"or"looks pretty ordinary")
elseif bl=="open"or bl=="close"then
say_line((bo and"they don't"or"it doesn't").." seem to "..bl)
elseif bl=="push"or bl=="pull"then
say_line(bo and"moving them would accomplish nothing"or"it won't budge!")
elseif bl=="talkto"then
say_line(bo and"erm ...  i don't think they want to talk"or"i am not talking to that!")
else
say_line"hmm. no."
end
end
function camera_at(bp)
cam_x,bq,br=bs(bp)
end
function camera_follow(bt)
stop_script(bu)
br,bq=bt
bu=function()
while br do
if(br.in_room==room_curr) cam_x=bs(br)
yield()
end
end
start_script(bu,true)
if(br.in_room!=room_curr) change_room(br.in_room,1)
end
function camera_pan_to(bp)
bq,br=bs(bp)
bu=function()
while cam_x~=bq do
cam_x+=sgn(bq-cam_x)/2
yield()
end
bq=nil
end
start_script(bu,true)
end
function wait_for_camera()
while script_running(bu) do
yield()
end
end
function cutscene(type,bv,bw)
bx={
by=type,
bz=cocreate(bv),
ca=bw,
cb=br
}
add(cc,bx)
ce=bx
break_time()
end
function dialog_set(cf)
for msg in all(cf) do
dialog_add(msg)
end
end
function dialog_add(msg)
cg=cg or{ch={}}
ci=cj(msg,32)
ck=cl(ci)
cm={
num=#cg.ch+1,
msg=msg,
ci=ci,
cn=ck
}
add(cg.ch,cm)
end
function dialog_start(col,co)
cg.col=col
cg.co=co
cg.cp=true
selected_sentence=nil
end
function dialog_hide()
cg.cp=false
end
function dialog_clear()
cg.ch={}
selected_sentence=nil
end
function dialog_end()
cg=nil
end
function get_use_pos(bg)
local cq,y,x=bg.use_pos or"pos_infront",bg.y,bg.x
if cr(cq) then
x,y=cq[1],cq[2]
else
local cs={
pos_left={-2,bg.h*8-2},
pos_right={bg.w*8,bg.h*8-2},
pos_above={bg.w*4-4,-2},
pos_center={bg.w*4,bg.h*4-4},
pos_infront={bg.w*4-4,bg.h*8+2}
}
if cq=="pos_left"and bg.ct then
x-=(bg.w*8+4)
y+=1
else
x+=cs[cq][1]
y+=cs[cq][2]
end
end
return{x=x,y=y}
end
function do_anim(cu,cv,cw)
if cv=="face_towards"then
if cr(cw) then
cx=atan2(cu.x-cw.x,cw.y-cu.y)
cy=93*(3.1415/180)
cx=cy-cx
cz=(cx*360)%360
cw=4-flr(cz/90)
cw=da[cw]
end
face_dir=da[cu.face_dir]
cw=da[cw]
while face_dir!=cw do
if face_dir<cw then
face_dir+=1
else
face_dir-=1
end
cu.face_dir=da[face_dir]
cu.flip=(cu.face_dir=="face_left")
break_time(10)
end
else
cu.curr_anim=cv
cu.db=1
cu.dc=1
end
end
function open_door(dd,de)
if dd.state=="state_open"then
say_line"it's already open"
else
dd.state="state_open"
if(de) de.state="state_open"
end
end
function close_door(dd,de)
if dd.state=="state_closed"then
say_line"it's already closed"
else
dd.state="state_closed"
if(de) de.state="state_closed"
end
end
function come_out_door(df,dg,dh)
if(dg==nil) di("target door does not exist") return
if(df.state~="state_open") say_line("the door is closed") return
dj=dg.in_room
if(dj!=room_curr) change_room(dj,dh)
local dk=get_use_pos(dg)
put_at(selected_actor,dk.x,dk.y,dj)
if dg.use_dir then
dl=da[(da[dg.use_dir]+1)%4+1]
else
dl="face_front"
end
selected_actor.face_dir=dl
selected_actor.flip=(selected_actor.face_dir=="face_left")
end
dm={
open=open_door,
close=close_door,
walkto=come_out_door
}
function fades(dn,dir)
local dp=25-25*dir
while true do
dp+=dir*2
if dp>50
or dp<0 then
return
end
if(dn==1) dq=min(dp,32)
yield()
end
end
function change_room(dj,dn)
if(not dj) di("room does not exist") return
stop_script(dr)
if dn and room_curr then
fades(dn,1)
end
if(room_curr and room_curr.exit) room_curr.exit(room_curr)
ds={}
dt()
room_curr=dj
if(not br or br.in_room!=room_curr) cam_x=0
stop_talking()
if dn then
dr=function()
fades(dn,-1)
end
start_script(dr,true)
else
dq=0
end
if room_curr.enter then
room_curr.enter(room_curr)
end
end
function valid_verb(bl,du)
if(not du or not du.verbs) return false
if cr(bl) then
if(du.verbs[bl[1]]) return true
else
if(du.verbs[bl]) return true
end
end
function pickup_obj(bg,bt)
bt=bt or selected_actor
add(bt.dv,bg)
bg.owner=bt
del(bg.in_room.objects,bg)
end
function start_script(dw,dx,dy,q)
local bz=cocreate(dw)
add(dx and dz or ds,{dw,bz,dy,q})
end
function script_running(dw)
for ea in all({ds,dz}) do
for eb,ec in pairs(ea) do
if ec[1]==dw then
return ec
end
end
end
end
function stop_script(dw)
ec=script_running(dw)
del(ds,ec)
del(dz,ec)
end
function break_time(ed)
for x=1,ed or 1 do
yield()
end
end
function wait_for_message()
while ee do
yield()
end
end
function say_line(bt,msg,ef,eg)
if type(bt)=="string"then
msg,bt=bt,selected_actor
end
eh=bt
print_line(msg,bt.x,bt.y-bt.h*8+4,bt.col,1,ef,eg)
end
function stop_talking()
ee,eh=nil
end
function print_line(msg,x,y,col,ei,ef,eg)
col=col or 7
ei=ei or 0
local ej=127-(x-cam_x)
if(ei==1) ej=min(x-cam_x,ej)
local ek=max(flr(ej/2),16)
local el=""
for em=1,#msg do
local en=sub(msg,em,em)
if en==":"then
el=sub(msg,em+1)
msg=sub(msg,1,em-1)
break
end
end
local ci=cj(msg,ek)
local ck=cl(ci)
eo=x-cam_x
if(ei==1) eo-=ck*2
local eo,ep=max(2,eo),max(18,y)
eo=min(eo,127-(ck*4)-1)
ee={
eq=ci,
x=eo,
y=ep,
col=col,
ei=ei,
er=eg or#msg*8,
cn=ck,
ef=ef
}
if#el>0 then
es=eh
wait_for_message()
eh=es
print_line(el,x,y,col,ei,ef)
end
wait_for_message()
end
function put_at(bg,x,y,et)
if et then
if not has_flag(bg.classes,"class_actor") then
if(bg.in_room) del(bg.in_room.objects,bg)
add(et.objects,bg)
bg.owner=nil
end
bg.in_room=et
end
bg.x,bg.y=x,y
end
function stop_actor(bt)
bt.eu,bt.curr_anim=0
dt()
end
function walk_to(bt,x,y)
local ev=ew(bt)
local ex,ey=flr(x/8)+room_curr.map[1],flr(y/8)+room_curr.map[2]
local ez={ex,ey}
local fa=fb(ev,ez,{x,y})
bt.eu=1
for fc=1,#fa do
local fd=fa[fc]
local fe=bt.walk_speed*(bt.scale or bt.ff)
local fg,fh=(fd[1]-room_curr.map[1])*8+4,(fd[2]-room_curr.map[2])*8+4
if(fc==#fa and x>=fg-4 and x<=fg+4 and y>=fh-4 and y<=fh+4) fg,fh=x,y
local fi=sqrt((fg-bt.x)^2+(fh-bt.y)^2)
local fj=fe*(fg-bt.x)/fi
local fk=fe*(fh-bt.y)/fi
if fi>0 then
for em=0,fi/fe-1 do
if bt.eu==0 then
return
end
bt.flip=fj<0
if abs(fj)<fe/2 then
bt.curr_anim=fk>0 and bt.walk_anim_front or bt.walk_anim_back
bt.face_dir=fk>0 and"face_front"or"face_back"
else
bt.curr_anim=bt.walk_anim_side
bt.face_dir=bt.flip and"face_left"or"face_right"
end
bt.x+=fj
bt.y+=fk
yield()
end
end
end
bt.eu,bt.curr_anim=2
end
function wait_for_actor(bt)
bt=bt or selected_actor
while bt.eu!=2 do
yield()
end
end
function proximity(bm,bn)
return bm.in_room==bn.in_room and sqrt((bm.x-bn.x)^2+(bm.y-bn.y)^2) or 1000
end
stage_top=16
cam_x,be=0,0
fl,fm,fn,fo=63.5,63.5,0,1
fp={
{spr=ui_uparrowspr,x=75,y=stage_top+60},
{spr=ui_dnarrowspr,x=75,y=stage_top+72}
}
da={
"face_front",
"face_left",
"face_back",
"face_right",
face_front=1,
face_left=2,
face_back=3,
face_right=4
}
function fq(bg)
local fr={}
for eb,bi in pairs(bg) do
add(fr,eb)
end
return fr
end
function get_verb(bg)
local bl,fr={},fq(bg[1])
add(bl,fr[1])
add(bl,bg[1][fr[1]])
add(bl,bg.text)
return bl
end
function dt()
fs,ft,fu,fv,fw,j=get_verb(verb_default),false,""
end
dt()
dz={}
ds={}
cc={}
fx={}
dq,dq=0,0
fy=0
function _init()
poke(0x5f2d,1)
fz()
start_script(startup_script,true)
end
function _update60()
if selected_actor and selected_actor.bz
and not coresume(selected_actor.bz) then
selected_actor.bz=nil
end
ga(dz)
if ce then
if ce.bz
and not coresume(ce.bz) then
if ce.by!=3
and ce.cb
then
camera_follow(ce.cb)
selected_actor=ce.cb
end
del(cc,ce)
if#cc>0 then
ce=cc[#cc]
else
if(ce.by!=2) fy=3
ce=nil
end
end
else
ga(ds)
end
gb()
gc()
gd,ge=1.5-rnd(3),1.5-rnd(3)
gd=flr(gd*be)
ge=flr(ge*be)
if(not bd) be=be>0.05 and be*0.90 or 0
end
function _draw()
cls()
camera(cam_x+gd,0+ge)
clip(
0+dq-gd,
stage_top+dq-ge,
128-dq*2-gd,
64-dq*2)
gf()
camera(0,0)
clip()
if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,stage_top-16,8)
print("mem: "..flr(stat(0)/1024*100).."%",0,stage_top-8,8)
print("x: "..flr(fl+cam_x).." y:"..fm-stage_top,80,stage_top-8,8)
end
gg()
if cg
and cg.cp then
gh()
gi()
return
end
if(fy>0) fy-=1 return
if(not ce) gj()
if(not ce
or ce.by==2)
and fy==0 then
gk()
end
if(not ce) gi()
end
function gl()
gm=stat(34)>0
end
function gb()
if ee and not gm and(btnp(4) or stat(34)==1) then
ee.er,gm=0,true
return
end
if ce then
if(btnp(5) or stat(34)==2) and ce.ca then
ce.bz=cocreate(ce.ca)
ce.ca=nil
return
end
gl()
return
end
if btn(0) then fl-=1 end
if btn(1) then fl+=1 end
if btn(2) then fm-=1 end
if btn(3) then fm+=1 end
if btnp(4) then gn(1) end
if btnp(5) then gn(2) end
go,gp=stat(32)-1,stat(33)-1
if go!=gq then fl=go end
if gp!=gr then fm=gp end
if stat(34)>0 and not gm then
gn(stat(34))
end
gq,gr=go,gp
gl()
end
fl,fm=mid(0,fl,127),mid(0,fm,127)
function gn(gs)
if(not selected_actor) return
if cg and cg.cp then
if(gt) selected_sentence=gt
return
end
if gu then
fs,fv,fw=get_verb(gu)
elseif gv then
if gs==1 then
if fv then
fw=gv
else
fv=gv
end
if(fs[2]==get_verb(verb_default)[2]
and gv.owner) then
fs=get_verb(verbs[verb_default_inventory_index])
end
elseif gw then
fs,fv=get_verb(gw),gv
gj()
end
elseif gx then
if gx==fp[1] then
if(selected_actor.gy>0) selected_actor.gy-=1
else
if selected_actor.gy+2<flr(#selected_actor.dv/4) then
selected_actor.gy+=1
end
end
return
end
local gz=fs[2]
if fv then
if gz=="use"or gz=="give"then
if fw then
elseif fv.use_with and fv.owner==selected_actor then
return
end
end
ft=true
selected_actor.bz=cocreate(function()
if(not fv.owner
and(not has_flag(fv.classes,"class_actor")
or gz!="use"))
or fw
then
ha=fw or fv
hb=get_use_pos(ha)
walk_to(selected_actor,hb.x,hb.y)
if selected_actor.eu!=2 then return end
use_dir=ha
if ha.use_dir then use_dir=ha.use_dir end
do_anim(selected_actor,"face_towards",use_dir)
end
if valid_verb(fs,fv) then
start_script(fv.verbs[fs[1]],false,fv,fw)
else
if has_flag(fv.classes,"class_door") then
local dw=dm[gz]
if(dw) dw(fv,fv.target_door)
else
bk(gz,fv,fw)
end
end
dt()
end)
coresume(selected_actor.bz)
elseif fm>stage_top and fm<stage_top+64 then
ft=true
selected_actor.bz=cocreate(function()
walk_to(selected_actor,fl+cam_x,fm-stage_top)
dt()
end)
coresume(selected_actor.bz)
end
end
function gc()
if(not room_curr) return
gu,gw,gv,gt,gx=nil
if cg and cg.cp then
for ea in all(cg.ch) do
if(hc(ea)) gt=ea
end
return
end
hd()
for bg in all(room_curr.objects) do
if(not bg.classes
or(bg.classes and not has_flag(bg.classes,"class_untouchable")))
and(not bg.dependent_on
or bg.dependent_on.state==bg.dependent_on_state)
then
he(bg,bg.w*8,bg.h*8,cam_x,hf)
else
bg.hg=nil
end
if hc(bg) then
if not gv
or max(bg.z,gv.z)==bg.z
then
gv=bg
end
end
hh(bg)
end
for eb,bt in pairs(actors) do
if bt.in_room==room_curr then
he(bt,bt.w*8,bt.h*8,cam_x,hf)
hh(bt)
if(hc(bt) and bt!=selected_actor) gv=bt
end
end
if selected_actor then
for bi in all(verbs) do
if(hc(bi)) gu=bi
end
for hi in all(fp) do
if(hc(hi)) gx=hi
end
for eb,bg in pairs(selected_actor.dv) do
if hc(bg) then
gv=bg
if(fs[2]=="pickup"and gv.owner) fs=nil
end
if(bg.owner!=selected_actor) del(selected_actor.dv,bg)
end
fs=fs or get_verb(verb_default)
gw=gv and bf(gv) or gw
end
end
function hd()
for x=-64,64 do
fx[x]={}
end
end
function hh(bg)
add(fx[bg.z and bg.z or flr(bg.y+(bg.hj and 0 or bg.h*8))],bg)
end
function gf()
if not room_curr then
print("-error-  no current room set",5+cam_x,5+stage_top,8,0)
return
end
rectfill(0,stage_top,127,stage_top+64,room_curr.hk or 0)
for z=-64,64 do
if z==0 then
hl(room_curr)
if room_curr.trans_col then
palt(0,false)
palt(room_curr.trans_col,true)
end
map(room_curr.map[1],room_curr.map[2],0,stage_top,room_curr.hm,room_curr.hn)
pal()
else
ho=fx[z]
for bg in all(ho) do
if not has_flag(bg.classes,"class_actor") then
if bg.states
or(bg.state
and bg[bg.state]
and bg[bg.state]>0)
and(not bg.dependent_on
or bg.dependent_on.state==bg.dependent_on_state)
and not bg.owner
or bg.draw
or bg.curr_anim
then
hp(bg)
end
else
if(bg.in_room==room_curr) hq(bg)
end
end
end
end
end
function hl(bg)
if bg.col_replace then
fc=bg.col_replace
pal(fc[1],fc[2])
end
if bg.lighting then
hr(bg.lighting)
elseif bg.in_room and bg.in_room.lighting then
hr(bg.in_room.lighting)
end
end
function hp(bg)
local hs=0
hl(bg)
if bg.draw then
bg.draw(bg)
else
if bg.curr_anim then
ht(bg)
hs=bg.curr_anim[bg.db]
end
for h=0,bg.repeat_x and bg.repeat_x-1 or 0 do
if bg.states then
hs=bg.states[bg.state]
elseif hs==0 then
hs=bg[bg.state]
end
hu(hs,bg.x+(h*(bg.w*8)),bg.y,bg.w,bg.h,bg.trans_col,bg.flip_x,bg.scale)
end
end
pal()
end
function hq(bt)
local hv,hs=da[bt.face_dir]
if bt.curr_anim
and(bt.eu==1 or cr(bt.curr_anim))
then
ht(bt)
hs=bt.curr_anim[bt.db]
else
hs=bt.idle[hv]
end
hl(bt)
local hw=(bt.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1])
hw=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*hw
bt.ff=mid(room_curr.autodepth_scale[1],hw,room_curr.autodepth_scale[2])
local scale=bt.scale or bt.ff
local hx,hy=(8*bt.h),(8*bt.w)
local hz=hx-(hx*scale)
local ia=hy-(hy*scale)
local ib=bt.ct+flr(ia/2)
local ic=bt.hj+hz
hu(hs,
ib,
ic,
bt.w,
bt.h,
bt.trans_col,
bt.flip,
false,
scale)
if eh
and eh==bt
and eh.talk
then
if bt.id<7 then
hu(bt.talk[hv],
ib+(bt.talk[5] or 0),
ic+flr((bt.talk[6] or 8)*scale),
(bt.talk[7] or 1),
(bt.talk[8] or 1),
bt.trans_col,
bt.flip,
false,
scale)
end
bt.id=bt.id%14+1
end
pal()
end
function gj()
local ie,ig,ih=verb_maincol,fs[2],fs and fs[3] or""
if fv then
ih=ih.." "..fv.name
if ig=="use"and(not ft or fw) then
ih=ih.." with"
elseif ig=="give"then
ih=ih.." to"
end
end
if fw then
ih=ih.." "..fw.name
elseif gv
and gv.name!=""
and(not fv or(fv!=gv))
and not ft
then
if gv.owner
and ig==get_verb(verb_default)[2] then
ih="look-at"
end
ih=ih.." "..gv.name
end
fu=ih
if ft then
ih=fu
ie=verb_hovcol
end
print(ii(ih),ij(ih),stage_top+66,ie)
end
function gg()
if ee then
local ik=0
for il in all(ee.eq) do
local im=0
if ee.ei==1 then
im=((ee.cn*4)-(#il*4))/2
end
outline_text(
il,
ee.x+im,
ee.y+ik,
ee.col,
0,
ee.ef)
ik+=6
end
ee.er-=1
if(ee.er<=0) stop_talking()
end
end
function gk()
local eo,ep,io=0,75,0
for bi in all(verbs) do
local ip=bi==gu and verb_hovcol or
(gw and bi==gw and verb_defcol or
verb_maincol)
local bj=get_verb(bi)
print(bj[3],eo,ep+stage_top+1,verb_shadcol)
print(bj[3],eo,ep+stage_top,ip)
bi.x=eo
bi.y=ep
he(bi,#bj[3]*4,5,0,0)
if(#bj[3]>io) io=#bj[3]
ep+=8
if ep>=95 then
ep=75
eo+=(io+1.0)*4
io=0
end
end
if selected_actor then
eo,ep=86,76
local iq=selected_actor.gy*4
local ir=min(iq+8,#selected_actor.dv)
for is=1,8 do
rectfill(eo-1,stage_top+ep-1,eo+8,stage_top+ep+8,verb_shadcol)
bg=selected_actor.dv[iq+is]
if bg then
bg.x,bg.y=eo,ep
hp(bg)
he(bg,bg.w*8,bg.h*8,0,0)
end
eo+=11
if eo>=125 then
ep+=12
eo=86
end
is+=1
end
for em=1,2 do
it=fp[em]
pal(7,gx==it and verb_hovcol or verb_maincol)
pal(5,verb_shadcol)
hu(it.spr,it.x,it.y,1,1,0)
he(it,8,7,0,0)
pal()
end
end
end
function gh()
local eo,ep=0,70
for ea in all(cg.ch) do
if ea.cn>0 then
ea.x,ea.y=eo,ep
he(ea,ea.cn*4,#ea.ci*5,0,0)
local ip=ea==gt and cg.co or cg.col
for il in all(ea.ci) do
print(ii(il),eo,ep+stage_top,ip)
ep+=5
end
ep+=2
end
end
end
function gi()
col=ui_cursor_cols[fo]
pal(7,col)
spr(ui_cursorspr,fl-4,fm-3,1,1,0)
pal()
fn+=1
if fn>7 then
fn=1
fo=fo%#ui_cursor_cols+1
end
end
function hu(iu,x,y,w,h,iv,flip_x,iw,scale)
set_trans_col(iv)
iu=iu or 0
local ix,iy=8*(iu%16),8*flr(iu/16)
local iz,ja=8*w,8*h
local jb=scale or 1
local jc,jd=iz*jb,ja*jb
sspr(ix,iy,iz,ja,x,stage_top+y,jc,jd,flip_x,iw)
end
function set_trans_col(iv)
palt(0,false)
palt(iv,true)
end
function fz()
for et in all(rooms) do
je(et)
et.hm=#et.map>2 and et.map[3]-et.map[1]+1 or 16
et.hn=#et.map>2 and et.map[4]-et.map[2]+1 or 8
et.autodepth_pos=et.autodepth_pos or{9,50}
et.autodepth_scale=et.autodepth_scale or{0.25,1}
for bg in all(et.objects) do
je(bg)
bg.in_room,bg.h=et,bg.h or 0
if(bg.init) bg.init(bg)
end
end
for jf,bt in pairs(actors) do
je(bt)
bt.eu=2
bt.dc=1
bt.id=1
bt.db=1
bt.dv={
}
bt.gy=0
end
end
function ga(scripts)
for ec in all(scripts) do
if ec[2] and not coresume(ec[2],ec[3],ec[4]) then
del(scripts,ec)
end
end
end
function hr(jg)
if(jg) jg=1-jg
local fd=flr(mid(0,jg,1)*100)
local jh={0,1,1,2,1,13,6,
4,4,9,3,13,1,13,14}
for ji=1,15 do
col=ji
jj=(fd+(ji*1.46))/22
for eb=1,jj do
col=jh[col]
end
pal(ji,col)
end
end
function cr(t)
return type(t)=="table"
end
function bs(bp)
return mid(0,(cr(bp) and bp.x or bp)-64,(room_curr.hm*8)-128)
end
function ew(bg)
return{flr(bg.x/8)+room_curr.map[1],flr(bg.y/8)+room_curr.map[2]}
end
function jk(ex,ey)
return fget(mget(ex,ey),0)
end
function cj(msg,ek)
local ci,jl,jm,en={},"","",""
local function jn(jo)
if#jm+#jl>jo then
add(ci,jl)
jl=""
end
jl=jl..jm
jm=""
end
for em=1,#msg do
en=sub(msg,em,em)
jm=jm..en
if en==" "or#jm>ek-1 then
jn(ek)
elseif#jm>ek-1 then
jm=jm.."-"
jn(ek)
elseif en==";"then
jl=jl..sub(jm,1,#jm-1)
jm=""
jn(0)
end
end
jn(ek)
if(jl!="") add(ci,jl)
return ci
end
function cl(ci)
local ck=0
for il in all(ci) do
if(#il>ck) ck=#il
end
return ck
end
function has_flag(bg,jp)
for jq in all(bg) do
if(jq==jp) return true
end
end
function he(bg,w,h,jr,js)
local x,y=bg.x,bg.y
if has_flag(bg.classes,"class_actor") then
bg.ct=x-(bg.w*8)/2
bg.hj=y-(bg.h*8)+1
x=bg.ct
y=bg.hj
end
bg.hg={
x=x,
y=y+stage_top,
jt=x+w-1,
ju=y+h+stage_top-1,
jr=jr,
js=js
}
end
function fb(jv,jw)
local jx,jy,jz,ka,kb,kc={},{},{}
kd(jx,jv,0)
jz[ke(jv)]=0
while#jx>0 and#jx<1000 do
kc=jx[#jx][1]
del(jx,jx[#jx])
if(ke(kc)==ke(jw)) break
local kf={}
for x=-1,1 do
for y=-1,1,x==0 and 2 or 1 do
local kg,kh=kc[1]+x,kc[2]+y
if kg>=room_curr.map[1] and kg<=room_curr.map[1]+room_curr.hm
and kh>=room_curr.map[2] and kh<=room_curr.map[2]+room_curr.hn
and jk(kg,kh)
and((abs(x)!=abs(y))
or jk(kg,kc[2])
or jk(kg-x,kh)
or enable_diag_squeeze)
then
local ki={kg,kh}
local kj=ke(ki)
local kk=jz[ke(kc)]+(x*y==0 and 1 or 1.414)
if not jz[kj] or kk<jz[kj] then
jz[kj]=kk
local h=max(abs(jw[1]-kg),abs(jw[2]-kh))+min(abs(jw[1]-kg),abs(jw[2]-kh))*.414
kd(jx,ki,kk+h)
jy[kj]=kc
if not ka or h<ka then
ka=h
kb=kj
kl=ki
end
end
end
end
end
end
local fa={}
kc=jy[ke(jw)]
if kc then
add(fa,jw)
elseif kb then
kc=jy[kb]
add(fa,kl)
end
if kc then
local km,kn=ke(kc),ke(jv)
while km!=kn do
add(fa,kc)
kc=jy[km]
km=ke(kc)
end
for em=1,#fa/2 do
local ko=fa[em]
local kp=#fa-(em-1)
fa[em]=fa[kp]
fa[kp]=ko
end
end
return fa
end
function kd(t,bp,fd)
local kq={bp,fd}
if#t>=1 then
for em=#t+1,2,-1 do
local ki=t[em-1]
if fd<ki[2] then
t[em]=kq
return
else
t[em]=ki
end
end
end
t[1]=kq
end
function ke(kr)
return((kr[1]+1)*16)+kr[2]
end
function ht(bg)
bg.dc+=1
if bg.dc>bg.frame_delay then
bg.dc=1
bg.db=bg.db%#bg.curr_anim+1
end
end
function di(msg)
print_line("-error-;"..msg,5+cam_x,5,8,0)
end
function je(bg)
for il in all(split(bg.data,"\n")) do
local pairs=split(il,"=")
if#pairs==2 then
bg[pairs[1]]=ks(pairs[2])
else
printh(" > invalid data: ["..pairs[1].."]")
end
end
end
function split(ea,kt)
local ku,iq,kv={},0,0
for em=1,#ea do
local kw=sub(ea,em,em)
if kw==kt then
add(ku,sub(ea,iq,kv))
iq,kv=0,0
elseif kw!=" "
and kw!="\t"then
kv,iq=em,iq==0 and em or iq
end
end
if iq+kv>0 then
add(ku,sub(ea,iq,kv))
end
return ku
end
function ks(kx)
local ky=sub(kx,1,1)
if kx=="true"then
return true
elseif kx=="false"then
return false
elseif tonum(kx) then
return tonum(kx)
elseif ky=="{"then
local ko=sub(kx,2,#kx-1)
kz={}
for bp in all(split(ko,",")) do
add(kz,ks(bp))
end
return kz
else
return kx
end
end
function outline_text(la,x,y,lb,lc,ef)
if(not ef) la=ii(la)
for ld=-1,1 do
for le=-1,1,ld==0 and 2 or 1 do
print(la,x+ld,y+le,lc)
end
end
print(la,x,y,lb)
end
function ij(ea)
return 63.5-flr(#ea*2)
end
function hc(bg)
if(not bg.hg or ce) return false
local hg=bg.hg
return not((fl+hg.jr>hg.jt or fl+hg.jr<hg.x)
or(fm>hg.ju or fm<hg.y))
end
function ii(ea)
local lf,il,fc,t=""
for em=1,#ea do
local hi=sub(ea,em,em)
if hi=="^"then
if(fc) lf=lf..hi
fc=not fc
elseif hi=="~"then
if(t) lf=lf..hi
t,il=not t,not il
else
if fc==il and hi>="a"and hi<="z"then
for ji=1,26 do
if hi==sub("etaoinsrhldcumfgpwybvkjxz",ji,ji) then
hi=sub("ETAOINSRHLDCUMFGPWYBVKJXZQ",ji,ji)
break
end
end
end
lf=lf..hi
fc,t=nil
end
end
return lf
end


__gfx__
0000000000000000000000000000000044444444440000004444444477777777f9e9f9f9ddd5ddd5bbbbbbbb5500000010101010000000000000000000000000
00000000000000000000000000000000444444404400000044444444777777779eee9f9fdd5ddd5dbbbbbbbb5555000001010101000000000000000000000000
00800800000000000000000000000000aaaaaa00aaaa000005aaaaaa77777777feeef9f9d5ddd5ddbbbbbbbb5555550010101010000000000000000000000000
0008800055555555ddddddddeeeeeeee999990009999000005999999777777779fef9fef5ddd5dddbbbbbbbb5555555501010101000000000000000000000000
0008800055555555ddddddddeeeeeeee44440000444444000005444477777777f9f9feeeddd5ddd5bbbbbbbb5555555510101010000000000000000000000000
0080080055555555ddddddddeeeeeeee444000004444440000054444777777779f9f9eeedd5ddd5dbbbbbbbb5555555501010101000000000000000000000000
0000000055555555ddddddddeeeeeeeeaa000000aaaaaaaa000005aa77777777f9f9feeed5ddd5ddbbbbbbbb5555555510101010000000000000000000000000
0000000055555555ddddddddeeeeeeee900000009999999900000599777777779f9f9fef5ddd5dddbbbbbbbb5555555501010101000000000000000000000000
0000000077777755666666ddbbbbbbee888888553333333313131344666666665888858866666666cbcbcbcb0000005510101044999999990000000088845888
00000000777755556666ddddbbbbeeee88888855333333333131314466666666588885881c1c1c1cbcbcbcbc0000555501010144444444440000000088845888
000010007755555566ddddddbbeeeeee88887777333333331313aaaa6666666655555555c1c1c1c1cbcbcbcb005555551010aaaa000450000000000088845888
0000c00055555555ddddddddeeeeeeee88886666333333333131999966666666888588881c1c1c1cbcbcbcbc5555555501019999000450000000000088845888
001c7c1055555555ddddddddeeeeeeee8855555533333333134444446666666688858888c1c1c1c1cbcbcbcb5555555510444444000450000000000088845888
0000c00055555555ddddddddeeeeeeee88555555333333333144444466666666555555551c1c1c1cbcbcbcbc5555555501444444000450000000000088845888
0000100055555555ddddddddeeeeeeee7777777733333333aaaaaaaa6666666658888588c1c1c1c1cbcbcbcb55555555aaaaaaaa000450000000000088845888
0000000055555555ddddddddeeeeeeee66666666333333339999999966666666588885887c7c7c7cbcbcbcbc5555555599999999000450000000000088845888
0000000055777777dd666666eebbbbbb558888885555555544444444777777777777777755555555444444454444444444444445000450008888888999999999
0000000055557777dddd6666eeeebbbb5588888855553333444444447777777777777777555555554444445c4444444444444458000450008888889444444444
0000000055555577dddddd66eeeeeebb7777888855333333aaaaaaaa777777777777777755555555444445cbaaaaaa4444444588000450008888894888845888
000c000055555555ddddddddeeeeeeee66668888533333339999999977777777777777775555555544445cbc9999994444445888000450008888948888845888
0000000055555555ddddddddeeeeeeee5555558853333333444444447777775555777777555555554445cbcb4444444444458888000450008889488888845888
0000000055555555ddddddddeeeeeeee555555885533333344444444777755555555777755555555445cbcbc4444444444588888000450008894588888845888
0000000055555555ddddddddeeeeeeee7777777755553333aaaaaaaa77555555555555770000000045cbcbcbaa44444445888888999999998944588888845888
0000000055555555ddddddddeeeeeeee6666666655555555999999995555555555555555000000005cbcbcbc9944444458888888555555559484588888845888
0000000055555555ddddddddbbbbbbbb555555555555555544444444cccccccc5555555677777777c77777776555555533333336633333338884588988845888
0000000055555555ddddddddbbbbbbbb555555553333555544444444cccccccc555555677777777ccc7777777655555533333367763333338884589488845888
0000000055555555ddddddddbbbbbbbb7777777733333355aaaaaa50cccccccc55555677777777ccccc777777765555533333677776333338884594488845888
0000000055555555ddddddddbbbbbbbb666666663333333599999950cccccccc5555677777777ccccccc77777776555533336777777633338884944488845888
0000000055555555ddddddddbbbbbbbb555555553333333544445000cccccccc555677777777ccccccccc7777777655533367777777763338889444488845888
0000000055555555ddddddddbbbbbbbb555555553333335544445000cccccccc55677777777ccccccccccc777777765533677777777776338894444488845888
0b03000055555555ddddddddbbbbbbbb7777777733335555aa500000cccccccc5677777777ccccccccccccc77777776536777777777777638944444499999999
b00030b055555555ddddddddbbbbbbbb666666665555555599500000cccccccc677777777ccccccccccccccc7777777667777777777777769444444455555555
00000000000000000000000000000000777777777777777777555555555555770000000000000000000000000000000000000000d00000004444444444444444
9f00d70000c0006500c0096500000000700000077000000770700000000007070000000000000000000000000000000000000000d50000004ffffff44ffffff4
9f2ed728b3c55565b3c5596500000000700000077000000770070000000070070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728b3c50565b3c5946500000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728b3c50565b3c5946500000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728b3c55565b3c9456500000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
9f2ed728b3c55565b3c9456500000000700000077000000770006000000600070000000000000000000000000000000000000000d51000004f4444944f444494
44444444444444444444444400000000777777777777777777776000000677770000000000000000000000000000000000000000d51000004f4444944f444494
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2302ffff2302ff0000000000007aa0fff76fff00000094
00000000000000000000000000000000000000000000000000000000000000000000000000000000ffb33bffffb33bff00000000000070a0fff76fff00000944
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff000000000000aaa0f8888bbf00009440
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2222ffff2222ff00000000000a4440888bbbbc00094400
00000000000000000000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff0000000000a40000fbbbbbcf00044000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f2b33b2ff2b33b2f000000000a400000fbbbcccf00400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f22bb22ff2b33b2f0000000074a90000fff00fff94000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000f222222ff22bb22f00000000007a0000fff00fff44000000
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
000000000fdffdf00fdffdf00fdffdf004f0fdfb04f0fdfb04f0fdfb444444444444444444444444000000000000000000000000000000000000000000000000
000770000f5ff5f00f5ff5f00f5ff5f000fff5fb00fff5fb00fff5fb444444404444444044444440bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
007557004ffffff44ffffff44ffffff440ffffff40ffffff40ffffff044444440444444404444444bffffffbbbbbbbbbbbbbbbbb000000000000000000000000
07500570bff44ffbbff44ffbbff44ffbb0fffff4b0fffff4b0fffff4b044444bb044444bb044444bbff44ffbbbfffffbbbbbbbbb000000000000000000000000
77700777b6ffff6bb6ffff6bb6ffff6bb6fffffbb6fffffbb6fffffbb044444bb044444bb044444bb6ffff6bbbfffffbbbbbbbbb000000000000000000000000
00700700bbfddfbbbbfddfbbbbfddfbbbb6fffdbbb6fffdbbb6fffdbbb0000bbbb0000bbbb0000bbbbf00fbbbb6ff00bbbbbbbbb000000000000000000000000
00700700bbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbf00fbbbbbff00bbbbbbbbb000000000000000000000000
00777700bdc55cdbbdc55cdbbdc55cdbbbddcbbbbbbddbbbbbddcbbbbddddddbbddddddbbddddddbbbbffbbbbbbbfffbbbbbbbbb000000000000000000000000
00555500dcc55ccddcc55ccddcc55ccdb1ccdcbbbb1ccdbbb1ccdcbbdccccccddccccccddccccccdbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
00070000c1c66c1cc1c66c1dd1c66c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1cc1cccc1dd1cccc1c000000000000000000000000000000000000000000000000
00070000c1c55c1cc1c55c1dd1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1cc1cccc1dd1cccc1c000000000000000000000000000000000000000000000000
00070000c1c55c1ccc155c1dd1c551ccb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1ccc1ccc1dd1ccc1cc000000000000000000000000000000000000000000000000
77707770c1c55c1ccc155c1dd1c551ccb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1ccc1ccc1dd1ccc1cc000000000000000000000000000000000000000000000000
00070000d1cddc1dbc1ddcdbbdcdd1cbb1dddcbbbb1dddbbb1dddcbbd1cccc1dbc1cccdbbdccc1cb000000000000000000000000000000000000000000000000
00070000fe1111efbfe1112bb2111efbbbff11bbbb2ff1bbbbff11bbfe1111efbfe1112bb2111efb000000000000000000000000000000000000000000000000
00070000bf1111fbbff111ebbe111ffbbbfe11bbbb2fe1bbbbfe11bbbf1111fbbff111ebbe111ffb000000000000000000000000000000000000000000000000
00000000bb1121bbbb1121bbbb1121bbbb2111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00777700bb1121bbbb1121bbbb1121bbbb1111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00755700bb1121bbbb1121bbbb1121bbbb1111bbbb2111bbbb2111bbbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
00700700bb1121bbbb1121bbbb1121bbbb1112bbbb2111bbbb21111bbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
77700777bb1121bbbb1121bbbb1121bbbb1112bbbb2111bbbb22111bbb1211bbbb1211bbbb1211bb000000000000000000000000000000000000000000000000
57500575bb1121bbbb1121bbbb1121bbb111122bbb2111bbb222111bbb1211bbbb121cbbbbc211bb000000000000000000000000000000000000000000000000
05700750bb1121bbbb1121bbbb1121bbc111222bbb2111bbb22211ccbb1211bbbb12cc7bb7cc11bb000000000000000000000000000000000000000000000000
00577500bbccccbbbb77c77bb77c77bb7ccc222bbbccccbbb222cc77bbccccbbbbcc677bb776ccbb000000000000000000000000000000000000000000000000
00055000b776677bbbbb677bb776bbbbb7776666bb6777bbb66677bbb776677bbb77bbbbbbbb77bb000000000000000000000000000000000000000000000000
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
0000000000000000002000000000002007070717171717171717171717070707070707080808080808614858485863080808080808070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0020000000000000000000000010000007070717171717171717171717070707070707080808080808715848584873080808080808070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
0000002000000000000000000000000007000717171717171717171717070007070007080808000808714858485873080800080808070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007070007626262006262716667666773626200626262070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000000007000717171717171717171717070007070007747474007474717677767773747400747474070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
0000000000000000000000000000200007011131313131313131313131210107070111313131313131313131313131313131313131210107000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
0000000000100000002000000000000011313131313131313131313131313121113131313131312515151515151515353131313131313121000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
2000000000000000000020000000000031313131313131313131313131313131312f2f2f2f2f2f2f2f2f3131312f2f2f2f2f2f2f2f2f2f2f000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
000000100000200000001f0061626262626262626262626262626263001f0010070707080808080808080808080808080808080808070707070707405040504050405040504050405040504050070707171717090909090909090909090909090909090909171717000000100000616262626262626262626262626200000010
002000000000001000001f2071447144714473004e71447344734473001f200007070708080808080808080808080808080808080807070707070750405040504050405040504050405040504007070717171709090909090909444444450909090909090917171700200000002071447474744473b271447474447400002000
200000000020000000201f0071647164716473005e71647364736473201f000007000708080808004e080808080808080808080808070007070707405040504050405040504050404e00504050070707170017656565656565655464645565656565656565170017182f2f2f2f2f71647474746473b27164747464742f2f2f2f
000020000000000020001f0062626262626273006e71626262626263001f002007000760606060005e606060606060606060606060070007070707606060606060606162636060607e00606060070707170017666766676667666766676667666766676667170017183f3f3f3f3f61747474747473b27174747474743f3f3f3f
303030303030303030301b3131313131313131253531313131313131310b303007000770707070006e707070707070707070707070070007070707707070707070707172737070706e00707070070707170017767776777677767776777677767776777677170017151515151515151515151515151515151515151515151515
151515151515151515151818181818181818343434341818181818181818151507011131313131313131313131313131313131313121010707271131313131313131313131313131313131313121280717021232323232323232323232323232323232323222021715153c191919191919191919343434191919193d15151515
1515151515151515151515151515151515143434343424151515151515151515113131313131312515151515151515353131313131313121113131313131312515151515151515353131313131313121123232323232323232323232323232323232323232323222153c3937373737378e373737373737373737373a3d151515
15151515151515151515151515151515151515151515151515151515151515153131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313232323232323232323232323232323232323232323232323c393737373737373737373737373737373737373a3d1515
