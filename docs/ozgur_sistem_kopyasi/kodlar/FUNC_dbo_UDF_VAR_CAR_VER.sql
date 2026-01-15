-- Function: dbo.UDF_VAR_CAR_VER
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.776639
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_CAR_VER] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_CAR_VER TABLE (
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    FISSERINO			VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA			VARCHAR(150) COLLATE Turkish_CI_AS,
    PLAKA				VARCHAR(50) COLLATE Turkish_CI_AS,
    BYTLTUTAR        	FLOAT,
    AYTLTUTAR           FLOAT,
    KUR        			FLOAT,
    FISAD         	    VARCHAR(50) COLLATE Turkish_CI_AS,
    OTOTAG              INT )
AS
BEGIN


 
  
    insert into @TB_CAR_VER (CARIKOD,CARIUNVAN,FISSERINO,ACIKLAMA,PLAKA,BYTLTUTAR,AYTLTUTAR,
    KUR,FISAD,OTOTAG)
    SELECT P.carkod AS CARIKOD,
    S.ad as CARIUNVAN,p.seri+cast(no as varchar) as FISSERINO,
    P.ack ACIKLAMA,p.PLAKA,
    BYTLTUTAR=case when fistip='FISVERSAT' 
    THEN p.toptut-(fiyfarktop+vadfarktop+isnull(isktop,0)) ELSE 0 END,
    AYTLTUTAR=case when fistip='FISALCSAT' THEN 
    p.toptut-(fiyfarktop+vadfarktop+isnull(isktop,0)) ELSE 0 END,
    P.kur AS KUR,P.fisad as FISAD,P.ototag
     FROM  veresimas AS P  with (nolock)
    INNER JOIN Genel_Kart AS S  with (nolock) ON (P.carkod=S.kod and s.cartp=p.cartip 
    AND p.sil=0 and P.varno in  (select * from CsvToInt(@VARNIN)) 
    and yertip=@TIP) 
    /*order by S.ad */
   

   
  RETURN

end

================================================================================
