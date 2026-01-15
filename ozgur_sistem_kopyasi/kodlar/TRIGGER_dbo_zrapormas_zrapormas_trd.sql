-- Trigger: dbo.zrapormas_trd
-- Tablo: dbo.zrapormas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.047857
================================================================================

CREATE TRIGGER [dbo].[zrapormas_trd] ON [dbo].[zrapormas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

   declare @zrapid int

    select @zrapid=zrapid from deleted

    update zraporhrk set sil=1 where zrapid=@zrapid


END

================================================================================
