-- Function: dbo.UDF_CARILITRE_GRUP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.700847
================================================================================

CREATE FUNCTION [dbo].UDF_CARILITRE_GRUP (
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_STOKLITRE_EKSTRE TABLE (
    STOK_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    STOK_TIP    VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)    COLLATE Turkish_CI_AS)

  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_STOK_AD     VARCHAR(50)


  /* Devir atanıyor */
  /*---------------------------------------------------------------------------- */
  INSERT @EKSTRE_TEMP
    SELECT
       stktip,stkod,k.ad
       FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip
       WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
       AND (m.tarih <= @TARIH2)
       group by h.stktip,h.stkod,k.ad
       
       
  /*---------------------------------------------------------------------------- */

  INSERT @TB_STOKLITRE_EKSTRE
    SELECT STOK_TIP,STOK_KOD,STOK_AD FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
