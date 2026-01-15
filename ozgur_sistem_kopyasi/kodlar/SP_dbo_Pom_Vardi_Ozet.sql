-- Stored Procedure: dbo.Pom_Vardi_Ozet
-- Tarih: 2026-01-14 20:06:08.353879
================================================================================

CREATE PROCEDURE [dbo].Pom_Vardi_Ozet (@VARNIN VARCHAR(8000))
AS
BEGIN

 declare @sql nvarchar(500);
 declare @acik float,@fazla float;
 declare @perkod varchar(50),@perad varchar(50);
 declare @yertip varchar(20)
 set @yertip='pomvardimas';
 
 declare @varno int

if object_id( 'tempdb..#PEKSTRE_TEMP' ) is null
CREATE TABLE [dbo].[#PEKSTRE_TEMP] (
    VARNO      FLOAT)

 TRUNCATE TABLE #PEKSTRE_TEMP

 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@VARNIN)) > 0)
 BEGIN
  set @VARNIN = @VARNIN + ','
 END

 while patindex('%,%' , @VARNIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @VARNIN)
   select @array_value = left(@VARNIN, @separator_position - 1)

  Insert #PEKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @VARNIN = stuff(@VARNIN, 1, @separator_position, '')
 end
 

if object_id( 'tempdb..#pom_genel_ozet' ) is null
CREATE TABLE [dbo].[#pom_genel_ozet] (
  [id] int IDENTITY(1, 1) NOT NULL,
  [giris] float DEFAULT 0 NULL,
  [cikis] float DEFAULT 0 NULL,
  [tip] varchar(10) COLLATE Turkish_CI_AS NULL,
  [tipack] varchar(50) COLLATE Turkish_CI_AS NULL,
  [sr] float NULL)

  delete from #pom_genel_ozet 

  insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
  select 'AKSAT','Akaryakıt Sayaçlı Satış Tutarı',1,
  isnull(sum(tutar),0),0 from pomvardisayac where sil=0
  AND varno in (select * from #PEKSTRE_TEMP)


 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'VERAT','Veresiye Alacak Tutarı',2.0,
 isnull(sum(toptut),0),0 from veresimas
 where fistip='FISALCSAT' and sil=0 and ototag<>1 and yertip=@yertip
 AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'VERBT','Veresiye Borç Tutarı',2.1,0,isnull(sum(toptut),0)
 from veresimas
 where fistip='FISVERSAT' and sil=0 and ototag<>1 and yertip=@yertip
 AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'VEROT','Otomasyon Tutarı',2.2,0,isnull(sum(toptut),0)
 from veresimas
 where sil=0 and ototag=1 and yertip=@yertip
 AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'POSST','Pos Satış Tutarı',3,0,isnull(sum(giren*kur),0)
 from poshrk
 where sil=0 and yertip=@yertip
 AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'MALST','Yağ - Emtia Satış Tutarı',4,isnull(sum(tutar),0),0
 from emtiasat
 where sil=0 and yertip=@yertip
 AND varno in (select * from #PEKSTRE_TEMP)


 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'NAKTS','Nakit Teslimat Tutarı',5,0,isnull(sum(giren*kur),0)
 from kasahrk
 where sil=0 and yertip=@yertip and islmhrk='TES' and masterid=0
 AND varno in (select * from #PEKSTRE_TEMP)
 

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'ODETT','Ödeme Tutarı',6,0,isnull(sum(cikan*kur),0)
 from kasahrk
 where ((islmtip='ODE' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='YTN') )
 and sil=0 and yertip=@yertip AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'TAHTT','Tahsilat Tutarı',7,isnull(sum(giren*kur),0),0 from kasahrk
 where ((islmtip='TAH' and cartip<>'gelgidkart') or (islmtip='BNK' and islmhrk='CKN') )
 and sil=0 and yertip=@yertip  AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'GELIR','Gelir Tutarı',20,
 isnull(sum(giren*kur),0),0 from kasahrk
 where islmtip='TAH' and cartip='gelgidkart' and sil=0
 and yertip=@yertip  AND varno in (select * from #PEKSTRE_TEMP)


 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'GIDER','Gider Tutarı',21,0,isnull(sum(cikan*kur),0) from kasahrk
 where islmtip='ODE' and cartip='gelgidkart'
 and sil=0 and yertip=@yertip AND varno in (select * from #PEKSTRE_TEMP)

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 select 'ARATOP','Ara Toplam',40,sum(giris),sum(cikis)
 from #pom_genel_ozet 


 select @acik=(giris-cikis) from #pom_genel_ozet where tip='ARATOP'
  
 if @acik<0
 begin
 set @fazla=0;
 set @acik=-@acik;
 end
 else
 begin
 set @fazla=@acik;
 set @acik=0;
 end

 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 values('ACKFAZ','Fark',41,@acik,@fazla) ;

 select @acik=sum(giris),@fazla=sum(cikis) from #pom_genel_ozet
 where (tip='ARATOP' or tip='ACKFAZ')


 insert into #pom_genel_ozet (tip,tipack,sr,giris,cikis)
 values('GENTOP','Genel Toplam',42,@acik,@fazla)



select tipack AS ACIKLAMA,giris AS GIRIS,cikis AS CIKIS,sr AS SIRA from #pom_genel_ozet order by sr


END

================================================================================
