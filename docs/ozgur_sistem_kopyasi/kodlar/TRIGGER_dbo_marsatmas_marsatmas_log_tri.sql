-- Trigger: dbo.marsatmas_log_tri
-- Tablo: dbo.marsatmas
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.975111
================================================================================

CREATE TRIGGER [dbo].[marsatmas_log_tri] ON [dbo].[marsatmas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'marsatmas',1,''
end

================================================================================
