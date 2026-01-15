-- View: dbo.Stok_FirmaFiyatList
-- Tarih: 2026-01-14 20:06:08.480229
================================================================================

CREATE VIEW [dbo].[Stok_FirmaFiyatList] AS
CREATE VIEW [dbo].[Stok_FirmaFiyatList]
AS

 Select isnull(S1.Firmano,0) Firmano,
 F.ad as FirmaUnvan,
 K.id,K.Tip,K.Kod,K.Ad,K.Grp1,K.Grp2,K.Grp3,
 K.Sat1Kdv SatisKdv,K.AlsKdv AlisKdv,
 ISNULL(A.Fiyat,0) AlisFiyat,
 ISNULL(S1.Fiyat,0) as SatisFiyat1,
 ISNULL(S2.Fiyat,0) as SatisFiyat2,
 ISNULL(S3.Fiyat,0) as SatisFiyat3,
 ISNULL(S4.Fiyat,0) as SatisFiyat4
 /*ISNULL(M.Miktar,0) as MevcutMiktar */
 From Stokkart as K with(nolock)
 inner join Firma as F with(nolock) on isnull(F.sil,0)=0
 inner Join Stok_Fiyat as S1 with(nolock)
 on S1.Stk_id=K.id And S1.FiyNo=1 and S1.FiyTip=2 And F.id=S1.FirmaNo
 inner Join Stok_Fiyat as S2 with(nolock)
 on S2.Stk_id=K.id And S2.FiyNo=2 and S2.FiyTip=2 And F.id=S2.FirmaNo
 inner Join Stok_Fiyat as S3 with(nolock)
 on S3.Stk_id=K.id And S3.FiyNo=3 and S3.FiyTip=2 And F.id=S3.FirmaNo
 inner Join Stok_Fiyat as S4 with(nolock)
 on S4.Stk_id=K.id And S4.FiyNo=4 and S4.FiyTip=2 And F.id=S4.FirmaNo
 inner Join Stok_Fiyat as A with(nolock)
 on A.Stk_id=K.id And A.FiyNo=1 and A.FiyTip=1 And F.id=A.FirmaNo
 /*
 Left Join _Stok_FirmaMiktar as M with(nolock)
 on M.stktip=K.Tip and M.Stkod=K.Kod And M.Firmano=S1.FirmaNo
 */

================================================================================
