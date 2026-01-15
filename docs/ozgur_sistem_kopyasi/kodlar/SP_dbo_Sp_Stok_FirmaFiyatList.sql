-- Stored Procedure: dbo.Sp_Stok_FirmaFiyatList
-- Tarih: 2026-01-14 20:06:08.367714
================================================================================

CREATE PROCEDURE dbo.Sp_Stok_FirmaFiyatList
@Firmano int
AS
BEGIN
 

  /*
    declare @SqlStr nvarchar(4000) 

    CREATE TABLE  #Stok_FirmaFiyatList  (
    id            INT ,
    Tip,
    Kod,
    Ad, 
    Grp1,
    Grp2,
    Grp3,
    Firmano
    FirmaUnvan
    Sat1Kdv
    AlisKdv
    
    
    
   set @SqlStr=' Update #Satis_Yillik Set Ay'
   +CAST(@Ay as varchar(2))+'Adet='+CAST(@Miktar as varchar(200))+
   ',Ay'+CAST(@Ay as varchar(2))+'Tutar='+CAST(@Tutar as varchar(200))+
   ',Ay'+CAST(@Ay as varchar(2))+'Kisi='+CAST(@Kisi as varchar(200))+
   ' where TipIdId='''+@TipId_Id+''' '
  
   EXECUTE(@SqlStr)

   */
   
   
  if @Firmano<=0
   Select 0 Firmano,
   'StokKart' as FirmaUnvan,
   K.id,K.Tip,K.Kod,K.Ad,K.Grp1,K.Grp2,K.Grp3,
   K.Sat1Kdv SatisKdv,K.AlsKdv AlisKdv,
   ISNULL(K.AlsFiy,0) AlisFiyat,
   ISNULL(K.Sat1Fiy,0) as SatisFiyat1,
   ISNULL(K.Sat2Fiy,0) as SatisFiyat2,
   ISNULL(K.Sat3Fiy,0) as SatisFiyat3,
   ISNULL(K.Sat4Fiy,0) as SatisFiyat4,
   0.00 AlisFiyatYeni,
   0.00 SatisFiyat1Yeni,0.00 SatisFiyat2Yeni,
   0.00 SatisFiyat3Yeni,0.00 SatisFiyat4Yeni
   /*ISNULL(M.Miktar,0) as MevcutMiktar */
   From Stokkart as K with(nolock)
   Where K.Sil=0 
   
   

  if @Firmano>0
   Select isnull(S1.Firmano,0) Firmano,
   F.ad as FirmaUnvan,
   K.id,K.Tip,K.Kod,K.Ad,K.Grp1,K.Grp2,K.Grp3,
   K.Sat1Kdv SatisKdv,K.AlsKdv AlisKdv,
   ISNULL(A.Fiyat,0) AlisFiyat,
   ISNULL(S1.Fiyat,0) as SatisFiyat1,
   ISNULL(S2.Fiyat,0) as SatisFiyat2,
   ISNULL(S3.Fiyat,0) as SatisFiyat3,
   ISNULL(S4.Fiyat,0) as SatisFiyat4,
   0.00 AlisFiyatYeni,
   0.00 SatisFiyat1Yeni,0.00 SatisFiyat2Yeni,
   0.00 SatisFiyat3Yeni,0.00 SatisFiyat4Yeni
   /*ISNULL(M.Miktar,0) as MevcutMiktar */
   From Stokkart as K with(nolock)
   inner join Firma as F with(nolock) on 
   isnull(F.sil,0)=0 and K.Sil=0 and F.id=@Firmano 
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
   
   
   
   
   
 
 
  return 
 
END

================================================================================
