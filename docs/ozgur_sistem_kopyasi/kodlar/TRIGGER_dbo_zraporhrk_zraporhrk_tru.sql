-- Trigger: dbo.zraporhrk_tru
-- Tablo: dbo.zraporhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.047482
================================================================================

CREATE TRIGGER [dbo].[zraporhrk_tru] ON [dbo].[zraporhrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @zrapid int

 select @zrapid=zrapid from inserted;

update zrapormas set toptut=
(select isnull(sum(miktar*brmfiy),0) from zraporhrk where zrapid=@zrapid and sil=0)
where zrapid=@zrapid


END

================================================================================
