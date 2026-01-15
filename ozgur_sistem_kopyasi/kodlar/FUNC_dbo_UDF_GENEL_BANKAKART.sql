-- Function: dbo.UDF_GENEL_BANKAKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.717840
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_BANKAKART (
@FIRMANO  INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_BANKAKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BORC              FLOAT,
    ALACAK            FLOAT,
    BAKIYE            FLOAT)
AS
BEGIN


  IF @FIRMANO>0
  INSERT @TB_GENEL_BANKAKART (KOD,AD,
  BORC,ALACAK,BAKIYE)
  select k.kod,k.ad,
  isnull(sum(h.borc),0),
  isnull(sum(h.alacak),0),
  isnull(sum(h.borc-h.alacak),0)
  FROM bankakart as k with (nolock)
  inner join bankahrk as h with (nolock) on k.kod=h.bankod
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and k.sil=0 and h.firmano=@FIRMANO
  group by k.kod,k.ad
  else
  INSERT @TB_GENEL_BANKAKART (KOD,AD,
  BORC,ALACAK,BAKIYE)
  select k.kod,k.ad,
  isnull(sum(h.borc),0),
  isnull(sum(h.alacak),0),
  isnull(sum(h.borc-h.alacak),0)
  FROM bankakart as k with (nolock)
  inner join bankahrk as h with (nolock) on k.kod=h.bankod
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and k.sil=0
  group by k.kod,k.ad
  
  
  

  RETURN

end

================================================================================
