-- Trigger: dbo.siparismas_log_tri
-- Tablo: dbo.siparismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.024456
================================================================================

CREATE TRIGGER [dbo].[siparismas_log_tri] ON [dbo].[siparismas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'siparismas',1,''
end

================================================================================
