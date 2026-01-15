-- Trigger: dbo.raporlar_triu
-- Tablo: dbo.raporlar
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.008890
================================================================================

CREATE TRIGGER [dbo].[raporlar_triu] ON [dbo].[raporlar]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
  
 declare @rapgrp    varchar(50) 

 select @rapgrp=rapgrp from inserted

 exec yetki_evrak_olustur @rapgrp
 



END

================================================================================
