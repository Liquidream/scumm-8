pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
a=true b=false c=true d=true e=true f=printh g={{{h="open"},i="open"},{{j="close"},i="close"},{{k="give"},i="give"},{{l="pickup"},i="pick-up"},{{m="lookat"},i="look-at"},{{n="talkto"},i="talk-to"},{{o="push"},i="push"},{{p="pull"},i="pull"},{{q="use"},i="use"}} r={{s="walkto"},i="walk to"} t=12 u=7 v=1 w=10 x={y=1,z=1,ba=1,h=2,bb=2,bc=2} bd=1 be=2 bf=4 bg=8 bh=16 bi=32 bj=1 bk=2 bl=1 bm=2 bn=3 bo=4 bp=1 bq=3 br=2 bs=4 bt=5 bu=1 bv=2 bw={bx={by=0,bz=0,ca={{7,15},},cb=function(cc) cd(cc.ce.cf,true) end,cg=function(cc) ch(cc.ce.cf) end,ci=0,ce={cf=function() while true do for cj=1,3 do ck("fire",cj) cl(8) end end end,cm=function() while true do for cj=1,3 do ck("spinning top",cj) cl(8) end end end},cn={co={cp="fire",cq=1,cr=8*8,cs=4*8,x={145,146,147},ct=1,cu=1,cv=bn,cw=bp,cx="front door",cy=x.y,g={m=function() cz("it's a nice, warm fire...") da() cl(10) db(dc,bv,bl) cz("ouch! it's hot!;*stupid fire*") da() end,n=function() cz("'hi fire...'") da() cl(10) db(dc,bv,bl) cz("the fire didn't say hello back;burn!!") da() end,l=function(cc) dd(cc) end,}},de={cp="front door",df=bh,cq=x.y,cr=1*8,cs=2*8,dg=-10,x={143,0},ct=1,cu=4,cw=bs,cv=bm,g={s=function(cc) if dh(cc)==x.h then
di(bw.dj.cn.de) else cz("the door is closed") end end,h=function(cc) dk(cc,bw.dj.cn.de) end,j=function(cc) dl(cc,bw.dj.cn.de) end}},dm={cp="kitchen",cq=x.h,cr=14*8,cs=2*8,ct=1,cu=4,cw=br,cv=bo,g={s=function() di(bw.dn.cn.dp) end}},dq={cp="bucket",df=be,cq=x.h,cr=13*8,cs=6*8,ct=1,cu=1,x={207,223},dr=15,g={m=function(cc) if ds(cc)==dc then
cz("it is a bucket in my pocket") else cz("it is a bucket") end end,l=function(cc) dd(cc) end,k=function(cc,dt) if dt==du.dv then
cz(du.dv,"Thanks!") da() cc.dw=du.dv else cz("I might need this") end end}},dx={cp="spinning top",cq=1,cr=2*8,cs=6*8,x={192,193,194},ca={{12,7}},dr=15,ct=1,cu=1,g={o=function(cc) if dy(dz.ce.cm) then
ch(dz.ce.cm) ck(cc,1) else cd(dz.ce.cm) end end,p=function(cc) ch(dz.ce.cm) ck(cc,1) end}},ea={cp="window",df=bh,cq=x.y,cv=bn,cw={cr=5*8,cs=(7*8)+1},cr=4*8,cs=1*8,ct=2,cu=2,x={132,134},g={h=function(cc) if not cc.eb then
ec(bj+bk,function() cc.eb=true ed("*creak*",40,20,8,1) da() ee(bw.dn) dc=du.dv ef(dc,dc.cr+10,dc.cs) cz("what was that?!") da() cz("i'd better check...") da() ef(dc,dc.cr-10,dc.cs) ee(bw.bx) cl(50) dc.cr=115 dc.cs=44 dc.eg=bw.bx ef(dc,dc.cr-10,dc.cs) cz("intruder!!!") da() end,function() ee(bw.bx) du.dv.eg=bw.bx du.dv.cr=105 du.dv.cs=44 eh() end) end end}}}},dn={by=16,bz=0,ei=39,ej=7,cb=function() end,cg=function() end,ce={},cn={dp={cp="hall",cq=x.h,cr=1*8,cs=2*8,ct=1,cu=4,cw=bs,cv=bm,g={s=function() di(bw.bx.cn.dm) end}},ek={cp="back door",df=bh,cq=x.y,cr=22*8,cs=2*8,dg=-10,x={143,0},el=true,ct=1,cu=4,cw=br,cv=bo,g={s=function(cc) if dh(cc)==x.h then
di(bw.bx.cn.de) else cz("the door is closed") end end,h=function(cc) dk(cc,bw.bx.cn.de) end,j=function(cc) dl(cc,bw.bx.cn.de) end}},},},dj={by=16,bz=8,ei=47,ej=15,cb=function(cc) end,cg=function(cc) end,ce={},cn={em={df=bd,cr=10*8,cs=3*8,cq=1,x={111},ct=1,cu=2,en=8},eo={df=bd,cr=22*8,cs=3*8,cq=1,x={111},ct=1,cu=2,en=8},de={cp="front door",df=bh,cq=x.y,cr=19*8,cs=1*8,x={142,0},el=true,ct=1,cu=3,cw=bp,cv=bn,g={s=function(cc) if dh(cc)==x.h then
di(bw.bx.cn.de) else cz("the door is closed") end end,h=function(cc) dk(cc,bw.bx.cn.de) end,j=function(cc) dl(cc,bw.bx.cn.de) end}},},}} ep=bw.dj du={eq={df=bi,cr=127/2+80,cs=127/2-24,ct=1,cu=4,er=bl,es={1,3,5,3},et={6,22,21,22},eu={2,3,4,3},ev=12,dr=11,ew=0.6,},dv={cp="purple tentacle",df=bf+bi,cr=127/2-24,cs=127/2-16,ct=1,cu=3,er=bl,es={30,30,30,30},et={47,47,47,47},ev=13,dr=15,ew=0.25,cw=br,eg=bw.dn,g={m=function() cz(dc,"it's a weird looking tentacle, thing!") end,n=function(cc) ec(bj,function() cz(cc,"what do you want?") da() end) while(not ex or ex.ey!=4) do while(true) do ez("where am i?") ez("who are you?") ez("how much wood would a wood-chuck chuck, if a wood-chuck could chuck wood?") ez("nevermind") fa(dc.ev,7) while not ex do cl() end break end fb() ec(bj,function() cz(ex.fc) da() f("sentence num: "..ex.ey) if ex.ey==1 then
cz(cc,"you are in paul's game") da() elseif ex.ey==2 then cz(cc,"it's complicated...") da() elseif ex.ey==3 then cz(cc,"a wood-chuck would chuck no amount of wood, coz a wood-chuck can't chuck wood!") da() elseif ex.ey==4 then cz(cc,"ok bye!") da() return end end) end end}}} dc=du.eq function fd(fe) local ff=nil if fg(fe.df,bf) then
ff="talkto"elseif fg(fe.df,bh) then if fe.cq==x.y then
ff="open"else ff="close"end else ff="lookat"end for fh in all(g) do fi=fj(fh) if(fi[2]==ff) then ff=fh break end
end return ff end function fk(fl,fm,fn) f("verb:"..fl.." , obj:"..fm.cp) if fl=="walkto"then
return elseif fl=="pickup"then if fg(fm.df,bi) then
cz("i don't need them") else cz("i don't need that") end elseif fl=="use"then if fg(fm.df,bi) then
cz("i can't just *use* someone") end if fn then
if fg(fn.df,bi) then
cz("i can't use that on someone!") else cz("that doesn't work") end end elseif fl=="give"then if fg(fm.df,bi) then
cz("i don't think i should be giving this away") else cz("i can't do that") end elseif fl=="lookat"then if fg(fm.df,bi) then
cz("i think it's alive") else cz("looks pretty ordinary") end elseif fl=="open"then if fg(fm.df,bi) then
cz("they don't seem to open") else cz("it doesn't seem to open") end elseif fl=="close"then if fg(fm.df,bi) then
cz(fo"they don't seem to close") else cz("it doesn't seem to close") end elseif fl=="push"or fl=="pull"then if fg(fm.df,bi) then
cz("moving them would accomplish nothing") else cz("it won't budge!") end elseif fl=="talkto"then if fg(fm.df,bi) then
cz("erm... i don't think they want to talk") else cz("i am not talking to that!") end else cz("hmm. no.") end end fp=127 fq=127 fr=16 fs=(dc.cu-1)*8 ft=0 fu=0 fv=0 fw=0 fx=dc fy=fp/2 fz=fq/2 ga=1 gb=0 gc={7,12,13,13,12,7} gd=1 ge={{spr=16,cr=75,cs=fr+60},{spr=48,cr=75,cs=fr+72}} gf=0 gg=0 gh=false dz=nil gi=nil gj=nil gk=nil gl=""gm=false gn=nil go=nil ex=nil gp=nil gq=nil gr={} gs={} gt={} gu={} function _init() if(e) then poke(0x5f2d,1) end
dc.eg=ep gv() ee(ep) end function _update60() gw() end function _draw() gx() end function gw() if dc.gy and not coresume(dc.gy) then
dc.gy=nil end gz(gr) if gp then
if gp.gy and not coresume(gp.gy) then
if(dz!=gp.ha) then ee(gp.ha) end
dc=gp.hb fw=gp.hc fx=gp.hd del(gt,gp) gp=nil if(#gt>0) then
gp=gt[#gt] end end else gz(gs) end he() hf() end function gx() rectfill(0,0,fp,fq,0) if fw==0 then
ft=mid(0,dc.cr-64,(dz.hg*8)-fp-1) end camera(ft,0) clip(0,fr,fp+1,64) hh() camera(0,0) clip() if(d) then
print("cpu: "..flr(100*stat(1)).."%",0,fr-16,8) print("mem: "..flr(stat(0)/1024*100).."%",0,fr-8,8) end if(a) then print("x: "..fy.." y:"..fz-fr,80,fr-8,8) end
hi() if go and go.hj then
hk() hl() return end if(hm==gp) then
else hm=gp return end if not gp then
hn() end if(not gp
or not fg(gp.ho,bj)) and(hm==gp) then hp() else end hm=gp if not gp
then hl() end end function he() if gp then
if((btnp(4) and btnp(5)) or(e and stat(34)==2))
and gp.hq then gp.gy=cocreate(gp.hq) gp.hq=nil if(e) then gh=true end
return end return end if(btn(0)) then fy=fy-1 end
if(btn(1)) then fy=fy+1 end
if(btn(2)) then fz=fy-1 end
if(btn(3)) then fz=fy+1 end
if(btnp(4)) then hr(1) end
if(btnp(5)) then hr(2) end
if(e) then
if(stat(32)-1!=gf) then fy=stat(32)-1 end
if(stat(33)-1!=gg) then fz=stat(33)-1 end
if(stat(34)>0) then
if(not gh) then
hr(stat(34)) gh=true end else gh=false end gf=stat(32)-1 gg=stat(33)-1 end fy=max(fy,0) fy=min(fy,127) fz=max(fz,0) fz=min(fz,127) end function hr(hs) local ht=gi if go and go.hj then
if hu then
ex=hu end return end if hv then
gi=fj(hv) f("verb = "..gi[2]) elseif hw then if hs==1 then
if(gi[1]=="use"or gi[1]=="give")
and gj then gk=hw f("noun2_curr = "..gk.cp) else gj=hw f("noun1_curr = "..gj.cp) end elseif hx then gi=fj(hx) gj=hw f("n1 tpe:"..type(gj)) hy(gj) f("name:"..gj.cp) hn() end elseif hz then if hz==ge[1] then
if dc.ia>0 then
dc.ia-=1 end else if dc.ia+2<flr(#dc.ib/4) then
dc.ia+=1 end end return else end if(gj!=nil) then
if gi[2]=="use"or gi[2]=="give"then
if gk then
else return end end gm=true dc.gy=cocreate(function(ic,fe,fl,dt) if not fe.dw then
f("obj x="..fe.cr..",y="..fe.cs) f("obj w="..fe.ct..",h="..fe.cu) id=ie(fe) f("dest_pos x="..id.cr..",y="..id.cs) if(fe.ig) then f("offset x="..fe.ig..",y="..fe.ih) end
ef(dc,id.cr,id.cs) f(".moving="..dc.ii) if dc.ii!=2 then return end
cv=dc.er if(fe.cv and(fl!=r)) then cv=fe.cv end
db(dc,bv,cv) end if ij(fl,fe) then
f("verb_obj_script!") f("verb = "..fl[2]) f("obj = "..fe.cp) cd(fe.g[fl[1]],false,fe,dt) else fk(fl[2],fe,dt) end ik() end) coresume(dc.gy,dc,gj,gi,gk) elseif(fz>fr and fz<fr+64) then gm=true dc.gy=cocreate(function(cr,cs) ef(dc,cr,cs) ik() end) coresume(dc.gy,fy,fz-fr) end f("--------------------------------") end function hf() hv=nil hx=nil hw=nil hu=nil hz=nil if go and go.hj then
for fo in all(go.il) do if im(fo) then
hu=fo end end return end io() for ip,fe in pairs(dz.cn) do if(not fe.df
or(fe.df and fe.df!=bd)) and(not fe.cx or iq(fe.cx).cq==fe.cy) then ir(fe,fe.ct*8,fe.cu*8,ft,is) else fe.it=nil end if im(fe) then
hw=fe end iu(fe) end for ip,ic in pairs(du) do if(ic.eg==dz) then
ir(ic,ic.ct*8,ic.cu*8,ft,is) iu(ic) if im(ic)
and ic!=dc then hw=ic end end end for fh in all(g) do if im(fh) then
hv=fh end end for iv in all(ge) do if im(iv) then
hz=iv end end for ip,fe in pairs(dc.ib) do if im(fe) then
hw=fe end if fe.dw!=dc then
del(dc.ib,fe) end end if(gi==nil) then
gi=fj(r) end if hw then
hx=fd(hw) end end function io() gu={} for cr=1,64 do gu[cr]={} end end function iu(fe) iw=-1 if fe.ih then
iw=fe.cs else iw=fe.cs+(fe.cu*8) end ix=flr(iw-fr) if fe.dg then ix+=fe.dg end
add(gu[ix],fe) end function hh() for iy in all(dz.ca) do pal(iy[1],iy[2]) end map(dz.by,dz.bz,0,fr,dz.hg,dz.iz) pal() if c then
ja=jb(dc) jc=flr((fy+ft)/8)+dz.by jd=flr((fz-fr)/8)+dz.bz je={jc,jd} jf=jg(ja,je) jh=jb({cr=(fy+ft),cs=(fz-fr)}) if ji(jh[1],jh[2]) then
add(jf,jh) end for jj in all(jf) do rect((jj[1]-dz.by)*8,fr+(jj[2]-dz.bz)*8,(jj[1]-dz.by)*8+7,fr+(jj[2]-dz.bz)*8+7,11) end end for jk=1,64 do ix=gu[jk] for fe in all(ix) do if not fg(fe.df,bi) then
if(fe.x)
and fe.x[fe.cq] and(fe.x[fe.cq]>0) and(not fe.cx or iq(fe.cx).cq==fe.cy) and not fe.dw then jl(fe) end else if(fe.eg==dz) then
jm(fe) end end jn(fe) end end end function jm(ic) if(ic.ii==1)
and ic.eu then ic.jo=ic.jo+1 if(ic.jo>5) then
ic.jo=1 ic.jp=ic.jp+1 if(ic.jp>#ic.eu) then ic.jp=1 end
end jq=ic.eu[ic.jp] else jq=ic.es[ic.er] end for iy in all(ic.ca) do pal(iy[1],iy[2]) end jr(jq,ic.ig,ic.ih,ic.ct,ic.cu,ic.dr,ic.flip,false) if(gq
and gq==ic) then if(ic.js<7) then
jq=ic.et[ic.er] jr(jq,ic.ig,ic.ih+8,1,1,ic.dr,ic.flip,false) end ic.js=ic.js+1 if(ic.js>14) then ic.js=1 end
end pal() end function hn() jt=""ju=12 if not gm then
if gi then
jt=gi[3] end if gj then
jt=jt.." "..gj.cp end if gi[2]=="use"
and gj then jt=jt.." with"end if gi[2]=="give"
and gj then jt=jt.." to"end if gk then
jt=jt.." "..gk.cp elseif hw and hw.cp!=""and(not gj or(gj!=hw)) then jt=jt.." "..hw.cp end gl=jt else jt=gl ju=7 end print(jv(jt),jw(jt),fr+66,ju) end function hi() if gn then
jx=0 for jy in all(gn.jz) do ka=0 if gn.kb==1 then
ka=((gn.kc*4)-(#jy*4))/2 end kd(jy,gn.cr+ka,gn.cs+jx,gn.ev) jx+=6 end gn.ke=gn.ke-1 if(gn.ke<=0) then
eh() end end end function hp() kf=0 iw=75 kg=0 for fh in all(g) do kh=t if hx
and(fh==hx) then kh=w end if(fh==hv) then kh=u end
fi=fj(fh) print(fi[3],kf,iw+fr+1,v) print(fi[3],kf,iw+fr,kh) fh.cr=kf fh.cs=iw ir(fh,#fi[3]*4,5,0,0) jn(fh) if(#fi[3]>kg) then kg=#fi[3] end
iw=iw+8 if iw>=95 then
iw=75 kf=kf+(kg+1.0)*4 kg=0 end end kf=86 iw=76 ki=dc.ia*4 kj=min(ki+8,#dc.ib) for kk=1,8 do rectfill(kf-1,fr+iw-1,kf+8,fr+iw+8,1) fe=dc.ib[ki+kk] if fe then
fe.cr=kf fe.cs=iw jl(fe) ir(fe,fe.ct*8,fe.cu*8,0,0) jn(fe) end kf=kf+11 if kf>=125 then
iw=iw+12 kf=86 end kk=kk+1 end for kl=1,2 do km=ge[kl] if hz==km then pal(t,7) end
jr(km.spr,km.cr,km.cs,1,1,0) ir(km,8,7,0,0) jn(km) pal() end end function hk() kf=0 iw=70 for fo in all(go.il) do fo.cr=kf fo.cs=iw ir(fo,fo.kc*4,#fo.kn*5,0,0) kh=go.ev if(fo==hu) then kh=go.ko end
for jy in all(fo.kn) do print(jv(jy),kf,iw+fr,kh) iw=iw+5 end jn(fo) iw=iw+2 end end function hl() ev=gc[gd] pal(7,ev) spr(32,fy-4,fz-3,1,1,0) pal() gb=gb+1 if(gb>7) then
gb=1 gd=gd+1 if(gd>#gc) then gd=1 end
end end function jr(kp,cr,cs,ct,cu,kq,el,kr) palt(0,false) palt(kq,true) spr(kp,cr,fr+cs,ct,cu,el,kr) palt(kq,false) palt(0,true) end function ec(ho,ks,kt) ga=ga-1 ku={ho=ho,gy=cocreate(ks),hq=kt,ha=dz,hb=dc,hc=fw,hd=fx} add(gt,ku) gp=ku fw=1 ft=0 cl() end function ez(fc) if not go then go={il={},hj=false} end
kn=kv(fc,32) kw=kx(kn) ky={ey=#go.il+1,fc=fc,kn=kn,kc=kw} add(go.il,ky) end function fa(ev,ko) go.ev=ev go.ko=ko go.hj=true ex=nil end function fb() go.hj=false go=nil end function ie(fe) kz={} f("get_use_pos") if type(fe.cw)=="table"then
f("usr tbl") kz.cr=fe.cw.cr-ft kz.cs=fe.cw.cs-fr elseif not fe.cw or(fe.cw==bp) then kz.cr=fe.cr+((fe.ct*8)/2)-ft-4 kz.cs=fe.cs+(fe.cu*8)+2 elseif(fe.cw==br) then if fe.ig then
kz.cr=fe.cr-ft-(fe.ct*8+4) kz.cs=fe.cs+1 else kz.cr=fe.cr-ft kz.cs=fe.cs+((fe.cu*8)-2) end elseif(fe.cw==bs) then kz.cr=fe.cr+(fe.ct*8)-ft kz.cs=fe.cs+((fe.cu*8)-2) end return kz end function db(ic,la,lb) ic.flip=(lb==bm) if la==bu then
f(" > anim_face") ic.er=lb elseif la==bv then f(" > anim_turn") while(ic.er!=lb) do if(ic.er<lb) then
ic.er=ic.er+1 else ic.er=ic.er-1 end cl(10) end end end function dk(lc,ld) if dh(lc)==x.h then
cz(dc,"it's already open") else ck(lc,x.h) if ld then ck(ld,x.h) end
end end function dl(lc,ld) if dh(lc)==x.y then
cz(dc,"it's already closed") else ck(lc,x.y) if ld then ck(ld,x.y) end
end end function di(le) lf=le.eg ee(lf) kz=ie(le) f("pos x:"..kz.cr..", y:"..kz.cs) dc.cr=kz.cr dc.cs=kz.cs if le.cv then
lg=le.cv+2 if(lg>4) then
lg-=4 end else lg=1 end db(dc,bu,lg) dc.eg=lf end function ee(lf) f("change_room()...") if dz and dz.cg then
dz.cg(dz) end gs={} ik() dz=lf if dz.ei then
dz.hg=dz.ei-dz.by+1 dz.iz=dz.ej-dz.bz+1 else dz.hg=16 dz.iz=8 end ft=0 if dz.cb then
f("t2: "..type(dz)) f("scr2:"..type(dz.ce.cf)) dz.cb(dz) end end function ij(fl,lh) if not lh then return false end
if not lh.g then return false end
if type(fl)=="table"then
if lh.g[fl[1]] then return true end
else if(lh.g[fl]) then return true end
end return false end function dd(li) fe=iq(li) if fe
and not fe.dw then f("adding to inv") add(dc.ib,fe) fe.dw=dc del(fe.eg.cn,fe) end end function ds(li) fe=iq(li) if fe then
return fe.dw end end function dh(li,cq) fe=iq(li) if fe then
return fe.cq end end function ck(li,cq) fe=iq(li) if fe then
fe.cq=cq end end function iq(cp) if(type(cp)=="table") then return cp end
for ip,fe in pairs(dz.cn) do if(fe.cp==cp) then return fe end
end end function cd(lj,lk,ll,dt) local gy=cocreate(lj) if lk then
add(gr,{lj,gy,ll,dt}) else add(gs,{lj,gy,ll,dt}) end end function dy(lj) f("script_running()") for ip,lm in pairs(gs) do f("...") if(lm[1]==lj) then
f("found!") return true end end for ip,lm in pairs(gr) do f("...") if(lm[1]==lj) then
f("found!") return true end end return false end function ch(lj) f("stop_script()") for ip,lm in pairs(gs) do f("...") if(lm[1]==lj) then
f("found!") del(gs,lm) f("deleted!") lm=nil end end for ip,lm in pairs(gr) do f("...") if(lm[1]==lj) then
f("found!") del(gr,lm) f("deleted!") lm=nil end end end function cl(ln) ln=ln or 1 for cr=1,ln do yield() end end function da() while gn!=nil do yield() end end function cz(ic,fc) if type(ic)=="string"then
fc=ic ic=dc end iw=ic.cs-fs gq=ic f("talking actor set") ed(fc,ic.cr,iw,ic.ev,1) end function eh() gn=nil gq=nil f("talking actor cleared") end function ed(fc,cr,cs,ev,kb) f("print_line") local ev=ev or 7 local kb=kb or 0 f(fc) local kn={} local lo=""local lp=""kw=0 lq=min(cr,fp-cr) lr=max(flr(lq/2),16) lp=""for kl=1,#fc do lo=sub(fc,kl,kl) if lo==";"then
f("msg break!") lp=sub(fc,kl+1) f("msg_left:"..lp) fc=sub(fc,1,kl-1) break end end kn=kv(fc,lr,true) kw=kx(kn) if kb==1 then
kf=cr-((kw*4)/2) end kf=max(2,kf) iw=max(18,cs) kf=min(kf,fp-(kw*4)-1) gn={jz=kn,cr=kf,cs=iw,ev=ev,kb=kb,ke=(#fc)*8,kc=kw} if(#lp>0) then
lt=gq da() gq=lt ed(lp,cr,cs,ev,kb) end end function jl(fe) for iy in all(fe.ca) do pal(iy[1],iy[2]) end lu=1 if fe.en then lu=fe.en end
for cu=0,lu-1 do jr(fe.x[fe.cq],fe.cr+(cu*(fe.ct*8)),fe.cs,fe.ct,fe.cu,fe.dr,fe.el) end pal() end function ef(ic,cr,cs) cr=cr+ft ja=jb(ic) jc=flr(cr/8)+dz.by jd=flr(cs/8)+dz.bz je={jc,jd} jf=jg(ja,je) lv=jb({cr=cr,cs=cs}) if ji(lv[1],lv[2]) then
add(jf,lv) end for jj in all(jf) do lw=(jj[1]-dz.by)*8+4 lx=(jj[2]-dz.bz)*8+4 local ly=sqrt((lw-ic.cr)^2+(lx-ic.cs)^2) local lz=ic.ew*(lw-ic.cr)/ly local ma=ic.ew*(lx-ic.cs)/ly ic.ii=1 ic.flip=(lz<0) ic.er=bo if(ic.flip) then ic.er=bm end
for kl=0,ly/ic.ew do ic.cr=ic.cr+lz ic.cs=ic.cs+ma yield() end ic.ii=2 end end function gv() for mb,mc in pairs(bw) do for md,fe in pairs(mc.cn) do fe.eg=mc end end for me,ic in pairs(du) do ic.ii=2 ic.jo=1 ic.js=1 ic.jp=1 ic.ib={} ic.ia=0 end end function jn(fe) if b and fe.it then
rect(fe.it.cr,fe.it.cs,fe.it.mf,fe.it.mg,8) end end function gz(ce) for lm in all(ce) do if lm[2] and not coresume(lm[2],lm[3],lm[4]) then
del(ce,lm) lm=nil end end end function mh(cr,cs) jc=flr(cr/8)+dz.by jd=flr(cs/8)+dz.bz mi=ji(jc,jd) return mi end function jb(fe) jc=flr(fe.cr/8)+dz.by jd=flr(fe.cs/8)+dz.bz return{jc,jd} end function ji(jc,jd) mj=mget(jc,jd) mi=fget(mj,0) return mi end function hy(fe) mk={} for ip,fh in pairs(fe) do add(mk,ip) end return mk end function fj(fe) fl={} mk=hy(fe[1]) add(fl,mk[1]) add(fl,fe[1][mk[1]]) add(fl,fe.i) return fl end function kv(fc,lr,ml) local kn={} local mm=""local mn=""local lo=""local mo=function(mp) if#mn+#mm>mp then
add(kn,mm) mm=""end mm=mm..mn mn=""end for kl=1,#fc do lo=sub(fc,kl,kl) mn=mn..lo if(lo==" ")
or(#mn>lr-1) then mo(lr) elseif#mn>lr-1 then mn=mn.."-"mo(lr) elseif lo==","and ml then f("line break!") mm=mm..sub(mn,1,#mn-1) mn=""mo(0) end end mo(lr) if mm!=""then
add(kn,mm) end return kn end function kx(kn) kw=0 for jy in all(kn) do if(#jy>kw) then kw=#jy end
end return kw end function fg(fe,mq) if(band(fe,mq)!=0) then return true end
return false end function ik() gi=fj(r) gj=nil gk=nil cc=nil gm=false gl=""f("command wiped") end function ir(fe,ct,cu,mr,ms) cr=fe.cr cs=fe.cs if fg(fe.df,bi) then
fe.ig=fe.cr-(fe.ct*8)/2 fe.ih=fe.cs-(fe.cu*8)+1 cr=fe.ig cs=fe.ih end fe.it={cr=cr,cs=cs+fr,mf=cr+ct-1,mg=cs+cu+fr-1,mr=mr,ms=ms} end function jg(mt,mu) mv={} mw(mv,mt,0) mx={} mx[my(mt)]=nil mz={} mz[my(mt)]=0 while(#mv>0 and#mv<1000) do local na=mv[#mv] del(mv,mv[#mv]) nb=na[1] if my(nb)==my(mu) then
break end local nc={} for cr=-1,1 do for cs=-1,1 do if cr==0 and cs==0 then
else nd=nb[1]+cr ne=nb[2]+cs if abs(cr)!=abs(cs) then nf=1 else nf=1.4 end
if nd>=dz.by and nd<=dz.by+dz.hg
and ne>=dz.bz and ne<=dz.bz+dz.iz and ji(nd,ne) and((abs(cr)!=abs(cs)) or ji(nd,nb[2]) or ji(nd-cr,ne)) then add(nc,{nd,ne,nf}) end end end end for ng in all(nc) do local nh=my(ng) local ni=mz[my(nb)]+ng[3] if(mz[nh]==nil) or(ni<mz[nh]) then
mz[nh]=ni local nj=ni+max(abs(mu[1]-ng[1]),abs(mu[2]-ng[2])) mw(mv,ng,nj) mx[nh]=nb end end end jf={} nb=mx[my(mu)] if nb then
local nk=my(nb) local nl=my(mt) while nk!=nl do add(jf,nb) nb=mx[nk] nk=my(nb) end for kl=1,(#jf/2) do local nm=jf[kl] local nn=#jf-(kl-1) jf[kl]=jf[nn] jf[nn]=nm end end return jf end function mw(no,np,jj) if#no>=1 then
add(no,{}) for kl=(#no),2,-1 do local ng=no[kl-1] if jj<ng[2] then
no[kl]={np,jj} return else no[kl]=ng end end no[1]={np,jj} else add(no,{np,jj}) end end function my(nq) return((nq[1]+1)*16)+nq[2] end function kd(nr,cr,cs,ns,nt) local ns=ns or 7 local nt=nt or 0 nr=jv(nr) for nu=-1,1 do for nv=-1,1 do print(nr,cr+nu,cs+nv,nt) end end print(nr,cr,cs,ns) end function jw(fo) return(fp/2)-flr((#fo*4)/2) end function nw(fo) return(fq/2)-flr(5/2) end function im(fe) if not fe.it then return false end
it=fe.it if(fy+it.mr>it.mf or fy+it.mr<it.cr)
or(fz>it.mg or fz<it.cs) then return false else return true end end function jv(fo) local f=""local jy,iy,no=false,false for kl=1,#fo do local iv=sub(fo,kl,kl) if iv=="^"then
if(iy) then f=f..iv end
iy=not iy elseif iv=="~"then if(no) then f=f..iv end
no,jy=not no,not jy else if iy==jy and iv>="a"and iv<="z"then
for nx=1,26 do if iv==sub("abcdefghijklmnopqrstuvwxyz",nx,nx) then
iv=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",nx,nx) break end end end f=f..iv iy,no=false,false end end return f end
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
77777755666666ddbbbbbbee3333335533333333000000006666666658888588dddddddd00000000000000550000000000000000000000000000000000045000
777755556666ddddbbbbeeee33333355333333330000000066666666588885885555555500000000000055550000000000000000000000000000000000045000
7755555566ddddddbbeeeeee33336666333333330000000066666666555555556666666600000000005555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33336666333333330000000066666666888588886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666888588886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee33555555333333330000000066666666555555556666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885886666666600000000555555550000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66666666333333330000000066666666588885886666666600000000555555550000000000000000000000000000000000045000
55777777dd666666eebbbbbb55333333555555550000000000000000000000000000000000000000000000000000000000000000000000000000000099999999
55557777dddd6666eeeebbbb55333333555533330000000000000000000000000000000000000000000000000000000000000000000000000000000044444444
55555577dddddd66eeeeeebb66663333553333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
55555555ddddddddeeeeeeee66663333533333330000000000000000000000000000000000000000000000000000000000000000000000000000000000045000
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
fff76ffffff76ffffff76fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666666f
fbbbbccff8888bbffcccc88f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006cccccc6
bbbcccc8888bbbbcccc8888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d666666d
fccccc8ffbbbbbcff88888bf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fccc888ffbbbcccff888bbbf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
fff00ffffff00ffffff00fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff6665ff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666666f
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065555556
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d666666d
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f666650f
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff6665ff
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
44444449494949494949494949494949000000000000000000005f0058585858585858585858585858585858005f00004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44444449494949494949494949494949000000000000000000005f0058845884588458008e58845884588458005f00004444444949494949494949494944444444444449494949494949494949444444444444494949494949494949494444444444444949494949494949494944444444444449494949494949494949444444
44004449494949494949494949494949000000000000000000005f0058a458a458a458009e58a458a458a458005f00004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
440044494949494949494949494949490000000000004500000045005858585858585800ae58585858585858000000004400444949494949494949494944004444004449494949494949494949440044440044494949494949494949494400444400444949494949494949494944004444004449494949494949494949440044
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

