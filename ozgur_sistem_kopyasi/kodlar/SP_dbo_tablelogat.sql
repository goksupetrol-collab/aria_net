-- Stored Procedure: dbo.tablelogat
-- Tarih: 2026-01-14 20:06:08.384684
================================================================================

CREATE PROCEDURE [dbo].tablelogat @tabload varchar(30),@islemtip char,@id float
AS
BEGIN
/*islemtip */
/*I insert */
/*U update */
/*D delete */
  
  
insert into tablelog (tablead,islemtip,hrkid) values (@tabload,@islemtip,@id)
  
  
END

================================================================================
