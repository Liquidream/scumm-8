
-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


function shake(bk)
if bk then
bl=1
end
bm=bk
end
function bn(bo)
local bp=nil
if has_flag(bo.classes,"class_talkable") then
bp="talkto"
elseif has_flag(bo.classes,"class_openable") then
if bo.state=="state_closed"then
bp="open"
else
bp="close"
end
else
bp="lookat"
end
for bq in all(verbs) do
br=get_verb(bq)
if br[2]==bp then bp=bq break end
end
return bp
end
function bs(bt,bu,bv)
local bw=has_flag(bu.classes,"class_actor")
if bt=="walkto"then
return
elseif bt=="pickup"then
if bw then
say_line"i don't need them"
else
say_line"i don't need that"
end
elseif bt=="use"then
if bw then
say_line"i can't just *use* someone"
end
if bv then
if has_flag(bv.classes,class_actor) then
say_line"i can't use that on someone!"
else
say_line"that doesn't work"
end
end
elseif bt=="give"then
if bw then
say_line"i don't think i should be giving this away"
else
say_line"i can't do that"
end
elseif bt=="lookat"then
if bw then
say_line"i think it's alive"
else
say_line"looks pretty ordinary"
end
elseif bt=="open"then
if bw then
say_line"they don't seem to open"
else
say_line"it doesn't seem to open"
end
elseif bt=="close"then
if bw then
say_line"they don't seem to close"
else
say_line"it doesn't seem to close"
end
elseif bt=="push"or bt=="pull"then
if bw then
say_line"moving them would accomplish nothing"
else
say_line"it won't budge!"
end
elseif bt=="talkto"then
if bw then
say_line"erm... i don't think they want to talk"
else
say_line"i am not talking to that!"
end
else
say_line"hmm. no."
end
end
function camera_at(bx)
cam_x=by(bx)
bz=nil
ca=nil
end
function camera_follow(cb)
stop_script(cc)
ca=cb
bz=nil
cc=function()
while ca do
if ca.in_room==room_curr then
cam_x=by(ca)
end
yield()
end
end
start_script(cc,true)
if ca.in_room!=room_curr then
change_room(ca.in_room,1)
end
end
function camera_pan_to(bx)
bz=by(bx)
ca=nil
cc=function()
while(true) do
if cam_x==bz then
bz=nil
return
elseif bz>cam_x then
cam_x+=0.5
else
cam_x-=0.5
end
yield()
end
end
start_script(cc,true)
end
function wait_for_camera()
while script_running(cc) do
yield()
end
end
function cutscene(type,cd,ce)
cf={
cg=type,
ch=cocreate(cd),
ci=ce,
cj=ca
}
add(ck,cf)
cl=cf
break_time()
end
function dialog_set(cm)
for msg in all(cm) do
dialog_add(msg)
end
end
function dialog_add(msg)
if not cn then cn={co={},cp=false} end
cq=cr(msg,32)
cs=ct(cq)
cu={
num=#cn.co+1,
msg=msg,
cq=cq,
cv=cs
}
add(cn.co,cu)
end
function dialog_start(col,cw)
cn.col=col
cn.cw=cw
cn.cp=true
selected_sentence=nil
end
function dialog_hide()
cn.cp=false
end
function dialog_clear()
cn.co={}
selected_sentence=nil
end
function dialog_end()
cn=nil
end
function get_use_pos(bo)
local cx=bo.use_pos
local x=bo.x
local y=bo.y
if type(cx)=="table"then
x=cx[1]
y=cx[2]
elseif cx=="pos_left"then
if bo.cy then
x-=(bo.w*8+4)
y+=1
else
x-=2
y+=((bo.h*8)-2)
end
elseif cx=="pos_right"then
x+=(bo.w*8)
y+=((bo.h*8)-2)
elseif cx=="pos_above"then
x+=((bo.w*8)/2)-4
y-=2
elseif cx=="pos_center"then
x+=((bo.w*8)/2)
y+=((bo.h*8)/2)-4
elseif cx=="pos_infront"
or cx==nil then
x+=((bo.w*8)/2)-4
y+=(bo.h*8)+2
end
return{x=x,y=y}
end
function do_anim(cz,da,db)
if da=="face_towards"then
dc={
"face_front",
"face_left",
"face_back",
"face_right"
}
if type(db)=="table"then
dd=atan2(cz.x-db.x,db.y-cz.y)
de=93*(3.1415/180)
dd=de-dd
df=dd*360
df=df%360
if df<0 then df+=360 end
db=4-flr(df/90)
db=dc[db]
end
face_dir=dg[cz.face_dir]
db=dg[db]
while face_dir!=db do
if face_dir<db then
face_dir+=1
else
face_dir-=1
end
cz.face_dir=dc[face_dir]
cz.flip=(cz.face_dir=="face_left")
break_time(10)
end
else
cz.dh=da
cz.di=1
cz.dj=1
end
end
function open_door(dk,dl)
if dk.state=="state_open"then
say_line"it's already open"
else
dk.state="state_open"
if dl then dl.state="state_open"end
end
end
function close_door(dk,dl)
if dk.state=="state_closed"then
say_line"it's already closed"
else
dk.state="state_closed"
if dl then dl.state="state_closed"end
end
end
function come_out_door(dm,dn,dp)
if dn==nil then
dq("target door does not exist")
return
end
if dm.state=="state_open"then
dr=dn.in_room
if dr!=room_curr then
change_room(dr,dp)
end
local ds=get_use_pos(dn)
put_at(selected_actor,ds.x,ds.y,dr)
dt={
face_front="face_back",
face_left="face_right",
face_back="face_front",
face_right="face_left"
}
if dn.use_dir then
du=dt[dn.use_dir]
else
du=1
end
selected_actor.face_dir=du
selected_actor.flip=(selected_actor.face_dir=="face_left")
else
say_line("the door is closed")
end
end
function fades(dv,dir)
if dir==1 then
dw=0
else
dw=50
end
while true do
dw+=dir*2
if dw>50
or dw<0 then
return
end
if dv==1 then
dx=min(dw,32)
end
yield()
end
end
function change_room(dr,dv)
if dr==nil then
dq("room does not exist")
return
end
stop_script(dy)
if dv and room_curr then
fades(dv,1)
end
if room_curr and room_curr.exit then
room_curr.exit(room_curr)
end
dz={}
ea()
room_curr=dr
if not ca
or ca.in_room!=room_curr then
cam_x=0
end
stop_talking()
if dv then
dy=function()
fades(dv,-1)
end
start_script(dy,true)
else
dx=0
end
if room_curr.enter then
room_curr.enter(room_curr)
end
end
function valid_verb(bt,eb)
if not eb
or not eb.verbs then return false end
if type(bt)=="table"then
if eb.verbs[bt[1]] then return true end
else
if eb.verbs[bt] then return true end
end
return false
end
function pickup_obj(bo,cb)
cb=cb or selected_actor
add(cb.bi,bo)
bo.owner=cb
del(bo.in_room.objects,bo)
end
function start_script(ec,ed,ee,ef)
local ch=cocreate(ec)
local scripts=dz
if ed then
scripts=eg
end
add(scripts,{ec,ch,ee,ef})
end
function script_running(ec)
for eh in all({dz,eg}) do
for ei,ej in pairs(eh) do
if ej[1]==ec then
return ej
end
end
end
return false
end
function stop_script(ec)
ej=script_running(ec)
if ej then
del(dz,ej)
del(eg,ej)
end
end
function break_time(ek)
ek=ek or 1
for x=1,ek do
yield()
end
end
function wait_for_message()
while el!=nil do
yield()
end
end
function say_line(cb,msg,em,en)
if type(cb)=="string"then
msg=cb
cb=selected_actor
end
eo=cb.y-(cb.h)*8+4
ep=cb
print_line(msg,cb.x,eo,cb.col,1,em,en)
end
function stop_talking()
el,ep=nil,nil
end
function print_line(msg,x,y,col,eq,em,en)
local col=col or 7
local eq=eq or 0
if eq==1 then
er=min(x-cam_x,127-(x-cam_x))
else
er=127-(x-cam_x)
end
local es=max(flr(er/2),16)
local et=""
for eu=1,#msg do
local ev=sub(msg,eu,eu)
if ev==":"then
et=sub(msg,eu+1)
msg=sub(msg,1,eu-1)
break
end
end
local cq=cr(msg,es)
local cs=ct(cq)
ew=x-cam_x
if eq==1 then
ew-=((cs*4)/2)
end
ew=max(2,ew)
eo=max(18,y)
ew=min(ew,127-(cs*4)-1)
el={
ex=cq,
x=ew,
y=eo,
col=col,
eq=eq,
ey=en or(#msg)*8,
cv=cs,
em=em
}
if#et>0 then
ez=ep
wait_for_message()
ep=ez
print_line(et,x,y,col,eq,em)
end
wait_for_message()
end
function put_at(bo,x,y,fa)
if fa then
if not has_flag(bo.classes,"class_actor") then
if bo.in_room then del(bo.in_room.objects,bo) end
add(fa.objects,bo)
bo.owner=nil
end
bo.in_room=fa
end
bo.x,bo.y=x,y
end
function stop_actor(cb)
cb.fb=0
cb.dh=nil
ea()
end
function walk_to(cb,x,y)
local fc=fd(cb)
local fe=flr(x/8)+room_curr.map[1]
local ff=flr(y/8)+room_curr.map[2]
local fg={fe,ff}
local fh=fi(fc,fg,{x,y})
cb.fb=1
for fj=1,#fh do
fk=fh[fj]
local fl=cb.walk_speed*(cb.scale or cb.fm)
local fn,fo
fn=(fk[1]-room_curr.map[1])*8+4
fo=(fk[2]-room_curr.map[2])*8+4
if fj==#fh then
if x>=fn-4 and x<=fn+4
and y>=fo-4 and y<=fo+4 then
fn=x
fo=y
end
end
local fp=sqrt((fn-cb.x)^2+(fo-cb.y)^2)
local fq=fl*(fn-cb.x)/fp
local fr=fl*(fo-cb.y)/fp
if cb.fb==0 then
return
end
if fp>0 then
for eu=0,fp/fl-1 do
cb.flip=(fq<0)
if abs(fq)<fl/2 then
if fr>0 then
cb.dh=cb.walk_anim_front
cb.face_dir="face_front"
else
cb.dh=cb.walk_anim_back
cb.face_dir="face_back"
end
else
cb.dh=cb.walk_anim_side
cb.face_dir="face_right"
if cb.flip then cb.face_dir="face_left"end
end
cb.x+=fq
cb.y+=fr
yield()
end
end
end
cb.fb=2
cb.dh=nil
end
function wait_for_actor(cb)
cb=cb or selected_actor
while cb.fb!=2 do
yield()
end
end
function proximity(bu,bv)
if bu.in_room==bv.in_room then
local fp=sqrt((bu.x-bv.x)^2+(bu.y-bv.y)^2)
return fp
else
return 1000
end
end
stage_top=16
cam_x,bz,cc,bl=0,nil,nil,0
fs,ft,fu,fv=63.5,63.5,0,1
fw={
{spr=ui_uparrowspr,x=75,y=stage_top+60},
{spr=ui_dnarrowspr,x=75,y=stage_top+72}
}
dg={
face_front=1,
face_left=2,
face_back=3,
face_right=4
}
function fx(bo)
local fy={}
for ei,bq in pairs(bo) do
add(fy,ei)
end
return fy
end
function get_verb(bo)
local bt={}
local fy=fx(bo[1])
add(bt,fy[1])
add(bt,bo[1][fy[1]])
add(bt,bo.text)
return bt
end
function ea()
fz=get_verb(verb_default)
ga,gb,m,gc,gd=nil,nil,nil,false,""
end
ea()
el=nil
cn=nil
cl=nil
ep=nil
eg={}
dz={}
ck={}
ge={}
dx,dx=0,0
gf=0
function _init()
poke(0x5f2d,1)
gg()
start_script(startup_script,true)
end
function _update60()
gh()
end
function _draw()
gi()
end
function gh()
if selected_actor and selected_actor.ch
and not coresume(selected_actor.ch) then
selected_actor.ch=nil
end
gj(eg)
if cl then
if cl.ch
and not coresume(cl.ch) then
if cl.cg!=3
and cl.cj
then
camera_follow(cl.cj)
selected_actor=cl.cj
end
del(ck,cl)
if#ck>0 then
cl=ck[#ck]
else
if cl.cg!=2 then
gf=3
end
cl=nil
end
end
else
gj(dz)
end
gk()
gl()
gm,gn=1.5-rnd(3),1.5-rnd(3)
gm=flr(gm*bl)
gn=flr(gn*bl)
if not bm then
bl*=0.90
if bl<0.05 then bl=0 end
end
end
function gi()
rectfill(0,0,127,127,0)
camera(cam_x+gm,0+gn)
clip(
0+dx-gm,
stage_top+dx-gn,
128-dx*2-gm,
64-dx*2)
go()
camera(0,0)
clip()
if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,stage_top-16,8)
print("mem: "..flr(stat(0)/1024*100).."%",0,stage_top-8,8)
print("x: "..flr(fs+cam_x).." y:"..ft-stage_top,80,stage_top-8,8)
end
gp()
if cn
and cn.cp then
gq()
gr()
return
end
if gf>0 then
gf-=1
return
end
if not cl then
gs()
end
if(not cl
or cl.cg==2)
and gf==0 then
gt()
end
if not cl then
gr()
end
end
function gu()
if stat(34)>0 then
if not gv then
gv=true
end
else
gv=false
end
end
function gk()
if el and not gv then
if(btnp(4) or stat(34)==1) then
el.ey=0
gv=true
return
end
end
if cl then
if(btnp(5) or stat(34)==2)
and cl.ci then
cl.ch=cocreate(cl.ci)
cl.ci=nil
return
end
gu()
return
end
if btn(0) then fs-=1 end
if btn(1) then fs+=1 end
if btn(2) then ft-=1 end
if btn(3) then ft+=1 end
if btnp(4) then gw(1) end
if btnp(5) then gw(2) end
gx,gy=stat(32)-1,stat(33)-1
if gx!=gz then fs=gx end
if gy!=ha then ft=gy end
if stat(34)>0 and not gv then
gw(stat(34))
end
gz=gx
ha=gy
gu()
end
fs=mid(0,fs,127)
ft=mid(0,ft,127)
function gw(hb)
local hc=fz
if not selected_actor then
return
end
if cn and cn.cp then
if hd then
selected_sentence=hd
end
return
end
if he then
fz=get_verb(he)
ga=nil
gb=nil
elseif hf then
if hb==1 then
if ga then
gb=hf
else
ga=hf
end
if(fz[2]==get_verb(verb_default)[2]
and hf.owner) then
fz=get_verb(verbs[verb_default_inventory_index])
end
elseif hg then
fz=get_verb(hg)
ga=hf
fx(ga)
gs()
end
elseif hh then
if hh==fw[1] then
if selected_actor.hi>0 then
selected_actor.hi-=1
end
else
if selected_actor.hi+2<flr(#selected_actor.bi/4) then
selected_actor.hi+=1
end
end
return
end
if ga!=nil
then
if fz[2]=="use"or fz[2]=="give"then
if gb then
elseif ga.use_with
and ga.owner==selected_actor
then
return
end
end
gc=true
selected_actor.ch=cocreate(function()
if(not ga.owner
and(not has_flag(ga.classes,"class_actor")
or fz[2]!="use"))
or gb
then
hj=gb or ga
hk=get_use_pos(hj)
walk_to(selected_actor,hk.x,hk.y)
if selected_actor.fb!=2 then return end
use_dir=hj
if hj.use_dir then use_dir=hj.use_dir end
do_anim(selected_actor,"face_towards",use_dir)
end
if valid_verb(fz,ga) then
start_script(ga.verbs[fz[1]],false,ga,gb)
else
if has_flag(ga.classes,"class_door") then
if fz[2]=="walkto"then
come_out_door(ga,ga.target_door)
elseif fz[2]=="open"then
open_door(ga,ga.target_door)
elseif fz[2]=="close"then
close_door(ga,ga.target_door)
end
else
bs(fz[2],ga,gb)
end
end
ea()
end)
coresume(selected_actor.ch)
elseif ft>stage_top and ft<stage_top+64 then
gc=true
selected_actor.ch=cocreate(function()
walk_to(selected_actor,fs+cam_x,ft-stage_top)
ea()
end)
coresume(selected_actor.ch)
end
end
function gl()
if not room_curr then
return
end
he,hg,hf,hd,hh=nil,nil,nil,nil,nil
if cn
and cn.cp
then
for eh in all(cn.co) do
if hl(eh) then
hd=eh
end
end
return
end
hm()
for bo in all(room_curr.objects) do
if(not bo.classes
or(bo.classes and not has_flag(bo.classes,"class_untouchable")))
and(not bo.dependent_on
or bo.dependent_on.state==bo.dependent_on_state)
then
hn(bo,bo.w*8,bo.h*8,cam_x,ho)
else
bo.hp=nil
end
if hl(bo) then
if not hf
or(not bo.z and hf.z<0)
or(bo.z and hf.z and bo.z>hf.z)
then
hf=bo
end
end
hq(bo)
end
for ei,cb in pairs(actors) do
if cb.in_room==room_curr then
hn(cb,cb.w*8,cb.h*8,cam_x,ho)
hq(cb)
if hl(cb)
and cb!=selected_actor then
hf=cb
end
end
end
if selected_actor then
for bq in all(verbs) do
if hl(bq) then
he=bq
end
end
for hr in all(fw) do
if hl(hr) then
hh=hr
end
end
for ei,bo in pairs(selected_actor.bi) do
if hl(bo) then
hf=bo
if fz[2]=="pickup"and hf.owner then
fz=nil
end
end
if bo.owner!=selected_actor then
del(selected_actor.bi,bo)
end
end
if fz==nil then
fz=get_verb(verb_default)
end
if hf then
hg=bn(hf)
end
end
end
function hm()
ge={}
for x=-64,64 do
ge[x]={}
end
end
function hq(bo)
eo=-1
if bo.hs then
eo=bo.y
else
eo=bo.y+(bo.h*8)
end
ht=flr(eo)
if bo.z then
ht=bo.z
end
add(ge[ht],bo)
end
function go()
if not room_curr then
print("-error-  no current room set",5+cam_x,5+stage_top,8,0)
return
end
rectfill(0,stage_top,127,stage_top+64,room_curr.hu or 0)
for z=-64,64 do
if z==0 then
hv(room_curr)
if room_curr.trans_col then
palt(0,false)
palt(room_curr.trans_col,true)
end
map(room_curr.map[1],room_curr.map[2],0,stage_top,room_curr.hw,room_curr.hx)
pal()
else
ht=ge[z]
for bo in all(ht) do
if not has_flag(bo.classes,"class_actor") then
if bo.states
or(bo.state
and bo[bo.state]
and bo[bo.state]>0)
and(not bo.dependent_on
or bo.dependent_on.state==bo.dependent_on_state)
and not bo.owner
or bo.draw
or bo.dh
then
hy(bo)
end
else
if bo.in_room==room_curr then
hz(bo)
end
end
end
end
end
end
function hv(bo)
if bo.col_replace then
fj=bo.col_replace
pal(fj[1],fj[2])
end
if bo.lighting then
ia(bo.lighting)
elseif bo.in_room
and bo.in_room.lighting then
ia(bo.in_room.lighting)
end
end
function hy(bo)
local ib=0
hv(bo)
if bo.draw then
bo.draw(bo)
else
if bo.dh then
ic(bo)
ib=bo.dh[bo.di]
end
id=1
if bo.repeat_x then id=bo.repeat_x end
for h=0,id-1 do
if bo.states then
ib=bo.states[bo.state]
elseif ib==0 then
ib=bo[bo.state]
end
ie(ib,bo.x+(h*(bo.w*8)),bo.y,bo.w,bo.h,bo.trans_col,bo.flip_x,bo.scale)
end
end
pal()
end
function hz(cb)
ig=dg[cb.face_dir]
if cb.dh
and(cb.fb==1 or type(cb.dh)=="table")
then
ic(cb)
ib=cb.dh[cb.di]
else
ib=cb.idle[ig]
end
hv(cb)
local ih=(cb.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1])
ih=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*ih
cb.fm=mid(room_curr.autodepth_scale[1],ih,room_curr.autodepth_scale[2])
local scale=cb.scale or cb.fm
local ii=(8*cb.h)
local ij=(8*cb.w)
local ik=ii-(ii*scale)
local il=ij-(ij*scale)
local im=cb.cy+flr(il/2)
local io=cb.hs+ik
ie(ib,
im,
io,
cb.w,
cb.h,
cb.trans_col,
cb.flip,
false,
scale)
if ep
and ep==cb
and ep.talk
then
if cb.ip<7 then
ie(cb.talk[ig],
im+(cb.talk[5] or 0),
io+flr((cb.talk[6] or 8)*scale),
(cb.talk[7] or 1),
(cb.talk[8] or 1),
cb.trans_col,
cb.flip,
false,
scale)
end
cb.ip+=1
if cb.ip>14 then cb.ip=1 end
end
pal()
end
function gs()
iq=""
ir=verb_maincol
is=fz[2]
if fz then
iq=fz[3]
end
if ga then
iq=iq.." "..ga.name
if is=="use"and(not gc or gb) then
iq=iq.." with"
elseif is=="give"then
iq=iq.." to"
end
end
if gb then
iq=iq.." "..gb.name
elseif hf
and hf.name!=""
and(not ga or(ga!=hf))
and not gc
then
if hf.owner
and is==get_verb(verb_default)[2] then
iq="look-at"
end
iq=iq.." "..hf.name
end
gd=iq
if gc then
iq=gd
ir=verb_hovcol
end
print(it(iq),iu(iq),stage_top+66,ir)
end
function gp()
if el then
iv=0
for iw in all(el.ex) do
ix=0
if el.eq==1 then
ix=((el.cv*4)-(#iw*4))/2
end
outline_text(
iw,
el.x+ix,
el.y+iv,
el.col,
0,
el.em)
iv+=6
end
el.ey-=1
if el.ey<=0 then
stop_talking()
end
end
end
function gt()
ew,eo,iy=0,75,0
for bq in all(verbs) do
iz=verb_maincol
if hg
and bq==hg then
iz=verb_defcol
end
if bq==he then iz=verb_hovcol end
br=get_verb(bq)
print(br[3],ew,eo+stage_top+1,verb_shadcol)
print(br[3],ew,eo+stage_top,iz)
bq.x=ew
bq.y=eo
hn(bq,#br[3]*4,5,0,0)
if#br[3]>iy then iy=#br[3] end
eo+=8
if eo>=95 then
eo=75
ew+=(iy+1.0)*4
iy=0
end
end
if selected_actor then
ew,eo=86,76
ja=selected_actor.hi*4
jb=min(ja+8,#selected_actor.bi)
for jc=1,8 do
rectfill(ew-1,stage_top+eo-1,ew+8,stage_top+eo+8,verb_shadcol)
bo=selected_actor.bi[ja+jc]
if bo then
bo.x,bo.y=ew,eo
hy(bo)
hn(bo,bo.w*8,bo.h*8,0,0)
end
ew+=11
if ew>=125 then
eo+=12
ew=86
end
jc+=1
end
for eu=1,2 do
jd=fw[eu]
if hh==jd then
pal(7,verb_hovcol)
else
pal(7,verb_maincol)
end
pal(5,verb_shadcol)
ie(jd.spr,jd.x,jd.y,1,1,0)
hn(jd,8,7,0,0)
pal()
end
end
end
function gq()
ew,eo=0,70
for eh in all(cn.co) do
if eh.cv>0 then
eh.x,eh.y=ew,eo
hn(eh,eh.cv*4,#eh.cq*5,0,0)
iz=cn.col
if eh==hd then iz=cn.cw end
for iw in all(eh.cq) do
print(it(iw),ew,eo+stage_top,iz)
eo+=5
end
eo+=2
end
end
end
function gr()
col=ui_cursor_cols[fv]
pal(7,col)
spr(ui_cursorspr,fs-4,ft-3,1,1,0)
pal()
fu+=1
if fu>7 then
fu=1
fv+=1
if fv>#ui_cursor_cols then fv=1 end
end
end
function ie(je,x,y,w,h,jf,flip_x,jg,scale)
set_trans_col(jf,true)
je=je or 0
local jh=8*(je%16)
local ji=8*flr(je/16)
local jj=8*w
local jk=8*h
local jl=scale or 1
local jm=jj*jl
local jn=jk*jl
sspr(jh,ji,jj,jk,x,stage_top+y,jm,jn,flip_x,jg)
end
function set_trans_col(jf,bk)
palt(0,false)
palt(jf,true)
if jf and jf>0 then
palt(0,false)
end
end
function gg()
for fa in all(rooms) do
jo(fa)
if(#fa.map>2) then
fa.hw=fa.map[3]-fa.map[1]+1
fa.hx=fa.map[4]-fa.map[2]+1
else
fa.hw=16
fa.hx=8
end
fa.autodepth_pos=fa.autodepth_pos or{9,50}
fa.autodepth_scale=fa.autodepth_scale or{0.25,1}
for bo in all(fa.objects) do
jo(bo)
bo.in_room=fa
bo.h=bo.h or 0
if bo.init then
bo.init(bo)
end
end
end
for jp,cb in pairs(actors) do
jo(cb)
cb.fb=2
cb.dj=1
cb.ip=1
cb.di=1
cb.bi={
}
cb.hi=0
end
end
function gj(scripts)
for ej in all(scripts) do
if ej[2] and not coresume(ej[2],ej[3],ej[4]) then
del(scripts,ej)
ej=nil
end
end
end
function ia(jq)
if jq then jq=1-jq end
local fk=flr(mid(0,jq,1)*100)
local jr={0,1,1,2,1,13,6,
4,4,9,3,13,1,13,14}
for js=1,15 do
col=js
jt=(fk+(js*1.46))/22
for ei=1,jt do
col=jr[col]
end
pal(js,col)
end
end
function by(bx)
if type(bx)=="table"then
bx=bx.x
end
return mid(0,bx-64,(room_curr.hw*8)-128)
end
function fd(bo)
local fe=flr(bo.x/8)+room_curr.map[1]
local ff=flr(bo.y/8)+room_curr.map[2]
return{fe,ff}
end
function ju(fe,ff)
local jv=mget(fe,ff)
local jw=fget(jv,0)
return jw
end
function cr(msg,es)
local cq={}
local jx=""
local jy=""
local ev=""
local jz=function(ka)
if#jy+#jx>ka then
add(cq,jx)
jx=""
end
jx=jx..jy
jy=""
end
for eu=1,#msg do
ev=sub(msg,eu,eu)
jy=jy..ev
if ev==" "
or#jy>es-1 then
jz(es)
elseif#jy>es-1 then
jy=jy.."-"
jz(es)
elseif ev==";"then
jx=jx..sub(jy,1,#jy-1)
jy=""
jz(0)
end
end
jz(es)
if jx!=""then
add(cq,jx)
end
return cq
end
function ct(cq)
cs=0
for iw in all(cq) do
if#iw>cs then cs=#iw end
end
return cs
end
function has_flag(bo,kb)
for kc in all(bo) do
if kc==kb then
return true
end
end
return false
end
function hn(bo,w,h,kd,ke)
x=bo.x
y=bo.y
if has_flag(bo.classes,"class_actor") then
bo.cy=x-(bo.w*8)/2
bo.hs=y-(bo.h*8)+1
x=bo.cy
y=bo.hs
end
bo.hp={
x=x,
y=y+stage_top,
kf=x+w-1,
kg=y+h+stage_top-1,
kd=kd,
ke=ke
}
end
function fi(kh,ki)
local kj,kk,kl,km,kn={},{},{},nil,nil
ko(kj,kh,0)
kk[kp(kh)]=nil
kl[kp(kh)]=0
while#kj>0 and#kj<1000 do
local kq=kj[#kj]
del(kj,kj[#kj])
kr=kq[1]
if kp(kr)==kp(ki) then
break
end
local ks={}
for x=-1,1 do
for y=-1,1 do
if x==0 and y==0 then
else
local kt=kr[1]+x
local ku=kr[2]+y
if abs(x)!=abs(y) then kv=1 else kv=1.4 end
if kt>=room_curr.map[1] and kt<=room_curr.map[1]+room_curr.hw
and ku>=room_curr.map[2] and ku<=room_curr.map[2]+room_curr.hx
and ju(kt,ku)
and((abs(x)!=abs(y))
or ju(kt,kr[2])
or ju(kt-x,ku)
or enable_diag_squeeze)
then
add(ks,{kt,ku,kv})
end
end
end
end
for kw in all(ks) do
local kx=kp(kw)
local ky=kl[kp(kr)]+kw[3]
if not kl[kx]
or ky<kl[kx]
then
kl[kx]=ky
local h=max(abs(ki[1]-kw[1]),abs(ki[2]-kw[2]))
local kz=ky+h
ko(kj,kw,kz)
kk[kx]=kr
if not km
or h<km then
km=h
kn=kx
la=kw
end
end
end
end
local fh={}
kr=kk[kp(ki)]
if kr then
add(fh,ki)
elseif kn then
kr=kk[kn]
add(fh,la)
end
if kr then
local lb=kp(kr)
local lc=kp(kh)
while lb!=lc do
add(fh,kr)
kr=kk[lb]
lb=kp(kr)
end
for eu=1,#fh/2 do
local ld=fh[eu]
local le=#fh-(eu-1)
fh[eu]=fh[le]
fh[le]=ld
end
end
return fh
end
function ko(t,bx,fk)
if#t>=1 then
add(t,{})
for eu=(#t),2,-1 do
local kw=t[eu-1]
if fk<kw[2] then
t[eu]={bx,fk}
return
else
t[eu]=kw
end
end
t[1]={bx,fk}
else
add(t,{bx,fk})
end
end
function kp(lf)
return((lf[1]+1)*16)+lf[2]
end
function ic(bo)
bo.dj+=1
if bo.dj>bo.frame_delay then
bo.dj=1
bo.di+=1
if bo.di>#bo.dh then bo.di=1 end
end
end
function dq(msg)
print_line("-error-;"..msg,5+cam_x,5,8,0)
end
function jo(bo)
local cq=split(bo.data,"\n")
for iw in all(cq) do
local pairs=split(iw,"=")
if#pairs==2 then
bo[pairs[1]]=lg(pairs[2])
else
printh(" > invalid data: ["..pairs[1].."]")
end
end
end
function split(eh,lh)
local li={}
local ja=0
local lj=0
for eu=1,#eh do
local lk=sub(eh,eu,eu)
if lk==lh then
add(li,sub(eh,ja,lj))
ja=0
lj=0
elseif lk!=" "
and lk!="\t"then
lj=eu
if ja==0 then ja=eu end
end
end
if ja+lj>0 then
add(li,sub(eh,ja,lj))
end
return li
end
function lg(ll)
local lm=sub(ll,1,1)
local li=nil
if ll=="true"then
li=true
elseif ll=="false"then
li=false
elseif ln(lm) then
if lm=="-"then
li=sub(ll,2,#ll)*-1
else
li=ll+0
end
elseif lm=="{"then
local ld=sub(ll,2,#ll-1)
li=split(ld,",")
lo={}
for bx in all(li) do
bx=lg(bx)
add(lo,bx)
end
li=lo
else
li=ll
end
return li
end
function ln(fj)
for lp=1,13 do
if fj==sub("0123456789.-+",lp,lp) then
return true
end
end
end
function outline_text(lq,x,y,lr,lt,em)
if not em then lq=it(lq) end
for lu=-1,1 do
for lv=-1,1 do
print(lq,x+lu,y+lv,lt)
end
end
print(lq,x,y,lr)
end
function iu(eh)
return 63.5-flr((#eh*4)/2)
end
function lw(eh)
return 61
end
function hl(bo)
if not bo.hp
or cl then
return false
end
hp=bo.hp
if(fs+hp.kd>hp.kf or fs+hp.kd<hp.x)
or(ft>hp.kg or ft<hp.y) then
return false
else
return true
end
end
function it(eh)
local lp=""
local iw,fj,t=false,false
for eu=1,#eh do
local hr=sub(eh,eu,eu)
if hr=="^"then
if fj then lp=lp..hr end
fj=not fj
elseif hr=="~"then
if t then lp=lp..hr end
t,iw=not t,not iw
else
if fj==iw and hr>="a"and hr<="z"then
for js=1,26 do
if hr==sub("abcdefghijklmnopqrstuvwxyz",js,js) then
hr=sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\",js,js)
break
end
end
end
lp=lp..hr
fj,t=false,false
end
end
return lp
end
