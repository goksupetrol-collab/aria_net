-- View: dbo.Stok_FirmaFiyatDurum
-- Tarih: 2026-01-14 20:06:08.479901
================================================================================

CREATE VIEW [dbo].[Stok_FirmaFiyatDurum] AS
CREATE VIEW dbo.Stok_FirmaFiyatDurum
AS

 Select S.Firmano,K.id,K.Tip,K.Kod,K.Ad,
 ISNULL(A.AlisFiyatKdvli,0) AlisFiyat,
 ISNULL(S.Fiyat,0) as SatisFiyat,
 ISNULL(M.Miktar,0) as MevcutMiktar
 From Stokkart as K with(nolock)
 Left Join Stok_Fiyat as S with(nolock)
 on S.Stk_id=K.id And S.FiyNo=1 and S.FiyTip=2
 Left Join _Stok_FirmaAlisFiyat as A with(nolock)
 on A.stktip=K.Tip and A.Stkod=K.Kod And
 A.Firmano=S.FirmaNo
 Left Join _Stok_FirmaMiktar as M with(nolock)
 on M.stktip=K.Tip and M.Stkod=K.Kod And
 M.Firmano=S.FirmaNo

================================================================================
