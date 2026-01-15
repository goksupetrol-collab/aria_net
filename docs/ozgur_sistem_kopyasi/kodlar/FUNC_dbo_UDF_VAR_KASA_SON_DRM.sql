-- Function: dbo.UDF_VAR_KASA_SON_DRM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.781784
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_KASA_SON_DRM] 
(@VARNIN VARCHAR(1000))
RETURNS
    @TB_KASA_SONDRM TABLE (
    KASA_KOD     	VARCHAR(40)  COLLATE Turkish_CI_AS,
    KASA_AD			VARCHAR(70)  COLLATE Turkish_CI_AS,
    PARABRM			VARCHAR(20)  COLLATE Turkish_CI_AS,
    BAKIYE     		FLOAT,
    KUR				FLOAT,
    KUR_BAKIYE		FLOAT)
    
AS
BEGIN    

     DECLARE @PARABRM    VARCHAR(30)
     DECLARE @DATE		 DATETIME

     SELECT @PARABRM=k.sistem_parabrm from sistemtanim as k
     
     
     
     SELECT @DATE='2100-01-01'
     


       insert into @TB_KASA_SONDRM
       (KASA_KOD,KASA_AD,PARABRM,BAKIYE,KUR,KUR_BAKIYE)
       select K.kod,K.ad,K.parabrm,
       k.top_bakiye,DBO.UDF_CAPRAZ_KUR 
       (@DATE,K.parabrm,@PARABRM),0
       from Kasa_Kart_Listesi as k
       where k.firmano in (select firmano from pomvardimas 
       where varno in (select * from CsvToInt(@VARNIN) ))
       
       
      UPDATE @TB_KASA_SONDRM SET KUR_BAKIYE=BAKIYE*KUR
        
       

      RETURN


END

================================================================================
