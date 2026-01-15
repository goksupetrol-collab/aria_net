-- View: dbo._Cari_Cek_Bakiye
-- Tarih: 2026-01-14 20:06:08.453968
================================================================================

CREATE VIEW [dbo].[_Cari_Cek_Bakiye] AS
CREATE VIEW [dbo]._Cari_Cek_Bakiye
AS
  SELECT h.cartip,h.carkod,
  ISNULL(SUM((borc-alacak)),0) as cek_bakiye
  FROM carihrk as h
  inner join cekkart as k
  on h.masterid=k.cekid and k.drm
  /*not in ('TKT','ELT','ODE') */
  in ('POR','TAK','KSN')
  where h.sil=0
  and (
  (h.cartip=k.cartip and h.carkod=k.carkod)
  or (h.cartip=k.vercartip and h.carkod=k.vercarkod))
  and h.islmtip='CEK'
  group by h.cartip,h.carkod

================================================================================
