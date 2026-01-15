-- Function: dbo.UDF_OTOMASPDA_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.757578
================================================================================

CREATE FUNCTION dbo.UDF_OTOMASPDA_HRK
(@otomasid int)
RETURNS TABLE AS
RETURN(select hrk.id as id,
hrk.otomasid,
hrk.Sayac_Kod as SAYAC_KOD,hrk.Stok_Kod AS STOK_KOD,
s_tnk.tank_kod as TANK_KOD,Per_Kod AS PERSONEL_KOD,
Litre AS LITRE,Birim_Fiyat as BIRIM_FIYAT,
Tutar AS TUTAR,tarih,saat,Kayit_Tar_Saat
from otomaspumphrk AS hrk
inner join sayac_tanklistesi as s_tnk on s_tnk.sayac_kod=hrk.Sayac_Kod
where hrk.otomasid>@otomasid)

================================================================================
