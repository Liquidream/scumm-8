
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
x-=(bt.w*8+4) y+=1 else x-=2 y+=((bt.h*8)-2) end elseif dd=="pos_right"then x+=(bt.w*8) y+=((bt.h*8)-2) elseif dd=="pos_above"then x+=((bt.w*8)/2)-4 y-=2 elseif dd=="pos_center"then x+=((bt.w*8)/2) y+=((bt.h*8)/2)-4 elseif dd=="pos_infront"or dd==nil then x+=((bt.w*8)/2)-4 y+=(bt.h*8)+2 end return{x=x,y=y} end function do_anim(df,dg,dh) if dg=="face_towards"then
di={"face_front","face_left","face_back","face_right"} if type(dh)=="table"then
dj=atan2(df.x-dh.x,dh.y-df.y) dk=93*(3.1415/180) dj=dk-dj dl=dj*360 dl=dl%360 if dl<0 then dl+=360 end
dh=4-flr(dl/90) dh=di[dh] end face_dir=dm[df.face_dir] dh=dm[dh] while face_dir!=dh do if face_dir<dh then
face_dir+=1 else face_dir-=1 end df.face_dir=di[face_dir] df.flip=(df.face_dir=="face_left") break_time(10) end else df.dn=dg df.dp=1 df.dq=1 end end function open_door(dr,ds) if dr.state=="state_open"then
say_line"it's already open"else dr.state="state_open"if ds then ds.state="state_open"end
end end function close_door(dr,ds) if dr.state=="state_closed"then
say_line"it's already closed"else dr.state="state_closed"if ds then ds.state="state_closed"end
end end function come_out_door(dt,du,dv) if du==nil then
dw("target door does not exist") return end if dt.state=="state_open"then
dx=du.in_room if dx!=room_curr then
change_room(dx,dv) end local dy=get_use_pos(du) put_at(selected_actor,dy.x,dy.y,dx) dz={face_front="face_back",face_left="face_right",face_back="face_front",face_right="face_left"} if du.use_dir then
ea=dz[du.use_dir] else ea=1 end selected_actor.face_dir=ea selected_actor.flip=(selected_actor.face_dir=="face_left") else say_line("the door is closed") end end function fades(eb,bc) if bc==1 then
ec=0 else ec=50 end while true do ec+=bc*2 if ec>50
or ec<0 then return end if eb==1 then
ed=min(ec,32) end yield() end end function change_room(dx,eb) if dx==nil then
dw("room does not exist") return end stop_script(ee) if eb and room_curr then
fades(eb,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ef={} eg() room_curr=dx if not cg
or cg.in_room!=room_curr then cam_x=0 end stop_talking() if eb then
ee=function() fades(eb,-1) end start_script(ee,true) else ed=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(by,eh) if not eh
or not eh.verbs then return false end if type(by)=="table"then
if eh.verbs[by[1]] then return true end
else if eh.verbs[by] then return true end
end return false end function pickup_obj(bt,ch) ch=ch or selected_actor add(ch.bn,bt) bt.owner=ch del(bt.in_room.objects,bt) end function start_script(ei,ej,ek,el) local cn=cocreate(ei) local scripts=ef if ej then
scripts=em end add(scripts,{ei,cn,ek,el}) end function script_running(ei) for en in all({ef,em}) do for eo,ep in pairs(en) do if ep[1]==ei then
return ep end end end return false end function stop_script(ei) ep=script_running(ei) if ep then
del(ef,ep) del(em,ep) end end function break_time(eq) eq=eq or 1 for x=1,eq do yield() end end function wait_for_message() while er!=nil do yield() end end function say_line(ch,msg,es,et) if type(ch)=="string"then
msg=ch ch=selected_actor end eu=ch.y-(ch.h)*8+4 ev=ch print_line(msg,ch.x,eu,ch.col,1,es,et) end function stop_talking() er,ev=nil,nil end function print_line(msg,x,y,col,ew,es,et) local col=col or 7 local ew=ew or 0 if ew==1 then
ex=min(x-cam_x,127-(x-cam_x)) else ex=127-(x-cam_x) end local ey=max(flr(ex/2),16) local ez=""for fa=1,#msg do local fb=sub(msg,fa,fa) if fb==":"then
ez=sub(msg,fa+1) msg=sub(msg,1,fa-1) break end end local cw=cx(msg,ey) local cy=cz(cw) fc=x-cam_x if ew==1 then
fc-=((cy*4)/2) end fc=max(2,fc) eu=max(18,y) fc=min(fc,127-(cy*4)-1) er={fd=cw,x=fc,y=eu,col=col,ew=ew,fe=et or(#msg)*8,db=cy,es=es} if#ez>0 then
ff=ev wait_for_message() ev=ff print_line(ez,x,y,col,ew,es) end wait_for_message() end function put_at(bt,x,y,fg) if fg then
if not has_flag(bt.classes,"class_actor") then
if bt.in_room then del(bt.in_room.objects,bt) end
add(fg.objects,bt) bt.owner=nil end bt.in_room=fg end bt.x,bt.y=x,y end function stop_actor(ch) ch.fh=0 ch.dn=nil eg() end function walk_to(ch,x,y) local fi=fj(ch) local fk=flr(x/8)+room_curr.map[1] local fl=flr(y/8)+room_curr.map[2] local fm={fk,fl} local fn=fo(fi,fm,{x,y}) ch.fh=1 for fp=1,#fn do fq=fn[fp] local fr=ch.walk_speed*(ch.scale or ch.fs) local ft,fu ft=(fq[1]-room_curr.map[1])*8+4 fu=(fq[2]-room_curr.map[2])*8+4 if fp==#fn then
if x>=ft-4 and x<=ft+4
and y>=fu-4 and y<=fu+4 then ft=x fu=y end end local fv=sqrt((ft-ch.x)^2+(fu-ch.y)^2) local fw=fr*(ft-ch.x)/fv local fx=fr*(fu-ch.y)/fv if ch.fh==0 then
return end if fv>0 then
for fa=0,fv/fr-1 do ch.flip=(fw<0) if abs(fw)<fr/2 then
if fx>0 then
ch.dn=ch.walk_anim_front ch.face_dir="face_front"else ch.dn=ch.walk_anim_back ch.face_dir="face_back"end else ch.dn=ch.walk_anim_side ch.face_dir="face_right"if ch.flip then ch.face_dir="face_left"end
end ch.x+=fw ch.y+=fx yield() end end end ch.fh=2 ch.dn=nil end function wait_for_actor(ch) ch=ch or selected_actor while ch.fh!=2 do yield() end end function proximity(bz,ca) if bz.in_room==ca.in_room then
local fv=sqrt((bz.x-ca.x)^2+(bz.y-ca.y)^2) return fv else return 1000 end end fy=16 cam_x,cf,ci,bq=0,nil,nil,0 fz,ga,gb,gc=63.5,63.5,0,1 gd={{spr=ui_uparrowspr,x=75,y=fy+60},{spr=ui_dnarrowspr,x=75,y=fy+72}} dm={face_front=1,face_left=2,face_back=3,face_right=4} function ge(bt) local gf={} for eo,bv in pairs(bt) do add(gf,eo) end return gf end function get_verb(bt) local by={} local gf=ge(bt[1]) add(by,gf[1]) add(by,bt[1][gf[1]]) add(by,bt.text) return by end function eg() gg=get_verb(verb_default) gh,gi,n,gj,gk=nil,nil,nil,false,""end eg() er=nil ct=nil cr=nil ev=nil em={} ef={} cq={} gl={} ed,ed=0,0 gm=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gn() start_script(startup_script,true) end function _update60() go() end function _draw() gp() end function go() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gq(em) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gm=3 end cr=nil end end else gq(ef) end gr() gs() gt,gu=1.5-rnd(3),1.5-rnd(3) gt=flr(gt*bq) gu=flr(gu*bq) if not br then
bq*=0.90 if bq<0.05 then bq=0 end
end end function gp() rectfill(0,0,127,127,0) camera(cam_x+gt,0+gu) clip(0+ed-gt,fy+ed-gu,128-ed*2-gt,64-ed*2) gv() camera(0,0) clip() if show_debuginfo then
print("x: "..flr(fz+cam_x).." y:"..ga-fy,80,fy-8,8) end gw() if ct
and ct.cv then gx() gy() return end if gm>0 then
gm-=1 return end if not cr then
gz() end if(not cr
or cr.cm==2) and gm==0 then ha() end if not cr then
gy() end end function hb() if stat(34)>0 then
if not hc then
hc=true end else hc=false end end function gr() if er and not hc then
if(btnp(4) or stat(34)==1) then
er.fe=0 hc=true return end end if cr then
if(btnp(5) or stat(34)==2)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end hb() return end if btn(0) then fz-=1 end
if btn(1) then fz+=1 end
if btn(2) then ga-=1 end
if btn(3) then ga+=1 end
if btnp(4) then hd(1) end
if btnp(5) then hd(2) end
if enable_mouse then
he,hf=stat(32)-1,stat(33)-1 if he!=hg then fz=he end
if hf!=hh then ga=hf end
if stat(34)>0 and not hc then
hd(stat(34)) end hg=he hh=hf hb() end fz=mid(0,fz,127) ga=mid(0,ga,127) end function hd(hi) local hj=gg if not selected_actor then
return end if ct and ct.cv then
if hk then
selected_sentence=hk end return end if hl then
gg=get_verb(hl) gh=nil gi=nil elseif hm then if hi==1 then
if(gg[2]=="use"or gg[2]=="give")
and gh then gi=hm else gh=hm end elseif hn then gg=get_verb(hn) gh=hm ge(gh) gz() end elseif ho then if ho==gd[1] then
if selected_actor.hp>0 then
selected_actor.hp-=1 end else if selected_actor.hp+2<flr(#selected_actor.bn/4) then
selected_actor.hp+=1 end end return end if gh!=nil
then if gg[2]=="use"or gg[2]=="give"then
if gi then
elseif gh.use_with and gh.owner==selected_actor then return end end gj=true selected_actor.cn=cocreate(function() if(not gh.owner
and(not has_flag(gh.classes,"class_actor") or gg[2]!="use")) or gi then hq=gi or gh hr=get_use_pos(hq) walk_to(selected_actor,hr.x,hr.y) if selected_actor.fh!=2 then return end
use_dir=hq if hq.use_dir then use_dir=hq.use_dir end
do_anim(selected_actor,"face_towards",use_dir) end if valid_verb(gg,gh) then
start_script(gh.verbs[gg[1]],false,gh,gi) else if has_flag(gh.classes,"class_door") then
if gg[2]=="walkto"then
come_out_door(gh,gh.target_door) elseif gg[2]=="open"then open_door(gh,gh.target_door) elseif gg[2]=="close"then close_door(gh,gh.target_door) end else bx(gg[2],gh,gi) end end eg() end) coresume(selected_actor.cn) elseif ga>fy and ga<fy+64 then gj=true selected_actor.cn=cocreate(function() walk_to(selected_actor,fz+cam_x,ga-fy) eg() end) coresume(selected_actor.cn) end end function gs() if not room_curr then
return end hl,hn,hm,hk,ho=nil,nil,nil,nil,nil if ct
and ct.cv then for en in all(ct.cu) do if hs(en) then
hk=en end end return end ht() for bt in all(room_curr.objects) do if(not bt.classes
or(bt.classes and not has_flag(bt.classes,"class_untouchable"))) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) then hu(bt,bt.w*8,bt.h*8,cam_x,hv) else bt.hw=nil end if hs(bt) then
if not hm
or(not bt.z and hm.z<0) or(bt.z and hm.z and bt.z>hm.z) then hm=bt end end hx(bt) end for eo,ch in pairs(actors) do if ch.in_room==room_curr then
hu(ch,ch.w*8,ch.h*8,cam_x,hv) hx(ch) if hs(ch)
and ch!=selected_actor then hm=ch end end end if selected_actor then
for bv in all(verbs) do if hs(bv) then
hl=bv end end for hy in all(gd) do if hs(hy) then
ho=hy end end for eo,bt in pairs(selected_actor.bn) do if hs(bt) then
hm=bt if gg[2]=="pickup"and hm.owner then
gg=nil end end if bt.owner!=selected_actor then
del(selected_actor.bn,bt) end end if gg==nil then
gg=get_verb(verb_default) end if hm then
hn=bs(hm) end end end function ht() gl={} for x=-64,64 do gl[x]={} end end function hx(bt) eu=-1 if bt.hz then
eu=bt.y else eu=bt.y+(bt.h*8) end ia=flr(eu) if bt.z then
ia=bt.z end add(gl[ia],bt) end function gv() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fy,8,0) return end rectfill(0,fy,127,fy+64,room_curr.ib or 0) for z=-64,64 do if z==0 then
ic(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fy,room_curr.id,room_curr.ie) pal() else ia=gl[z] for bt in all(ia) do if not has_flag(bt.classes,"class_actor") then
if bt.states
or(bt.state and bt[bt.state] and bt[bt.state]>0) and(not bt.dependent_on or bt.dependent_on.state==bt.dependent_on_state) and not bt.owner or bt.draw or bt.dn then ig(bt) end else if bt.in_room==room_curr then
ih(bt) end end ii(bt) end end end end function ic(bt) if bt.col_replace then
fp=bt.col_replace pal(fp[1],fp[2]) end if bt.lighting then
ij(bt.lighting) elseif bt.in_room and bt.in_room.lighting then ij(bt.in_room.lighting) end end function ig(bt) local ik=0 ic(bt) if bt.draw then
bt.draw(bt) else if bt.dn then
il(bt) ik=bt.dn[bt.dp] end im=1 if bt.repeat_x then im=bt.repeat_x end
for h=0,im-1 do if bt.states then
ik=bt.states[bt.state] elseif ik==0 then ik=bt[bt.state] end io(ik,bt.x+(h*(bt.w*8)),bt.y,bt.w,bt.h,bt.trans_col,bt.flip_x,bt.scale) end end pal() end function ih(ch) ip=dm[ch.face_dir] if ch.fh==1
and type(ch.dn)=="table"then il(ch) ik=ch.dn[ch.dp] else ik=ch.idle[ip] end ic(ch) local iq=(ch.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1]) iq=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*iq ch.fs=mid(room_curr.autodepth_scale[1],iq,room_curr.autodepth_scale[2]) local scale=ch.scale or ch.fs local ir=(8*ch.h) local is=(8*ch.w) local it=ir-(ir*scale) local iu=is-(is*scale) local iv=ch.de+flr(iu/2) local iw=ch.hz+it io(ik,iv,iw,ch.w,ch.h,ch.trans_col,ch.flip,false,scale) if ev
and ev==ch and ev.talk then if ch.ix<7 then
io(ch.talk[ip],iv+(ch.talk[5] or 0),iw+flr((ch.talk[6] or 8)*scale),(ch.talk[7] or 1),(ch.talk[8] or 1),ch.trans_col,ch.flip,false,scale) end ch.ix+=1 if ch.ix>14 then ch.ix=1 end
end pal() end function gz() iy=""iz=verb_maincol ja=gg[2] if gg then
iy=gg[3] end if gh then
iy=iy.." "..gh.name if ja=="use"and(not gj or gi) then
iy=iy.." with"elseif ja=="give"then iy=iy.." to"end end if gi then
iy=iy.." "..gi.name elseif hm and hm.name!=""and(not gh or(gh!=hm)) and(not hm.owner or ja!=get_verb(verb_default)[2]) then iy=iy.." "..hm.name end gk=iy if gj then
iy=gk iz=verb_hovcol end print(jb(iy),jc(iy),fy+66,iz) end function gw() if er then
jd=0 for je in all(er.fd) do jf=0 if er.ew==1 then
jf=((er.db*4)-(#je*4))/2 end outline_text(je,er.x+jf,er.y+jd,er.col,0,er.es) jd+=6 end er.fe-=1 if er.fe<=0 then
stop_talking() end end end function ha() fc,eu,jg=0,75,0 for bv in all(verbs) do jh=verb_maincol if hn
and bv==hn then jh=verb_defcol end if bv==hl then jh=verb_hovcol end
bw=get_verb(bv) print(bw[3],fc,eu+fy+1,verb_shadcol) print(bw[3],fc,eu+fy,jh) bv.x=fc bv.y=eu hu(bv,#bw[3]*4,5,0,0) ii(bv) if#bw[3]>jg then jg=#bw[3] end
eu+=8 if eu>=95 then
eu=75 fc+=(jg+1.0)*4 jg=0 end end if selected_actor then
fc,eu=86,76 ji=selected_actor.hp*4 jj=min(ji+8,#selected_actor.bn) for jk=1,8 do rectfill(fc-1,fy+eu-1,fc+8,fy+eu+8,verb_shadcol) bt=selected_actor.bn[ji+jk] if bt then
bt.x,bt.y=fc,eu ig(bt) hu(bt,bt.w*8,bt.h*8,0,0) ii(bt) end fc+=11 if fc>=125 then
eu+=12 fc=86 end jk+=1 end for fa=1,2 do jl=gd[fa] if ho==jl then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) io(jl.spr,jl.x,jl.y,1,1,0) hu(jl,8,7,0,0) ii(jl) pal() end end end function gx() fc,eu=0,70 for en in all(ct.cu) do if en.db>0 then
en.x,en.y=fc,eu hu(en,en.db*4,#en.cw*5,0,0) jh=ct.col if en==hk then jh=ct.dc end
for je in all(en.cw) do print(jb(je),fc,eu+fy,jh) eu+=5 end ii(en) eu+=2 end end end function gy() col=ui_cursor_cols[gc] pal(7,col) spr(ui_cursorspr,fz-4,ga-3,1,1,0) pal() gb+=1 if gb>7 then
gb=1 gc+=1 if gc>#ui_cursor_cols then gc=1 end
end end function io(jm,x,y,w,h,jn,flip_x,jo,scale) set_trans_col(jn,true) local jp=8*(jm%16) local jq=8*flr(jm/16) local jr=8*w local js=8*h local jt=scale or 1 local ju=jr*jt local jv=js*jt sspr(jp,jq,jr,js,x,fy+y,ju,jv,flip_x,jo) end function set_trans_col(jn,bp) palt(0,false) palt(jn,true) if jn and jn>0 then
palt(0,false) end end function gn() for fg in all(rooms) do jw(fg) if(#fg.map>2) then
fg.id=fg.map[3]-fg.map[1]+1 fg.ie=fg.map[4]-fg.map[2]+1 else fg.id=16 fg.ie=8 end fg.autodepth_pos=fg.autodepth_pos or{9,50} fg.autodepth_scale=fg.autodepth_scale or{0.25,1} for bt in all(fg.objects) do jw(bt) bt.in_room=fg bt.h=bt.h or 0 if bt.init then
bt.init(bt) end end end for jx,ch in pairs(actors) do jw(ch) ch.fh=2 ch.dq=1 ch.ix=1 ch.dp=1 ch.bn={} ch.hp=0 end end function ii(bt) local jy=bt.hw if show_collision
and jy then rect(jy.x,jy.y,jy.jz,jy.ka,8) end end function gq(scripts) for ep in all(scripts) do if ep[2] and not coresume(ep[2],ep[3],ep[4]) then
del(scripts,ep) ep=nil end end end function ij(kb) if kb then kb=1-kb end
local fq=flr(mid(0,kb,1)*100) local kc={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for kd=1,15 do col=kd ke=(fq+(kd*1.46))/22 for eo=1,ke do col=kc[col] end pal(kd,col) end end function ce(cc) if type(cc)=="table"then
cc=cc.x end return mid(0,cc-64,(room_curr.id*8)-128) end function fj(bt) local fk=flr(bt.x/8)+room_curr.map[1] local fl=flr(bt.y/8)+room_curr.map[2] return{fk,fl} end function kf(fk,fl) local kg=mget(fk,fl) local kh=fget(kg,0) return kh end function cx(msg,ey) local cw={} local ki=""local kj=""local fb=""local kk=function(kl) if#kj+#ki>kl then
add(cw,ki) ki=""end ki=ki..kj kj=""end for fa=1,#msg do fb=sub(msg,fa,fa) kj=kj..fb if fb==" "
or#kj>ey-1 then kk(ey) elseif#kj>ey-1 then kj=kj.."-"kk(ey) elseif fb==";"then ki=ki..sub(kj,1,#kj-1) kj=""kk(0) end end kk(ey) if ki!=""then
add(cw,ki) end return cw end function cz(cw) cy=0 for je in all(cw) do if#je>cy then cy=#je end
end return cy end function has_flag(bt,km) for kn in all(bt) do if kn==km then
return true end end return false end function hu(bt,w,h,ko,kp) x=bt.x y=bt.y if has_flag(bt.classes,"class_actor") then
bt.de=x-(bt.w*8)/2 bt.hz=y-(bt.h*8)+1 x=bt.de y=bt.hz end bt.hw={x=x,y=y+fy,jz=x+w-1,ka=y+h+fy-1,ko=ko,kp=kp} end function fo(kq,kr) local ks,kt,ku,kv,kw={},{},{},nil,nil kx(ks,kq,0) kt[ky(kq)]=nil ku[ky(kq)]=0 while#ks>0 and#ks<1000 do local kz=ks[#ks] del(ks,ks[#ks]) la=kz[1] if ky(la)==ky(kr) then
break end local lb={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local lc=la[1]+x local ld=la[2]+y if abs(x)!=abs(y) then le=1 else le=1.4 end
if lc>=room_curr.map[1] and lc<=room_curr.map[1]+room_curr.id
and ld>=room_curr.map[2] and ld<=room_curr.map[2]+room_curr.ie and kf(lc,ld) and((abs(x)!=abs(y)) or kf(lc,la[2]) or kf(lc-x,ld) or enable_diag_squeeze) then add(lb,{lc,ld,le}) end end end end for lf in all(lb) do local lg=ky(lf) local lh=ku[ky(la)]+lf[3] if not ku[lg]
or lh<ku[lg] then ku[lg]=lh local h=max(abs(kr[1]-lf[1]),abs(kr[2]-lf[2])) local li=lh+h kx(ks,lf,li) kt[lg]=la if not kv
or h<kv then kv=h kw=lg lj=lf end end end end local fn={} la=kt[ky(kr)] if la then
add(fn,kr) elseif kw then la=kt[kw] add(fn,lj) end if la then
local lk=ky(la) local ll=ky(kq) while lk!=ll do add(fn,la) la=kt[lk] lk=ky(la) end for fa=1,#fn/2 do local lm=fn[fa] local ln=#fn-(fa-1) fn[fa]=fn[ln] fn[ln]=lm end end return fn end function kx(lo,cc,fq) if#lo>=1 then
add(lo,{}) for fa=(#lo),2,-1 do local lf=lo[fa-1] if fq<lf[2] then
lo[fa]={cc,fq} return else lo[fa]=lf end end lo[1]={cc,fq} else add(lo,{cc,fq}) end end function ky(lp) return((lp[1]+1)*16)+lp[2] end function il(bt) bt.dq+=1 if bt.dq>bt.frame_delay then
bt.dq=1 bt.dp+=1 if bt.dp>#bt.dn then bt.dp=1 end
end end function dw(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function jw(bt) local cw=lq(bt.data,"\n") for je in all(cw) do local pairs=lq(je,"=") if#pairs==2 then
bt[pairs[1]]=lr(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function lq(en,lt) local lu={} local ji=0 local lv=0 for fa=1,#en do local lw=sub(en,fa,fa) if lw==lt then
add(lu,sub(en,ji,lv)) ji=0 lv=0 elseif lw!=" "and lw!="\t"then lv=fa if ji==0 then ji=fa end
end end if ji+lv>0 then
add(lu,sub(en,ji,lv)) end return lu end function lr(lx) local ly=sub(lx,1,1) local lu=nil if lx=="true"then
lu=true elseif lx=="false"then lu=false elseif lz(ly) then if ly=="-"then
lu=sub(lx,2,#lx)*-1 else lu=lx+0 end elseif ly=="{"then local lm=sub(lx,2,#lx-1) lu=lq(lm,",") ma={} for cc in all(lu) do cc=lr(cc) add(ma,cc) end lu=ma else lu=lx end return lu end function lz(fp) for mb=1,13 do if fp==sub("0123456789.-+",mb,mb) then
return true end end end function outline_text(mc,x,y,md,me,es) if not es then mc=jb(mc) end
for mf=-1,1 do for mg=-1,1 do print(mc,x+mf,y+mg,me) end end print(mc,x,y,md) end function jc(en) return 63.5-flr((#en*4)/2) end function mh(en) return 61 end function hs(bt) if not bt.hw
or cr then return false end hw=bt.hw if(fz+hw.ko>hw.jz or fz+hw.ko<hw.x)
or(ga>hw.ka or ga<hw.y) then return false else return true end end function jb(en) local mb=""local je,fp,lo=false,false for fa=1,#en do local hy=sub(en,fa,fa) if hy=="^"then
if fp then mb=mb..hy end
fp=not fp elseif hy=="~"then if lo then mb=mb..hy end
lo,je=not lo,not je else if fp==je and hy>="a"and hy<="z"then
for kd=1,26 do if hy==sub("abcdefghijklmnopqrstuvwxyz",kd,kd) then
hy=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",kd,kd) break end end end mb=mb..hy fp,lo=false,false end end return mb end
