pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- adv-jam-2018
-- paul nicholas


-- debugging
show_debuginfo = false
show_collision = false
show_pathfinding = false
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

-- [ liquidream logo "room" ]
	rm_liquidream = {
		data = [[
			map = {0,8}
		]],
		objects = {
		},
		enter = function(me)
   -- switch gfx
   load_gfx_page(0)
			t=0
			cutscene(
				3, -- no verbs & no follow, 
				function()
					break_time(150)
					change_room(rm_scumm, 1) -- iris fade
				end) -- end cutscene
		end
	}

-- [ scumm-8 logo "room" ]
	-- objects
  obj_scumm8_logo = {
    data = [[
     x=1
     y=1
     classes = {class_untouchable}
    ]],
    draw = function(me)
     -- draw logo
     sspr(48, 8, 32, 8, 32, 56,   64,16)
    end,
   }
	
	rm_scumm = {
		data = [[
			map = {0,0}
		]],
		objects = {
			obj_scumm8_logo
		},
		enter = function(me)
   -- switch gfx
   load_gfx_page(1)
			t=0
			cutscene(
				3, -- no verbs & no follow, 
				function()
					print_line("powered by",64,48,7,1, false, 175)
     -- fade out, using "iris" transition
     fades(1, 1)
					--change_room(rm_crash, 1) -- iris fade

     print_line("music by; ;chris (gruber) donnelly",64,50,7,1,false,100)
         
     -- load the game cart
     load("_game-pt1")
				end) -- end cutscene
		end
	}




--
-- [ "the void" (room) ]
-- a place to put objects/actors when not in a room	
	-- objects

	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
		},
	}




-- 
-- active rooms list
-- 
rooms = {
	rm_void,
	rm_liquidream,
	rm_scumm,
}



--
-- actor definitions
-- 

	-- -- initialize the player's actor object
	-- main_actor = { 	
	-- 	data = [[
	-- 		name = humanoid
	-- 		w = 1
	-- 		h = 4
	-- 		idle = { 65, 69, 71, 69 }
	-- 		talk = { 90, 91, 92, 91 }
	-- 		walk_anim_side = { 68, 69, 70, 69 }
	-- 		walk_anim_front = { 66, 65, 67, 65 }
	-- 		walk_anim_back = { 72, 71, 73, 71 }
	-- 		col = 7
	-- 		trans_col = 11
	-- 		walk_speed = 0.6
	-- 		frame_delay = 5
	-- 		classes = {class_actor}
	-- 		face_dir = face_front
	-- 	]],
	-- 	-- sprites for directions (front, left, back, right) - note: right=left-flipped
	-- 	inventory = {
	-- 		--obj_switch_tent
	-- 	},
	-- 	verbs = {
	-- 		use = function(me)
	-- 			selected_actor = me
	-- 			camera_follow(me)
	-- 		end
	-- 	}
	-- }


