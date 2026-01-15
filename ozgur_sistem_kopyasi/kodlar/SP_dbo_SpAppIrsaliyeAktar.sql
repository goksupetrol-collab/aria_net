-- Stored Procedure: dbo.SpAppIrsaliyeAktar
-- Tarih: 2026-01-14 20:06:08.368264
================================================================================

CREATE PROCEDURE dbo.[SpAppIrsaliyeAktar]
@BackIrsaliyeId  int,
@DeviceId  varchar(50),
@UserId  int
AS
BEGIN

   declare @Tutar float
   declare @KdvDahilTutar float

   
   
   
   select @Tutar=Round(Sum(brmfiy*Mik),2),
   @KdvDahilTutar=Round(Sum( (brmfiy*Mik)*(1+kdvyuz)),2)
   from  irsaliyehrk with (nolock)
   Where irid=@BackIrsaliyeId and Sil=0 
   

   update irsaliyemas set irid=id,
   irtop=isnull(@Tutar,0),
   genel_top=isnull(@KdvDahilTutar,0),
   genel_ara_top=isnull(@Tutar,0),
   genel_kdv_top=isnull(@KdvDahilTutar,0)-isnull(@Tutar,0),
   genel_net_top=isnull(@Tutar,0),
   kayok=1 where id=@BackIrsaliyeId
  
   Declare @UserUnvan   varchar(150)
   select @UserUnvan=ad from  users where id=@UserId
    
   select id,firmano,irseri+irno irsserino,tarih,saat,@UserUnvan as userunvan 
   from irsaliyemas with (nolock) where id=@BackIrsaliyeId 
   


END

================================================================================
