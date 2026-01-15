-- Function: dbo.FATURAFIS_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.656831
================================================================================

CREATE FUNCTION dbo.FATURAFIS_HRK(@fatid float)
RETURNS TABLE AS
RETURN(
SELECT fishrk.stkod AS STOK_KOD,gstk.ad as STOK_AD,
fis.plaka as PLAKA,fis.tarih AS TARIH,fis.saat AS SAAT,
fis.ykno AS YKNO,seri+cast([no] as varchar) AS FISNO,
fis.surucu as SURUCU,
fishrk.brim as BIRIM,
fishrk.mik as MIKTAR,fishrk.brmfiy as BRIMFIYAT,
fishrk.mik*fishrk.brmfiy AS TUTAR,
fis.ack as ACIKLAMA from faturamas as fat
inner join veresimas as fis on fis.akid=fat.fatid
and fis.aktip='FT' and fat.fatid=@fatid
inner join veresihrk as fishrk on fishrk.verid=fis.verid and fishrk.sil=0
inner join gelgidlistok as gstk on gstk.kod=fishrk.stkod and gstk.tip=fishrk.stktip)

================================================================================
