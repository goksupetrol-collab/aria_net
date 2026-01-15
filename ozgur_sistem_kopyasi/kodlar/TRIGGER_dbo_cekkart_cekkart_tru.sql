-- Trigger: dbo.cekkart_tru
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.935015
================================================================================

CREATE TRIGGER [dbo].[cekkart_tru] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @cekid 		float
declare @hrk 		varchar(10)
declare @drm 		varchar(10)
declare @drmad 		varchar(20)
declare @cartur 	varchar(30)
declare @cartip 	varchar(20)
declare @carkod 	varchar(20)
declare @tar 		datetime
declare @saat 		varchar(8)
declare @varno 		float
declare @sil 		int
declare @yertip 	varchar(50)
declare @tahodeid 	float


select @cekid=cekid,@varno=varno,@sil=sil,@yertip=yertip,
@tahodeid=tahodeid from inserted


 if update(varok)
  return
 
 
 
  /*Vardiyada alınan cek olucak sadece  */
  if @yertip='pomvardimas' 
   update pomvardimas set cektop=isnull(dt.tutar,0) from pomvardimas as t 
    join (select 
    sum(case when sil=0 then abs(giren)*kur else 0 end)  as tutar from cekkart 
    where varno=@varno and yertip=@yertip and cartip='vardicek') dt 
    on t.varno=@varno
 
 


if update(sil) and (@sil=1)
begin
  delete from cekhrk where cekid=@cekid
  delete from bankahrk where masterid=@cekid and karsihestip='cekkart'
  delete from carihrk where  masterid=@cekid  and karsihestip='cekkart'
  delete from kasahrk where  masterid=@cekid  and karsihestip='cekkart'
  
  delete from TahsilatOdeme where id=@tahodeid
end

if not update(drm) and (@sil=0)
 begin
     insert into cekhrk (firmano,cekid,gctip,yertip,yerad,tarih,saat,ack,
     olususer,olustarsaat,drm,drmad,aktif,
     tutar,cartip_id,cartip,car_id,carkod)
     (select m.firmano,cekid,gctip,yertip,yerad,tarih,saat,ack,
     deguser,degtarsaat,drm,drmad,
     case when (drm='POR') OR (drm='KSN') then 1 else 0 end,
     case when (giren)>0 then abs(giren) else abs(cikan) end,
     case when gctip='C' then vercartip_id else cartip_id end,
     case when gctip='C' then vercartip else cartip end,
     case when gctip='C' then vercar_id else car_id end,
     case when gctip='C' then vercarkod else carkod end
     from cekkart as m where cekid=@cekid)
 end



END

================================================================================
