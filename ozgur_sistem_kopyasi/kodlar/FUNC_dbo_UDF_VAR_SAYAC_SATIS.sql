-- Function: dbo.UDF_VAR_SAYAC_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.791424
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_SAYAC_SATIS (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_SAYAC_SATIS TABLE (
    SAYAC_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    SAYAC_AD     VARCHAR(100) COLLATE Turkish_CI_AS,
    ILKENDEKS         FLOAT,
    SONENDEKS        FLOAT,
    SATISMIKTAR      FLOAT,
    TESTMIKTAR        FLOAT,
    TRANSFERMIKTAR    FLOAT ,
    BIRIMFIYAT        FLOAT,
    TUTAR             FLOAT )
AS
BEGIN
 
  INSERT @TB_SAYAC_SATIS (SAYAC_KOD,SAYAC_AD,ILKENDEKS,SONENDEKS,
  SATISMIKTAR,TESTMIKTAR,TRANSFERMIKTAR,BIRIMFIYAT,TUTAR)
  select ps.sayackod,sy.ad,MIN(ps.ilkendk),MAX(PS.sonendk),sum(ps.satmik),
  sum(testmik),sum(transfermik),
  case when sum(satmik)>0 then
  sum(PS.satmik*ps.brimfiy)/sum(ps.satmik) else 0 end,
  sum(ps.brimfiy*ps.satmik)
  FROM  pomvardisayac as ps with (nolock) 
  inner join sayackart as sy with (nolock)  on sy.kod=ps.sayackod
  where ps.varno in (select * from CsvToInt_Max(@VARNIN)) and ps.satmik>0 
  and ps.sil=0 group by ps.sayackod,sy.ad

  RETURN

end

================================================================================
