-- Stored Procedure: dbo.pomvarozet_Yeni
-- Tarih: 2026-01-14 20:06:08.358079
================================================================================

CREATE PROCEDURE [dbo].[pomvarozet_Yeni] 
@varno float,
@tip varchar(10),
@tipdty varchar(10)
AS
BEGIN

declare @sql nvarchar(500)
declare @acik float
declare @fazla float
declare @perkod varchar(50)
declare @perad varchar(50)
declare @yertip varchar(20)


set @yertip='pomvardimas'

SET NOCOUNT ON


  declare @Table_Pomvardiozet TABLE (
  [id] numeric(18, 0) IDENTITY(1, 1) NOT NULL,
  [varno] float NOT NULL,
  [perkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [perad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [ada] varchar(50) COLLATE Turkish_CI_AS NULL,
  [grs] float DEFAULT 0 NULL,
  [cks] float DEFAULT 0 NULL,
  [ickkod] varchar(10) COLLATE Turkish_CI_AS NULL,
  [ickad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [sr] float NULL,
  PRIMARY KEY CLUSTERED ([id], [varno]))
 
  

/*
AKSAT
VERAT
VERBT
VEROT
POSST
MALST
NAKTS
ODETT
CAROD
PEROD
PRKOD
TAHTT
CARTH
PERTH
PRKTH
GELIR
GIDER

*/


if @tip='per'
begin

DECLARE vardiperx CURSOR LOCAL FOR SELECT per,perad 
 FROM pomvardiper with (nolock) where varno=@varno and sil=0

 OPEN vardiperx
 FETCH NEXT FROM vardiperx INTO  @perkod,@perad
 WHILE @@FETCH_STATUS <> -1
 BEGIN

 insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
 select @varno,'AKSAT','Akaryakıt Sayaçlı Satış Tutarı',1,@perkod,@perad,isnull(sum(tutar),0),0 
 from pomvardisayac with (nolock) where varno=@varno and sil=0 and perkod=@perkod

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VERAT','Veresiye Alacak Tutarı',2.0,@perkod,@perad,
isnull(sum(toptut-(isktop)),0),0 from veresimas as m with (nolock)
where varno=@varno and fistip='FISALCSAT' and sil=0 and 
m.perkod=@perkod and m.ototag=0 and yertip=@yertip and isnull(m.fis_alc_kocan,0)=0


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VERAT','Veresiye Alacak Tutarı',2.0,@perkod,@perad,
isnull(sum(toptut-(isktop)),0),0 from veresimas as m with (nolock)
where varno=@varno and fistip='FISALCSAT' and sil=0 and 
m.perkod=@perkod and m.ototag=0 and yertip=@yertip and isnull(m.fis_alc_kocan,0)=1



 UPDATE @Table_Pomvardiozet set cks=cks+cikan from @Table_Pomvardiozet as t join
 (select isnull(sum(toptut-(isktop)),0) cikan 
 from veresimas as m with (nolock) where varno=@varno and fistip='FISALCSAT' and sil=0 
 and m.perkod=@perkod and m.ototag=0 and yertip=@yertip 
 and isnull(m.fis_alc_kocan,0)=1 )
 dt on t.sr=2





insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VERBT','Veresiye Borç Tutarı',2.1,@perkod,@perad,0,isnull(sum(toptut-(isktop)),0) from veresimas
with (nolock) where varno=@varno and fistip='FISVERSAT' and sil=0 and perkod=@perkod and ototag=0 and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VEROT','Otomasyon Tutarı',2.2,@perkod,@perad,0,isnull(sum(toptut-(isktop)),0) from veresimas
with (nolock) where varno=@varno and sil=0 and perkod=@perkod and ototag>0 and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'POSST','Pos Satış Tutarı',3,@perkod,@perad,
isnull(sum(case when carslip=1 then (giren*kur) else 0 end ),0),
isnull(sum(giren*kur),0) from poshrk with (nolock)
where varno=@varno and sil=0 and perkod=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'MALST','Yağ - Emtia Satış Tutarı',4,@perkod,@perad,isnull(sum(tutar),0),0 from emtiasat
with (nolock) where varno=@varno and sil=0 and perkod=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'NAKTS','Nakit Teslimat Tutarı',5,@perkod,@perad,0,isnull(sum(giren*kur),0) from kasahrk
with (nolock) where varno=@varno and sil=0 and perkod=@perkod and yertip=@yertip and islmhrk='TES' and masterid=0

if @tipdty='genel'
  insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
  select @varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
  with (nolock) where varno=@varno and ((islmtip='ODE' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='YTN') )
  and sil=0 and perkod=@perkod and yertip=@yertip


if @tipdty='detay'
begin

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values (@varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,0)


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'CAROD','Cari Ödemeler',8,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and (islmtip='ODE' and cartip='carikart') and sil=0 and perkod=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'PEROD','Personel Ödemeler',10,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and (islmtip='ODE' and cartip='perkart') and sil=0 and perkod=@perkod and yertip=@yertip

end

 
 if @tipdty='genel'
  begin
  insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
  select @varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk 
  with (nolock) where varno=@varno and ((islmtip='TAH' and islmhrk<>'TES' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='CKN') )
  and sil=0 and perkod=@perkod and yertip=@yertip 
  
 end
 

  if @tipdty='detay'
  begin
    insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
    values (@varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,0,0)


    insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
    select @varno,'CARTH','Cari Tahsilat',9,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
    with (nolock) where varno=@varno and (islmtip='TAH' and cartip='carikart')
    and sil=0 and perkod=@perkod and yertip=@yertip

    insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
    select @varno,'PERTH','Personel Tahsilat',11,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
    with (nolock) where varno=@varno and (islmtip='TAH' and cartip='perkart')
    and sil=0 and perkod=@perkod and yertip=@yertip


    insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
    select @varno,'PRKTH','Perakende Tahsilat',13,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
    with (nolock) where varno=@varno and (islmtip='TAH' and cartip='perakendekart')
    and sil=0 and perkod=@perkod and yertip=@yertip

  end


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'GELIR','Gelir Tutarı',20,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock)where varno=@varno and islmtip='TAH' and cartip='gelgidkart' and sil=0 and perkod=@perkod
and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'GIDER','Gider Tutarı',21,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and islmtip='ODE' and cartip='gelgidkart' and sil=0 and perkod=@perkod
and yertip=@yertip

if @tipdty='detay'
begin

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'CEKST','Çek-Senet',25,@perkod,@perad,
isnull(sum(case when cartip<>'vardicek' then giren*kur else 0 end),0),
isnull(sum(giren*kur),0) from cekkart
with (nolock) where varno=@varno and sil=0 and perkod=@perkod and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKCK','Banka Çekilen',26,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='CKN' and sil=0 and perkod=@perkod and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKYT','Banka Yatan',27,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='YTN' and sil=0 and perkod=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKEF','Banka Gelen EFT',28,@perkod,@perad,0,isnull(sum(borc*kur),0) from bankahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='C-B' and sil=0 and carkod='VRDHES'
and perkod=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKEF','Banka Giden EFT',29,@perkod,@perad,isnull(sum(alacak*kur),0),0 from bankahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='B-C' and sil=0 and carkod='VRDHES'
and perkod=@perkod and yertip=@yertip

end



if @tipdty='genel' /* diğer satışlar olusturuluyor */
 begin

    insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
    select @varno,'DIGST','Diğer Tutarlar',39,@perkod,@perad,
    isnull(sum(case when cartip<>'vardicek' then giren*kur else 0 end),0),
    isnull(sum(giren*kur),0) from cekkart with (nolock)
    where varno=@varno and sil=0 and perkod=@perkod and yertip=@yertip
   
    
     UPDATE @Table_Pomvardiozet SET grs=grs+giren,cks=cks+cikan from @Table_Pomvardiozet as t join
     (select isnull(sum(alacak*kur),0) as giren,isnull(sum(borc*kur),0) cikan from bankahrk
      where varno=@varno and islmtip='BNK' and islmhrk in ('C-B','B-C') and sil=0 and carkod='VRDHES' 
      and perkod=@perkod and yertip=@yertip ) dt on t.sr=39 and t.perkod=@perkod


   /*
     UPDATE @Table_Pomvardiozet SET grs=grs+giren,cks=cks+cikan from @Table_Pomvardiozet as t join
     (select isnull(sum(giren*kur),0) as giren ,0 cikan from kasahrk
      where varno=@varno and islmtip='BNK' and islmhrk='CKN' and sil=0 and
      perkod=@perkod and yertip=@yertip ) dt on t.sr=39

     UPDATE @Table_Pomvardiozet SET grs=grs+giren,cks=cks+cikan from @Table_Pomvardiozet as t join
     (select 0 as giren,isnull(sum(cikan*kur),0) cikan   from kasahrk
     where varno=@varno and islmtip='BNK' and islmhrk='YTN' and sil=0 and
     perkod=@perkod and yertip=@yertip ) dt on t.sr=39
    */ 

 end



insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'ARATOP','Ara Toplam',40,@perkod,@perad,sum(grs),sum(cks) 
from @Table_Pomvardiozet where varno=@varno and perkod=@perkod


select @acik=(grs-cks) from @Table_Pomvardiozet 
where ickkod='ARATOP' and varno=@varno and perkod=@perkod 

if @acik<0
begin
set @fazla=0
set @acik=-@acik
end
else
begin
set @fazla=@acik
set @acik=0
end

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values(@varno,'ACKFAZ','Fark',41,@perkod,@perad,@acik,@fazla) 

select @acik=sum(grs),@fazla=sum(cks) from 
@Table_Pomvardiozet where (ickkod='ARATOP' or ickkod='ACKFAZ') 
and varno=@varno and perkod=@perkod


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values(@varno,'GENTOP','Genel Toplam',42,@perkod,@perad,@acik,@fazla) 



  FETCH NEXT FROM vardiperx INTO  @perkod,@perad
  END
  CLOSE vardiperx
  DEALLOCATE vardiperx


end/*personele gore */


/*----ada göre */

if @tip='ada'
begin

 DECLARE vardiperx CURSOR LOCAL FOR 
 SELECT cast(adaid as varchar) kod,adad ad 
 FROM pomvardisayac with (nolock) where varno=@varno and sil=0
 group by adaid,adad

 OPEN vardiperx
 FETCH NEXT FROM vardiperx INTO  @perkod,@perad
 WHILE @@FETCH_STATUS <> -1
 BEGIN

 insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
 select @varno,'AKSAT','Akaryakıt Sayaçlı Satış Tutarı',1,@perkod,@perad,isnull(sum(tutar),0),0 from pomvardisayac
 with (nolock) where varno=@varno and sil=0 and adaid=@perkod


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VERAT','Veresiye Alacak Tutarı',2.0,@perkod,@perad,isnull(sum(toptut-(isktop)),0),0 from veresimas
 with (nolock) where varno=@varno and fistip='FISALCSAT' and sil=0 and adaid=@perkod and ototag=0 and yertip=@yertip


 UPDATE @Table_Pomvardiozet set cks=cks+cikan from @Table_Pomvardiozet as t join
 (select isnull(sum(toptut-(isktop)),0) cikan 
 from veresimas as m with (nolock) where varno=@varno and fistip='FISALCSAT' and sil=0 
 and m.adaid=@perkod and m.ototag=0 and yertip=@yertip 
 and isnull(m.fis_alc_kocan,0)=1 )
 dt on t.sr=2




insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VERBT','Veresiye Borç Tutarı',2.1,@perkod,@perad,0,isnull(sum(toptut-(isktop)),0) from veresimas
with (nolock) where varno=@varno and fistip='FISVERSAT' and sil=0 and adaid=@perkod and ototag=0 and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'VEROT','Otomasyon Tutarı',2.2,@perkod,@perad,0,isnull(sum(toptut-(isktop)),0) from veresimas
with (nolock) where varno=@varno and sil=0 and adaid=@perkod and ototag>0 and yertip=@yertip




insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'POSST','Pos Satış Tutarı',3,@perkod,@perad,
isnull(sum(case when carslip=1 then (giren*kur) else 0 end ),0),
isnull(sum(giren*kur),0) from poshrk with (nolock)
where varno=@varno and sil=0 and adaid=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'MALST','Yağ - Emtia Satış Tutarı',4,@perkod,@perad,isnull(sum(tutar),0),0 from emtiasat
with (nolock) where varno=@varno and sil=0 and adaid=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'NAKTS','Nakit Teslimat Tutarı',5,@perkod,@perad,0,isnull(sum(giren*kur),0) from kasahrk
with (nolock) where varno=@varno and sil=0 and adaid=@perkod and yertip=@yertip

if @tipdty='genel'
insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and ((islmtip='ODE' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='YTN') )
and sil=0 and adaid=@perkod and yertip=@yertip

if @tipdty='detay'
begin

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values (@varno,'ODETT','Ödeme Tutarı',6,@perkod,@perad,0,0)


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'CAROD','Cari Ödemeler',8,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and (islmtip='ODE' and cartip='carikart') and sil=0 and adaid=@perkod
and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'PEROD','Personel Ödemeler',10,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and (islmtip='ODE' and cartip='perkart') and sil=0 and adaid=@perkod
and yertip=@yertip

end


if @tipdty='genel'
begin
insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and ((islmtip='TAH' and islmhrk<>'TES' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='CKN') )
and sil=0 and adaid=@perkod and yertip=@yertip
end


if @tipdty='detay'
begin
insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values (@varno,'TAHTT','Tahsilat Tutarı',7,@perkod,@perad,0,0)


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'CARTH','Cari Tahsilat',9,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and (islmtip='TAH' and cartip='carikart')
and sil=0 and adaid=@perkod and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'PERTH','Personel Tahsilat',11,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and (islmtip='TAH' and cartip='perkart')
and sil=0 and adaid=@perkod and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'PRKTH','Perakende Tahsilat',13,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and (islmtip='TAH' and cartip='perakendekart')
and sil=0 and adaid=@perkod and yertip=@yertip

end



insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'GELIR','Gelir Tutarı',20,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and islmtip='TAH' and cartip='gelgidkart' and sil=0 and adaid=@perkod
and yertip=@yertip


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'GIDER','Gider Tutarı',21,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and islmtip='ODE' and  cartip='gelgidkart' and sil=0 and adaid=@perkod
and yertip=@yertip

if @tipdty='detay'
begin

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'CEKST','Çek-Senet',25,@perkod,@perad,
isnull(sum(case when cartip<>'vardicek' then giren*kur else 0 end),0),
isnull(sum(giren*kur),0) from cekkart with (nolock)
where varno=@varno and sil=0 and adaid=@perkod and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKCK','Banka Çekilen',26,@perkod,@perad,isnull(sum(giren*kur),0),0 from kasahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='CKN'
and sil=0 and adaid=@perkod and yertip=@yertip

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'BNKYT','Banka Yatan',27,@perkod,@perad,0,isnull(sum(cikan*kur),0) from kasahrk
with (nolock) where varno=@varno and islmtip='BNK' and islmhrk='YTN'
and sil=0 and adaid=@perkod and yertip=@yertip



end



insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
select @varno,'ARATOP','Ara Toplam',40,@perkod,@perad,sum(grs),sum(cks) from @Table_Pomvardiozet where varno=@varno and perkod=@perkod


select @acik=isnull((grs-cks),0) from @Table_Pomvardiozet where ickkod='ARATOP' and varno=@varno and perkod=@perkod 

if @acik<0
begin
set @fazla=0
set @acik=-@acik
end
else
begin
set @fazla=@acik
set @acik=0
end

insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values(@varno,'ACKFAZ','Fark',41,@perkod,@perad,@acik,@fazla) 

select @acik=sum(grs),@fazla=sum(cks) from @Table_Pomvardiozet where (ickkod='ARATOP' or ickkod='ACKFAZ') 
and varno=@varno and perkod=@perkod


insert into @Table_Pomvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
values(@varno,'GENTOP','Genel Toplam',42,@perkod,@perad,@acik,@fazla) 



  FETCH NEXT FROM vardiperx INTO  @perkod,@perad
  END
  CLOSE vardiperx
  DEALLOCATE vardiperx


end/*ada gore */


SET NOCOUNT OFF






 
 
 
 
 if object_id( 'tempdb..##pomvardiozet' ) is null
  CREATE TABLE [dbo].[##pomvardiozet] (
  [id] numeric(18, 0) IDENTITY(1, 1) NOT NULL,
  [varno] float NOT NULL,
  [perkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [perad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [ada] varchar(50) COLLATE Turkish_CI_AS NULL,
  [grs] float DEFAULT 0 NULL,
  [cks] float DEFAULT 0 NULL,
  [ickkod] varchar(10) COLLATE Turkish_CI_AS NULL,
  [ickad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [sr] float NULL,
  PRIMARY KEY CLUSTERED ([id], [varno]))
  
  
  truncate table ##pomvardiozet
  
  insert into ##pomvardiozet (varno,perkod,perad,ada,grs,cks,ickkod,ickad,sr) 
  select varno,perkod,perad,ada,grs,cks,ickkod,ickad,sr from @Table_Pomvardiozet



  select * from @Table_Pomvardiozet


END

================================================================================
