pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
show_debuginfo=true show_collision=false show_perfinfo=false enable_mouse=true a=printh verbs={{{b="open"},text="open"},{{c="close"},text="close"},{{d="give"},text="give"},{{e="pickup"},text="pick-up"},{{f="lookat"},text="look-at"},{{g="talkto"},text="talk-to"},{{i="push"},text="push"},{{j="pull"},text="pull"},{{k="use"},text="use"}} verb_default={{l="walkto"},text="walk to"} verb_maincol=12 verb_hovcol=7 verb_shadcol=1 verb_defcol=10 state_closed=1 state_open=2 state_off=1 state_on=2 state_gone=1 state_here=2 class_untouchable=1 class_pickupable=2 class_talkable=4 class_giveable=8 class_openable=16 class_actor=32 cut_noverbs=1 cut_no_follow=4 face_front=1 face_left=2 face_back=3 face_right=4 pos_infront=1 pos_behind=3 pos_left=2 pos_right=4 pos_inside=5 anim_face=1 rooms={m={map_x=0,map_y=8,enter=function(n) if not n.o then
n.o=true cutscene(cut_noverbs+cut_no_follow,function() break_time(50) print_line("in a galaxy not far away...",64,45,8,1) change_room(rooms.p,1) shake(true) start_script(rooms.p.scripts.q,true) print_line("cozy fireplaces...",90,20,8,1) print_line("(just look at it!)",90,20,8,1) shake(false) change_room(rooms.r,1) print_line("strange looking aliens...",30,20,8,1,true) put_actor_at(actors.s,130,actors.s.y,rooms.r) walk_to(actors.s,actors.s.x-30,actors.s.y) wait_for_actor(actors.s) say_line(actors.s,"what did you call me?!") change_room(rooms.t,1) print_line("and even swimming pools!",90,20,8,1,true) camera_at(200) camera_pan_to(0) wait_for_camera() print_line("quack!",45,60,10,1) change_room(rooms.u,1) end) end end,exit=function() end,scripts={},objects={},},p={map_x=0,map_y=0,enter=function(n) start_script(n.scripts.v,true) start_script(n.scripts.ba) end,exit=function(n) stop_script(n.scripts.v) stop_script(n.scripts.ba) end,lighting=0.75,scripts={v=function() while true do for bb=1,3 do set_state("fire",bb) break_time(8) end end end,q=function() bc=-1 while true do for x=1,3 do for bb=1,3 do set_state("spinning top",bb) break_time(4) end bd=find_object("spinning top") bd.x-=bc end bc*=-1 end end,ba=function() while true do a("tentacle guarding---...") if proximity(actors.be,actors.s)<30 then
say_line(actors.s,"halt!!!") end break_time(10) end end},objects={bf={name="fire",state=1,x=8*8,y=4*8,states={145,146,147},w=1,h=1,lighting=1,verbs={f=function() say_line("it's a nice, warm fire...") break_time(10) do_anim(selected_actor,anim_face,face_front) say_line("ouch! it's hot!:*stupid fire*") end,g=function() say_line("'hi fire...'") break_time(10) do_anim(selected_actor,anim_face,face_front) say_line("the fire didn't say hello back:burn!!") end,e=function(n) pickup_obj(n) end,}},bg={name="front door",class=class_openable,state=state_closed,x=1*8,y=2*8,bh=-10,states={143,0},w=1,h=4,use_pos=pos_right,use_dir=face_left,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.u.objects.bg) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.u.objects.bg) end,c=function(n) close_door(n,rooms.u.objects.bg) end}},bi={name="kitchen",state=state_open,x=14*8,y=2*8,w=1,h=4,use_pos=pos_left,use_dir=face_right,verbs={l=function() come_out_door(rooms.r.objects.bj) end}},bk={name="bucket",class=class_pickupable,state=state_open,x=13*8,y=6*8,w=1,h=1,states={207,223},trans_col=15,verbs={f=function(n) if owner_of(n)==selected_actor then
say_line("it is a bucket in my pocket") else say_line("it is a bucket") end end,e=function(n) pickup_obj(n) end,d=function(n,bl) if bl==actors.s then
say_line("can you fill this up for me?") say_line(actors.s,"sure") n.owner=actors.s break_time(30) say_line(actors.s,"here ya go...") n.state=state_closed n.name="full bucket"pickup_obj(n) else say_line("i might need this") end end}},bm={name="spinning top",state=1,x=2*8,y=6*8,states={192,193,194},col_replace={{12,7}},trans_col=15,w=1,h=1,verbs={i=function(n) if script_running(room_curr.scripts.q) then
stop_script(room_curr.scripts.q) set_state(n,1) else start_script(room_curr.scripts.q) end end,j=function(n) stop_script(room_curr.scripts.q) set_state(n,1) end}},bn={name="window",class=class_openable,state=state_closed,use_pos={x=5*8,y=(7*8)+1},x=4*8,y=1*8,w=2,h=2,states={132,134},verbs={b=function(n) if not n.bo then
cutscene(cut_noverbs,function() n.bo=true set_state(n,state_open) print_line("*bang*",40,20,8,1) change_room(rooms.r,1) selected_actor=actors.s walk_to(selected_actor,selected_actor.x+10,selected_actor.y) say_line("what was that?!") say_line("i'd better check...") walk_to(selected_actor,selected_actor.x-10,selected_actor.y) change_room(rooms.p,1) break_time(50) put_actor_at(selected_actor,115,44,rooms.p) walk_to(selected_actor,selected_actor.x-10,selected_actor.y) say_line("intruder!!!") do_anim(actors.be,anim_face,actors.s) end,function() change_room(rooms.p) put_actor_at(actors.s,105,44,rooms.p) stop_talking() do_anim(actors.be,anim_face,actors.s) end) end end}}}},r={map_x=16,map_y=0,map_x1=39,map_y1=7,enter=function() end,exit=function() end,scripts={},objects={bj={name="hall",state=state_open,x=1*8,y=2*8,w=1,h=4,use_pos=pos_right,use_dir=face_left,verbs={l=function() come_out_door(rooms.p.objects.bi) end}},bp={name="back door",class=class_openable,state=state_closed,x=22*8,y=2*8,bh=-10,states={143,0},flip_x=true,w=1,h=4,use_pos=pos_left,use_dir=face_right,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.t.objects.bq) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.p.objects.bg) end,c=function(n) close_door(n,rooms.p.objects.bg) end}},},},u={map_x=16,map_y=8,map_x1=47,map_y1=15,enter=function(n) if not n.o then
n.o=true selected_actor=actors.be put_actor_at(selected_actor,144,36,rooms.u) camera_follow(selected_actor) cutscene(cut_noverbs,function() camera_at(0) camera_pan_to(selected_actor) wait_for_camera() say_line("let's do this") end) end end,exit=function(n) end,scripts={},objects={br={class=class_untouchable,x=10*8,y=3*8,state=1,states={111},w=1,h=2,repeat_x=8},bs={class=class_untouchable,x=22*8,y=3*8,state=1,states={111},w=1,h=2,repeat_x=8},bg={name="front door",class=class_openable,state=state_closed,x=19*8,y=1*8,states={142,0},flip_x=true,w=1,h=3,use_dir=face_back,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.p.objects.bg) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.p.objects.bg) end,c=function(n) close_door(n,rooms.p.objects.bg) end}},},},t={map_x=40,map_y=0,map_x1=63,map_y1=7,enter=function() end,exit=function() end,scripts={},objects={bq={name="kitchen",state=state_open,x=13*8,y=1*8,w=1,h=3,verbs={l=function() come_out_door(rooms.r.objects.bp) end}}},},} actors={be={class=class_actor,w=1,h=4,face_dir=face_front,idle={1,3,5,3},talk={6,22,21,22},walk_anim={2,3,4,3},col=12,trans_col=11,speed=0.6,},s={name="purple tentacle",class=class_talkable+class_actor,x=127/2-24,y=127/2-16,w=1,h=3,face_dir=face_front,idle={30,30,30,30},talk={47,47,47,47},col=11,trans_col=15,speed=0.25,use_pos=pos_left,in_room=rooms.r,verbs={f=function() say_line("it's a weird looking tentacle, thing!") end,g=function(n) cutscene(cut_noverbs,function() say_line(n,"what do you want?") end) while(true) do dialog_add("where am i?") dialog_add("who are you?") dialog_add("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?") dialog_add("nevermind") dialog_start(selected_actor.col,7) while not selected_sentence do break_time() end dialog_hide() cutscene(cut_noverbs,function() say_line(selected_sentence.msg) if selected_sentence.num==1 then
say_line(n,"you are in paul's game") elseif selected_sentence.num==2 then say_line(n,"it's complicated...") elseif selected_sentence.num==3 then say_line(n,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!") elseif selected_sentence.num==4 then say_line(n,"ok bye!") dialog_end() return end end) dialog_clear() end end}}} function startup_script() change_room(rooms.m,1) end function find_default_verb(bt) local bu=nil if has_flag(bt.class,class_talkable) then
bu="talkto"elseif has_flag(bt.class,class_openable) then if bt.state==state_closed then
bu="open"else bu="close"end else bu="lookat"end for bv in all(verbs) do bw=get_verb(bv) if bw[2]==bu then bu=bv break end
end return bu end function unsupported_action(bx,by,bz) if bx=="walkto"then
return elseif bx=="pickup"then if has_flag(by.class,class_actor) then
say_line("i don't need them") else say_line("i don't need that") end elseif bx=="use"then if has_flag(by.class,class_actor) then
say_line("i can't just *use* someone") end if bz then
if has_flag(bz.class,class_actor) then
say_line("i can't use that on someone!") else say_line("that doesn't work") end end elseif bx=="give"then if has_flag(by.class,class_actor) then
say_line("i don't think i should be giving this away") else say_line("i can't do that") end elseif bx=="lookat"then if has_flag(by.class,class_actor) then
say_line("i think it's alive") else say_line("looks pretty ordinary") end elseif bx=="open"then if has_flag(by.class,class_actor) then
say_line("they don't seem to open") else say_line("it doesn't seem to open") end elseif bx=="close"then if has_flag(by.class,class_actor) then
say_line(ca"they don't seem to close") else say_line("it doesn't seem to close") end elseif bx=="push"or bx=="pull"then if has_flag(by.class,class_actor) then
say_line("moving them would accomplish nothing") else say_line("it won't budge!") end elseif bx=="talkto"then if has_flag(by.class,class_actor) then
say_line("erm... i don't think they want to talk") else say_line("i am not talking to that!") end else say_line("hmm. no.") end end function shake(cb) if cb then
cc=1 end cd=cb end function camera_at(ce) cf=cg(ce) ch=nil ci=nil end function camera_follow(cj) ci=cj ch=nil ck=function() while ci do if ci.in_room==room_curr then
cf=cg(ci) end yield() end end start_script(ck,true) end function camera_pan_to(ce) ch=cg(ce) ci=nil ck=function() while(true) do if cf==ch then
ch=nil return elseif ch>cf then cf+=0.5 else cf-=0.5 end yield() end end start_script(ck,true) end function wait_for_camera() while script_running(ck) do yield() end end function cutscene(cl,cm,cn) co={cl=cl,cp=cocreate(cm),cq=cn,cr=ci} add(cs,co) ct=co break_time() end function dialog_add(msg) if not cu then cu={cv={},cw=false} end
cx=cy(msg,32) cz=da(cx) db={num=#cu.cv+1,msg=msg,cx=cx,dc=cz} add(cu.cv,db) end function dialog_start(col,dd) cu.col=col cu.dd=dd cu.cw=true selected_sentence=nil end function dialog_hide() cu.cw=false end function dialog_clear() cu.cv={} selected_sentence=nil end function dialog_end() cu=nil end function get_use_pos(de) df=de.use_pos if type(df)=="table"then
x=df.x-cf y=df.y-dg elseif not df or df==pos_infront then x=de.x+((de.w*8)/2)-cf-4 y=de.y+(de.h*8)+2 elseif df==pos_left then if de.dh then
x=de.x-cf-(de.w*8+4) y=de.y+1 else x=de.x-cf-2 y=de.y+((de.h*8)-2) end elseif df==pos_right then x=de.x+(de.w*8)-cf y=de.y+((de.h*8)-2) end return{x=x,y=y} end function do_anim(cj,di,dj) if di==anim_face then
if type(dj)=="table"then
dk=atan2(cj.x-dj.x,dj.y-cj.y) dl=93*(3.1415/180) dk=dl-dk dm=dk*(1130.938/3.1415) dm=dm%360 if(dm<0) then dm+=360 end
dj=4-flr(dm/90) end while cj.face_dir!=dj do if cj.face_dir<dj then
cj.face_dir+=1 else cj.face_dir-=1 end cj.flip=(cj.face_dir==face_left) break_time(10) end end end function open_door(dn,dp) if state_of(dn)==state_open then
say_line("it's already open") else set_state(dn,state_open) if dp then set_state(dp,state_open) end
end end function close_door(dn,dp) if state_of(dn)==state_closed then
say_line("it's already closed") else set_state(dn,state_closed) if dp then set_state(dp,state_closed) end
end end function come_out_door(dq,dr) ds=dq.in_room change_room(ds,dr) dt=get_use_pos(dq) put_actor_at(selected_actor,dt.x,dt.y,ds) if dq.use_dir then
du=dq.use_dir+2 if du>4 then
du-=4 end else du=1 end selected_actor.face_dir=du end function fades(dv,bv) if bv==1 then
dw=0 else dw=50 end while true do dw+=bv*2 if dw>50
or dw<0 then return end if dv==1 then
dx=min(dw,32) end yield() end end function change_room(ds,dv) stop_script(dy) if dv and room_curr then
fades(dv,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end dz={} ea() room_curr=ds if not ci
or ci.in_room!=room_curr then cf=0 end stop_talking() if dv then
dy=function() fades(dv,-1) end start_script(dy,true) else dx=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(eb,ec) if not ec then return false end
if not ec.verbs then return false end
if type(eb)=="table"then
if ec.verbs[eb[1]] then return true end
else if ec.verbs[eb] then return true end
end return false end function pickup_obj(ed) de=find_object(ed) if de
then add(selected_actor.ee,de) de.owner=selected_actor del(de.in_room.objects,de) end end function owner_of(ed) de=find_object(ed) if de then
return de.owner end end function state_of(ed,state) de=find_object(ed) if de then
return de.state end end function set_state(ed,state) de=find_object(ed) if de then
de.state=state end end function find_object(name) if type(name)=="table"then return name end
for ef,de in pairs(room_curr.objects) do if de.name==name then return de end
end end function start_script(eg,eh,ei,ej) local cp=cocreate(eg) if eh then
add(ek,{eg,cp,ei,ej}) else add(dz,{eg,cp,ei,ej}) end end function script_running(eg) for ef,el in pairs(dz) do if(el[1]==eg) then
return el end end for ef,el in pairs(ek) do if(el[1]==eg) then
return el end end return false end function stop_script(eg) el=script_running(eg) if el then
del(dz,el) del(ek,el) end end function break_time(em) em=em or 1 for x=1,em do yield() end end function wait_for_message() while en!=nil do yield() end end function say_line(cj,msg,eo) if type(cj)=="string"then
msg=cj cj=selected_actor end ep=cj.y-(cj.h)*8+4 eq=cj print_line(msg,cj.x,ep,cj.col,1,eo) end function stop_talking() en=nil eq=nil end function print_line(msg,x,y,col,er,eo) local col=col or 7 local er=er or 0 local cx={} local es=""local et=""cz=0 eu=min(x-cf,ev-(x-cf)) ew=max(flr(eu/2),16) et=""for ex=1,#msg do es=sub(msg,ex,ex) if es==":"then
et=sub(msg,ex+1) msg=sub(msg,1,ex-1) break end end cx=cy(msg,ew) cz=da(cx) if er==1 then
ey=x-cf-((cz*4)/2) end ey=max(2,ey) ep=max(18,y) ey=min(ey,ev-(cz*4)-1) en={ez=cx,x=ey,y=ep,col=col,er=er,fa=(#msg)*8,dc=cz} if(#et>0) then
fb=eq wait_for_message() eq=fb print_line(et,x,y,col,er) end if not eo then
wait_for_message() end end function put_actor_at(cj,x,y,fc) if fc then cj.in_room=fc end
cj.x=x cj.y=y end function walk_to(cj,x,y) x=x+cf fd=fe(cj) ff=flr(x/8)+room_curr.map_x fg=flr(y/8)+room_curr.map_y fh={ff,fg} fi=fj(fd,fh) fk=fe({x=x,y=y}) if fl(fk[1],fk[2]) then
add(fi,fk) end for fm in all(fi) do fn=(fm[1]-room_curr.map_x)*8+4 fo=(fm[2]-room_curr.map_y)*8+4 local fp=sqrt((fn-cj.x)^2+(fo-cj.y)^2) local fq=cj.speed*(fn-cj.x)/fp local fr=cj.speed*(fo-cj.y)/fp if fp>1 then
cj.fs=1 cj.flip=(fq<0) cj.face_dir=face_right if(cj.flip) then cj.face_dir=face_left end
for ex=0,fp/cj.speed do cj.x=cj.x+fq cj.y=cj.y+fr yield() end end end cj.fs=2 end function wait_for_actor(cj) cj=cj or selected_actor while cj.fs!=2 do yield() end end function proximity(ft,fu) if type(ft)=="string"then
ft=find_object(ft) end if type(ft)=="string"then
fu=find_object(fu) end if ft.in_room==fu.in_room then
local fp=sqrt((ft.x-fu.x)^2+(ft.y-fu.y)^2) return fp else return 1000 end end ev=127 fv=127 dg=16 cf=0 ch=nil ck=nil cc=0 fw=ev/2 fx=fv/2 fy=0 fz={7,12,13,13,12,7} ga=1 gb={{spr=16,x=75,y=dg+60},{spr=48,x=75,y=dg+72}} gc=0 gd=0 ge=false room_curr=nil gf=nil gg=nil gh=nil gi=""gj=false en=nil cu=nil ct=nil eq=nil dx=0 gk=0 ek={} dz={} cs={} gl={} function _init() if enable_mouse then poke(0x5f2d,1) end
gm() start_script(startup_script,true) end function _update60() gn() end function _draw() go() end function gn() if selected_actor and selected_actor.cp and not coresume(selected_actor.cp) then
selected_actor.cp=nil end gp(ek) if ct then
if ct.cp and not coresume(ct.cp) then
if not has_flag(ct.cl,cut_no_follow) and
ct.cr then camera_follow(ct.cr) selected_actor=ct.cr end del(cs,ct) ct=nil if#cs>0 then
ct=cs[#cs] end end else gp(dz) end gq() gr() gs=1.5-rnd(3) gt=1.5-rnd(3) gs*=cc gt*=cc if not cd then
cc*=0.90 if cc<0.05 then cc=0 end
end end function go() rectfill(0,0,ev,fv,0) camera(cf+gs,0+gt) clip(0+dx,dg+dx,ev+1-dx*2,64-dx*2) gu() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,dg-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,dg-8,8) end if show_debuginfo then
print("x: "..fw.." y:"..fx-dg,80,dg-8,8) end gv() if cu and cu.cw then
gw() gx() return end if gy==ct then
else gy=ct return end if not ct then
gz() end if(not ct
or not has_flag(ct.cl,cut_noverbs)) and(gy==ct) then ha() else end gy=ct if not ct then
gx() end end function gq() if ct then
if btnp(4) and btnp(5) and ct.cq then
ct.cp=cocreate(ct.cq) ct.cq=nil return end return end if btn(0) then fw-=1 end
if btn(1) then fw+=1 end
if btn(2) then fx-=1 end
if btn(3) then fx+=1 end
if btnp(4) then hb(1) end
if btnp(5) then hb(2) end
if enable_mouse then
if stat(32)-1!=gc then fw=stat(32)-1 end
if stat(33)-1!=gd then fx=stat(33)-1 end
if stat(34)>0 then
if not ge then
hb(stat(34)) ge=true end else ge=false end gc=stat(32)-1 gd=stat(33)-1 end fw=max(fw,0) fw=min(fw,127) fx=max(fx,0) fx=min(fx,127) end function hb(hc) local hd=gf if not selected_actor then
return end if cu and cu.cw then
if he then
selected_sentence=he end return end if hf then
gf=get_verb(hf) elseif hg then if hc==1 then
if(gf[2]=="use"or gf[2]=="give")
and gg then gh=hg else gg=hg end elseif hh then gf=get_verb(hh) gg=hg hi(gg) gz() end elseif hj then if hj==gb[1] then
if selected_actor.hk>0 then
selected_actor.hk-=1 end else if selected_actor.hk+2<flr(#selected_actor.ee/4) then
selected_actor.hk+=1 end end return end if gg!=nil
and not gj then if gf[2]=="use"or gf[2]=="give"then
if gh then
else return end end gj=true selected_actor.cp=cocreate(function(cj,de,eb,ej) if not de.owner
or ej then hl=ej or de hm=get_use_pos(hl) walk_to(selected_actor,hm.x,hm.y) if selected_actor.fs!=2 then return end
use_dir=hl if hl.use_dir then use_dir=hl.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(eb,de) then
start_script(de.verbs[eb[1]],false,de,ej) else unsupported_action(eb[2],de,ej) end ea() end) coresume(selected_actor.cp,selected_actor,gg,gf,gh) elseif(fx>dg and fx<dg+64) then gj=true selected_actor.cp=cocreate(function(x,y) walk_to(selected_actor,x,y) ea() end) coresume(selected_actor.cp,fw,fx-dg) end end function gr() hf=nil hh=nil hg=nil he=nil hj=nil if cu and cu.cw then
for hn in all(cu.cv) do if ho(hn) then
he=hn end end return end hp() for ef,de in pairs(room_curr.objects) do if(not de.class
or(de.class and de.class!=class_untouchable)) and(not de.dependent_on or find_object(de.dependent_on).state==de.dependent_on_state) then hq(de,de.w*8,de.h*8,cf,hr) else de.hs=nil end if ho(de) then
if not hg
or(de.z and not hg.z and de.z>hg.y) or(de.z and hg.z and de.z>hg.z) then hg=de end end ht(de) end for ef,cj in pairs(actors) do if cj.in_room==room_curr then
hq(cj,cj.w*8,cj.h*8,cf,hr) ht(cj) if ho(cj)
and cj!=selected_actor then hg=cj end end end if selected_actor then
for hu in all(verbs) do if ho(hu) then
hf=hu end end for hv in all(gb) do if ho(hv) then
hj=hv end end for ef,de in pairs(selected_actor.ee) do if ho(de) then
hg=de if gf[2]=="pickup"and hg.owner then
gf=nil end end if de.owner!=selected_actor then
del(selected_actor.ee,de) end end if gf==nil then
gf=get_verb(verb_default) end if hg then
hh=find_default_verb(hg) end end end function hp() gl={} for x=-64,64 do gl[x]={} end end function ht(de) ep=-1 if de.hw then
ep=de.y else ep=de.y+(de.h*8) end hx=flr(ep-dg) if de.z then hx=de.z end
add(gl[hx],de) end function gu() for z=-64,64 do if z==0 then
hy(room_curr) map(room_curr.map_x,room_curr.map_y,0,dg,room_curr.hz,room_curr.ia) pal() else hx=gl[z] for de in all(hx) do if not has_flag(de.class,class_actor) then
if(de.states)
and de.states[de.state] and(de.states[de.state]>0) and(not de.dependent_on or find_object(de.dependent_on).state==de.dependent_on_state) and not de.owner then ib(de) end else if(de.in_room==room_curr) then
ic(de) end end id(de) end end end end function hy(de) for ie in all(de.col_replace) do pal(ie[1],ie[2]) end if de.lighting then
ig(de.lighting) elseif de.in_room then ig(de.in_room.lighting) end end function ib(de) hy(de) ih=1 if de.repeat_x then ih=de.repeat_x end
for h=0,ih-1 do ii(de.states[de.state],de.x+(h*(de.w*8)),de.y,de.w,de.h,de.trans_col,de.flip_x) end pal() end function ic(cj) if cj.fs==1
and cj.walk_anim then cj.ij+=1 if cj.ij>5 then
cj.ij=1 cj.ik+=1 if cj.ik>#cj.walk_anim then cj.ik=1 end
end il=cj.walk_anim[cj.ik] else il=cj.idle[cj.face_dir] end hy(cj) ii(il,cj.dh,cj.hw,cj.w,cj.h,cj.trans_col,cj.flip,false) if eq
and eq==cj then if cj.im<7 then
il=cj.talk[cj.face_dir] ii(il,cj.dh,cj.hw+8,1,1,cj.trans_col,cj.flip,false) end cj.im+=1 if cj.im>14 then cj.im=1 end
end pal() end function gz() io=""ip=12 if not gj then
if gf then
io=gf[3] end if gg then
io=io.." "..gg.name if gf[2]=="use"then
io=io.." with"elseif gf[2]=="give"then io=io.." to"end end if gh then
io=io.." "..gh.name elseif hg and hg.name!=""and(not gg or(gg!=hg)) then io=io.." "..hg.name end gi=io else io=gi ip=7 end print(iq(io),ir(io),dg+66,ip) end function gv() if en then
is=0 for it in all(en.ez) do iu=0 if en.er==1 then
iu=((en.dc*4)-(#it*4))/2 end iv(it,en.x+iu,en.y+is,en.col) is+=6 end en.fa-=1 if(en.fa<=0) then
stop_talking() end end end function ha() ey=0 ep=75 iw=0 for hu in all(verbs) do ix=verb_maincol if hh
and(hu==hh) then ix=verb_defcol end if hu==hf then ix=verb_hovcol end
iy=get_verb(hu) print(iy[3],ey,ep+dg+1,verb_shadcol) print(iy[3],ey,ep+dg,ix) hu.x=ey hu.y=ep hq(hu,#iy[3]*4,5,0,0) id(hu) if#iy[3]>iw then iw=#iy[3] end
ep=ep+8 if ep>=95 then
ep=75 ey=ey+(iw+1.0)*4 iw=0 end end if selected_actor then
ey=86 ep=76 iz=selected_actor.hk*4 ja=min(iz+8,#selected_actor.ee) for jb=1,8 do rectfill(ey-1,dg+ep-1,ey+8,dg+ep+8,1) de=selected_actor.ee[iz+jb] if de then
de.x=ey de.y=ep ib(de) hq(de,de.w*8,de.h*8,0,0) id(de) end ey+=11 if ey>=125 then
ep+=12 ey=86 end jb+=1 end for ex=1,2 do jc=gb[ex] if hj==jc then pal(verb_maincol,7) end
ii(jc.spr,jc.x,jc.y,1,1,0) hq(jc,8,7,0,0) id(jc) pal() end end end function gw() ey=0 ep=70 for hn in all(cu.cv) do hn.x=ey hn.y=ep hq(hn,hn.dc*4,#hn.cx*5,0,0) ix=cu.col if hn==he then ix=cu.dd end
for it in all(hn.cx) do print(iq(it),ey,ep+dg,ix) ep+=5 end id(hn) ep+=2 end end function gx() col=fz[ga] pal(7,col) spr(32,fw-4,fx-3,1,1,0) pal() fy+=1 if fy>7 then
fy=1 ga+=1 if(ga>#fz) then ga=1 end
end end function ii(jd,x,y,w,h,je,flip_x,jf) palt(0,false) palt(je,true) spr(jd,x,dg+y,w,h,flip_x,jf) palt(je,false) palt(0,true) end function gm() for jg,fc in pairs(rooms) do if fc.map_x1 then
fc.hz=fc.map_x1-fc.map_x+1 fc.ia=fc.map_y1-fc.map_y+1 else fc.hz=16 fc.ia=8 end for jh,de in pairs(fc.objects) do de.in_room=fc end end for ji,cj in pairs(actors) do cj.fs=2 cj.ij=1 cj.im=1 cj.ik=1 cj.ee={} cj.hk=0 end end function id(de) if show_collision and de.hs then
rect(de.hs.x,de.hs.y,de.hs.jj,de.hs.jk,8) end end function gp(scripts) for el in all(scripts) do if el[2] and not coresume(el[2],el[3],el[4]) then
del(scripts,el) el=nil end end end function ig(jl) if jl then jl=1-jl end
local fm=flr(mid(0,jl,1)*100) jm={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14} for jn=1,15 do col=jn jo=(fm+(jn*1.46))/22 for ef=1,jo do col=jm[col] end pal(jn,col) end end function cg(ce) if type(ce)=="table"then
ce=ce.x end return mid(0,ce-64,(room_curr.hz*8)-ev-1) end function jp(x,y) ff=flr(x/8)+room_curr.map_x fg=flr(y/8)+room_curr.map_y jq=fl(ff,fg) return jq end function fe(de) ff=flr(de.x/8)+room_curr.map_x fg=flr(de.y/8)+room_curr.map_y return{ff,fg} end function fl(ff,fg) jr=mget(ff,fg) jq=fget(jr,0) return jq end function hi(de) js={} for ef,hu in pairs(de) do add(js,ef) end return js end function get_verb(de) eb={} js=hi(de[1]) add(eb,js[1]) add(eb,de[1][js[1]]) add(eb,de.text) return eb end function cy(msg,ew) local cx={} local jt=""local ju=""local es=""local jv=function(jw) if#ju+#jt>jw then
add(cx,jt) jt=""end jt=jt..ju ju=""end for ex=1,#msg do es=sub(msg,ex,ex) ju=ju..es if(es==" ")
or(#ju>ew-1) then jv(ew) elseif#ju>ew-1 then ju=ju.."-"jv(ew) elseif es==";"then jt=jt..sub(ju,1,#ju-1) ju=""jv(0) end end jv(ew) if jt!=""then
add(cx,jt) end return cx end function da(cx) cz=0 for it in all(cx) do if#it>cz then cz=#it end
end return cz end function has_flag(de,jx) if band(de,jx)!=0 then return true end
return false end function ea() gf=get_verb(verb_default) gg=nil gh=nil jy=nil gj=false gi=""end function hq(de,w,h,jz,ka) x=de.x y=de.y if has_flag(de.class,class_actor) then
de.dh=de.x-(de.w*8)/2 de.hw=de.y-(de.h*8)+1 x=de.dh y=de.hw end de.hs={x=x,y=y+dg,jj=x+w-1,jk=y+h+dg-1,jz=jz,ka=ka} end function fj(kb,kc) kd={} ke(kd,kb,0) kf={} kf[kg(kb)]=nil kh={} kh[kg(kb)]=0 while#kd>0 and#kd<1000 do local ki=kd[#kd] del(kd,kd[#kd]) kj=ki[1] if kg(kj)==kg(kc) then
break end local kk={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else kl=kj[1]+x km=kj[2]+y if abs(x)!=abs(y) then kn=1 else kn=1.4 end
if kl>=room_curr.map_x and kl<=room_curr.map_x+room_curr.hz
and km>=room_curr.map_y and km<=room_curr.map_y+room_curr.ia and fl(kl,km) and((abs(x)!=abs(y)) or fl(kl,kj[2]) or fl(kl-x,km)) then add(kk,{kl,km,kn}) end end end end for ko in all(kk) do local kp=kg(ko) local kq=kh[kg(kj)]+ko[3] if(kh[kp]==nil) or(kq<kh[kp]) then
kh[kp]=kq local kr=kq+max(abs(kc[1]-ko[1]),abs(kc[2]-ko[2])) ke(kd,ko,kr) kf[kp]=kj end end end fi={} kj=kf[kg(kc)] if kj then
local ks=kg(kj) local kt=kg(kb) while ks!=kt do add(fi,kj) kj=kf[ks] ks=kg(kj) end for ex=1,#fi/2 do local ku=fi[ex] local kv=#fi-(ex-1) fi[ex]=fi[kv] fi[kv]=ku end end return fi end function ke(kw,ce,fm) if#kw>=1 then
add(kw,{}) for ex=(#kw),2,-1 do local ko=kw[ex-1] if fm<ko[2] then
kw[ex]={ce,fm} return else kw[ex]=ko end end kw[1]={ce,fm} else add(kw,{ce,fm}) end end function kg(kx) return((kx[1]+1)*16)+kx[2] end function iv(ky,x,y,kz,la) local kz=kz or 7 local la=la or 0 ky=iq(ky) for lb=-1,1 do for lc=-1,1 do print(ky,x+lb,y+lc,la) end end print(ky,x,y,kz) end function ir(hn) return(ev/2)-flr((#hn*4)/2) end function ld(hn) return(fv/2)-flr(5/2) end function ho(de) if not de.hs then return false end
hs=de.hs if(fw+hs.jz>hs.jj or fw+hs.jz<hs.x)
or(fx>hs.jk or fx<hs.y) then return false else return true end end function iq(hn) local le=""local it,ie,kw=false,false for ex=1,#hn do local hv=sub(hn,ex,ex) if hv=="^"then
if(ie) then le=le..hv end
ie=not ie elseif hv=="~"then if(kw) then le=le..hv end
kw,it=not kw,not it else if ie==it and hv>="a"and hv<="z"then
for jn=1,26 do if hv==sub("abcdefghijklmnopqrstuvwxyz",jn,jn) then
hv=sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\",jn,jn) break end end end le=le..hv ie,kw=false,false end end return le end
__gfx__
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0f5ff5f0000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb4ffffff4000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbff44ffb000000000000000000000000000000000000000000000000000000000000000000000000
00000000b444449bb494449bb494449bb494449bb999449bb6ffff6b000000000000000000000000000000000000000000000000000000000000000000000000
000000004440444949444449494444494944444994444449bbf00fbb000000000000000000000000000000000000000000000000000000000000000000000000
000000004040000449440004494400044944000494444444bbf00fbb000000000000000000000000000000000000000000000000000000000000000000000000
0000000004ffff000440fffb0440fffb0440fffb44444444bbbffbbb000000000000000000000000000000000000000000000000000000000000000000000000
000000000f9ff9f004f0f9fb04f0f9fb04f0f9fb44444444bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000
000cc0000f5ff5f000fff5fb00fff5fb00fff5fb4444444000fff5fb00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c11c004ffffff440ffffff40ffffff40ffffff0444444440ffffff00000000000000000000000000000000000000000000000000000000ffffffff00000000
0c1001c0bff44ffbb0fffff4b0fffff4b0fffff4b044444bb0fffff400000000000000000000000000000000000000000000000000000000ffffffff00000000
ccc00cccb6ffff6bb6fffffbb6fffffbb6fffffbb044444bb6fffffb00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c00c00bbfddfbbbb6fffdbbb6fffdbbb6fffdbbb0000bbbb6ff00b00000000000000000000000000000000000000000000000000000000ffffffff00000000
00c00c00bbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbffbbbbbbff00b00000000000000000000000000000000000000000000000000000000ffffffff00000000
00cccc00bdc55cdbbbddcbbbbbbddbbbbbddcbbbbddddddbbbbbbffb00000000000000000000000000000000000000000000000000000000fff22fff00000000
00111100dcc55ccdb1ccdcbbbb1ccdbbb1ccdcbbdccccccdbbbbbbbb00000000000000000000000000000000000000000000000000000000ff0020ff00000000
00070000c1c66c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2302ffff2302ff
00070000c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ffb33bffffb33bff
00070000c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff
77707770c1c55c1cb1ccdcbbbb1ccdbbb1ccdcbbc1cccc1c0000000000000000000000000000000000000000000000000000000000000000ff2222ffff2222ff
00070000d1cddc1db1dddcbbbb1dddbbb1dddcbbd1cccc1d0000000000000000000000000000000000000000000000000000000000000000ff2bb2ffff2bb2ff
00070000fe1111efbbff11bbbb2ff1bbbbff11bbfe1111ef0000000000000000000000000000000000000000000000000000000000000000f2b33b2ff2b33b2f
00070000bf1111fbbbfe11bbbb2fe1bbbbfe11bbbf1111fb0000000000000000000000000000000000000000000000000000000000000000f22bb22ff2b33b2f
00000000bb1121bbbb2111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f222222ff22bb22f
00cccc00bb1121bbbb1111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f222222f00000000
00c11c00bb1121bbbb1111bbbb2111bbbb2111bbbb1211bb0000000000000000000000000000000000000000000000000000000000000000f22bb22f00000000
00c00c00bb1121bbbb1112bbbb2111bbbb21111bbb1211bb0000000000000000000000000000000000000000000000000000000000000000f2b33b2f00000000
ccc00cccbb1121bbbb1112bbbb2111bbbb22111bbb1211bb000000000000000000000000000000000000000000000000000000000000000022b33b2200000000
1c1001c1bb1121bbb111122bbb2111bbb222111bbb1211bb0000000000000000000000000000000000000000000000000000000000000000222bb22200000000
01c00c10bb1121bbc111222bbb2111bbb22211ccbb1211bb00000000000000000000000000000000000000000000000000000000000000002222222200000000
001cc100bbccccbb7ccc222bbbccccbbb222cc77bbccccbb00000000000000000000000000000000000000000000000000000000000000002222222200000000
00011000b776677bb7776666bb6777bbb66677bbb776677b0000000000000000000000000000000000000000000000000000000000000000bbbbbbbb00000000
00000000000000000000000000000000000000000000000077777777f9e9f9f9ddd5ddd5bbbbbbbb550000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000777777779eee9f9fdd5ddd5dbbbbbbbb555500000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000077777777feeef9f9d5ddd5ddbbbbbbbb555555000000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779fef9fef5ddd5dddbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeeddd5ddd5bbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779f9f9eeedd5ddd5dbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee00000000000000000000000077777777f9f9feeed5ddd5ddbbbbbbbb555555550000000000000000000000000000000000000000
55555555ddddddddeeeeeeee000000000000000000000000777777779f9f9fef5ddd5dddbbbbbbbb555555550000000000000000000000000000000000000000
77777755666666ddbbbbbbee33333355333333330000000066666666588885886666666600000000000000550000000000000000000000000000000000045000
777755556666ddddbbbbeeee33333355333333330000000066666666588885881c1c1c1c00000000000055550000000000000000000000000000000000045000
7755555566ddddddbbeeeeee3333666633333333000000006666666655555555c1c1c1c100000000005555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee33336666333333330000000066666666888588881c1c1c1c00000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee3355555533333333000000006666666688858888c1c1c1c10000000055555555000000000000000000000000001c7c1000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666555555551c1c1c1c00000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee6666666633333333000000006666666658888588c1c1c1c100000000555555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885887c7c7c7c00000000555555550000000000000000000000000000000000045000
55777777dd666666eebbbbbb55333333555555550000000000000000000000000000000000000000000000000000000000000000000000000000000099999999
55557777dddd6666eeeebbbb55333333555533330000000000000000000000000000000000000000000000000000000000000000000000000000000044444444
55555577dddddd66eeeeeebb66663333553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee6666333353333333000000000000000000000000000000000000000000000000000000000000000000000000000c000000045000
55555555ddddddddeeeeeeee55555533533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee55555533553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555533330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb555555555555555500000000cccccccc5555555677777777c7777777655555553333333663333333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333555500000000cccccccc555555677777777ccc777777765555553333336776333333000000000000000000045000
55555555ddddddddbbbbbbbb666666663333335500000000cccccccc55555677777777ccccc77777776555553333367777633333000000000000000000045000
55555555ddddddddbbbbbbbb666666663333333500000000cccccccc5555677777777ccccccc7777777655553333677777763333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333333500000000cccccccc555677777777ccccccccc777777765553336777777776333000000000000000000045000
55555555ddddddddbbbbbbbb555555553333335500000000cccccccc55677777777ccccccccccc77777776553367777777777633000000000000000000045000
55555555ddddddddbbbbbbbb666666663333555500000000cccccccc5677777777ccccccccccccc7777777653677777777777763000000000b03000099999999
55555555ddddddddbbbbbbbb666666665555555500000000cccccccc677777777ccccccccccccccc77777776677777777777777600000000b00030b055555555
00000000000000000000000000000000777777777777777777555555555555770000000000000000000000000000000000000000000000004444444444444444
00000000000000000000000000000000700000077000000770700000000007070000000000000000000000000000000000000000000000004ffffff44ffffff4
00000000000000000000000000000000700000077000000770070000000070070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000077000000770006000000600070000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000777777777777777777776000000677770000000000000000000000000000000000000000000000004f4444944f444494
00000000000000000000000000000000700000677600000770066000000660070000000000000000000000000000000000000000000000004f4444944f444494
0000000000000000000a000000000000700006077060000770606000000606070000000000000000000000000000000000000000000000004f9999944f444494
0000000000000000000000000000000070000507705000077050600000060507000000000000000000000000000000000000000000000000444444444f449994
0000000000a0a000000aa000000a0a0070000007700000077000600000060007000000000000000000000000000000000000000000000000444444444f994444
0000000000aaaa0000aaaa0000aaa0007000000770000007700500000000500700000000000000000000000000000000000000000000000049a4444444444444
0000000000a9aa0000a99a0000aa9a00700000077000000770500000000005070000000000000000000000000000000000000000000000004994444444444444
0000000000a99a0000a99a0000a99a00777777777777777775000000000000770000000000000000000000000000000000000000000000004444444449a44444
00000000004444000044440000444400555555555555555555555555555555550000000000000000000000000000000000000000000000004ffffff449944444
99999999777777777777777777777777700000077776000077777777777777770000000000000000000000000000000000000000000000004f44449444444444
55555555555555555555555555555555700000077776000055555555555555550000000000000000000000000000000000000000000000004f4444944444fff4
444444440dd6dd6dd6dd6dd6d6dd6d50700000077776000044444444444444440000000000000000000000000000000000000000000000004f4444944fff4494
ffff4fff0dd6dd6dd6dd6dd6d6dd6d507000000766665555444ffffffffff4440000000000000000000000000000000000000000000000004f4444944f444494
44494944066666666666666666666650700000070000777644494444444494440000000000000000000000000000000000000000000000004f4444944f444494
444949440d6dd6dd6dd6dd6ddd6dd65070000007000077764449444aa44494440000000000000000000000000000000000000000000000004f4444944f444494
444949440d6dd6dd6dd6dd6ddd6dd650777777770000777644494444444494440000000000000000000000000000000000000000000000004ffffff44f444494
4449494406666666666666666666665055555555555566664449999999999444000000000000000000000000000000000000000000000000444444444f444494
444949440dd6dd600000000056dd6d506dd6dd6d000000004449444444449444000000000000000000000000000000000000000000000000000000004f444494
444949440dd6dd650000000056dd6d5066666666000000004449444444449444000000000000000000000000000000000000000000000000000000004f444994
44494944066666650000000056666650d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f499444
444949440d6dd6d5000000005d6dd650d6dd6dd6000000004449444444449444000000000000000000000000000000000000000000000000000000004f944444
444949440d6dd6d5000000005d6dd650666666660000000044494444444494440000000000000000000000000000000000000000000000000000000044444400
444949440666666500000000566666506dd6dd6d0000000044494444444494440000000000000000000000000000000000000000000000000000000044440000
999949990dd6dd650000000056dd6d506dd6dd6d0000000044499999999994440000000000000000000000000000000000000000000000000000000044000000
444444440dd6dd650000000056dd6d50666666660000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
fff76ffffff76ffffff76fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccffffffff
fff76ffffff76ffffff76fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccf666677f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccc7cccccc7
bbbcccc8888bbbbcccc8888b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaccccd776666d
fccccc8ffbbbbbcff88888bf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000caaaccccf676650f
fccc888ffbbbcccff888bbbf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
fff00ffffff00ffffff00fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccaaaaacf676650f
fff00ffffff00ffffff00fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccccff7665ff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666677f
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000075555557
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d776666d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff7665ff
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000944
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094400
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800808
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080088008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080088008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800808
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088888888
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffff9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffffffffffffffffffff
fffffffffffffffffffffffffeeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9e9f9f97755555555555577f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9eee9f9f70700000000007079eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffffffffffffffffffff
fffffffffffffffffffffffffeeef9f97007000000007007feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffffffffffffffffffff
ffffffffffffffffffffffff9fef9fef70006000000600079fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feee7000600000060007f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9eee70006000000600079f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffffffffffffffffffffffff
fffffffffffffffffffffffff9f9feee7000600000060007f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffffffffffffffffffffffff
ffffffffffffffffffffffff9f9f9fef77776000494449779f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffffffffffffffffffffffff
ffffffff00000000fffffffff9e9f9f97006600494444497f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9eee9f9f70606004944000479eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffff00000000ffffffff
ffffffff00000000fffffffffeeef9f970506000440fff07feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9fef9fef700060004f0f9f079fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefffff7fff00000000ffffffff
ffffffff00000000fffffffff9f9feee700500000fff5f07f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeffff7fff00000000ffffffff
ffffffff00000000ffffffff9f9f9eee705000040ffffff79f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeffff7fff00000000ffffffff
ffffffff00000000fffffffff9f9feee750000000fffff47f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef777f77700000000ffffffff
ffffffff00000000ffffffff9f9f9fef555555556fffff559f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffff7fff00000000ffffffff
ffffffff00000000ffffffff999999999999999996fffd9999999999ffffffffffffffffffffffff999999999999999999999999ffff7fff00000000ffffffff
ffffffff00000000ffffffff555555555555555555ff555555555555555555555555555555555555555555555555555555555555ffff7fff00000000ffffffff
ffffffff00000000ffffffff444444444444444444dd4444444444440dd6dd6dd6dd6dd6d6dd6d50444444444444444444444444ffffffff00000000ffffffff
ffffffff00000000ffffffffffff4fffffff4ffff1ccdfffffff4fff0dd6dd6dd6dd6dd6d6dd6d50ffff4fffffff4fffffff4fff22ffffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd94444494944066666666666666666666650444949444449494444494940020fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd944444949440d6dd6dd6dd6dd6ddd6dd650444949444449494444494942302fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd944444949440d6dd6dd6dd6dd6ddd6dd65044494944444949444449494b33bfffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ccd94444494944066666666666666666666650444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494441ddd944444949440dd6dd600000000056dd6d50444949444449494444494942222fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442ff1944444949440dd6dd650000000056dd6d50444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442fe19444449494406666665000000005666665044494944444949444449492b33b2ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440d6dd6d500a0a0005d6dd650444949444449494444494922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440d6dd6d500aaaa005d6dd6504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494442111944444949440666666500a9aa00566666504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff999949999999499992111999999949990dd6dd6500a99a0056dd6d50999949999999499999994922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444444444444444442111444444444440dd6dd650044440056dd6d5044444444444444444444442b33b2ffff00000000ffffffff
ffffffff00000000ffffff555555555555555555521115555555555555555555555555555555555555555555555555555555522b33b22fff00000000ffffffff
ffffffff00000000ffff555555555555555555555211155555555555555555555555555555555555555555555555555555555222bb222fff00000000ffffffff
ffffffff00000000ff55555555555555555555555cccc55555555555555555555555555555555555555555555555555555555222222225ff00000000ffffffff
ffffffff5555555555555555555555555555555556777555555555555555555555555555555555555555555555555555555552222222255555555555ffffffff
ffffffff555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555bbbbbbbb55555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffffff5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ffffffff
ffffff55555555555557655555555555555555553333333333333333333333333333333333333333333333335555555555555555555555555555555555ffffff
ffff555555555555555765555555555555553333333333333333333333333333333333333333333333333333333355555555555556666775555555555555ffff
ff555555555555555bbbb775555555555533333333333333333333333333333333333333333333333333333333333355555555557555555755555555555555ff
5555555555555555bbb7777855555555533333333333333333333333333333333333333333333333333333333333333555555555d776666d5555555555555555
55555555555555555777778555555555533333333333333333333333333333333333333333333333333333333333333555555555567665055555555555555555
55555555555555555777888555555555553333333333333333333333333333333333333333333333333333333333335555555555567665055555555555555555
55555555555555555550055555555555555533333333333333333333333333333333333333333333333333333333555555555555567665055555555555555555
55555555555555555550055555555555555555553333333333333333333333333333333333333333333333335555555555555555557665555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c0c0ccc0c000c0c00000ccc00cc00000ccc0c0c0ccc0ccc0c000ccc00000ccc0ccc0cc00ccc0ccc0ccc0c000ccc00000000000000000000
00000000000000000c0c0c0c0c000cc0000000c00c0c00000c0c0c0c0c0c0c0c0c000cc0000000c00cc00c0c00c00c0c0c000c000cc000000000000000000000
00000000000000000ccc0ccc0c000c0c000000c00c0c00000ccc0c0c0cc00ccc0c000c00000000c00c000c0c00c00ccc0c000c000c0000000000000000000000
00000000000000000ccc0c0c0ccc0c0c000000c00cc000000c0000cc0c0c0c000ccc0ccc000000c00ccc0c0c00c00c0c0ccc0ccc0ccc00000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc0ccc0ccc0cc0000000000ccc0ccc00cc0c0c00000c0c0ccc00000ccc0c0c00cc0c0c000000000000001111111111011111111110111111111101111111111
c1c0c1c0c110c1c000000000c1c01c10c110c0c00000c0c0c1c00000c1c0c0c0c110c0c0000000cc000001111111111011111111110111111111101111111111
c0c0ccc0cc00c0c000000000ccc00c00c000cc10ccc0c0c0ccc00000ccc0c0c0ccc0ccc000000c11c00001111111111011111111110111111111101111111111
c0c0c110c100c0c000000000c1100c00c000c1c01110c0c0c1100000c110c0c011c0c1c00000c1001c0001111111111011111111110111111111101111111111
cc10c000ccc0c0c000000000c000ccc01cc0c0c000001cc0c0000000c0001cc0cc10c0c0000ccc00ccc001111111111011111111110111111111101111111111
11001000111010100000000010001110011010100000011010000000100001101100101000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000cccc00001111111111011111111110111111111101111111111
0cc0c0000cc00cc0ccc00000c0000cc00cc0c0c00000ccc0ccc00000ccc0c0c0c000c00000000111100001111111111011111111110111111111101111111111
c110c000c1c0c110c1100000c000c1c0c1c0c0c00000c1c01c100000c1c0c0c0c000c00000000000000001111111111011111111110111111111101111111111
c000c000c0c0ccc0cc000000c000c0c0c0c0cc10ccc0ccc00c000000ccc0c0c0c000c00000000000000000000000000000000000000000000000000000000000
c000c000c0c011c0c1000000c000c0c0c0c0c1c01110c1c00c000000c110c0c0c000c00000000000000000000000000000000000000000000000000000000000
1cc0ccc0cc10cc10ccc00000ccc0cc10cc10c0c00000c0c00c000000c0001cc0ccc0ccc000000000000001111111111011111111110111111111101111111111
01101110110011001110000011101100110010100000101001000000100001101110111000000cccc00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c11c00001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00001111111111011111111110111111111101111111111
0cc0ccc0c0c0ccc000000000aaa0aaa0a000a0a00000aaa00aa00000c0c00cc0ccc00000000ccc00ccc001111111111011111111110111111111101111111111
c1101c10c0c0c110000000001a10a1a0a000a0a000001a10a1a00000c0c0c110c11000000001c1001c1001111111111011111111110111111111101111111111
c0000c00c0c0cc00000000000a00aaa0a000aa10aaa00a00a0a00000c0c0ccc0cc00000000001c00c10001111111111011111111110111111111101111111111
c0c00c00ccc0c100000000000a00a1a0a000a1a011100a00a0a00000c0c011c0c1000000000001cc100001111111111011111111110111111111101111111111
ccc0ccc01c10ccc0000000000a00a0a0aaa0a0a000000a00aa1000001cc0cc10ccc0000000000011000001111111111011111111110111111111101111111111
11101110010011100000000001001010111010100000010011000000011011001110000000000000000001111111111011111111110111111111101111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010100000000000000010000000000010101010100000000000100000000000101010101000000000000000000000001010101010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
464646474747474747474747474646465656564848484848484848484848484848484848485656560000005e0000a1a2a2a2a2a2a2a2a2a2a2a2a2a20000005e46464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
46464647000047474747474747464646565656484848484848488485858548484848484848565656006e0000006eb184b4b4b484b3b2b184b4b484b400006e0046464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
46004647000047474747474747460046560056a5a5a5a5a5a5a594a4a495a5a5a5a5a5a5a5560056576f6f6f6f6fb1a4b4b4b4a4b3b2b1a4b4b4a4b46f6f6f6f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
460046a0a0a0a0a1a2a3a0a0a0460046560056a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7560056577f7f7f7f7fa2b4b4b4b4b4b3b2b1b4b4b4b4b47f7f7f7f46004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
460046b0b0b0b0b1b2b3b0b0b0460046560056b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b756005654545454545454545454545454545454545454545454545446004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404656415171717171717171717171717171717171717161415654547b585858585858585858737373585858587c5454545446405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
50707070645454545454547470707060517171717171717171717171717171717171717171717161547b787676767676ce76767676767676767676797c54545450707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
707070707070707070707070707070707171717171717171717171717171717171717171717171717b78767676767676767676767676767676767676797c545470707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
0000000000000000006e00000000006e0000005e00006e0000005f00a1a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3005f005e4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
006e00000000000000000000005e0000006e00000000005e00005f6eb184b184b184b3008eb184b384b384b3005f6e004646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
0000006e0000000000000000000000006e000000006e0000006e5f00b1a4b1a4b1a4b3009eb1a4b3a4b3a4b36e5f00004600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
0000000000000000000000000000000000006e00000000006e004500a2a2a2a2a2a2b300aeb1a2a2a2a2a2a30000006e4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
000000000000000000000000000000007e7e7e7e7e7e7e7e7e7e5a7070707070707070647470707070707070704a7e7e4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
00000000000000000000000000006e0054545454545454545454575757575757575773737373575757575757575754544640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
00000000005e0000006e00000000000054545454545454545454545454545454545373737373635454545454545454545070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
6e0000000000000000006e000000000054545454545454545454545454545454545454545454545454545454545454547070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046
4640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
4646465656565656565656565646464646464648484848484848484848464646464646565656565656565656564646464646464848484848484848484846464646464656565656565656565656464646464646484848484848484848484646464646465656565656565656565646464646464648484848484848484848464646
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4600465656565656565656565646004646004648484848484848484848460046460046565656565656565656564600464600464848484848484848484846004646004656565656565656565656460046460046484848484848484848484600464600465656565656565656565646004646004648484848484848484848460046
4640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046464050707070707070707070706040464640507070707070707070707060404646405070707070707070707070604046
5070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060507070707070707070707070707070605070707070707070707070707070706050707070707070707070707070707060
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
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

