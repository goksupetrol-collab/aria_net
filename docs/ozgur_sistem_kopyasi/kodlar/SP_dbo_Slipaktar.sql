-- Stored Procedure: dbo.Slipaktar
-- Tarih: 2026-01-14 20:06:08.365088
================================================================================

CREATE PROCEDURE [dbo].Slipaktar
@tutarytl       float,
@bankkomtut     float,
@komgidkod      varchar(30),
@ekkomtut       float,
@ekgidkod       varchar(30),
@tarih          datetime,
@Saat            varchar(10),
@userad         varchar(100),
@ack            varchar(150),
@GuidStr        varchar(50)
AS
BEGIN

  DECLARE @EKSTRE_TEMP TABLE (
  poshrkid      int)

   declare @hrk_id        int
   declare @hrk_phrkid    int
   declare @hrk_kaltut    float
   declare @poshrktut     float
   declare @brmfiy        float
   declare @gctip         varchar(1)
   declare @giren         float
   declare @cikan         float
   declare @newid         int
   declare @islmtip       varchar(20)
   declare @islmhrk       varchar(20)
   declare @islmtipad     varchar(30)
   declare @islmhrkad     varchar(30)
   declare @hrk_bankod    varchar(30)
   declare @bankod        varchar(50)
   declare @poskod        varchar(50)
   declare @yertip        varchar(30)
   declare @yertipad      varchar(50)
  /* declare @saatx         varchar(8) */
   declare @parabrm       varchar(8)
   declare @parakur       float
   declare @say           int
   declare @mesaj         varchar(300)
   
   declare @FirmanNo       int
   
   declare @ErrorNo int
   declare @ErrorMesaj varchar(200)
   declare @IdMesaj varchar(200)

  /*----pos parcala */
   set @ErrorNo=1
   set @IdMesaj=''
   
   if @tutarytl>0  /*tutar girilmisse */
   begin
   set @hrk_kaltut=Round(@tutarytl,2)

    DECLARE POSAKTAR_HRK CURSOR FAST_FORWARD FOR
    SELECT  p.id,p.bankod,p.poskod,p.poshrkid,
    Round(giren,2) FROM poshrk as p with (nolock)
    WHERE   p.sil=0 and p.poshrkid in (select poshrkid from ##pos_slip_aktar where GuidStr=@GuidStr)
    order by p.id
    OPEN POSAKTAR_HRK

    delete from @EKSTRE_TEMP

    FETCH NEXT FROM POSAKTAR_HRK INTO
    @hrk_id,@hrk_bankod,@poskod,@hrk_phrkid,@poshrktut
    WHILE @@FETCH_STATUS = 0
    BEGIN
     set @bankod=@hrk_bankod

    if @hrk_kaltut>0 
     begin
      Insert @EKSTRE_TEMP  Values (@hrk_phrkid)
      if @IdMesaj=''
       set @IdMesaj=cast(@hrk_phrkid as varchar)
      else
       set @IdMesaj=@IdMesaj+','+cast(@hrk_phrkid as varchar)
     end
     
     if round(@hrk_kaltut,2)<round(@poshrktut,2)
     begin
   
        if round(@hrk_kaltut,2)>0        
         exec slipparcala @hrk_phrkid,@hrk_kaltut,@userad
      break
     end

    set @hrk_kaltut=Round(@hrk_kaltut,2)-Round(@poshrktut,2)


    FETCH NEXT FROM POSAKTAR_HRK INTO
    @hrk_id,@hrk_bankod,@poskod,@hrk_phrkid,@poshrktut
    END

    CLOSE POSAKTAR_HRK
    DEALLOCATE POSAKTAR_HRK
  end  /*tutar girilmisse */
  
  
  /*----------------- */

  /* set @saatx=convert(varchar,getdate(),108); */
  
   BEGIN TRANSACTION
   BEGIN TRY  
   
   set @ErrorNo=2
   
   set @islmtip='BNK'
   set @islmhrk='SLO'
   set  @yertip='poskart'
   select @islmtipad=ad from islemturtip where tip=@islmtip
   select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
   select @yertipad=ad from yertipad where kod=@yertip

   select @bankod=bankod from poskart where kod=@poskod

   select @parabrm=b.parabrm,@FirmanNo=Firmano from bankakart as b where b.kod=@bankod

   
   select @newid=0
   insert into bankahrk (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
   cartip,masterid,varno,bankhrkid,perkod,adaid,vadetar,tarih,saat,cartur,carkod,bankod,
   belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat)
   values (@FirmanNo,'B',@islmtip,@islmtipad,@islmhrk,@islmhrkad,@yertip,@yertipad,
   '',@newid,0,@newid,'',0,@tarih,@tarih,@saat,'','',@bankod,'',@ack,
   @tutarytl,0,1,@parabrm,@userad,getdate())
   
   select @newid=SCOPE_IDENTITY() 
   update bankahrk set masterid=id,bankhrkid=id where id=@newid
   
   set @ErrorNo=3
    if @newid=0
     begin
        RAISERROR ('Aktarma bankahrk Yeni Id İşlemi Hatalı Tekrar Deneyiniz', 16,1) 
     end
  
   
   if @bankkomtut>0
   begin
   set @islmhrk='BKK'
   select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk

   insert into bankahrk (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,cartip,
   masterid,varno,bankhrkid,perkod,adaid,vadetar,tarih,saat,cartur,carkod,bankod,
   belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat)
   values (@FirmanNo,'A',@islmtip,@islmtipad,@islmhrk,@islmhrkad,@yertip,@yertipad,
   'gelgidkart',@newid,0,@newid,'',0,@tarih,@tarih,@saat,'',@komgidkod,@bankod,
   '',@ack,0,@bankkomtut,1,@parabrm,
   @userad,getdate())
   end

   if @ekkomtut>0
   begin
   set @islmhrk='EKK'
   select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk
   
   insert into bankahrk (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,cartip,
   masterid,varno,bankhrkid,perkod,adaid,vadetar,tarih,saat,cartur,carkod,bankod,
   belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat)
   values (@FirmanNo,'A',@islmtip,@islmtipad,@islmhrk,@islmhrkad,@yertip,@yertipad,
   'gelgidkart',@newid,0,@newid,'',0,@tarih,@tarih,@saat,'',@ekgidkod,@bankod,
   '',@ack,0,@ekkomtut,1,@parabrm,
   @userad,getdate())
   end

    set @ErrorNo=4
  
    /*-slipleri aktarılmıs olarak isaretle */
    update poshrk set aktip='AK',akid=@newid,aktar=@tarih,
    deguser=@userad,degtarsaat=getdate()
     where poshrkid in (select * from @EKSTRE_TEMP)
     and sil=0

    set @ErrorNo=5
    
    END TRY  
    BEGIN CATCH 
      set @ErrorMesaj= 'Aktarma İşlemi Hatalı '+CAST(@ErrorNo as varchar(50))+
      ' IdMesaj='+@IdMesaj+' Tekrar Deneyiniz'
      RAISERROR (@ErrorMesaj, 16,1) 
      ROLLBACK TRANSACTION
      RETURN
   END CATCH

   COMMIT TRANSACTION

END

================================================================================
