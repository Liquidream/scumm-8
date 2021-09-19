
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
cd=bx
break_time()
end
function dialog_set(ce)
for msg in all(ce) do
dialog_add(msg)
end
end
function dialog_add(msg)
cf=cf or{cg={}}
ch=ci(msg,32)
cj=ck(ch)
cl={
num=#cf.cg+1,
msg=msg,
ch=ch,
cm=cj
}
add(cf.cg,cl)
end
function dialog_start(col,cn)
cf.col=col
cf.cn=cn
cf.co=true
selected_sentence=nil
end
function dialog_hide()
cf.co=false
end
function dialog_clear()
cf.cg={}
selected_sentence=nil
end
function dialog_end()
cf=nil
end
function get_use_pos(bg)
local cp,y,x=bg.use_pos or"pos_infront",bg.y,bg.x
if cq(cp) then
x,y=cp[1],cp[2]
else
local cr={
pos_left={-2,bg.h*8-2},
pos_right={bg.w*8,bg.h*8-2},
pos_above={bg.w*4-4,-2},
pos_center={bg.w*4,bg.h*4-4},
pos_infront={bg.w*4-4,bg.h*8+2}
}
if cp=="pos_left"and bg.cs then
x-=(bg.w*8+4)
y+=1
else
x+=cr[cp][1]
y+=cr[cp][2]
end
end
return{x=x,y=y}
end
function do_anim(ct,cu,cv)
if cu=="face_towards"then
if cq(cv) then
cw=atan2(ct.x-cv.x,cv.y-ct.y)
cx=93*(3.1415/180)
cw=cx-cw
cy=(cw*360)%360
cv=4-flr(cy/90)
cv=cz[cv]
end
face_dir=cz[ct.face_dir]
cv=cz[cv]
while face_dir!=cv do
if face_dir<cv then
face_dir+=1
else
face_dir-=1
end
ct.face_dir=cz[face_dir]
ct.flip=(ct.face_dir=="face_left")
break_time(10)
end
else
ct.curr_anim=cu
ct.da=1
ct.db=1
end
end
function open_door(dc,dd)
if dc.state=="state_open"then
say_line"it's already open"
else
dc.state="state_open"
if(dd) dd.state="state_open"
end
end
function close_door(dc,dd)
if dc.state=="state_closed"then
say_line"it's already closed"
else
dc.state="state_closed"
if(dd) dd.state="state_closed"
end
end
function come_out_door(de,df,dg)
if(df==nil) dh("target door does not exist") return
if(de.state~="state_open") say_line("the door is closed") return
di=df.in_room
if(di!=room_curr) change_room(di,dg)
local dj=get_use_pos(df)
put_at(selected_actor,dj.x,dj.y,di)
if df.use_dir then
dk=cz[(cz[df.use_dir]+1)%4+1]
else
dk="face_front"
end
selected_actor.face_dir=dk
selected_actor.flip=(selected_actor.face_dir=="face_left")
end
dl={
open=open_door,
close=close_door,
walkto=come_out_door
}
function fades(dm,dir)
local dn=25-25*dir
while true do
dn+=dir*2
if dn>50
or dn<0 then
return
end
if(dm==1) dp=min(dn,32)
yield()
end
end
function change_room(di,dm)
if(not di) dh("room does not exist") return
stop_script(dq)
if dm and room_curr then
fades(dm,1)
end
if(room_curr and room_curr.exit) room_curr.exit(room_curr)
dr={}
ds()
room_curr=di
if(not br or br.in_room!=room_curr) cam_x=0
stop_talking()
if dm then
dq=function()
fades(dm,-1)
end
start_script(dq,true)
else
dp=0
end
if room_curr.enter then
room_curr.enter(room_curr)
end
end
function valid_verb(bl,dt)
if(not dt or not dt.verbs) return false
if cq(bl) then
if(dt.verbs[bl[1]]) return true
else
if(dt.verbs[bl]) return true
end
end
function pickup_obj(bg,bt)
bt=bt or selected_actor
add(bt.du,bg)
bg.owner=bt
del(bg.in_room.objects,bg)
end
function start_script(dv,dw,dx,q)
local bz=cocreate(dv)
add(dw and dy or dr,{dv,bz,dx,q})
end
function script_running(dv)
for dz in all({dr,dy}) do
for ea,eb in pairs(dz) do
if eb[1]==dv then
return eb
end
end
end
end
function stop_script(dv)
eb=script_running(dv)
del(dr,eb)
del(dy,eb)
end
function break_time(ec)
for x=1,ec or 1 do
yield()
end
end
function wait_for_message()
while ed do
yield()
end
end
function say_line(bt,msg,ee,ef)
if type(bt)=="string"then
msg,bt=bt,selected_actor
end
eg=bt
print_line(msg,bt.x,bt.y-bt.h*8+4,bt.col,1,ee,ef)
end
function stop_talking()
ed,eg=nil
end
function print_line(msg,x,y,col,eh,ee,ef,ei)
col=col or 7
eh=eh or 0
local ej=127-(x-cam_x)
if(eh==1) ej=min(x-cam_x,ej)
local ek=max(flr(ej/2),16)
local el=""
for em=1,#msg do
local en=sub(msg,em,em)
if en==":"then
el=sub(msg,em+1)
msg=sub(msg,1,em-1)
break
end
end
local ch=ci(msg,ek)
local cj=ck(ch)
eo=x-cam_x
if(eh==1) eo-=cj*(ei and 4 or 2)
local eo,ep=max(2,eo),max(18,y)
eo=min(eo,127-(cj*4)-1)
ed={
eq=ch,
x=eo,
y=ep,
col=col,
eh=eh,
er=ef or#msg*8,
cm=cj,
ee=ee,
ei=ei
}
if#el>0 then
es=eg
wait_for_message()
eg=es
print_line(el,x,y,col,eh,ee,nil,ei)
end
wait_for_message()
end
function put_at(bg,x,y,et)
if et then
if not has_flag(bg.classes,"class_actor") then
if(bg.in_room) del(bg.in_room.objects,bg)
add(et.objects,bg)
bg.owner=nil
end
bg.in_room=et
end
bg.x,bg.y=x,y
end
function stop_actor(bt)
bt.eu,bt.curr_anim=0
ds()
end
function walk_to(bt,x,y)
local ev=ew(bt)
local ex,ey=flr(x/8)+room_curr.map[1],flr(y/8)+room_curr.map[2]
local ez={ex,ey}
local fa=fb(ev,ez,{x,y})
bt.eu=1
for fc=1,#fa do
local fd=fa[fc]
local fe=bt.walk_speed*(bt.scale or bt.ff)
local fg,fh=(fd[1]-room_curr.map[1])*8+4,(fd[2]-room_curr.map[2])*8+4
if(fc==#fa and x>=fg-4 and x<=fg+4 and y>=fh-4 and y<=fh+4) fg,fh=x,y
local fi=sqrt((fg-bt.x)^2+(fh-bt.y)^2)
local fj=fe*(fg-bt.x)/fi
local fk=fe*(fh-bt.y)/fi
if fi>0 then
for em=0,fi/fe-1 do
if bt.eu==0 then
return
end
bt.flip=fj<0
if abs(fj)<fe/2 then
bt.curr_anim=fk>0 and bt.walk_anim_front or bt.walk_anim_back
bt.face_dir=fk>0 and"face_front"or"face_back"
else
bt.curr_anim=bt.walk_anim_side
bt.face_dir=bt.flip and"face_left"or"face_right"
end
bt.x+=fj
bt.y+=fk
yield()
end
end
end
bt.eu,bt.curr_anim=2
end
function wait_for_actor(bt)
bt=bt or selected_actor
while bt.eu!=2 do
yield()
end
end
function proximity(bm,bn)
return bm.in_room==bn.in_room and sqrt((bm.x-bn.x)^2+(bm.y-bn.y)^2) or 1000
end
stage_top=16
cam_x,be=0,0
fl,fm,fn,fo=63.5,63.5,0,1
fp={
{spr=ui_uparrowspr,x=75,y=stage_top+60},
{spr=ui_dnarrowspr,x=75,y=stage_top+72}
}
cz={
"face_front",
"face_left",
"face_back",
"face_right",
face_front=1,
face_left=2,
face_back=3,
face_right=4
}
function fq(bg)
local fr={}
for ea,bi in pairs(bg) do
add(fr,ea)
end
return fr
end
function get_verb(bg)
local bl,fr={},fq(bg[1])
add(bl,fr[1])
add(bl,bg[1][fr[1]])
add(bl,bg.text)
return bl
end
function ds()
fs,ft,fu,fv,fw,j=get_verb(verb_default),false,""
end
ds()
dy={}
dr={}
cc={}
fx={}
dp,dp=0,0
fy=0
function _init()
poke(0x5f2d,1)
fz()
start_script(startup_script,true)
end
function _update60()
if selected_actor and selected_actor.bz
and not coresume(selected_actor.bz) then
selected_actor.bz=nil
end
ga(dy)
if cd then
if cd.bz
and not coresume(cd.bz) then
if cd.by!=3
and cd.cb
then
camera_follow(cd.cb)
selected_actor=cd.cb
end
del(cc,cd)
if#cc>0 then
cd=cc[#cc]
else
if(cd.by!=2) fy=3
cd=nil
end
end
else
ga(dr)
end
gb()
gc()
gd,ge=1.5-rnd(3),1.5-rnd(3)
gd=flr(gd*be)
ge=flr(ge*be)
if(not bd) be=be>0.05 and be*0.90 or 0
end
function _draw()
cls()
camera(cam_x+gd,0+ge)
clip(
0+dp-gd,
stage_top+dp-ge,
128-dp*2-gd,
64-dp*2)
gf()
camera(0,0)
clip()
if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,stage_top-16,8)
print("mem: "..flr(stat(0)/1024*100).."%",0,stage_top-8,8)
print("x: "..flr(fl+cam_x).." y:"..fm-stage_top,80,stage_top-8,8)
end
gg()
if cf
and cf.co then
gh()
gi()
return
end
if(fy>0) fy-=1 return
if(not cd) gj()
if(not cd
or cd.by==2)
and fy==0 then
gk()
end
if(not cd) gi()
end
function gl()
gm=stat(34)>0
end
function gb()
if ed and not gm and(btnp(4) or stat(34)==1) then
ed.er,gm=0,true
return
end
if cd then
if(btnp(5) or stat(34)==2) and cd.ca then
cd.bz=cocreate(cd.ca)
cd.ca=nil
return
end
gl()
return
end
if btn(0) then fl-=1 end
if btn(1) then fl+=1 end
if btn(2) then fm-=1 end
if btn(3) then fm+=1 end
if btnp(4) then gn(1) end
if btnp(5) then gn(2) end
go,gp=stat(32)-1,stat(33)-1
if go!=gq then fl=go end
if gp!=gr then fm=gp end
if stat(34)>0 and not gm then
gn(stat(34))
end
gq,gr=go,gp
gl()
end
fl,fm=mid(0,fl,127),mid(0,fm,127)
function gn(gs)
if(not selected_actor) return
if cf and cf.co then
if(gt) selected_sentence=gt
return
end
if(ft) ds()
if gu then
fs,fv,fw=get_verb(gu)
elseif gv then
if gs==1 then
if fv and not ft then
fw=gv
else
fv=gv
end
if(fs[2]==get_verb(verb_default)[2]
and gv.owner) then
fs=get_verb(verbs[verb_default_inventory_index])
end
elseif gw then
fs,fv=get_verb(gw),gv
gj()
end
elseif gx then
if gx==fp[1] then
if(selected_actor.gy>0) selected_actor.gy-=1
else
if selected_actor.gy+2<flr(#selected_actor.du/4) then
selected_actor.gy+=1
end
end
return
end
local gz=fs[2]
if fv then
if gz=="use"or gz=="give"then
if fw then
elseif fv.use_with and fv.owner==selected_actor then
return
end
end
ft=true
selected_actor.bz=cocreate(function()
if(not fv.owner
and(not has_flag(fv.classes,"class_actor")
or gz!="use"))
or fw
then
ha=fw or fv
hb=get_use_pos(ha)
walk_to(selected_actor,hb.x,hb.y)
if selected_actor.eu!=2 then return end
use_dir=ha
if ha.use_dir then use_dir=ha.use_dir end
do_anim(selected_actor,"face_towards",use_dir)
end
if valid_verb(fs,fv) then
start_script(fv.verbs[fs[1]],false,fv,fw)
else
if has_flag(fv.classes,"class_door") then
local dv=dl[gz]
if(dv) dv(fv,fv.target_door)
else
bk(gz,fv,fw)
end
end
ds()
end)
coresume(selected_actor.bz)
elseif fm>stage_top and fm<stage_top+64 then
ft=true
selected_actor.bz=cocreate(function()
walk_to(selected_actor,fl+cam_x,fm-stage_top)
ds()
end)
coresume(selected_actor.bz)
end
end
function gc()
if(not room_curr) return
gu,gw,gv,gt,gx=nil
if cf and cf.co then
for dz in all(cf.cg) do
if(hc(dz)) gt=dz
end
return
end
hd()
for bg in all(room_curr.objects) do
if(not bg.classes
or(bg.classes and not has_flag(bg.classes,"class_untouchable")))
and(not bg.dependent_on
or bg.dependent_on.state==bg.dependent_on_state)
then
he(bg,bg.w*8,bg.h*8,cam_x,hf)
else
bg.hg=nil
end
if hc(bg) then
if not gv
or max(bg.z,gv.z)==bg.z
then
gv=bg
end
end
hh(bg)
end
for ea,bt in pairs(actors) do
if bt.in_room==room_curr then
he(bt,bt.w*8,bt.h*8,cam_x,hf)
hh(bt)
if(hc(bt) and bt!=selected_actor) gv=bt
end
end
if selected_actor then
for bi in all(verbs) do
if(hc(bi)) gu=bi
end
for hi in all(fp) do
if(hc(hi)) gx=hi
end
for ea,bg in pairs(selected_actor.du) do
if hc(bg) then
gv=bg
if(fs[2]=="pickup"and gv.owner) fs=nil
end
if(bg.owner!=selected_actor) del(selected_actor.du,bg)
end
fs=fs or get_verb(verb_default)
gw=gv and bf(gv) or gw
end
end
function hd()
for x=-64,64 do
fx[x]={}
end
end
function hh(bg)
add(fx[bg.z and bg.z or flr(bg.y+(bg.hj and 0 or bg.h*8))],bg)
end
function gf()
if not room_curr then
print("-error-  no current room set",5+cam_x,5+stage_top,8,0)
return
end
rectfill(0,stage_top,127,stage_top+64,room_curr.hk or 0)
for z=-64,64 do
if z==0 then
hl(room_curr)
if room_curr.trans_col then
palt(0,false)
palt(room_curr.trans_col,true)
end
map(room_curr.map[1],room_curr.map[2],0,stage_top,room_curr.hm,room_curr.hn)
pal()
else
ho=fx[z]
for bg in all(ho) do
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
hp(bg)
end
else
if(bg.in_room==room_curr) hq(bg)
end
end
end
end
end
function hl(bg)
if bg.col_replace then
fc=bg.col_replace
pal(fc[1],fc[2])
end
if bg.lighting then
hr(bg.lighting)
elseif bg.in_room and bg.in_room.lighting then
hr(bg.in_room.lighting)
end
end
function hp(bg)
local hs=0
hl(bg)
if bg.draw then
bg.draw(bg)
else
if bg.curr_anim then
ht(bg)
hs=bg.curr_anim[bg.da]
end
for h=0,bg.repeat_x and bg.repeat_x-1 or 0 do
if bg.states then
hs=bg.states[bg.state]
elseif hs==0 then
hs=bg[bg.state]
end
hu(hs,bg.x+(h*(bg.w*8)),bg.y,bg.w,bg.h,bg.trans_col,bg.flip_x,bg.scale)
end
end
pal()
end
function hq(bt)
local hv,hs=cz[bt.face_dir]
if bt.curr_anim
and(bt.eu==1 or cq(bt.curr_anim))
then
ht(bt)
hs=bt.curr_anim[bt.da]
else
hs=bt.idle[hv]
end
hl(bt)
local hw=(bt.y-room_curr.autodepth_pos[1])/(room_curr.autodepth_pos[2]-room_curr.autodepth_pos[1])
hw=room_curr.autodepth_scale[1]+(room_curr.autodepth_scale[2]-room_curr.autodepth_scale[1])*hw
bt.ff=mid(room_curr.autodepth_scale[1],hw,room_curr.autodepth_scale[2])
local scale=bt.scale or bt.ff
local hx,hy=(8*bt.h),(8*bt.w)
local hz=hx-(hx*scale)
local ia=hy-(hy*scale)
local ib=bt.cs+flr(ia/2)
local ic=bt.hj+hz
hu(hs,
ib,
ic,
bt.w,
bt.h,
bt.trans_col,
bt.flip,
false,
scale)
if eg
and eg==bt
and eg.talk
then
if bt.id<7 then
hu(bt.talk[hv],
ib+(bt.talk[5] or 0),
ic+flr((bt.talk[6] or 8)*scale),
(bt.talk[7] or 1),
(bt.talk[8] or 1),
bt.trans_col,
bt.flip,
false,
scale)
end
bt.id=bt.id%14+1
end
pal()
end
function gj()
local ie,ig,ih=verb_maincol,fs[2],fs and fs[3] or""
if fv then
ih=ih.." "..fv.name
if ig=="use"and(not ft or fw) then
ih=ih.." with"
elseif ig=="give"then
ih=ih.." to"
end
end
if fw then
ih=ih.." "..fw.name
elseif gv
and gv.name!=""
and(not fv or(fv!=gv))
and not ft
then
if gv.owner
and ig==get_verb(verb_default)[2] then
ih="look-at"
end
ih=ih.." "..gv.name
end
fu=ih
if ft then
ih=fu
ie=verb_hovcol
end
print(ii(ih),63.5-flr(#ih*2),stage_top+66,ie)
end
function gg()
if ed then
local ij=0
for ik in all(ed.eq) do
local il=0
if ed.eh==1 then
il=((ed.cm*4)-(#ik*4))/2
end
outline_text(
ik,
ed.x+il,
ed.y+ij,
ed.col,
0,
ed.ee,
ed.ei)
ij+=ed.ei and 12 or 6
end
ed.er-=1
if(ed.er<=0) stop_talking()
end
end
function gk()
local eo,ep,im=0,75,0
for bi in all(verbs) do
local io=bi==gu and verb_hovcol or
(gw and bi==gw and verb_defcol or
verb_maincol)
local bj=get_verb(bi)
print(bj[3],eo,ep+stage_top+1,verb_shadcol)
print(bj[3],eo,ep+stage_top,io)
bi.x=eo
bi.y=ep
he(bi,#bj[3]*4,5,0,0)
if(#bj[3]>im) im=#bj[3]
ep+=8
if ep>=95 then
ep=75
eo+=(im+1.0)*4
im=0
end
end
if selected_actor then
eo,ep=86,76
local ip=selected_actor.gy*4
local iq=min(ip+8,#selected_actor.du)
for ir=1,8 do
rectfill(eo-1,stage_top+ep-1,eo+8,stage_top+ep+8,verb_shadcol)
bg=selected_actor.du[ip+ir]
if bg then
bg.x,bg.y=eo,ep
hp(bg)
he(bg,bg.w*8,bg.h*8,0,0)
end
eo+=11
if eo>=125 then
ep+=12
eo=86
end
ir+=1
end
for em=1,2 do
is=fp[em]
pal(7,gx==is and verb_hovcol or verb_maincol)
pal(5,verb_shadcol)
hu(is.spr,is.x,is.y,1,1,0)
he(is,8,7,0,0)
pal()
end
end
end
function gh()
local eo,ep=0,70
for dz in all(cf.cg) do
if dz.cm>0 then
dz.x,dz.y=eo,ep
he(dz,dz.cm*4,#dz.ch*5,0,0)
local io=dz==gt and cf.cn or cf.col
for ik in all(dz.ch) do
print(ii(ik),eo,ep+stage_top,io)
ep+=5
end
ep+=2
end
end
end
function gi()
col=ui_cursor_cols[fo]
pal(7,col)
spr(ui_cursorspr,fl-4,fm-3,1,1,0)
pal()
fn+=1
if fn>7 then
fn=1
fo=fo%#ui_cursor_cols+1
end
end
function hu(it,x,y,w,h,iu,flip_x,iv,scale)
set_trans_col(iu)
it=it or 0
local iw,ix=8*(it%16),8*flr(it/16)
local iy,iz=8*w,8*h
local ja=scale or 1
local jb,jc=iy*ja,iz*ja
sspr(iw,ix,iy,iz,x,stage_top+y,jb,jc,flip_x,iv)
end
function set_trans_col(iu)
palt(0,false)
palt(iu,true)
end
function fz()
for et in all(rooms) do
jd(et)
et.hm=#et.map>2 and et.map[3]-et.map[1]+1 or 16
et.hn=#et.map>2 and et.map[4]-et.map[2]+1 or 8
et.autodepth_pos=et.autodepth_pos or{9,50}
et.autodepth_scale=et.autodepth_scale or{0.25,1}
for bg in all(et.objects) do
jd(bg)
bg.in_room,bg.h=et,bg.h or 0
if(bg.init) bg.init(bg)
end
end
for je,bt in pairs(actors) do
jd(bt)
bt.eu=2
bt.db=1
bt.id=1
bt.da=1
bt.du={
}
bt.gy=0
end
end
function ga(scripts)
for eb in all(scripts) do
if eb[2] and not coresume(eb[2],eb[3],eb[4]) then
del(scripts,eb)
end
end
end
function hr(jf)
if(jf) jf=1-jf
local fd=flr(mid(0,jf,1)*100)
local jg={0,1,1,2,1,13,6,
4,4,9,3,13,1,13,14}
for jh=1,15 do
col=jh
ji=(fd+(jh*1.46))/22
for ea=1,ji do
col=jg[col]
end
pal(jh,col)
end
end
function cq(t)
return type(t)=="table"
end
function bs(bp)
return mid(0,(cq(bp) and bp.x or bp)-64,(room_curr.hm*8)-128)
end
function ew(bg)
return{flr(bg.x/8)+room_curr.map[1],flr(bg.y/8)+room_curr.map[2]}
end
function jj(ex,ey)
return fget(mget(ex,ey),0)
end
function ci(msg,ek)
local ch,jk,jl,en={},"","",""
local function jm(jn)
if#jl+#jk>jn then
add(ch,jk)
jk=""
end
jk=jk..jl
jl=""
end
for em=1,#msg do
en=sub(msg,em,em)
jl=jl..en
if en==" "or#jl>ek-1 then
jm(ek)
elseif#jl>ek-1 then
jl=jl.."-"
jm(ek)
elseif en==";"then
jk=jk..sub(jl,1,#jl-1)
jl=""
jm(0)
end
end
jm(ek)
if(jk!="") add(ch,jk)
return ch
end
function ck(ch)
local cj=0
for ik in all(ch) do
if(#ik>cj) cj=#ik
end
return cj
end
function has_flag(bg,jo)
for jp in all(bg) do
if(jp==jo) return true
end
end
function he(bg,w,h,jq,jr)
local x,y=bg.x,bg.y
if has_flag(bg.classes,"class_actor") then
bg.cs=x-(bg.w*8)/2
bg.hj=y-(bg.h*8)+1
x=bg.cs
y=bg.hj
end
bg.hg={
x=x,
y=y+stage_top,
js=x+w-1,
jt=y+h+stage_top-1,
jq=jq,
jr=jr
}
end
function fb(ju,jv)
local jw,jx,jy,jz,ka,kb={},{},{}
kc(jw,ju,0)
jy[kd(ju)]=0
while#jw>0 and#jw<1000 do
kb=jw[#jw][1]
del(jw,jw[#jw])
if(kd(kb)==kd(jv)) break
local ke={}
for x=-1,1 do
for y=-1,1,x==0 and 2 or 1 do
local kf,kg=kb[1]+x,kb[2]+y
if kf>=room_curr.map[1] and kf<=room_curr.map[1]+room_curr.hm
and kg>=room_curr.map[2] and kg<=room_curr.map[2]+room_curr.hn
and jj(kf,kg)
and((abs(x)!=abs(y))
or jj(kf,kb[2])
or jj(kf-x,kg)
or enable_diag_squeeze)
then
local kh={kf,kg}
local ki=kd(kh)
local kj=jy[kd(kb)]+(x*y==0 and 1 or 1.414)
if not jy[ki] or kj<jy[ki] then
jy[ki]=kj
local h=max(abs(jv[1]-kf),abs(jv[2]-kg))+min(abs(jv[1]-kf),abs(jv[2]-kg))*.414
kc(jw,kh,kj+h)
jx[ki]=kb
if not jz or h<jz then
jz=h
ka=ki
kk=kh
end
end
end
end
end
end
local fa={}
kb=jx[kd(jv)]
if kb then
add(fa,jv)
elseif ka then
kb=jx[ka]
add(fa,kk)
end
if kb then
local kl,km=kd(kb),kd(ju)
while kl!=km do
add(fa,kb)
kb=jx[kl]
kl=kd(kb)
end
for em=1,#fa/2 do
local kn=fa[em]
local ko=#fa-(em-1)
fa[em]=fa[ko]
fa[ko]=kn
end
end
return fa
end
function kc(t,bp,fd)
local kp={bp,fd}
if#t>=1 then
for em=#t+1,2,-1 do
local kh=t[em-1]
if fd<kh[2] then
t[em]=kp
return
else
t[em]=kh
end
end
end
t[1]=kp
end
function kd(kq)
return((kq[1]+1)*16)+kq[2]
end
function ht(bg)
bg.db+=1
if bg.db>bg.frame_delay then
bg.db=1
bg.da=bg.da%#bg.curr_anim+1
end
end
function dh(msg)
print_line("-error-;"..msg,5+cam_x,5,8,0)
end
function jd(bg)
for ik in all(split(bg.data,"\n")) do
local pairs=split(ik,"=")
if#pairs==2 then
bg[pairs[1]]=kr(pairs[2])
else
printh(" > invalid data: ["..pairs[1].."]")
end
end
end
function split(dz,ks)
local kt,ip,ku={},0,0
for em=1,#dz do
local kv=sub(dz,em,em)
if kv==ks then
add(kt,sub(dz,ip,ku))
ip,ku=0,0
elseif kv!=" "
and kv!="\t"then
ku,ip=em,ip==0 and em or ip
end
end
if ip+ku>0 then
add(kt,sub(dz,ip,ku))
end
return kt
end
function kr(kw)
local kx=sub(kw,1,1)
if kw=="true"then
return true
elseif kw=="false"then
return false
elseif tonum(kw) then
return tonum(kw)
elseif kx=="{"then
local kn=sub(kw,2,#kw-1)
ky={}
for bp in all(split(kn,",")) do
add(ky,kr(bp))
end
return ky
else
return kw
end
end
function outline_text(kz,x,y,la,lb,ee,ei)
if(not ee) kz=ii(kz)
if(ei) kz="\^w\^t"..kz
for lc=-1,1 do
for ld=-1,1,lc==0 and 2 or 1 do
print(kz,x+lc,y+ld,lb)
end
end
print(kz,x,y,la)
end
function hc(bg)
if(not bg.hg or cd) return false
local hg=bg.hg
return not((fl+hg.jq>hg.js or fl+hg.jq<hg.x)
or(fm>hg.jt or fm<hg.y))
end
function ii(dz)
local t=""
for em=1,#dz do
local fc=ord(dz,em)
t..=chr(fc>96 and fc<123 and fc-32 or fc)
end
return t
end
