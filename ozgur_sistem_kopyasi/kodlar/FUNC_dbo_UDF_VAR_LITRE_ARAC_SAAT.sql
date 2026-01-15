-- Function: dbo.UDF_VAR_LITRE_ARAC_SAAT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.782589
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_LITRE_ARAC_SAAT]
(@FIRMANO     INT,
@VARIN        VARCHAR(8000))
RETURNS
    @TB_VAR_LITRE_ARAC TABLE (
    MINTAR				DATETIME,
    MAXTAR				DATETIME,
    SAAT				INT,
    LITRE		      	FLOAT,
    TUTAR				FLOAT,
    ARAC_SAYI          	FLOAT,
    GUN_SAYI			INT,
    ORT_LITRE			FLOAT,
    ORT_ARAC			FLOAT,
    ORT_TUTAR			FLOAT)
AS
BEGIN
   
 
  declare @GUNSAYI    FLOAT
  declare @LITRE   FLOAT
  declare @ARAC   FLOAT
  declare @TUTAR   FLOAT

  
   INSERT @TB_VAR_LITRE_ARAC (MINTAR,MAXTAR,SAAT,LITRE,
   TUTAR,ARAC_SAYI,GUN_SAYI,ORT_LITRE,ORT_ARAC,ORT_TUTAR)
   select 
   min(tarih),
   max(tarih),
   LEFT(ot.saat,2),
   round(sum(ot.miktar),3),
   round(sum(ot.tutar),3),
   count(ot.miktar),
   0,0,0,0  
   FROM  otomasoku as ot
   where varno in (select * from CsvToInt(@VARIN))
   group by LEFT(ot.saat,2)
   
   
   select @GUNSAYI=datediff(day,MIN(MINTAR),MAX(MAXTAR))+1,
   @LITRE=sum(LITRE),
   @ARAC=sum(ARAC_SAYI),
   @TUTAR=sum(TUTAR)
   FROM @TB_VAR_LITRE_ARAC 
   
   
   
   
   update @TB_VAR_LITRE_ARAC set 
   GUN_SAYI=@GUNSAYI,
   ORT_LITRE=CASE WHEN (@GUNSAYI*24)>0 THEN 
   @LITRE/(@GUNSAYI*24) ELSE 0 END,
   ORT_ARAC=case when (@GUNSAYI*24)>0 THEN 
   @ARAC/(@GUNSAYI*24) else 0 end,
   ORT_TUTAR=case when (@GUNSAYI*24)>0 THEN 
   @TUTAR/(@GUNSAYI*24) else 0 end

   
  
   
   
   
   return


END

================================================================================
