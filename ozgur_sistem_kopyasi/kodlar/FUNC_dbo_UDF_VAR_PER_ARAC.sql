-- Function: dbo.UDF_VAR_PER_ARAC
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.786311
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_PER_ARAC]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000))
RETURNS
    @TB_VAR_PER_ARAC TABLE (
    MINTAR				DATETIME,
    MAXTAR				DATETIME,
    PER_KOD				VARCHAR(30),
    PER_UNVAN			VARCHAR(100),
    LITRE		      	FLOAT,
    TUTAR				FLOAT,
    ARAC_SAYI          	FLOAT,
    PER_SAYI			INT,
    ORT_LITRE			FLOAT,
    ORT_ARAC			FLOAT,
    ORT_TUTAR			FLOAT,
    TAG					INT)
AS
BEGIN
   

  declare @PERSAYI    FLOAT
  declare @LITRE   FLOAT
  declare @ARAC   FLOAT
  declare @TUTAR   FLOAT
  declare @TOP_ARAC  FLOAT
  DECLARE @TOP_LT    FLOAT
  DECLARE @TOP_TUT   FLOAT


  declare @OT_ARAC  FLOAT
  DECLARE @OT_LT    FLOAT
  DECLARE @OT_TUT   FLOAT



    
   INSERT @TB_VAR_PER_ARAC (MINTAR,MAXTAR,
   PER_KOD,LITRE,TUTAR,ARAC_SAYI,TAG,
   PER_SAYI,ORT_LITRE,ORT_ARAC,ORT_TUTAR)
   select min(tarih),
    max(tarih),ot.perkod,
    round( sum(ot.miktar),3),
   round( sum(ot.tutar),3),
   count(ot.miktar),max(ot.tag),
   0,0,0,0
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   group by ot.perkod
   
   select @LITRE=sum(LITRE),
   @ARAC=sum(ARAC_SAYI),
   @TUTAR=sum(TUTAR)
   FROM @TB_VAR_PER_ARAC 
   
   SELECT 
   @PERSAYI=COUNT(DISTINCT(PER_KOD))
   FROM @TB_VAR_PER_ARAC where Tag=0
   
   SELECT
   @TOP_ARAC=isnull(sum(ARAC_SAYI),0),
   @TOP_LT=isnull(sum(LITRE),0),
   @TOP_TUT=isnull(SUM(TUTAR),0)
    FROM @TB_VAR_PER_ARAC 
      
   
   SELECT
   @OT_ARAC=isnull(sum(ARAC_SAYI),0),
   @OT_LT=isnull(sum(LITRE),0),
   @OT_TUT=isnull(SUM(TUTAR),0)
    FROM @TB_VAR_PER_ARAC where tag>0
   
   
   
   UPDATE @TB_VAR_PER_ARAC set 
   LITRE=LITRE+CASE WHEN @PERSAYI>0 THEN 
   round(@OT_LT/@PERSAYI,1) ELSE 0 END,
   ARAC_SAYI=ARAC_SAYI+case when (@PERSAYI)>0 THEN 
   (round((@OT_ARAC)/@PERSAYI,1)) else 0 end,
   TUTAR=TUTAR+case when @PERSAYI>0 THEN 
   round(@OT_TUT/@PERSAYI,2) else 0 end
   WHERE TAG=0
   
   
  
   
  
  /*  
   update @TB_VAR_PER_ARAC set
   PER_SAYI=@PERSAYI,
   ORT_LITRE=CASE WHEN @PERSAYI>0 THEN 
   round(LT/@PERSAYI,1)+round((@OT_LT/@PERSAYI),1) ELSE 0 END,
   ORT_ARAC=case when (@PERSAYI)>0 THEN 
   (round((A_SAY)/@PERSAYI,1))+round((@OT_ARAC/@PERSAYI),1) else 0 end,
   ORT_TUTAR=case when @PERSAYI>0 THEN 
   round(TUT/@PERSAYI,2)+round((@OT_ARAC/@PERSAYI),1) else 0 end
   FROM @TB_VAR_PER_ARAC T JOIN
   (SELECT PER_KOD,
   sum(LITRE) LT,
   sum(ARAC_SAYI) A_SAY,
   sum(TUTAR) TUT   FROM @TB_VAR_PER_ARAC
   where Tag=0
   GROUP BY PER_KOD ) DT
   ON DT.PER_KOD=T.PER_KOD
   
  */
  
   
 
     
   
   UPDATE @TB_VAR_PER_ARAC set 
   PER_SAYI=@PERSAYI,
   ORT_LITRE=CASE WHEN @PERSAYI>0 THEN 
   round(@TOP_LT/@PERSAYI,1) ELSE 0 END,
   ORT_ARAC=case when (@PERSAYI)>0 THEN 
   (round((@TOP_ARAC)/@PERSAYI,1)) else 0 end,
   ORT_TUTAR=case when @PERSAYI>0 THEN 
   round(@TOP_TUT/@PERSAYI,2) else 0 end,
   
   
   PER_UNVAN=dt.unvan from 
   @TB_VAR_PER_ARAC as t join 
   (select kod,ad+' '+soyad as unvan from perkart) dt
   on dt.kod=t.PER_KOD
   
   
   return


END

================================================================================
