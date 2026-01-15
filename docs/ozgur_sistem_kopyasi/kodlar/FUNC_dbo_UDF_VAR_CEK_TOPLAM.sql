-- Function: dbo.UDF_VAR_CEK_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.778914
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_CEK_TOPLAM (
@VARNIN VARCHAR(max),@TIP VARCHAR(30)
)
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_KOD     VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_AD      VARCHAR(150)   COLLATE Turkish_CI_AS,
    CARI_GRUP    VARCHAR(50)  COLLATE Turkish_CI_AS,
    CEKNO        VARCHAR(50)  COLLATE Turkish_CI_AS,
    REFERANSNO   VARCHAR(50)  COLLATE Turkish_CI_AS,
    BANKA_AD	 VARCHAR(70)  COLLATE Turkish_CI_AS,	
    BANKA_SUBE   VARCHAR(70)  COLLATE Turkish_CI_AS,
    KESIDECI     VARCHAR(100)  COLLATE Turkish_CI_AS,
    CEKTUTAR     FLOAT,
    VADETARIHI   DATETIME)
AS
BEGIN
  

  INSERT @TB_TAH_ODE_TOPLAM (CARI_KOD,CARI_AD,CARI_GRUP,CEKNO,
  REFERANSNO,BANKA_AD,BANKA_SUBE,KESIDECI,
  CEKTUTAR,VADETARIHI)
  select h.carkod,ck.ad,ck.grupad1,h.ceksenno,h.refno,
  h.banka,h.banksub,h.kesideci,
  (h.giren*kur),h.vadetar
  FROM  cekkart as h with (nolock)
  inner join Genel_Kart as ck with (nolock) on ck.kod=h.carkod and ck.cartp=h.cartip
  where h.varno in (select * from CsvToInt_Max(@VARNIN) )
  and h.sil=0 
  and h.yertip=@TIP

  RETURN

end

================================================================================
