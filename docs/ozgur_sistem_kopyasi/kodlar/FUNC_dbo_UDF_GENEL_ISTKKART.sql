-- Function: dbo.UDF_GENEL_ISTKKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.721271
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_ISTKKART (
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_ISTKKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(50)  COLLATE Turkish_CI_AS,
    BORC              FLOAT,
    ALACAK            FLOAT,
    BAKIYE            FLOAT)
AS
BEGIN
  INSERT @TB_GENEL_ISTKKART (KOD,AD,
  BORC,ALACAK,BAKIYE)
  select k.kod,k.ad,
  isnull(sum(h.borc),0),
  isnull(sum(h.alacak),0),
  isnull(sum(h.borc-h.alacak),0)
  FROM istkart as k
  inner join istkhrk as h on k.kod=h.istkkod
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and k.sil=0
  group by k.kod,k.ad

  RETURN

end

================================================================================
