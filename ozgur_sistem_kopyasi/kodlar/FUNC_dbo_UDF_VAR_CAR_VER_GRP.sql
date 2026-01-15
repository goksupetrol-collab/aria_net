-- Function: dbo.UDF_VAR_CAR_VER_GRP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.777110
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_CAR_VER_GRP] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_CAR_VER_GRP TABLE (
    CARITIP             VARCHAR(30) COLLATE Turkish_CI_AS,
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    FIS_ADET			INT,
    BYTLTUTAR        	FLOAT,
    AYTLTUTAR           FLOAT,
    TOPMIKTAR           FLOAT,
    CARIBAKIYE          FLOAT)
AS
BEGIN
 
  
   insert into @TB_CAR_VER_GRP
   
   SELECT P.cartip,P.carkod AS CARIKOD,S.ad as CARIUNVAN,
   count(p.carkod) as FIS_ADET,
   BYTLTUTAR=SUM(case when fistip='FISVERSAT' THEN p.toptut-isnull(isktop,0) ELSE 0 END),
   AYTLTUTAR=SUM(case when fistip='FISALCSAT' THEN p.toptut-isnull(isktop,0) ELSE 0 END), 
   TOPMIKTAR=SUM(case when fistip='FISVERSAT' THEN isnull(Top_Mik,0) ELSE 0 END),
   0 CARIBAKIYE
    FROM  veresimas AS P with (nolock)
     INNER JOIN Genel_Kart AS S with (nolock) ON 
     (P.carkod=S.kod and s.cartp=p.cartip AND p.sil=0 
     and P.varno in  (select * from CsvToInt(@VARNIN))
     and yertip=@TIP) 
     group by p.cartip,P.carkod,S.ad 
     order by S.ad
   

    UPDATE @TB_CAR_VER_GRP set 
     CARIBAKIYE=dt.top_bakiye from @TB_CAR_VER_GRP as t join (
     select kod,top_bakiye from  Cari_Kart_Listesi) dt 
     on dt.kod=t.CARIKOD and t.CARITIP='carikart'
    
   
  RETURN

end

================================================================================
