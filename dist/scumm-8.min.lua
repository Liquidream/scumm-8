
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
function print_line(msg,x,y,col,ei,ef,eg)
col=col or 7
ei=ei or 0
local ej=127-(x-cam_x)
if(ei==1) ej=min(x-cam_x,ej)
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
local ci=cj(msg,ek)
local ck=cl(ci)
eo=x-cam_x
if(ei==1) eo-=ck*2
local eo,ep=max(2,eo),max(18,y)
eo=min(eo,127-(ck*4)-1)
ee={
eq=ci,
x=eo,
y=ep,
col=col,
ei=ei,
er=eg or#msg*8,
cn=ck,
ef=ef
}
if#el>0 then
es=eh
wait_for_message()
eh=es
print_line(el,x,y,col,ei,ef)
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
dt()
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
function fq(bg)
local fr={}
for eb,bi in pairs(bg) do
add(fr,eb)
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
function dt()
fs,ft,fu,fv,fw,j=get_verb(verb_default),false,""
end
dt()
dz={}
ds={}
cc={}
fx={}
dq,dq=0,0
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
ga(dz)
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
if(ce.by!=2) fy=3
ce=nil
end
end
else
ga(ds)
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
0+dq-gd,
stage_top+dq-ge,
128-dq*2-gd,
64-dq*2)
gf()
camera(0,0)
clip()
if show_debuginfo then
print("cpu: "..flr(100*stat(1)).."%",0,stage_top-16,8)
print("mem: "..flr(stat(0)/1024*100).."%",0,stage_top-8,8)
print("x: "..flr(fl+cam_x).." y:"..fm-stage_top,80,stage_top-8,8)
end
gg()
if cg
and cg.cp then
gh()
gi()
return
end
if(fy>0) fy-=1 return
if(not ce) gj()
if(not ce
or ce.by==2)
and fy==0 then
gk()
end
if(not ce) gi()
end
function gl()
gm=stat(34)>0
end
function gb()
if ee and not gm and(btnp(4) or stat(34)==1) then
ee.er,gm=0,true
return
end
if ce then
if(btnp(5) or stat(34)==2) and ce.ca then
ce.bz=cocreate(ce.ca)
ce.ca=nil
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
if cg and cg.cp then
if(gt) selected_sentence=gt
return
end
if gu then
fs,fv,fw=get_verb(gu)
elseif gv then
if gs==1 then
if fv then
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
if selected_actor.gy+2<flr(#selected_actor.dv/4) then
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
local dw=dm[gz]
if(dw) dw(fv,fv.target_door)
else
bk(gz,fv,fw)
end
end
dt()
end)
coresume(selected_actor.bz)
elseif fm>stage_top and fm<stage_top+64 then
ft=true
selected_actor.bz=cocreate(function()
walk_to(selected_actor,fl+cam_x,fm-stage_top)
dt()
end)
coresume(selected_actor.bz)
end
end
function gc()
if(not room_curr) return
gu,gw,gv,gt,gx=nil
if cg and cg.cp then
for ea in all(cg.ch) do
if(hc(ea)) gt=ea
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
for eb,bt in pairs(actors) do
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
for eb,bg in pairs(selected_actor.dv) do
if hc(bg) then
gv=bg
if(fs[2]=="pickup"and gv.owner) fs=nil
end
if(bg.owner!=selected_actor) del(selected_actor.dv,bg)
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
hs=bg.curr_anim[bg.db]
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
local hv,hs=da[bt.face_dir]
if bt.curr_anim
and(bt.eu==1 or cr(bt.curr_anim))
then
ht(bt)
hs=bt.curr_anim[bt.db]
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
local ib=bt.ct+flr(ia/2)
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
if eh
and eh==bt
and eh.talk
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
print(ii(ih),ij(ih),stage_top+66,ie)
end
function gg()
if ee then
local ik=0
for il in all(ee.eq) do
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
ee.ef)
ik+=6
end
ee.er-=1
if(ee.er<=0) stop_talking()
end
end
function gk()
local eo,ep,io=0,75,0
for bi in all(verbs) do
local ip=bi==gu and verb_hovcol or
(gw and bi==gw and verb_defcol or
verb_maincol)
local bj=get_verb(bi)
print(bj[3],eo,ep+stage_top+1,verb_shadcol)
print(bj[3],eo,ep+stage_top,ip)
bi.x=eo
bi.y=ep
he(bi,#bj[3]*4,5,0,0)
if(#bj[3]>io) io=#bj[3]
ep+=8
if ep>=95 then
ep=75
eo+=(io+1.0)*4
io=0
end
end
if selected_actor then
eo,ep=86,76
local iq=selected_actor.gy*4
local ir=min(iq+8,#selected_actor.dv)
for is=1,8 do
rectfill(eo-1,stage_top+ep-1,eo+8,stage_top+ep+8,verb_shadcol)
bg=selected_actor.dv[iq+is]
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
is+=1
end
for em=1,2 do
it=fp[em]
pal(7,gx==it and verb_hovcol or verb_maincol)
pal(5,verb_shadcol)
hu(it.spr,it.x,it.y,1,1,0)
he(it,8,7,0,0)
pal()
end
end
end
function gh()
local eo,ep=0,70
for ea in all(cg.ch) do
if ea.cn>0 then
ea.x,ea.y=eo,ep
he(ea,ea.cn*4,#ea.ci*5,0,0)
local ip=ea==gt and cg.co or cg.col
for il in all(ea.ci) do
print(ii(il),eo,ep+stage_top,ip)
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
function hu(iu,x,y,w,h,iv,flip_x,iw,scale)
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
function fz()
for et in all(rooms) do
je(et)
et.hm=#et.map>2 and et.map[3]-et.map[1]+1 or 16
et.hn=#et.map>2 and et.map[4]-et.map[2]+1 or 8
et.autodepth_pos=et.autodepth_pos or{9,50}
et.autodepth_scale=et.autodepth_scale or{0.25,1}
for bg in all(et.objects) do
je(bg)
bg.in_room,bg.h=et,bg.h or 0
if(bg.init) bg.init(bg)
end
end
for jf,bt in pairs(actors) do
je(bt)
bt.eu=2
bt.dc=1
bt.id=1
bt.db=1
bt.dv={
}
bt.gy=0
end
end
function ga(scripts)
for ec in all(scripts) do
if ec[2] and not coresume(ec[2],ec[3],ec[4]) then
del(scripts,ec)
end
end
end
function hr(jg)
if(jg) jg=1-jg
local fd=flr(mid(0,jg,1)*100)
local jh={0,1,1,2,1,13,6,
4,4,9,3,13,1,13,14}
for ji=1,15 do
col=ji
jj=(fd+(ji*1.46))/22
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
return mid(0,(cr(bp) and bp.x or bp)-64,(room_curr.hm*8)-128)
end
function ew(bg)
return{flr(bg.x/8)+room_curr.map[1],flr(bg.y/8)+room_curr.map[2]}
end
function jk(ex,ey)
return fget(mget(ex,ey),0)
end
function cj(msg,ek)
local ci,jl,jm,en={},"","",""
local function jn(jo)
if#jm+#jl>jo then
add(ci,jl)
jl=""
end
jl=jl..jm
jm=""
end
for em=1,#msg do
en=sub(msg,em,em)
jm=jm..en
if en==" "or#jm>ek-1 then
jn(ek)
elseif#jm>ek-1 then
jm=jm.."-"
jn(ek)
elseif en==";"then
jl=jl..sub(jm,1,#jm-1)
jm=""
jn(0)
end
end
jn(ek)
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
function he(bg,w,h,jr,js)
local x,y=bg.x,bg.y
if has_flag(bg.classes,"class_actor") then
bg.ct=x-(bg.w*8)/2
bg.hj=y-(bg.h*8)+1
x=bg.ct
y=bg.hj
end
bg.hg={
x=x,
y=y+stage_top,
jt=x+w-1,
ju=y+h+stage_top-1,
jr=jr,
js=js
}
end
function fb(jv,jw)
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
if kg>=room_curr.map[1] and kg<=room_curr.map[1]+room_curr.hm
and kh>=room_curr.map[2] and kh<=room_curr.map[2]+room_curr.hn
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
local fa={}
kc=jy[ke(jw)]
if kc then
add(fa,jw)
elseif kb then
kc=jy[kb]
add(fa,kl)
end
if kc then
local km,kn=ke(kc),ke(jv)
while km!=kn do
add(fa,kc)
kc=jy[km]
km=ke(kc)
end
for em=1,#fa/2 do
local ko=fa[em]
local kp=#fa-(em-1)
fa[em]=fa[kp]
fa[kp]=ko
end
end
return fa
end
function kd(t,bp,fd)
local kq={bp,fd}
if#t>=1 then
for em=#t+1,2,-1 do
local ki=t[em-1]
if fd<ki[2] then
t[em]=kq
return
else
t[em]=ki
end
end
end
t[1]=kq
end
function ke(kr)
return((kr[1]+1)*16)+kr[2]
end
function ht(bg)
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
for em=1,#ea do
local kw=sub(ea,em,em)
if kw==kt then
add(ku,sub(ea,iq,kv))
iq,kv=0,0
elseif kw!=" "
and kw!="\t"then
kv,iq=em,iq==0 and em or iq
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
function outline_text(la,x,y,lb,lc,ef)
if(not ef) la=ii(la)
for ld=-1,1 do
for le=-1,1,ld==0 and 2 or 1 do
print(la,x+ld,y+le,lc)
end
end
print(la,x,y,lb)
end
function ij(ea)
return 63.5-flr(#ea*2)
end
function hc(bg)
if(not bg.hg or ce) return false
local hg=bg.hg
return not((fl+hg.jr>hg.jt or fl+hg.jr<hg.x)
or(fm>hg.ju or fm<hg.y))
end
function ii(ea)
local lf,il,fc,t=""
for em=1,#ea do
local hi=sub(ea,em,em)
if hi=="^"then
if(fc) lf=lf..hi
fc=not fc
elseif hi=="~"then
if(t) lf=lf..hi
t,il=not t,not il
else
if fc==il and hi>="a"and hi<="z"then
for ji=1,26 do
if hi==sub("etaoinsrhldcumfgpwybvkjxz",ji,ji) then
hi=sub("ETAOINSRHLDCUMFGPWYBVKJXZQ",ji,ji)
break
end
end
end
lf=lf..hi
fc,t=nil
end
end
return lf
end
