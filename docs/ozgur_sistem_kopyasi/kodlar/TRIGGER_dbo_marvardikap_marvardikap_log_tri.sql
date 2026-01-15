-- Trigger: dbo.marvardikap_log_tri
-- Tablo: dbo.marvardikap
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.978550
================================================================================

CREATE TRIGGER [dbo].[marvardikap_log_tri] ON [dbo].[marvardikap]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'marvardikap',1,''
end

================================================================================
