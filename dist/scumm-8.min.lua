
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
add(fc.objects,bu) bu.owner=nil end bu.in_room=fc end bu.x,bu.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=mid(room_curr.min_autoscale or 0.15,ch.y/40,1) fm*=(room_curr.autoscale_zoom or 1) local fn=ch.walk_speed*(ch.fo or fm) local fp=(fl[1]-room_curr.map[1])*8+4 local fq=(fl[2]-room_curr.map[2])*8+4 local fr=sqrt((fp-ch.x)^2+(fq-ch.y)^2) local fs=fn*(fp-ch.x)/fr local ft=fn*(fq-ch.y)/fr if ch.fd==0 then
return end if fr>5 then
ch.flip=(fs<0) if abs(fs)<fn/2 then
if ft>0 then
ch.fu=ch.walk_anim_front ch.face_dir="face_front"else ch.fu=ch.walk_anim_back ch.face_dir="face_back"end else ch.fu=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end for ew=0,fr/fn do ch.x+=fs ch.y+=ft yield() end end end ch.fd=2 end function wait_for_actor(ch) ch=ch or selected_actor while ch.fd!=2 do yield() end end function proximity(ca,cb) if ca.in_room==cb.in_room then
local fr=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fr else return 1000 end end fv=16 cam_x,cf,ci,br=0,nil,nil,0 fw,fx,fy,fz=63.5,63.5,0,1 ga={{spr=ui_uparrowspr,x=75,y=fv+60},{spr=ui_dnarrowspr,x=75,y=fv+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function gb(bu) local gc={} for ek,bw in pairs(bu) do add(gc,ek) end return gc end function get_verb(bu) local bz={} local gc=gb(bu[1]) add(bz,gc[1]) add(bz,bu[1][gc[1]]) add(bz,bu.text) return bz end function ec() gd=get_verb(verb_default) ge,gf,o,gg,gh=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gi={} dz,dz=0,0 gj=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gk() start_script(startup_script,true) end function _update60() gl() end function _draw() gm() end function gl() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gn(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gj=3 end cr=nil end end else gn(eb) end go() gp() gq,gr=1.5-rnd(3),1.5-rnd(3) gq=flr(gq*br) gr=flr(gr*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gm() rectfill(0,0,127,127,0) camera(cam_x+gq,0+gr) clip(0+dz-gq,fv+dz-gr,128-dz*2-gq,64-dz*2) gs() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fv-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fv-8,8) end if show_debuginfo then
print("x: "..flr(fw+cam_x).." y:"..fx-fv,80,fv-8,8) end gt() if ct
and ct.cv then gu() gv() return end if gj>0 then
gj-=1 return end if not cr then
gw() end if(not cr
or cr.cm==2) and gj==0 then gx() else end if not cr then
gv() end end function go() if cr then
if(btnp(5) or stat(34)>0)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end return end if btn(0) then fw-=1 end
if btn(1) then fw+=1 end
if btn(2) then fx-=1 end
if btn(3) then fx+=1 end
if btnp(4) then gy(1) end
if btnp(5) then gy(2) end
if enable_mouse then
gz,ha=stat(32)-1,stat(33)-1 if gz!=hb then fw=gz end
if ha!=hc then fx=ha end
if stat(34)>0 then
if not hd then
gy(stat(34)) hd=true end else hd=false end hb=gz hc=ha end fw=mid(0,fw,127) fx=mid(0,fx,127) end function gy(he) local hf=gd if not selected_actor then
return end if ct and ct.cv then
if hg then
selected_sentence=hg end return end if hh then
gd=get_verb(hh) elseif hi then if he==1 then
if(gd[2]=="use"or gd[2]=="give")
and ge then gf=hi else ge=hi end elseif hj then gd=get_verb(hj) ge=hi gb(ge) gw() end elseif hk then if hk==ga[1] then
if selected_actor.hl>0 then
selected_actor.hl-=1 end else if selected_actor.hl+2<flr(#selected_actor.bo/4) then
selected_actor.hl+=1 end end return end if ge!=nil
then if gd[2]=="use"or gd[2]=="give"then
if gf then
elseif ge.use_with and ge.owner==selected_actor then return end end gg=true selected_actor.cn=cocreate(function() if(not ge.owner
and(not has_flag(ge.classes,"class_actor") or gd[2]!="use")) or gf then hm=gf or ge hn=get_use_pos(hm) walk_to(selected_actor,hn.x,hn.y) if selected_actor.fd!=2 then return end
use_dir=hm if hm.use_dir then use_dir=hm.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gd,ge) then
start_script(ge.verbs[gd[1]],false,ge,gf) else if has_flag(ge.classes,"class_door") then
if gd[2]=="walkto"then
come_out_door(ge,ge.target_door) elseif gd[2]=="open"then open_door(ge,ge.target_door) elseif gd[2]=="close"then close_door(ge,ge.target_door) end else by(gd[2],ge,gf) end end ec() end) coresume(selected_actor.cn) elseif fx>fv and fx<fv+64 then gg=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fw+cam_x,fx-fv) ec() end) coresume(selected_actor.cn) end end function gp() if not room_curr then
return end hh,hj,hi,hg,hk=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if ho(ej) then
hg=ej end end return end hp() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hq(bu,bu.w*8,bu.h*8,cam_x,hr) else bu.hs=nil end if ho(bu) then
if not hi
or(not bu.z and hi.z<0) or(bu.z and hi.z and bu.z>hi.z) then hi=bu end end ht(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hq(ch,ch.w*8,ch.h*8,cam_x,hr) ht(ch) if ho(ch)
and ch!=selected_actor then hi=ch end end end if selected_actor then
for bw in all(verbs) do if ho(bw) then
hh=bw end end for hu in all(ga) do if ho(hu) then
hk=hu end end for ek,bu in pairs(selected_actor.bo) do if ho(bu) then
hi=bu if gd[2]=="pickup"and hi.owner then
gd=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if gd==nil then
gd=get_verb(verb_default) end if hi then
hj=bt(hi) end end end function hp() gi={} for x=-64,64 do gi[x]={} end end function ht(bu) eq=-1 if bu.hv then
eq=bu.y else eq=bu.y+(bu.h*8) end hw=flr(eq) if bu.z then
hw=bu.z end add(gi[hw],bu) end function gs() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fv,8,0) return end rectfill(0,fv,127,fv+64,room_curr.hx or 0) for z=-64,64 do if z==0 then
hy(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fv,room_curr.hz,room_curr.ia) pal() else hw=gi[z] for bu in all(hw) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then ib(bu) end else if bu.in_room==room_curr then
ic(bu) end end id(bu) end end end end function hy(bu) if bu.col_replace then
ie=bu.col_replace pal(ie[1],ie[2]) end if bu.lighting then
ig(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ig(bu.in_room.lighting) end end function ib(bu) hy(bu) if bu.draw then
bu.draw(bu) else ih=1 if bu.repeat_x then ih=bu.repeat_x end
for h=0,ih-1 do local ii=0 if bu.states then
ii=bu.states[bu.state] else ii=bu[bu.state] end ij(ii,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x,bu.fo) end end pal() end function ic(ch) ik=dl[ch.face_dir] if ch.fd==1
and ch.fu then ch.il+=1 if ch.il>ch.frame_delay then
ch.il=1 ch.im+=1 if ch.im>#ch.fu then ch.im=1 end
end io=ch.fu[ch.im] else io=ch.idle[ik] end hy(ch) local fm=mid(room_curr.min_autoscale or 0,(ch.y+12)/64,1) fm*=(room_curr.autoscale_zoom or 1) printh("auto_scale:"..fm) local fo=ch.fo or fm local ip=(8*ch.h) local iq=(8*ch.w) local ir=ip-(ip*fo) local is=iq-(iq*fo) ij(io,ch.de+flr(is/2),ch.hv+ir,ch.w,ch.h,ch.trans_col,ch.flip,false,fo) if er
and er==ch and er.talk then if ch.it<7 then
io=ch.talk[ik] ij(io,ch.de+flr(is/2),ch.hv+flr(8*fo)+ir,1,1,ch.trans_col,ch.flip,false,fo) end ch.it+=1 if ch.it>14 then ch.it=1 end
end pal() end function gw() iu=""iv=verb_maincol iw=gd[2] if gd then
iu=gd[3] end if ge then
iu=iu.." "..ge.name if iw=="use"then
iu=iu.." with"elseif iw=="give"then iu=iu.." to"end end if gf then
iu=iu.." "..gf.name elseif hi and hi.name!=""and(not ge or(ge!=hi)) and(not hi.owner or iw!=get_verb(verb_default)[2]) then iu=iu.." "..hi.name end gh=iu if gg then
iu=gh iv=verb_hovcol end print(ix(iu),iy(iu),fv+66,iv) end function gt() if en then
iz=0 for ja in all(en.ez) do jb=0 if en.es==1 then
jb=((en.db*4)-(#ja*4))/2 end outline_text(ja,en.x+jb,en.y+iz,en.col,0,en.eo) iz+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gx() ey,eq,jc=0,75,0 for bw in all(verbs) do jd=verb_maincol if hj
and bw==hj then jd=verb_defcol end if bw==hh then jd=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fv+1,verb_shadcol) print(bx[3],ey,eq+fv,jd) bw.x=ey bw.y=eq hq(bw,#bx[3]*4,5,0,0) id(bw) if#bx[3]>jc then jc=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(jc+1.0)*4 jc=0 end end if selected_actor then
ey,eq=86,76 je=selected_actor.hl*4 jf=min(je+8,#selected_actor.bo) for jg=1,8 do rectfill(ey-1,fv+eq-1,ey+8,fv+eq+8,verb_shadcol) bu=selected_actor.bo[je+jg] if bu then
bu.x,bu.y=ey,eq ib(bu) hq(bu,bu.w*8,bu.h*8,0,0) id(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end jg+=1 end for ew=1,2 do jh=ga[ew] if hk==jh then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ij(jh.spr,jh.x,jh.y,1,1,0) hq(jh,8,7,0,0) id(jh) pal() end end end function gu() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hq(ej,ej.db*4,#ej.cw*5,0,0) jd=ct.col if ej==hg then jd=ct.dc end
for ja in all(ej.cw) do print(ix(ja),ey,eq+fv,jd) eq+=5 end id(ej) eq+=2 end end end function gv() col=ui_cursor_cols[fz] pal(7,col) spr(ui_cursorspr,fw-4,fx-3,1,1,0) pal() fy+=1 if fy>7 then
fy=1 fz+=1 if fz>#ui_cursor_cols then fz=1 end
end end function ij(ji,x,y,w,h,jj,flip_x,jk,fo) set_trans_col(jj,true) local jl=8*(ji%16) local jm=8*flr(ji/16) local jn=8*w local jo=8*h local jp=fo or 1 local jq=jn*jp local jr=jo*jp sspr(jl,jm,jn,jo,x,fv+y,jq,jr,flip_x,jk) end function set_trans_col(jj,bq) palt(0,false) palt(jj,true) if jj and jj>0 then
palt(0,false) end end function gk() for fc in all(rooms) do js(fc) if(#fc.map>2) then
fc.hz=fc.map[3]-fc.map[1]+1 fc.ia=fc.map[4]-fc.map[2]+1 else fc.hz=16 fc.ia=8 end for bu in all(fc.objects) do js(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for jt,ch in pairs(actors) do js(ch) ch.fd=2 ch.il=1 ch.it=1 ch.im=1 ch.bo={} ch.hl=0 end end function id(bu) local ju=bu.hs if show_collision
and ju then rect(ju.x,ju.y,ju.jv,ju.jw,8) end end function gn(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ig(jx) if jx then jx=1-jx end
local fl=flr(mid(0,jx,1)*100) local jy={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jz=1,15 do col=jz ka=(fl+(jz*1.46))/22 for ek=1,ka do col=jy[col] end pal(jz,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hz*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function kb(fg,fh) local kc=mget(fg,fh) local kd=fget(kc,0) return kd end function cx(msg,eu) local cw={} local ke=""local kf=""local ex=""local kg=function(kh) if#kf+#ke>kh then
add(cw,ke) ke=""end ke=ke..kf kf=""end for ew=1,#msg do ex=sub(msg,ew,ew) kf=kf..ex if ex==" "
or#kf>eu-1 then kg(eu) elseif#kf>eu-1 then kf=kf.."-"kg(eu) elseif ex==";"then ke=ke..sub(kf,1,#kf-1) kf=""kg(0) end end kg(eu) if ke!=""then
add(cw,ke) end return cw end function cz(cw) cy=0 for ja in all(cw) do if#ja>cy then cy=#ja end
end return cy end function has_flag(bu,ki) for be in all(bu) do if be==ki then
return true end end return false end function hq(bu,w,h,kj,kk) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.hv=y-(bu.h*8)+1 x=bu.de y=bu.hv end bu.hs={x=x,y=y+fv,jv=x+w-1,jw=y+h+fv-1,kj=kj,kk=kk} end function fk(kl,km) local kn,ko,kp,kq,kr={},{},{},nil,nil ks(kn,kl,0) ko[kt(kl)]=nil kp[kt(kl)]=0 while#kn>0 and#kn<1000 do local ku=kn[#kn] del(kn,kn[#kn]) kv=ku[1] if kt(kv)==kt(km) then
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
or cr then return false end hs=bu.hs if(fw+hs.kj>hs.jv or fw+hs.kj<hs.x)
or(fx>hs.jw or fx<hs.y) then return false else return true end end function ix(ej) local a=""local ja,ie,lj=false,false for ew=1,#ej do local hu=sub(ej,ew,ew) if hu=="^"then
if ie then a=a..hu end
ie=not ie elseif hu=="~"then if lj then a=a..hu end
lj,ja=not lj,not ja else if ie==ja and hu>="a"and hu<="z"then
for jz=1,26 do if hu==sub("abcdefghijklmnopqrstuvwxyz",jz,jz) then
hu=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jz,jz) break end end end a=a..hu ie,lj=false,false end end return a end
