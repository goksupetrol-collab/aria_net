-- Function: dbo.UDF_GENEL_PERKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.722339
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_PERKART (
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_PERKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BORC              FLOAT,
    ALACAK            FLOAT,
    BAKIYE            FLOAT)
AS
BEGIN
  INSERT @TB_GENEL_PERKART (KOD,AD,
  BORC,ALACAK,BAKIYE)
  select k.kod,k.ad+' '+k.soyad,
  isnull(sum(h.borc),0),
  isnull(sum(h.alacak),0),
  isnull(sum(h.borc-h.alacak),0)
  FROM perkart as k
  inner join carihrk as h on k.kod=h.carkod and h.cartip='perkart'
  and h.sil=0 and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  group by k.kod,k.ad+' '+k.soyad

  RETURN

end

================================================================================
