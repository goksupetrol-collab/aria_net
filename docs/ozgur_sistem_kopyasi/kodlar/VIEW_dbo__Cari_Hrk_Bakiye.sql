-- View: dbo._Cari_Hrk_Bakiye
-- Tarih: 2026-01-14 20:06:08.456368
================================================================================

CREATE VIEW [dbo].[_Cari_Hrk_Bakiye] AS
CREATE VIEW [dbo]._Cari_Hrk_Bakiye
 AS
 select h.cartip,h.carkod,
 max(h.tarih) as sonhrk_tarih,
 /*max(case when borc>0 then h.tarih else null end ) sonbrc_tarih, */
 /*max(case when alacak>0 then h.tarih else null end ) sonalc_tarih, */
 isnull(sum(borc),0) as borc,
 isnull(sum(alacak),0) as alacak,
 isnull(sum(borc-alacak),0) as bakiye
 from carihrk as h with (nolock) where isnull(h.CariAvans,0)=0 and  h.sil=0
 group by h.cartip,h.carkod

================================================================================
