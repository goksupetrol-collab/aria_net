-- Function: dbo.UDF_VAR_CAR_TAHODE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.775822
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_CAR_TAHODE] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_CAR_TAHODE TABLE (
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    BELGENO				VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA			VARCHAR(150) COLLATE Turkish_CI_AS,
    GYTLTUTAR        	FLOAT,
    CYTLTUTAR           FLOAT,
    KUR        			FLOAT,
    ISLEMTIP         	VARCHAR(50) COLLATE Turkish_CI_AS )
AS
BEGIN
 
  
   insert into @TB_CAR_TAHODE
   SELECT  P.carkod,vk.ad,p.belno,P.ack,
    p.alacak,p.borc,P.kur AS KUR,P.islmhrkad 
    FROM  carihrk AS P WITH(NOLOCK) 
     INNER JOIN Genel_Kart AS vk with (nolock)
     ON (P.carkod=vk.kod and vk.cartp=p.cartip 
     and P.varno in  (select * from CsvToInt(@VARNIN)) 
     and p.sil=0 and yertip=@TIP  ) 
     ORDER BY P.carkod 
   
    
   
  RETURN

end

================================================================================
