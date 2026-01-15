-- Function: dbo.UDF_VAR_BANKONOT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.774660
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_BANKONOT] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_BANKONOT TABLE (
    KASA_KOD            VARCHAR(50) COLLATE Turkish_CI_AS,
    KASA_AD     		VARCHAR(150) COLLATE Turkish_CI_AS,
    PARABRIM			VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA			VARCHAR(150) COLLATE Turkish_CI_AS,
    ADET			    INT,
    TUTAR         	    FLOAT,
    TLTUTAR             FLOAT )
AS
BEGIN
 
  
   insert into @TB_BANKONOT
   
     SELECT kh.kaskod AS KASA_KOD,k.ad as KASA_AD,
       kh.parabrm as PARABRIM,
       bt.ack ACIKLAMA,sum(bh.adet) ADET,
       sum(bh.deger*bh.adet) as TUTAR,
       sum(bh.deger*bh.adet*kh.kur) as TLTUTAR
       FROM kasahrk AS kh INNER JOIN kasakart AS k ON 
       kh.kaskod=k.kod and kh.varno in  (select * from CsvToInt(@VARNIN))
       and kh.sil=0 
       and yertip=@TIP and islmhrk='TES' and kh.banknot=1 
       INNER JOIN banknot_hrk as bh  on bh.hrk_id=kh.kashrkid 
       INNER JOIN banknot_tip as bt  on bt.id=bh.tip 
       group by kh.kaskod,k.ad,Kh.parabrm,bh.tip,bt.ack 
 
    
   
  RETURN

end

================================================================================
