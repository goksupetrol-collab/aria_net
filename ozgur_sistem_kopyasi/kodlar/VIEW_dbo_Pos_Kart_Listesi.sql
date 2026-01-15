-- View: dbo.Pos_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.476386
================================================================================

CREATE VIEW [dbo].[Pos_Kart_Listesi] AS
CREATE VIEW [dbo].Pos_Kart_Listesi
AS
  select p.id,p.firmano,p.kod,p.ad,bankod,(b.ad) bankad,
  p.muhonkod,p.muhkod,
  p.kom,p.exkom,p.vade,p.vadetip,p.sil,
  p.drm,p.parabrm,p.Mas_Gid_Kod,gd.ad as Mas_Gid_Ad,
  bak.bek_bak as bekbak,
  bak.kom_bak as kombak,(bak.bek_bak-bak.kom_bak) as nettutar,
  bak.vad_gelen  from poskart as p
  left join bankakart as b on p.bankod=b.kod
  left join gelgidkart as gd on p.Mas_Gid_Kod=gd.kod
  inner join Bakiye_Pos as bak on p.kod=bak.kod

================================================================================
