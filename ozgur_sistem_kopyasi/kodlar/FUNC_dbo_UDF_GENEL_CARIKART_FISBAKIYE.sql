-- Function: dbo.UDF_GENEL_CARIKART_FISBAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.718739
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_CARIKART_FISBAKIYE(
@FIRMANO  INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_CARIKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BAKIYE            FLOAT)
AS
BEGIN
  /*--tum veresiye fişleri geliyor aktarılmıs ve aktarılmamıslar */
  
  if @FIRMANO>0
  INSERT @TB_GENEL_CARIKART (KOD,AD,
  BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(v.toptut),0)
  FROM carikart as k with (nolock)
  inner join veresimas as v with (nolock) on 
  k.kod=v.carkod and v.cartip='carikart' and v.firmano=@FIRMANO
  and v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.sil=0 and k.sil=0
  group by k.kod,k.unvan
  else
  INSERT @TB_GENEL_CARIKART (KOD,AD,
  BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(v.toptut),0)
  FROM carikart as k with (nolock)
  inner join veresimas as v with (nolock) on 
  k.kod=v.carkod and v.cartip='carikart' 
  and v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.sil=0 and k.sil=0
  group by k.kod,k.unvan 


  RETURN

end

================================================================================
