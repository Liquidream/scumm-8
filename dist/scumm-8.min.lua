
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
local fo=sqrt((ca.x-cb.x)^2+(ca.y-cb.y)^2) return fo else return 1000 end end fs=16 cam_x,cf,ci,br=0,nil,nil,0 ft,fu,fv,fw=63.5,63.5,0,1 fx={{spr=ui_uparrowspr,x=75,y=fs+60},{spr=ui_dnarrowspr,x=75,y=fs+72}} dl={face_front=1,face_left=2,face_back=3,face_right=4} function fy(bu) local fz={} for ek,bw in pairs(bu) do add(fz,ek) end return fz end function get_verb(bu) local bz={} local fz=fy(bu[1]) add(bz,fz[1]) add(bz,bu[1][fz[1]]) add(bz,bu.text) return bz end function ec() ga=get_verb(verb_default) gb,gc,o,gd,ge=nil,nil,nil,false,""end ec() en=nil ct=nil cr=nil er=nil ei={} eb={} cq={} gf={} dz,dz=0,0 gg=0 function _init() if enable_mouse then poke(0x5f2d,1) end
gh() start_script(startup_script,true) end function _update60() gi() end function _draw() gj() end function gi() if selected_actor and selected_actor.cn
and not coresume(selected_actor.cn) then selected_actor.cn=nil end gk(ei) if cr then
if cr.cn
and not coresume(cr.cn) then if cr.cm!=3
and cr.cp then camera_follow(cr.cp) selected_actor=cr.cp end del(cq,cr) if#cq>0 then
cr=cq[#cq] else if cr.cm!=2 then
gg=3 end cr=nil end end else gk(eb) end gl() gm() gn,go=1.5-rnd(3),1.5-rnd(3) gn=flr(gn*br) go=flr(go*br) if not bs then
br*=0.90 if br<0.05 then br=0 end
end end function gj() rectfill(0,0,127,127,0) camera(cam_x+gn,0+go) clip(0+dz-gn,fs+dz-go,128-dz*2-gn,64-dz*2) gp() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,fs-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fs-8,8) end if show_debuginfo then
print("x: "..flr(ft+cam_x).." y:"..fu-fs,80,fs-8,8) end gq() if ct
and ct.cv then gr() gs() return end if gg>0 then
gg-=1 return end if not cr then
gt() end if(not cr
or cr.cm==2) and gg==0 then gu() else end if not cr then
gs() end end function gl() if cr then
if(btnp(5) or stat(34)>0)
and cr.co then cr.cn=cocreate(cr.co) cr.co=nil return end return end if btn(0) then ft-=1 end
if btn(1) then ft+=1 end
if btn(2) then fu-=1 end
if btn(3) then fu+=1 end
if btnp(4) then gv(1) end
if btnp(5) then gv(2) end
if enable_mouse then
gw,gx=stat(32)-1,stat(33)-1 if gw!=gy then ft=gw end
if gx!=gz then fu=gx end
if stat(34)>0 then
if not ha then
gv(stat(34)) ha=true end else ha=false end gy=gw gz=gx end ft=mid(0,ft,127) fu=mid(0,fu,127) end function gv(hb) local hc=ga if not selected_actor then
return end if ct and ct.cv then
if hd then
selected_sentence=hd end return end if he then
ga=get_verb(he) elseif hf then if hb==1 then
if(ga[2]=="use"or ga[2]=="give")
and gb then gc=hf else gb=hf end elseif hg then ga=get_verb(hg) gb=hf fy(gb) gt() end elseif hh then if hh==fx[1] then
if selected_actor.hi>0 then
selected_actor.hi-=1 end else if selected_actor.hi+2<flr(#selected_actor.bo/4) then
selected_actor.hi+=1 end end return end if gb!=nil
then if ga[2]=="use"or ga[2]=="give"then
if gc then
elseif gb.use_with and gb.owner==selected_actor then return end end gd=true selected_actor.cn=cocreate(function() if(not gb.owner
and(not has_flag(gb.classes,"class_actor") or ga[2]!="use")) or gc then hj=gc or gb hk=get_use_pos(hj) walk_to(selected_actor,hk.x,hk.y) if selected_actor.fd!=2 then return end
use_dir=hj if hj.use_dir then use_dir=hj.use_dir end
do_anim(selected_actor,"anim_face",use_dir) end if valid_verb(ga,gb) then
start_script(gb.verbs[ga[1]],false,gb,gc) else if has_flag(gb.classes,"class_door") then
if ga[2]=="walkto"then
come_out_door(gb,gb.target_door) elseif ga[2]=="open"then open_door(gb,gb.target_door) elseif ga[2]=="close"then close_door(gb,gb.target_door) end else by(ga[2],gb,gc) end end ec() end) coresume(selected_actor.cn) elseif fu>fs and fu<fs+64 then gd=true selected_actor.cn=cocreate(function() walk_to(selected_actor,ft+cam_x,fu-fs) ec() end) coresume(selected_actor.cn) end end function gm() if not room_curr then
return end he,hg,hf,hd,hh=nil,nil,nil,nil,nil if ct
and ct.cv then for ej in all(ct.cu) do if hl(ej) then
hd=ej end end return end hm() for bu in all(room_curr.objects) do if(not bu.classes
or(bu.classes and not has_flag(bu.classes,"class_untouchable"))) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) then hn(bu,bu.w*8,bu.h*8,cam_x,ho) else bu.hp=nil end if hl(bu) then
if not hf
or(not bu.z and hf.z<0) or(bu.z and hf.z and bu.z>hf.z) then hf=bu end end hq(bu) end for ek,ch in pairs(actors) do if ch.in_room==room_curr then
hn(ch,ch.w*8,ch.h*8,cam_x,ho) hq(ch) if hl(ch)
and ch!=selected_actor then hf=ch end end end if selected_actor then
for bw in all(verbs) do if hl(bw) then
he=bw end end for hr in all(fx) do if hl(hr) then
hh=hr end end for ek,bu in pairs(selected_actor.bo) do if hl(bu) then
hf=bu if ga[2]=="pickup"and hf.owner then
ga=nil end end if bu.owner!=selected_actor then
del(selected_actor.bo,bu) end end if ga==nil then
ga=get_verb(verb_default) end if hf then
hg=bt(hf) end end end function hm() gf={} for x=-64,64 do gf[x]={} end end function hq(bu) eq=-1 if bu.hs then
eq=bu.y else eq=bu.y+(bu.h*8) end ht=flr(eq) if bu.z then
ht=bu.z end add(gf[ht],bu) end function gp() if not room_curr then
print("-error-  no current room set",5+cam_x,5+fs,8,0) return end rectfill(0,fs,127,fs+64,room_curr.hu or 0) for z=-64,64 do if z==0 then
hv(room_curr) if room_curr.trans_col then
palt(0,false) palt(room_curr.trans_col,true) end map(room_curr.map[1],room_curr.map[2],0,fs,room_curr.hw,room_curr.hx) pal() else ht=gf[z] for bu in all(ht) do if not has_flag(bu.classes,"class_actor") then
if bu.states
or(bu.state and bu[bu.state] and bu[bu.state]>0) and(not bu.dependent_on or bu.dependent_on.state==bu.dependent_on_state) and not bu.owner or bu.draw then hy(bu) end else if bu.in_room==room_curr then
hz(bu) end end ia(bu) end end end end function hv(bu) if bu.col_replace then
ib=bu.col_replace pal(ib[1],ib[2]) end if bu.lighting then
ic(bu.lighting) elseif bu.in_room and bu.in_room.lighting then ic(bu.in_room.lighting) end end function hy(bu) hv(bu) if bu.draw then
bu.draw(bu) else id=1 if bu.repeat_x then id=bu.repeat_x end
for h=0,id-1 do local ie=0 if bu.states then
ie=bu.states[bu.state] else ie=bu[bu.state] end ig(ie,bu.x+(h*(bu.w*8)),bu.y,bu.w,bu.h,bu.trans_col,bu.flip_x) end end pal() end function hz(ch) ih=dl[ch.face_dir] if ch.fd==1
and ch.fr then ch.ii+=1 if ch.ii>ch.frame_delay then
ch.ii=1 ch.ij+=1 if ch.ij>#ch.fr then ch.ij=1 end
end ik=ch.fr[ch.ij] else ik=ch.idle[ih] end hv(ch) ig(ik,ch.de,ch.hs,ch.w,ch.h,ch.trans_col,ch.flip,false) if er
and er==ch and er.talk then if ch.il<7 then
ik=ch.talk[ih] ig(ik,ch.de,ch.hs+8,1,1,ch.trans_col,ch.flip,false) end ch.il+=1 if ch.il>14 then ch.il=1 end
end pal() end function gt() im=""io=verb_maincol ip=ga[2] if ga then
im=ga[3] end if gb then
im=im.." "..gb.name if ip=="use"then
im=im.." with"elseif ip=="give"then im=im.." to"end end if gc then
im=im.." "..gc.name elseif hf and hf.name!=""and(not gb or(gb!=hf)) and(not hf.owner or ip!=get_verb(verb_default)[2]) then im=im.." "..hf.name end ge=im if gd then
im=ge io=verb_hovcol end print(iq(im),ir(im),fs+66,io) end function gq() if en then
is=0 for it in all(en.ez) do iu=0 if en.es==1 then
iu=((en.db*4)-(#it*4))/2 end outline_text(it,en.x+iu,en.y+is,en.col,0,en.eo) is+=6 end en.fa-=1 if en.fa<=0 then
stop_talking() end end end function gu() ey,eq,iv=0,75,0 for bw in all(verbs) do iw=verb_maincol if hg
and bw==hg then iw=verb_defcol end if bw==he then iw=verb_hovcol end
bx=get_verb(bw) print(bx[3],ey,eq+fs+1,verb_shadcol) print(bx[3],ey,eq+fs,iw) bw.x=ey bw.y=eq hn(bw,#bx[3]*4,5,0,0) ia(bw) if#bx[3]>iv then iv=#bx[3] end
eq+=8 if eq>=95 then
eq=75 ey+=(iv+1.0)*4 iv=0 end end if selected_actor then
ey,eq=86,76 ix=selected_actor.hi*4 iy=min(ix+8,#selected_actor.bo) for iz=1,8 do rectfill(ey-1,fs+eq-1,ey+8,fs+eq+8,verb_shadcol) bu=selected_actor.bo[ix+iz] if bu then
bu.x,bu.y=ey,eq hy(bu) hn(bu,bu.w*8,bu.h*8,0,0) ia(bu) end ey+=11 if ey>=125 then
eq+=12 ey=86 end iz+=1 end for ew=1,2 do ja=fx[ew] if hh==ja then
pal(7,verb_hovcol) else pal(7,verb_maincol) end pal(5,verb_shadcol) ig(ja.spr,ja.x,ja.y,1,1,0) hn(ja,8,7,0,0) ia(ja) pal() end end end function gr() ey,eq=0,70 for ej in all(ct.cu) do if ej.db>0 then
ej.x,ej.y=ey,eq hn(ej,ej.db*4,#ej.cw*5,0,0) iw=ct.col if ej==hd then iw=ct.dc end
for it in all(ej.cw) do print(iq(it),ey,eq+fs,iw) eq+=5 end ia(ej) eq+=2 end end end function gs() col=ui_cursor_cols[fw] pal(7,col) spr(ui_cursorspr,ft-4,fu-3,1,1,0) pal() fv+=1 if fv>7 then
fv=1 fw+=1 if fw>#ui_cursor_cols then fw=1 end
end end function ig(jb,x,y,w,h,jc,flip_x,jd) set_trans_col(jc,true) spr(jb,x,fs+y,w,h,flip_x,jd) end function set_trans_col(jc,bq) palt(0,false) palt(jc,true) if jc and jc>0 then
palt(0,false) end end function gh() for fc in all(rooms) do je(fc) if(#fc.map>2) then
fc.hw=fc.map[3]-fc.map[1]+1 fc.hx=fc.map[4]-fc.map[2]+1 else fc.hw=16 fc.hx=8 end for bu in all(fc.objects) do je(bu) bu.in_room=fc bu.h=bu.h or 0 if bu.init then
bu.init(bu) end end end for jf,ch in pairs(actors) do je(ch) ch.fd=2 ch.ii=1 ch.il=1 ch.ij=1 ch.bo={} ch.hi=0 end end function ia(bu) local jg=bu.hp if show_collision
and jg then rect(jg.x,jg.y,jg.jh,jg.ji,8) end end function gk(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ic(jj) if jj then jj=1-jj end
local fl=flr(mid(0,jj,1)*100) local jk={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jl=1,15 do col=jl jm=(fl+(jl*1.46))/22 for ek=1,jm do col=jk[col] end pal(jl,col) end end function ce(cd) if type(cd)=="table"then
cd=cd.x end return mid(0,cd-64,(room_curr.hw*8)-128) end function ff(bu) local fg=flr(bu.x/8)+room_curr.map[1] local fh=flr(bu.y/8)+room_curr.map[2] return{fg,fh} end function jn(fg,fh) local jo=mget(fg,fh) local jp=fget(jo,0) return jp end function cx(msg,eu) local cw={} local jq=""local jr=""local ex=""local js=function(jt) if#jr+#jq>jt then
add(cw,jq) jq=""end jq=jq..jr jr=""end for ew=1,#msg do ex=sub(msg,ew,ew) jr=jr..ex if ex==" "
or#jr>eu-1 then js(eu) elseif#jr>eu-1 then jr=jr.."-"js(eu) elseif ex==";"then jq=jq..sub(jr,1,#jr-1) jr=""js(0) end end js(eu) if jq!=""then
add(cw,jq) end return cw end function cz(cw) cy=0 for it in all(cw) do if#it>cy then cy=#it end
end return cy end function has_flag(bu,ju) for be in all(bu) do if be==ju then
return true end end return false end function hn(bu,w,h,jv,jw) x=bu.x y=bu.y if has_flag(bu.classes,"class_actor") then
bu.de=x-(bu.w*8)/2 bu.hs=y-(bu.h*8)+1 x=bu.de y=bu.hs end bu.hp={x=x,y=y+fs,jh=x+w-1,ji=y+h+fs-1,jv=jv,jw=jw} end function fk(jx,jy) local jz,ka,kb,kc,kd={},{},{},nil,nil ke(jz,jx,0) ka[kf(jx)]=nil kb[kf(jx)]=0 while#jz>0 and#jz<1000 do local kg=jz[#jz] del(jz,jz[#jz]) kh=kg[1] if kf(kh)==kf(jy) then
break end local ki={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else local kj=kh[1]+x local kk=kh[2]+y if abs(x)!=abs(y) then kl=1 else kl=1.4 end
if kj>=room_curr.map[1] and kj<=room_curr.map[1]+room_curr.hw
and kk>=room_curr.map[2] and kk<=room_curr.map[2]+room_curr.hx and jn(kj,kk) and((abs(x)!=abs(y)) or jn(kj,kh[2]) or jn(kj-x,kk) or enable_diag_squeeze) then add(ki,{kj,kk,kl}) end end end end for km in all(ki) do local kn=kf(km) local ko=kb[kf(kh)]+km[3] if not kb[kn]
or ko<kb[kn] then kb[kn]=ko local h=max(abs(jy[1]-km[1]),abs(jy[2]-km[2])) local kp=ko+h ke(jz,km,kp) ka[kn]=kh if not kc
or h<kc then kc=h kd=kn kq=km end end end end local fj={} kh=ka[kf(jy)] if kh then
add(fj,jy) elseif kd then kh=ka[kd] add(fj,kq) end if kh then
local kr=kf(kh) local ks=kf(jx) while kr!=ks do add(fj,kh) kh=ka[kr] kr=kf(kh) end for ew=1,#fj/2 do local kt=fj[ew] local ku=#fj-(ew-1) fj[ew]=fj[ku] fj[ku]=kt end end return fj end function ke(kv,cd,fl) if#kv>=1 then
add(kv,{}) for ew=(#kv),2,-1 do local km=kv[ew-1] if fl<km[2] then
kv[ew]={cd,fl} return else kv[ew]=km end end kv[1]={cd,fl} else add(kv,{cd,fl}) end end function kf(kw) return((kw[1]+1)*16)+kw[2] end function ds(msg) print_line("-error-;"..msg,5+cam_x,5,8,0) end function je(bu) local cw=kx(bu.data,"\n") for it in all(cw) do local pairs=kx(it,"=") if#pairs==2 then
bu[pairs[1]]=ky(pairs[2]) else printh(" > invalid data: ["..pairs[1].."]") end end end function kx(ej,kz) local la={} local ix=0 local lb=0 for ew=1,#ej do local lc=sub(ej,ew,ew) if lc==kz then
add(la,sub(ej,ix,lb)) ix=0 lb=0 elseif lc!=" "and lc!="\t"then lb=ew if ix==0 then ix=ew end
end end if ix+lb>0 then
add(la,sub(ej,ix,lb)) end return la end function ky(ld) local le=sub(ld,1,1) local la=nil if ld=="true"then
la=true elseif ld=="false"then la=false elseif lf(le) then if le=="-"then
la=sub(ld,2,#ld)*-1 else la=ld+0 end elseif le=="{"then local kt=sub(ld,2,#ld-1) la=kx(kt,",") lg={} for cd in all(la) do cd=ky(cd) add(lg,cd) end la=lg else la=ld end return la end function lf(ib) for a=1,13 do if ib==sub("0123456789.-+",a,a) then
return true end end end function outline_text(lh,x,y,li,lj,eo) if not eo then lh=iq(lh) end
for lk=-1,1 do for ll=-1,1 do print(lh,x+lk,y+ll,lj) end end print(lh,x,y,li) end function ir(ej) return 63.5-flr((#ej*4)/2) end function lm(ej) return 61 end function hl(bu) if not bu.hp
or cr then return false end hp=bu.hp if(ft+hp.jv>hp.jh or ft+hp.jv<hp.x)
or(fu>hp.ji or fu<hp.y) then return false else return true end end function iq(ej) local a=""local it,ib,kv=false,false for ew=1,#ej do local hr=sub(ej,ew,ew) if hr=="^"then
if ib then a=a..hr end
ib=not ib elseif hr=="~"then if kv then a=a..hr end
kv,it=not kv,not it else if ib==it and hr>="a"and hr<="z"then
for jl=1,26 do if hr==sub("abcdefghijklmnopqrstuvwxyz",jl,jl) then
hr=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",jl,jl) break end end end a=a..hr ib,kv=false,false end end return a end
