-- Function: dbo.UDF_VAR_PERTAH_ODE_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.786794
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_PERTAH_ODE_TOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD     VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_ADI     VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_GRUP    VARCHAR(50) COLLATE Turkish_CI_AS,
    GIREN         FLOAT,
    CIKAN         FLOAT,
    BELGENO       VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA      VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLEM         VARCHAR(50) COLLATE Turkish_CI_AS)
AS
BEGIN
 

  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN,
  BELGENO,ACIKLAMA,ISLEM)
  select h.cartip,h.carkod,ck.ad+' '+ck.soyad,gp.ad,(h.giren),(h.cikan),
  h.belno,h.ack,h.islmhrkad
  FROM  kasahrk as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.carkod and h.cartip='perkart'
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from dbo.CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP
  
  
  
  
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN,
  BELGENO,ACIKLAMA,ISLEM)
  select h.cartip,h.carkod,ck.ad+' '+ck.soyad,gp.ad,
  (h.borc),(h.alacak),
  h.belno,h.ack,h.islmhrkad
  FROM  bankahrk as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.carkod and h.cartip='perkart'
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from dbo.CsvToInt_Max(@VARNIN))
  and h.sil=0 and h.yertip=@TIP

  
  
  
  

  RETURN

end

================================================================================
