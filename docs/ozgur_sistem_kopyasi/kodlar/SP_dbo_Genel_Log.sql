-- Stored Procedure: dbo.Genel_Log
-- Tarih: 2026-01-14 20:06:08.332420
================================================================================

CREATE PROCEDURE [dbo].Genel_Log @yertip varchar(30),@id float,@islemtip int
AS
BEGIN
  
 insert into genellog (tarih,yertip,islemno,islemtip,aktip)
 values (GETDATE(),@yertip,@id,@islemtip,0)

END

================================================================================
