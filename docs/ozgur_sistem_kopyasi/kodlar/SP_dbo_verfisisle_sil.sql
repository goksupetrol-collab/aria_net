-- Stored Procedure: dbo.verfisisle_sil
-- Tarih: 2026-01-14 20:06:08.389437
================================================================================

CREATE PROCEDURE [dbo].verfisisle_sil @fatid float
AS
BEGIN

 if @fatid=0
  return

  update veresimas set aktip='BK',aktar=NULL,akid=0,fatid=0 where
   fatid=@fatid


END

================================================================================
