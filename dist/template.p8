pico-8 cartridge // http://www.pico-8.com
version 14
__lua__
-- scumm-8 game template
-- paul nicholas


-- debugging
show_debuginfo = false
show_collision = false
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
					classes = {class_openable,class_door}
					use_pos = pos_right
					use_dir = face_left
				]],
				init = function(me)  
					me.target_door = obj_front_door
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

		
			obj_spinning_top = {		
				data = [[
					name=spinning top
					x=42
					y=50
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



		rm_hall = {
			data = [[
				map = {32,24,55,31}
				col_replace = {5,2}
			]],
			objects = {
				obj_spinning_top,
				obj_front_door_inside,
				obj_hall_door_library,
				obj_hall_door_kitchen,
			},
			enter = function(me)
				if not me.done_intro then
					-- don't do this again
					me.done_intro = true
					-- set which actor the player controls by default
					selected_actor = main_actor
					-- init actor
					put_at(selected_actor, 30, 55, rm_hall)
					-- make camera follow player
					-- (setting now, will be re-instated after cutscene)
					camera_follow(selected_actor)
				end
				-- animate clock
				start_script(me.scripts.anim_clock, true) -- bg script
			end,
			exit = function(me)
				-- pause clock while not in room
				stop_script(me.scripts.anim_clock)
			end,
			scripts = {
			}
		}

	



-- "the void" (room)
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
	rm_hall,
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

	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)
	change_room(rm_hall, 1) -- iris fade
end


-- (end of customisable game content)





























-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(br) if br then
bs=1 end bt=br end function bu(bv) local bw=nil if has_flag(bv.classes,"class_talkable") then
bw="talkto"elseif has_flag(bv.classes,"class_openable") then if bv.state=="state_closed"then
bw="open"else bw="close"end else bw="lookat"end for bx in all(verbs) do by=get_verb(bx) if by[2]==bw then bw=bx break end
end return bw end function bz(ca,cb,cc) local cd=has_flag(cb.classes,"class_actor") if ca=="walkto"then
return elseif ca=="pickup"then if cd then
say_line"i don't need them"else say_line"i don't need that"end elseif ca=="use"then if cd then
say_line"i can't just *use* someone"end if cc then
if has_flag(cc.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif ca=="give"then if cd then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif ca=="lookat"then if cd then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif ca=="open"then if cd then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif ca=="close"then if cd then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif ca=="push"or ca=="pull"then if cd then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif ca=="talkto"then if cd then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(ce) cam_x=cf(ce) cg=nil ch=nil end function camera_follow(ci) stop_script(cj) ch=ci cg=nil cj=function() while ch do if ch.in_room==room_curr then
cam_x=cf(ch) end yield() end end start_script(cj,true) if ch.in_room!=room_curr then
change_room(ch.in_room,1) end end function camera_pan_to(ce) cg=cf(ce) ch=nil cj=function() while(true) do if cam_x==cg then
cg=nil return elseif cg>cam_x then cam_x+=0.5 else cam_x-=0.5 end yield() end end start_script(cj,true) end function wait_for_camera() while script_running(cj) do yield() end end function cutscene(type,ck,cl) cm={cn=type,co=cocreate(ck),cp=cl,cq=ch} add(cr,cm) cs=cm break_time() end function dialog_set(ct) for msg in all(ct) do dialog_add(msg) end end function dialog_add(msg) if not cu then cu={cv={},cw=false} end
cx=cy(msg,32) cz=da(cx) db={num=#cu.cv+1,msg=msg,cx=cx,dc=cz} add(cu.cv,db) end function dialog_start(col,dd) cu.col=col cu.dd=dd cu.cw=true selected_sentence=nil end function dialog_hide() cu.cw=false end function dialog_clear() cu.cv={} selected_sentence=nil end function dialog_end() cu=nil end function get_use_pos(bv) local de=bv.use_pos local x=bv.x local y=bv.y if type(de)=="table"then
x=de[1] y=de[2] elseif de=="pos_left"then if bv.df then
x-=(bv.w*8+4) y+=1 else x-=2 y+=((bv.h*8)-2) end elseif de=="pos_right"then x+=(bv.w*8) y+=((bv.h*8)-2) elseif de=="pos_above"then x+=((bv.w*8)/2)-4 y-=2 elseif de=="pos_center"then x+=((bv.w*8)/2) y+=((bv.h*8)/2)-4 elseif de=="pos_infront"or de==nil then x+=((bv.w*8)/2)-4 y+=(bv.h*8)+2 end return{x=x,y=y} end function do_anim(ci,dg,dh) di={"face_front","face_left","face_back","face_right"} if dg=="anim_face"then
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
dx=dw[dr.use_dir] else dx=1 end selected_actor.face_dir=dx selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(dy,be) if be==1 then
dz=0 else dz=50 end while true do dz+=be*2 if dz>50
or dz<0 then return end if dy==1 then
ea=min(dz,32) end yield() end end function change_room(du,dy) if du==nil then
dt("room does not exist") return end stop_script(eb) if dy and room_curr then
fades(dy,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ec={} ed() room_curr=du if not ch
or ch.in_room!=room_curr then cam_x=0 end stop_talking() if dy then
eb=function() fades(dy,-1) end start_script(eb,true) else ea=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(ca,ee) if not ee
or not ee.verbs then return false end if type(ca)=="table"then
if ee.verbs[ca[1]] then return true end
else if ee.verbs[ca] then return true end
end return false end function pickup_obj(bv,ci) ci=ci or selected_actor add(ci.bp,bv) bv.owner=ci del(bv.in_room.objects,bv) end function start_script(ef,eg,eh,ei) local co=cocreate(ef) local scripts=ec if eg then
scripts=ej end add(scripts,{ef,co,eh,ei}) end function script_running(ef) for ek in all({ec,ej}) do for el,em in pairs(ek) do if em[1]==ef then
return em end end end return false end function stop_script(ef) em=script_running(ef) if em then
del(ec,em) del(ej,em) end end function break_time(en) en=en or 1 for x=1,en do yield() end end function wait_for_message() while eo!=nil do yield() end end function say_line(ci,msg,ep,eq) if type(ci)=="string"then
msg=ci ci=selected_actor end er=ci.y-(ci.h)*8+4 es=ci print_line(msg,ci.x,er,ci.col,1,ep,eq) end function stop_talking() eo,es=nil,nil end function print_line(msg,x,y,col,et,ep,eq) local col=col or 7 local et=et or 0 if et==1 then
eu=min(x-cam_x,127-(x-cam_x)) else eu=127-(x-cam_x) end local ev=max(flr(eu/2),16) local ew=""for ex=1,#msg do local ey=sub(msg,ex,ex) if ey==":"then
ew=sub(msg,ex+1) msg=sub(msg,1,ex-1) break end end local cx=cy(msg,ev) local cz=da(cx) ez=x-cam_x if et==1 then
ez-=((cz*4)/2) end ez=max(2,ez) er=max(18,y) ez=min(ez,127-(cz*4)-1) eo={fa=cx,x=ez,y=er,col=col,et=et,fb=eq or(#msg)*8,dc=cz,ep=ep} if#ew>0 then
fc=es wait_for_message() es=fc print_line(ew,x,y,col,et,ep) end wait_for_message() end function put_at(bv,x,y,fd) if fd then
if not has_flag(bv.classes,"class_actor") then
if bv.in_room then del(bv.in_room.objects,bv) end
add(fd.objects,bv) bv.owner=nil end bv.in_room=fd end bv.x,bv.y=x,y end function stop_actor(ci) ci.fe=0 ed() end function walk_to(ci,x,y) local ff=fg(ci) local fh=flr(x/8)+room_curr.map[1] local fi=flr(y/8)+room_curr.map[2] local fj={fh,fi} local fk=fl(ff,fj) ci.fe=1 for fm in all(fk) do local fn=mid(room_curr.fo or 0.15,ci.y/40,1) fn*=(room_curr.fp or 1) local fq=ci.walk_speed*(ci.scale or fn) local fr=(fm[1]-room_curr.map[1])*8+4 local fs=(fm[2]-room_curr.map[2])*8+4 local ft=sqrt((fr-ci.x)^2+(fs-ci.y)^2) local fu=fq*(fr-ci.x)/ft local fv=fq*(fs-ci.y)/ft if ci.fe==0 then
return end if ft>5 then
ci.flip=(fu<0) if abs(fu)<fq/2 then
if fv>0 then
ci.fw=ci.walk_anim_front ci.face_dir="face_front"else ci.fw=ci.walk_anim_back ci.face_dir="face_back"end else ci.fw=ci.walk_anim_side ci.face_dir="face_right"if ci.flip then ci.face_dir="face_left"end
end for ex=0,ft/fq do ci.x+=fu ci.y+=fv yield() end end end ci.fe=2 end function wait_for_actor(ci) ci=ci or selected_actor while ci.fe!=2 do yield() end end function proximity(cb,cc) if cb.in_room==cc.in_room then
local ft=sqrt((cb.x-cc.x)^2+(cb.y-cc.y)^2) return ft else return 1000 end end fx=16 cam_x,cg,cj,bs=0,nil,nil,0 fy,fz,ga,gb=63.5,63.5,0,1 gc={{spr=ui_uparrowspr,x=75,y=fx+60},{spr=ui_dnarrowspr,x=75,y=fx+72}} dm={face_front=1,face_left=2,face_back=3,face_right=4} function gd(bv) local ge={} for el,bx in pairs(bv) do add(ge,el) end return ge end function get_verb(bv) local ca={} local ge=gd(bv[1]) add(ca,ge[1]) add(ca,bv[1][ge[1]]) add(ca,bv.text) return ca end function ed() gf=get_verb(verb_default) gg,gh,p,gi,gj=nil,nil,nil,false,""end ed() eo=nil cu=nil cs=nil es=nil ej={} ec={} cr={} gk={} ea,ea=0,0 gl=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gm() start_script(startup_script,true) end function _update60() gn() end function _draw() go() end function gn() if selected_actor and selected_actor.co
and not coresume(selected_actor.co) then selected_actor.co=nil end gp(ej) if cs then
if cs.co
and not coresume(cs.co) then if cs.cn!=3
and cs.cq then camera_follow(cs.cq) selected_actor=cs.cq end del(cr,cs) if#cr>0 then
cs=cr[#cr] else if cs.cn!=2 then
gl=3 end cs=nil end end else gp(ec) end gq() gr() gs,gt=1.5-rnd(3),1.5-rnd(3) gs=flr(gs*bs) gt=flr(gt*bs) if not bt then
bs*=0.90 if bs<0.05 then bs=0 end
end end function go() rectfill(0,0,127,127,0) camera(cam_x+gs,0+gt) clip(0+ea-gs,fx+ea-gt,128-ea*2-gs,64-ea*2) gu() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fx-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fx-8,8) end if show_debuginfo then
print("x: "..flr(fy+cam_x).." y:"..fz-fx,80,fx-8,8) end gv() if cu
and cu.cw then gw() gx() return end if gl>0 then
gl-=1 return end if not cs then
gy() end if(not cs
or cs.cn==2) and gl==0 then gz() else end if not cs then
gx() end end function gq() if cs and not ha then
if eo
and(btnp(4) or stat(34)==1) then eo.fb=0 ha=true return elseif cs.cp and(btnp(5) or stat(34)==2) then cs.co=cocreate(cs.cp) cs.cp=nil return end return end if btn(0) then fy-=1 end
if btn(1) then fy+=1 end
if btn(2) then fz-=1 end
if btn(3) then fz+=1 end
if btnp(4) then hb(1) end
if btnp(5) then hb(2) end
if enable_mouse then
hc,hd=stat(32)-1,stat(33)-1 if hc!=he then fy=hc end
if hd!=hf then fz=hd end
if stat(34)>0 then
if not ha then
hb(stat(34)) ha=true end else ha=false end he=hc hf=hd end fy=mid(0,fy,127) fz=mid(0,fz,127) end function hb(hg) local hh=gf if not selected_actor then
return end if cu and cu.cw then
if hi then
selected_sentence=hi end return end if hj then
gf=get_verb(hj) elseif hk then if hg==1 then
if(gf[2]=="use"or gf[2]=="give")
and gg then gh=hk else gg=hk end elseif hl then gf=get_verb(hl) gg=hk gd(gg) gy() end elseif hm then if hm==gc[1] then
if selected_actor.hn>0 then
selected_actor.hn-=1 end else if selected_actor.hn+2<flr(#selected_actor.bp/4) then
selected_actor.hn+=1 end end return end if gg!=nil
then if gf[2]=="use"or gf[2]=="give"then
if gh then
elseif gg.use_with and gg.owner==selected_actor then return end end gi=true selected_actor.co=cocreate(function() if(not gg.owner
and(not has_flag(gg.classes,"class_actor") or gf[2]!="use")) or gh then ho=gh or gg hp=get_use_pos(ho) walk_to(selected_actor,hp.x,hp.y) if selected_actor.fe!=2 then return end
use_dir=ho if ho.use_dir then use_dir=ho.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gf,gg) then
start_script(gg.verbs[gf[1]],false,gg,gh) else if has_flag(gg.classes,"class_door") then
if gf[2]=="walkto"then
come_out_door(gg,gg.target_door) elseif gf[2]=="open"then open_door(gg,gg.target_door) elseif gf[2]=="close"then close_door(gg,gg.target_door) end else bz(gf[2],gg,gh) end end ed() end) coresume(selected_actor.co) elseif fz>fx and fz<fx+64 then gi=true selected_actor.co=cocreate(function() walk_to(selected_actor,fy+cam_x,fz-fx) ed() end) coresume(selected_actor.co) end end function gr() if not room_curr then
return end hj,hl,hk,hi,hm=nil,nil,nil,nil,nil if cu
and cu.cw then for ek in all(cu.cv) do if hq(ek) then
hi=ek end end return end hr() for bv in all(room_curr.objects) do if(not bv.classes
or(bv.classes and not has_flag(bv.classes,"class_untouchable"))) and(not bv.dependent_on or bv.dependent_on.state==bv.dependent_on_state) then hs(bv,bv.w*8,bv.h*8,cam_x,ht) else bv.hu=nil end if hq(bv) then
if not hk
or(not bv.z and hk.z<0) or(bv.z and hk.z and bv.z>hk.z) then hk=bv end end hv(bv) end for el,ci in pairs(actors) do if ci.in_room==room_curr then
hs(ci,ci.w*8,ci.h*8,cam_x,ht) hv(ci) if hq(ci)
and ci!=selected_actor then hk=ci end end end if selected_actor then
for bx in all(verbs) do if hq(bx) then
hj=bx end end for hw in all(gc) do if hq(hw) then
hm=hw end end for el,bv in pairs(selected_actor.bp) do if hq(bv) then
hk=bv if gf[2]=="pickup"and hk.owner then
gf=nil end end if bv.owner!=selected_actor then
del(selected_actor.bp,bv) end end if gf==nil then
gf=get_verb(verb_default) end if hk then
hl=bu(hk) end end end function hr() gk={} for x=-64,64 do gk[x]={} end end function hv(bv) er=-1 if bv.hx then
er=bv.y else er=bv.y+(bv.h*8) end hy=flr(er) if bv.z then
hy=bv.z end add(gk[hy],bv) end function gu() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fx,8,0) return end rectfill(0,fx,127,fx+64,room_curr.hz or 0) for z=-64,64 do if z==0 then
ia(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fx,room_curr.ib,room_curr.ic) pal() else hy=gk[z] for bv in all(hy) do if not has_flag(bv.classes,"class_actor") then
if bv.states
or(bv.state and bv[bv.state] and bv[bv.state]>0) and(not bv.dependent_on or bv.dependent_on.state==bv.dependent_on_state) and not bv.owner or bv.draw then id(bv) end else if bv.in_room==room_curr then
ie(bv) end end ig(bv) end end end end function ia(bv) if bv.col_replace then
ih=bv.col_replace pal(ih[1],ih[2]) end if bv.lighting then
ii(bv.lighting) elseif bv.in_room and bv.in_room.lighting then ii(bv.in_room.lighting) end end function id(bv) ia(bv) if bv.draw then
bv.draw(bv) else ij=1 if bv.repeat_x then ij=bv.repeat_x end
for h=0,ij-1 do local ik=0 if bv.states then
ik=bv.states[bv.state] else ik=bv[bv.state] end il(ik,bv.x+(h*(bv.w*8)),bv.y,bv.w,bv.h,bv.trans_col,bv.flip_x,bv.scale) end end pal() end function ie(ci) im=dm[ci.face_dir] if ci.fe==1
and ci.fw then ci.io+=1 if ci.io>ci.frame_delay then
ci.io=1 ci.ip+=1 if ci.ip>#ci.fw then ci.ip=1 end
end iq=ci.fw[ci.ip] else iq=ci.idle[im] end ia(ci) local fn=mid(room_curr.fo or 0,(ci.y+12)/64,1) fn*=(room_curr.fp or 1) local scale=ci.scale or fn local ir=(8*ci.h) local is=(8*ci.w) local it=ir-(ir*scale) local iu=is-(is*scale) il(iq,ci.df+flr(iu/2),ci.hx+it,ci.w,ci.h,ci.trans_col,ci.flip,false,scale) if es
and es==ci and es.talk then if ci.iv<7 then
iq=ci.talk[im] il(iq,ci.df+flr(iu/2),ci.hx+flr(8*scale)+it,1,1,ci.trans_col,ci.flip,false,scale) end ci.iv+=1 if ci.iv>14 then ci.iv=1 end
end pal() end function gy() iw=""ix=verb_maincol iy=gf[2] if gf then
iw=gf[3] end if gg then
iw=iw.." "..gg.name if iy=="use"then
iw=iw.." with"elseif iy=="give"then iw=iw.." to"end end if gh then
iw=iw.." "..gh.name elseif hk and hk.name!=""and(not gg or(gg!=hk)) and(not hk.owner or iy!=get_verb(verb_default)[2]) then iw=iw.." "..hk.name end gj=iw if gi then
iw=gj ix=verb_hovcol end print(iz(iw),ja(iw),fx+66,ix) end function gv() if eo then
jb=0 for jc in all(eo.fa) do jd=0 if eo.et==1 then
jd=((eo.dc*4)-(#jc*4))/2 end outline_text(jc,eo.x+jd,eo.y+jb,eo.col,0,eo.ep) jb+=6 end eo.fb-=1 if eo.fb<=0 then
stop_talking() end end end function gz() ez,er,je=0,75,0 for bx in all(verbs) do jf=verb_maincol if hl
and bx==hl then jf=verb_defcol end if bx==hj then jf=verb_hovcol end
by=get_verb(bx) print(by[3],ez,er+fx+1,verb_shadcol) print(by[3],ez,er+fx,jf) bx.x=ez bx.y=er hs(bx,#by[3]*4,5,0,0) ig(bx) if#by[3]>je then je=#by[3] end
er+=8 if er>=95 then
er=75 ez+=(je+1.0)*4 je=0 end end if selected_actor then
ez,er=86,76 jg=selected_actor.hn*4 jh=min(jg+8,#selected_actor.bp) for ji=1,8 do rectfill(ez-1,fx+er-1,ez+8,fx+er+8,verb_shadcol) bv=selected_actor.bp[jg+ji] if bv then
bv.x,bv.y=ez,er id(bv) hs(bv,bv.w*8,bv.h*8,0,0) ig(bv) end ez+=11 if ez>=125 then
er+=12 ez=86 end ji+=1 end for ex=1,2 do jj=gc[ex] if hm==jj then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) il(jj.spr,jj.x,jj.y,1,1,0) hs(jj,8,7,0,0) ig(jj) pal() end end end function gw() ez,er=0,70 for ek in all(cu.cv) do if ek.dc>0 then
ek.x,ek.y=ez,er hs(ek,ek.dc*4,#ek.cx*5,0,0) jf=cu.col if ek==hi then jf=cu.dd end
for jc in all(ek.cx) do print(iz(jc),ez,er+fx,jf) er+=5 end ig(ek) er+=2 end end end function gx() col=ui_cursor_cols[gb] pal(7,col) spr(ui_cursorspr,fy-4,fz-3,1,1,0) pal() ga+=1 if ga>7 then
ga=1 gb+=1 if gb>#ui_cursor_cols then gb=1 end
end end function il(jk,x,y,w,h,jl,flip_x,jm,scale) set_trans_col(jl,true) local jn=8*(jk%16) local jo=8*flr(jk/16) local jp=8*w local jq=8*h local jr=scale or 1 local js=jp*jr local jt=jq*jr sspr(jn,jo,jp,jq,x,fx+y,js,jt,flip_x,jm) end function set_trans_col(jl,br) palt(0,false) palt(jl,true) if jl and jl>0 then
palt(0,false) end end function gm() for fd in all(rooms) do ju(fd) if(#fd.map>2) then
fd.ib=fd.map[3]-fd.map[1]+1 fd.ic=fd.map[4]-fd.map[2]+1 else fd.ib=16 fd.ic=8 end for bv in all(fd.objects) do ju(bv) bv.in_room=fd bv.h=bv.h or 0 if bv.init then
bv.init(bv) end end end for jv,ci in pairs(actors) do ju(ci) ci.fe=2 ci.io=1 ci.iv=1 ci.ip=1 ci.bp={} ci.hn=0 end end function ig(bv) local jw=bv.hu if show_collision
and jw then rect(jw.x,jw.y,jw.jx,jw.jy,8) end end function gp(scripts) for em in all(scripts) do if em[2] and not coresume(em[2],em[3],em[4]) then
del(scripts,em) em=nil end end end function ii(jz) if jz then jz=1-jz end
local fm=flr(mid(0,jz,1)*100) local ka={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kb=1,15 do col=kb kc=(fm+(kb*1.46))/22 for el=1,kc do col=ka[col] end pal(kb,col) end end function cf(ce) if type(ce)=="table"then
ce=ce.x end return mid(0,ce-64,(room_curr.ib*8)-128) end function fg(bv) local fh=flr(bv.x/8)+room_curr.map[1] local fi=flr(bv.y/8)+room_curr.map[2] return{fh,fi} end function kd(fh,fi) local ke=mget(fh,fi) local kf=fget(ke,0) return kf end function cy(msg,ev) local cx={} local kg=""local kh=""local ey=""local ki=function(kj) if#kh+#kg>kj then
add(cx,kg) kg=""end kg=kg..kh kh=""end for ex=1,#msg do ey=sub(msg,ex,ex) kh=kh..ey if ey==" "
or#kh>ev-1 then ki(ev) elseif#kh>ev-1 then kh=kh.."-"ki(ev) elseif ey==";"then kg=kg..sub(kh,1,#kh-1) kh=""ki(0) end end ki(ev) if kg!=""then
add(cx,kg) end return cx end function da(cx) cz=0 for jc in all(cx) do if#jc>cz then cz=#jc end
end return cz end function has_flag(bv,kk) for bf in all(bv) do if bf==kk then
return true end end return false end function hs(bv,w,h,kl,km) x=bv.x y=bv.y if has_flag(bv.classes,"class_actor") then
bv.df=x-(bv.w*8)/2 bv.hx=y-(bv.h*8)+1 x=bv.df y=bv.hx end bv.hu={x=x,y=y+fx,jx=x+w-1,jy=y+h+fx-1,kl=kl,km=km} end function fl(kn,ko) local kp,kq,kr,ks,kt={},{},{},nil,nil ku(kp,kn,0) kq[kv(kn)]=nil kr[kv(kn)]=0 while#kp>0 and#kp<1000 do local kw=kp[#kp] del(kp,kp[#kp]) kx=kw[1] if kv(kx)==kv(ko) then
break end local ky={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kz=kx[1]+x local la=kx[2]+y if abs(x)!=abs(y) then lb=1 else lb=1.4 end
if kz>=room_curr.map[1] and kz<=room_curr.map[1]+room_curr.ib
and la>=room_curr.map[2] and la<=room_curr.map[2]+room_curr.ic and kd(kz,la) and((abs(x)!=abs(y)) or kd(kz,kx[2]) or kd(kz-x,la) or enable_diag_squeeze) then add(ky,{kz,la,lb}) end end end end for lc in all(ky) do local ld=kv(lc) local le=kr[kv(kx)]+lc[3] if not kr[ld]
or le<kr[ld] then kr[ld]=le local h=max(abs(ko[1]-lc[1]),abs(ko[2]-lc[2])) local lf=le+h ku(kp,lc,lf) kq[ld]=kx if not ks
or h<ks then ks=h kt=ld lg=lc end end end end local fk={} kx=kq[kv(ko)] if kx then
add(fk,ko) elseif kt then kx=kq[kt] add(fk,lg) end if kx then
local lh=kv(kx) local li=kv(kn) while lh!=li do add(fk,kx) kx=kq[lh] lh=kv(kx) end for ex=1,#fk/2 do local lj=fk[ex] local lk=#fk-(ex-1) fk[ex]=fk[lk] fk[lk]=lj end end return fk end function ku(ll,ce,fm) if#ll>=1 then
add(ll,{}) for ex=(#ll),2,-1 do local lc=ll[ex-1] if fm<lc[2] then
ll[ex]={ce,fm} return else ll[ex]=lc end end ll[1]={ce,fm} else add(ll,{ce,fm}) end end function kv(lm) return((lm[1]+1)*16)+lm[2] end function dt(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function ju(bv) local cx=ln(bv.data,"\n") for jc in all(cx) do local pairs=ln(jc,"=") if#pairs==2 then
bv[pairs[1]]=lo(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function ln(ek,lp) local lq={} local jg=0 local lr=0 for ex=1,#ek do local lt=sub(ek,ex,ex) if lt==lp then
add(lq,sub(ek,jg,lr)) jg=0 lr=0 elseif lt!=" "and lt!="\t"then lr=ex if jg==0 then jg=ex end
end end if jg+lr>0 then
add(lq,sub(ek,jg,lr)) end return lq end function lo(lu) local lv=sub(lu,1,1) local lq=nil if lu=="true"then
lq=true elseif lu=="false"then lq=false elseif lw(lv) then if lv=="-"then
lq=sub(lu,2,#lu)*-1 else lq=lu+0 end elseif lv=="{"then local lj=sub(lu,2,#lu-1) lq=ln(lj,",") lx={} for ce in all(lq) do ce=lo(ce) add(lx,ce) end lq=lx else lq=lu end return lq end function lw(ih) for b=1,13 do if ih==sub("0123456789.-+",b,b) then
return true end end end function outline_text(ly,x,y,lz,ma,ep) if not ep then ly=iz(ly) end
for mb=-1,1 do for mc=-1,1 do print(ly,x+mb,y+mc,ma) end end print(ly,x,y,lz) end function ja(ek) return 63.5-flr((#ek*4)/2) end function md(ek) return 61 end function hq(bv) if not bv.hu
or cs then return false end hu=bv.hu if(fy+hu.kl>hu.jx or fy+hu.kl<hu.x)
or(fz>hu.jy or fz<hu.y) then return false else return true end end function iz(ek) local b=""local jc,ih,ll=false,false for ex=1,#ek do local hw=sub(ek,ex,ex) if hw=="^"then
if ih then b=b..hw end
ih=not ih elseif hw=="~"then if ll then b=b..hw end
ll,jc=not ll,not jc else if ih==jc and hw>="a"and hw<="z"then
for kb=1,26 do if hw==sub("abcdefghijklmnopqrstuvwxyz",kb,kb) then
hw=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kb,kb) break end end end b=b..hw ih,ll=false,false end end return b end



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
00000000000000000000000000000000777777777777777777555555555555778888884444888888888888888888888888888888d00000004444444444444444
9f00d70000c0006500c0096500000000700000077000000770700000000007078888884004088888888888888888888888888888d50000004ffffff44ffffff4
9f2ed728b3c55565b3c5596500000000700000077000000770070000000070078888844444408888888888888888888888888888d51000004f4444944f444494
9f2ed728b3c50565b3c5946500000000700000077000000770006000000600078888440000440888888888888888888888888888d51000004f4444944f444494
9f2ed728b3c50565b3c5946500000000700000077000000770006000000600078884402222044088888666666666688888866666d51000004f4444944f444494
9f2ed728b3c55565b3c9456500000000700000077000000770006000000600078844025555404408888600000000688888860000d51000004f4444944f444494
9f2ed728b3c55565b3c94565000000007000000770000007700060000006000784402500aa540408888600000000688888860b00d51000004f4444944f444494
444444444444444444444444000000007777777777777777777760000006777784405aaaaaa50440888600000000688888860000d51000004f4444944f444494
00000000000000000000000000000000700000677600000770066000000660078440aa5555aa0440888600000000688800000000d51000004f4444944f444494
00cd006500000000000a000000000000700006077060000770606000000606078002a59aa95a2000888600000000688800000000d51000004f9999944f444494
b3cd826500000000000000000000000070000507705000077050600000060507884759a5aa950408888600000000688800000000d5100000444444444f449994
b3cd826500a0a000000aa000000a0a007000000770000007700060000006000788475aa5aaa50408888666666666688800000000d5100000444444444f994444
b3cd826500aaaa0000aaaa0000aaa0007000000770000007700500000000500788475aa955a50408888888555588888800000000d510000049a4444444444444
b3cd826500a9aa0000a99a0000aa9a0070000007700000077050000000000507884759aaaa950408866666666666666800000000d51000004994444444444444
b3cd826500a99a0000a99a0000a99a00777777777777777775000000000000778847a59aa95a0408866666666555666800000000d51000004444444449a44444
44444444004444000044440000444400555555555555555555555555555555558847aa5555aa0408866666666666666800000000d51000004ffffff449944444
9999999977777777777777777777777770000007777600007777777777777777884744aaaa4404088824a0000002450877777777d51000004f44449444444444
555555555555555555555555555555557000000777760000555555555555555588422222222224088824a0000002450855555555d51000004f4444944444fff4
444444441dd6dd6dd6dd6dd6d6dd6d517000000777760000444444444444444488000000000000088824a0000002450844444444d51000004f4444944fff4494
ffff4fff1dd6dd6dd6dd6dd6d6dd6d517000000766665555444ffffffffff44480444444444444008824a0000002450844444444d51000004f4444944f444494
444949441666666666666666666666517000000700007776444944444444944488000000000000088824a0000002450844444444d51000004f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd65170000007000077764449444aa444944488244444444445088824a2222222450844444444d51111114f4444944f444494
444949441d6dd6dd6dd6dd6ddd6dd651777777770000777644494444444494448824aaaaaaaa4508882444444444450844444444d55555554ffffff44f444494
44494944166666666666666666666651555555555555666644499999999994448824a00000024508882440000009450844444444dddddddd444444444f444494
444949441dd6dd600000000056dd6d516dd6dd6d0000000044494444444494448824a00000024508882440888889450888944488000000004f4444944f444494
444949441dd6dd650000000056dd6d51666666660000000044494444444494448824a00000024508888888888888888888944488000000004f4444944f444994
44494944166666650000000056666651d6dd6dd60000000044494444444494448824a00000024508888888888888888888944488006660004f4444944f499444
444949441d6dd6d5000000005d6dd651d6dd6dd60000000044494444444494448824a00000024508888888888888888888944488006760004f4444944f944444
444949441d6dd6d5000000005d6dd651666666660000000044494444444494448824a00000024508888888888888888888944488006560004f44449444444400
444949441666666500000000566666516dd6dd6d0000000044494444444494448824a00000024508888888888888888888944488006660004f44449444440000
999949991dd6dd650000000056dd6d516dd6dd6d0000000044499999999994448824a00000024508888888888888888888944488000000004f44449444000000
444444441dd6dd650000000056dd6d51666666660000000044444444444444448824a00000024508888888888888888888944488000000004f44449400000000
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
000770000f5ff5f00f5ff5f00f5ff5f000fff5fb00fff5fb00fff5fb4444444044444440444444400f5ff5f000fff5fb44444440000000000000000000000000
007557004ffffff44ffffff44ffffff440ffffff40ffffff40ffffff0444444404444444044444444ffffff440ffffff04444444000000000000000000000000
07500570bff44ffbbff44ffbbff44ffbb0fffff4b0fffff4b0fffff4b044444bb044444bb044444bbff44ffbb0fffff4b044444b000000000000000000000000
77700777b6ffff6bb6ffff6bb6ffff6bb6fffffbb6fffffbb6fffffbb044444bb044444bb044444bb6ffff6bb6fffffbb044444b000000000000000000000000
00700700bbfddfbbbbfddfbbbbfddfbbbb6fffdbbb6fffdbbb6fffdbbb0000bbbb0000bbbb0000bbbbf00fbbbb6ff00bbb0000bb000000000000000000000000
00700700bbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbf00fbbbbbff00bbbbffbbb000000000000000000000000
00777700bdc55cdbbdc55cdbbdc55cdbbbddcbbbbbbddbbbbbddcbbbbddddddbbddddddbbddddddbbbbffbbbbbbbbffbbddddddb000000000000000000000000
00555500dcc55ccddcc55ccddcc55ccdb1ccdcbbbb1ccdbbb1ccdcbbdccccccddccccccddccccccdbbbbbbbbbbbbbbbbdccccccd000000000000000000000000
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
0001010101010100000000010000000000010101010101000000000101000000000101010101010101010101000000000001010101010100000000000000000000000000000000000000808000000000000000000000000000008080000000000000000000008080000000008000000000000000000000000000010180000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
1131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
3131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
1717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
1717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
1232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
3232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0707071717171717171717171707070717171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707171717080808080808080808081717170707071717171717171717171707070717171708080808080808080808171717
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0700071717171717171717171707000717001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007170017080808080808080808081700170700071717171717171717171707000717001708080808080808080808170017
0701113131313131313131313121010717021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107170212323232323232323232322202170701113131313131313131313121010717021232323232323232323232220217
1131313131313131313131313131312112323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121123232323232323232323232323232221131313131313131313131313131312112323232323232323232323232323222
3131313131313131313131313131313132323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131323232323232323232323232323232323131313131313131313131313131313132323232323232323232323232323232
17171708080808080808080808171717070707171717171717171717170707070707071a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
17171708080808080808080808171717070707171717171717171717170707070707071a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a070707000000000000000017171708080808080808080808171717070707171717171717171717170707071717170808080808080808080817171707070717171717171717171717070707
17001708080808080808080808170017070007171717171717171717170700070700071a1a1a1a1a1a1a1a1a1a1a1a1a4e001a1a1a070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007070007606060606060606060606060605e00606060070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1700170808080808080808080817001707000717171717171717171717070007070007707070707070707070707070706e00707070070007000000000000000017001708080808080808080808170017070007171717171717171717170700071700170808080808080808080817001707000717171717171717171717070007
1702123232323232323232323222021707011131313131313131313131210107070111313131313131313131313131313131313131210107000000000000000017021232323232323232323232220217070111313131313131313131312101071702123232323232323232323222021707011131313131313131313131210107
1232323232323232323232323232322211313131313131313131313131313121113131313131312515151515151515353131313131313121000000000000000012323232323232323232323232323222113131313131313131313131313131211232323232323232323232323232322211313131313131313131313131313121
3232323232323232323232323232323231313131313131313131313131313131313131313131313131313131313131313131313131313131000000000000000032323232323232323232323232323232313131313131313131313131313131313232323232323232323232323232323231313131313131313131313131313131
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

