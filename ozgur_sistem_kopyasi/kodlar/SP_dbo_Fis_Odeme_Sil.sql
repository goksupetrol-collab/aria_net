-- Stored Procedure: dbo.Fis_Odeme_Sil
-- Tarih: 2026-01-14 20:06:08.329872
================================================================================

CREATE PROCEDURE [dbo].Fis_Odeme_Sil @verid int 
AS
BEGIN
  
 /* kasahrk  sil */
   if @verid=0
     RETURN
    
      update kasahrk set sil=1 
       where fisfatid=@verid and fisfattip='FIS'


END

================================================================================
