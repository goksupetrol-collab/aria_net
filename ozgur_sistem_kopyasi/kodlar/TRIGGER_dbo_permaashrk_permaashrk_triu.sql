-- Trigger: dbo.permaashrk_triu
-- Tablo: dbo.permaashrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.995451
================================================================================

CREATE TRIGGER [dbo].[permaashrk_triu] ON [dbo].[permaashrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @id int
declare @sil int
declare @permasmasid int

  SELECT @id=id,@permasmasid=permaashrkid,@sil=sil from inserted;


 exec personelmaas @id,@sil



END

================================================================================
