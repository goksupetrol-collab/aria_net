-- Trigger: dbo.gelgidkart_log_tri
-- Tablo: dbo.gelgidkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.947841
================================================================================

CREATE TRIGGER [dbo].[gelgidkart_log_tri] ON [dbo].[gelgidkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'gelgidkart',1,''
end

================================================================================
