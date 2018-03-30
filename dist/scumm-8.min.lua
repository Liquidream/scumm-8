
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
add(fc.objects,bu) bu.owner=nil end bu.in_room=fc end bu.x,bu.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=(fl[1]-room_curr.map[1])*8+4 local fn=(fl[2]-room_curr.map[2])*8+4 local fo=sqrt((fm-ch.x)^2+(fn-ch.y)^2) local fp=ch.walk_speed*(fm-ch.x)/fo local fq=ch.walk_speed*(fn-ch.y)/fo if ch.fd==0 then
return end if fo>5 then
ch.flip=(fp<0) if abs(fp)<0.4 then
if fq>0 then
ch.fr=ch.walk_anim_front ch.face_dir="face_front"else ch.fr=ch.walk_anim_back ch.face_dir="face_back"end else ch.fr=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end for ew=0,fo/ch.walk_speed do ch.x+=fp ch.y+=fq yield() end end end ch.fd=2 end function wait_for_actor(ch) ch=ch or selected_actor while ch.fd!=2 do yield() end end function proximity(ca,cb) if ca.in_room==cb.in_room then
local fo=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fo else return 1000 end end fs=16 cam_x,cf,ci,br=0,nil,nil,0 ft,fu,fv,fw=63.5,63.5,0,1 fx={7,12,13,13,12,7} fy={{spr=208,x=75,y=fs+60},{spr=240,x=75,y=fs+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function fz(bu) local ga={} for ek,bw in pairs(bu) do add(ga,ek) end return ga end function get_verb(bu) local bz={} local ga=fz(bu[1]) add(bz,ga[1]) add(bz,bu[1][ga[1]]) add(bz,bu.text) return bz end function ec() gb=get_verb(verb_default) gc,gd,o,ge,gf=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gg={} dz,dz=0,0 gh=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gi() start_script(startup_script,true) end function _update60() gj() end function _draw() gk() end function gj() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gl(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gh=3 end cr=nil end end else gl(eb) end gm() gn() go,gp=1.5-rnd(3),1.5-rnd(3) go=flr(go*br) gp=flr(gp*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gk() rectfill(0,0,127,127,0) camera(cam_x+go,0+gp) clip(0+dz-go,fs+dz-gp,128-dz*2-go,64-dz*2) gq() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fs-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fs-8,8) end if show_debuginfo then
print("x: "..flr(ft+cam_x).." y:"..fu-fs,80,fs-8,8) end gr() if ct
and ct.cv then gs() gt() return end if gh>0 then
gh-=1 return end if not cr then
gu() end if(not cr
or cr.cm==2) and gh==0 then gv() else end if not cr then
gt() end end function gm() if cr then
if(btnp(5) or stat(34)>0)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end return end if btn(0) then ft-=1 end
if btn(1) then ft+=1 end
if btn(2) then fu-=1 end
if btn(3) then fu+=1 end
if btnp(4) then gw(1) end
if btnp(5) then gw(2) end
if enable_mouse then
gx,gy=stat(32)-1,stat(33)-1 if gx!=gz then ft=gx end
if gy!=ha then fu=gy end
if stat(34)>0 then
if not hb then
gw(stat(34)) hb=true end else hb=false end gz=gx ha=gy end ft=mid(0,ft,127) fu=mid(0,fu,127) end function gw(hc) local hd=gb if not selected_actor then
return end if ct and ct.cv then
if he then
selected_sentence=he end return end if hf then
gb=get_verb(hf) elseif hg then if hc==1 then
if(gb[2]=="use"or gb[2]=="give")
and gc then gd=hg else gc=hg end elseif hh then gb=get_verb(hh) gc=hg fz(gc) gu() end elseif hi then if hi==fy[1] then
if selected_actor.hj>0 then
selected_actor.hj-=1 end else if selected_actor.hj+2<flr(#selected_actor.bo/4) then
selected_actor.hj+=1 end end return end if gc!=nil
then if gb[2]=="use"or gb[2]=="give"then
if gd then
elseif gc.use_with and gc.owner==selected_actor then return end end ge=true selected_actor.cn=cocreate(function() if(not gc.owner
and(not has_flag(gc.classes,"class_actor") or gb[2]!="use")) or gd then hk=gd or gc hl=get_use_pos(hk) walk_to(selected_actor,hl.x,hl.y) if selected_actor.fd!=2 then return end
use_dir=hk if hk.use_dir then use_dir=hk.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gb,gc) then
start_script(gc.verbs[gb[1]],false,gc,gd) else if has_flag(gc.classes,"class_door") then
if gb[2]=="walkto"then
come_out_door(gc,gc.target_door) elseif gb[2]=="open"then open_door(gc,gc.target_door) elseif gb[2]=="close"then close_door(gc,gc.target_door) end else by(gb[2],gc,gd) end end ec() end) coresume(selected_actor.cn) elseif fu>fs and fu<fs+64 then ge=true selected_actor.cn=cocreate(function() walk_to(selected_actor,ft+cam_x,fu-fs) ec() end) coresume(selected_actor.cn) end end function gn() if not room_curr then
return end hf,hh,hg,he,hi=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if hm(ej) then
he=ej end end return end hn() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then ho(bu,bu.w*8,bu.h*8,cam_x,hp) else bu.hq=nil end if hm(bu) then
if not hg
or(not bu.z and hg.z<0) or(bu.z and hg.z and bu.z>hg.z) then hg=bu end end hr(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
ho(ch,ch.w*8,ch.h*8,cam_x,hp) hr(ch) if hm(ch)
and ch!=selected_actor then hg=ch end end end if selected_actor then
for bw in all(verbs) do if hm(bw) then
hf=bw end end for hs in all(fy) do if hm(hs) then
hi=hs end end for ek,bu in pairs(selected_actor.bo) do if hm(bu) then
hg=bu if gb[2]=="pickup"and hg.owner then
gb=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if gb==nil then
gb=get_verb(verb_default) end if hg then
hh=bt(hg) end end end function hn() gg={} for x=-64,64 do gg[x]={} end end function hr(bu) eq=-1 if bu.ht then
eq=bu.y else eq=bu.y+(bu.h*8) end hu=flr(eq) if bu.z then
hu=bu.z end add(gg[hu],bu) end function gq() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fs,8,0) return end rectfill(0,fs,127,fs+64,room_curr.hv or 0) for z=-64,64 do if z==0 then
hw(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fs,room_curr.hx,room_curr.hy) pal() else hu=gg[z] for bu in all(hu) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then hz(bu) end else if bu.in_room==room_curr then
ia(bu) end end ib(bu) end end end end function hw(bu) if bu.col_replace then
ic=bu.col_replace pal(ic[1],ic[2]) end if bu.lighting then
id(bu.lighting) elseif bu.in_room and bu.in_room.lighting then id(bu.in_room.lighting) end end function hz(bu) hw(bu) if bu.draw then
bu.draw(bu) else ie=1 if bu.repeat_x then ie=bu.repeat_x end
for h=0,ie-1 do local ig=0 if bu.states then
ig=bu.states[bu.state] else ig=bu[bu.state] end ih(ig,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x) end end pal() end function ia(ch) ii=dl[ch.face_dir] if ch.fd==1
and ch.fr then ch.ij+=1 if ch.ij>ch.frame_delay then
ch.ij=1 ch.ik+=1 if ch.ik>#ch.fr then ch.ik=1 end
end il=ch.fr[ch.ik] else il=ch.idle[ii] end hw(ch) ih(il,ch.de,ch.ht,ch.w,ch.h,ch.trans_col,ch.flip,false) if er
and er==ch and er.talk then if ch.im<7 then
il=ch.talk[ii] ih(il,ch.de,ch.ht+8,1,1,ch.trans_col,ch.flip,false) end ch.im+=1 if ch.im>14 then ch.im=1 end
end pal() end function gu() io=""ip=verb_maincol iq=gb[2] if gb then
io=gb[3] end if gc then
io=io.." "..gc.name if iq=="use"then
io=io.." with"elseif iq=="give"then io=io.." to"end end if gd then
io=io.." "..gd.name elseif hg and hg.name!=""and(not gc or(gc!=hg)) and(not hg.owner or iq!=get_verb(verb_default)[2]) then io=io.." "..hg.name end gf=io if ge then
io=gf ip=verb_hovcol end print(ir(io),is(io),fs+66,ip) end function gr() if en then
it=0 for iu in all(en.ez) do iv=0 if en.es==1 then
iv=((en.db*4)-(#iu*4))/2 end outline_text(iu,en.x+iv,en.y+it,en.col,0,en.eo) it+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gv() ey,eq,iw=0,75,0 for bw in all(verbs) do ix=verb_maincol if hh
and bw==hh then ix=verb_defcol end if bw==hf then ix=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fs+1,verb_shadcol) print(bx[3],ey,eq+fs,ix) bw.x=ey bw.y=eq ho(bw,#bx[3]*4,5,0,0) ib(bw) if#bx[3]>iw then iw=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(iw+1.0)*4 iw=0 end end if selected_actor then
ey,eq=86,76 iy=selected_actor.hj*4 iz=min(iy+8,#selected_actor.bo) for ja=1,8 do rectfill(ey-1,fs+eq-1,ey+8,fs+eq+8,verb_shadcol) bu=selected_actor.bo[iy+ja] if bu then
bu.x,bu.y=ey,eq hz(bu) ho(bu,bu.w*8,bu.h*8,0,0) ib(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end ja+=1 end for ew=1,2 do jb=fy[ew] if hi==jb then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ih(jb.spr,jb.x,jb.y,1,1,0) ho(jb,8,7,0,0) ib(jb) pal() end end end function gs() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq ho(ej,ej.db*4,#ej.cw*5,0,0) ix=ct.col if ej==he then ix=ct.dc end
for iu in all(ej.cw) do print(ir(iu),ey,eq+fs,ix) eq+=5 end ib(ej) eq+=2 end end end function gt() col=fx[fw] pal(7,col) spr(224,ft-4,fu-3,1,1,0) pal() fv+=1 if fv>7 then
fv=1 fw+=1 if fw>#fx then fw=1 end
end end function ih(jc,x,y,w,h,jd,flip_x,je) set_trans_col(jd,true) spr(jc,x,fs+y,w,h,flip_x,je) end function set_trans_col(jd,bq) palt(0,false) palt(jd,true) if jd and jd>0 then
palt(0,false) end end function gi() for fc in all(rooms) do jf(fc) if(#fc.map>2) then
fc.hx=fc.map[3]-fc.map[1]+1 fc.hy=fc.map[4]-fc.map[2]+1 else fc.hx=16 fc.hy=8 end for bu in all(fc.objects) do jf(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for jg,ch in pairs(actors) do jf(ch) ch.fd=2 ch.ij=1 ch.im=1 ch.ik=1 ch.bo={} ch.hj=0 end end function ib(bu) local jh=bu.hq if show_collision
and jh then rect(jh.x,jh.y,jh.ji,jh.jj,8) end end function gl(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function id(jk) if jk then jk=1-jk end
local fl=flr(mid(0,jk,1)*100) local jl={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jm=1,15 do col=jm jn=(fl+(jm*1.46))/22 for ek=1,jn do col=jl[col] end pal(jm,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hx*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function jo(fg,fh) local jp=mget(fg,fh) local jq=fget(jp,0) return jq end function cx(msg,eu) local cw={} local jr=""local js=""local ex=""local jt=function(ju) if#js+#jr>ju then
add(cw,jr) jr=""end jr=jr..js js=""end for ew=1,#msg do ex=sub(msg,ew,ew) js=js..ex if ex==" "
or#js>eu-1 then jt(eu) elseif#js>eu-1 then js=js.."-"jt(eu) elseif ex==";"then jr=jr..sub(js,1,#js-1) js=""jt(0) end end jt(eu) if jr!=""then
add(cw,jr) end return cw end function cz(cw) cy=0 for iu in all(cw) do if#iu>cy then cy=#iu end
end return cy end function has_flag(bu,jv) for be in all(bu) do if be==jv then
return true end end return false end function ho(bu,w,h,jw,jx) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.ht=y-(bu.h*8)+1 x=bu.de y=bu.ht end bu.hq={x=x,y=y+fs,ji=x+w-1,jj=y+h+fs-1,jw=jw,jx=jx} end function fk(jy,jz) local ka,kb,kc,kd,ke={},{},{},nil,nil kf(ka,jy,0) kb[kg(jy)]=nil kc[kg(jy)]=0 while#ka>0 and#ka<1000 do local kh=ka[#ka] del(ka,ka[#ka]) ki=kh[1] if kg(ki)==kg(jz) then
break end local kj={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kk=ki[1]+x local kl=ki[2]+y if abs(x)!=abs(y) then km=1 else km=1.4 end
if kk>=room_curr.map[1] and kk<=room_curr.map[1]+room_curr.hx
and kl>=room_curr.map[2] and kl<=room_curr.map[2]+room_curr.hy and jo(kk,kl) and((abs(x)!=abs(y)) or jo(kk,ki[2]) or jo(kk-x,kl) or enable_diag_squeeze) then add(kj,{kk,kl,km}) end end end end for kn in all(kj) do local ko=kg(kn) local kp=kc[kg(ki)]+kn[3] if not kc[ko]
or kp<kc[ko] then kc[ko]=kp local h=max(abs(jz[1]-kn[1]),abs(jz[2]-kn[2])) local kq=kp+h kf(ka,kn,kq) kb[ko]=ki if not kd
or h<kd then kd=h ke=ko kr=kn end end end end local fj={} ki=kb[kg(jz)] if ki then
add(fj,jz) elseif ke then ki=kb[ke] add(fj,kr) end if ki then
local ks=kg(ki) local kt=kg(jy) while ks!=kt do add(fj,ki) ki=kb[ks] ks=kg(ki) end for ew=1,#fj/2 do local ku=fj[ew] local kv=#fj-(ew-1) fj[ew]=fj[kv] fj[kv]=ku end end return fj end function kf(kw,cd,fl) if#kw>=1 then
add(kw,{}) for ew=(#kw),2,-1 do local kn=kw[ew-1] if fl<kn[2] then
kw[ew]={cd,fl} return else kw[ew]=kn end end kw[1]={cd,fl} else add(kw,{cd,fl}) end end function kg(kx) return((kx[1]+1)*16)+kx[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jf(bu) local cw=ky(bu.data,"\n") for iu in all(cw) do local pairs=ky(iu,"=") if#pairs==2 then
bu[pairs[1]]=kz(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function ky(ej,la) local lb={} local iy=0 local lc=0 for ew=1,#ej do local ld=sub(ej,ew,ew) if ld==la then
add(lb,sub(ej,iy,lc)) iy=0 lc=0 elseif ld!=" "and ld!="\t"then lc=ew if iy==0 then iy=ew end
end end if iy+lc>0 then
add(lb,sub(ej,iy,lc)) end return lb end function kz(le) local lf=sub(le,1,1) local lb=nil if le=="true"then
lb=true elseif le=="false"then lb=false elseif lg(lf) then if lf=="-"then
lb=sub(le,2,#le)*-1 else lb=le+0 end elseif lf=="{"then local ku=sub(le,2,#le-1) lb=ky(ku,",") lh={} for cd in all(lb) do cd=kz(cd) add(lh,cd) end lb=lh else lb=le end return lb end function lg(ic) for a=1,13 do if ic==sub("0123456789.-+",a,a) then
return true end end end function outline_text(li,x,y,lj,lk,eo) if not eo then li=ir(li) end
for ll=-1,1 do for lm=-1,1 do print(li,x+ll,y+lm,lk) end end print(li,x,y,lj) end function is(ej) return 63.5-flr((#ej*4)/2) end function ln(ej) return 61 end function hm(bu) if not bu.hq
or cr then return false end hq=bu.hq if(ft+hq.jw>hq.ji or ft+hq.jw<hq.x)
or(fu>hq.jj or fu<hq.y) then return false else return true end end function ir(ej) local a=""local iu,ic,kw=false,false for ew=1,#ej do local hs=sub(ej,ew,ew) if hs=="^"then
if ic then a=a..hs end
ic=not ic elseif hs=="~"then if kw then a=a..hs end
kw,iu=not kw,not iu else if ic==iu and hs>="a"and hs<="z"then
for jm=1,26 do if hs==sub("abcdefghijklmnopqrstuvwxyz",jm,jm) then
hs=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jm,jm) break end end end a=a..hs ic,kw=false,false end end return a end
