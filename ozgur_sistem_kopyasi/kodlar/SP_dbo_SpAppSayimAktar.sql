-- Stored Procedure: dbo.SpAppSayimAktar
-- Tarih: 2026-01-14 20:06:08.370051
================================================================================

CREATE PROCEDURE dbo.SpAppSayimAktar
@BackSayimId  int,
@DeviceId  varchar(50),
@AppSayimId  int,
@UserId  int
AS
BEGIN

   update sayimhrk set OnlineSayimMiktar=dt.miktar,
   OnlineSayimTarihSaat=dt.TarihSaat,saydrm='S',OnlineSayim=1 from sayimhrk t join 
   (select StokKod,sum(miktar) as miktar,max(TarihSaat) TarihSaat 
   from AppSayim where BackSayimId=@BackSayimId
    /*DeviceId=@DeviceId and AppSayimId=@AppSayimId  */
   group by StokKod ) as dt on t.stkod=dt.StokKod 
   and t.sayid=@BackSayimId
   
   exec SpSayimSatisMiktarHesapla @BackSayimId
   
   
   Declare @UserUnvan   varchar(150)
   select @UserUnvan=ad from  users where id=@UserId
    
   select id,firmano,sayack,tarih,saat,@UserUnvan as userunvan 
   from sayimmas with (nolock) where sayid=@BackSayimId 

END

================================================================================
