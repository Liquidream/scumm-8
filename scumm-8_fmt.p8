pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
a=true b=false c=true d=true e=printh f={{{g="open"},h="open"},{{i="close"},h="close"},{{j="give"},h="give"},{{k="pickup"},h="pick-up"},{{l="lookat"},h="look-at"},{{m="talkto"},h="talk-to"},{{n="push"},h="push"},{{o="pull"},h="pull"},{{p="use"},h="use"}} q={{r="walkto"},h="walk to"} s=12 t=7 u=1 v=10 w={x=1,y=1,z=1,g=2,ba=2,bb=2} bc=1 bd=2 be=4 bf=8 bg=16 bh=32 bi=1 bj=2 bk=1 bl=2 bm=3 bn=4 bo=1 bp=3 bq=2 br=4 bs=5 bt=1 bu=2 bv={bw={bx=0,by=0,bz={{7,15},},ca=function(cb) cc(cb.cd.ce,true) end,cf=function(cb) cg(cb.cd.ce) end,ch=0,cd={ce=function() while true do for ci=1,3 do cj("fire",ci) ck(8) end end end,cl=function() while true do for ci=1,3 do cj("spinning top",ci) ck(8) end end end},cm={cn={co="fire",cp=1,cq=8*8,cr=4*8,w={145,146,147},cs=1,ct=1,cu=bm,cv=bo,cw="front door",cx=w.x,f={l=function() cy("it's a nice, warm fire...") cz() ck(10) da(db,bu,bk) cy("ouch! it's hot!;*stupid fire*") cz() end,m=function() cy("'hi fire...'") cz() ck(10) da(db,bu,bk) cy("the fire didn't say hello back;burn!!") cz() end,k=function(cb) dc(cb) end,}},dd={co="front door",de=bg,cp=w.x,cq=1*8,cr=2*8,df=-10,w={143,0},cs=1,ct=4,cv=br,cu=bl,f={r=function(cb) if dg(cb)==w.g then
dh(bv.di.cm.dd) else cy("the door is closed") end end,g=function(cb) dj(cb,bv.di.cm.dd) end,i=function(cb) dk(cb,bv.di.cm.dd) end}},dl={co="kitchen",cp=w.g,cq=14*8,cr=2*8,cs=1,ct=4,cv=bq,cu=bn,f={r=function() dh(bv.dm.cm.dn) end}},dp={co="bucket",de=bd,cp=w.g,cq=13*8,cr=6*8,cs=1,ct=1,w={207,223},dq=15,f={l=function(cb) if dr(cb)==db then
cy("it is a bucket in my pocket") else cy("it is a bucket") end end,k=function(cb) dc(cb) end,j=function(cb,ds) if ds==dt.du then
cy("can you fill this up for me?") cz() cy(dt.du,"sure") cz() cb.dv=dt.du ck(30) cy(dt.du,"here ya go...") cz() cb.cp=w.x cb.co="full bucket"dc(cb) else cy("i might need this") end end}},dw={co="spinning top",cp=1,cq=2*8,cr=6*8,w={192,193,194},bz={{12,7}},dq=15,cs=1,ct=1,f={n=function(cb) if dx(dy.cd.cl) then
cg(dy.cd.cl) cj(cb,1) else cc(dy.cd.cl) end end,o=function(cb) cg(dy.cd.cl) cj(cb,1) end}},dz={co="window",de=bg,cp=w.x,cu=bm,cv={cq=5*8,cr=(7*8)+1},cq=4*8,cr=1*8,cs=2,ct=2,w={132,134},f={g=function(cb) if not cb.ea then
eb(bi+bj,function() cb.ea=true ec("*bang*",40,20,8,1) cj(cb,w.g) cz() ed(bv.dm,1) db=dt.du ee(db,db.cq+10,db.cr) cy("what was that?!") cz() cy("i'd better check...") cz() ee(db,db.cq-10,db.cr) ed(bv.bw,1) ck(50) db.cq=115 db.cr=44 db.ef=bv.bw ee(db,db.cq-10,db.cr) cy("intruder!!!") cz() end,function() ed(bv.bw) dt.du.ef=bv.bw dt.du.cq=105 dt.du.cr=44 eg() end) end end}}}},dm={bx=16,by=0,eh=39,ei=7,ca=function() end,cf=function() end,cd={},cm={dn={co="hall",cp=w.g,cq=1*8,cr=2*8,cs=1,ct=4,cv=br,cu=bl,f={r=function() dh(bv.bw.cm.dl) end}},ej={co="back door",de=bg,cp=w.x,cq=22*8,cr=2*8,df=-10,w={143,0},ek=true,cs=1,ct=4,cv=bq,cu=bn,f={r=function(cb) if dg(cb)==w.g then
dh(bv.bw.cm.dd) else cy("the door is closed") end end,g=function(cb) dj(cb,bv.bw.cm.dd) end,i=function(cb) dk(cb,bv.bw.cm.dd) end}},},},di={bx=16,by=8,eh=47,ei=15,ca=function(cb) end,cf=function(cb) end,cd={},cm={el={de=bc,cq=10*8,cr=3*8,cp=1,w={111},cs=1,ct=2,em=8},en={de=bc,cq=22*8,cr=3*8,cp=1,w={111},cs=1,ct=2,em=8},dd={co="front door",de=bg,cp=w.x,cq=19*8,cr=1*8,w={142,0},ek=true,cs=1,ct=3,cv=bo,cu=bm,f={r=function(cb) if dg(cb)==w.g then
dh(bv.bw.cm.dd) else cy("the door is closed") end end,g=function(cb) dj(cb,bv.bw.cm.dd) end,i=function(cb) dk(cb,bv.bw.cm.dd) end}},},}} dt={eo={de=bh,cs=1,ct=4,ep=bk,eq={1,3,5,3},er={6,22,21,22},es={2,3,4,3},et=12,dq=11,eu=0.6,},du={co="purple tentacle",de=be+bh,cq=127/2-24,cr=127/2-16,cs=1,ct=3,ep=bk,eq={30,30,30,30},er={47,47,47,47},et=13,dq=15,eu=0.25,cv=bq,ef=bv.dm,f={l=function() cy("it's a weird looking tentacle, thing!") end,m=function(cb) eb(bi,function() cy(cb,"what do you want?") cz() end) while(true) do ev("where am i?") ev("who are you?") ev("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?") ev("nevermind") ew(db.et,7) while not ex.ey do ck() end ez=ex.ey fa() eb(bi,function() cy(ez.fb) cz() if ez.fc==1 then
cy(cb,"you are in paul's game") cz() elseif ez.fc==2 then cy(cb,"it's complicated...") cz() elseif ez.fc==3 then cy(cb,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!") cz() elseif ez.fc==4 then cy(cb,"ok bye!") cz() fd() return end end) fe() end end}}} function ff() db=dt.eo db.ef=bv.bw db.cq=64 db.cr=44 ed(bv.bw) fg(db) fh() cy("let's do this") cz() e("11") fi(db) end function fj(fk) local fl=nil if fm(fk.de,be) then
fl="talkto"elseif fm(fk.de,bg) then if fk.cp==w.x then
fl="open"else fl="close"end else fl="lookat"end for fn in all(f) do fo=fp(fn) if fo[2]==fl then fl=fn break end
end return fl end function fq(fr,fs,ft) if fr=="walkto"then
return elseif fr=="pickup"then if fm(fs.de,bh) then
cy("i don't need them") else cy("i don't need that") end elseif fr=="use"then if fm(fs.de,bh) then
cy("i can't just *use* someone") end if ft then
if fm(ft.de,bh) then
cy("i can't use that on someone!") else cy("that doesn't work") end end elseif fr=="give"then if fm(fs.de,bh) then
cy("i don't think i should be giving this away") else cy("i can't do that") end elseif fr=="lookat"then if fm(fs.de,bh) then
cy("i think it's alive") else cy("looks pretty ordinary") end elseif fr=="open"then if fm(fs.de,bh) then
cy("they don't seem to open") else cy("it doesn't seem to open") end elseif fr=="close"then if fm(fs.de,bh) then
cy(fu"they don't seem to close") else cy("it doesn't seem to close") end elseif fr=="push"or fr=="pull"then if fm(fs.de,bh) then
cy("moving them would accomplish nothing") else cy("it won't budge!") end elseif fr=="talkto"then if fm(fs.de,bh) then
cy("erm... i don't think they want to talk") else cy("i am not talking to that!") end else cy("hmm. no.") end end fv=127 fw=127 fx=16 fy=0 fz=0 ga=0 gb=nil gc=nil gd=fv/2 ge=fw/2 gf=0 gg={7,12,13,13,12,7} gh=1 gi={{spr=16,cq=75,cr=fx+60},{spr=48,cq=75,cr=fx+72}} gj=0 gk=0 gl=false dy=nil gm=nil gn=nil go=nil gp=""gq=false gr=nil ex=nil gs=nil gt=nil gu=0 gv={} gw={} gx={} gy={} function _init() if d then poke(0x5f2d,1) end
gz() cc(ff,true) end function _update60() ha() end function _draw() hb() end function ha() if db and db.hc and not coresume(db.hc) then
db.hc=nil end hd(gv) if gs then
if gs.hc and not coresume(gs.hc) then
if(dy!=gs.he) then ed(gs.he) end
db=gs.hf fi(gs.hg) del(gx,gs) gs=nil if#gx>0 then
gs=gx[#gx] end end else hd(gw) end hh() hi() end function hb() rectfill(0,0,fv,fw,0) camera(fy,0) clip(0+gu,fx+gu,fv+1-gu*2,64-gu*2) hj() camera(0,0) clip() if c then
print("cpu: "..flr(100*stat(1)).."%",0,fx-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fx-8,8) end if a then print("x: "..gd.." y:"..ge-fx,80,fx-8,8) end
hk() if ex and ex.hl then
hm() hn() return end if ho==gs then
else ho=gs return end if not gs then
hp() end if(not gs
or not fm(gs.hq,bi)) and(ho==gs) then hr() else end ho=gs if not gs then
hn() end end function hh() if gs then
if btnp(4) and btnp(5) and gs.hs then
gs.hc=cocreate(gs.hs) gs.hs=nil return end return end if btn(0) then gd-=1 end
if btn(1) then gd+=1 end
if btn(2) then ge-=1 end
if btn(3) then ge+=1 end
if btnp(4) then ht(1) end
if btnp(5) then ht(2) end
if d then
if stat(32)-1!=gj then gd=stat(32)-1 end
if stat(33)-1!=gk then ge=stat(33)-1 end
if stat(34)>0 then
if not gl then
ht(stat(34)) gl=true end else gl=false end gj=stat(32)-1 gk=stat(33)-1 end gd=max(gd,0) gd=min(gd,127) ge=max(ge,0) ge=min(ge,127) end function ht(hu) local hv=gm if ex and ex.hl then
if hw then
ex.ey=hw end return end if hx then
gm=fp(hx) e("verb = "..gm[2]) elseif hy then if hu==1 then
if(gm[2]=="use"or gm[2]=="give")
and gn then go=hy e("noun2_curr = "..go.co) else gn=hy e("noun1_curr = "..gn.co) end elseif hz then gm=fp(hz) gn=hy ia(gn) hp() end elseif ib then if ib==gi[1] then
if db.ic>0 then
db.ic-=1 end else if db.ic+2<flr(#db.id/4) then
db.ic+=1 end end return else end if(gn!=nil) then
if gm[2]=="use"or gm[2]=="give"then
if go then
else return end end gq=true db.hc=cocreate(function(ie,fk,fr,ds) if not fk.dv then
e("obj x="..fk.cq..",y="..fk.cr) e("obj w="..fk.cs..",h="..fk.ct) ig=ih(fk) e("dest_pos x="..ig.cq..",y="..ig.cr) if(fk.ii) then e("offset x="..fk.ii..",y="..fk.ij) end
ee(db,ig.cq,ig.cr) e(".moving="..db.ik) if db.ik!=2 then return end
cu=db.ep if fk.cu and fr!=q then cu=fk.cu end
da(db,bu,cu) end if il(fr,fk) then
cc(fk.f[fr[1]],false,fk,ds) else fq(fr[2],fk,ds) end im() end) coresume(db.hc,db,gn,gm,go) elseif(ge>fx and ge<fx+64) then gq=true db.hc=cocreate(function(cq,cr) ee(db,cq,cr) im() end) coresume(db.hc,gd,ge-fx) end end function hi() hx=nil hz=nil hy=nil hw=nil ib=nil if ex and ex.hl then
for fu in all(ex.io) do if ip(fu) then
hw=fu end end return end iq() for ir,fk in pairs(dy.cm) do if(not fk.de
or(fk.de and fk.de!=bc)) and(not fk.cw or is(fk.cw).cp==fk.cx) then it(fk,fk.cs*8,fk.ct*8,fy,iu) else fk.iv=nil end if ip(fk) then
hy=fk end iw(fk) end for ir,ie in pairs(dt) do if ie.ef==dy then
it(ie,ie.cs*8,ie.ct*8,fy,iu) iw(ie) if ip(ie)
and ie!=db then hy=ie end end end for fn in all(f) do if ip(fn) then
hx=fn end end for ix in all(gi) do if ip(ix) then
ib=ix end end for ir,fk in pairs(db.id) do if ip(fk) then
hy=fk if gm[2]=="pickup"and hy.dv then
gm=nil end end if fk.dv!=db then
del(db.id,fk) end end if gm==nil then
gm=fp(q) end if hy then
hz=fj(hy) end end function iq() gy={} for cq=1,64 do gy[cq]={} end end function iw(fk) iy=-1 if fk.ij then
iy=fk.cr else iy=fk.cr+(fk.ct*8) end iz=flr(iy-fx) if fk.df then iz+=fk.df end
add(gy[iz],fk) end function hj() ja(dy) map(dy.bx,dy.by,0,fx,dy.jb,dy.jc) pal() for jd=1,64 do iz=gy[jd] for fk in all(iz) do if not fm(fk.de,bh) then
if(fk.w)
and fk.w[fk.cp] and(fk.w[fk.cp]>0) and(not fk.cw or is(fk.cw).cp==fk.cx) and not fk.dv then je(fk) end else if(fk.ef==dy) then
jf(fk) end end jg(fk) end end end function ja(fk) for jh in all(fk.bz) do pal(jh[1],jh[2]) end end function je(fk) ja(fk) ji=1 if fk.em then ji=fk.em end
for ct=0,ji-1 do jj(fk.w[fk.cp],fk.cq+(ct*(fk.cs*8)),fk.cr,fk.cs,fk.ct,fk.dq,fk.ek) end pal() end function jf(ie) if ie.ik==1
and ie.es then ie.jk+=1 if ie.jk>5 then
ie.jk=1 ie.jl+=1 if ie.jl>#ie.es then ie.jl=1 end
end jm=ie.es[ie.jl] else jm=ie.eq[ie.ep] end ja(ie) jj(jm,ie.ii,ie.ij,ie.cs,ie.ct,ie.dq,ie.flip,false) if gt
and gt==ie then if ie.jn<7 then
jm=ie.er[ie.ep] jj(jm,ie.ii,ie.ij+8,1,1,ie.dq,ie.flip,false) end ie.jn+=1 if ie.jn>14 then ie.jn=1 end
end pal() end function hp() jo=""jp=12 if not gq then
if gm then
jo=gm[3] end if gn then
jo=jo.." "..gn.co if gm[2]=="use"then
jo=jo.." with"elseif gm[2]=="give"then jo=jo.." to"end end if go then
jo=jo.." "..go.co elseif hy and hy.co!=""and(not gn or(gn!=hy)) then jo=jo.." "..hy.co end gp=jo else jo=gp jp=7 end print(jq(jo),jr(jo),fx+66,jp) end function hk() if gr then
js=0 for jt in all(gr.ju) do jv=0 if gr.jw==1 then
jv=((gr.jx*4)-(#jt*4))/2 end jy(jt,gr.cq+jv,gr.cr+js,gr.et) js+=6 end gr.jz-=1 if(gr.jz<=0) then
eg() end end end function hr() ka=0 iy=75 kb=0 for fn in all(f) do kc=s if hz
and(fn==hz) then kc=v end if fn==hx then kc=t end
fo=fp(fn) print(fo[3],ka,iy+fx+1,u) print(fo[3],ka,iy+fx,kc) fn.cq=ka fn.cr=iy it(fn,#fo[3]*4,5,0,0) jg(fn) if#fo[3]>kb then kb=#fo[3] end
iy=iy+8 if iy>=95 then
iy=75 ka=ka+(kb+1.0)*4 kb=0 end end ka=86 iy=76 kd=db.ic*4 ke=min(kd+8,#db.id) for kf=1,8 do rectfill(ka-1,fx+iy-1,ka+8,fx+iy+8,1) fk=db.id[kd+kf] if fk then
fk.cq=ka fk.cr=iy je(fk) it(fk,fk.cs*8,fk.ct*8,0,0) jg(fk) end ka+=11 if ka>=125 then
iy+=12 ka=86 end kf+=1 end for kg=1,2 do kh=gi[kg] if ib==kh then pal(s,7) end
jj(kh.spr,kh.cq,kh.cr,1,1,0) it(kh,8,7,0,0) jg(kh) pal() end end function hm() ka=0 iy=70 for fu in all(ex.io) do fu.cq=ka fu.cr=iy it(fu,fu.jx*4,#fu.ki*5,0,0) kc=ex.et if fu==hw then kc=ex.kj end
for jt in all(fu.ki) do print(jq(jt),ka,iy+fx,kc) iy+=5 end jg(fu) iy+=2 end end function hn() et=gg[gh] pal(7,et) spr(32,gd-4,ge-3,1,1,0) pal() gf+=1 if gf>7 then
gf=1 gh+=1 if(gh>#gg) then gh=1 end
end end function jj(kk,cq,cr,cs,ct,kl,ek,km) palt(0,false) palt(kl,true) spr(kk,cq,fx+cr,cs,ct,ek,km) palt(kl,false) palt(0,true) end function kn(ko) if type(ko)=="table"then
cq=ko.cq end fy=cq gb=nil kp=nil end function fi(ie) if type(ko)=="table"then
cq=ko.cq end e("setting cam follow to:"..type(ie)) kp=ie gb=nil gc=function() while kp do fy=mid(0,kp.cq-64,(dy.jb*8)-fv-1) yield() end end cc(gc,true) end function fg(ko) if type(ko)=="table"then
cq=ko.cq end gb=cq kp=nil gc=function() while(true) do if fy==gb-flr(fv/2) then
gb=nil return elseif gb>fy then fy+=0.5 else fy-=0.5 end yield() end end cc(gc,true) end function fh() while dx(gc) do yield() end end function eb(hq,kq,kr) e("follow:"..type(kp)) ks={hq=hq,hc=cocreate(kq),hs=kr,he=dy,hf=db,hg=kp} add(gx,ks) gs=ks kt=1 fy=0 ck() end function ev(fb) if not ex then ex={io={},hl=false} end
ki=ku(fb,32) kv=kw(ki) ez={fc=#ex.io+1,fb=fb,ki=ki,jx=kv} add(ex.io,ez) end function ew(et,kj) ex.et=et ex.kj=kj ex.hl=true ex.ey=nil end function fa() ex.hl=false end function fe() ex.io={} ex.ey=nil end function fd() ex=nil end function ih(fk) kx={} if type(fk.cv)=="table"then
kx.cq=fk.cv.cq-fy kx.cr=fk.cv.cr-fx elseif not fk.cv or fk.cv==bo then kx.cq=fk.cq+((fk.cs*8)/2)-fy-4 kx.cr=fk.cr+(fk.ct*8)+2 elseif fk.cv==bq then if fk.ii then
kx.cq=fk.cq-fy-(fk.cs*8+4) kx.cr=fk.cr+1 else kx.cq=fk.cq-fy kx.cr=fk.cr+((fk.ct*8)-2) end elseif fk.cv==br then kx.cq=fk.cq+(fk.cs*8)-fy kx.cr=fk.cr+((fk.ct*8)-2) end return kx end function da(ie,ky,kz) ie.flip=(kz==bl) if ky==bt then
ie.ep=kz elseif ky==bu then while ie.ep!=kz do if ie.ep<kz then
ie.ep+=1 else ie.ep-=1 end ck(10) end end end function dj(la,lb) if dg(la)==w.g then
cy("it's already open") else cj(la,w.g) if lb then cj(lb,w.g) end
end end function dk(la,lb) if dg(la)==w.x then
cy("it's already closed") else cj(la,w.x) if lb then cj(lb,w.x) end
end end function dh(lc,ld) le=lc.ef ed(le,ld) kx=ih(lc) db.cq=kx.cq db.cr=kx.cr if lc.cu then
lf=lc.cu+2 if lf>4 then
lf-=4 end else lf=1 end da(db,bt,lf) db.ef=le end function lg(lh,li) if li==1 then
lj=0 else lj=50 end while true do lj+=li*2 if lj>50
or lj<0 then return end if lh==1 then
gu=min(lj,32) end yield() end end function ed(le,lh) if dy and dy.cf then
dy.cf(dy) end gw={} im() e("fade down!") if lh then
lg(lh,1) end dy=le if dy.eh then
dy.jb=dy.eh-dy.bx+1 dy.jc=dy.ei-dy.by+1 else dy.jb=16 dy.jc=8 end fy=0 if dy.ca then
dy.ca(dy) end e("fade up!") if lh then
lg(lh,-1) end end function il(fr,lk) if not lk then return false end
if not lk.f then return false end
if type(fr)=="table"then
if lk.f[fr[1]] then return true end
else if lk.f[fr] then return true end
end return false end function dc(ll) fk=is(ll) if fk
then add(db.id,fk) fk.dv=db del(fk.ef.cm,fk) end end function dr(ll) fk=is(ll) if fk then
return fk.dv end end function dg(ll,cp) fk=is(ll) if fk then
return fk.cp end end function cj(ll,cp) fk=is(ll) if fk then
fk.cp=cp end end function is(co) if type(co)=="table"then return co end
for ir,fk in pairs(dy.cm) do if fk.co==co then return fk end
end end function cc(lm,ln,lo,ds) local hc=cocreate(lm) if ln then
add(gv,{lm,hc,lo,ds}) else add(gw,{lm,hc,lo,ds}) end end function dx(lm) for ir,lp in pairs(gw) do if(lp[1]==lm) then
return true end end for ir,lp in pairs(gv) do if(lp[1]==lm) then
return true end end return false end function cg(lm) for ir,lp in pairs(gw) do if(lp[1]==lm) then
del(gw,lp) lp=nil end end for ir,lp in pairs(gv) do if(lp[1]==lm) then
del(gv,lp) lp=nil end end end function ck(lq) lq=lq or 1 for cq=1,lq do yield() end end function cz() while gr!=nil do yield() end end function cy(ie,fb) if type(ie)=="string"then
fb=ie ie=db end iy=ie.cr-(ie.ct)*8+4 gt=ie ec(fb,ie.cq,iy,ie.et,1) end function eg() gr=nil gt=nil end function ec(fb,cq,cr,et,jw) local et=et or 7 local jw=jw or 0 e(fb) local ki={} local lr=""local lt=""kv=0 lu=min(cq-fy,fv-(cq-fy)) lv=max(flr(lu/2),16) e("screen_space:"..lu) lt=""for kg=1,#fb do lr=sub(fb,kg,kg) if lr==";"then
lt=sub(fb,kg+1) fb=sub(fb,1,kg-1) break end end ki=ku(fb,lv,true) kv=kw(ki) if jw==1 then
ka=cq-fy-((kv*4)/2) end ka=max(2,ka) iy=max(18,cr) ka=min(ka,fv-(kv*4)-1) gr={ju=ki,cq=ka,cr=iy,et=et,jw=jw,jz=(#fb)*8,jx=kv} if(#lt>0) then
lw=gt cz() gt=lw ec(lt,cq,cr,et,jw) end end function ee(ie,cq,cr) cq=cq+fy lx=ly(ie) lz=flr(cq/8)+dy.bx ma=flr(cr/8)+dy.by mb={lz,ma} mc=md(lx,mb) me=ly({cq=cq,cr=cr}) if mf(me[1],me[2]) then
add(mc,me) end for mg in all(mc) do mh=(mg[1]-dy.bx)*8+4 mi=(mg[2]-dy.by)*8+4 local mj=sqrt((mh-ie.cq)^2+(mi-ie.cr)^2) local mk=ie.eu*(mh-ie.cq)/mj local ml=ie.eu*(mi-ie.cr)/mj if mj>1 then
ie.ik=1 ie.flip=(mk<0) ie.ep=bn if(ie.flip) then ie.ep=bl end
for kg=0,mj/ie.eu do ie.cq=ie.cq+mk ie.cr=ie.cr+ml yield() end end end ie.ik=2 end function gz() for mm,mn in pairs(bv) do for mo,fk in pairs(mn.cm) do fk.ef=mn end end for mp,ie in pairs(dt) do ie.ik=2 ie.jk=1 ie.jn=1 ie.jl=1 ie.id={} ie.ic=0 end end function jg(fk) if b and fk.iv then
rect(fk.iv.cq,fk.iv.cr,fk.iv.mq,fk.iv.mr,8) end end function hd(cd) for lp in all(cd) do if lp[2] and not coresume(lp[2],lp[3],lp[4]) then
del(cd,lp) lp=nil end end end function ms(cq,cr) lz=flr(cq/8)+dy.bx ma=flr(cr/8)+dy.by mt=mf(lz,ma) return mt end function ly(fk) lz=flr(fk.cq/8)+dy.bx ma=flr(fk.cr/8)+dy.by return{lz,ma} end function mf(lz,ma) mu=mget(lz,ma) mt=fget(mu,0) return mt end function ia(fk) mv={} for ir,fn in pairs(fk) do add(mv,ir) end return mv end function fp(fk) fr={} mv=ia(fk[1]) add(fr,mv[1]) add(fr,fk[1][mv[1]]) add(fr,fk.h) return fr end function ku(fb,lv,mw) local ki={} local mx=""local my=""local lr=""local mz=function(na) if#my+#mx>na then
add(ki,mx) mx=""end mx=mx..my my=""end for kg=1,#fb do lr=sub(fb,kg,kg) my=my..lr if(lr==" ")
or(#my>lv-1) then mz(lv) elseif#my>lv-1 then my=my.."-"mz(lv) elseif lr==","and mw then e("line break!") mx=mx..sub(my,1,#my-1) my=""mz(0) end end mz(lv) if mx!=""then
add(ki,mx) end return ki end function kw(ki) kv=0 for jt in all(ki) do if#jt>kv then kv=#jt end
end return kv end function fm(fk,nb) if band(fk,nb)!=0 then return true end
return false end function im() gm=fp(q) gn=nil go=nil cb=nil gq=false gp=""e("command wiped") end function it(fk,cs,ct,nc,nd) cq=fk.cq cr=fk.cr if fm(fk.de,bh) then
fk.ii=fk.cq-(fk.cs*8)/2 fk.ij=fk.cr-(fk.ct*8)+1 cq=fk.ii cr=fk.ij end fk.iv={cq=cq,cr=cr+fx,mq=cq+cs-1,mr=cr+ct+fx-1,nc=nc,nd=nd} end function md(ne,nf) ng={} nh(ng,ne,0) ni={} ni[nj(ne)]=nil nk={} nk[nj(ne)]=0 while#ng>0 and#ng<1000 do local nl=ng[#ng] del(ng,ng[#ng]) nm=nl[1] if nj(nm)==nj(nf) then
break end local nn={} for cq=-1,1 do for cr=-1,1 do if cq==0 and cr==0 then
else no=nm[1]+cq np=nm[2]+cr if abs(cq)!=abs(cr) then nq=1 else nq=1.4 end
if no>=dy.bx and no<=dy.bx+dy.jb
and np>=dy.by and np<=dy.by+dy.jc and mf(no,np) and((abs(cq)!=abs(cr)) or mf(no,nm[2]) or mf(no-cq,np)) then add(nn,{no,np,nq}) end end end end for nr in all(nn) do local ns=nj(nr) local nt=nk[nj(nm)]+nr[3] if(nk[ns]==nil) or(nt<nk[ns]) then
nk[ns]=nt local nu=nt+max(abs(nf[1]-nr[1]),abs(nf[2]-nr[2])) nh(ng,nr,nu) ni[ns]=nm end end end mc={} nm=ni[nj(nf)] if nm then
local nv=nj(nm) local nw=nj(ne) while nv!=nw do add(mc,nm) nm=ni[nv] nv=nj(nm) end for kg=1,#mc/2 do local nx=mc[kg] local ny=#mc-(kg-1) mc[kg]=mc[ny] mc[ny]=nx end end return mc end function nh(nz,ko,mg) if#nz>=1 then
add(nz,{}) for kg=(#nz),2,-1 do local nr=nz[kg-1] if mg<nr[2] then
nz[kg]={ko,mg} return else nz[kg]=nr end end nz[1]={ko,mg} else add(nz,{ko,mg}) end end function nj(oa) return((oa[1]+1)*16)+oa[2] end function jy(ob,cq,cr,oc,od) local oc=oc or 7 local od=od or 0 ob=jq(ob) for oe=-1,1 do for of=-1,1 do print(ob,cq+oe,cr+of,od) end end print(ob,cq,cr,oc) end function jr(fu) return(fv/2)-flr((#fu*4)/2) end function og(fu) return(fw/2)-flr(5/2) end function ip(fk) if not fk.iv then return false end
iv=fk.iv if(gd+iv.nc>iv.mq or gd+iv.nc<iv.cq)
or(ge>iv.mr or ge<iv.cr) then return false else return true end end function jq(fu) local e=""local jt,jh,nz=false,false for kg=1,#fu do local ix=sub(fu,kg,kg) if ix=="^"then
if(jh) then e=e..ix end
jh=not jh elseif ix=="~"then if(nz) then e=e..ix end
nz,jt=not nz,not jt else if jh==jt and ix>="a"and ix<="z"then
for oh=1,26 do if ix==sub("abcdefghijklmnopqrstuvwxyz",oh,oh) then
ix=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",oh,oh) break end end end e=e..ix jh,nz=false,false end end return e end
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

