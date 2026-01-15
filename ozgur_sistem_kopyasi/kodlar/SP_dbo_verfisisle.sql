-- Stored Procedure: dbo.verfisisle
-- Tarih: 2026-01-14 20:06:08.388967
================================================================================

CREATE PROCEDURE [dbo].verfisisle @fatid float
AS
BEGIN
declare @kaptip varchar(10)
declare @tarih datetime
declare @sql varchar(8000)
declare @kayok int,@sil int

declare @cartip varchar(20)
declare @carkod varchar(50)

select @kayok=kayok,@sil=sil,@tarih=tarih,
@sql=kapidler,
@kaptip=kaptip from faturamas WITH (NOLOCK) where fatid=@fatid

  if @fatid=0
   RETURN


if @kaptip='VER'
begin

 if @kayok=1 and @sil=0
 update veresimas  set aktip='FT',aktar=@tarih,akid=@fatid
 where fatid=@fatid

 if @kayok=0 or @sil=1
 begin
 select @cartip=cartip,@carkod=carkod from veresimas WITH (NOLOCK) where fatid=@fatid
 
 update veresimas  set aktip='BK',aktar=NULL,akid=0,fatid=0 /*from veresimas WITH (NOLOCK) */
 where fatid=@fatid
 

 end

end;

END

================================================================================
