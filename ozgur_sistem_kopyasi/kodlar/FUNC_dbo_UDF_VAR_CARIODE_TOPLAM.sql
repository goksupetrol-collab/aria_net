-- Function: dbo.UDF_VAR_CARIODE_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.777931
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_CARIODE_TOPLAM (@VARNIN VARCHAR(4000),@TIP VARCHAR(30))
RETURNS
  @TB_CARI_TAH_TOPLAM TABLE (
    CARI_TIP      VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD      VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN    VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH         DATETIME,
    BELGENO       VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA      VARCHAR(100) COLLATE Turkish_CI_AS,
    TUTAR         FLOAT,
    ISLEM         VARCHAR(50) COLLATE Turkish_CI_AS)
AS
BEGIN
  
  INSERT @TB_CARI_TAH_TOPLAM (CARI_TIP,CARI_KOD,CARI_UNVAN,TARIH,BELGENO,
  ACIKLAMA,TUTAR,ISLEM)
  select h.cartip,h.carkod,ck.ad,h.tarih,h.belno,h.ack,h.cikan,h.islmhrkad
  FROM  kasahrk as h
  inner join Genel_Kart as ck on ck.kod=h.carkod and h.cartip=ck.cartp
  where h.cikan>0 and h.islmhrk<>'VTO' 
  and h.varno in (select * from CsvToInt(@VARNIN)) 
  and h.sil=0 and h.yertip=@TIP


  RETURN

end

================================================================================
