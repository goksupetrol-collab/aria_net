-- Function: dbo.UDF_CAPRAZ_KUR
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.690036
================================================================================

CREATE FUNCTION [dbo].UDF_CAPRAZ_KUR
(
@tarih   datetime,
@KUR1   varchar(20),
@KUR2    varchar(20))
 RETURNS float
AS
BEGIN

 declare @kur1_deger float
 declare @kur2_deger float
 declare @sonuc      float
 
 /*RETURN 1 */
 
 
select @kur1_deger=isnull(dov_satis,1) from
para_kur where kod=@KUR1 and
tarih=(select max(tarih) from para_kur where  tarih<=@tarih)
 
select @kur2_deger=isnull(dov_satis,1) from
para_kur where kod=@KUR2 and
tarih=(select max(tarih) from para_kur where  tarih<=@tarih)
 
 if (@kur1_deger is null) or (@kur2_deger=0)
   set @sonuc=1
  else
    set @sonuc=round(@kur1_deger/@kur2_deger,25)

 RETURN @sonuc
 
 
END

================================================================================
