-- Function: dbo.UDF_VAR_LITRE_ARAC_GUNLUK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.782186
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_LITRE_ARAC_GUNLUK
(@FIRMANO     INT,
 @VARIN        VARCHAR(8000))
 RETURNS
    @TB_VAR_LITRE_ARAC TABLE (
    GUN				INT,
    AY				INT,
    YIL				INT,
    TARIH		      	datetime,
    LITRE		      	FLOAT,
    TUTAR			FLOAT,
    ARAC_SAYI          		FLOAT,
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

  
   INSERT @TB_VAR_LITRE_ARAC (GUN,AY,YIL,TARIH,LITRE,
   TUTAR,ARAC_SAYI,GUN_SAYI,ORT_LITRE,ORT_ARAC,ORT_TUTAR)
   select day(p.tarih),
   month(p.tarih),YEAR(p.tarih),p.tarih,
   round( sum(ot.miktar),3),
   round( sum(ot.tutar),3),
   count(ot.miktar),
   0,0,0,0  
   FROM  otomasoku as ot 
   inner join pomvardimas as p on 
   p.varno=ot.varno
   where p.varno in (select * from CsvToInt(@VARIN))
   group by p.tarih
   
   
   select @GUNSAYI=datediff(day,min(TARIH),max(TARIH))+1,
   @LITRE=sum(LITRE),
   @ARAC=sum(ARAC_SAYI),
   @TUTAR=sum(TUTAR)
   FROM @TB_VAR_LITRE_ARAC 
   
   update @TB_VAR_LITRE_ARAC set
   GUN_SAYI=@GUNSAYI,
   ORT_LITRE=CASE WHEN @GUNSAYI>0 THEN 
   @LITRE/@GUNSAYI ELSE 0 END,
   ORT_ARAC=case when (@GUNSAYI)>0 THEN 
   @ARAC/@GUNSAYI else 0 end,
   ORT_TUTAR=case when @GUNSAYI>0 THEN 
   @TUTAR/@GUNSAYI else 0 end

    
     
   Return


END

================================================================================
