-- Function: dbo.UDF_GUNLUK_POM_VAR_OZET
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.730911
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_POM_VAR_OZET]
(@FIRMANO     INT,
@VARIN		  VARCHAR(4000))
RETURNS
    @TB_VAR_LITRE_ARAC TABLE (
    TARIH		      	datetime,
    STOK_TIP			VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_KOD			VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_AD				VARCHAR(100) COLLATE Turkish_CI_AS,
    SATIS_LT			FLOAT,
    ARAC_SAYI			FLOAT,
    VERESIYE_LT			FLOAT,
    VERESIYE_TUT		FLOAT,
    SATIS_TUT     		FLOAT)
AS
BEGIN
   
   if @FIRMANO>0
   INSERT @TB_VAR_LITRE_ARAC (TARIH,STOK_TIP,STOK_KOD,STOK_AD,
   SATIS_LT,ARAC_SAYI,VERESIYE_LT,VERESIYE_TUT,SATIS_TUT)
   select MAX(ot.tarih),'akykt',ot.stkod,'',
   round( sum(ot.miktar),3),count(ot.miktar),
   sum(case when sattip='Veresiye' then ot.miktar else 0 end),
   sum(case when sattip='Veresiye' then ot.tutar else 0 end),
   sum(ot.tutar)   
   FROM  otomasoku as ot with (nolock) 
   where ot.firmano=@FIRMANO and ot.varno in (select * from CsvToInt(@VARIN))
   group by ot.stkod
   else
   INSERT @TB_VAR_LITRE_ARAC (TARIH,STOK_TIP,STOK_KOD,STOK_AD,
   SATIS_LT,ARAC_SAYI,VERESIYE_LT,VERESIYE_TUT,SATIS_TUT)
   select MAX(ot.tarih),'akykt',ot.stkod,'',
   round( sum(ot.miktar),3),count(ot.miktar),
   sum(case when sattip='Veresiye' then ot.miktar else 0 end),
   sum(case when sattip='Veresiye' then ot.tutar else 0 end),
   sum(ot.tutar)   
   FROM  otomasoku as ot with (nolock) 
   where ot.varno in (select * from CsvToInt(@VARIN))
   group by ot.stkod
   
     
   
   
   update @TB_VAR_LITRE_ARAC set STOK_AD=dt.ad
   from @TB_VAR_LITRE_ARAC as t join
   (select tip,kod,ad from stokkart with (nolock)  ) dt 
   on t.STOK_TIP=dt.tip and t.STOK_KOD=dt.kod
   
   
   
   return


END

================================================================================
