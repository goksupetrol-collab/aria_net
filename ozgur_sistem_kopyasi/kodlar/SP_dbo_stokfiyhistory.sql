-- Stored Procedure: dbo.stokfiyhistory
-- Tarih: 2026-01-14 20:06:08.382716
================================================================================

CREATE PROCEDURE [dbo].stokfiyhistory @id int
AS
BEGIN


 insert into stokfiyathistory (kod,tip,sat1fiy,sat1kdv,sat1kdvtip,
 sat2fiy,sat2kdv,sat2kdvtip,alsfiy,alskdv,alskdvtip)
 select kod,tip,sat1fiy,sat1kdv,sat1kdvtip,
 sat2fiy,sat2kdv,sat2kdvtip,alsfiy,alskdv,alskdvtip from stokkart where id=@id
  
  
  
  
END

================================================================================
