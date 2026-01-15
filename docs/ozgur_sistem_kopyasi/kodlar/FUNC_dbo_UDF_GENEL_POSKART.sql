-- Function: dbo.UDF_GENEL_POSKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.722735
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_POSKART (
@FIRMANO   INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_POSKART TABLE (
    KOD               VARCHAR(50)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BEKLEYEN          FLOAT)
AS
BEGIN

  IF @FIRMANO>0
  INSERT @TB_GENEL_POSKART (KOD,AD,
  BEKLEYEN)
  select k.kod,k.ad,
  isnull(sum(h.giren),0)
  FROM poskart as k with (nolock)
  inner join poshrk as h with (nolock) 
  on k.kod=h.poskod and h.firmano=@FIRMANO
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  group by k.kod,k.ad
  else
  INSERT @TB_GENEL_POSKART (KOD,AD,
  BEKLEYEN)
  select k.kod,k.ad,
  isnull(sum(h.giren),0)
  FROM poskart as k with (nolock)
  inner join poshrk as h with (nolock) 
  on k.kod=h.poskod
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  group by k.kod,k.ad

  RETURN

end

================================================================================