-- 
-- active actors list
-- 
actors = {
	main_actor,
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	change_room(rm_liquidream, 1) -- iris fade

 -- reset all game state
 cartdata("pn_code8")
 for d=0,63 do
  dset(d,0)
 end

 -- ########################################
 -- testing
 --
    -- dset(20,1) --main_actor.fixed_ship
    -- dset(22,1) --main_actor.disabled_signal = true
    -- dset(23,1) --main_actor.engine_cover_replaced = true
    -- dset(24,1) --main_actor.crystal_replaced = true
 -- 
 -- ######################################## 

 music(1)

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
gu() end end function gn() if cr then
if(btnp(5) or stat(34)>0)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end return end if btn(0) then fv-=1 end
if btn(1) then fv+=1 end
if btn(2) then fw-=1 end
if btn(3) then fw+=1 end
if btnp(4) then gx(1) end
if btnp(5) then gx(2) end
if enable_mouse then
gy,gz=stat(32)-1,stat(33)-1 if gy!=ha then fv=gy end
if gz!=hb then fw=gz end
if stat(34)>0 then
if not hc then
gx(stat(34)) hc=true end else hc=false end ha=gy hb=gz end fv=mid(0,fv,127) fw=mid(0,fw,127) end function gx(hd) local he=gc if not selected_actor then
return end if ct and ct.cv then
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
elseif gd.use_with and gd.owner==selected_actor then return end end gf=true selected_actor.cn=cocreate(function() if(not gd.owner
and(not has_flag(gd.classes,"class_actor") or gc[2]!="use")) or ge then hl=ge or gd hm=get_use_pos(hl) walk_to(selected_actor,hm.x,hm.y) if selected_actor.fd!=2 then return end
use_dir=hl if hl.use_dir then use_dir=hl.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gc,gd) then
start_script(gd.verbs[gc[1]],false,gd,ge) else if has_flag(gd.classes,"class_door") then
if gc[2]=="walkto"then
come_out_door(gd,gd.target_door) elseif gc[2]=="open"then open_door(gd,gd.target_door) elseif gc[2]=="close"then close_door(gd,gd.target_door) end else by(gc[2],gd,ge) end end ec() end) coresume(selected_actor.cn) elseif fw>fu and fw<fu+64 then gf=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fv+cam_x,fw-fu) ec() end) coresume(selected_actor.cn) end end function go() if not room_curr then
return end hg,hi,hh,hf,hj=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if hn(ej) then
hf=ej end end return end ho() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hp(bu,bu.w*8,bu.h*8,cam_x,hq) else bu.hr=nil end if hn(bu) then
if not hh
or(not bu.z and hh.z<0) or(bu.z and hh.z and bu.z>hh.z) then hh=bu end end hs(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hp(ch,ch.w*8,ch.h*8,cam_x,hq) hs(ch) if hn(ch)
and ch!=selected_actor then hh=ch end end end if selected_actor then
for bw in all(verbs) do if hn(bw) then
hg=bw end end for ht in all(fz) do if hn(ht) then
hj=ht end end for ek,bu in pairs(selected_actor.bo) do if hn(bu) then
hh=bu if gc[2]=="pickup"and hh.owner then
gc=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if gc==nil then
gc=get_verb(verb_default) end if hh then
hi=bt(hh) end end end function ho() gh={} for x=-64,64 do gh[x]={} end end function hs(bu) eq=-1 if bu.hu then
eq=bu.y else eq=bu.y+(bu.h*8) end hv=flr(eq) if bu.z then
hv=bu.z end add(gh[hv],bu) end function gr() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fu,8,0) return end rectfill(0,fu,127,fu+64,room_curr.hw or 0) for z=-64,64 do if z==0 then
hx(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fu,room_curr.hy,room_curr.hz) pal() else hv=gh[z] for bu in all(hv) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then ia(bu) end else if bu.in_room==room_curr then
ib(bu) end end ic(bu) end end end end function hx(bu) if bu.col_replace then
id=bu.col_replace pal(id[1],id[2]) end if bu.lighting then
ie(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ie(bu.in_room.lighting) end end function ia(bu) hx(bu) if bu.draw then
bu.draw(bu) else ig=1 if bu.repeat_x then ig=bu.repeat_x end
for h=0,ig-1 do local ih=0 if bu.states then
ih=bu.states[bu.state] else ih=bu[bu.state] end ii(ih,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x,bu.scale) end end pal() end function ib(ch) ij=dl[ch.face_dir] if ch.fd==1
and ch.ft then ch.ik+=1 if ch.ik>ch.frame_delay then
ch.ik=1 ch.il+=1 if ch.il>#ch.ft then ch.il=1 end
end im=ch.ft[ch.il] else im=ch.idle[ij] end hx(ch) local fm=mid(room_curr.min_autoscale or 0,(ch.y+12)/64,1) fm*=(room_curr.autoscale_zoom or 1) local scale=ch.scale or fm local io=(8*ch.h) local ip=(8*ch.w) local iq=io-(io*scale) local ir=ip-(ip*scale) ii(im,ch.de+flr(ir/2),ch.hu+iq,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if er
and er==ch and er.talk then if ch.is<7 then
im=ch.talk[ij] ii(im,ch.de+flr(ir/2),ch.hu+flr(8*scale)+iq,1,1,ch.trans_col,ch.flip,false,scale) end ch.is+=1 if ch.is>14 then ch.is=1 end
end pal() end function gv() it=""iu=verb_maincol iv=gc[2] if gc then
it=gc[3] end if gd then
it=it.." "..gd.name if iv=="use"then
it=it.." with"elseif iv=="give"then it=it.." to"end end if ge then
it=it.." "..ge.name elseif hh and hh.name!=""and(not gd or(gd!=hh)) and(not hh.owner or iv!=get_verb(verb_default)[2]) then it=it.." "..hh.name end gg=it if gf then
it=gg iu=verb_hovcol end print(iw(it),ix(it),fu+66,iu) end function gs() if en then
iy=0 for iz in all(en.ez) do ja=0 if en.es==1 then
ja=((en.db*4)-(#iz*4))/2 end outline_text(iz,en.x+ja,en.y+iy,en.col,0,en.eo) iy+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gw() ey,eq,jb=0,75,0 for bw in all(verbs) do jc=verb_maincol if hi
and bw==hi then jc=verb_defcol end if bw==hg then jc=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fu+1,verb_shadcol) print(bx[3],ey,eq+fu,jc) bw.x=ey bw.y=eq hp(bw,#bx[3]*4,5,0,0) ic(bw) if#bx[3]>jb then jb=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(jb+1.0)*4 jb=0 end end if selected_actor then
ey,eq=86,76 jd=selected_actor.hk*4 je=min(jd+8,#selected_actor.bo) for jf=1,8 do rectfill(ey-1,fu+eq-1,ey+8,fu+eq+8,verb_shadcol) bu=selected_actor.bo[jd+jf] if bu then
bu.x,bu.y=ey,eq ia(bu) hp(bu,bu.w*8,bu.h*8,0,0) ic(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end jf+=1 end for ew=1,2 do jg=fz[ew] if hj==jg then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ii(jg.spr,jg.x,jg.y,1,1,0) hp(jg,8,7,0,0) ic(jg) pal() end end end function gt() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hp(ej,ej.db*4,#ej.cw*5,0,0) jc=ct.col if ej==hf then jc=ct.dc end
for iz in all(ej.cw) do print(iw(iz),ey,eq+fu,jc) eq+=5 end ic(ej) eq+=2 end end end function gu() col=ui_cursor_cols[fy] pal(7,col) spr(ui_cursorspr,fv-4,fw-3,1,1,0) pal() fx+=1 if fx>7 then
fx=1 fy+=1 if fy>#ui_cursor_cols then fy=1 end
end end function ii(jh,x,y,w,h,ji,flip_x,jj,scale) set_trans_col(ji,true) local jk=8*(jh%16) local jl=8*flr(jh/16) local jm=8*w local jn=8*h local jo=scale or 1 local jp=jm*jo local jq=jn*jo sspr(jk,jl,jm,jn,x,fu+y,jp,jq,flip_x,jj) end function set_trans_col(ji,bq) palt(0,false) palt(ji,true) if ji and ji>0 then
palt(0,false) end end function gj() for fc in all(rooms) do jr(fc) if(#fc.map>2) then
fc.hy=fc.map[3]-fc.map[1]+1 fc.hz=fc.map[4]-fc.map[2]+1 else fc.hy=16 fc.hz=8 end for bu in all(fc.objects) do jr(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for js,ch in pairs(actors) do jr(ch) ch.fd=2 ch.ik=1 ch.is=1 ch.il=1 ch.bo={} ch.hk=0 end end function ic(bu) local jt=bu.hr if show_collision
and jt then rect(jt.x,jt.y,jt.ju,jt.jv,8) end end function gm(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ie(jw) if jw then jw=1-jw end
local fl=flr(mid(0,jw,1)*100) local jx={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jy=1,15 do col=jy jz=(fl+(jy*1.46))/22 for ek=1,jz do col=jx[col] end pal(jy,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hy*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function ka(fg,fh) local kb=mget(fg,fh) local kc=fget(kb,0) return kc end function cx(msg,eu) local cw={} local kd=""local ke=""local ex=""local kf=function(kg) if#ke+#kd>kg then
add(cw,kd) kd=""end kd=kd..ke ke=""end for ew=1,#msg do ex=sub(msg,ew,ew) ke=ke..ex if ex==" "
or#ke>eu-1 then kf(eu) elseif#ke>eu-1 then ke=ke.."-"kf(eu) elseif ex==";"then kd=kd..sub(ke,1,#ke-1) ke=""kf(0) end end kf(eu) if kd!=""then
add(cw,kd) end return cw end function cz(cw) cy=0 for iz in all(cw) do if#iz>cy then cy=#iz end
end return cy end function has_flag(bu,kh) for be in all(bu) do if be==kh then
return true end end return false end function hp(bu,w,h,ki,kj) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.hu=y-(bu.h*8)+1 x=bu.de y=bu.hu end bu.hr={x=x,y=y+fu,ju=x+w-1,jv=y+h+fu-1,ki=ki,kj=kj} end function fk(kk,kl) local km,kn,ko,kp,kq={},{},{},nil,nil kr(km,kk,0) kn[ks(kk)]=nil ko[ks(kk)]=0 while#km>0 and#km<1000 do local kt=km[#km] del(km,km[#km]) ku=kt[1] if ks(ku)==ks(kl) then
break end local kv={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kw=ku[1]+x local kx=ku[2]+y if abs(x)!=abs(y) then ky=1 else ky=1.4 end
if kw>=room_curr.map[1] and kw<=room_curr.map[1]+room_curr.hy
and kx>=room_curr.map[2] and kx<=room_curr.map[2]+room_curr.hz and ka(kw,kx) and((abs(x)!=abs(y)) or ka(kw,ku[2]) or ka(kw-x,kx) or enable_diag_squeeze) then add(kv,{kw,kx,ky}) end end end end for kz in all(kv) do local la=ks(kz) local lb=ko[ks(ku)]+kz[3] if not ko[la]
or lb<ko[la] then ko[la]=lb local h=max(abs(kl[1]-kz[1]),abs(kl[2]-kz[2])) local lc=lb+h kr(km,kz,lc) kn[la]=ku if not kp
or h<kp then kp=h kq=la ld=kz end end end end local fj={} ku=kn[ks(kl)] if ku then
add(fj,kl) elseif kq then ku=kn[kq] add(fj,ld) end if ku then
local le=ks(ku) local lf=ks(kk) while le!=lf do add(fj,ku) ku=kn[le] le=ks(ku) end for ew=1,#fj/2 do local lg=fj[ew] local lh=#fj-(ew-1) fj[ew]=fj[lh] fj[lh]=lg end end return fj end function kr(li,cd,fl) if#li>=1 then
add(li,{}) for ew=(#li),2,-1 do local kz=li[ew-1] if fl<kz[2] then
li[ew]={cd,fl} return else li[ew]=kz end end li[1]={cd,fl} else add(li,{cd,fl}) end end function ks(lj) return((lj[1]+1)*16)+lj[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jr(bu) local cw=lk(bu.data,"\n") for iz in all(cw) do local pairs=lk(iz,"=") if#pairs==2 then
bu[pairs[1]]=ll(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function lk(ej,lm) local ln={} local jd=0 local lo=0 for ew=1,#ej do local lp=sub(ej,ew,ew) if lp==lm then
add(ln,sub(ej,jd,lo)) jd=0 lo=0 elseif lp!=" "and lp!="\t"then lo=ew if jd==0 then jd=ew end
end end if jd+lo>0 then
add(ln,sub(ej,jd,lo)) end return ln end function ll(lq) local lr=sub(lq,1,1) local ln=nil if lq=="true"then
ln=true elseif lq=="false"then ln=false elseif lt(lr) then if lr=="-"then
ln=sub(lq,2,#lq)*-1 else ln=lq+0 end elseif lr=="{"then local lg=sub(lq,2,#lq-1) ln=lk(lg,",") lu={} for cd in all(ln) do cd=ll(cd) add(lu,cd) end ln=lu else ln=lq end return ln end function lt(id) for a=1,13 do if id==sub("0123456789.-+",a,a) then
return true end end end function outline_text(lv,x,y,lw,lx,eo) if not eo then lv=iw(lv) end
for ly=-1,1 do for lz=-1,1 do print(lv,x+ly,y+lz,lx) end end print(lv,x,y,lw) end function ix(ej) return 63.5-flr((#ej*4)/2) end function ma(ej) return 61 end function hn(bu) if not bu.hr
or cr then return false end hr=bu.hr if(fv+hr.ki>hr.ju or fv+hr.ki<hr.x)
or(fw>hr.jv or fw<hr.y) then return false else return true end end function iw(ej) local a=""local iz,id,li=false,false for ew=1,#ej do local ht=sub(ej,ew,ew) if ht=="^"then
if id then a=a..ht end
id=not id elseif ht=="~"then if li then a=a..ht end
li,iz=not li,not iz else if id==iz and ht>="a"and ht<="z"then
for jy=1,26 do if ht==sub("abcdefghijklmnopqrstuvwxyz",jy,jy) then
ht=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jy,jy) break end end end a=a..ht id,li=false,false end end return a end















-- hijack draw method
scumm_draw = _draw

function _draw()
--function _update60() 
 -- check for gfx change
 if req_gfx_num != curr_gfx_num then
  printh("gfx update!!!!!!")
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

 printh("load sprite flags - index: "..index)

 local flag_target_start = 0x42ff - ((index+1) * 0x80) 

 for i=flag_target_start, flag_target_start+0x7f,0x1 do  
  printh(">sfx mem ("..i..") = "..peek(i))
 end

 reload(0x3080, flag_target_start, 0x80)

  for i=0x30ff,0x3080,-0x1 do
   printh(">spr mem ("..i..") = "..peek(i))
  end
end



__gfx__
941008049a030cba0ee5d4f0489246a850f418271b087274161391abaaa84a063eaf2dae2a79ea69ea2e0c85a8be43c7e820bb8e5ac14c479aaa6d4a0a04075d
7e93ca3dc6f01d80926349d04342f01501722a0181758a241c65627152f13721890a49e9cd68486b3801a8a517250241428c24c7d11304fbe2daa0a410841438
8ab11973238eb08ec35fc751787e827c1a5ca1ebf598083a92e41235210ad49482c685856184021600021e17a1a303f92ea233cf5bbddfbaf88efdf7ff0027ff
f9ffcf3f57b2557d6aa3315aea288093468a0ec1a1a1f558d83e2d92427c284ef4526a1aaa0d55d5a365840f0999082da24f93abc96e49fff4151fc1500c26dd
555964eba654591da4d5a949e4a25942a5e5554159213455a87e86a870bbaa9519527841b55457868665c980825ac2974cb482e24aaaa5552a605d89f49f2259
32d9eab8600c26100ced300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000808000000000800088800000808000008080888000008880
00000000000000000000000000000000000000000000000000000000000000000000000000000000808008000000800000800000808008008080008000008000
00000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000888008800000888000008880008000008880
00000000000000000000000000000000000000000000000000000000000000000000000000000000808008000000808000800000008008000080008000000080
00000000000000000000000000000000000000000000000000000000000000000000000000000000808000000000888088800000888000000080008008008880
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
00000000000000000000000000000000000000000000000007000000700005775000070007000700007775000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007000000700057007500070007000700007057500000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007000000700070000700070007000700007000700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007000000700070000700070007000700007000700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007000000700070070700070007000700007000700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007000000700057007500075057000700007057500000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000007777000700005775700007770000700007775000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007775000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001100000000000000007007000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007c00000000000000007007000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000cd00000000000000007770000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007007000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007007000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000c00000000000000005005000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000111111c111111000000000007777000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000001111ccccccc11c1ccccccc111000007000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000111cccc1111111c1c1111111cccccc1007777000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001cccc111ccccccc1c1ccccc11111ccc007555000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000cc1111ccc111111cc11111ccccc1111007000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c11cccc111111117c111111111cccc1007777000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000011cc01111ccccc0c00ccc11cc111ccc000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001cc0111ccc00000000001c111cc111c000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000101011cc11001100001000c111cc111000070000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001010c00c1000100000011111c1c0110000575000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000010011c001c01000000000c11c110111000707000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000011011c01000011111111c01c110011c005777500000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001cc01100111110000001111110011cc007555700000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000100c1111000011111111110001cccc0007000700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001111ccc11111000000000011ccc1001000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001111010cc1111110011ccccccc11111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001c1111101ccccc10011111111111cc1007000700000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000001cc11111101111d0010001ccccc000007707700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001011101111111110011111111110011007575700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001100111c01111111101111111111111007050700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001111111111cc1c10010ccc011c11111007000700000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000111110011111111d111111111111111007000700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001111111111111111111111111111111000000000000000000000000000000000000000000000000
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
__music__
01 08090a44
00 0b090a44
00 080d0c44
02 0e0d0c44
01 0f101444
02 11121344
01 0f151444
02 11151344

