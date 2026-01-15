-- Stored Procedure: dbo.SpSayimSatisMiktarHesapla
-- Tarih: 2026-01-14 20:06:08.379695
================================================================================

CREATE PROCEDURE dbo.SpSayimSatisMiktarHesapla
@SayimId   int
AS
BEGIN
  
  declare @SayimAcTarihSaat Datetime
  declare @Firmano  int
  declare @DepoKod  varchar(50)
  
  
  declare @SatisMiktar  float
  
  set @SayimAcTarihSaat= null
    
  select @SayimAcTarihSaat=(tarih+cast(saat as datetime)),
  @Firmano=Firmano,@DepoKod=depkod
  from sayimmas Where id=@SayimId and Sil=0

  if @SayimAcTarihSaat  is not null
   begin

  declare @id int
  declare @StkKod varchar(50)
  declare @StkTip varchar(20)
  Declare @SayimTarihSaat  datetime
  declare pom_var CURSOR FAST_FORWARD  FOR 
  select id,stkod,Stktip,OnlineSayimTarihSaat from SayimHrk with (nolock) 
  where sayid=@SayimId 
  and sil=0 and isnull(OnlineSayim,0)=1 
   open pom_var
  fetch next from  pom_var into @id,@StkKod,@Stktip,@SayimTarihSaat
  while @@FETCH_STATUS=0
   begin
  
   set @SatisMiktar=0
   
   Select @SatisMiktar=sum(cikan-giren) From stkhrk with (nolock) 
   where stktip=@StkTip and stkod=@StkKod and depkod=@DepoKod and Sil=0
   and (tarih+cast(saat as datetime))>=@SayimAcTarihSaat  
   and (tarih+cast(saat as datetime))<@SayimTarihSaat

   update SayimHrk set sayimmik=OnlineSayimMiktar+isnull(@SatisMiktar,0),
   OnlineSatisMiktar=isnull(@SatisMiktar,0)
   Where id=@id

  FETCH next from  pom_var into @id,@StkKod,@Stktip,@SayimTarihSaat
  end
 close Pom_Var
 deallocate pom_var

end


END

================================================================================
