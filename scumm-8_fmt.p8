pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
show_debuginfo=false show_collision=false show_perfinfo=false enable_mouse=true a=printh verbs={{{b="open"},text="open"},{{c="close"},text="close"},{{d="give"},text="give"},{{e="pickup"},text="pick-up"},{{f="lookat"},text="look-at"},{{g="talkto"},text="talk-to"},{{i="push"},text="push"},{{j="pull"},text="pull"},{{k="use"},text="use"}} verb_default={{l="walkto"},text="walk to"} verb_maincol=12 verb_hovcol=7 verb_shadcol=1 verb_defcol=10 state_closed=1 state_open=2 state_off=1 state_on=2 state_gone=1 state_here=2 class_untouchable=1 class_pickupable=2 class_talkable=4 class_giveable=8 class_openable=16 class_actor=32 cut_noverbs=1 cut_hidecursor=2 cut_no_follow=4 face_front=1 face_left=2 face_back=3 face_right=4 pos_infront=1 pos_behind=3 pos_left=2 pos_right=4 pos_inside=5 anim_face=1 rooms={m={map_x=0,map_y=0,col_replace={{7,15},},enter=function(n) start_script(n.scripts.o,true) end,exit=function(n) stop_script(n.scripts.o) end,lighting=0,scripts={o=function() while true do for p=1,3 do set_state("fire",p) break_time(8) end end end,q=function() r=-1 while true do for x=1,3 do for p=1,3 do set_state("spinning top",p) break_time(4) end s=find_object("spinning top") s.x-=r end r*=-1 end end},objects={t={name="fire",state=1,x=8*8,y=4*8,states={145,146,147},w=1,h=1,dependent_on="front door",dependent_on_state=state_open,verbs={f=function() say_line("it's a nice, warm fire...") wait_for_message() break_time(10) do_anim(selected_actor,anim_face,face_front) say_line("ouch! it's hot!;*stupid fire*") wait_for_message() end,g=function() say_line("'hi fire...'") wait_for_message() break_time(10) do_anim(selected_actor,anim_face,face_front) say_line("the fire didn't say hello back;burn!!") wait_for_message() end,e=function(n) pickup_obj(n) end,}},u={name="front door",class=class_openable,state=state_closed,x=1*8,y=2*8,elevation=-10,states={143,0},w=1,h=4,use_pos=pos_right,use_dir=face_left,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.v.objects.u) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.v.objects.u) end,c=function(n) close_door(n,rooms.v.objects.u) end}},z={name="kitchen",state=state_open,x=14*8,y=2*8,w=1,h=4,use_pos=pos_left,use_dir=face_right,verbs={l=function() come_out_door(rooms.ba.objects.bb) end}},bc={name="bucket",class=class_pickupable,state=state_open,x=13*8,y=6*8,w=1,h=1,states={207,223},trans_col=15,verbs={f=function(n) if owner_of(n)==selected_actor then
say_line("it is a bucket in my pocket") else say_line("it is a bucket") end end,e=function(n) pickup_obj(n) end,d=function(n,bd) if bd==actors.be then
say_line("can you fill this up for me?") wait_for_message() say_line(actors.be,"sure") wait_for_message() n.owner=actors.be break_time(30) say_line(actors.be,"here ya go...") wait_for_message() n.state=state_closed n.name="full bucket"pickup_obj(n) else say_line("i might need this") end end}},bf={name="spinning top",state=1,x=2*8,y=6*8,states={192,193,194},col_replace={{12,7}},trans_col=15,w=1,h=1,verbs={i=function(n) if script_running(room_curr.scripts.q) then
stop_script(room_curr.scripts.q) set_state(n,1) else start_script(room_curr.scripts.q) end end,j=function(n) stop_script(room_curr.scripts.q) set_state(n,1) end}},bg={name="window",class=class_openable,state=state_closed,use_pos={x=5*8,y=(7*8)+1},x=4*8,y=1*8,w=2,h=2,states={132,134},verbs={b=function(n) if not n.bh then
cutscene(cut_noverbs+cut_hidecursor,function() n.bh=true print_line("*bang*",40,20,8,1) set_state(n,state_open) wait_for_message() change_room(rooms.ba,1) selected_actor=actors.be walk_to(selected_actor,selected_actor.x+10,selected_actor.y) say_line("what was that?!") wait_for_message() say_line("i'd better check...") wait_for_message() walk_to(selected_actor,selected_actor.x-10,selected_actor.y) change_room(rooms.m,1) break_time(50) put_actor_at(selected_actor,115,44,rooms.m) walk_to(selected_actor,selected_actor.x-10,selected_actor.y) say_line("intruder!!!") do_anim(actors.bi,anim_face,actors.be) wait_for_message() end,function() change_room(rooms.m) put_actor_at(actors.be,105,44,rooms.m) stop_talking() do_anim(actors.bi,anim_face,actors.be) end) end end}}}},ba={map_x=16,map_y=0,map_x1=39,map_y1=7,enter=function() end,exit=function() end,scripts={},objects={bb={name="hall",state=state_open,x=1*8,y=2*8,w=1,h=4,use_pos=pos_right,use_dir=face_left,verbs={l=function() come_out_door(rooms.m.objects.z) end}},bj={name="back door",class=class_openable,state=state_closed,x=22*8,y=2*8,elevation=-10,states={143,0},flip_x=true,w=1,h=4,use_pos=pos_left,use_dir=face_right,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.m.objects.u) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.m.objects.u) end,c=function(n) close_door(n,rooms.m.objects.u) end}},},},v={map_x=16,map_y=8,map_x1=47,map_y1=15,enter=function(n) if not n.bk then
n.bk=true selected_actor=actors.bi put_actor_at(selected_actor,144,36,rooms.v) camera_follow(selected_actor) cutscene(cut_noverbs+cut_hidecursor,function() camera_at(0) camera_pan_to(selected_actor) wait_for_camera() say_line("let's do this") wait_for_message() end) end end,exit=function(n) end,scripts={},objects={bl={class=class_untouchable,x=10*8,y=3*8,state=1,states={111},w=1,h=2,repeat_x=8},bm={class=class_untouchable,x=22*8,y=3*8,state=1,states={111},w=1,h=2,repeat_x=8},u={name="front door",class=class_openable,state=state_closed,x=19*8,y=1*8,states={142,0},flip_x=true,w=1,h=3,use_dir=face_back,verbs={l=function(n) if state_of(n)==state_open then
come_out_door(rooms.m.objects.u) else say_line("the door is closed") end end,b=function(n) open_door(n,rooms.m.objects.u) end,c=function(n) close_door(n,rooms.m.objects.u) end}},},}} actors={bi={class=class_actor,w=1,h=4,face_dir=face_front,idle={1,3,5,3},talk={6,22,21,22},walk_anim={2,3,4,3},col=12,trans_col=11,speed=0.6,},be={name="purple tentacle",class=class_talkable+class_actor,x=127/2-24,y=127/2-16,w=1,h=3,face_dir=face_front,idle={30,30,30,30},talk={47,47,47,47},col=13,trans_col=15,speed=0.25,use_pos=pos_left,in_room=rooms.ba,verbs={f=function() say_line("it's a weird looking tentacle, thing!") end,g=function(n) cutscene(cut_noverbs,function() say_line(n,"what do you want?") wait_for_message() end) while(true) do dialog_add("where am i?") dialog_add("who are you?") dialog_add("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?") dialog_add("nevermind") dialog_start(selected_actor.col,7) while not selected_sentence do break_time() end dialog_hide() cutscene(cut_noverbs,function() say_line(selected_sentence.msg) wait_for_message() if selected_sentence.num==1 then
say_line(n,"you are in paul's game") wait_for_message() elseif selected_sentence.num==2 then say_line(n,"it's complicated...") wait_for_message() elseif selected_sentence.num==3 then say_line(n,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!") wait_for_message() elseif selected_sentence.num==4 then say_line(n,"ok bye!") wait_for_message() dialog_end() return end end) dialog_clear() end end}}} function startup_script() change_room(rooms.v,1) end function find_default_verb(bn) local bo=nil if has_flag(bn.class,class_talkable) then
bo="talkto"elseif has_flag(bn.class,class_openable) then if bn.state==state_closed then
bo="open"else bo="close"end else bo="lookat"end for bp in all(verbs) do bq=get_verb(bp) if bq[2]==bo then bo=bp break end
end return bo end function unsupported_action(br,bs,bt) if br=="walkto"then
return elseif br=="pickup"then if has_flag(bs.class,class_actor) then
say_line("i don't need them") else say_line("i don't need that") end elseif br=="use"then if has_flag(bs.class,class_actor) then
say_line("i can't just *use* someone") end if bt then
if has_flag(bt.class,class_actor) then
say_line("i can't use that on someone!") else say_line("that doesn't work") end end elseif br=="give"then if has_flag(bs.class,class_actor) then
say_line("i don't think i should be giving this away") else say_line("i can't do that") end elseif br=="lookat"then if has_flag(bs.class,class_actor) then
say_line("i think it's alive") else say_line("looks pretty ordinary") end elseif br=="open"then if has_flag(bs.class,class_actor) then
say_line("they don't seem to open") else say_line("it doesn't seem to open") end elseif br=="close"then if has_flag(bs.class,class_actor) then
say_line(bu"they don't seem to close") else say_line("it doesn't seem to close") end elseif br=="push"or br=="pull"then if has_flag(bs.class,class_actor) then
say_line("moving them would accomplish nothing") else say_line("it won't budge!") end elseif br=="talkto"then if has_flag(bs.class,class_actor) then
say_line("erm... i don't think they want to talk") else say_line("i am not talking to that!") end else say_line("hmm. no.") end end 


function camera_at(bv) if type(bv)=="table"then
bv=bv.x end bw=mid(0,bv-64,(room_curr.bx*8)-by-1) bz=nil ca=nil end function camera_follow(cb) ca=cb bz=nil cc=function() while ca do bw=mid(0,ca.x-64,(room_curr.bx*8)-by-1) yield() end end start_script(cc,true) end function camera_pan_to(bv) if type(bv)=="table"then
x=bv.x end bz=x ca=nil cc=function() while(true) do cd=bw+flr(by/2)+1 if cd==bz then
bz=nil return elseif bz>cd then bw+=0.5 else bw-=0.5 end bw=mid(0,bw,(room_curr.bx*8)-by-1) yield() end end start_script(cc,true) end function wait_for_camera() while script_running(cc) do yield() end end function cutscene(ce,cf,cg) ch={ce=ce,ci=cocreate(cf),cj=cg,ck=room_curr,cl=selected_actor,cm=ca} add(cn,ch) co=ch break_time() end function dialog_add(msg) if not cp then cp={cq={},cr=false} end
cs=ct(msg,32) cu=cv(cs) cw={num=#cp.cq+1,msg=msg,cs=cs,cx=cu} add(cp.cq,cw) end function dialog_start(col,cy) cp.col=col cp.cy=cy cp.cr=true selected_sentence=nil end function dialog_hide() cp.cr=false end function dialog_clear() cp.cq={} selected_sentence=nil end function dialog_end() cp=nil end function get_use_pos(bn) cz=bn.use_pos if type(cz)=="table"then
x=cz.x-bw y=cz.y-da elseif not cz or cz==pos_infront then x=bn.x+((bn.w*8)/2)-bw-4 y=bn.y+(bn.h*8)+2 elseif cz==pos_left then if bn.db then
x=bn.x-bw-(bn.w*8+4) y=bn.y+1 else x=bn.x-bw-2 y=bn.y+((bn.h*8)-2) end elseif cz==pos_right then x=bn.x+(bn.w*8)-bw y=bn.y+((bn.h*8)-2) end return{x=x,y=y} end function do_anim(cb,dc,dd) if dc==anim_face then
if type(dd)=="table"then
de=atan2(cb.x-dd.x,dd.y-cb.y) df=93*(3.1415/180) de=df-de dg=de*(1130.938/3.1415) dg=dg%360 if(dg<0) then dg+=360 end
dd=4-flr(dg/90) end while cb.face_dir!=dd do if cb.face_dir<dd then
cb.face_dir+=1 else cb.face_dir-=1 end cb.flip=(cb.face_dir==face_left) break_time(10) end end end function open_door(dh,di) if state_of(dh)==state_open then
say_line("it's already open") else set_state(dh,state_open) if di then set_state(di,state_open) end
end end function close_door(dh,di) if state_of(dh)==state_closed then
say_line("it's already closed") else set_state(dh,state_closed) if di then set_state(di,state_closed) end
end end function come_out_door(dj,dk) dl=dj.in_room bw=0 change_room(dl,dk) dm=get_use_pos(dj) put_actor_at(selected_actor,dm.x,dm.y,dl) if dj.use_dir then
dn=dj.use_dir+2 if dn>4 then
dn-=4 end else dn=1 end selected_actor.face_dir=dn end function fades(dp,r) if r==1 then
dq=0 else dq=50 end while true do dq+=r*2 if dq>50
or dq<0 then return end if dp==1 then
dr=min(dq,32) end yield() end end function change_room(dl,dp) if dp and room_curr then
fades(dp,1) end if room_curr and room_curr.exit then
room_curr.exit(room_curr) end ds={} dt() room_curr=dl stop_talking() if dp then
start_script(function() fades(dp,-1) end,true) else dr=0 end if room_curr.enter then
room_curr.enter(room_curr) end end function valid_verb(br,du) if not du then return false end
if not du.verbs then return false end
if type(br)=="table"then
if du.verbs[br[1]] then return true end
else if du.verbs[br] then return true end
end return false end function pickup_obj(dv) bn=find_object(dv) if bn
then add(selected_actor.dw,bn) bn.owner=selected_actor del(bn.in_room.objects,bn) end end function owner_of(dv) bn=find_object(dv) if bn then
return bn.owner end end function state_of(dv,state) bn=find_object(dv) if bn then
return bn.state end end function set_state(dv,state) bn=find_object(dv) if bn then
bn.state=state end end function find_object(name) if type(name)=="table"then return name end
for dx,bn in pairs(room_curr.objects) do if bn.name==name then return bn end
end end function start_script(dy,dz,ea,bd) local ci=cocreate(dy) if dz then
add(eb,{dy,ci,ea,bd}) else add(ds,{dy,ci,ea,bd}) end end function script_running(dy) for dx,ec in pairs(ds) do if(ec[1]==dy) then
return ec end end for dx,ec in pairs(eb) do if(ec[1]==dy) then
return ec end end return false end function stop_script(dy) ec=script_running(dy) if ec then
del(ds,ec) del(eb,ec) end end function break_time(ed) ed=ed or 1 for x=1,ed do yield() end end function wait_for_message() while ee!=nil do yield() end end function say_line(cb,msg) if type(cb)=="string"then
msg=cb cb=selected_actor end ef=cb.y-(cb.h)*8+4 eg=cb print_line(msg,cb.x,ef,cb.col,1) end function stop_talking() ee=nil eg=nil end function print_line(msg,x,y,col,eh) local col=col or 7 local eh=eh or 0 local cs={} local ei=""local ej=""cu=0 ek=min(x-bw,by-(x-bw)) el=max(flr(ek/2),16) ej=""for em=1,#msg do ei=sub(msg,em,em) if ei==";"then
ej=sub(msg,em+1) msg=sub(msg,1,em-1) break end end cs=ct(msg,el,true) cu=cv(cs) if eh==1 then
en=x-bw-((cu*4)/2) end en=max(2,en) ef=max(18,y) en=min(en,by-(cu*4)-1) ee={eo=cs,x=en,y=ef,col=col,eh=eh,ep=(#msg)*8,cx=cu} if(#ej>0) then
eq=eg wait_for_message() eg=eq print_line(ej,x,y,col,eh) end end function put_actor_at(cb,x,y,er) if er then cb.in_room=er end
cb.x=x cb.y=y end function walk_to(cb,x,y) x=x+bw es=et(cb) eu=flr(x/8)+room_curr.map_x ev=flr(y/8)+room_curr.map_y ew={eu,ev} ex=ey(es,ew) ez=et({x=x,y=y}) if fa(ez[1],ez[2]) then
add(ex,ez) end for fb in all(ex) do fc=(fb[1]-room_curr.map_x)*8+4 fd=(fb[2]-room_curr.map_y)*8+4 local fe=sqrt((fc-cb.x)^2+(fd-cb.y)^2) local ff=cb.speed*(fc-cb.x)/fe local fg=cb.speed*(fd-cb.y)/fe if fe>1 then
cb.fh=1 cb.flip=(ff<0) cb.face_dir=face_right if(cb.flip) then cb.face_dir=face_left end
for em=0,fe/cb.speed do cb.x=cb.x+ff cb.y=cb.y+fg yield() end end end cb.fh=2 end by=127 fi=127 da=16 bw=0 bz=nil cc=nil fj=by/2 fk=fi/2 fl=0 fm={7,12,13,13,12,7} fn=1 fo={{spr=16,x=75,y=da+60},{spr=48,x=75,y=da+72}} fp=0 fq=0 fr=false room_curr=nil fs=nil ft=nil fu=nil fv=""fw=false ee=nil cp=nil co=nil eg=nil dr=0 eb={} ds={} cn={} fx={} function _init() if enable_mouse then poke(0x5f2d,1) end
fy() start_script(startup_script,true) end function _update60() fz() end function _draw() ga() end function fz() if selected_actor and selected_actor.ci and not coresume(selected_actor.ci) then
selected_actor.ci=nil end gb(eb) if co then
if co.ci and not coresume(co.ci) then
if(room_curr!=co.ck) then change_room(co.ck) end
selected_actor=co.cl camera_follow(co.cm) del(cn,co) co=nil if#cn>0 then
co=cn[#cn] end end else gb(ds) end gc() gd() end function ga() rectfill(0,0,by,fi,0) camera(bw,0) clip(0+dr,da+dr,by+1-dr*2,64-dr*2) ge() camera(0,0) clip() if show_perfinfo then
print("cpu: "..flr(100*stat(1)).."%",0,da-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,da-8,8) end if show_debuginfo then
print("x: "..fj.." y:"..fk-da,80,da-8,8) end gf() if cp and cp.cr then
gg() gh() return end if gi==co then
else gi=co return end if not co then
gj() end if(not co
or not has_flag(co.ce,cut_noverbs)) and(gi==co) then gk() else end gi=co if not co then
gh() end end function gc() if co then
if btnp(4) and btnp(5) and co.cj then
co.ci=cocreate(co.cj) co.cj=nil return end return end if btn(0) then fj-=1 end
if btn(1) then fj+=1 end
if btn(2) then fk-=1 end
if btn(3) then fk+=1 end
if btnp(4) then gl(1) end
if btnp(5) then gl(2) end
if enable_mouse then
if stat(32)-1!=fp then fj=stat(32)-1 end
if stat(33)-1!=fq then fk=stat(33)-1 end
if stat(34)>0 then
if not fr then
gl(stat(34)) fr=true end else fr=false end fp=stat(32)-1 fq=stat(33)-1 end fj=max(fj,0) fj=min(fj,127) fk=max(fk,0) fk=min(fk,127) end function gl(gm) local gn=fs if cp and cp.cr then
if go then
selected_sentence=go end return end if gp then
fs=get_verb(gp) elseif gq then if gm==1 then
if(fs[2]=="use"or fs[2]=="give")
and ft then fu=gq else ft=gq end elseif gr then fs=get_verb(gr) ft=gq gs(ft) gj() end elseif gt then if gt==fo[1] then
if selected_actor.gu>0 then
selected_actor.gu-=1 end else if selected_actor.gu+2<flr(#selected_actor.dw/4) then
selected_actor.gu+=1 end end return end if(ft!=nil) then
if fs[2]=="use"or fs[2]=="give"then
if fu then
else return end end fw=true selected_actor.ci=cocreate(function(cb,bn,br,bd) if not bn.owner then
gv=get_use_pos(bn) walk_to(selected_actor,gv.x,gv.y) if selected_actor.fh!=2 then return end
use_dir=bn if bn.use_dir and br!=verb_default then use_dir=bn.use_dir end
do_anim(selected_actor,anim_face,use_dir) end if valid_verb(br,bn) then
start_script(bn.verbs[br[1]],false,bn,bd) else unsupported_action(br[2],bn,bd) end dt() end) coresume(selected_actor.ci,selected_actor,ft,fs,fu) elseif(fk>da and fk<da+64) then fw=true selected_actor.ci=cocreate(function(x,y) walk_to(selected_actor,x,y) dt() end) coresume(selected_actor.ci,fj,fk-da) end end function gd() gp=nil gr=nil gq=nil go=nil gt=nil if cp and cp.cr then
for bu in all(cp.cq) do if gw(bu) then
go=bu end end return end gx() for dx,bn in pairs(room_curr.objects) do if(not bn.class
or(bn.class and bn.class!=class_untouchable)) and(not bn.dependent_on or find_object(bn.dependent_on).state==bn.dependent_on_state) then gy(bn,bn.w*8,bn.h*8,bw,gz) else bn.ha=nil end if gw(bn) then
gq=bn end hb(bn) end for dx,cb in pairs(actors) do if cb.in_room==room_curr then
gy(cb,cb.w*8,cb.h*8,bw,gz) hb(cb) if gw(cb)
and cb!=selected_actor then gq=cb end end end for bp in all(verbs) do if gw(bp) then
gp=bp end end for hc in all(fo) do if gw(hc) then
gt=hc end end for dx,bn in pairs(selected_actor.dw) do if gw(bn) then
gq=bn if fs[2]=="pickup"and gq.owner then
fs=nil end end if bn.owner!=selected_actor then
del(selected_actor.dw,bn) end end if fs==nil then
fs=get_verb(verb_default) end if gq then
gr=find_default_verb(gq) end end function gx() fx={} for x=1,64 do fx[x]={} end end function hb(bn) ef=-1 if bn.hd then
ef=bn.y else ef=bn.y+(bn.h*8) end he=flr(ef-da) if bn.elevation then he+=bn.elevation end
add(fx[he],bn) end function ge() hf(room_curr) map(room_curr.map_x,room_curr.map_y,0,da,room_curr.bx,room_curr.hg) pal() for hh=1,64 do he=fx[hh] for bn in all(he) do if not has_flag(bn.class,class_actor) then
if(bn.states)
and bn.states[bn.state] and(bn.states[bn.state]>0) and(not bn.dependent_on or find_object(bn.dependent_on).state==bn.dependent_on_state) and not bn.owner then hi(bn) end else if(bn.in_room==room_curr) then
hj(bn) end end hk(bn) end end end function hf(bn) for hl in all(bn.col_replace) do pal(hl[1],hl[2]) end end function hi(bn) hf(bn) hm=1 if bn.repeat_x then hm=bn.repeat_x end
for h=0,hm-1 do hn(bn.states[bn.state],bn.x+(h*(bn.w*8)),bn.y,bn.w,bn.h,bn.trans_col,bn.flip_x) end pal() end function hj(cb) if cb.fh==1
and cb.walk_anim then cb.ho+=1 if cb.ho>5 then
cb.ho=1 cb.hp+=1 if cb.hp>#cb.walk_anim then cb.hp=1 end
end hq=cb.walk_anim[cb.hp] else hq=cb.idle[cb.face_dir] end hf(cb) hn(hq,cb.db,cb.hd,cb.w,cb.h,cb.trans_col,cb.flip,false) if eg
and eg==cb then if cb.hr<7 then
hq=cb.talk[cb.face_dir] hn(hq,cb.db,cb.hd+8,1,1,cb.trans_col,cb.flip,false) end cb.hr+=1 if cb.hr>14 then cb.hr=1 end
end pal() end function gj() hs=""ht=12 if not fw then
if fs then
hs=fs[3] end if ft then
hs=hs.." "..ft.name if fs[2]=="use"then
hs=hs.." with"elseif fs[2]=="give"then hs=hs.." to"end end if fu then
hs=hs.." "..fu.name elseif gq and gq.name!=""and(not ft or(ft!=gq)) then hs=hs.." "..gq.name end fv=hs else hs=fv ht=7 end print(hu(hs),hv(hs),da+66,ht) end function gf() if ee then
hw=0 for hx in all(ee.eo) do hy=0 if ee.eh==1 then
hy=((ee.cx*4)-(#hx*4))/2 end hz(hx,ee.x+hy,ee.y+hw,ee.col) hw+=6 end ee.ep-=1 if(ee.ep<=0) then
stop_talking() end end end function gk() en=0 ef=75 ia=0 for bp in all(verbs) do ib=verb_maincol if gr
and(bp==gr) then ib=verb_defcol end if bp==gp then ib=verb_hovcol end
bq=get_verb(bp) print(bq[3],en,ef+da+1,verb_shadcol) print(bq[3],en,ef+da,ib) bp.x=en bp.y=ef gy(bp,#bq[3]*4,5,0,0) hk(bp) if#bq[3]>ia then ia=#bq[3] end
ef=ef+8 if ef>=95 then
ef=75 en=en+(ia+1.0)*4 ia=0 end end en=86 ef=76 ic=selected_actor.gu*4 id=min(ic+8,#selected_actor.dw) for ie=1,8 do rectfill(en-1,da+ef-1,en+8,da+ef+8,1) bn=selected_actor.dw[ic+ie] if bn then
bn.x=en bn.y=ef hi(bn) gy(bn,bn.w*8,bn.h*8,0,0) hk(bn) end en+=11 if en>=125 then
ef+=12 en=86 end ie+=1 end for em=1,2 do ig=fo[em] if gt==ig then pal(verb_maincol,7) end
hn(ig.spr,ig.x,ig.y,1,1,0) gy(ig,8,7,0,0) hk(ig) pal() end end function gg() en=0 ef=70 for bu in all(cp.cq) do bu.x=en bu.y=ef gy(bu,bu.cx*4,#bu.cs*5,0,0) ib=cp.col if bu==go then ib=cp.cy end
for hx in all(bu.cs) do print(hu(hx),en,ef+da,ib) ef+=5 end hk(bu) ef+=2 end end function gh() col=fm[fn] pal(7,col) spr(32,fj-4,fk-3,1,1,0) pal() fl+=1 if fl>7 then
fl=1 fn+=1 if(fn>#fm) then fn=1 end
end end function hn(ih,x,y,w,h,ii,flip_x,ij) palt(0,false) palt(ii,true) spr(ih,x,da+y,w,h,flip_x,ij) pal() end function fy() for ik,er in pairs(rooms) do if er.map_x1 then
er.bx=er.map_x1-er.map_x+1 er.hg=er.map_y1-er.map_y+1 else er.bx=16 er.hg=8 end for il,bn in pairs(er.objects) do bn.in_room=er end end for im,cb in pairs(actors) do cb.fh=2 cb.ho=1 cb.hr=1 cb.hp=1 cb.dw={} cb.gu=0 end end function hk(bn) if show_collision and bn.ha then
rect(bn.ha.x,bn.ha.y,bn.ha.io,bn.ha.ip,8) end end function gb(scripts) for ec in all(scripts) do if ec[2] and not coresume(ec[2],ec[3],ec[4]) then
del(scripts,ec) ec=nil end end end function iq(x,y) eu=flr(x/8)+room_curr.map_x ev=flr(y/8)+room_curr.map_y ir=fa(eu,ev) return ir end function et(bn) eu=flr(bn.x/8)+room_curr.map_x ev=flr(bn.y/8)+room_curr.map_y return{eu,ev} end function fa(eu,ev) is=mget(eu,ev) ir=fget(is,0) return ir end function gs(bn) it={} for dx,bp in pairs(bn) do add(it,dx) end return it end function get_verb(bn) br={} it=gs(bn[1]) add(br,it[1]) add(br,bn[1][it[1]]) add(br,bn.text) return br end function ct(msg,el,iu) local cs={} local iv=""local iw=""local ei=""local ix=function(iy) if#iw+#iv>iy then
add(cs,iv) iv=""end iv=iv..iw iw=""end for em=1,#msg do ei=sub(msg,em,em) iw=iw..ei if(ei==" ")
or(#iw>el-1) then ix(el) elseif#iw>el-1 then iw=iw.."-"ix(el) elseif ei==","and iu then iv=iv..sub(iw,1,#iw-1) iw=""ix(0) end end ix(el) if iv!=""then
add(cs,iv) end return cs end function cv(cs) cu=0 for hx in all(cs) do if#hx>cu then cu=#hx end
end return cu end function has_flag(bn,iz) if band(bn,iz)!=0 then return true end
return false end function dt() fs=get_verb(verb_default) ft=nil fu=nil n=nil fw=false fv=""end function gy(bn,w,h,ja,jb) x=bn.x y=bn.y if has_flag(bn.class,class_actor) then
bn.db=bn.x-(bn.w*8)/2 bn.hd=bn.y-(bn.h*8)+1 x=bn.db y=bn.hd end bn.ha={x=x,y=y+da,io=x+w-1,ip=y+h+da-1,ja=ja,jb=jb} end function ey(jc,jd) je={} jf(je,jc,0) jg={} jg[jh(jc)]=nil ji={} ji[jh(jc)]=0 while#je>0 and#je<1000 do local s=je[#je] del(je,je[#je]) jj=s[1] if jh(jj)==jh(jd) then
break end local jk={} for x=-1,1 do for y=-1,1 do if x==0 and y==0 then
else jl=jj[1]+x jm=jj[2]+y if abs(x)!=abs(y) then jn=1 else jn=1.4 end
if jl>=room_curr.map_x and jl<=room_curr.map_x+room_curr.bx
and jm>=room_curr.map_y and jm<=room_curr.map_y+room_curr.hg and fa(jl,jm) and((abs(x)!=abs(y)) or fa(jl,jj[2]) or fa(jl-x,jm)) then add(jk,{jl,jm,jn}) end end end end for jo in all(jk) do local jp=jh(jo) local jq=ji[jh(jj)]+jo[3] if(ji[jp]==nil) or(jq<ji[jp]) then
ji[jp]=jq local jr=jq+max(abs(jd[1]-jo[1]),abs(jd[2]-jo[2])) jf(je,jo,jr) jg[jp]=jj end end end ex={} jj=jg[jh(jd)] if jj then
local js=jh(jj) local jt=jh(jc) while js!=jt do add(ex,jj) jj=jg[js] js=jh(jj) end for em=1,#ex/2 do local ju=ex[em] local jv=#ex-(em-1) ex[em]=ex[jv] ex[jv]=ju end end return ex end function jf(jw,bv,fb) if#jw>=1 then
add(jw,{}) for em=(#jw),2,-1 do local jo=jw[em-1] if fb<jo[2] then
jw[em]={bv,fb} return else jw[em]=jo end end jw[1]={bv,fb} else add(jw,{bv,fb}) end end function jh(jx) return((jx[1]+1)*16)+jx[2] end function hz(jy,x,y,jz,ka) local jz=jz or 7 local ka=ka or 0 jy=hu(jy) for kb=-1,1 do for kc=-1,1 do print(jy,x+kb,y+kc,ka) end end print(jy,x,y,jz) end function hv(bu) return(by/2)-flr((#bu*4)/2) end function kd(bu) return(fi/2)-flr(5/2) end function gw(bn) if not bn.ha then return false end
ha=bn.ha if(fj+ha.ja>ha.io or fj+ha.ja<ha.x)
or(fk>ha.ip or fk<ha.y) then return false else return true end end function hu(bu) local a=""local hx,hl,jw=false,false for em=1,#bu do local hc=sub(bu,em,em) if hc=="^"then
if(hl) then a=a..hc end
hl=not hl elseif hc=="~"then if(jw) then a=a..hc end
jw,hx=not jw,not hx else if hl==hx and hc>="a"and hc<="z"then
for ke=1,26 do if hc==sub("abcdefghijklmnopqrstuvwxyz",ke,ke) then
hc=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",ke,ke) break end end end a=a..hc hl,jw=false,false end end return a end


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
77777755666666ddbbbbbbee33333355333333330000000066666666588885880000000000000000000000550000000000000000000000000000000000045000
777755556666ddddbbbbeeee33333355333333330000000066666666588885880000000000000000000055550000000000000000000000000000000000045000
7755555566ddddddbbeeeeee33336666333333330000000066666666555555550000000000000000005555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee33336666333333330000000066666666888588880000000000000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee3355555533333333000000006666666688858888000000000000000055555555000000000000000000000000001c7c1000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666555555550000000000000000555555550000000000000000000000000000c00000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885880000000000000000555555550000000000000000000000000000100000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885880000000000000000555555550000000000000000000000000000000000045000
55777777dd666666eebbbbbb55333333555555550000000000000000000000000000000000000000000000000000000000000000000000000000000099999999
55557777dddd6666eeeebbbb55333333555533330000000000000000000000000000000000000000000000000000000000000000000000000000000044444444
55555577dddddd66eeeeeebb66663333553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee6666333353333333000000000000000000000000000000000000000000000000000000000000000000000000000c000000045000
55555555ddddddddeeeeeeee55555533533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee55555533553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555533330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333355550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333333550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333333350000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333333350000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb55555555333333550000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddbbbbbbbb66666666333355550000000000000000000000000000000000000000000000000000000000000000000000000b03000099999999
55555555ddddddddbbbbbbbb6666666655555555000000000000000000000000000000000000000000000000000000000000000000000000b00030b055555555
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
444949440dd6dd600000000056dd6d5000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f444494
444949440dd6dd650000000056dd6d5000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f444994
4449494406666665000000005666665000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f499444
444949440d6dd6d5000000005d6dd65000000000000000004449444444449444000000000000000000000000000000000000000000000000000000004f944444
444949440d6dd6d5000000005d6dd650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000044444400
44494944066666650000000056666650000000000000000044494444444494440000000000000000000000000000000000000000000000000000000044440000
999949990dd6dd650000000056dd6d50000000000000000044499999999994440000000000000000000000000000000000000000000000000000000044000000
444444440dd6dd650000000056dd6d50000000000000000044444444444444440000000000000000000000000000000000000000000000000000000000000000
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666677f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007cccccc7
bbbcccc8888bbbbcccc8888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d776666d
fccccc8ffbbbbbcff88888bf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
fccc888ffbbbcccff888bbbf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff7665ff
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
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
8aaaaaa88cccccc8822222288bbbbbb8899999988eeeeee88dddddd8866666688111111885555558877777788ffffff883333338844444488dddddd880000008
8a8aa8a88c8cc8c8828228288b8bb8b8898998988e8ee8e88d8dd8d8868668688181181885855858878778788f8ff8f883833838848448488d8dd8d880800808
8aa88aa88cc88cc8822882288bb88bb8899889988ee88ee88dd88dd8866886688118811885588558877887788ff88ff883388338844884488dd88dd880088008
8aa88aa88cc88cc8822882288bb88bb8899889988ee88ee88dd88dd8866886688118811885588558877887788ff88ff883388338844884488dd88dd880088008
8a8aa8a88c8cc8c8828228288b8bb8b8898998988e8ee8e88d8dd8d8868668688181181885855858878778788f8ff8f883833838848448488d8dd8d880800808
8aaaaaa88cccccc8822222288bbbbbb8899999988eeeeee88dddddd8866666688111111885555558877777788ffffff883333338844444488dddddd880000008
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
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
4646464747474747474747474746464656565648484848484848484848484848484848484856565600000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4646464700004747474747474746464656565648484848484848848585854848484848484856565600000000000000004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
46004647000047474747474747460046560056a5a5a5a5a5a5a594a4a495a5a5a5a5a5a5a556005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
460046a0a0a0a0a1a2a3a0a0a0460046560056a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a7a6a756005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
460046b0b0b0b0b1b2b3b0b0b0460046560056b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b7b6b756005600000000000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4640507070707070707070707060404656415171717171717171717171717171717171717161415600000000000000004454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
5070707064545454545454747070706051717171717171717171717171717171717171717171716100000000000000006470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707071717171717171717171717171717171717171717171717100000000000000007070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
444444494949494949494949494949490000005e00006e0000005f00a1a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3005f005e4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44444449494949494949494949494949006e00000000005e00005f6eb184b184b184b3008eb184b384b384b3005f6e004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
440044494949494949494949494949496e000000006e0000006e5f00b1a4b1a4b1a4b3009eb1a4b3a4b3a4b36e5f00004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494949494900006e00000000006e004500a2a2a2a2a2a2b300aeb1a2a2a2a2a2a30000006e4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044494949494949494949494949497e7e7e7e7e7e7e7e7e7e5a7070707070707070647470707070707070704a7e7e4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707070707054545454545454545454575757575757575773737373575757575757575754544454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707054545454545454545454545454545454545373737373635454545454545454546470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707054545454545454545454545454545454545454545454545454545454545454547070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
4454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444445464707070707070707070707454444454647070707070707070707074544444546470707070707070707070745444
6470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074647070707070707070707070707070746470707070707070707070707070707464707070707070707070707070707074
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

