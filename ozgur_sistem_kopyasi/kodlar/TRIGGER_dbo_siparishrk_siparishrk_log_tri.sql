-- Trigger: dbo.siparishrk_log_tri
-- Tablo: dbo.siparishrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.022661
================================================================================

CREATE TRIGGER [dbo].[siparishrk_log_tri] ON [dbo].[siparishrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'siparishrk',1,''
end

================================================================================
