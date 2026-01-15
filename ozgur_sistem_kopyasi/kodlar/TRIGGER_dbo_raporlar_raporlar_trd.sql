-- Trigger: dbo.raporlar_trd
-- Tablo: dbo.raporlar
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.008414
================================================================================

CREATE TRIGGER [dbo].[raporlar_trd] ON [dbo].[raporlar]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

 declare @rapgrp    varchar(50) 

 select @rapgrp=rapgrp from deleted

 exec yetki_evrak_olustur @rapgrp
 
END

================================================================================
