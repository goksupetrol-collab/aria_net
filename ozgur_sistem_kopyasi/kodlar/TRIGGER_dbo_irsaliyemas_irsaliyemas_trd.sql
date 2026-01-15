-- Trigger: dbo.irsaliyemas_trd
-- Tablo: dbo.irsaliyemas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.956036
================================================================================

CREATE TRIGGER [dbo].[irsaliyemas_trd] ON [dbo].[irsaliyemas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
 declare @irid float
 select @irid=irid from deleted
 
  exec stokhrkisle @irid,'irsaliyehrk','',1,1,@irid 
 
  delete from irsaliyehrk where irid=@irid
END

================================================================================
