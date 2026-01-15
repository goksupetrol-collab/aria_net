-- Function: dbo.PROMOSYON_HRK
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.668584
================================================================================

CREATE FUNCTION dbo.[PROMOSYON_HRK] 
(@promid float)
RETURNS TABLE AS
RETURN(select h.stkod AS STOK_KOD,gstk.ad as STOK_AD,
(h.mik) MIKTAR,h.brim AS STOK_BIRIM,
(h.brmfiy) BIRIM_FIYAT,
(h.brmfiy/(1+h.kdvyuz)) BIRIM_KDVSIZ,
round((h.brmfiy*h.mik),2) TUTAR,
round( ((h.brmfiy*h.mik)/(1+h.kdvyuz)),2) TUTAR_KDVSIZ,
(h.kdvyuz*100) KDV_ORAN,
abs(h.Kaz_Brm_Puan-h.Sat_Brm_Puan) BRIM_PUAN,
abs(h.Kaz_Top_Puan-h.Sat_Top_Puan) TOPLAM_PUAN


from Prom_Sat_Hrk AS h inner join 
gelgidlistok as gstk on gstk.kod=h.stkod
and h.stktip=gstk.tip where h.promid=@promid and h.sil=0 )

================================================================================
