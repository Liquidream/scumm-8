pico-8 cartridge // http://www.pico-8.com
version 9
__lua__
-- scumm-8 game template
-- paul nicholas

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


verb_maincol = 11  -- main color (lt blue)
verb_hovcol = 10   -- hover color (white)
verb_shadcol = 0   -- shadow (dk blue)
verb_defcol = 10   -- default action (yellow)


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
							break_time(50)
							print_line("deep in the caribbean...",64,45,2,1)

		    			--[[
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
							change_room(rm_mi_dock, 1)
							

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

-- [ monkey island mini-game ]

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
						--come_out_door(me, obj_front_door_inside)
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
				if not me.done_intro then
					-- don't do this again
					me.done_intro = true
					-- set which actor the player controls by default
					selected_actor = mi_actor
					-- init actor
					put_actor_at(selected_actor, 20, 60, rm_mi_dock)
					
					
					
					-- make camera follow player
					-- (setting now, will be re-instated after cutscene)
					camera_follow(selected_actor)

--[[
					camera_at(0)
					break_time(75)
					camera_pan_to(196,60)
					walk_to(selected_actor, 196,60)
					
					wait_for_camera()

					camera_follow(selected_actor)
					
					say_line("there's something very famililar about all this...")
]]

				end
			end,
			exit = function(me)
				-- todo: anything here?
			end,
		}



	rm_void = {
		data = [[
			map = {0,0}
		]],
		objects = {
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
	rm_mi_dock
}



--
-- actor definitions
-- 

	-- initialize the player's actor object
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
	mi_actor
	--purp_tentacle
}


-- 
-- scripts
-- 

-- this script is execute once on game startup
function startup_script()	
	-- set which room to start the game in 
	-- (e.g. could be a "pseudo" room for title screen!)

	-- pickup_obj(obj_switch_tent, mi_actor)
	-- pickup_obj(obj_switch_player, purp_tentacle)
			-- 
	change_room(rm_mi_dock, 1) -- iris fade
	--change_room(rm_title, 1) -- iris fade

	--room_curr = rm_title
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
x=du[1]-ct y=du[2]-dv elseif du=="pos_left"then if cj.dw then
x-=(cj.w*8+4) y+=1 else x-=2 y+=((cj.h*8)-2) end elseif du=="pos_right"then x+=(cj.w*8) y+=((cj.h*8)-2) elseif du=="pos_above"then x+=((cj.w*8)/2)-4 y-=2 elseif du=="pos_center"then x+=((cj.w*8)/2) y+=((cj.h*8)/2)-4 elseif du=="pos_infront"or du==nil then x+=((cj.w*8)/2)-4 y+=(cj.h*8)+2 end return{x=x,y=y} end function do_anim(cx,dx,dy) dz={"face_front","face_left","face_back","face_right"} if dx=="anim_face"then
if type(dy)=="table"then
ea=atan2(cx.x-dy.x,dy.y-cx.y) eb=93*(3.1415/180) ea=eb-ea ec=ea*360 ec=ec%360 if ec<0 then ec+=360 end
dy=4-flr(ec/90) dy=dz[dy] end face_dir=ed[cx.face_dir] dy=ed[dy] while face_dir!=dy do if face_dir<dy then
face_dir+=1 else face_dir-=1 end cx.face_dir=dz[face_dir] cx.flip=(cx.face_dir=="face_left") break_time(10) end end end function open_door(ee,ef) if ee.state=="state_open"then
say_line"it's already open"else ee.state="state_open"if ef then ef.state="state_open"end
end end function close_door(ee,ef) if ee.state=="state_closed"then
say_line"it's already closed"else ee.state="state_closed"if ef then ef.state="state_closed"end
end end function come_out_door(eg,eh,ei) if eh==nil then
ej("exit door does not exist") return end if eg.state=="state_open"then
ek=eh.in_room change_room(ek,ei) local el=get_use_pos(eh) put_actor_at(selected_actor,el.x,el.y,ek) em={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if eh.use_dir then
en=em[eh.use_dir] else en=1 end selected_actor.face_dir=en selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eo,bp) if bp==1 then
ep=0 else ep=50 end while true do ep+=bp*2 if ep>50
or ep<0 then return end if eo==1 then
eq=min(ep,32) end yield() end end function change_room(ek,eo) if ek==nil then
ej("room does not exist") return end stop_script(er) if eo and room_curr then
fades(eo,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end es={} et() room_curr=ek if not cw
or cw.in_room!=room_curr then ct=0 end stop_talking() if eo then
er=function() fades(eo,-1) end start_script(er,true) else eq=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(co,eu) if not eu
or not eu.verbs then return false end if type(co)=="table"then
if eu.verbs[co[1]] then return true end
else if eu.verbs[co] then return true end
end return false end function pickup_obj(cj,cx) cx=cx or selected_actor add(cx.cd,cj) cj.owner=cx del(cj.in_room.objects,cj) end function start_script(ev,ew,ex,bg) local dd=cocreate(ev) local scripts=es if ew then
scripts=ey end add(scripts,{ev,dd,ex,bg}) end function script_running(ev) for ez in all({es,ey}) do for fa,fb in pairs(ez) do if fb[1]==ev then
return fb end end end return false end function stop_script(ev) fb=script_running(ev) if fb then
del(es,fb) del(ey,fb) end end function break_time(fc) fc=fc or 1 for x=1,fc do yield() end end function wait_for_message() while fd!=nil do yield() end end function say_line(cx,msg,fe,ff) if type(cx)=="string"then
msg=cx cx=selected_actor end fg=cx.y-(cx.h)*8+4 fh=cx print_line(msg,cx.x,fg,cx.col,1,fe,ff) end function stop_talking() fd,fh=nil,nil end function print_line(msg,x,y,col,fi,fe,ff) local col=col or 7 local fi=fi or 0 if fi==1 then
fj=min(x-ct,127-(x-ct)) else fj=127-(x-ct) end local fk=max(flr(fj/2),16) local fl=""for fm=1,#msg do local fn=sub(msg,fm,fm) if fn==":"then
fl=sub(msg,fm+1) msg=sub(msg,1,fm-1) break end end local dm=dn(msg,fk) local dp=dq(dm) fo=x-ct if fi==1 then
fo-=((dp*4)/2) end fo=max(2,fo) fg=max(18,y) fo=min(fo,127-(dp*4)-1) fd={fp=dm,x=fo,y=fg,col=col,fi=fi,fq=(#msg)*8,ds=dp,fe=fe} if#fl>0 then
fr=fh wait_for_message() fh=fr print_line(fl,x,y,col,fi,fe) end if not ff then
wait_for_message() end end function put_actor_at(cx,x,y,fs) if fs then cx.in_room=fs end
cx.x,cx.y=x,y end function walk_to(cx,x,y) x+=ct local ft=fu(cx) local fv=flr(x/8)+room_curr.map[1] local fw=flr(y/8)+room_curr.map[2] local fx={fv,fw} local fy=fz(ft,fx) local ga=fu({x=x,y=y}) if gb(ga[1],ga[2]) then
add(fy,ga) end for gc in all(fy) do local gd=(gc[1]-room_curr.map[1])*8+4 local ge=(gc[2]-room_curr.map[2])*8+4 local gf=sqrt((gd-cx.x)^2+(ge-cx.y)^2) local gg=cx.walk_speed*(gd-cx.x)/gf local gh=cx.walk_speed*(ge-cx.y)/gf if gf>5 then
cx.gi=1 cx.flip=(gg<0) if abs(gg)<0.4 then
if gh>0 then
cx.gj=cx.walk_anim_front cx.face_dir="face_front"else cx.gj=cx.walk_anim_back cx.face_dir="face_back"end else cx.gj=cx.walk_anim_side cx.face_dir="face_right"if cx.flip then cx.face_dir="face_left"end
end for fm=0,gf/cx.walk_speed do cx.x+=gg cx.y+=gh yield() end end end cx.gi=2 end function wait_for_actor(cx) cx=cx or selected_actor while cx.gi!=2 do yield() end end function proximity(cp,cq) if cp.in_room==cq.in_room then
local gf=sqrt((cp.x-cq.x)^2+(cp.y-cq.y)^2) return gf else return 1000 end end dv=16 ct,cv,cy,cg=0,nil,nil,0 gk,gl,gm,gn=63.5,63.5,0,1 go={7,12,13,13,12,7} gp={{spr=208,x=75,y=dv+60},{spr=240,x=75,y=dv+72}} ed={face_front=1,face_left=2,face_back=3,face_right=4} function gq(cj) local gr={} for fa,cl in pairs(cj) do add(gr,fa) end return gr end function get_verb(cj) local co={} local gr=gq(cj[1]) add(co,gr[1]) add(co,cj[1][gr[1]]) add(co,cj.text) return co end function et() gs=get_verb(verb_default) gt,gu,n,gv,gw=nil,nil,nil,false,""end et() fd=nil dj=nil dh=nil fh=nil ey={} es={} dg={} gx={} eq,eq=0,0 function _init() if enable_mouse then poke(0x5f2d,1) end
gy() start_script(startup_script,true) end function _update60() gz() end function _draw() ha() end function gz() if selected_actor and selected_actor.dd
and not coresume(selected_actor.dd) then selected_actor.dd=nil end hb(ey) if dh then
if dh.dd
and not coresume(dh.dd) then if dh.cz!=3
and dh.df then camera_follow(dh.df) selected_actor=dh.df end del(dg,dh) dh=nil if#dg>0 then
dh=dg[#dg] end end else hb(es) end hc() hd() he,hf=1.5-rnd(3),1.5-rnd(3) he=flr(he*cg) hf=flr(hf*cg) if not ch then
cg*=0.90 if cg<0.05 then cg=0 end
end end function ha() rectfill(0,0,127,127,0) camera(ct+he,0+hf) clip(0+eq-he,dv+eq-hf,128-eq*2-he,64-eq*2) hg() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dv-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dv-8,8) end if show_debuginfo then
print("x: "..flr(gk+ct).." y:"..gl-dv,80,dv-8,8) end hh() if dj
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
and(not has_flag(gt.classes,"class_actor") or gs[2]!="use")) or gu then ib=gu or gt ic=get_use_pos(ib) walk_to(selected_actor,ic.x,ic.y) if selected_actor.gi!=2 then return end
use_dir=ib if ib.use_dir then use_dir=ib.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gs,gt) then
start_script(gt.verbs[gs[1]],false,gt,gu) else cn(gs[2],gt,gu) end et() end) coresume(selected_actor.dd) elseif gl>dv and gl<dv+64 then gv=true selected_actor.dd=cocreate(function() walk_to(selected_actor,gk,gl-dv) et() end) coresume(selected_actor.dd) end end function hd() hw,hy,hx,hv,hz=nil,nil,nil,nil,nil if dj
and dj.dl then for ez in all(dj.dk) do if id(ez) then
hv=ez end end return end ie() for cj in all(room_curr.objects) do if(not cj.classes
or(cj.classes and not has_flag(cj.classes,"class_untouchable"))) and(not cj.dependent_on or cj.dependent_on.state==cj.dependent_on_state) then ig(cj,cj.w*8,cj.h*8,ct,ih) else cj.ii=nil end if id(cj) then
if not hx
or(not cj.z and hx.z<0) or(cj.z and hx.z and cj.z>hx.z) then hx=cj end end ij(cj) end for fa,cx in pairs(actors) do if cx.in_room==room_curr then
ig(cx,cx.w*8,cx.h*8,ct,ih) ij(cx) if id(cx)
and cx!=selected_actor then hx=cx end end end if selected_actor then
for cl in all(verbs) do if id(cl) then
hw=cl end end for ik in all(gp) do if id(ik) then
hz=ik end end for fa,cj in pairs(selected_actor.cd) do if id(cj) then
hx=cj if gs[2]=="pickup"and hx.owner then
gs=nil end end if cj.owner!=selected_actor then
del(selected_actor.cd,cj) end end if gs==nil then
gs=get_verb(verb_default) end if hx then
hy=ci(hx) end end end function ie() gx={} for x=-64,64 do gx[x]={} end end function ij(cj) fg=-1 if cj.il then
fg=cj.y else fg=cj.y+(cj.h*8) end im=flr(fg) if cj.z then
im=cj.z end add(gx[im],cj) end function hg() rectfill(0,dv,127,dv+64,room_curr.io or 0) for z=-64,64 do if z==0 then
ip(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,dv,room_curr.iq,room_curr.ir) pal() else im=gx[z] for cj in all(im) do if not has_flag(cj.classes,"class_actor") then
if cj.states
or(cj.state and cj[cj.state] and cj[cj.state]>0) and(not cj.dependent_on or cj.dependent_on.state==cj.dependent_on_state) and not cj.owner then is(cj) end else if cj.in_room==room_curr then
it(cj) end end iu(cj) end end end end function ip(cj) if cj.col_replace then
iv=cj.col_replace pal(iv[1],iv[2]) end if cj.lighting then
iw(cj.lighting) elseif cj.in_room then iw(cj.in_room.lighting) end end function is(cj) ip(cj) if cj.draw then
cj.draw(cj) return end ix=1 if cj.repeat_x then ix=cj.repeat_x end
for h=0,ix-1 do local iy=0 if cj.states then
iy=cj.states[cj.state] else iy=cj[cj.state] end iz(iy,cj.x+(h*(cj.w*8)),cj.y,cj.w,cj.h,cj.trans_col,cj.flip_x) end pal() end function it(cx) ja=ed[cx.face_dir] if cx.gi==1
and cx.gj then cx.jb+=1 if cx.jb>cx.frame_delay then
cx.jb=1 cx.jc+=1 if cx.jc>#cx.gj then cx.jc=1 end
end jd=cx.gj[cx.jc] else jd=cx.idle[ja] end ip(cx) iz(jd,cx.dw,cx.il,cx.w,cx.h,cx.trans_col,cx.flip,false) if fh
and fh==cx and fh.talk then if cx.je<7 then
jd=cx.talk[ja] iz(jd,cx.dw,cx.il+8,1,1,cx.trans_col,cx.flip,false) end cx.je+=1 if cx.je>14 then cx.je=1 end
end pal() end function hl() jf=""jg=12 jh=gs[2] if not gv then
if gs then
jf=gs[3] end if gt then
jf=jf.." "..gt.name if jh=="use"then
jf=jf.." with"elseif jh=="give"then jf=jf.." to"end end if gu then
jf=jf.." "..gu.name elseif hx and hx.name!=""and(not gt or(gt!=hx)) and(not hx.owner or jh!=get_verb(verb_default)[2]) then jf=jf.." "..hx.name end gw=jf else jf=gw jg=7 end print(ji(jf),jj(jf),dv+66,jg) end function hh() if fd then
jk=0 for jl in all(fd.fp) do jm=0 if fd.fi==1 then
jm=((fd.ds*4)-(#jl*4))/2 end jn(jl,fd.x+jm,fd.y+jk,fd.col,0,fd.fe) jk+=6 end fd.fq-=1 if fd.fq<=0 then
stop_talking() end end end function hm() fo,fg,jo=0,75,0 for cl in all(verbs) do jp=verb_maincol if hy
and cl==hy then jp=verb_defcol end if cl==hw then jp=verb_hovcol end
cm=get_verb(cl) print(cm[3],fo,fg+dv+1,verb_shadcol) print(cm[3],fo,fg+dv,jp) cl.x=fo cl.y=fg ig(cl,#cm[3]*4,5,0,0) iu(cl) if#cm[3]>jo then jo=#cm[3] end
fg+=8 if fg>=95 then
fg=75 fo+=(jo+1.0)*4 jo=0 end end if selected_actor then
fo,fg=86,76 jq=selected_actor.ia*4 jr=min(jq+8,#selected_actor.cd) for js=1,8 do rectfill(fo-1,dv+fg-1,fo+8,dv+fg+8,1) cj=selected_actor.cd[jq+js] if cj then
cj.x,cj.y=fo,fg is(cj) ig(cj,cj.w*8,cj.h*8,0,0) iu(cj) end fo+=11 if fo>=125 then
fg+=12 fo=86 end js+=1 end for fm=1,2 do jt=gp[fm] if hz==jt then pal(verb_maincol,7) end
iz(jt.spr,jt.x,jt.y,1,1,0) ig(jt,8,7,0,0) iu(jt) pal() end end end function hi() fo,fg=0,70 for ez in all(dj.dk) do if ez.ds>0 then
ez.x,ez.y=fo,fg ig(ez,ez.ds*4,#ez.dm*5,0,0) jp=dj.col if ez==hv then jp=dj.dt end
for jl in all(ez.dm) do print(ji(jl),fo,fg+dv,jp) fg+=5 end iu(ez) fg+=2 end end end function hj() col=go[gn] pal(7,col) spr(224,gk-4,gl-3,1,1,0) pal() gm+=1 if gm>7 then
gm=1 gn+=1 if gn>#go then gn=1 end
end end function iz(ju,x,y,w,h,jv,flip_x,jw) palt(0,false) palt(jv,true) spr(ju,x,dv+y,w,h,flip_x,jw) palt(jv,false) palt(0,true) end function gy() for fs in all(rooms) do jx(fs) if(#fs.map>2) then
fs.iq=fs.map[3]-fs.map[1]+1 fs.ir=fs.map[4]-fs.map[2]+1 else fs.iq=16 fs.ir=8 end for cj in all(fs.objects) do jx(cj) cj.in_room=fs end end for jy,cx in pairs(actors) do jx(cx) cx.gi=2 cx.jb=1 cx.je=1 cx.jc=1 cx.cd={} cx.ia=0 end end function iu(cj) local jz=cj.ii if show_collision
and jz then rect(jz.x,jz.y,jz.ka,jz.kb,8) end end function hb(scripts) for fb in all(scripts) do if fb[2] and not coresume(fb[2],fb[3],fb[4]) then
del(scripts,fb) fb=nil end end end function iw(kc) if kc then kc=1-kc end
local gc=flr(mid(0,kc,1)*100) local kd={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for ke=1,15 do col=ke kf=(gc+(ke*1.46))/22 for fa=1,kf do col=kd[col] end pal(ke,col) end end function cu(cs) if type(cs)=="table"then
cs=cs.x end return mid(0,cs-64,(room_curr.iq*8)-128) end function fu(cj) local fv=flr(cj.x/8)+room_curr.map[1] local fw=flr(cj.y/8)+room_curr.map[2] return{fv,fw} end function gb(fv,fw) local kg=mget(fv,fw) local kh=fget(kg,0) return kh end function dn(msg,fk) local dm={} local ki=""local kj=""local fn=""local kk=function(kl) if#kj+#ki>kl then
add(dm,ki) ki=""end ki=ki..kj kj=""end for fm=1,#msg do fn=sub(msg,fm,fm) kj=kj..fn if fn==" "
or#kj>fk-1 then kk(fk) elseif#kj>fk-1 then kj=kj.."-"kk(fk) elseif fn==";"then ki=ki..sub(kj,1,#kj-1) kj=""kk(0) end end kk(fk) if ki!=""then
add(dm,ki) end return dm end function dq(dm) dp=0 for jl in all(dm) do if#jl>dp then dp=#jl end
end return dp end function has_flag(cj,km) for bq in all(cj) do if bq==km then
return true end end return false end function ig(cj,w,h,kn,ko) x=cj.x y=cj.y if has_flag(cj.classes,"class_actor") then
cj.dw=x-(cj.w*8)/2 cj.il=y-(cj.h*8)+1 x=cj.dw y=cj.il end cj.ii={x=x,y=y+dv,ka=x+w-1,kb=y+h+dv-1,kn=kn,ko=ko} end function fz(kp,kq) local kr,ks,kt={},{},{} ku(kr,kp,0) ks[kv(kp)]=nil kt[kv(kp)]=0 while#kr>0 and#kr<1000 do local kw=kr[#kr] del(kr,kr[#kr]) kx=kw[1] if kv(kx)==kv(kq) then
break end local ky={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kz=kx[1]+x local la=kx[2]+y if abs(x)!=abs(y) then lb=1 else lb=1.4 end
if kz>=room_curr.map[1] and kz<=room_curr.map[1]+room_curr.iq
and la>=room_curr.map[2] and la<=room_curr.map[2]+room_curr.ir and gb(kz,la) and((abs(x)!=abs(y)) or gb(kz,kx[2]) or gb(kz-x,la)) then add(ky,{kz,la,lb}) end end end end for lc in all(ky) do local ld=kv(lc) local le=kt[kv(kx)]+lc[3] if kt[ld]==nil
or le<kt[ld] then kt[ld]=le local lf=le+max(abs(kq[1]-lc[1]),abs(kq[2]-lc[2])) ku(kr,lc,lf) ks[ld]=kx end end end local fy={} kx=ks[kv(kq)] if kx then
local lg=kv(kx) local lh=kv(kp) while lg!=lh do add(fy,kx) kx=ks[lg] lg=kv(kx) end for fm=1,#fy/2 do local li=fy[fm] local lj=#fy-(fm-1) fy[fm]=fy[lj] fy[lj]=li end end return fy end function ku(lk,cs,gc) if#lk>=1 then
add(lk,{}) for fm=(#lk),2,-1 do local lc=lk[fm-1] if gc<lc[2] then
lk[fm]={cs,gc} return else lk[fm]=lc end end lk[1]={cs,gc} else add(lk,{cs,gc}) end end function kv(ll) return((ll[1]+1)*16)+ll[2] end function ej(msg) print_line("-error-;"..msg,5+ct,5,8,0) end function jx(cj) local dm=lm(cj.data,"\n") for jl in all(dm) do local pairs=lm(jl,"=") if#pairs==2 then
cj[pairs[1]]=ln(pairs[2]) else printh("invalid data line") end end end function lm(ez,lo) local lp={} local jq=0 local lq=0 for fm=1,#ez do local lr=sub(ez,fm,fm) if lr==lo then
add(lp,sub(ez,jq,lq)) jq=0 lq=0 elseif lr!=" "and lr!="\t"then lq=fm if jq==0 then jq=fm end
end end if jq+lq>0 then
add(lp,sub(ez,jq,lq)) end return lp end function ln(lt) local lu=sub(lt,1,1) local lp=nil if lt=="true"then
lp=true elseif lt=="false"then lp=false elseif lv(lu) then if lu=="-"then
lp=sub(lt,2,#lt)*-1 else lp=lt+0 end elseif lu=="{"then local li=sub(lt,2,#lt-1) lp=lm(li,",") lw={} for cs in all(lp) do cs=ln(cs) add(lw,cs) end lp=lw else lp=lt end return lp end function lv(iv) for a=1,13 do if iv==sub("0123456789.-+",a,a) then
return true end end end function jn(lx,x,y,ly,lz,fe) if not fe then lx=ji(lx) end
for ma=-1,1 do for mb=-1,1 do print(lx,x+ma,y+mb,lz) end end print(lx,x,y,ly) end function jj(ez) return 63.5-flr((#ez*4)/2) end function mc(ez) return 61 end function id(cj) if not cj.ii then return false end
ii=cj.ii if(gk+ii.kn>ii.ka or gk+ii.kn<ii.x)
or(gl>ii.kb or gl<ii.y) then return false else return true end end function ji(ez) local a=""local jl,iv,lk=false,false for fm=1,#ez do local ik=sub(ez,fm,fm) if ik=="^"then
if iv then a=a..ik end
iv=not iv elseif ik=="~"then if lk then a=a..ik end
lk,jl=not lk,not jl else if iv==jl and ik>="a"and ik<="z"then
for ke=1,26 do if ik==sub("abcdefghijklmnopqrstuvwxyz",ke,ke) then
ik=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",ke,ke) break end end end a=a..ik iv,lk=false,false end end return a end














__gfx__
00000000100010001010101010101010c111c111c1c1c1c1c1c1c1c10000000000000000bbbbbbbb000000000000000011111111000000000000000088998888
00000000000000000100010001010101111111111c111c111c1c1c1c0000000000000000bbb40bbb000000000000000019999991000000000000000089999888
0080080000100010101010101010101011c111c1c1c1c1c1c1c1c1c10000000000000000bb4000bb00000000000000001aaaaaa1000000000000000089999888
0008800000000000000100010101010111111111111c111c1c1c1c1c00000000000000004400000000000000000000001aaaaaa1000000000000000088998888
00088000100010001010101010101010c111c111c1c1c1c1c1c1c1c100000000000000000000000000000000000000001aaaaaa1000000000000000088ff8888
00800800000000000100010001010101111111111c111c111c1c1c1c00000000000000000000000000000000000000001aaaaaa1000000000000000087777888
0000000000100010101010101010101011c111c1c1c1c1c1c1c1c1c100000000000000000000000000000000000000001aaaaaa1000000000000000077777788
0000000000000000000100010101010111111111111c111c1c1c1c1c00000000000000000000000000000000000000001aaaaaa10000000000000000f7777f88
00000000000000000000000000000000c1c1c1c1c1c1c1c1c1c1c1c1bbbbbbbbbbbbbb4400bbbbbbbbbbbbbb000000001aaaaaa10000000000000000f7777f88
000000000000000000000000000000001c1c1c1c1c1c1c1c1c1c1c1cbbbbbbbbbbbb44000000bbbbbbbbbbbb000000001aaaaaa10000000000000000f5500f88
00000000000000000000000000000000c1c1c1c1c1c1c1c1c1c1c1c1bbbbbbbbbb440000000000bbbbbbbbbb001010001aaaaaa1000000000000000085500888
000000000000000000000000000000001c1c1c1c1e1e1e1e1e1e1e1ebbbbbbbb4400000000000000bbbbbbbb000000001aaaaaa1000000000000000085000888
00000000000000000000000000000000c1c1c1c1c2c2c2c2e2e2e2e2bbbbbb44000000000000000000bbbbbb010001001aaaaaa1000000000000000080080888
000000000000000000000000000000001c1c1c1c2e2e2e2e2e99992ebbbb440000000000000000000000bbbb001110001aaaaaa1000000000000000088787888
00000000000000000000000000000000c2c2c2c292929292e9aaaa92bb4400000000000000000000000000bb000000001aaaaaa1000000000000000088787888
00000000000000000000000000000000eeeeeeee999999999aaaaaa944000000000000000000000000000000000000001aaaaaa1000000000000000080080088
000000000000000000000000c7cc7cccc9ce8ece1d11d111191eee19bbb40000000000000000000000000bbb1111111188999888889998888899988888999888
000000000000000000000000ccccccccecececec1111111111e1e1e1bbb40000000000000990990000000bbb10000001899ff888899ff888899ff888899ff888
000000000000000000000000cc77cc77ccacccac11dd11dd11aa1111bbb400000000000009a0a90000000bbb1010000199fff88889fff88889fff88889fff888
000000000000000000000000ccccccccecececec11111111e111e1aabbb40000000000000000000000000bbb10100001889ff888989ff888989ff888989ff888
000000000000000000000000777ccccc77cc99ccccc1111111e11111bbb400000000000009a0a90000000bbb1010000188778888887788888877888888778888
000000000000000000000000ccccccccecececec1111111111a1e1a1bbb400000000000009a0a90000000bbb1010000187777888877778888777788887777888
000000000000000000000000cccc7777ceeecaaa1111cccc1e111aeabbb40000000000000000000000000bbb1010000187777f88877778888767788887777888
000000000000000000000000cccccccccccccccc1111111111111111bbb40000000000000000000000000bbb101111018f677f88877676f8877677f88f677f88
11110411114011110000000000000000101010100000000000000000bbb40bbb001100100000000000000000100000018f677f88f76776f8f67767f88f677f88
94940094949494940000000000000000010101010000000000000000bbb40bbb011111100000000000000000100001018ff59f88f8009888f85598888ff90f88
010101010101010100000000000ddd00101010100000000000000000bbb40bbb0112211000000000000000001000000188550888880008888855088885500888
971010101010101000000ddd10d11110010101010000000000000000bbb40bbb010ff01000000000000000001000000188500888880008888855088885000888
00710101970101010dddd1110d100001101010100000000000000000bbb40bbb005ff50000000000000000001000000188000888855000888550008880080888
0090000000700000d111100001000000010101010000000000000000bbb40bbb0111111000000000000000001000000188000888855800888558008887786888
00400000009000001000000000000000101010100000000000000000bbb40bbb0111114000000000000000001000000188000888868800688788005889786888
0041c1c10041c1c10000000000000000010101010000000000000000bbb40bbb0101141000000000000000001000000188665588800886888008858866080688
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
aaaaaaaa6aaa6aaa6aaa6aaa6aaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a666a666a666a666a666a666a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6aaa6aaa6aaa6aaa6aaa6aaa6a6a6a666a666a666a666a666a666a666666666666666666666666666666666
aaaaaaaaaaaaaaaaaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a666a6666666666
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a666a6666666666666666666666666666666666666666666
aaaaaaaa6aaa6aaa6aaa6aaa6aaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a666a666a666a666a666a666a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6aaa6aaa6aaa6aaa6aaa6aaa6a6a6a666a666a666a666a666a666a666666666666666666666666666666666
aaaaaaaaaaaaaaaaaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a666a6666666666
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6aaa6a6a6a6a6a6a6a6a6a6a6a6a6a666a6666666666666666666666666666666666666666666
77777777677767776777677767776777676767676767676767676767676767676767676767676767676767676767676767676767666766676667666766676667
77777777777777777777777777777777777777777677767776777677767776777676767666766676667666766676667666666666666666666666666666666666
77777777777777777767776767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676766676666666666
77777777777777777777777777777777777777777777777777767776767676767676767676767676766676666666666666666666666666666666666666666666
77777777677767776777677767776777676767676767676767676767676767676767676767676767676767676767676767676767666766676667666766676667
77777777777777777777777777777777777777777677767776777677767776777676767666766676667666766676667666666666666666666666666666666666
77777777777777777767776767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676766676666666666
77777777777777777777777777777777777777777777777777767776767676767676767676767676766676666666666666666666666666666666666666666666
cccccccc4ccc4ccc4ccc4ccc4ccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c444c444c444c444c444c444c
ccccccccccccccccccccccccccccccccccccccccc4ccc4ccc4ccc4ccc4ccc4ccc4c4c4c444c444c444c444c444c444c444444444444444444444444444444444
cccccccccccccccccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c444c4444444444
ccccccccccccccccccccccccccccccccccccccccccccccccccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c444c4444444444444444444444444444444444444444444
cccccccc4ccc4ccc4ccc4ccc4ccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c444c444c444c444c444c444c
ccccccccccccccccccccccccccccccccccccccccc4ccc4ccc4ccc4ccc4ccc4ccc4c4c4c444c444c444c444c444c444c444444444444444444444444444444444
cccccccccccccccccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c444c4444444444
ccccccccccccccccccccccccccccccccccccccccccccccccccc4ccc4c4c4c4c4c4c4c4c4c4c4c4c4c444c4444444444444444444444444444444444444444444
33333333833383338333833383338333838383838383838383838383838383838383838383838383838383838383838383838383888388838883888388838883
33333333333333333333333333333333333333333833383338333833383338333838383888388838883888388838883888888888888888888888888888888888
33333333333333333383338383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838388838888888888
33333333333333333333333333333333333333333333333333383338383838383838383838383838388838888888888888888888888888888888888888888888
33333333833383338333833383338333838383838383838383838383838383838383838383838383838383838383838383838383888388838883888388838883
33333333333333333333333333333333333333333833383338333833383338333838383888388838883888388838883888888888888888888888888888888888
33333333333333333383338383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838388838888888888
33333333333333333333333333333333333333333333333333383338383838383838383838383838388838888888888888888888888888888888888888888888
aaaaaaaa8aaa8aaa8aaa8aaa8aaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a888a888a888a888a888a888a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaa8aaa8aaa8aaa8aaa8aaa8a8a8a888a888a888a888a888a888a888888888888888888888888888888888
aaaaaaaaaaaaaaaaaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a888a8888888888
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a888a8888888888888888888888888888888888888888888
aaaaaaaa8aaa8aaa8aaa8aaa8aaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a888a888a888a888a888a888a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaa8aaa8aaa8aaa8aaa8aaa8a8a8a888a888a888a888a888a888a888888888888888888888888888888888
aaaaaaaaaaaaaaaaaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a888a8888888888
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaa8a8a8a8a8a8a8a8a8a8a8a8a8a888a8888888888888888888888888888888888888888888
88888888b888b888b888b888b888b888b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbb8bbb8bbb8bbb8bbb8
88888888888888888888888888888888888888888b888b888b888b888b888b888b8b8b8bbb8bbb8bbb8bbb8bbb8bbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
888888888888888888b888b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbbbbbbbbb
888888888888888888888888888888888888888888888888888b888b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
88888888b888b888b888b888b888b888b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbb8bbb8bbb8bbb8bbb8
88888888888888888888888888888888888888888b888b888b888b888b888b888b8b8b8bbb8bbb8bbb8bbb8bbb8bbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
888888888888888888b888b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbbbbbbbbb
888888888888888888888888888888888888888888888888888b888b8b8b8b8b8b8b8b8b8b8b8b8b8bbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
11111111911191119111911191119111919191919191919191919191919191919191919191919191919191919191919191919191999199919991999199919991
11111111111111111111111111111111111111111911191119111911191119111919191999199919991999199919991999999999999999999999999999999999
11111111111111111191119191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919199919999999999
11111111111111111111111111111111111111111111111111191119191919191919191919191919199919999999999999999999999999999999999999999999
11111111911191119111911191119111919191919191919191919191919191919191919191919191919191919191919191919191999199919991999199919991
11111111111111111111111111111111111111111911191119111911191119111919191999199919991999199919991999999999999999999999999999999999
11111111111111111191119191919191919191919191919191919191919191919191919191919191919191919191919191919191919191919199919999999999
11111111111111111111111111111111111111111111111111191119191919191919191919191919199919999999999999999999999999999999999999999999
55555555655565556555655565556555656565656565656565656565656565656565656565656565656565656565656565656565666566656665666566656665
55555555555555555555555555555555555555555655565556555655565556555656565666566656665666566656665666666666666666666666666666666666
55555555555555555565556565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656566656666666666
55555555555555555555555555555555555555555555555555565556565656565656565656565656566656666666666666666666666666666666666666666666
55555555655565556555655565556555656565656565656565656565656565656565656565656565656565656565656565656565666566656665666566656665
55555555555555555555555555555555555555555655565556555655565556555656565666566656665666566656665666666666666666666666666666666666
55555555555555555565556565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656566656666666666
55555555555555555555555555555555555555555555555555565556565656565656565656565656566656666666666666666666666666666666666666666666
cccccccc9ccc9ccc9ccc9ccc9ccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c999c999c999c999c999c999c
ccccccccccccccccccccccccccccccccccccccccc9ccc9ccc9ccc9ccc9ccc9ccc9c9c9c999c999c999c999c999c999c999999999999999999999999999999999
cccccccccccccccccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c999c9999999999
ccccccccccccccccccccccccccccccccccccccccccccccccccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c999c9999999999999999999999999999999999999999999
cccccccc9ccc9ccc9ccc9ccc9ccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c999c999c999c999c999c999c
ccccccccccccccccccccccccccccccccccccccccc9ccc9ccc9ccc9ccc9ccc9ccc9c9c9c999c999c999c999c999c999c999999999999999999999999999999999
cccccccccccccccccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c999c9999999999
ccccccccccccccccccccccccccccccccccccccccccccccccccc9ccc9c9c9c9c9c9c9c9c9c9c9c9c9c999c9999999999999999999999999999999999999999999
88888888a888a888a888a888a888a888a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaa8aaa8aaa8aaa8aaa8
88888888888888888888888888888888888888888a888a888a888a888a888a888a8a8a8aaa8aaa8aaa8aaa8aaa8aaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
888888888888888888a888a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaaaaaaaaa
888888888888888888888888888888888888888888888888888a888a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
88888888a888a888a888a888a888a888a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaa8aaa8aaa8aaa8aaa8
88888888888888888888888888888888888888888a888a888a888a888a888a888a8a8a8aaa8aaa8aaa8aaa8aaa8aaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
888888888888888888a888a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaaaaaaaaa
888888888888888888888888888888888888888888888888888a888a8a8a8a8a8a8a8a8a8a8a8a8a8aaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaa7aaa7aaa7aaa7aaa7aaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a777a777a777a777a777a777a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7aaa7aaa7aaa7aaa7aaa7aaa7a7a7a777a777a777a777a777a777a777777777777777777777777777777777
aaaaaaaaaaaaaaaaaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a777a7777777777
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a777a7777777777777777777777777777777777777777777
aaaaaaaa7aaa7aaa7aaa7aaa7aaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a777a777a777a777a777a777a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7aaa7aaa7aaa7aaa7aaa7aaa7a7a7a777a777a777a777a777a777a777777777777777777777777777777777
aaaaaaaaaaaaaaaaaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a777a7777777777
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7aaa7a7a7a7a7a7a7a7a7a7a7a7a7a777a7777777777777777777777777777777777777777777
22222222622262226222622262226222626262626262626262626262626262626262626262626262626262626262626262626262666266626662666266626662
22222222222222222222222222222222222222222622262226222622262226222626262666266626662666266626662666666666666666666666666666666666
22222222222222222262226262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626266626666666666
22222222222222222222222222222222222222222222222222262226262626262626262626262626266626666666666666666666666666666666666666666666
22222222622262226222622262226222626262626262626262626262626262626262626262626262626262626262626262626262666266626662666266626662
22222222222222222222222222222222222222222622262226222622262226222626262666266626662666266626662666666666666666666666666666666666
22222222222222222262226262626262626262626262626262626262626262626262626262626262626262626262626262626262626262626266626666666666
22222222222222222222222222222222222222222222222222262226262626262626262626262626266626666666666666666666666666666666666666666666
44444444144414441444144414441444141414141414141414141414141414141414141414141414141414141414141414141414111411141114111411141114
44444444444444444444444444444444444444444144414441444144414441444141414111411141114111411141114111111111111111111111111111111111
44444444444444444414441414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141411141111111111
44444444444444444444444444444444444444444444444444414441414141414141414141414141411141111111111111111111111111111111111111111111
44444444144414441444144414441444141414141414141414141414141414141414141414141414141414141414141414141414111411141114111411141114
44444444444444444444444444444444444444444144414441444144414441444141414111411141114111411141114111111111111111111111111111111111
44444444444444444414441414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141411141111111111
44444444444444444444444444444444444444444444444444414441414141414141414141414141411141111111111111111111111111111111111111111111
ccccccccdcccdcccdcccdcccdcccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdddcdddcdddcdddcdddcdddc
cccccccccccccccccccccccccccccccccccccccccdcccdcccdcccdcccdcccdcccdcdcdcdddcdddcdddcdddcdddcdddcddddddddddddddddddddddddddddddddd
ccccccccccccccccccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdddcdddddddddd
cccccccccccccccccccccccccccccccccccccccccccccccccccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdddcddddddddddddddddddddddddddddddddddddddddddd
ccccccccdcccdcccdcccdcccdcccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdddcdddcdddcdddcdddcdddc
cccccccccccccccccccccccccccccccccccccccccdcccdcccdcccdcccdcccdcccdcdcdcdddcdddcdddcdddcdddcdddcddddddddddddddddddddddddddddddddd
ccccccccccccccccccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdddcdddddddddd
cccccccccccccccccccccccccccccccccccccccccccccccccccdcccdcdcdcdcdcdcdcdcdcdcdcdcdcdddcddddddddddddddddddddddddddddddddddddddddddd
ffffffff9fff9fff9fff9fff9fff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f999f999f999f999f999f999f
fffffffffffffffffffffffffffffffffffffffff9fff9fff9fff9fff9fff9fff9f9f9f999f999f999f999f999f999f999999999999999999999999999999999
ffffffffffffffffff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f999f9999999999
fffffffffffffffffffffffffffffffffffffffffffffffffff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f999f9999999999999999999999999999999999999999999
ffffffff9fff9fff9fff9fff9fff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f999f999f999f999f999f999f
fffffffffffffffffffffffffffffffffffffffff9fff9fff9fff9fff9fff9fff9f9f9f999f999f999f999f999f999f999999999999999999999999999999999
ffffffffffffffffff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f9f999f9999999999
fffffffffffffffffffffffffffffffffffffffffffffffffff9fff9f9f9f9f9f9f9f9f9f9f9f9f9f999f9999999999999999999999999999999999999999999
88888888f888f888f888f888f888f888f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8fff8fff8fff8fff8fff8fff8
88888888888888888888888888888888888888888f888f888f888f888f888f888f8f8f8fff8fff8fff8fff8fff8fff8fffffffffffffffffffffffffffffffff
888888888888888888f888f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8fff8ffffffffff
888888888888888888888888888888888888888888888888888f888f8f8f8f8f8f8f8f8f8f8f8f8f8fff8fffffffffffffffffffffffffffffffffffffffffff
88888888f888f888f888f888f888f888f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8fff8fff8fff8fff8fff8fff8
88888888888888888888888888888888888888888f888f888f888f888f888f888f8f8f8fff8fff8fff8fff8fff8fff8fffffffffffffffffffffffffffffffff
888888888888888888f888f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8fff8ffffffffff
888888888888888888888888888888888888888888888888888f888f8f8f8f8f8f8f8f8f8f8f8f8f8fff8fffffffffffffffffffffffffffffffffffffffffff

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101010101010101010101010101010101010101010101010101010101010101010101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020202020202020202020202020202020202020202020202020202020202020202020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303030303030303030303030303030303030303030303030303030303030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040404040404040404040404040404040404040404040404040404040404040404040404040404
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005050505050505050505050505050505050505050505050505050505050505050505050505050505
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015151515151515151515151515151515151615151515151515151515151515151515151515151515
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000025252525252525252525252525252525252625252525252525252525252525252525252525252525
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017191a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000027292a000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001718282a0000000000000000000000000000000000000000000000001718191a0000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002829282a0000000000000000000000000000000000000000000000002728292a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828191a00000000000000000000000000000000000000001718101b102a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828382a0000000000000000000000000000000000001718102929102b2a1718191a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028282828282a0000000000000000000000000000000000003737271010103b2a2729102a00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030313031303130313031303130313031303130303130313030303233323332333233323332333233
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

