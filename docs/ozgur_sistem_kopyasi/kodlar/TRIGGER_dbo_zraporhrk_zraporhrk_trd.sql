-- Trigger: dbo.zraporhrk_trd
-- Tablo: dbo.zraporhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.047063
================================================================================

CREATE TRIGGER [dbo].[zraporhrk_trd] ON [dbo].[zraporhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN


declare @zrapid int

 select @zrapid=zrapid from deleted;

update zrapormas set toptut=
(select isnull(sum(miktar*brmfiy),0) from zraporhrk where zrapid=@zrapid and sil=0)
where zrapid=@zrapid


END

================================================================================
