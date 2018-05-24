
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
