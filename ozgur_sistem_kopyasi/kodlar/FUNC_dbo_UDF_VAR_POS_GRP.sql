-- Function: dbo.UDF_VAR_POS_GRP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.787965
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_POS_GRP] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_POS_GRP TABLE (
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    POSKOD              VARCHAR(50) COLLATE Turkish_CI_AS,
    POSAD				VARCHAR(150) COLLATE Turkish_CI_AS,
    BELGENO			    VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA			VARCHAR(150) COLLATE Turkish_CI_AS,
    YTLTUTAR        	FLOAT,
    KOMISYON            FLOAT,
    HESGECTUTAR			FLOAT,
    VADETARIHI          DATETIME,
    KUR        			FLOAT )
AS
BEGIN
 
  
   insert into @TB_POS_GRP
     SELECT ('-') AS CARIKOD,('-') AS CARIUNVAN,
      P.poskod AS POSKOD,T.AD AS POSAD,
      ('-') as BELGENO,('-') AS ACIKLAMA,
      sum(p.giren) AS YTLTUTAR,
      sum((P.giren*P.bankomyuz)+((P.giren*P.bankomyuz)*P.extrakomyuz)+(P.giren*P.ekkomyuz)) AS KOMISYON,
      sum(P.giren-((P.giren*P.bankomyuz)+((P.giren*P.bankomyuz)*P.extrakomyuz)+(P.giren*P.ekkomyuz))) as HESGECTUTAR,
      min(P.VADETAR) AS VADETARIHI,max(P.kur) AS KUR FROM 
      poshrk AS P inner join poskart T on p.poskod=T.kod where p.sil=0 
      and P.varno in  (select * from CsvToInt(@VARNIN))
      and yertip=@TIP
      group by P.poskod,T.AD
     
     

 
   
 
    
   
  RETURN

end

================================================================================
