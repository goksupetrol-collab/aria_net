-- Function: dbo.UDF_VAR_SAYAC
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.790946
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_SAYAC] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_SAYAC  TABLE (
    SAYACKOD            VARCHAR(30) COLLATE Turkish_CI_AS,
    SAYACAD     		VARCHAR(100) COLLATE Turkish_CI_AS,
    ADAD				VARCHAR(50) COLLATE Turkish_CI_AS,
    ILKENDKS            FLOAT,
    SONENDKS            FLOAT,
    SATISMIKTAR         FLOAT,
    SATISTUTAR          FLOAT,
    TESTMIKTAR			FLOAT,
    BRIMFIYAT			FLOAT,
    TRANSFERMIKTAR      FLOAT)
AS
BEGIN
 
   insert into @TB_SAYAC 
   SELECT p.SAYACKOD,p.SAYACAD,P.ADAD,
        min(P.ilkendk),max(P.sonendk),
        sum(P.satmik),sum(p.satmik*p.brimfiy),
        sum(P.testmik),
        case when sum(satmik)>0 
        then sum(P.satmik*p.brimfiy)/sum(p.satmik) else 0 end,
        sum(P.transfermik)
         FROM  pomvardisayac AS p 
         where p.varno in (select * from CsvToInt(@VARNIN))
         group by P.SAYACKOD,p.SAYACAD,P.ADAD
   

  RETURN

end

================================================================================
