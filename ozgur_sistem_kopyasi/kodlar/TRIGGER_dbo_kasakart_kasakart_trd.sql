-- Trigger: dbo.kasakart_trd
-- Tablo: dbo.kasakart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.969166
================================================================================

CREATE TRIGGER [dbo].[kasakart_trd] ON [dbo].[kasakart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN


declare @kaskod varchar(30)
declare @mesaj  varchar(250)

select @kaskod=kod from deleted

  IF (SELECT COUNT(*) FROM kasahrk WHERE kaskod=@kaskod and sil=0) > 0
    BEGIN
      SELECT @mesaj = '"'+@kaskod+ '" Kodunun Hareketi Var! Silemezsiniz..!'
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      return
    END

END

================================================================================
