-- Stored Procedure: dbo.veresiyegiris
-- Tarih: 2026-01-14 20:06:08.387554
================================================================================

CREATE PROCEDURE [dbo].veresiyegiris @hrkid float
AS
BEGIN

declare @varno float
declare @baktop float
declare @newid float
declare @fistip varchar(3)
declare @gctip varchar(1)
declare @borc float,@alacak float
declare @tutar float
declare @say int

declare @cartip varchar(20)
declare @verid float

select @fistip=fistip,@verid=verid,
@tutar=toptut,@varno=varno,@cartip=cartip from veresimas with (nolock) 
where verid=@hrkid

set @borc=0
set @alacak=0

if @fistip='BOR'
begin
set @gctip='B'
set @borc=@tutar
end

if @fistip='ALC'
begin
set @gctip='A'
set @alacak=@tutar
end


if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
begin
  delete from carihrk where masterid=@hrkid and islmtip='FIS'

  select @newid=0
  insert into carihrk (carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
  cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,fisaktip)
  select @newid,@gctip,@verid,'FIS','Fiş Girişi',@fistip,fisad,yertip,yerad,
  cartip,carkod,@borc,@alacak,tarih,saat,olususer,olustarsaat,vadtar,seri+cast([no] as varchar),
  ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,aktip
  from veresimas with (nolock) where verid=@hrkid
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid


END

END

================================================================================
