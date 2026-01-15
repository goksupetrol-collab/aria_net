-- View: dbo._Stok_FirmaMiktar
-- Tarih: 2026-01-14 20:06:08.460984
================================================================================

CREATE VIEW [dbo].[_Stok_FirmaMiktar] AS
CREATE VIEW [dbo]._Stok_FirmaMiktar
AS
 SELECT h.Firmano,h.stktip,h.stkod,Sum(h.giren-h.Cikan) as Miktar
 From StkHrk as h with (nolock) where Sil=0
 Group By h.Firmano,h.stktip,h.stkod

================================================================================
