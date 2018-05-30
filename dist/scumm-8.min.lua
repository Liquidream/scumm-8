
-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(bp) if bp then
bq=1 end br=bp end function bs(bt) local bu=nil if has_flag(bt.classes,"class_talkable") then
bu="talkto"elseif has_flag(bt.classes,"class_openable") then if bt.state=="state_closed"then
bu="open"else bu="close"end else bu="lookat"end for bv in all(verbs) do bw=get_verb(bv) if bw[2]==bu then bu=bv break end
end return bu end function bx(by,bz,ca) local cb=has_flag(bz.classes,"class_actor") if by=="walkto"then
return elseif by=="pickup"then if cb then
say_line"i don't need them"else say_line"i don't need that"end elseif by=="use"then if cb then
say_line"i can't just *use* someone"end if ca then
if has_flag(ca.classes,class_actor) then
say_line"i can't use that on someone!"else say_line"that doesn't work"end end elseif by=="give"then if cb then
say_line"i don't think i should be giving this away"else say_line"i can't do that"end elseif by=="lookat"then if cb then
say_line"i think it's alive"else say_line"looks pretty ordinary"end elseif by=="open"then if cb then
say_line"they don't seem to open"else say_line"it doesn't seem to open"end elseif by=="close"then if cb then
say_line"they don't seem to close"else say_line"it doesn't seem to close"end elseif by=="push"or by=="pull"then if cb then
say_line"moving them would accomplish nothing"else say_line"it won't budge!"end elseif by=="talkto"then if cb then
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cc) cam_x=ce(cc) cf=nil cg=nil end function camera_follow(ch) stop_script(ci) cg=ch cf=nil ci=function() while cg do if cg.in_room==room_curr then
cam_x=ce(cg) end yield() end end start_script(ci,true) if cg.in_room!=room_curr then
change_room(cg.in_room,1) end end function camera_pan_to(cc) cf=ce(cc) cg=nil ci=function() while(true) do if cam_x==cf then
cf=nil return elseif cf>cam_x then cam_x+=0.5 else cam_x-=0.5 end yield() end end start_script(ci,true) end function wait_for_camera() while script_running(ci) do yield() end end function cutscene(type,cj,ck) cl={cm=type,cn=cocreate(cj),co=ck,cp=cg} add(cq,cl) cr=cl break_time() end function dialog_set(cs) for msg in all(cs) do dialog_add(msg) end end function dialog_add(msg) if not ct then ct={cu={},cv=false} end
cw=cx(msg,32) cy=cz(cw) da={num=#ct.cu+1,msg=msg,cw=cw,db=cy} add(ct.cu,da) end function dialog_start(col,dc) ct.col=col ct.dc=dc ct.cv=true selected_sentence=nil end function dialog_hide() ct.cv=false end function dialog_clear() ct.cu={} selected_sentence=nil end function dialog_end() ct=nil end function get_use_pos(bt) local dd=bt.use_pos local x=bt.x local y=bt.y if type(dd)=="table"then
x=dd[1] y=dd[2] elseif dd=="pos_left"then if bt.de then
x-=(bt.w*8+4) y+=1 else x-=2 y+=((bt.h*8)-2) end elseif dd=="pos_right"then x+=(bt.w*8) y+=((bt.h*8)-2) elseif dd=="pos_above"then x+=((bt.w*8)/2)-4 y-=2 elseif dd=="pos_center"then x+=((bt.w*8)/2) y+=((bt.h*8)/2)-4 elseif dd=="pos_infront"or dd==nil then x+=((bt.w*8)/2)-4 y+=(bt.h*8)+2 end return{x=x,y=y} end function do_anim(ch,df,dg) dh={"face_front","face_left","face_back","face_right"} if df=="anim_face"then
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
dw=dv[dq.use_dir] else dw=1 end selected_actor.face_dir=dw selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(dx,bc) if bc==1 then
dy=0 else dy=50 end while true do dy+=bc*2 if dy>50
or dy<0 then return end if dx==1 then
dz=min(dy,32) end yield() end end function change_room(dt,dx) if dt==nil then
ds("room does not exist") return end stop_script(ea) if dx and room_curr then
fades(dx,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end eb={} ec() room_curr=dt if not cg
or cg.in_room!=room_curr then cam_x=0 end stop_talking() if dx then
ea=function() fades(dx,-1) end start_script(ea,true) else dz=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(by,ed) if not ed
or not ed.verbs then return false end if type(by)=="table"then
if ed.verbs[by[1]] then return true end
else if ed.verbs[by] then return true end
end return false end function pickup_obj(bt,ch) ch=ch or selected_actor add(ch.bn,bt) bt.owner=ch del(bt.in_room.objects,bt) end function start_script(ee,ef,eg,eh) local cn=cocreate(ee) local scripts=eb if ef then
scripts=ei end add(scripts,{ee,cn,eg,eh}) end function script_running(ee) for ej in all({eb,ei}) do for ek,el in pairs(ej) do if el[1]==ee then
return el end end end return false end function stop_script(ee) el=script_running(ee) if el then
del(eb,el) del(ei,el) end end function break_time(em) em=em or 1 for x=1,em do yield() end end function wait_for_message() while en!=nil do yield() end end function say_line(ch,msg,eo,ep) if type(ch)=="string"then
msg=ch ch=selected_actor end eq=ch.y-(ch.h)*8+4 er=ch print_line(msg,ch.x,eq,ch.col,1,eo,ep) end function stop_talking() en,er=nil,nil end function print_line(msg,x,y,col,es,eo,ep) local col=col or 7 local es=es or 0 if es==1 then
et=min(x-cam_x,127-(x-cam_x)) else et=127-(x-cam_x) end local eu=max(flr(et/2),16) local ev=""for ew=1,#msg do local ex=sub(msg,ew,ew) if ex==":"then
ev=sub(msg,ew+1) msg=sub(msg,1,ew-1) break end end local cw=cx(msg,eu) local cy=cz(cw) ey=x-cam_x if es==1 then
ey-=((cy*4)/2) end ey=max(2,ey) eq=max(18,y) ey=min(ey,127-(cy*4)-1) en={ez=cw,x=ey,y=eq,col=col,es=es,fa=ep or(#msg)*8,db=cy,eo=eo} if#ev>0 then
fb=er wait_for_message() er=fb print_line(ev,x,y,col,es,eo) end wait_for_message() end function put_at(bt,x,y,fc) if fc then
if not has_flag(bt.classes,"class_actor") then
if bt.in_room then del(bt.in_room.objects,bt) end
add(fc.objects,bt) bt.owner=nil end bt.in_room=fc end bt.x,bt.y=x,y end function stop_actor(ch) ch.fd=0 ec() end function walk_to(ch,x,y) local fe=ff(ch) local fg=flr(x/8)+room_curr.map[1] local fh=flr(y/8)+room_curr.map[2] local fi={fg,fh} local fj=fk(fe,fi) ch.fd=1 for fl in all(fj) do local fm=ch.walk_speed*(ch.scale or ch.fn) local fo=(fl[1]-room_curr.map[1])*8+4 local fp=(fl[2]-room_curr.map[2])*8+4 local fq=sqrt((fo-ch.x)^2+(fp-ch.y)^2) local fr=fm*(fo-ch.x)/fq local fs=fm*(fp-ch.y)/fq if ch.fd==0 then
return end if fq>5 then
for ew=0,fq/fm do ch.flip=(fr<0) if abs(fr)<fm/2 then
if fs>0 then
ch.ft=ch.walk_anim_front ch.face_dir="face_front"else ch.ft=ch.walk_anim_back ch.face_dir="face_back"end else ch.ft=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end ch.x+=fr ch.y+=fs yield() end end end ch.fd=2 end function wait_for_actor(ch) ch=ch or selected_actor while ch.fd!=2 do yield() end end function proximity(bz,ca) if bz.in_room==ca.in_room then
local fq=sqrt((bz.x-ca.x)^2+(bz.y-ca.y)^2) return fq else return 1000 end end fu=16 cam_x,cf,ci,bq=0,nil,nil,0 fv,fw,fx,fy=63.5,63.5,0,1 fz={{spr=ui_uparrowspr,x=75,y=fu+60},{spr=ui_dnarrowspr,x=75,y=fu+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function ga(bt) local gb={} for ek,bv in pairs(bt) do add(gb,ek) end return gb end function get_verb(bt) local by={} local gb=ga(bt[1]) add(by,gb[1]) add(by,bt[1][gb[1]]) add(by,bt.text) return by end function ec() gc=get_verb(verb_default) gd,ge,n,gf,gg=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gh={} dz,dz=0,0 gi=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gj() start_script(startup_script,true) end function _update60() gk() end function _draw() gl() end function gk() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gm(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gi=3 end cr=nil end end else gm(eb) end gn() go() gp,gq=1.5-rnd(3),1.5-rnd(3) gp=flr(gp*bq) gq=flr(gq*bq) if not br then
bq*=0.90 if bq<0.05 then bq=0 end
end end function gl() rectfill(0,0,127,127,0) camera(cam_x+gp,0+gq) clip(0+dz-gp,fu+dz-gq,128-dz*2-gp,64-dz*2) gr() camera(0,0) clip() if show_debuginfo then
print("x: "..flr(fv+cam_x).." y:"..fw-fu,80,fu-8,8) end gs() if ct
and ct.cv then gt() gu() return end if gi>0 then
gi-=1 return end if not cr then
gv() end if(not cr
or cr.cm==2) and gi==0 then gw() end if not cr then
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
selected_actor.hl-=1 end else if selected_actor.hl+2<flr(#selected_actor.bn/4) then
selected_actor.hl+=1 end end return end if gd!=nil
then if gc[2]=="use"or gc[2]=="give"then
if ge then
elseif gd.use_with and gd.owner==selected_actor then return end end gf=true selected_actor.cn=cocreate(function() if(not gd.owner
and(not has_flag(gd.classes,"class_actor") or gc[2]!="use")) or ge then hm=ge or gd hn=get_use_pos(hm) walk_to(selected_actor,hn.x,hn.y) if selected_actor.fd!=2 then return end
use_dir=hm if hm.use_dir then use_dir=hm.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gc,gd) then
start_script(gd.verbs[gc[1]],false,gd,ge) else if has_flag(gd.classes,"class_door") then
if gc[2]=="walkto"then
come_out_door(gd,gd.target_door) elseif gc[2]=="open"then open_door(gd,gd.target_door) elseif gc[2]=="close"then close_door(gd,gd.target_door) end else bx(gc[2],gd,ge) end end ec() end) coresume(selected_actor.cn) elseif fw>fu and fw<fu+64 then gf=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fv+cam_x,fw-fu) ec() end) coresume(selected_actor.cn) end end function go() if not room_curr then
return end hh,hj,hi,hg,hk=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if ho(ej) then
hg=ej end end return end hp() for bt in all(room_curr.objects) do if(not bt.classes
or(bt.classes and not has_flag(bt.classes,"class_untouchable"))) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) then hq(bt,bt.w*8,bt.h*8,cam_x,hr) else bt.hs=nil end if ho(bt) then
if not hi
or(not bt.z and hi.z<0) or(bt.z and hi.z and bt.z>hi.z) then hi=bt end end ht(bt) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hq(ch,ch.w*8,ch.h*8,cam_x,hr) ht(ch) if ho(ch)
and ch!=selected_actor then hi=ch end end end if selected_actor then
for bv in all(verbs) do if ho(bv) then
hh=bv end end for hu in all(fz) do if ho(hu) then
hk=hu end end for ek,bt in pairs(selected_actor.bn) do if ho(bt) then
hi=bt if gc[2]=="pickup"and hi.owner then
gc=nil end end if bt.owner!=selected_actor then
del(selected_actor.bn,bt) end end if gc==nil then
gc=get_verb(verb_default) end if hi then
hj=bs(hi) end end end function hp() gh={} for x=-64,64 do gh[x]={} end end function ht(bt) eq=-1 if bt.hv then
eq=bt.y else eq=bt.y+(bt.h*8) end hw=flr(eq) if bt.z then
hw=bt.z end add(gh[hw],bt) end function gr() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fu,8,0) return end rectfill(0,fu,127,fu+64,room_curr.hx or 0) for z=-64,64 do if z==0 then
hy(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fu,room_curr.hz,room_curr.ia) pal() else hw=gh[z] for bt in all(hw) do if not has_flag(bt.classes,"class_actor") then
if bt.states
or(bt.state and bt[bt.state] and bt[bt.state]>0) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) and not bt.owner or bt.draw then ib(bt) end else if bt.in_room==room_curr then
ic(bt) end end id(bt) end end end end function hy(bt) if bt.col_replace then
ie=bt.col_replace pal(ie[1],ie[2]) end if bt.lighting then
ig(bt.lighting) elseif bt.in_room and bt.in_room.lighting then ig(bt.in_room.lighting) end end function ib(bt) hy(bt) if bt.draw then
bt.draw(bt) else ih=1 if bt.repeat_x then ih=bt.repeat_x end
for h=0,ih-1 do local ii=0 if bt.states then
ii=bt.states[bt.state] else ii=bt[bt.state] end ij(ii,bt.x+(h*(bt.w*8)),bt.y,bt.w,bt.h,bt.trans_col,bt.flip_x,bt.scale) end end pal() end function ic(ch) ik=dl[ch.face_dir] if ch.fd==1
and ch.ft then ch.il+=1 if ch.il>ch.frame_delay then
ch.il=1 ch.im+=1 if ch.im>#ch.ft then ch.im=1 end
end io=ch.ft[ch.im] else io=ch.idle[ik] end hy(ch) local ip=(ch.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1]) ip=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*ip ch.fn=mid(room_curr.autodepth_scale[1],ip,room_curr.autodepth_scale[2]) local scale=ch.scale or ch.fn local iq=(8*ch.h) local ir=(8*ch.w) local is=iq-(iq*scale) local it=ir-(ir*scale) local iu=ch.de+flr(it/2) local iv=ch.hv+is ij(io,iu,iv,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if er
and er==ch and er.talk then if ch.iw<7 then
ij(ch.talk[ik],iu+(ch.talk[5] or 0),iv+flr((ch.talk[6] or 8)*scale),(ch.talk[7] or 1),(ch.talk[8] or 1),ch.trans_col,ch.flip,false,scale) end ch.iw+=1 if ch.iw>14 then ch.iw=1 end
end pal() end function gv() ix=""iy=verb_maincol iz=gc[2] if gc then
ix=gc[3] end if gd then
ix=ix.." "..gd.name if iz=="use"then
ix=ix.." with"elseif iz=="give"then ix=ix.." to"end end if ge then
ix=ix.." "..ge.name elseif hi and hi.name!=""and(not gd or(gd!=hi)) and(not hi.owner or iz!=get_verb(verb_default)[2]) then ix=ix.." "..hi.name end gg=ix if gf then
ix=gg iy=verb_hovcol end print(ja(ix),jb(ix),fu+66,iy) end function gs() if en then
jc=0 for jd in all(en.ez) do je=0 if en.es==1 then
je=((en.db*4)-(#jd*4))/2 end outline_text(jd,en.x+je,en.y+jc,en.col,0,en.eo) jc+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gw() ey,eq,jf=0,75,0 for bv in all(verbs) do jg=verb_maincol if hj
and bv==hj then jg=verb_defcol end if bv==hh then jg=verb_hovcol end
bw=get_verb(bv) print(bw[3],ey,eq+fu+1,verb_shadcol) print(bw[3],ey,eq+fu,jg) bv.x=ey bv.y=eq hq(bv,#bw[3]*4,5,0,0) id(bv) if#bw[3]>jf then jf=#bw[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(jf+1.0)*4 jf=0 end end if selected_actor then
ey,eq=86,76 jh=selected_actor.hl*4 ji=min(jh+8,#selected_actor.bn) for jj=1,8 do rectfill(ey-1,fu+eq-1,ey+8,fu+eq+8,verb_shadcol) bt=selected_actor.bn[jh+jj] if bt then
bt.x,bt.y=ey,eq ib(bt) hq(bt,bt.w*8,bt.h*8,0,0) id(bt) end ey+=11 if ey>=125 then
eq+=12 ey=86 end jj+=1 end for ew=1,2 do jk=fz[ew] if hk==jk then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ij(jk.spr,jk.x,jk.y,1,1,0) hq(jk,8,7,0,0) id(jk) pal() end end end function gt() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hq(ej,ej.db*4,#ej.cw*5,0,0) jg=ct.col if ej==hg then jg=ct.dc end
for jd in all(ej.cw) do print(ja(jd),ey,eq+fu,jg) eq+=5 end id(ej) eq+=2 end end end function gu() col=ui_cursor_cols[fy] pal(7,col) spr(ui_cursorspr,fv-4,fw-3,1,1,0) pal() fx+=1 if fx>7 then
fx=1 fy+=1 if fy>#ui_cursor_cols then fy=1 end
end end function ij(jl,x,y,w,h,jm,flip_x,jn,scale) set_trans_col(jm,true) local jo=8*(jl%16) local jp=8*flr(jl/16) local jq=8*w local jr=8*h local js=scale or 1 local jt=jq*js local ju=jr*js sspr(jo,jp,jq,jr,x,fu+y,jt,ju,flip_x,jn) end function set_trans_col(jm,bp) palt(0,false) palt(jm,true) if jm and jm>0 then
palt(0,false) end end function gj() for fc in all(rooms) do jv(fc) if(#fc.map>2) then
fc.hz=fc.map[3]-fc.map[1]+1 fc.ia=fc.map[4]-fc.map[2]+1 else fc.hz=16 fc.ia=8 end fc.autodepth_pos=fc.autodepth_pos or{9,50} fc.autodepth_scale=fc.autodepth_scale or{0.25,1} for bt in all(fc.objects) do jv(bt) bt.in_room=fc bt.h=bt.h or 0 if bt.init then
bt.init(bt) end end end for jw,ch in pairs(actors) do jv(ch) ch.fd=2 ch.il=1 ch.iw=1 ch.im=1 ch.bn={} ch.hl=0 end end function id(bt) local jx=bt.hs if show_collision
and jx then rect(jx.x,jx.y,jx.jy,jx.jz,8) end end function gm(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ig(ka) if ka then ka=1-ka end
local fl=flr(mid(0,ka,1)*100) local kb={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kc=1,15 do col=kc kd=(fl+(kc*1.46))/22 for ek=1,kd do col=kb[col] end pal(kc,col) end end function ce(cc) if type(cc)=="table"then
cc=cc.x end return mid(0,cc-64,(room_curr.hz*8)-128) end function ff(bt) local fg=flr(bt.x/8)+room_curr.map[1] local fh=flr(bt.y/8)+room_curr.map[2] return{fg,fh} end function ke(fg,fh) local kf=mget(fg,fh) local kg=fget(kf,0) return kg end function cx(msg,eu) local cw={} local kh=""local ki=""local ex=""local kj=function(kk) if#ki+#kh>kk then
add(cw,kh) kh=""end kh=kh..ki ki=""end for ew=1,#msg do ex=sub(msg,ew,ew) ki=ki..ex if ex==" "
or#ki>eu-1 then kj(eu) elseif#ki>eu-1 then ki=ki.."-"kj(eu) elseif ex==";"then kh=kh..sub(ki,1,#ki-1) ki=""kj(0) end end kj(eu) if kh!=""then
add(cw,kh) end return cw end function cz(cw) cy=0 for jd in all(cw) do if#jd>cy then cy=#jd end
end return cy end function has_flag(bt,kl) for bd in all(bt) do if bd==kl then
return true end end return false end function hq(bt,w,h,km,kn) x=bt.x y=bt.y if has_flag(bt.classes,"class_actor") then
bt.de=x-(bt.w*8)/2 bt.hv=y-(bt.h*8)+1 x=bt.de y=bt.hv end bt.hs={x=x,y=y+fu,jy=x+w-1,jz=y+h+fu-1,km=km,kn=kn} end function fk(ko,kp) local kq,kr,ks,kt,ku={},{},{},nil,nil kv(kq,ko,0) kr[kw(ko)]=nil ks[kw(ko)]=0 while#kq>0 and#kq<1000 do local kx=kq[#kq] del(kq,kq[#kq]) ky=kx[1] if kw(ky)==kw(kp) then
break end local kz={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local la=ky[1]+x local lb=ky[2]+y if abs(x)!=abs(y) then lc=1 else lc=1.4 end
if la>=room_curr.map[1] and la<=room_curr.map[1]+room_curr.hz
and lb>=room_curr.map[2] and lb<=room_curr.map[2]+room_curr.ia and ke(la,lb) and((abs(x)!=abs(y)) or ke(la,ky[2]) or ke(la-x,lb) or enable_diag_squeeze) then add(kz,{la,lb,lc}) end end end end for ld in all(kz) do local le=kw(ld) local lf=ks[kw(ky)]+ld[3] if not ks[le]
or lf<ks[le] then ks[le]=lf local h=max(abs(kp[1]-ld[1]),abs(kp[2]-ld[2])) local lg=lf+h kv(kq,ld,lg) kr[le]=ky if not kt
or h<kt then kt=h ku=le lh=ld end end end end local fj={} ky=kr[kw(kp)] if ky then
add(fj,kp) elseif ku then ky=kr[ku] add(fj,lh) end if ky then
local li=kw(ky) local lj=kw(ko) while li!=lj do add(fj,ky) ky=kr[li] li=kw(ky) end for ew=1,#fj/2 do local lk=fj[ew] local ll=#fj-(ew-1) fj[ew]=fj[ll] fj[ll]=lk end end return fj end function kv(lm,cc,fl) if#lm>=1 then
add(lm,{}) for ew=(#lm),2,-1 do local ld=lm[ew-1] if fl<ld[2] then
lm[ew]={cc,fl} return else lm[ew]=ld end end lm[1]={cc,fl} else add(lm,{cc,fl}) end end function kw(ln) return((ln[1]+1)*16)+ln[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jv(bt) local cw=lo(bt.data,"\n") for jd in all(cw) do local pairs=lo(jd,"=") if#pairs==2 then
bt[pairs[1]]=lp(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function lo(ej,lq) local lr={} local jh=0 local lt=0 for ew=1,#ej do local lu=sub(ej,ew,ew) if lu==lq then
add(lr,sub(ej,jh,lt)) jh=0 lt=0 elseif lu!=" "and lu!="\t"then lt=ew if jh==0 then jh=ew end
end end if jh+lt>0 then
add(lr,sub(ej,jh,lt)) end return lr end function lp(lv) local lw=sub(lv,1,1) local lr=nil if lv=="true"then
lr=true elseif lv=="false"then lr=false elseif lx(lw) then if lw=="-"then
lr=sub(lv,2,#lv)*-1 else lr=lv+0 end elseif lw=="{"then local lk=sub(lv,2,#lv-1) lr=lo(lk,",") ly={} for cc in all(lr) do cc=lp(cc) add(ly,cc) end lr=ly else lr=lv end return lr end function lx(ie) for lz=1,13 do if ie==sub("0123456789.-+",lz,lz) then
return true end end end function outline_text(ma,x,y,mb,mc,eo) if not eo then ma=ja(ma) end
for md=-1,1 do for me=-1,1 do print(ma,x+md,y+me,mc) end end print(ma,x,y,mb) end function jb(ej) return 63.5-flr((#ej*4)/2) end function mf(ej) return 61 end function ho(bt) if not bt.hs
or cr then return false end hs=bt.hs if(fv+hs.km>hs.jy or fv+hs.km<hs.x)
or(fw>hs.jz or fw<hs.y) then return false else return true end end function ja(ej) local lz=""local jd,ie,lm=false,false for ew=1,#ej do local hu=sub(ej,ew,ew) if hu=="^"then
if ie then lz=lz..hu end
ie=not ie elseif hu=="~"then if lm then lz=lz..hu end
lm,jd=not lm,not jd else if ie==jd and hu>="a"and hu<="z"then
for kc=1,26 do if hu==sub("abcdefghijklmnopqrstuvwxyz",kc,kc) then
hu=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kc,kc) break end end end lz=lz..hu ie,lm=false,false end end return lz end
