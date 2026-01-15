-- Function: dbo.UDF_SIP_SEVIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.768435
================================================================================

CREATE FUNCTION [dbo].UDF_SIP_SEVIYE(
@FIRMANO     INT,
@STK_TIP     VARCHAR(30),
@STK_KODIN	 VARCHAR(8000))
RETURNS
    @TB_DEP_SIP_SEVIYE TABLE (
    STOK_KOD  		VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_AD    		VARCHAR(100) COLLATE Turkish_CI_AS,
    DEPO_KOD    		VARCHAR(30) COLLATE Turkish_CI_AS,
    DEPO_AD    		VARCHAR(100) COLLATE Turkish_CI_AS,
    BRIM       		VARCHAR(30) COLLATE Turkish_CI_AS,
    MEVCUTMIKTAR    FLOAT,
    MINMIK     		FLOAT,
    FARK			FLOAT)
AS
BEGIN
    
    
   DECLARE @TB_TEMP_STOKLIST
    TABLE (
    DEP_KOD     varchar(50) COLLATE Turkish_CI_AS,
    STK_TIP     varchar(50) COLLATE Turkish_CI_AS,
    STK_KOD     varchar(50) COLLATE Turkish_CI_AS,
    STK_AD     varchar(100) COLLATE Turkish_CI_AS,
    STK_BRIM    varchar(50) COLLATE Turkish_CI_AS,
    MIKTAR		FLOAT,
    MINMIK		FLOAT)
    
    
    
     insert into @TB_TEMP_STOKLIST (DEP_KOD,STK_TIP,
     STK_KOD,STK_AD,STK_BRIM,
     MIKTAR,MINMIK)
      select h.depkod,sk.tip,sk.kod,sk.ad,SK.brim,
      ISNULL(SUM(h.giren-h.cikan),0),
      SK.minmik
       from stokkart as sk 
       inner join stkhrk as h on h.stktip=sk.tip 
       and h.stkod=sk.kod  and h.sil=0 
       WHERE sk.tip=@STK_TIP and sk.sil=0
       group by h.depkod,sk.tip,sk.kod,sk.ad,SK.brim,SK.minmik
       
   
   
     insert into @TB_DEP_SIP_SEVIYE 
      (DEPO_KOD,DEPO_AD,STOK_KOD,STOK_AD,
      BRIM,MEVCUTMIKTAR,MINMIK,FARK)
     select DEP_KOD,'',STK_KOD,STK_AD,STK_BRIM,
     MIKTAR,MINMIK,(MINMIK-MIKTAR) from 
     @TB_TEMP_STOKLIST where (MIKTAR-MINMIK)<=MINMIK
    
    
   /* if @STK_TIP='akykt' */
    UPDATE @TB_DEP_SIP_SEVIYE 
    SET DEPO_AD=DT.AD FROM @TB_DEP_SIP_SEVIYE as  t
    join (select k.kod,k.ad from Depo_Kart_Listesi as k ) dt
    on dt.kod=t.DEPO_KOD 



  RETURN



END

================================================================================
