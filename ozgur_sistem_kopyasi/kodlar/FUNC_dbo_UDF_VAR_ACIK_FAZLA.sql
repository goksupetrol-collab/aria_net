-- Function: dbo.UDF_VAR_ACIK_FAZLA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.773793
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_ACIK_FAZLA (@VARNIN VARCHAR(max),@tip varchar(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD     VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_ADI     VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP    VARCHAR(100)  COLLATE Turkish_CI_AS,
    GIREN         FLOAT,
    CIKAN         FLOAT)
AS
BEGIN
 
 
 
  if @tip='pomvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad,sum(case when h.ackfaz='fazla' then tutar else 0 end),
  sum(case when h.ackfaz='acik' then tutar else 0 end)
  FROM  pomvardikap as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.kod and h.cartip='perkart'
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from CsvToInt_Max(@VARNIN)) and h.varok=1
  and h.sil=0
  group by h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad
  end

  if @tip='marvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad,sum(case when h.ackfaz='fazla' then tutar else 0 end),
  sum(case when h.ackfaz='acik' then tutar else 0 end)
  FROM  marvardikap as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.kod and h.cartip='perkart'
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from CsvToInt_Max(@VARNIN)) and h.sil=0
  group by h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad
  end
  
  
  
   if @tip='resvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad,sum(case when h.ackfaz='fazla' then tutar else 0 end),
  sum(case when h.ackfaz='acik' then tutar else 0 end)
  FROM  resvardikap as h with (nolock)
  inner join perkart as ck with (nolock) on ck.kod=h.kod and h.cartip='perkart'
  inner join grup as gp with (nolock) on gp.id=ck.grp1
  where h.varno in (select * from CsvToInt_Max(@VARNIN)) and h.sil=0
  group by h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad
  end




  RETURN

end

================================================================================
