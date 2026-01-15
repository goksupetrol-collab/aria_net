-- Trigger: dbo.kasahrk_trd
-- Tablo: dbo.kasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.966486
================================================================================

CREATE TRIGGER [dbo].[kasahrk_trd] ON [dbo].[kasahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @varno 		float
declare @idx 		float
declare @kaskod 	varchar(20)
declare @yertip 	varchar(20)
declare @naktop 	float
declare @pro 		int
declare @kashrkid 	float
declare @masterid 	float
declare @giren 		float
declare @cikan 		float
declare @kur 		float
declare @islmtip 	varchar(10)
declare @islmhrk 	varchar(10)
declare @fisfatid 	float
declare @fisfattip 	varchar(10)
declare @sil 		int
declare @varok 		int
declare @tarih 		datetime

  DECLARE kasahrk_del CURSOR LOCAL FOR
  SELECT tarih,yertip,kashrkid,id,kaskod,varno,varok,
  islmtip,islmhrk,masterid,fisfatid,fisfattip,giren,cikan,kur,sil
  from deleted
  OPEN kasahrk_del
  FETCH NEXT FROM kasahrk_del INTO @tarih,@yertip,@kashrkid,@idx,@kaskod,@varno,
  @varok,@islmtip,@islmhrk,@masterid,@fisfatid,@fisfattip,@giren,@cikan,@kur,@sil
  WHILE @@FETCH_STATUS = 0
  BEGIN

  exec kasahrkgiris @kashrkid,1

  if (@yertip='pomvardimas')
  begin

  if (@islmtip='TAH') and (@islmhrk='TES')
  update pomvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0)  where varno=@varno

  /*-tahsilat toplamı */
  if (@islmtip='TAH') and (@islmhrk='NAK')
  update pomvardimas set tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   where varno=@varno


 /*-odeme toplamı */
 if (@islmtip='ODE') and (@islmhrk='NAK')
 update pomvardimas set odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='ODE' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
 where varno=@varno
end

if (@yertip='marvardimas')
begin
update marvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0)
where varno=@varno

/*-tahsilat toplamı */
if (@islmtip='TAH') and (@islmhrk='NAK')
update marvardimas set tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

/*-ödeme toplamı */
if (@islmtip='ODE') and (@islmhrk='NAK')
update marvardimas set odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='ODE' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

end


if (@yertip='resvardimas')
begin
update resvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0)
where varno=@varno

/*-tahsilat toplamı */
if (@islmtip='TAH') and (@islmhrk='NAK')
update resvardimas set tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

/*-ödeme toplamı */
if (@islmtip='ODE') and (@islmhrk='NAK')
update resvardimas set odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='ODE' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

end


if (@fisfattip='FAT')
begin
update faturamas set odemetop=
   (select isnull(sum((giren+cikan)*kur),0) from kasahrk
   where sil=0 and fisfattip=@fisfattip and fisfatid=@fisfatid)
where fatid=@fisfatid
end

  FETCH NEXT FROM kasahrk_del INTO @tarih,@yertip,@kashrkid,@idx,@kaskod,@varno,
  @varok,@islmtip,@islmhrk,@masterid,@fisfatid,@fisfattip,@giren,@cikan,@kur,@sil
  END

  CLOSE kasahrk_del
  DEALLOCATE kasahrk_del
END

================================================================================
