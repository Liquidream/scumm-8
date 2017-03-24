pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
a=false b=false c=false d=true e=printh f={{{g="open"},h="open"},{{i="close"},h="close"},{{j="give"},h="give"},{{k="pickup"},h="pick-up"},{{l="lookat"},h="look-at"},{{m="talkto"},h="talk-to"},{{n="push"},h="push"},{{o="pull"},h="pull"},{{p="use"},h="use"}} q={{r="walkto"},h="walk to"} s=12 t=7 u=1 v=10 w=1 x=2 y=1 z=2 ba=1 bb=2 bc=1 bd=2 be=4 bf=8 bg=16 bh=32 bi=1 bj=2 bk=4 bl=1 bm=2 bn=3 bo=4 bp=1 bq=3 br=2 bs=4 bt=5 bu=1 bv={bw={bx=0,by=0,bz={{7,15},},ca=function(cb) cc(cb.cd.ce,true) end,cf=function(cb) cg(cb.cd.ce) end,ch=0,cd={ce=function() while true do for ci=1,3 do cj("fire",ci) ck(8) end end end,cl=function() cm=-1 while true do for cn=1,3 do for ci=1,3 do cj("spinning top",ci) ck(4) end co=cp("spinning top") co.cn-=cm end cm*=-1 end end},cq={cr={cs="fire",ct=1,cn=8*8,cu=4*8,cv={145,146,147},cw=1,cx=1,cy="front door",cz=x,f={l=function() da("it's a nice, warm fire...") db() ck(10) dc(dd,bu,bl) da("ouch! it's hot!;*stupid fire*") db() end,m=function() da("'hi fire...'") db() ck(10) dc(dd,bu,bl) da("the fire didn't say hello back;burn!!") db() end,k=function(cb) de(cb) end,}},df={cs="front door",dg=bg,ct=w,cn=1*8,cu=2*8,dh=-10,cv={143,0},cw=1,cx=4,di=bs,dj=bm,f={r=function(cb) if dk(cb)==x then
dl(bv.dm.cq.df) else da("the door is closed") end end,g=function(cb) dn(cb,bv.dm.cq.df) end,i=function(cb) dp(cb,bv.dm.cq.df) end}},dq={cs="kitchen",ct=x,cn=14*8,cu=2*8,cw=1,cx=4,di=br,dj=bo,f={r=function() dl(bv.dr.cq.ds) end}},dt={cs="bucket",dg=bd,ct=x,cn=13*8,cu=6*8,cw=1,cx=1,cv={207,223},du=15,f={l=function(cb) if dv(cb)==dd then
da("it is a bucket in my pocket") else da("it is a bucket") end end,k=function(cb) de(cb) end,j=function(cb,dw) if dw==dx.dy then
da("can you fill this up for me?") db() da(dx.dy,"sure") db() cb.dz=dx.dy ck(30) da(dx.dy,"here ya go...") db() cb.ct=w cb.cs="full bucket"de(cb) else da("i might need this") end end}},ea={cs="spinning top",ct=1,cn=2*8,cu=6*8,cv={192,193,194},bz={{12,7}},du=15,cw=1,cx=1,f={n=function(cb) if eb(ec.cd.cl) then
cg(ec.cd.cl) cj(cb,1) else cc(ec.cd.cl) end end,o=function(cb) cg(ec.cd.cl) cj(cb,1) end}},ed={cs="window",dg=bg,ct=w,di={cn=5*8,cu=(7*8)+1},cn=4*8,cu=1*8,cw=2,cx=2,cv={132,134},f={g=function(cb) if not cb.ee then
ef(bi+bj,function() cb.ee=true eg("*bang*",40,20,8,1) cj(cb,x) db() eh(bv.dr,1) dd=dx.dy ei(dd,dd.cn+10,dd.cu) da("what was that?!") db() da("i'd better check...") db() ei(dd,dd.cn-10,dd.cu) eh(bv.bw,1) ck(50) ej(dd,115,44,bv.bw) ei(dd,dd.cn-10,dd.cu) da("intruder!!!") dc(dx.ek,bu,dx.dy) db() end,function() eh(bv.bw) ej(dx.dy,105,44,bv.bw) el() dc(dx.ek,bu,dx.dy) end) end end}}}},dr={bx=16,by=0,em=39,en=7,ca=function() end,cf=function() end,cd={},cq={ds={cs="hall",ct=x,cn=1*8,cu=2*8,cw=1,cx=4,di=bs,dj=bm,f={r=function() dl(bv.bw.cq.dq) end}},eo={cs="back door",dg=bg,ct=w,cn=22*8,cu=2*8,dh=-10,cv={143,0},ep=true,cw=1,cx=4,di=br,dj=bo,f={r=function(cb) if dk(cb)==x then
dl(bv.bw.cq.df) else da("the door is closed") end end,g=function(cb) dn(cb,bv.bw.cq.df) end,i=function(cb) dp(cb,bv.bw.cq.df) end}},},},dm={bx=16,by=8,em=47,en=15,ca=function(cb) if not cb.eq then
cb.eq=true dd=dx.ek ej(dd,144,36,bv.dm) er(dd) ef(bi+bj,function() es(0) et(dd) eu() da("let's do this") db() end) end end,cf=function(cb) end,cd={},cq={ev={dg=bc,cn=10*8,cu=3*8,ct=1,cv={111},cw=1,cx=2,ew=8},ex={dg=bc,cn=22*8,cu=3*8,ct=1,cv={111},cw=1,cx=2,ew=8},df={cs="front door",dg=bg,ct=w,cn=19*8,cu=1*8,cv={142,0},ep=true,cw=1,cx=3,dj=bn,f={r=function(cb) if dk(cb)==x then
dl(bv.bw.cq.df) else da("the door is closed") end end,g=function(cb) dn(cb,bv.bw.cq.df) end,i=function(cb) dp(cb,bv.bw.cq.df) end}},},}} dx={ek={dg=bh,cw=1,cx=4,ey=bl,ez={1,3,5,3},fa={6,22,21,22},fb={2,3,4,3},fc=12,du=11,fd=0.6,},dy={cs="purple tentacle",dg=be+bh,cn=127/2-24,cu=127/2-16,cw=1,cx=3,ey=bl,ez={30,30,30,30},fa={47,47,47,47},fc=13,du=15,fd=0.25,di=br,fe=bv.dr,f={l=function() da("it's a weird looking tentacle, thing!") end,m=function(cb) ef(bi,function() da(cb,"what do you want?") db() end) while(true) do ff("where am i?") ff("who are you?") ff("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?") ff("nevermind") fg(dd.fc,7) while not fh.fi do ck() end fj=fh.fi fk() ef(bi,function() da(fj.fl) db() if fj.fm==1 then
da(cb,"you are in paul's game") db() elseif fj.fm==2 then da(cb,"it's complicated...") db() elseif fj.fm==3 then da(cb,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!") db() elseif fj.fm==4 then da(cb,"ok bye!") db() fn() return end end) fo() end end}}} function fp() eh(bv.dm,1) end function fq(fr) local fs=nil if ft(fr.dg,be) then
fs="talkto"elseif ft(fr.dg,bg) then if fr.ct==w then
fs="open"else fs="close"end else fs="lookat"end for fu in all(f) do fv=fw(fu) if fv[2]==fs then fs=fu break end
end return fs end function fx(fy,fz,ga) if fy=="walkto"then
return elseif fy=="pickup"then if ft(fz.dg,bh) then
da("i don't need them") else da("i don't need that") end elseif fy=="use"then if ft(fz.dg,bh) then
da("i can't just *use* someone") end if ga then
if ft(ga.dg,bh) then
da("i can't use that on someone!") else da("that doesn't work") end end elseif fy=="give"then if ft(fz.dg,bh) then
da("i don't think i should be giving this away") else da("i can't do that") end elseif fy=="lookat"then if ft(fz.dg,bh) then
da("i think it's alive") else da("looks pretty ordinary") end elseif fy=="open"then if ft(fz.dg,bh) then
da("they don't seem to open") else da("it doesn't seem to open") end elseif fy=="close"then if ft(fz.dg,bh) then
da(gb"they don't seem to close") else da("it doesn't seem to close") end elseif fy=="push"or fy=="pull"then if ft(fz.dg,bh) then
da("moving them would accomplish nothing") else da("it won't budge!") end elseif fy=="talkto"then if ft(fz.dg,bh) then
da("erm... i don't think they want to talk") else da("i am not talking to that!") end else da("hmm. no.") end end function es(gc) if type(gc)=="table"then
gc=gc.cn end gd=mid(0,gc-64,(ec.ge*8)-gf-1) gg=nil gh=nil end function er(gi) gh=gi gg=nil gj=function() while gh do gd=mid(0,gh.cn-64,(ec.ge*8)-gf-1) yield() end end cc(gj,true) end function et(gc) if type(gc)=="table"then
cn=gc.cn end gg=cn gh=nil gj=function() while(true) do gk=gd+flr(gf/2)+1 if gk==gg then
gg=nil return elseif gg>gk then gd+=0.5 else gd-=0.5 end gd=mid(0,gd,(ec.ge*8)-gf-1) yield() end end cc(gj,true) end function eu() while eb(gj) do yield() end end function ef(gl,gm,gn) go={gl=gl,gp=cocreate(gm),gq=gn,gr=ec,gs=dd,gt=gh} add(gu,go) gv=go ck() end function ff(fl) if not fh then fh={gw={},gx=false} end
gy=gz(fl,32) ha=hb(gy) fj={fm=#fh.gw+1,fl=fl,gy=gy,hc=ha} add(fh.gw,fj) end function fg(fc,hd) fh.fc=fc fh.hd=hd fh.gx=true fh.fi=nil end function fk() fh.gx=false end function fo() fh.gw={} fh.fi=nil end function fn() fh=nil end function he(fr) hf=fr.di if type(hf)=="table"then
cn=hf.cn-gd cu=hf.cu-hg elseif not hf or hf==bp then cn=fr.cn+((fr.cw*8)/2)-gd-4 cu=fr.cu+(fr.cx*8)+2 elseif hf==br then if fr.hh then
cn=fr.cn-gd-(fr.cw*8+4) cu=fr.cu+1 else cn=fr.cn-gd-2 cu=fr.cu+((fr.cx*8)-2) end elseif hf==bs then cn=fr.cn+(fr.cw*8)-gd cu=fr.cu+((fr.cx*8)-2) end return{cn=cn,cu=cu} end function dc(gi,hi,hj) if hi==bu then
if type(hj)=="table"then
hk=atan2(gi.cn-hj.cn,hj.cu-gi.cu) hl=93*(3.1415/180) hk=hl-hk hm=hk*(1130.938/3.1415) hm=hm%360 if(hm<0) then hm+=360 end
hj=4-flr(hm/90) end while gi.ey!=hj do if gi.ey<hj then
gi.ey+=1 else gi.ey-=1 end gi.flip=(gi.ey==bm) ck(10) end end end function dn(hn,ho) if dk(hn)==x then
da("it's already open") else cj(hn,x) if ho then cj(ho,x) end
end end function dp(hn,ho) if dk(hn)==w then
da("it's already closed") else cj(hn,w) if ho then cj(ho,w) end
end end function dl(hp,hq) hr=hp.fe gd=0 eh(hr,hq) hs=he(hp) ej(dd,hs.cn,hs.cu,hr) if hp.dj then
ht=hp.dj+2 if ht>4 then
ht-=4 end else ht=1 end dd.ey=ht end function hu(hv,cm) if cm==1 then
hw=0 else hw=50 end while true do hw+=cm*2 if hw>50
or hw<0 then return end if hv==1 then
hx=min(hw,32) end yield() end end function eh(hr,hv) if hv and ec then
hu(hv,1) end if ec and ec.cf then
ec.cf(ec) end hy={} hz() ec=hr el() if hv then
cc(function() hu(hv,-1) end,true) else hx=0 end if ec.ca then
ec.ca(ec) end end function ia(fy,ib) if not ib then return false end
if not ib.f then return false end
if type(fy)=="table"then
if ib.f[fy[1]] then return true end
else if ib.f[fy] then return true end
end return false end function de(ic) fr=cp(ic) if fr
then add(dd.id,fr) fr.dz=dd del(fr.fe.cq,fr) end end function dv(ic) fr=cp(ic) if fr then
return fr.dz end end function dk(ic,ct) fr=cp(ic) if fr then
return fr.ct end end function cj(ic,ct) fr=cp(ic) if fr then
fr.ct=ct end end function cp(cs) if type(cs)=="table"then return cs end
for ie,fr in pairs(ec.cq) do if fr.cs==cs then return fr end
end end function cc(ig,ih,ii,dw) local gp=cocreate(ig) if ih then
add(ij,{ig,gp,ii,dw}) else add(hy,{ig,gp,ii,dw}) end end function eb(ig) for ie,ik in pairs(hy) do if(ik[1]==ig) then
return ik end end for ie,ik in pairs(ij) do if(ik[1]==ig) then
return ik end end return false end function cg(ig) ik=eb(ig) if ik then
del(hy,ik) del(ij,ik) end end function ck(il) il=il or 1 for cn=1,il do yield() end end function db() while im!=nil do yield() end end function da(gi,fl) if type(gi)=="string"then
fl=gi gi=dd end io=gi.cu-(gi.cx)*8+4 ip=gi eg(fl,gi.cn,io,gi.fc,1) end function el() im=nil ip=nil end function eg(fl,cn,cu,fc,iq) local fc=fc or 7 local iq=iq or 0 local gy={} local ir=""local is=""ha=0 it=min(cn-gd,gf-(cn-gd)) iu=max(flr(it/2),16) is=""for iv=1,#fl do ir=sub(fl,iv,iv) if ir==";"then
is=sub(fl,iv+1) fl=sub(fl,1,iv-1) break end end gy=gz(fl,iu,true) ha=hb(gy) if iq==1 then
iw=cn-gd-((ha*4)/2) end iw=max(2,iw) io=max(18,cu) iw=min(iw,gf-(ha*4)-1) im={ix=gy,cn=iw,cu=io,fc=fc,iq=iq,iy=(#fl)*8,hc=ha} if(#is>0) then
iz=ip db() ip=iz eg(is,cn,cu,fc,iq) end end function ej(gi,cn,cu,ja) if ja then gi.fe=ja end
gi.cn=cn gi.cu=cu end function ei(gi,cn,cu) cn=cn+gd jb=jc(gi) jd=flr(cn/8)+ec.bx je=flr(cu/8)+ec.by jf={jd,je} jg=jh(jb,jf) ji=jc({cn=cn,cu=cu}) if jj(ji[1],ji[2]) then
add(jg,ji) end for jk in all(jg) do jl=(jk[1]-ec.bx)*8+4 jm=(jk[2]-ec.by)*8+4 local jn=sqrt((jl-gi.cn)^2+(jm-gi.cu)^2) local jo=gi.fd*(jl-gi.cn)/jn local jp=gi.fd*(jm-gi.cu)/jn if jn>1 then
gi.jq=1 gi.flip=(jo<0) gi.ey=bo if(gi.flip) then gi.ey=bm end
for iv=0,jn/gi.fd do gi.cn=gi.cn+jo gi.cu=gi.cu+jp yield() end end end gi.jq=2 end gf=127 jr=127 hg=16 gd=0 gg=nil gj=nil js=gf/2 jt=jr/2 ju=0 jv={7,12,13,13,12,7} jw=1 jx={{spr=16,cn=75,cu=hg+60},{spr=48,cn=75,cu=hg+72}} jy=0 jz=0 ka=false ec=nil kb=nil kc=nil kd=nil ke=""kf=false im=nil fh=nil gv=nil ip=nil hx=0 ij={} hy={} gu={} kg={} function _init() if d then poke(0x5f2d,1) end
kh() cc(fp,true) end function _update60() ki() end function _draw() kj() end function ki() if dd and dd.gp and not coresume(dd.gp) then
dd.gp=nil end kk(ij) if gv then
if gv.gp and not coresume(gv.gp) then
if(ec!=gv.gr) then eh(gv.gr) end
dd=gv.gs er(gv.gt) del(gu,gv) gv=nil if#gu>0 then
gv=gu[#gu] end end else kk(hy) end kl() km() end function kj() rectfill(0,0,gf,jr,0) camera(gd,0) clip(0+hx,hg+hx,gf+1-hx*2,64-hx*2) kn() camera(0,0) clip() if c then
print("cpu: "..flr(100*stat(1)).."%",0,hg-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,hg-8,8) end if a then
print("x: "..js.." y:"..jt-hg,80,hg-8,8) end ko() if fh and fh.gx then
kp() kq() return end if kr==gv then
else kr=gv return end if not gv then
ks() end if(not gv
or not ft(gv.gl,bi)) and(kr==gv) then kt() else end kr=gv if not gv then
kq() end end function kl() if gv then
if btnp(4) and btnp(5) and gv.gq then
gv.gp=cocreate(gv.gq) gv.gq=nil return end return end if btn(0) then js-=1 end
if btn(1) then js+=1 end
if btn(2) then jt-=1 end
if btn(3) then jt+=1 end
if btnp(4) then ku(1) end
if btnp(5) then ku(2) end
if d then
if stat(32)-1!=jy then js=stat(32)-1 end
if stat(33)-1!=jz then jt=stat(33)-1 end
if stat(34)>0 then
if not ka then
ku(stat(34)) ka=true end else ka=false end jy=stat(32)-1 jz=stat(33)-1 end js=max(js,0) js=min(js,127) jt=max(jt,0) jt=min(jt,127) end function ku(kv) local kw=kb if fh and fh.gx then
if kx then
fh.fi=kx end return end if ky then
kb=fw(ky) elseif kz then if kv==1 then
if(kb[2]=="use"or kb[2]=="give")
and kc then kd=kz else kc=kz end elseif la then kb=fw(la) kc=kz lb(kc) ks() end elseif lc then if lc==jx[1] then
if dd.ld>0 then
dd.ld-=1 end else if dd.ld+2<flr(#dd.id/4) then
dd.ld+=1 end end return end if(kc!=nil) then
if kb[2]=="use"or kb[2]=="give"then
if kd then
else return end end kf=true dd.gp=cocreate(function(gi,fr,fy,dw) if not fr.dz then
le=he(fr) ei(dd,le.cn,le.cu) if dd.jq!=2 then return end
dj=fr if fr.dj and fy!=q then dj=fr.dj end
dc(dd,bu,dj) end if ia(fy,fr) then
cc(fr.f[fy[1]],false,fr,dw) else fx(fy[2],fr,dw) end hz() end) coresume(dd.gp,dd,kc,kb,kd) elseif(jt>hg and jt<hg+64) then kf=true dd.gp=cocreate(function(cn,cu) ei(dd,cn,cu) hz() end) coresume(dd.gp,js,jt-hg) end end function km() ky=nil la=nil kz=nil kx=nil lc=nil if fh and fh.gx then
for gb in all(fh.gw) do if lf(gb) then
kx=gb end end return end lg() for ie,fr in pairs(ec.cq) do if(not fr.dg
or(fr.dg and fr.dg!=bc)) and(not fr.cy or cp(fr.cy).ct==fr.cz) then lh(fr,fr.cw*8,fr.cx*8,gd,li) else fr.lj=nil end if lf(fr) then
kz=fr end lk(fr) end for ie,gi in pairs(dx) do if gi.fe==ec then
lh(gi,gi.cw*8,gi.cx*8,gd,li) lk(gi) if lf(gi)
and gi!=dd then kz=gi end end end for fu in all(f) do if lf(fu) then
ky=fu end end for ll in all(jx) do if lf(ll) then
lc=ll end end for ie,fr in pairs(dd.id) do if lf(fr) then
kz=fr if kb[2]=="pickup"and kz.dz then
kb=nil end end if fr.dz!=dd then
del(dd.id,fr) end end if kb==nil then
kb=fw(q) end if kz then
la=fq(kz) end end function lg() kg={} for cn=1,64 do kg[cn]={} end end function lk(fr) io=-1 if fr.lm then
io=fr.cu else io=fr.cu+(fr.cx*8) end ln=flr(io-hg) if fr.dh then ln+=fr.dh end
add(kg[ln],fr) end function kn() lo(ec) map(ec.bx,ec.by,0,hg,ec.ge,ec.lp) pal() for lq=1,64 do ln=kg[lq] for fr in all(ln) do if not ft(fr.dg,bh) then
if(fr.cv)
and fr.cv[fr.ct] and(fr.cv[fr.ct]>0) and(not fr.cy or cp(fr.cy).ct==fr.cz) and not fr.dz then lr(fr) end else if(fr.fe==ec) then
lt(fr) end end lu(fr) end end end function lo(fr) for lv in all(fr.bz) do pal(lv[1],lv[2]) end end function lr(fr) lo(fr) lw=1 if fr.ew then lw=fr.ew end
for cx=0,lw-1 do lx(fr.cv[fr.ct],fr.cn+(cx*(fr.cw*8)),fr.cu,fr.cw,fr.cx,fr.du,fr.ep) end pal() end function lt(gi) if gi.jq==1
and gi.fb then gi.ly+=1 if gi.ly>5 then
gi.ly=1 gi.lz+=1 if gi.lz>#gi.fb then gi.lz=1 end
end ma=gi.fb[gi.lz] else ma=gi.ez[gi.ey] end lo(gi) lx(ma,gi.hh,gi.lm,gi.cw,gi.cx,gi.du,gi.flip,false) if ip
and ip==gi then if gi.mb<7 then
ma=gi.fa[gi.ey] lx(ma,gi.hh,gi.lm+8,1,1,gi.du,gi.flip,false) end gi.mb+=1 if gi.mb>14 then gi.mb=1 end
end pal() end function ks() mc=""md=12 if not kf then
if kb then
mc=kb[3] end if kc then
mc=mc.." "..kc.cs if kb[2]=="use"then
mc=mc.." with"elseif kb[2]=="give"then mc=mc.." to"end end if kd then
mc=mc.." "..kd.cs elseif kz and kz.cs!=""and(not kc or(kc!=kz)) then mc=mc.." "..kz.cs end ke=mc else mc=ke md=7 end print(me(mc),mf(mc),hg+66,md) end function ko() if im then
mg=0 for mh in all(im.ix) do mi=0 if im.iq==1 then
mi=((im.hc*4)-(#mh*4))/2 end mj(mh,im.cn+mi,im.cu+mg,im.fc) mg+=6 end im.iy-=1 if(im.iy<=0) then
el() end end end function kt() iw=0 io=75 mk=0 for fu in all(f) do ml=s if la
and(fu==la) then ml=v end if fu==ky then ml=t end
fv=fw(fu) print(fv[3],iw,io+hg+1,u) print(fv[3],iw,io+hg,ml) fu.cn=iw fu.cu=io lh(fu,#fv[3]*4,5,0,0) lu(fu) if#fv[3]>mk then mk=#fv[3] end
io=io+8 if io>=95 then
io=75 iw=iw+(mk+1.0)*4 mk=0 end end iw=86 io=76 mm=dd.ld*4 mn=min(mm+8,#dd.id) for mo=1,8 do rectfill(iw-1,hg+io-1,iw+8,hg+io+8,1) fr=dd.id[mm+mo] if fr then
fr.cn=iw fr.cu=io lr(fr) lh(fr,fr.cw*8,fr.cx*8,0,0) lu(fr) end iw+=11 if iw>=125 then
io+=12 iw=86 end mo+=1 end for iv=1,2 do mp=jx[iv] if lc==mp then pal(s,7) end
lx(mp.spr,mp.cn,mp.cu,1,1,0) lh(mp,8,7,0,0) lu(mp) pal() end end function kp() iw=0 io=70 for gb in all(fh.gw) do gb.cn=iw gb.cu=io lh(gb,gb.hc*4,#gb.gy*5,0,0) ml=fh.fc if gb==kx then ml=fh.hd end
for mh in all(gb.gy) do print(me(mh),iw,io+hg,ml) io+=5 end lu(gb) io+=2 end end function kq() fc=jv[jw] pal(7,fc) spr(32,js-4,jt-3,1,1,0) pal() ju+=1 if ju>7 then
ju=1 jw+=1 if(jw>#jv) then jw=1 end
end end function lx(mq,cn,cu,cw,cx,mr,ep,ms) palt(0,false) palt(mr,true) spr(mq,cn,hg+cu,cw,cx,ep,ms) pal() end function kh() for mt,ja in pairs(bv) do if ja.em then
ja.ge=ja.em-ja.bx+1 ja.lp=ja.en-ja.by+1 else ja.ge=16 ja.lp=8 end for mu,fr in pairs(ja.cq) do fr.fe=ja end end for mv,gi in pairs(dx) do gi.jq=2 gi.ly=1 gi.mb=1 gi.lz=1 gi.id={} gi.ld=0 end end function lu(fr) if b and fr.lj then
rect(fr.lj.cn,fr.lj.cu,fr.lj.mw,fr.lj.mx,8) end end function kk(cd) for ik in all(cd) do if ik[2] and not coresume(ik[2],ik[3],ik[4]) then
del(cd,ik) ik=nil end end end function my(cn,cu) jd=flr(cn/8)+ec.bx je=flr(cu/8)+ec.by mz=jj(jd,je) return mz end function jc(fr) jd=flr(fr.cn/8)+ec.bx je=flr(fr.cu/8)+ec.by return{jd,je} end function jj(jd,je) na=mget(jd,je) mz=fget(na,0) return mz end function lb(fr) nb={} for ie,fu in pairs(fr) do add(nb,ie) end return nb end function fw(fr) fy={} nb=lb(fr[1]) add(fy,nb[1]) add(fy,fr[1][nb[1]]) add(fy,fr.h) return fy end function gz(fl,iu,nc) local gy={} local nd=""local ne=""local ir=""local nf=function(ng) if#ne+#nd>ng then
add(gy,nd) nd=""end nd=nd..ne ne=""end for iv=1,#fl do ir=sub(fl,iv,iv) ne=ne..ir if(ir==" ")
or(#ne>iu-1) then nf(iu) elseif#ne>iu-1 then ne=ne.."-"nf(iu) elseif ir==","and nc then nd=nd..sub(ne,1,#ne-1) ne=""nf(0) end end nf(iu) if nd!=""then
add(gy,nd) end return gy end function hb(gy) ha=0 for mh in all(gy) do if#mh>ha then ha=#mh end
end return ha end function ft(fr,nh) if band(fr,nh)!=0 then return true end
return false end function hz() kb=fw(q) kc=nil kd=nil cb=nil kf=false ke=""end function lh(fr,cw,cx,ni,nj) cn=fr.cn cu=fr.cu if ft(fr.dg,bh) then
fr.hh=fr.cn-(fr.cw*8)/2 fr.lm=fr.cu-(fr.cx*8)+1 cn=fr.hh cu=fr.lm end fr.lj={cn=cn,cu=cu+hg,mw=cn+cw-1,mx=cu+cx+hg-1,ni=ni,nj=nj} end function jh(nk,nl) nm={} nn(nm,nk,0) no={} no[np(nk)]=nil nq={} nq[np(nk)]=0 while#nm>0 and#nm<1000 do local co=nm[#nm] del(nm,nm[#nm]) nr=co[1] if np(nr)==np(nl) then
break end local ns={} for cn=-1,1 do for cu=-1,1 do if cn==0 and cu==0 then
else nt=nr[1]+cn nu=nr[2]+cu if abs(cn)!=abs(cu) then nv=1 else nv=1.4 end
if nt>=ec.bx and nt<=ec.bx+ec.ge
and nu>=ec.by and nu<=ec.by+ec.lp and jj(nt,nu) and((abs(cn)!=abs(cu)) or jj(nt,nr[2]) or jj(nt-cn,nu)) then add(ns,{nt,nu,nv}) end end end end for nw in all(ns) do local nx=np(nw) local ny=nq[np(nr)]+nw[3] if(nq[nx]==nil) or(ny<nq[nx]) then
nq[nx]=ny local nz=ny+max(abs(nl[1]-nw[1]),abs(nl[2]-nw[2])) nn(nm,nw,nz) no[nx]=nr end end end jg={} nr=no[np(nl)] if nr then
local oa=np(nr) local ob=np(nk) while oa!=ob do add(jg,nr) nr=no[oa] oa=np(nr) end for iv=1,#jg/2 do local oc=jg[iv] local od=#jg-(iv-1) jg[iv]=jg[od] jg[od]=oc end end return jg end function nn(oe,gc,jk) if#oe>=1 then
add(oe,{}) for iv=(#oe),2,-1 do local nw=oe[iv-1] if jk<nw[2] then
oe[iv]={gc,jk} return else oe[iv]=nw end end oe[1]={gc,jk} else add(oe,{gc,jk}) end end function np(of) return((of[1]+1)*16)+of[2] end function mj(og,cn,cu,oh,oi) local oh=oh or 7 local oi=oi or 0 og=me(og) for oj=-1,1 do for ok=-1,1 do print(og,cn+oj,cu+ok,oi) end end print(og,cn,cu,oh) end function mf(gb) return(gf/2)-flr((#gb*4)/2) end function ol(gb) return(jr/2)-flr(5/2) end function lf(fr) if not fr.lj then return false end
lj=fr.lj if(js+lj.ni>lj.mw or js+lj.ni<lj.cn)
or(jt>lj.mx or jt<lj.cu) then return false else return true end end function me(gb) local e=""local mh,lv,oe=false,false for iv=1,#gb do local ll=sub(gb,iv,iv) if ll=="^"then
if(lv) then e=e..ll end
lv=not lv elseif ll=="~"then if(oe) then e=e..ll end
oe,mh=not oe,not mh else if lv==mh and ll>="a"and ll<="z"then
for om=1,26 do if ll==sub("abcdefghijklmnopqrstuvwxyz",om,om) then
ll=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",om,om) break end end end e=e..ll lv,oe=false,false end end return e end
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
ffffffffffffffffffffffff9f9f9fef77776000000677779f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefffffffffffffffffffffffff
ffffffff00000000fffffffff9e9f9f97006600004944497f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9f9e9f9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9eee9f9f70606000494444499eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9fffffffff00000000ffffffff
ffffffff00000000fffffffffeeef9f97050600049440004feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9ffffffff00000000ffffffff
ffffffff00000000ffffffff9fef9fef700060000440fff79fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fef9fefff7fffff00000000ffffffff
ffffffff00000000fffffffff9f9feee7005000004f0f9f7f9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeeff7fffff00000000ffffffff
ffffffff00000000ffffffff9f9f9eee7050000000fff5f79f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eee9f9f9eeeff7fffff00000000ffffffff
ffffffff00000000fffffffff9f9feee7500000040fffffff9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9feeef9f9fee777f777ff00000000ffffffff
ffffffff00000000ffffffff9f9f9fef5555555550fffff49f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fef9f9f9fefff7fffff00000000ffffffff
ffffffff00000000ffffffff999999999999999996fffff999999999ffffffffffffffffffffffff999999999999999999999999ff7fffff00000000ffffffff
ffffffff00000000ffffffff5555555555555555556fffd555555555555555555555555555555555555555555555555555555555ff7fffff00000000ffffffff
ffffffff00000000ffffffff4444444444444444444ff444444444440dd6dd6dd6dd6dd6d6dd6d50444444444444444444444444ffffffff00000000ffffffff
ffffffff00000000ffffffffffff4fffffff4ffffffddfffffff4fff0dd6dd6dd6dd6dd6d6dd6d50ffff4fffffff4fffffff4fff22ffffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ccd4444494944066666666666666666666650444949444449494444494940020fffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ccd44444949440d6dd6dd6dd6dd6ddd6dd650444949444449494444494942302fffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ccd44444949440d6dd6dd6dd6dd6ddd6dd65044494944444949444449494b33bfffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ccd4444494944066666666666666666666650444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ccd44444949440dd6dd600000000056dd6d50444949444449494444494942222fffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944441ddd44444949440dd6dd65000a000056dd6d50444949444449494444494942bb2fffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944442ff1444449494406666665000000005666665044494944444949444449492b33b2ffff00000000ffffffff
ffffffff00000000ffffffff4449494444494944442fe144444949440d6dd6d5000aa0005d6dd650444949444449494444494922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494444211144444949440d6dd6d500aaaa005d6dd6504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff444949444449494444211144444949440666666500a99a00566666504449494444494944444949222222ffff00000000ffffffff
ffffffff00000000ffffffff999949999999499999211199999949990dd6dd6500a99a0056dd6d50999949999999499999994922bb22ffff00000000ffffffff
ffffffff00000000ffffffff444444444444444444211144444444440dd6dd650044440056dd6d5044444444444444444444442b33b2ffff00000000ffffffff
ffffffff00000000ffffff555555555555555555552111555555555555555555555555555555555555555555555555555555522b33b22fff00000000ffffffff
ffffffff00000000ffff555555555555555555555521115555555555555555555555555555555555555555555555555555555222bb222fff00000000ffffffff
ffffffff00000000ff55555555555555555555555521115555555555555555555555555555555555555555555555555555555222222225ff00000000ffffffff
ffffffff5555555555555555555555555555555555cccc55555555555555555555555555555555555555555555555555555552222222255555555555ffffffff
ffffffff555555555555555555555555555555555567775555555555555555555555555555555555555555555555555555555bbbbbbbb55555555555ffffffff
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

