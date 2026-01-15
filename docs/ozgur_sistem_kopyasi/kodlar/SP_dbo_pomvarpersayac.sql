-- Stored Procedure: dbo.pomvarpersayac
-- Tarih: 2026-01-14 20:06:08.358905
================================================================================

CREATE PROCEDURE [dbo].pomvarpersayac
@firmano int,
@varno float,
@perkod varchar(50),
@perad varchar(50),
@adaid int,@adad varchar(50)
AS
BEGIN
SET NOCOUNT ON

declare @say int
declare @grp1 int
declare @kod varchar(50)
declare @ad varchar(50)
declare @satfiytip varchar(50)
declare @tankkod varchar(50)
declare @stktip varchar(10)
declare @enktur varchar(10)
declare @otomaskod varchar(50)
declare @stkkod varchar(50)
declare @ilkend float
declare @sonend float
declare @satfiy float
declare @aktarma float
declare @test float
declare @sonendk float
declare @kdvyuz float
declare @stkkalan float



if @adad='Tum'
 DECLARE pomvardisayacac CURSOR FORWARD_ONLY READ_ONLY LOCAL FOR
 SELECT s.grp1,g.ad,s.kod,s.otomaskod,s.ad,s.satfiytip,s.sonendks,
 s.tankod,t.bagak,t.stktip,s.enktur FROM sayackart as s with (NOLOCK) 
 inner join tankkart as t with (NOLOCK)  on t.kod=s.tankod
 and t.drm='Aktif' and t.sil=0 and s.firmano=@firmano
 inner join grup as g on g.id=s.grp1 
 where s.drm='Aktif' and s.sil=0
 
if @adad<>'Tum'
 DECLARE pomvardisayacac CURSOR FORWARD_ONLY READ_ONLY LOCAL FOR
 SELECT s.grp1,g.ad,s.kod,s.otomaskod,s.ad,s.satfiytip,s.sonendks,
 s.tankod,t.bagak,t.stktip,s.enktur FROM sayackart as s with (NOLOCK)  
 inner join tankkart  as t with (NOLOCK)  on t.kod=s.tankod
 and t.drm='Aktif' and t.sil=0 and s.firmano=@firmano
 inner join grup as g on g.id=s.grp1 
 where s.drm='Aktif' and s.sil=0 and s.grp1=@adaid

 OPEN pomvardisayacac
 FETCH NEXT FROM pomvardisayacac INTO  @grp1,@adad,@kod,@otomaskod,@ad,
 @satfiytip,@ilkend,
 @tankkod,@stkkod,@stktip,@enktur
 WHILE @@FETCH_STATUS <> -1
 BEGIN


 set @satfiytip=SUBSTRING(@satfiytip,1,1)


if @satfiytip='1'
select @kdvyuz=sat1kdv,@satfiy=case when sat1kdvtip='Dahil' then 
sat1fiy else sat1fiy*(1+(sat1kdv/100)) end 
from stokkart with (nolock) where tip=@stktip and kod=@stkkod

if @satfiytip='2'
select @kdvyuz=sat2kdv,@satfiy=case when sat2kdvtip='Dahil' then 
sat2fiy else sat2fiy*(1+(sat2kdv/100))  end 
from stokkart with (nolock) where tip=@stktip and kod=@stkkod

if @satfiytip='3'
select @kdvyuz=sat3kdv,@satfiy=case when sat3kdvtip='Dahil' then 
sat3fiy else sat3fiy*(1+(sat3kdv/100)) end 
from stokkart with (nolock) where tip=@stktip and kod=@stkkod

if @satfiytip='4'
select @kdvyuz=sat4kdv,@satfiy=case when sat4kdvtip='Dahil' then 
 sat4fiy else sat4fiy*(1+(sat4kdv/100)) end from stokkart with (nolock)
where tip=@stktip and kod=@stkkod


  


  if not EXISTS(select id from pomvardisayac
  where perkod=@perkod and sayackod=@kod and varno=@varno and firmano=@firmano and Sil=0)
  begin
    insert into pomvardisayac (firmano,varno,perkod,perad,adaid,adad,sayackod,otomaskod,sayacad,ilkendk,sonendk,OncekiSonEndk,transfermik,testmik,satmik,kdvyuz,brimfiy,tutar,tankod,stkod,stktip,enktur)
     values  (@firmano,@varno,@perkod,@perad,@grp1,@adad,@kod,@otomaskod,@ad,@ilkend,@ilkend,@ilkend,0,0,0,@kdvyuz/100,@satfiy,0,@tankkod,@stkkod,@stktip,@enktur);
  end


 FETCH NEXT FROM pomvardisayacac INTO  @grp1,@adad,@kod,@otomaskod,@ad,@satfiytip,@ilkend,@tankkod,@stkkod,@stktip,@enktur

  END
  CLOSE pomvardisayacac
  DEALLOCATE pomvardisayacac


 exec pomstoktankac @firmano,@varno

SET NOCOUNT OFF
 
END

================================================================================
