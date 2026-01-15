-- View: dbo.V_StokSonKullanimList
-- Tarih: 2026-01-14 20:06:08.487744
================================================================================

CREATE VIEW [dbo].[V_StokSonKullanimList] AS
CREATE VIEW dbo.V_StokSonKullanimList 
AS
    
  SELECT  S.Id,S.FirmaNo,
  S.StokId,
  K.barkod,k.kod StokKod,k.ad StokAd,
  K.grp1,K.grp2,K.grp3,
  S.Tarih,S.Miktar,S.OlusturmaTarihSaat,S.OlusturmaKullaniciUnvan,
  S.DegistirmeTarihSaat,S.DegistirmeKullaniciUnvan,S.SilTarihSaat,S.SilKullaniciUnvan,S.Sil
FROM 
  StokSonKullanim as S 
  inner join stokkart as k on k.id=S.StokId

================================================================================
