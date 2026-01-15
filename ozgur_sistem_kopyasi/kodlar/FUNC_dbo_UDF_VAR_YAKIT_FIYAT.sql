-- Function: dbo.UDF_VAR_YAKIT_FIYAT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.798532
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_YAKIT_FIYAT] 
(@VARIN VARCHAR(4000),@tip varchar(30))
RETURNS
  @TB_YAKIT_FIYAT TABLE (
    STOK_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD     VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_ADI     VARCHAR(150)  COLLATE Turkish_CI_AS,
    VAR_LITRE         FLOAT,
    VAR_FIYAT		  FLOAT,
    VAR_TUTAR		  FLOAT,
    SAT_FIYAT         FLOAT,
    SAT_TUTAR		  FLOAT,
    IND_TUTAR		  FLOAT   
    )
AS
BEGIN
  
 
 
  if @tip='pomvardimas'
  begin
  INSERT @TB_YAKIT_FIYAT (STOK_TIP,STOK_KOD,STOK_ADI,VAR_LITRE,VAR_FIYAT,SAT_FIYAT)
  select ot.stktip,ot.stkod,k.ad,
    sum(ot.satmik),
   case when sum(ot.satmik)>0 then 
    sum(ot.satmik * ot.brimfiy)/ sum(ot.satmik) else 0 END,
    0
    FROM  pomvardisayac as ot with (nolock)
   inner join pomvardimas as p  with (nolock) on 
   p.varno=ot.varno
   inner join stokkart as k with (nolock) on k.kod=ot.stkod and k.tip=ot.stktip 
   where p.varno in (select * from CsvToInt(@VARIN))
   group by ot.stktip,ot.stkod,k.ad
   order by k.ad
   
  
  
  
  
  
   update @TB_YAKIT_FIYAT set 
   SAT_FIYAT=DT.fiyat from @TB_YAKIT_FIYAT as t 
  join (select stkod,max(round(ot.brimfiy,3)) as fiyat 
   FROM  pomvardisayac as ot with (nolock)
   inner join pomvardimas as p  with (nolock) on 
   p.varno=ot.varno
   where p.varno in (select * from CsvToInt(@VARIN))  
   group by ot.stkod ) dt 
   on t.STOK_KOD=dt.stkod
  
  
  update @TB_YAKIT_FIYAT 
  set VAR_TUTAR=VAR_LITRE*VAR_FIYAT,
  SAT_TUTAR=VAR_LITRE*SAT_FIYAT 
  
   
  update @TB_YAKIT_FIYAT set IND_TUTAR=SAT_TUTAR-VAR_TUTAR
 
  
  
  end



 /*
  if @tip='marvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad,sum(case when h.ackfaz='fazla' then tutar else 0 end),
  sum(case when h.ackfaz='acik' then tutar else 0 end)
  FROM  marvardikap as h
  inner join perkart as ck on ck.kod=h.kod and h.cartip='perkart'
  inner join grup as gp on gp.id=ck.grp1
  where h.varno in (select * from @EKSTRE_TEMP) and h.sil=0
  group by h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad
  end
  
  
  
   if @tip='resvardimas'
  begin
  INSERT @TB_TAH_ODE_TOPLAM (CARI_TIP,CARI_KOD,CARI_ADI,CARI_GRUP,GIREN,CIKAN)
  select h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad,sum(case when h.ackfaz='fazla' then tutar else 0 end),
  sum(case when h.ackfaz='acik' then tutar else 0 end)
  FROM  resvardikap as h
  inner join perkart as ck on ck.kod=h.kod and h.cartip='perkart'
  inner join grup as gp on gp.id=ck.grp1
  where h.varno in (select * from @EKSTRE_TEMP) and h.sil=0
  group by h.cartip,h.kod,ck.ad+' '+ck.soyad,gp.ad
  end
*/



  RETURN

end

================================================================================
