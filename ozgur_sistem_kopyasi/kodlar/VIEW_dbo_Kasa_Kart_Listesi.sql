-- View: dbo.Kasa_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.473418
================================================================================

CREATE VIEW [dbo].[Kasa_Kart_Listesi] AS
CREATE VIEW Kasa_Kart_Listesi
AS
  SELECT k.id,k.firmano,k.kod,k.ad,k.sil,k.muhkod,k.tip,k.parabrm,
  isnull(round((bak.giren),2),0) giren_bakiye,
  isnull(round((bak.cikan),2),0) cikan_bakiye,
  isnull(round((bak.giren-bak.cikan),2),0) top_bakiye
  from KasaKart as k with (nolock)
  left join Bakiye_Kasa as bak on bak.kod=k.kod

================================================================================
