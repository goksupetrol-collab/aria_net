-- View: dbo._Cari_Avans_Bakiye
-- Tarih: 2026-01-14 20:06:08.453639
================================================================================

CREATE VIEW [dbo].[_Cari_Avans_Bakiye] AS
CREATE VIEW [dbo]._Cari_Avans_Bakiye
 AS
 select h.cartip,h.carkod,
 isnull(sum(borc),0) as borc,
 isnull(sum(alacak),0) as alacak,
 isnull(sum(borc-alacak),0) as bakiye
 from carihrk as h with (nolock) where isnull(h.CariAvans,0)=1 and h.sil=0
 group by h.cartip,h.carkod

================================================================================
