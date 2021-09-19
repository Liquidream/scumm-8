
-->8
-- scumm-8 core engine

-- ############################
--    you should not need to 
--  modify anything below here
-- ############################

function shake(bc)
bd,be=bc,bc and 1 or be
end
function bf(bg)
local bh="lookat"
if has_flag(bg.classes,"class_talkable") then
bh="talkto"
elseif has_flag(bg.classes,"class_openable") then
if bg.state=="state_closed"then
bh="open"
else
bh="close"
end
end
for bi in all(verbs) do
bj=get_verb(bi)
if bj[2]==bh then bh=bi break end
end
return bh
end
function bk(bl,bm,bn)
local bo=has_flag(bm.classes,"class_actor")
if bl=="walkto"then
return
elseif bl=="pickup"then
say_line(bo and"i don't need them"or"i don't need that")
elseif bl=="use"then
say_line(bo and"i can't just *use* someone"or
((bn and has_flag(bn.classes,class_actor)) and"i can't use that on someone!"or"that doesn't work"))
elseif bl=="give"then
say_line(bo and"i don't think i should be giving this away"or"i can't do that")
elseif bl=="lookat"then
say_line(bo and"i think it's alive"or"looks pretty ordinary")
elseif bl=="open"or bl=="close"then
say_line((bo and"they don't"or"it doesn't").." seem to "..bl)
elseif bl=="push"or bl=="pull"then
say_line(bo and"moving them would accomplish nothing"or"it won't budge!")
elseif bl=="talkto"then
say_line(bo and"erm ...  i don't think they want to talk"or"i am not talking to that!")
else
say_line"hmm. no."
end
end
function camera_at(bp)
cam_x,bq,br=bs(bp)
end
function camera_follow(bt)
stop_script(bu)
br,bq=bt
bu=function()
while br do
if(br.in_room==room_curr) cam_x=bs(br)
yield()
end
end
start_script(bu,true)
if(br.in_room!=room_curr) change_room(br.in_room,1)
end
function camera_pan_to(bp)
bq,br=bs(bp)
bu=function()
while cam_x~=bq do
cam_x+=sgn(bq-cam_x)/2
yield()
end
bq=nil
end
start_script(bu,true)
end
function wait_for_camera()
while script_running(bu) do
yield()
end
end
function cutscene(type,bv,bw)
bx={
by=type,
bz=cocreate(bv),
ca=bw,
cb=br
}
add(cc,bx)
ce=bx
break_time()
end
function dialog_set(cf)
for msg in all(cf) do
dialog_add(msg)
end
end
function dialog_add(msg)
cg=cg or{ch={}}
ci=cj(msg,32)
ck=cl(ci)
cm={
num=#cg.ch+1,
msg=msg,
ci=ci,
cn=ck
}
add(cg.ch,cm)
end
function dialog_start(col,co)
cg.col=col
cg.co=co
cg.cp=true
selected_sentence=nil
end
function dialog_hide()
cg.cp=false
end
function dialog_clear()
cg.ch={}
selected_sentence=nil
end
function dialog_end()
cg=nil
end
function get_use_pos(bg)
local cq,y,x=bg.use_pos or"pos_infront",bg.y,bg.x
if cr(cq) then
x,y=cq[1],cq[2]
else
local cs={
pos_left={-2,bg.h*8-2},
pos_right={bg.w*8,bg.h*8-2},
pos_above={bg.w*4-4,-2},
pos_center={bg.w*4,bg.h*4-4},
pos_infront={bg.w*4-4,bg.h*8+2}
}
if cq=="pos_left"and bg.ct then
x-=(bg.w*8+4)
y+=1
else
x+=cs[cq][1]
y+=cs[cq][2]
end
end
return{x=x,y=y}
end
function do_anim(cu,cv,cw)
if cv=="face_towards"then
if cr(cw) then
cx=atan2(cu.x-cw.x,cw.y-cu.y)
cy=93*(3.1415/180)
cx=cy-cx
cz=(cx*360)%360
cw=4-flr(cz/90)
cw=da[cw]
end
face_dir=da[cu.face_dir]
cw=da[cw]
while face_dir!=cw do
if face_dir<cw then
face_dir+=1
else
face_dir-=1
end
cu.face_dir=da[face_dir]
cu.flip=(cu.face_dir=="face_left")
break_time(10)
end
else
cu.curr_anim=cv
cu.db=1
cu.dc=1
end
end
function open_door(dd,de)
if dd.state=="state_open"then
say_line"it's already open"
else
dd.state="state_open"
if(de) de.state="state_open"
end
end
function close_door(dd,de)
if dd.state=="state_closed"then
say_line"it's already closed"
else
dd.state="state_closed"
if(de) de.state="state_closed"
end
end
function come_out_door(df,dg,dh)
if(dg==nil) di("target door does not exist") return
if(df.state~="state_open") say_line("the door is closed") return
dj=dg.in_room
if(dj!=room_curr) change_room(dj,dh)
local dk=get_use_pos(dg)
put_at(selected_actor,dk.x,dk.y,dj)
if dg.use_dir then
dl=da[(da[dg.use_dir]+1)%4+1]
else
dl="face_front"
end
selected_actor.face_dir=dl
selected_actor.flip=(selected_actor.face_dir=="face_left")
end
dm={
open=open_door,
close=close_door,
walkto=come_out_door
}
function fades(dn,dir)
local dp=25-25*dir
while true do
dp+=dir*2
if dp>50
or dp<0 then
return
end
if(dn==1) dq=min(dp,32)
yield()
end
end
function change_room(dj,dn)
if(not dj) di("room does not exist") return
stop_script(dr)
if dn and room_curr then
fades(dn,1)
end
if(room_curr and room_curr.exit) room_curr.exit(room_curr)
ds={}
dt()
room_curr=dj
if(not br or br.in_room!=room_curr) cam_x=0
stop_talking()
if dn then
dr=function()
fades(dn,-1)
end
start_script(dr,true)
else
dq=0
end
if room_curr.enter then
room_curr.enter(room_curr)
end
end
function valid_verb(bl,du)
if(not du or not du.verbs) return false
if cr(bl) then
if(du.verbs[bl[1]]) return true
else
if(du.verbs[bl]) return true
end
end
function pickup_obj(bg,bt)
bt=bt or selected_actor
add(bt.dv,bg)
bg.owner=bt
del(bg.in_room.objects,bg)
end
function start_script(dw,dx,dy,q)
local bz=cocreate(dw)
add(dx and dz or ds,{dw,bz,dy,q})
end
function script_running(dw)
for ea in all({ds,dz}) do
for eb,ec in pairs(ea) do
if ec[1]==dw then
return ec
end
end
end
end
function stop_script(dw)
ec=script_running(dw)
del(ds,ec)
del(dz,ec)
end
function break_time(ed)
for x=1,ed or 1 do
yield()
end
end
function wait_for_message()
while ee do
yield()
end
end
function say_line(bt,msg,ef,eg)
if type(bt)=="string"then
msg,bt=bt,selected_actor
end
eh=bt
print_line(msg,bt.x,bt.y-bt.h*8+4,bt.col,1,ef,eg)
end
function stop_talking()
ee,eh=nil
end
function print_line(msg,x,y,col,ei,ef,eg,ej)
col=col or 7
ei=ei or 0
local ek=127-(x-cam_x)
if(ei==1) ek=min(x-cam_x,ek)
local el=max(flr(ek/2),16)
local em=""
for en=1,#msg do
local eo=sub(msg,en,en)
if eo==":"then
em=sub(msg,en+1)
msg=sub(msg,1,en-1)
break
end
end
local ci=cj(msg,el)
local ck=cl(ci)
ep=x-cam_x
if(ei==1) ep-=ck*(ej and 4 or 2)
local ep,eq=max(2,ep),max(18,y)
ep=min(ep,127-(ck*4)-1)
ee={
er=ci,
x=ep,
y=eq,
col=col,
ei=ei,
es=eg or#msg*8,
cn=ck,
ef=ef,
ej=ej
}
if#em>0 then
et=eh
wait_for_message()
eh=et
print_line(em,x,y,col,ei,ef,nil,ej)
end
wait_for_message()
end
function put_at(bg,x,y,eu)
if eu then
if not has_flag(bg.classes,"class_actor") then
if(bg.in_room) del(bg.in_room.objects,bg)
add(eu.objects,bg)
bg.owner=nil
end
bg.in_room=eu
end
bg.x,bg.y=x,y
end
function stop_actor(bt)
bt.ev,bt.curr_anim=0
dt()
end
function walk_to(bt,x,y)
local ew=ex(bt)
local ey,ez=flr(x/8)+room_curr.map[1],flr(y/8)+room_curr.map[2]
local fa={ey,ez}
local fb=fc(ew,fa,{x,y})
bt.ev=1
for fd=1,#fb do
local fe=fb[fd]
local ff=bt.walk_speed*(bt.scale or bt.fg)
local fh,fi=(fe[1]-room_curr.map[1])*8+4,(fe[2]-room_curr.map[2])*8+4
if(fd==#fb and x>=fh-4 and x<=fh+4 and y>=fi-4 and y<=fi+4) fh,fi=x,y
local fj=sqrt((fh-bt.x)^2+(fi-bt.y)^2)
local fk=ff*(fh-bt.x)/fj
local fl=ff*(fi-bt.y)/fj
if fj>0 then
for en=0,fj/ff-1 do
if bt.ev==0 then
return
end
bt.flip=fk<0
if abs(fk)<ff/2 then
bt.curr_anim=fl>0 and bt.walk_anim_front or bt.walk_anim_back
bt.face_dir=fl>0 and"face_front"or"face_back"
else
bt.curr_anim=bt.walk_anim_side
bt.face_dir=bt.flip and"face_left"or"face_right"
end
bt.x+=fk
bt.y+=fl
yield()
end
end
end
bt.ev,bt.curr_anim=2
end
function wait_for_actor(bt)
bt=bt or selected_actor
while bt.ev!=2 do
yield()
end
end
function proximity(bm,bn)
return bm.in_room==bn.in_room and sqrt((bm.x-bn.x)^2+(bm.y-bn.y)^2) or 1000
end
stage_top=16
cam_x,be=0,0
fm,fn,fo,fp=63.5,63.5,0,1
fq={
{spr=ui_uparrowspr,x=75,y=stage_top+60},
{spr=ui_dnarrowspr,x=75,y=stage_top+72}
}
da={
"face_front",
"face_left",
"face_back",
"face_right",
face_front=1,
face_left=2,
face_back=3,
face_right=4
}
function fr(bg)
local fs={}
for eb,bi in pairs(bg) do
add(fs,eb)
end
return fs
end
function get_verb(bg)
local bl,fs={},fr(bg[1])
add(bl,fs[1])
add(bl,bg[1][fs[1]])
add(bl,bg.text)
return bl
end
function dt()
ft,fu,fv,fw,fx,j=get_verb(verb_default),false,""
end
dt()
dz={}
ds={}
cc={}
fy={}
dq,dq=0,0
fz=0
function _init()
poke(0x5f2d,1)
ga()
start_script(startup_script,true)
end
function _update60()
if selected_actor and selected_actor.bz
and not coresume(selected_actor.bz) then
selected_actor.bz=nil
end
gb(dz)
if ce then
if ce.bz
and not coresume(ce.bz) then
if ce.by!=3
and ce.cb
then
camera_follow(ce.cb)
selected_actor=ce.cb
end
del(cc,ce)
if#cc>0 then
ce=cc[#cc]
else
if(ce.by!=2) fz=3
ce=nil
end
end
else
gb(ds)
end
gc()
gd()
ge,gf=1.5-rnd(3),1.5-rnd(3)
ge=flr(ge*be)
gf=flr(gf*be)
if(not bd) be=be>0.05 and be*0.90 or 0
end
function _draw()
cls()
camera(cam_x+ge,0+gf)
clip(
0+dq-ge,
stage_top+dq-gf,
128-dq*2-ge,
64-dq*2)
gg()
camera(0,0)
clip()
if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,stage_top-16,8)
print("mem: "..flr(stat(0)/1024*100).."%",0,stage_top-8,8)
print("x: "..flr(fm+cam_x).." y:"..fn-stage_top,80,stage_top-8,8)
end
gh()
if cg
and cg.cp then
gi()
gj()
return
end
if(fz>0) fz-=1 return
if(not ce) gk()
if(not ce
or ce.by==2)
and fz==0 then
gl()
end
if(not ce) gj()
end
function gm()
gn=stat(34)>0
end
function gc()
if ee and not gn and(btnp(4) or stat(34)==1) then
ee.es,gn=0,true
return
end
if ce then
if(btnp(5) or stat(34)==2) and ce.ca then
ce.bz=cocreate(ce.ca)
ce.ca=nil
return
end
gm()
return
end
if btn(0) then fm-=1 end
if btn(1) then fm+=1 end
if btn(2) then fn-=1 end
if btn(3) then fn+=1 end
if btnp(4) then go(1) end
if btnp(5) then go(2) end
gp,gq=stat(32)-1,stat(33)-1
if gp!=gr then fm=gp end
if gq!=gs then fn=gq end
if stat(34)>0 and not gn then
go(stat(34))
end
gr,gs=gp,gq
gm()
end
fm,fn=mid(0,fm,127),mid(0,fn,127)
function go(gt)
if(not selected_actor) return
if cg and cg.cp then
if(gu) selected_sentence=gu
return
end
if(fu) dt()
if gv then
ft,fw,fx=get_verb(gv)
elseif gw then
if gt==1 then
if fw and not fu then
fx=gw
else
fw=gw
end
if(ft[2]==get_verb(verb_default)[2]
and gw.owner) then
ft=get_verb(verbs[verb_default_inventory_index])
end
elseif gx then
ft,fw=get_verb(gx),gw
gk()
end
elseif gy then
if gy==fq[1] then
if(selected_actor.gz>0) selected_actor.gz-=1
else
if selected_actor.gz+2<flr(#selected_actor.dv/4) then
selected_actor.gz+=1
end
end
return
end
local ha=ft[2]
if fw then
if ha=="use"or ha=="give"then
if fx then
elseif fw.use_with and fw.owner==selected_actor then
return
end
end
fu=true
selected_actor.bz=cocreate(function()
if(not fw.owner
and(not has_flag(fw.classes,"class_actor")
or ha!="use"))
or fx
then
hb=fx or fw
hc=get_use_pos(hb)
walk_to(selected_actor,hc.x,hc.y)
if selected_actor.ev!=2 then return end
use_dir=hb
if hb.use_dir then use_dir=hb.use_dir end
do_anim(selected_actor,"face_towards",use_dir)
end
if valid_verb(ft,fw) then
start_script(fw.verbs[ft[1]],false,fw,fx)
else
if has_flag(fw.classes,"class_door") then
local dw=dm[ha]
if(dw) dw(fw,fw.target_door)
else
bk(ha,fw,fx)
end
end
dt()
end)
coresume(selected_actor.bz)
elseif fn>stage_top and fn<stage_top+64 then
fu=true
selected_actor.bz=cocreate(function()
walk_to(selected_actor,fm+cam_x,fn-stage_top)
dt()
end)
coresume(selected_actor.bz)
end
end
function gd()
if(not room_curr) return
gv,gx,gw,gu,gy=nil
if cg and cg.cp then
for ea in all(cg.ch) do
if(hd(ea)) gu=ea
end
return
end
he()
for bg in all(room_curr.objects) do
if(not bg.classes
or(bg.classes and not has_flag(bg.classes,"class_untouchable")))
and(not bg.dependent_on
or bg.dependent_on.state==bg.dependent_on_state)
then
hf(bg,bg.w*8,bg.h*8,cam_x,hg)
else
bg.hh=nil
end
if hd(bg) then
if not gw
or max(bg.z,gw.z)==bg.z
then
gw=bg
end
end
hi(bg)
end
for eb,bt in pairs(actors) do
if bt.in_room==room_curr then
hf(bt,bt.w*8,bt.h*8,cam_x,hg)
hi(bt)
if(hd(bt) and bt!=selected_actor) gw=bt
end
end
if selected_actor then
for bi in all(verbs) do
if(hd(bi)) gv=bi
end
for hj in all(fq) do
if(hd(hj)) gy=hj
end
for eb,bg in pairs(selected_actor.dv) do
if hd(bg) then
gw=bg
if(ft[2]=="pickup"and gw.owner) ft=nil
end
if(bg.owner!=selected_actor) del(selected_actor.dv,bg)
end
ft=ft or get_verb(verb_default)
gx=gw and bf(gw) or gx
end
end
function he()
for x=-64,64 do
fy[x]={}
end
end
function hi(bg)
add(fy[bg.z and bg.z or flr(bg.y+(bg.hk and 0 or bg.h*8))],bg)
end
function gg()
if not room_curr then
print("-error-  no current room set",5+cam_x,5+stage_top,8,0)
return
end
rectfill(0,stage_top,127,stage_top+64,room_curr.hl or 0)
for z=-64,64 do
if z==0 then
hm(room_curr)
if room_curr.trans_col then
palt(0,false)
palt(room_curr.trans_col,true)
end
map(room_curr.map[1],room_curr.map[2],0,stage_top,room_curr.hn,room_curr.ho)
pal()
else
hp=fy[z]
for bg in all(hp) do
if not has_flag(bg.classes,"class_actor") then
if bg.states
or(bg.state
and bg[bg.state]
and bg[bg.state]>0)
and(not bg.dependent_on
or bg.dependent_on.state==bg.dependent_on_state)
and not bg.owner
or bg.draw
or bg.curr_anim
then
hq(bg)
end
else
if(bg.in_room==room_curr) hr(bg)
end
end
end
end
end
function hm(bg)
if bg.col_replace then
fd=bg.col_replace
pal(fd[1],fd[2])
end
if bg.lighting then
hs(bg.lighting)
elseif bg.in_room and bg.in_room.lighting then
hs(bg.in_room.lighting)
end
end
function hq(bg)
local ht=0
hm(bg)
if bg.draw then
bg.draw(bg)
else
if bg.curr_anim then
hu(bg)
ht=bg.curr_anim[bg.db]
end
for h=0,bg.repeat_x and bg.repeat_x-1 or 0 do
if bg.states then
ht=bg.states[bg.state]
elseif ht==0 then
ht=bg[bg.state]
end
hv(ht,bg.x+(h*(bg.w*8)),bg.y,bg.w,bg.h,bg.trans_col,bg.flip_x,bg.scale)
end
end
pal()
end
function hr(bt)
local hw,ht=da[bt.face_dir]
if bt.curr_anim
and(bt.ev==1 or cr(bt.curr_anim))
then
hu(bt)
ht=bt.curr_anim[bt.db]
else
ht=bt.idle[hw]
end
hm(bt)
local hx=(bt.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1])
hx=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*hx
bt.fg=mid(room_curr.autodepth_scale[1],hx,room_curr.autodepth_scale[2])
local scale=bt.scale or bt.fg
local hy,hz=(8*bt.h),(8*bt.w)
local ia=hy-(hy*scale)
local ib=hz-(hz*scale)
local ic=bt.ct+flr(ib/2)
local id=bt.hk+ia
hv(ht,
ic,
id,
bt.w,
bt.h,
bt.trans_col,
bt.flip,
false,
scale)
if eh
and eh==bt
and eh.talk
then
if bt.ie<7 then
hv(bt.talk[hw],
ic+(bt.talk[5] or 0),
id+flr((bt.talk[6] or 8)*scale),
(bt.talk[7] or 1),
(bt.talk[8] or 1),
bt.trans_col,
bt.flip,
false,
scale)
end
bt.ie=bt.ie%14+1
end
pal()
end
function gk()
local ig,ih,ii=verb_maincol,ft[2],ft and ft[3] or""
if fw then
ii=ii.." "..fw.name
if ih=="use"and(not fu or fx) then
ii=ii.." with"
elseif ih=="give"then
ii=ii.." to"
end
end
if fx then
ii=ii.." "..fx.name
elseif gw
and gw.name!=""
and(not fw or(fw!=gw))
and not fu
then
if gw.owner
and ih==get_verb(verb_default)[2] then
ii="look-at"
end
ii=ii.." "..gw.name
end
fv=ii
if fu then
ii=fv
ig=verb_hovcol
end
print(ij(ii),63.5-flr(#ii*2),stage_top+66,ig)
end
function gh()
if ee then
local ik=0
for il in all(ee.er) do
local im=0
if ee.ei==1 then
im=((ee.cn*4)-(#il*4))/2
end
outline_text(
il,
ee.x+im,
ee.y+ik,
ee.col,
0,
ee.ef,
ee.ej)
ik+=ee.ej and 12 or 6
end
ee.es-=1
if(ee.es<=0) stop_talking()
end
end
function gl()
local ep,eq,io=0,75,0
for bi in all(verbs) do
local ip=bi==gv and verb_hovcol or
(gx and bi==gx and verb_defcol or
verb_maincol)
local bj=get_verb(bi)
print(bj[3],ep,eq+stage_top+1,verb_shadcol)
print(bj[3],ep,eq+stage_top,ip)
bi.x=ep
bi.y=eq
hf(bi,#bj[3]*4,5,0,0)
if(#bj[3]>io) io=#bj[3]
eq+=8
if eq>=95 then
eq=75
ep+=(io+1.0)*4
io=0
end
end
if selected_actor then
ep,eq=86,76
local iq=selected_actor.gz*4
local ir=min(iq+8,#selected_actor.dv)
for is=1,8 do
rectfill(ep-1,stage_top+eq-1,ep+8,stage_top+eq+8,verb_shadcol)
bg=selected_actor.dv[iq+is]
if bg then
bg.x,bg.y=ep,eq
hq(bg)
hf(bg,bg.w*8,bg.h*8,0,0)
end
ep+=11
if ep>=125 then
eq+=12
ep=86
end
is+=1
end
for en=1,2 do
it=fq[en]
pal(7,gy==it and verb_hovcol or verb_maincol)
pal(5,verb_shadcol)
hv(it.spr,it.x,it.y,1,1,0)
hf(it,8,7,0,0)
pal()
end
end
end
function gi()
local ep,eq=0,70
for ea in all(cg.ch) do
if ea.cn>0 then
ea.x,ea.y=ep,eq
hf(ea,ea.cn*4,#ea.ci*5,0,0)
local ip=ea==gu and cg.co or cg.col
for il in all(ea.ci) do
print(ij(il),ep,eq+stage_top,ip)
eq+=5
end
eq+=2
end
end
end
function gj()
col=ui_cursor_cols[fp]
pal(7,col)
spr(ui_cursorspr,fm-4,fn-3,1,1,0)
pal()
fo+=1
if fo>7 then
fo=1
fp=fp%#ui_cursor_cols+1
end
end
function hv(iu,x,y,w,h,iv,flip_x,iw,scale)
set_trans_col(iv)
iu=iu or 0
local ix,iy=8*(iu%16),8*flr(iu/16)
local iz,ja=8*w,8*h
local jb=scale or 1
local jc,jd=iz*jb,ja*jb
sspr(ix,iy,iz,ja,x,stage_top+y,jc,jd,flip_x,iw)
end
function set_trans_col(iv)
palt(0,false)
palt(iv,true)
end
function ga()
for eu in all(rooms) do
je(eu)
eu.hn=#eu.map>2 and eu.map[3]-eu.map[1]+1 or 16
eu.ho=#eu.map>2 and eu.map[4]-eu.map[2]+1 or 8
eu.autodepth_pos=eu.autodepth_pos or{9,50}
eu.autodepth_scale=eu.autodepth_scale or{0.25,1}
for bg in all(eu.objects) do
je(bg)
bg.in_room,bg.h=eu,bg.h or 0
if(bg.init) bg.init(bg)
end
end
for jf,bt in pairs(actors) do
je(bt)
bt.ev=2
bt.dc=1
bt.ie=1
bt.db=1
bt.dv={
}
bt.gz=0
end
end
function gb(scripts)
for ec in all(scripts) do
if ec[2] and not coresume(ec[2],ec[3],ec[4]) then
del(scripts,ec)
end
end
end
function hs(jg)
if(jg) jg=1-jg
local fe=flr(mid(0,jg,1)*100)
local jh={0,1,1,2,1,13,6,
4,4,9,3,13,1,13,14}
for ji=1,15 do
col=ji
jj=(fe+(ji*1.46))/22
for eb=1,jj do
col=jh[col]
end
pal(ji,col)
end
end
function cr(t)
return type(t)=="table"
end
function bs(bp)
return mid(0,(cr(bp) and bp.x or bp)-64,(room_curr.hn*8)-128)
end
function ex(bg)
return{flr(bg.x/8)+room_curr.map[1],flr(bg.y/8)+room_curr.map[2]}
end
function jk(ey,ez)
return fget(mget(ey,ez),0)
end
function cj(msg,el)
local ci,jl,jm,eo={},"","",""
local function jn(jo)
if#jm+#jl>jo then
add(ci,jl)
jl=""
end
jl=jl..jm
jm=""
end
for en=1,#msg do
eo=sub(msg,en,en)
jm=jm..eo
if eo==" "or#jm>el-1 then
jn(el)
elseif#jm>el-1 then
jm=jm.."-"
jn(el)
elseif eo==";"then
jl=jl..sub(jm,1,#jm-1)
jm=""
jn(0)
end
end
jn(el)
if(jl!="") add(ci,jl)
return ci
end
function cl(ci)
local ck=0
for il in all(ci) do
if(#il>ck) ck=#il
end
return ck
end
function has_flag(bg,jp)
for jq in all(bg) do
if(jq==jp) return true
end
end
function hf(bg,w,h,jr,js)
local x,y=bg.x,bg.y
if has_flag(bg.classes,"class_actor") then
bg.ct=x-(bg.w*8)/2
bg.hk=y-(bg.h*8)+1
x=bg.ct
y=bg.hk
end
bg.hh={
x=x,
y=y+stage_top,
jt=x+w-1,
ju=y+h+stage_top-1,
jr=jr,
js=js
}
end
function fc(jv,jw)
local jx,jy,jz,ka,kb,kc={},{},{}
kd(jx,jv,0)
jz[ke(jv)]=0
while#jx>0 and#jx<1000 do
kc=jx[#jx][1]
del(jx,jx[#jx])
if(ke(kc)==ke(jw)) break
local kf={}
for x=-1,1 do
for y=-1,1,x==0 and 2 or 1 do
local kg,kh=kc[1]+x,kc[2]+y
if kg>=room_curr.map[1] and kg<=room_curr.map[1]+room_curr.hn
and kh>=room_curr.map[2] and kh<=room_curr.map[2]+room_curr.ho
and jk(kg,kh)
and((abs(x)!=abs(y))
or jk(kg,kc[2])
or jk(kg-x,kh)
or enable_diag_squeeze)
then
local ki={kg,kh}
local kj=ke(ki)
local kk=jz[ke(kc)]+(x*y==0 and 1 or 1.414)
if not jz[kj] or kk<jz[kj] then
jz[kj]=kk
local h=max(abs(jw[1]-kg),abs(jw[2]-kh))+min(abs(jw[1]-kg),abs(jw[2]-kh))*.414
kd(jx,ki,kk+h)
jy[kj]=kc
if not ka or h<ka then
ka=h
kb=kj
kl=ki
end
end
end
end
end
end
local fb={}
kc=jy[ke(jw)]
if kc then
add(fb,jw)
elseif kb then
kc=jy[kb]
add(fb,kl)
end
if kc then
local km,kn=ke(kc),ke(jv)
while km!=kn do
add(fb,kc)
kc=jy[km]
km=ke(kc)
end
for en=1,#fb/2 do
local ko=fb[en]
local kp=#fb-(en-1)
fb[en]=fb[kp]
fb[kp]=ko
end
end
return fb
end
function kd(t,bp,fe)
local kq={bp,fe}
if#t>=1 then
for en=#t+1,2,-1 do
local ki=t[en-1]
if fe<ki[2] then
t[en]=kq
return
else
t[en]=ki
end
end
end
t[1]=kq
end
function ke(kr)
return((kr[1]+1)*16)+kr[2]
end
function hu(bg)
bg.dc+=1
if bg.dc>bg.frame_delay then
bg.dc=1
bg.db=bg.db%#bg.curr_anim+1
end
end
function di(msg)
print_line("-error-;"..msg,5+cam_x,5,8,0)
end
function je(bg)
for il in all(split(bg.data,"\n")) do
local pairs=split(il,"=")
if#pairs==2 then
bg[pairs[1]]=ks(pairs[2])
else
printh(" > invalid data: ["..pairs[1].."]")
end
end
end
function split(ea,kt)
local ku,iq,kv={},0,0
for en=1,#ea do
local kw=sub(ea,en,en)
if kw==kt then
add(ku,sub(ea,iq,kv))
iq,kv=0,0
elseif kw!=" "
and kw!="\t"then
kv,iq=en,iq==0 and en or iq
end
end
if iq+kv>0 then
add(ku,sub(ea,iq,kv))
end
return ku
end
function ks(kx)
local ky=sub(kx,1,1)
if kx=="true"then
return true
elseif kx=="false"then
return false
elseif tonum(kx) then
return tonum(kx)
elseif ky=="{"then
local ko=sub(kx,2,#kx-1)
kz={}
for bp in all(split(ko,",")) do
add(kz,ks(bp))
end
return kz
else
return kx
end
end
function outline_text(la,x,y,lb,lc,ef,ej)
if(not ef) la=ij(la)
if(ej) la="\^w\^t"..la
for ld=-1,1 do
for le=-1,1,ld==0 and 2 or 1 do
print(la,x+ld,y+le,lc)
end
end
print(la,x,y,lb)
end
function hd(bg)
if(not bg.hh or ce) return false
local hh=bg.hh
return not((fm+hh.jr>hh.jt or fm+hh.jr<hh.x)
or(fn>hh.ju or fn<hh.y))
end
function ij(ea)
local t=""
for en=1,#ea do
local fd=ord(ea,en)
t..=chr(fd>96 and fd<123 and fd-32 or fd)
end
return t
end
