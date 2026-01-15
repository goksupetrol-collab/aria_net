-- Trigger: dbo.kasakart_tru
-- Tablo: dbo.kasakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.969641
================================================================================

CREATE TRIGGER [dbo].[kasakart_tru] ON [dbo].[kasakart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

declare @kaskod varchar(30)
declare @mesaj  varchar(250)
declare @sil    int

select @kaskod=kod,@sil=sil from inserted

 if @sil=1
 begin
 IF (SELECT COUNT(*) FROM kasahrk WHERE kaskod=@kaskod and sil=0) > 0
   BEGIN
      SELECT @mesaj = '"'+@kaskod+ '" Kodunun Hareketi Var! Silemezsiniz..!'
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      return
  END
  end




END

================================================================================
