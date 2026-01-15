-- Function: dbo.UDF_KUR_GIRIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.736490
================================================================================

CREATE FUNCTION [dbo].UDF_KUR_GIRIS
(@tarih         datetime
)
RETURNS
   @TB_KUR_GRS TABLE (
    TARIH                DATETIME,
    KOD                  VARCHAR(10) COLLATE Turkish_CI_AS,
    AD                   VARCHAR(20) COLLATE Turkish_CI_AS,
    DOV_ALIS             FLOAT,
    DOV_SATIS            FLOAT,
    EFK_ALIS             FLOAT,
    EFK_SATIS            FLOAT)
AS
BEGIN

   insert into @TB_KUR_GRS (TARIH,KOD,AD,DOV_ALIS,DOV_SATIS,EFK_ALIS,EFK_SATIS)
   select @tarih,k.kod,k.ad,
   isnull(h.dov_alis,0),isnull(h.dov_alis,0),
   isnull(h.efk_alis,0),isnull(h.efk_satis,0) from parabrm as k
   left join para_kur as h on h.kod=k.kod and h.tarih=@tarih



 RETURN


END

================================================================================
