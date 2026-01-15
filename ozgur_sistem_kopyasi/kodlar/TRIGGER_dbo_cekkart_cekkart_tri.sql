-- Trigger: dbo.cekkart_tri
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.934672
================================================================================

CREATE TRIGGER [dbo].[cekkart_tri] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @cekid float
declare @hrk varchar(10),@drm varchar(10),@drmad varchar(20)
declare @cartur varchar(30),@cartip varchar(20),@carkod varchar(20)
declare @tar datetime,@saat varchar(8)
declare @varno float,@pro int
declare @yertip varchar(50)

select @cekid=cekid,@varno=varno,@pro=pro,@yertip=yertip from inserted

 if @yertip='pomvardimas' 
   update pomvardimas set cektop=isnull(dt.tutar,0) from pomvardimas as t 
    join (select 
    sum(case when sil=0 then abs(giren-cikan)*kur else 0 end)  as tutar from cekkart 
    where varno=@varno and yertip=@yertip and cartip='vardicek') dt 
    on t.varno=@varno



/*exec cekhrkgiris @cekid */

insert into cekhrk (firmano,cekid,gctip,yertip,yerad,tarih,saat,ack,
olususer,olustarsaat,drm,drmad,tutar,cartip_id,cartip,car_id,carkod)
(select firmano,cekid,gctip,yertip,yerad,tarih,saat,ack,
olususer,olustarsaat,drm,drmad,abs(giren-cikan),
case when gctip='C' then vercartip_id else cartip_id end,
case when gctip='C' then vercartip else cartip end,
case when gctip='C' then vercar_id else car_id end,
case when gctip='C' then vercarkod else carkod end
 from cekkart as m
where cekid=@cekid)



END

================================================================================
