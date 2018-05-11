
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
add(fc.objects,bu) bu.owner=nil end bu.in_room=fc end bu.x,bu.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=mid(room_curr.fn or 0.15,ch.y/40,1) fm*=(room_curr.fo or 1) local fp=ch.walk_speed*(ch.scale or fm) local fq=(fl[1]-room_curr.map[1])*8+4 local fr=(fl[2]-room_curr.map[2])*8+4 local fs=sqrt((fq-ch.x)^2+(fr-ch.y)^2) local ft=fp*(fq-ch.x)/fs local fu=fp*(fr-ch.y)/fs if ch.fd==0 then
return end if fs>5 then
ch.flip=(ft<0) if abs(ft)<fp/2 then
if fu>0 then
ch.fv=ch.walk_anim_front ch.face_dir="face_front"else ch.fv=ch.walk_anim_back ch.face_dir="face_back"end else ch.fv=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end for ew=0,fs/fp do ch.x+=ft ch.y+=fu yield() end end end ch.fd=2 end function wait_for_actor(ch) ch=ch or selected_actor while ch.fd!=2 do yield() end end function proximity(ca,cb) if ca.in_room==cb.in_room then
local fs=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fs else return 1000 end end fw=16 cam_x,cf,ci,br=0,nil,nil,0 fx,fy,fz,ga=63.5,63.5,0,1 gb={{spr=ui_uparrowspr,x=75,y=fw+60},{spr=ui_dnarrowspr,x=75,y=fw+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function gc(bu) local gd={} for ek,bw in pairs(bu) do add(gd,ek) end return gd end function get_verb(bu) local bz={} local gd=gc(bu[1]) add(bz,gd[1]) add(bz,bu[1][gd[1]]) add(bz,bu.text) return bz end function ec() ge=get_verb(verb_default) gf,gg,o,gh,gi=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gj={} dz,dz=0,0 gk=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gl() start_script(startup_script,true) end function _update60() gm() end function _draw() gn() end function gm() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end go(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gk=3 end cr=nil end end else go(eb) end gp() gq() gr,gs=1.5-rnd(3),1.5-rnd(3) gr=flr(gr*br) gs=flr(gs*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gn() rectfill(0,0,127,127,0) camera(cam_x+gr,0+gs) clip(0+dz-gr,fw+dz-gs,128-dz*2-gr,64-dz*2) gt() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fw-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fw-8,8) end if show_debuginfo then
print("x: "..flr(fx+cam_x).." y:"..fy-fw,80,fw-8,8) end gu() if ct
and ct.cv then gv() gw() return end if gk>0 then
gk-=1 return end if not cr then
gx() end if(not cr
or cr.cm==2) and gk==0 then gy() else end if not cr then
gw() end end function gp() if cr then
if(btnp(5) or stat(34)>0)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end return end if btn(0) then fx-=1 end
if btn(1) then fx+=1 end
if btn(2) then fy-=1 end
if btn(3) then fy+=1 end
if btnp(4) then gz(1) end
if btnp(5) then gz(2) end
if enable_mouse then
ha,hb=stat(32)-1,stat(33)-1 if ha!=hc then fx=ha end
if hb!=hd then fy=hb end
if stat(34)>0 then
if not he then
gz(stat(34)) he=true end else he=false end hc=ha hd=hb end fx=mid(0,fx,127) fy=mid(0,fy,127) end function gz(hf) local hg=ge if not selected_actor then
return end if ct and ct.cv then
if hh then
selected_sentence=hh end return end if hi then
ge=get_verb(hi) elseif hj then if hf==1 then
if(ge[2]=="use"or ge[2]=="give")
and gf then gg=hj else gf=hj end elseif hk then ge=get_verb(hk) gf=hj gc(gf) gx() end elseif hl then if hl==gb[1] then
if selected_actor.hm>0 then
selected_actor.hm-=1 end else if selected_actor.hm+2<flr(#selected_actor.bo/4) then
selected_actor.hm+=1 end end return end if gf!=nil
then if ge[2]=="use"or ge[2]=="give"then
if gg then
elseif gf.use_with and gf.owner==selected_actor then return end end gh=true selected_actor.cn=cocreate(function() if(not gf.owner
and(not has_flag(gf.classes,"class_actor") or ge[2]!="use")) or gg then hn=gg or gf ho=get_use_pos(hn) walk_to(selected_actor,ho.x,ho.y) if selected_actor.fd!=2 then return end
use_dir=hn if hn.use_dir then use_dir=hn.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(ge,gf) then
start_script(gf.verbs[ge[1]],false,gf,gg) else if has_flag(gf.classes,"class_door") then
if ge[2]=="walkto"then
come_out_door(gf,gf.target_door) elseif ge[2]=="open"then open_door(gf,gf.target_door) elseif ge[2]=="close"then close_door(gf,gf.target_door) end else by(ge[2],gf,gg) end end ec() end) coresume(selected_actor.cn) elseif fy>fw and fy<fw+64 then gh=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fx+cam_x,fy-fw) ec() end) coresume(selected_actor.cn) end end function gq() if not room_curr then
return end hi,hk,hj,hh,hl=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if hp(ej) then
hh=ej end end return end hq() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hr(bu,bu.w*8,bu.h*8,cam_x,hs) else bu.ht=nil end if hp(bu) then
if not hj
or(not bu.z and hj.z<0) or(bu.z and hj.z and bu.z>hj.z) then hj=bu end end hu(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hr(ch,ch.w*8,ch.h*8,cam_x,hs) hu(ch) if hp(ch)
and ch!=selected_actor then hj=ch end end end if selected_actor then
for bw in all(verbs) do if hp(bw) then
hi=bw end end for hv in all(gb) do if hp(hv) then
hl=hv end end for ek,bu in pairs(selected_actor.bo) do if hp(bu) then
hj=bu if ge[2]=="pickup"and hj.owner then
ge=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if ge==nil then
ge=get_verb(verb_default) end if hj then
hk=bt(hj) end end end function hq() gj={} for x=-64,64 do gj[x]={} end end function hu(bu) eq=-1 if bu.hw then
eq=bu.y else eq=bu.y+(bu.h*8) end hx=flr(eq) if bu.z then
hx=bu.z end add(gj[hx],bu) end function gt() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fw,8,0) return end rectfill(0,fw,127,fw+64,room_curr.hy or 0) for z=-64,64 do if z==0 then
hz(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fw,room_curr.ia,room_curr.ib) pal() else hx=gj[z] for bu in all(hx) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then ic(bu) end else if bu.in_room==room_curr then
id(bu) end end ie(bu) end end end end function hz(bu) if bu.col_replace then
ig=bu.col_replace pal(ig[1],ig[2]) end if bu.lighting then
ih(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ih(bu.in_room.lighting) end end function ic(bu) hz(bu) if bu.draw then
bu.draw(bu) else ii=1 if bu.repeat_x then ii=bu.repeat_x end
for h=0,ii-1 do local ij=0 if bu.states then
ij=bu.states[bu.state] else ij=bu[bu.state] end ik(ij,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x,bu.scale) end end pal() end function id(ch) il=dl[ch.face_dir] if ch.fd==1
and ch.fv then ch.im+=1 if ch.im>ch.frame_delay then
ch.im=1 ch.io+=1 if ch.io>#ch.fv then ch.io=1 end
end ip=ch.fv[ch.io] else ip=ch.idle[il] end hz(ch) local fm=mid(room_curr.fn or 0,(ch.y+12)/64,1) fm*=(room_curr.fo or 1) local scale=ch.scale or fm local iq=(8*ch.h) local ir=(8*ch.w) local is=iq-(iq*scale) local it=ir-(ir*scale) ik(ip,ch.de+flr(it/2),ch.hw+is,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if er
and er==ch and er.talk then if ch.iu<7 then
ip=ch.talk[il] ik(ip,ch.de+flr(it/2),ch.hw+flr(8*scale)+is,1,1,ch.trans_col,ch.flip,false,scale) end ch.iu+=1 if ch.iu>14 then ch.iu=1 end
end pal() end function gx() iv=""iw=verb_maincol ix=ge[2] if ge then
iv=ge[3] end if gf then
iv=iv.." "..gf.name if ix=="use"then
iv=iv.." with"elseif ix=="give"then iv=iv.." to"end end if gg then
iv=iv.." "..gg.name elseif hj and hj.name!=""and(not gf or(gf!=hj)) and(not hj.owner or ix!=get_verb(verb_default)[2]) then iv=iv.." "..hj.name end gi=iv if gh then
iv=gi iw=verb_hovcol end print(iy(iv),iz(iv),fw+66,iw) end function gu() if en then
ja=0 for jb in all(en.ez) do jc=0 if en.es==1 then
jc=((en.db*4)-(#jb*4))/2 end outline_text(jb,en.x+jc,en.y+ja,en.col,0,en.eo) ja+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gy() ey,eq,jd=0,75,0 for bw in all(verbs) do je=verb_maincol if hk
and bw==hk then je=verb_defcol end if bw==hi then je=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fw+1,verb_shadcol) print(bx[3],ey,eq+fw,je) bw.x=ey bw.y=eq hr(bw,#bx[3]*4,5,0,0) ie(bw) if#bx[3]>jd then jd=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(jd+1.0)*4 jd=0 end end if selected_actor then
ey,eq=86,76 jf=selected_actor.hm*4 jg=min(jf+8,#selected_actor.bo) for jh=1,8 do rectfill(ey-1,fw+eq-1,ey+8,fw+eq+8,verb_shadcol) bu=selected_actor.bo[jf+jh] if bu then
bu.x,bu.y=ey,eq ic(bu) hr(bu,bu.w*8,bu.h*8,0,0) ie(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end jh+=1 end for ew=1,2 do ji=gb[ew] if hl==ji then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ik(ji.spr,ji.x,ji.y,1,1,0) hr(ji,8,7,0,0) ie(ji) pal() end end end function gv() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hr(ej,ej.db*4,#ej.cw*5,0,0) je=ct.col if ej==hh then je=ct.dc end
for jb in all(ej.cw) do print(iy(jb),ey,eq+fw,je) eq+=5 end ie(ej) eq+=2 end end end function gw() col=ui_cursor_cols[ga] pal(7,col) spr(ui_cursorspr,fx-4,fy-3,1,1,0) pal() fz+=1 if fz>7 then
fz=1 ga+=1 if ga>#ui_cursor_cols then ga=1 end
end end function ik(jj,x,y,w,h,jk,flip_x,jl,scale) set_trans_col(jk,true) local jm=8*(jj%16) local jn=8*flr(jj/16) local jo=8*w local jp=8*h local jq=scale or 1 local jr=jo*jq local js=jp*jq sspr(jm,jn,jo,jp,x,fw+y,jr,js,flip_x,jl) end function set_trans_col(jk,bq) palt(0,false) palt(jk,true) if jk and jk>0 then
palt(0,false) end end function gl() for fc in all(rooms) do jt(fc) if(#fc.map>2) then
fc.ia=fc.map[3]-fc.map[1]+1 fc.ib=fc.map[4]-fc.map[2]+1 else fc.ia=16 fc.ib=8 end for bu in all(fc.objects) do jt(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for ju,ch in pairs(actors) do jt(ch) ch.fd=2 ch.im=1 ch.iu=1 ch.io=1 ch.bo={} ch.hm=0 end end function ie(bu) local jv=bu.ht if show_collision
and jv then rect(jv.x,jv.y,jv.jw,jv.jx,8) end end function go(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ih(jy) if jy then jy=1-jy end
local fl=flr(mid(0,jy,1)*100) local jz={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for ka=1,15 do col=ka kb=(fl+(ka*1.46))/22 for ek=1,kb do col=jz[col] end pal(ka,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.ia*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function kc(fg,fh) local kd=mget(fg,fh) local ke=fget(kd,0) return ke end function cx(msg,eu) local cw={} local kf=""local kg=""local ex=""local kh=function(ki) if#kg+#kf>ki then
add(cw,kf) kf=""end kf=kf..kg kg=""end for ew=1,#msg do ex=sub(msg,ew,ew) kg=kg..ex if ex==" "
or#kg>eu-1 then kh(eu) elseif#kg>eu-1 then kg=kg.."-"kh(eu) elseif ex==";"then kf=kf..sub(kg,1,#kg-1) kg=""kh(0) end end kh(eu) if kf!=""then
add(cw,kf) end return cw end function cz(cw) cy=0 for jb in all(cw) do if#jb>cy then cy=#jb end
end return cy end function has_flag(bu,kj) for be in all(bu) do if be==kj then
return true end end return false end function hr(bu,w,h,kk,kl) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.hw=y-(bu.h*8)+1 x=bu.de y=bu.hw end bu.ht={x=x,y=y+fw,jw=x+w-1,jx=y+h+fw-1,kk=kk,kl=kl} end function fk(km,kn) local ko,kp,kq,kr,ks={},{},{},nil,nil kt(ko,km,0) kp[ku(km)]=nil kq[ku(km)]=0 while#ko>0 and#ko<1000 do local kv=ko[#ko] del(ko,ko[#ko]) kw=kv[1] if ku(kw)==ku(kn) then
break end local kx={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local ky=kw[1]+x local kz=kw[2]+y if abs(x)!=abs(y) then la=1 else la=1.4 end
if ky>=room_curr.map[1] and ky<=room_curr.map[1]+room_curr.ia
and kz>=room_curr.map[2] and kz<=room_curr.map[2]+room_curr.ib and kc(ky,kz) and((abs(x)!=abs(y)) or kc(ky,kw[2]) or kc(ky-x,kz) or enable_diag_squeeze) then add(kx,{ky,kz,la}) end end end end for lb in all(kx) do local lc=ku(lb) local ld=kq[ku(kw)]+lb[3] if not kq[lc]
or ld<kq[lc] then kq[lc]=ld local h=max(abs(kn[1]-lb[1]),abs(kn[2]-lb[2])) local le=ld+h kt(ko,lb,le) kp[lc]=kw if not kr
or h<kr then kr=h ks=lc lf=lb end end end end local fj={} kw=kp[ku(kn)] if kw then
add(fj,kn) elseif ks then kw=kp[ks] add(fj,lf) end if kw then
local lg=ku(kw) local lh=ku(km) while lg!=lh do add(fj,kw) kw=kp[lg] lg=ku(kw) end for ew=1,#fj/2 do local li=fj[ew] local lj=#fj-(ew-1) fj[ew]=fj[lj] fj[lj]=li end end return fj end function kt(lk,cd,fl) if#lk>=1 then
add(lk,{}) for ew=(#lk),2,-1 do local lb=lk[ew-1] if fl<lb[2] then
lk[ew]={cd,fl} return else lk[ew]=lb end end lk[1]={cd,fl} else add(lk,{cd,fl}) end end function ku(ll) return((ll[1]+1)*16)+ll[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jt(bu) local cw=lm(bu.data,"\n") for jb in all(cw) do local pairs=lm(jb,"=") if#pairs==2 then
bu[pairs[1]]=ln(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function lm(ej,lo) local lp={} local jf=0 local lq=0 for ew=1,#ej do local lr=sub(ej,ew,ew) if lr==lo then
add(lp,sub(ej,jf,lq)) jf=0 lq=0 elseif lr!=" "and lr!="\t"then lq=ew if jf==0 then jf=ew end
end end if jf+lq>0 then
add(lp,sub(ej,jf,lq)) end return lp end function ln(lt) local lu=sub(lt,1,1) local lp=nil if lt=="true"then
lp=true elseif lt=="false"then lp=false elseif lv(lu) then if lu=="-"then
lp=sub(lt,2,#lt)*-1 else lp=lt+0 end elseif lu=="{"then local li=sub(lt,2,#lt-1) lp=lm(li,",") lw={} for cd in all(lp) do cd=ln(cd) add(lw,cd) end lp=lw else lp=lt end return lp end function lv(ig) for a=1,13 do if ig==sub("0123456789.-+",a,a) then
return true end end end function outline_text(lx,x,y,ly,lz,eo) if not eo then lx=iy(lx) end
for ma=-1,1 do for mb=-1,1 do print(lx,x+ma,y+mb,lz) end end print(lx,x,y,ly) end function iz(ej) return 63.5-flr((#ej*4)/2) end function mc(ej) return 61 end function hp(bu) if not bu.ht
or cr then return false end ht=bu.ht if(fx+ht.kk>ht.jw or fx+ht.kk<ht.x)
or(fy>ht.jx or fy<ht.y) then return false else return true end end function iy(ej) local a=""local jb,ig,lk=false,false for ew=1,#ej do local hv=sub(ej,ew,ew) if hv=="^"then
if ig then a=a..hv end
ig=not ig elseif hv=="~"then if lk then a=a..hv end
lk,jb=not lk,not jb else if ig==jb and hv>="a"and hv<="z"then
for ka=1,26 do if hv==sub("abcdefghijklmnopqrstuvwxyz",ka,ka) then
hv=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",ka,ka) break end end end a=a..hv ig,lk=false,false end end return a end
