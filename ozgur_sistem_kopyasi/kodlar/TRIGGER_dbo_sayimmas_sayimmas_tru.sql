-- Trigger: dbo.sayimmas_tru
-- Tablo: dbo.sayimmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.019623
================================================================================

CREATE TRIGGER [dbo].[sayimmas_tru] ON [dbo].[sayimmas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @drm varchar(5)
declare @sil int
declare @sayid float
declare @mesaj varchar(500)

 select @sayid=sayid,@sil=sil,@drm=drm from inserted


 if isnull(@sayid,0)=0
  return


if update(sil)
 begin
 if (@sil=1) and (@drm='O') 
  begin
       SELECT @mesaj = 'Sayımın Onayını Kaldırmadan Sayımı Silemezsiniz..!'
       RAISERROR (@mesaj, 16,1)
       ROLLBACK TRANSACTION
   RETURN
  end
 end
 
 update sayimhrk set drm=@drm,sil=@sil where sayid=@sayid


if update(drm) or update(sil)
begin
if @sil=1 or @drm='B'
  delete from carihrk where islmtip='SAY' AND fisfatid=@sayid
end

if update(drm) 
exec sayimonayla @sayid,@drm



END

================================================================================
