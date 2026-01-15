-- Trigger: dbo.stkdeptrs_log_tri
-- Tablo: dbo.stkdeptrs
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.027759
================================================================================

CREATE TRIGGER [dbo].[stkdeptrs_log_tri] ON [dbo].[stkdeptrs]
WITH EXECUTE AS CALLER
FOR INSERT
AS
begin
  Declare @firmano int,@id int,@islem int
  Select @firmano=firmano,@id=id from inserted
  exec sp_loglama @firmano,@id,'stkdeptrs',1,''
end

================================================================================
