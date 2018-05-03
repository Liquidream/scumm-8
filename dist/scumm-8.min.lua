
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
add(fc.objects,bu) bu.owner=nil end bu.in_room=fc end bu.x,bu.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=mid(0.15,ch.y/40,1) local fn=ch.walk_speed*(ch.scale or fm) local fo=(fl[1]-room_curr.map[1])*8+4 local fp=(fl[2]-room_curr.map[2])*8+4 local fq=sqrt((fo-ch.x)^2+(fp-ch.y)^2) local fr=fn*(fo-ch.x)/fq local fs=fn*(fp-ch.y)/fq if ch.fd==0 then
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
end im=ch.ft[ch.il] else im=ch.idle[ij] end hx(ch) local fm=max(0.15,(y+fu*3)/58) local scale=ch.scale or fm local io=(8*ch.h) local ip=(8*ch.w) local iq=io-(io*scale) local ir=ip-(ip*scale) ii(im,ch.de+flr(ir/2),ch.hu+fu+iq,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if er
and er==ch and er.talk then if ch.is<7 then
im=ch.talk[ij] ii(im,ch.de+flr(ir/2),ch.hu+fu+(8*(ch.scale or fm))+iq,1,1,ch.trans_col,ch.flip,false,ch.scale or fm) end ch.is+=1 if ch.is>14 then ch.is=1 end
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
bu.de=x-(bu.w*8)/2 bu.hu=y-(bu.h*8)+1-fu x=bu.de y=bu.hu end bu.hr={x=x,y=y+fu,ju=x+w-1,jv=y+h+fu-1,ki=ki,kj=kj} end function fk(kk,kl) local km,kn,ko,kp,kq={},{},{},nil,nil kr(km,kk,0) kn[ks(kk)]=nil ko[ks(kk)]=0 while#km>0 and#km<1000 do local kt=km[#km] del(km,km[#km]) ku=kt[1] if ks(ku)==ks(kl) then
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
