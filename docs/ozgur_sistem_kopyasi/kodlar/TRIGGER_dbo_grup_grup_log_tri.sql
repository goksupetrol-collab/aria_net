-- Trigger: dbo.grup_log_tri
-- Tablo: dbo.grup
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.950553
================================================================================

CREATE TRIGGER [dbo].[grup_log_tri] ON [dbo].[grup]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'grup',1,''
end

================================================================================
