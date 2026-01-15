-- Stored Procedure: dbo.carifisaktaroto
-- Tarih: 2026-01-14 20:06:08.317386
================================================================================

CREATE PROCEDURE [dbo].carifisaktaroto (@tar datetime,@verid float)
AS
BEGIN

declare @newid float
declare @fistip varchar(15)
declare @gctip varchar(1)
declare @borc float,@alacak float
declare @fistutar float
declare @islmtip varchar(10)
declare @islmhrk varchar(10)
declare @aktip   varchar(10)
declare @aktar  datetime



declare @islmtipad varchar(30)
declare @islmhrkad varchar(30)

set @islmtip='FIS'
set @islmhrk='CAK'

select @islmtipad=ad from islemturtip where tip=@islmtip
select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk


SET @aktip='CH'
  
   DECLARE carifisaktarotoaktar CURSOR FAST_FORWARD FOR
   SELECT vs.verid,vs.fistip,vs.toptut FROM veresimas as vs with (nolock) 
   inner join carikart as ck with (nolock) on ck.kod=vs.carkod and vs.cartip='carikart'
   and vs.aktip='BK' and vs.sil=0 and vs.varok=1 and ck.otofisak=1 and vs.verid=@verid
   

   
   OPEN carifisaktarotoaktar

  FETCH NEXT FROM carifisaktarotoaktar INTO @verid,@fistip,@fistutar
  WHILE @@FETCH_STATUS = 0
  BEGIN
  

  set @borc=0
  set @alacak=0
  
  if @fistip='FISVERSAT'
  begin
  set @gctip='B'
  set @borc=@fistutar
  end
  
  if @fistip='FISALCSAT'
  begin
  set @gctip='A'
  set @alacak=@fistutar
  end
  
  

  select @newid=0
  insert into carihrk (carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,fisaktip)
  select @newid,@gctip,@verid,@islmtip,@islmtipad,@islmhrk,@islmhrkad,yertip,yerad,
  cartip,carkod,@borc,@alacak,tarih,saat,olususer,olustarsaat,vadtar,seri+cast([no] as varchar),
  ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,@aktip
  from veresimas with (nolock) where verid=@verid
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid

  set @aktar=convert(varchar,getdate(),101);

  update veresimas set aktip=@aktip,akid=@newid,aktar=@aktar where verid=@verid


  FETCH NEXT FROM carifisaktarotoaktar  INTO @verid,@fistip,@fistutar
  END

  CLOSE carifisaktarotoaktar
  DEALLOCATE carifisaktarotoaktar



  
  
END

================================================================================
