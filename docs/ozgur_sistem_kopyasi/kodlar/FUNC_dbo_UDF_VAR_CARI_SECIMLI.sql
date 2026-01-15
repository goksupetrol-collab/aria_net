-- Function: dbo.UDF_VAR_CARI_SECIMLI
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.777516
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_CARI_SECIMLI] 
(@VARNIN VARCHAR(1000),
 @GRPIN VARCHAR(4000))
RETURNS
    @TB_CARI_SECIMLI TABLE (
    GRP_ID     		INT, 
    GRP_AD			VARCHAR(70)  COLLATE Turkish_CI_AS,
    BAKIYE     		FLOAT)
    
AS
BEGIN    

       insert into @TB_CARI_SECIMLI
       (GRP_ID,GRP_AD,BAKIYE)
       select grp.id,grp.ad,sum(k.top_bakiye)
       from Cari_Kart_Listesi as k 
       left join grup as grp on grp.id=k.grp1 and grp.sil=0
       where k.sil=0 and grp.id in (select * from CsvToInt(@GRPIN))
       GROUP by grp.id,grp.ad

      RETURN


END

================================================================================
