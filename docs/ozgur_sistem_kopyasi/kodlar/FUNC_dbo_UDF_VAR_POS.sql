-- Function: dbo.UDF_VAR_POS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.787602
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_POS] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_POS TABLE (
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
 
  
   insert into @TB_POS
    SELECT P.carkod AS CARIKOD,S.ad AS CARIUNVAN,
     P.poskod AS POSKOD,T.AD AS POSAD,
     p.belno as BELGENO,P.ack AS ACIKLAMA,
     p.giren AS YTLTUTAR,
     ((P.giren*P.bankomyuz)+((P.giren*P.bankomyuz)*P.extrakomyuz)+(P.giren*P.ekkomyuz)) AS KOMISYON,
     P.giren-((P.giren*P.bankomyuz)+((P.giren*P.bankomyuz)*P.extrakomyuz)+(P.giren*P.ekkomyuz)) as HESGECTUTAR,
     P.VADETAR AS VADETARIHI,P.kur AS KUR FROM 
     poshrk AS P inner join poskart T on p.poskod=T.kod 
     left JOIN Genel_Kart AS S 
     ON P.carkod=S.kod and s.cartp=p.cartip 
     where p.sil=0 
     and P.varno in  (select * from CsvToInt(@VARNIN)) 
     and yertip=@TIP order by p.poskod 

 
   
 
    
   
  RETURN

end

================================================================================
