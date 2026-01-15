-- Function: dbo.UDF_VAR_AKARYAKIT_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.774160
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_AKARYAKIT_SATIS 
(@VARNIN VARCHAR(max),@tip varchar(30))
RETURNS
  @TB_AKARYAKIT_SATIS TABLE (
    STOK_KOD           VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD            VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_TIP           VARCHAR(20)  COLLATE Turkish_CI_AS,
    SATISMIKTAR         FLOAT,
    SATISTUTAR          FLOAT,
    VERSATMIKTAR        FLOAT,
    VERSATTUTAR         FLOAT,
    KDV                 FLOAT,
    KDVTUTAR            FLOAT,
    BIRIMFIYAT          FLOAT)
AS
BEGIN
  


  INSERT @TB_AKARYAKIT_SATIS (STOK_KOD,STOK_AD,STOK_TIP,
  SATISMIKTAR,SATISTUTAR,
  KDV,KDVTUTAR,BIRIMFIYAT,VERSATMIKTAR,VERSATTUTAR)
  select st.kod,st.ad,st.tip,
  sum(ps.satmik),
  sum(PS.satmik*ps.brimfiy),avg(ps.kdvyuz*100),
  sum(  (PS.satmik*ps.brimfiy)-  ((PS.satmik*ps.brimfiy)/(1+ps.kdvyuz))  ),
  case when sum(ps.satmik)>0 then
  sum(PS.satmik*ps.brimfiy)/sum(ps.satmik) else 0 end,
  0,0
  FROM  pomvardistok as ps with (nolock)
  inner join stokkart as st with (nolock) on st.kod=ps.kod and ps.stktip=st.tip
  where ps.varno in (select * from CsvToInt_Max(@VARNIN)) and ps.sil=0
  group by st.kod,st.ad,st.tip order by st.ad
  
  
  update @TB_AKARYAKIT_SATIS set VERSATMIKTAR=isnull(dt.VERSATMIKTAR,0),
  VERSATTUTAR=isnull(dt.VERSATTUTAR,0) from @TB_AKARYAKIT_SATIS as t
  join (select vh.stkod,vh.stktip,sum(vh.mik) as VERSATMIKTAR,
  sum(vh.mik*(vh.brmfiy-(vh.fiyfarktop+vh.vadfarktop))) VERSATTUTAR
  from veresihrk  as vh with (nolock)
  inner join veresimas as vm with (nolock) on vh.verid=vm.verid and vm.sil=0
  and vh.sil=0
  where vm.varno in (select * from CsvToInt_Max(@VARNIN)) and vm.yertip=@tip
  group by vh.stkod,vh.stktip)
  dt on t.STOK_TIP=dt.stktip and t.STOK_KOD=dt.stkod


  RETURN

end

================================================================================
