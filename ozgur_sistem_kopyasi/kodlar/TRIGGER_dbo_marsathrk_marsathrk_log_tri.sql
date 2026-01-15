-- Trigger: dbo.marsathrk_log_tri
-- Tablo: dbo.marsathrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.972370
================================================================================

CREATE TRIGGER [dbo].[marsathrk_log_tri] ON [dbo].[marsathrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'marsathrk',1,''
end

================================================================================
