-- View: dbo._Cari_Hrk_Bakiye_Ay
-- Tarih: 2026-01-14 20:06:08.456727
================================================================================

CREATE VIEW [dbo].[_Cari_Hrk_Bakiye_Ay] AS
CREATE VIEW [dbo]._Cari_Hrk_Bakiye_Ay
 AS
 select h.cartip,h.carkod,
 year(h.tarih) as Yil,
 month(h.tarih) as Ay,
 isnull(sum(borc),0) as borc,
 isnull(sum(alacak),0) as alacak,
 isnull(sum(borc-alacak),0) as bakiye
 from carihrk as h where h.sil=0
 group by h.cartip,h.carkod,
 year(h.tarih),month(h.tarih)

================================================================================
