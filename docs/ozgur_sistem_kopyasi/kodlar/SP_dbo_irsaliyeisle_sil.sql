-- Stored Procedure: dbo.irsaliyeisle_sil
-- Tarih: 2026-01-14 20:06:08.337763
================================================================================

CREATE PROCEDURE [dbo].irsaliyeisle_sil @fatid float
AS
BEGIN

 update irsaliyemas set aktip='BK',aktar=NULL,akid=0,fatid=0
 where fatid=@fatid


END

================================================================================
