
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
say_line"erm... i don't think they want to talk"else say_line"i am not talking to that!"end else say_line"hmm. no."end end function camera_at(cc) cam_x=cd(cc) ce=nil cf=nil end function camera_follow(cg) stop_script(ch) cf=cg ce=nil ch=function() while cf do if cf.in_room==room_curr then
cam_x=cd(cf) end yield() end end start_script(ch,true) if cf.in_room!=room_curr then
change_room(cf.in_room,1) end end function camera_pan_to(cc) ce=cd(cc) cf=nil ch=function() while(true) do if cam_x==ce then
ce=nil return elseif ce>cam_x then cam_x+=0.5 else cam_x-=0.5 end yield() end end start_script(ch,true) end function wait_for_camera() while script_running(ch) do yield() end end function cutscene(type,ci,cj) ck={cl=type,cm=cocreate(ci),cn=cj,co=cf} add(cp,ck) cq=ck break_time() end function dialog_set(cr) for msg in all(cr) do dialog_add(msg) end end function dialog_add(msg) if not cs then cs={ct={},cu=false} end
cv=cw(msg,32) cx=cy(cv) cz={num=#cs.ct+1,msg=msg,cv=cv,da=cx} add(cs.ct,cz) end function dialog_start(col,db) cs.col=col cs.db=db cs.cu=true selected_sentence=nil end function dialog_hide() cs.cu=false end function dialog_clear() cs.ct={} selected_sentence=nil end function dialog_end() cs=nil end function get_use_pos(bt) local dc=bt.use_pos local x=bt.x local y=bt.y if type(dc)=="table"then
x=dc[1] y=dc[2] elseif dc=="pos_left"then if bt.dd then
x-=(bt.w*8+4) y+=1 else x-=2 y+=((bt.h*8)-2) end elseif dc=="pos_right"then x+=(bt.w*8) y+=((bt.h*8)-2) elseif dc=="pos_above"then x+=((bt.w*8)/2)-4 y-=2 elseif dc=="pos_center"then x+=((bt.w*8)/2) y+=((bt.h*8)/2)-4 elseif dc=="pos_infront"or dc==nil then x+=((bt.w*8)/2)-4 y+=(bt.h*8)+2 end return{x=x,y=y} end function do_anim(cg,de,df) dg={"face_front","face_left","face_back","face_right"} if de=="anim_face"then
if type(df)=="table"then
dh=atan2(cg.x-df.x,df.y-cg.y) di=93*(3.1415/180) dh=di-dh dj=dh*360 dj=dj%360 if dj<0 then dj+=360 end
df=4-flr(dj/90) df=dg[df] end face_dir=dk[cg.face_dir] df=dk[df] while face_dir!=df do if face_dir<df then
face_dir+=1 else face_dir-=1 end cg.face_dir=dg[face_dir] cg.flip=(cg.face_dir=="face_left") break_time(10) end end end function open_door(dl,dm) if dl.state=="state_open"then
say_line"it's already open"else dl.state="state_open"if dm then dm.state="state_open"end
end end function close_door(dl,dm) if dl.state=="state_closed"then
say_line"it's already closed"else dl.state="state_closed"if dm then dm.state="state_closed"end
end end function come_out_door(dn,dp,dq) if dp==nil then
dr("target door does not exist") return end if dn.state=="state_open"then
ds=dp.in_room if ds!=room_curr then
change_room(ds,dq) end local dt=get_use_pos(dp) put_at(selected_actor,dt.x,dt.y,ds) du={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if dp.use_dir then
dv=du[dp.use_dir] else dv=1 end selected_actor.face_dir=dv selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(dw,bc) if bc==1 then
dx=0 else dx=50 end while true do dx+=bc*2 if dx>50
or dx<0 then return end if dw==1 then
dy=min(dx,32) end yield() end end function change_room(ds,dw) if ds==nil then
dr("room does not exist") return end stop_script(dz) if dw and room_curr then
fades(dw,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ea={} eb() room_curr=ds if not cf
or cf.in_room!=room_curr then cam_x=0 end stop_talking() if dw then
dz=function() fades(dw,-1) end start_script(dz,true) else dy=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(by,ec) if not ec
or not ec.verbs then return false end if type(by)=="table"then
if ec.verbs[by[1]] then return true end
else if ec.verbs[by] then return true end
end return false end function pickup_obj(bt,cg) cg=cg or selected_actor add(cg.bn,bt) bt.owner=cg del(bt.in_room.objects,bt) end function start_script(ed,ee,ef,eg) local cm=cocreate(ed) local scripts=ea if ee then
scripts=eh end add(scripts,{ed,cm,ef,eg}) end function script_running(ed) for ei in all({ea,eh}) do for ej,ek in pairs(ei) do if ek[1]==ed then
return ek end end end return false end function stop_script(ed) ek=script_running(ed) if ek then
del(ea,ek) del(eh,ek) end end function break_time(el) el=el or 1 for x=1,el do yield() end end function wait_for_message() while em!=nil do yield() end end function say_line(cg,msg,en,eo) if type(cg)=="string"then
msg=cg cg=selected_actor end ep=cg.y-(cg.h)*8+4 eq=cg print_line(msg,cg.x,ep,cg.col,1,en,eo) end function stop_talking() em,eq=nil,nil end function print_line(msg,x,y,col,er,en,eo) local col=col or 7 local er=er or 0 if er==1 then
es=min(x-cam_x,127-(x-cam_x)) else es=127-(x-cam_x) end local et=max(flr(es/2),16) local eu=""for ev=1,#msg do local ew=sub(msg,ev,ev) if ew==":"then
eu=sub(msg,ev+1) msg=sub(msg,1,ev-1) break end end local cv=cw(msg,et) local cx=cy(cv) ex=x-cam_x if er==1 then
ex-=((cx*4)/2) end ex=max(2,ex) ep=max(18,y) ex=min(ex,127-(cx*4)-1) em={ey=cv,x=ex,y=ep,col=col,er=er,ez=eo or(#msg)*8,da=cx,en=en} if#eu>0 then
fa=eq wait_for_message() eq=fa print_line(eu,x,y,col,er,en) end wait_for_message() end function put_at(bt,x,y,fb) if fb then
if not has_flag(bt.classes,"class_actor") then
if bt.in_room then del(bt.in_room.objects,bt) end
add(fb.objects,bt) bt.owner=nil end bt.in_room=fb end bt.x,bt.y=x,y end function stop_actor(cg) cg.fc=0 eb() end function walk_to(cg,x,y) local fd=fe(cg) local ff=flr(x/8)+room_curr.map[1] local fg=flr(y/8)+room_curr.map[2] local fh={ff,fg} local fi=fj(fd,fh) cg.fc=1 for fk in all(fi) do local fl=cg.walk_speed*(cg.scale or cg.fm) local fn=(fk[1]-room_curr.map[1])*8+4 local fo=(fk[2]-room_curr.map[2])*8+4 local fp=sqrt((fn-cg.x)^2+(fo-cg.y)^2) local fq=fl*(fn-cg.x)/fp local fr=fl*(fo-cg.y)/fp if cg.fc==0 then
return end if fp>5 then
for ev=0,fp/fl do cg.flip=(fq<0) if abs(fq)<fl/2 then
if fr>0 then
cg.fs=cg.walk_anim_front cg.face_dir="face_front"else cg.fs=cg.walk_anim_back cg.face_dir="face_back"end else cg.fs=cg.walk_anim_side cg.face_dir="face_right"if cg.flip then cg.face_dir="face_left"end
end cg.x+=fq cg.y+=fr yield() end end end cg.fc=2 end function wait_for_actor(cg) cg=cg or selected_actor while cg.fc!=2 do yield() end end function proximity(bz,ca) if bz.in_room==ca.in_room then
local fp=sqrt((bz.x-ca.x)^2+(bz.y-ca.y)^2) return fp else return 1000 end end ft=16 cam_x,ce,ch,bq=0,nil,nil,0 fu,fv,fw,fx=63.5,63.5,0,1 fy={{spr=ui_uparrowspr,x=75,y=ft+60},{spr=ui_dnarrowspr,x=75,y=ft+72}} dk={face_front=1,face_left=2,face_back=3,face_right=4} function fz(bt) local ga={} for ej,bv in pairs(bt) do add(ga,ej) end return ga end function get_verb(bt) local by={} local ga=fz(bt[1]) add(by,ga[1]) add(by,bt[1][ga[1]]) add(by,bt.text) return by end function eb() gb=get_verb(verb_default) gc,gd,n,ge,gf=nil,nil,nil,false,""end eb() em=nil cs=nil cq=nil eq=nil eh={} ea={} cp={} gg={} dy,dy=0,0 gh=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gi() start_script(startup_script,true) end function _update60() gj() end function _draw() gk() end function gj() if selected_actor and selected_actor.cm
and not coresume(selected_actor.cm) then selected_actor.cm=nil end gl(eh) if cq then
if cq.cm
and not coresume(cq.cm) then if cq.cl!=3
and cq.co then camera_follow(cq.co) selected_actor=cq.co end del(cp,cq) if#cp>0 then
cq=cp[#cp] else if cq.cl!=2 then
gh=3 end cq=nil end end else gl(ea) end gm() gn() go,gp=1.5-rnd(3),1.5-rnd(3) go=flr(go*bq) gp=flr(gp*bq) if not br then
bq*=0.90 if bq<0.05 then bq=0 end
end end function gk() rectfill(0,0,127,127,0) camera(cam_x+go,0+gp) clip(0+dy-go,ft+dy-gp,128-dy*2-go,64-dy*2) gq() camera(0,0) clip() if show_debuginfo then
print("x: "..flr(fu+cam_x).." y:"..fv-ft,80,ft-8,8) end gr() if cs
and cs.cu then gs() gt() return end if gh>0 then
gh-=1 return end if not cq then
gu() end if(not cq
or cq.cl==2) and gh==0 then gv() end if not cq then
gt() end end function gw() if stat(34)>0 then
if not gx then
gx=true end else gx=false end end function gm() if em and not gx then
if(btnp(4) or stat(34)==1) then
em.ez=0 gx=true return end end if cq then
if(btnp(5) or stat(34)==2)
and cq.cn then cq.cm=cocreate(cq.cn) cq.cn=nil return end gw() return end if btn(0) then fu-=1 end
if btn(1) then fu+=1 end
if btn(2) then fv-=1 end
if btn(3) then fv+=1 end
if btnp(4) then gy(1) end
if btnp(5) then gy(2) end
if enable_mouse then
gz,ha=stat(32)-1,stat(33)-1 if gz!=hb then fu=gz end
if ha!=hc then fv=ha end
if stat(34)>0 and not gx then
gy(stat(34)) end hb=gz hc=ha gw() end fu=mid(0,fu,127) fv=mid(0,fv,127) end function gy(hd) local he=gb if not selected_actor then
return end if cs and cs.cu then
if hf then
selected_sentence=hf end return end if hg then
gb=get_verb(hg) elseif hh then if hd==1 then
if(gb[2]=="use"or gb[2]=="give")
and gc then gd=hh else gc=hh end elseif hi then gb=get_verb(hi) gc=hh fz(gc) gu() end elseif hj then if hj==fy[1] then
if selected_actor.hk>0 then
selected_actor.hk-=1 end else if selected_actor.hk+2<flr(#selected_actor.bn/4) then
selected_actor.hk+=1 end end return end if gc!=nil
then if gb[2]=="use"or gb[2]=="give"then
if gd then
elseif gc.use_with and gc.owner==selected_actor then return end end ge=true selected_actor.cm=cocreate(function() if(not gc.owner
and(not has_flag(gc.classes,"class_actor") or gb[2]!="use")) or gd then hl=gd or gc hm=get_use_pos(hl) walk_to(selected_actor,hm.x,hm.y) if selected_actor.fc!=2 then return end
use_dir=hl if hl.use_dir then use_dir=hl.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(gb,gc) then
start_script(gc.verbs[gb[1]],false,gc,gd) else if has_flag(gc.classes,"class_door") then
if gb[2]=="walkto"then
come_out_door(gc,gc.target_door) elseif gb[2]=="open"then open_door(gc,gc.target_door) elseif gb[2]=="close"then close_door(gc,gc.target_door) end else bx(gb[2],gc,gd) end end eb() end) coresume(selected_actor.cm) elseif fv>ft and fv<ft+64 then ge=true selected_actor.cm=cocreate(function() walk_to(selected_actor,fu+cam_x,fv-ft) eb() end) coresume(selected_actor.cm) end end function gn() if not room_curr then
return end hg,hi,hh,hf,hj=nil,nil,nil,nil,nil if cs
and cs.cu then for ei in all(cs.ct) do if hn(ei) then
hf=ei end end return end ho() for bt in all(room_curr.objects) do if(not bt.classes
or(bt.classes and not has_flag(bt.classes,"class_untouchable"))) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) then hp(bt,bt.w*8,bt.h*8,cam_x,hq) else bt.hr=nil end if hn(bt) then
if not hh
or(not bt.z and hh.z<0) or(bt.z and hh.z and bt.z>hh.z) then hh=bt end end hs(bt) end for ej,cg in pairs(actors) do if cg.in_room==room_curr then
hp(cg,cg.w*8,cg.h*8,cam_x,hq) hs(cg) if hn(cg)
and cg!=selected_actor then hh=cg end end end if selected_actor then
for bv in all(verbs) do if hn(bv) then
hg=bv end end for ht in all(fy) do if hn(ht) then
hj=ht end end for ej,bt in pairs(selected_actor.bn) do if hn(bt) then
hh=bt if gb[2]=="pickup"and hh.owner then
gb=nil end end if bt.owner!=selected_actor then
del(selected_actor.bn,bt) end end if gb==nil then
gb=get_verb(verb_default) end if hh then
hi=bs(hh) end end end function ho() gg={} for x=-64,64 do gg[x]={} end end function hs(bt) ep=-1 if bt.hu then
ep=bt.y else ep=bt.y+(bt.h*8) end hv=flr(ep) if bt.z then
hv=bt.z end add(gg[hv],bt) end function gq() if not room_curr then
print("-error-  no current room set",5+cam_x,5+ft,8,0) return end rectfill(0,ft,127,ft+64,room_curr.hw or 0) for z=-64,64 do if z==0 then
hx(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,ft,room_curr.hy,room_curr.hz) pal() else hv=gg[z] for bt in all(hv) do if not has_flag(bt.classes,"class_actor") then
if bt.states
or(bt.state and bt[bt.state] and bt[bt.state]>0) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) and not bt.owner or bt.draw then ia(bt) end else if bt.in_room==room_curr then
ib(bt) end end ic(bt) end end end end function hx(bt) if bt.col_replace then
id=bt.col_replace pal(id[1],id[2]) end if bt.lighting then
ie(bt.lighting) elseif bt.in_room and bt.in_room.lighting then ie(bt.in_room.lighting) end end function ia(bt) hx(bt) if bt.draw then
bt.draw(bt) else ig=1 if bt.repeat_x then ig=bt.repeat_x end
for h=0,ig-1 do local ih=0 if bt.states then
ih=bt.states[bt.state] else ih=bt[bt.state] end ii(ih,bt.x+(h*(bt.w*8)),bt.y,bt.w,bt.h,bt.trans_col,bt.flip_x,bt.scale) end end pal() end function ib(cg) ij=dk[cg.face_dir] if cg.fc==1
and cg.fs then cg.ik+=1 if cg.ik>cg.frame_delay then
cg.ik=1 cg.il+=1 if cg.il>#cg.fs then cg.il=1 end
end im=cg.fs[cg.il] else im=cg.idle[ij] end hx(cg) local io=(cg.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1]) io=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*io cg.fm=mid(room_curr.autodepth_scale[1],io,room_curr.autodepth_scale[2]) local scale=cg.scale or cg.fm local ip=(8*cg.h) local iq=(8*cg.w) local ir=ip-(ip*scale) local is=iq-(iq*scale) ii(im,cg.dd+flr(is/2),cg.hu+ir,cg.w,cg.h,cg.trans_col,cg.flip,false,scale) if eq
and eq==cg and eq.talk then if cg.it<7 then
im=cg.talk[ij] ii(im,cg.dd+flr(is/2),cg.hu+flr(8*scale)+ir,1,1,cg.trans_col,cg.flip,false,scale) end cg.it+=1 if cg.it>14 then cg.it=1 end
end pal() end function gu() iu=""iv=verb_maincol iw=gb[2] if gb then
iu=gb[3] end if gc then
iu=iu.." "..gc.name if iw=="use"then
iu=iu.." with"elseif iw=="give"then iu=iu.." to"end end if gd then
iu=iu.." "..gd.name elseif hh and hh.name!=""and(not gc or(gc!=hh)) and(not hh.owner or iw!=get_verb(verb_default)[2]) then iu=iu.." "..hh.name end gf=iu if ge then
iu=gf iv=verb_hovcol end print(ix(iu),iy(iu),ft+66,iv) end function gr() if em then
iz=0 for ja in all(em.ey) do jb=0 if em.er==1 then
jb=((em.da*4)-(#ja*4))/2 end outline_text(ja,em.x+jb,em.y+iz,em.col,0,em.en) iz+=6 end em.ez-=1 if em.ez<=0 then
stop_talking() end end end function gv() ex,ep,jc=0,75,0 for bv in all(verbs) do jd=verb_maincol if hi
and bv==hi then jd=verb_defcol end if bv==hg then jd=verb_hovcol end
bw=get_verb(bv) print(bw[3],ex,ep+ft+1,verb_shadcol) print(bw[3],ex,ep+ft,jd) bv.x=ex bv.y=ep hp(bv,#bw[3]*4,5,0,0) ic(bv) if#bw[3]>jc then jc=#bw[3] end
ep+=8 if ep>=95 then
ep=75 ex+=(jc+1.0)*4 jc=0 end end if selected_actor then
ex,ep=86,76 je=selected_actor.hk*4 jf=min(je+8,#selected_actor.bn) for jg=1,8 do rectfill(ex-1,ft+ep-1,ex+8,ft+ep+8,verb_shadcol) bt=selected_actor.bn[je+jg] if bt then
bt.x,bt.y=ex,ep ia(bt) hp(bt,bt.w*8,bt.h*8,0,0) ic(bt) end ex+=11 if ex>=125 then
ep+=12 ex=86 end jg+=1 end for ev=1,2 do jh=fy[ev] if hj==jh then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ii(jh.spr,jh.x,jh.y,1,1,0) hp(jh,8,7,0,0) ic(jh) pal() end end end function gs() ex,ep=0,70 for ei in all(cs.ct) do if ei.da>0 then
ei.x,ei.y=ex,ep hp(ei,ei.da*4,#ei.cv*5,0,0) jd=cs.col if ei==hf then jd=cs.db end
for ja in all(ei.cv) do print(ix(ja),ex,ep+ft,jd) ep+=5 end ic(ei) ep+=2 end end end function gt() col=ui_cursor_cols[fx] pal(7,col) spr(ui_cursorspr,fu-4,fv-3,1,1,0) pal() fw+=1 if fw>7 then
fw=1 fx+=1 if fx>#ui_cursor_cols then fx=1 end
end end function ii(ji,x,y,w,h,jj,flip_x,jk,scale) set_trans_col(jj,true) local jl=8*(ji%16) local jm=8*flr(ji/16) local jn=8*w local jo=8*h local jp=scale or 1 local jq=jn*jp local jr=jo*jp sspr(jl,jm,jn,jo,x,ft+y,jq,jr,flip_x,jk) end function set_trans_col(jj,bp) palt(0,false) palt(jj,true) if jj and jj>0 then
palt(0,false) end end function gi() for fb in all(rooms) do js(fb) if(#fb.map>2) then
fb.hy=fb.map[3]-fb.map[1]+1 fb.hz=fb.map[4]-fb.map[2]+1 else fb.hy=16 fb.hz=8 end fb.autodepth_pos=fb.autodepth_pos or{9,50} fb.autodepth_scale=fb.autodepth_scale or{0.25,1} for bt in all(fb.objects) do js(bt) bt.in_room=fb bt.h=bt.h or 0 if bt.init then
bt.init(bt) end end end for jt,cg in pairs(actors) do js(cg) cg.fc=2 cg.ik=1 cg.it=1 cg.il=1 cg.bn={} cg.hk=0 end end function ic(bt) local ju=bt.hr if show_collision
and ju then rect(ju.x,ju.y,ju.jv,ju.jw,8) end end function gl(scripts) for ek in all(scripts) do if ek[2] and not coresume(ek[2],ek[3],ek[4]) then
del(scripts,ek) ek=nil end end end function ie(jx) if jx then jx=1-jx end
local fk=flr(mid(0,jx,1)*100) local jy={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jz=1,15 do col=jz ka=(fk+(jz*1.46))/22 for ej=1,ka do col=jy[col] end pal(jz,col) end end function cd(cc) if type(cc)=="table"then
cc=cc.x end return mid(0,cc-64,(room_curr.hy*8)-128) end function fe(bt) local ff=flr(bt.x/8)+room_curr.map[1] local fg=flr(bt.y/8)+room_curr.map[2] return{ff,fg} end function kb(ff,fg) local kc=mget(ff,fg) local kd=fget(kc,0) return kd end function cw(msg,et) local cv={} local ke=""local kf=""local ew=""local kg=function(kh) if#kf+#ke>kh then
add(cv,ke) ke=""end ke=ke..kf kf=""end for ev=1,#msg do ew=sub(msg,ev,ev) kf=kf..ew if ew==" "
or#kf>et-1 then kg(et) elseif#kf>et-1 then kf=kf.."-"kg(et) elseif ew==";"then ke=ke..sub(kf,1,#kf-1) kf=""kg(0) end end kg(et) if ke!=""then
add(cv,ke) end return cv end function cy(cv) cx=0 for ja in all(cv) do if#ja>cx then cx=#ja end
end return cx end function has_flag(bt,ki) for bd in all(bt) do if bd==ki then
return true end end return false end function hp(bt,w,h,kj,kk) x=bt.x y=bt.y if has_flag(bt.classes,"class_actor") then
bt.dd=x-(bt.w*8)/2 bt.hu=y-(bt.h*8)+1 x=bt.dd y=bt.hu end bt.hr={x=x,y=y+ft,jv=x+w-1,jw=y+h+ft-1,kj=kj,kk=kk} end function fj(kl,km) local kn,ko,kp,kq,kr={},{},{},nil,nil ks(kn,kl,0) ko[kt(kl)]=nil kp[kt(kl)]=0 while#kn>0 and#kn<1000 do local ku=kn[#kn] del(kn,kn[#kn]) kv=ku[1] if kt(kv)==kt(km) then
break end local kw={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kx=kv[1]+x local ky=kv[2]+y if abs(x)!=abs(y) then kz=1 else kz=1.4 end
if kx>=room_curr.map[1] and kx<=room_curr.map[1]+room_curr.hy
and ky>=room_curr.map[2] and ky<=room_curr.map[2]+room_curr.hz and kb(kx,ky) and((abs(x)!=abs(y)) or kb(kx,kv[2]) or kb(kx-x,ky) or enable_diag_squeeze) then add(kw,{kx,ky,kz}) end end end end for la in all(kw) do local lb=kt(la) local lc=kp[kt(kv)]+la[3] if not kp[lb]
or lc<kp[lb] then kp[lb]=lc local h=max(abs(km[1]-la[1]),abs(km[2]-la[2])) local ld=lc+h ks(kn,la,ld) ko[lb]=kv if not kq
or h<kq then kq=h kr=lb le=la end end end end local fi={} kv=ko[kt(km)] if kv then
add(fi,km) elseif kr then kv=ko[kr] add(fi,le) end if kv then
local lf=kt(kv) local lg=kt(kl) while lf!=lg do add(fi,kv) kv=ko[lf] lf=kt(kv) end for ev=1,#fi/2 do local lh=fi[ev] local li=#fi-(ev-1) fi[ev]=fi[li] fi[li]=lh end end return fi end function ks(lj,cc,fk) if#lj>=1 then
add(lj,{}) for ev=(#lj),2,-1 do local la=lj[ev-1] if fk<la[2] then
lj[ev]={cc,fk} return else lj[ev]=la end end lj[1]={cc,fk} else add(lj,{cc,fk}) end end function kt(lk) return((lk[1]+1)*16)+lk[2] end function dr(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function js(bt) local cv=ll(bt.data,"\n") for ja in all(cv) do local pairs=ll(ja,"=") if#pairs==2 then
bt[pairs[1]]=lm(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function ll(ei,ln) local lo={} local je=0 local lp=0 for ev=1,#ei do local lq=sub(ei,ev,ev) if lq==ln then
add(lo,sub(ei,je,lp)) je=0 lp=0 elseif lq!=" "and lq!="\t"then lp=ev if je==0 then je=ev end
end end if je+lp>0 then
add(lo,sub(ei,je,lp)) end return lo end function lm(lr) local lt=sub(lr,1,1) local lo=nil if lr=="true"then
lo=true elseif lr=="false"then lo=false elseif lu(lt) then if lt=="-"then
lo=sub(lr,2,#lr)*-1 else lo=lr+0 end elseif lt=="{"then local lh=sub(lr,2,#lr-1) lo=ll(lh,",") lv={} for cc in all(lo) do cc=lm(cc) add(lv,cc) end lo=lv else lo=lr end return lo end function lu(id) for lw=1,13 do if id==sub("0123456789.-+",lw,lw) then
return true end end end function outline_text(lx,x,y,ly,lz,en) if not en then lx=ix(lx) end
for ma=-1,1 do for mb=-1,1 do print(lx,x+ma,y+mb,lz) end end print(lx,x,y,ly) end function iy(ei) return 63.5-flr((#ei*4)/2) end function mc(ei) return 61 end function hn(bt) if not bt.hr
or cq then return false end hr=bt.hr if(fu+hr.kj>hr.jv or fu+hr.kj<hr.x)
or(fv>hr.jw or fv<hr.y) then return false else return true end end function ix(ei) local lw=""local ja,id,lj=false,false for ev=1,#ei do local ht=sub(ei,ev,ev) if ht=="^"then
if id then lw=lw..ht end
id=not id elseif ht=="~"then if lj then lw=lw..ht end
lj,ja=not lj,not ja else if id==ja and ht>="a"and ht<="z"then
for jz=1,26 do if ht==sub("abcdefghijklmnopqrstuvwxyz",jz,jz) then
ht=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jz,jz) break end end end lw=lw..ht id,lj=false,false end end return lw end
