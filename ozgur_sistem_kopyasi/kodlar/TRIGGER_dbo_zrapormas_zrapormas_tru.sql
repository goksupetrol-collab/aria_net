-- Trigger: dbo.zrapormas_tru
-- Tablo: dbo.zrapormas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.048210
================================================================================

CREATE TRIGGER [dbo].[zrapormas_tru] ON [dbo].[zrapormas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN


declare @sil int
declare @zrapid int
declare @masId int
declare @kayok int

 select @zrapid=zrapid,@kayok=kayok,@sil=sil,@masId=MasId from inserted

 if (update(kayok) or update(sil)) and (@kayok=1 or @sil=1)
  update zraporhrk set kayok=@kayok,sil=@sil 
  where zrapid=@zrapid and sil=0
  
  
  if @kayok=1
   update zrapormas set 
   masId=case when isnull(masId,0)=0 then id else masId end,
   genel_kdv_top=dt.kdv_top,
   genel_top=dt.toplam,
   Genel_Ara_Top=dt.Ara_top
   from zrapormas as t join 
   (select round(sum(brmfiy*miktar),2) as toplam,
   (sum( (brmfiy-(brmfiy/(1+kdvyuz)))*miktar) ) as kdv_top,
   ( (sum(brmfiy*miktar)-
   sum( (brmfiy-(brmfiy/(1+kdvyuz)))*miktar)) ) as Ara_Top
   from zraporhrk where zrapid=@zrapid and sil=0)
   dt on t.zrapid=@zrapid
   



END

================================================================================
