-- Trigger: dbo.carihrk_log_tri
-- Tablo: dbo.carihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.925362
================================================================================

CREATE TRIGGER [dbo].[carihrk_log_tri] ON [dbo].[carihrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'carihrk',1,''
end

================================================================================
