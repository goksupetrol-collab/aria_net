-- Trigger: dbo.veresimas_triu
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.045351
================================================================================

CREATE TRIGGER [dbo].[veresimas_triu] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno 		float

declare @del_varno 	float
declare @del_varok 	int
declare @del_yertip varchar(20)

Declare @idx 		float
declare @verid 		float
declare @varok 		int
declare @sil 		int
declare	@ototag 	int
declare @kayok 		int
declare @cartip    	varchar(30)
declare @carkod 	varchar(20)
declare @fistip 	varchar(3)
declare @delcarkod 	varchar(20)
declare @aktip     	varchar(5)
declare @yertip    	varchar(20)
declare @toptutar  	float
declare @vtsid     	float
declare @marsatid  	float
declare @otomas_id 	int
declare @islmtar   	datetime
declare @mesaj     	varchar(300)
declare @fisserino  varchar(30)
declare @fis_alc_bagverid     int
declare @firmano      int
declare @verIdcount   int


if update(varok)
 return

if update(fatid)
 return


DECLARE veresimasinup CURSOR LOCAL FOR SELECT ins.id,ins.firmano,
 ins.varno,del.varno,ins.verid,
 ins.fistip,ins.cartip,ins.carkod,ins.varok,del.varok,ins.sil,ins.ototag,
 ins.kayok,ins.aktip,ins.yertip,del.yertip,ins.toptut,
 ins.marsatid,ins.tarih,ins.vtsid,ins.otomas_id,
 ins.seri+cast(ins.[no] as varchar),ins.fis_alc_bagverid 
 FROM inserted as ins left join deleted as del on ins.id=del.id
 OPEN veresimasinup
 FETCH NEXT FROM veresimasinup INTO  @idx,@firmano,
 @varno,@del_varno,@verid,@fistip,@cartip,@carkod,
 @varok,@del_varok,@sil,@ototag,@kayok,@aktip,
 @yertip,@del_yertip,@toptutar,@marsatid,@islmtar,@vtsid,@otomas_id,@fisserino,
 @fis_alc_bagverid
 WHILE @@FETCH_STATUS = 0
 BEGIN
 
  update veresimas set verid=id where id=@idx and verid=0


  select @verIdcount=count(*) from veresimas with (nolock)
  where isnull(verid,0)=0 and firmano=@firmano 


 if @verIdcount>1
 begin
   RAISERROR ('verId Hatası', 16,1) 
   ROLLBACK TRANSACTION
   RETURN
 end

/*-fiş kaydedilmisse */
if (update(kayok) or update(sil)) and (@kayok=1 or @sil=1)
 begin
     
 
 if @aktip<>'BK'
  begin
  
    set @mesaj=''
     select @mesaj=@fisserino+' Nolu Fiş Aktarılmış Durumda...!'+char(13)+char(10)

    if @mesaj<>''
     begin
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      RETURN
    end

  end
   else
     begin
 
 
      update veresihrk set kayok=@kayok,sil=@sil where verid=@verid and sil=0

      if (@yertip='vts_islem') and (@varok=0) and (@vtsid>0)
         exec Vts_Fis_Giris @vtsid,@sil

      if @sil=1
       update otomasoku set aktarid=0 where otomasid=@otomas_id 

      /*insert */
      if (@yertip='pomvardimas') and (@varok=0)
      begin
           update pomvardimas set otomastop=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(toptut-(fiyfarktop+vadfarktop)) else
                                              toptut-(fiyfarktop+vadfarktop) end ),0)
                                              from veresimas with (nolock) 
                                              where yertip=@yertip and varno=@varno and ototag>=1 and sil=0 )
                                              where varno=@varno
                                              
            update pomvardimas set otomasmik=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(top_mik) else top_mik end ),0)
                                              from veresimas with (nolock) where yertip=@yertip 
                                              and varno=@varno and ototag>=1 and sil=0 )
                                              where varno=@varno                                              
                                              
                                              

            update pomvardimas set veresitop=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(toptut-(fiyfarktop+vadfarktop)   ) else
                                              toptut-(fiyfarktop+vadfarktop) end),0)
                                              from veresimas with (nolock) 
                                              where yertip=@yertip and varno=@varno and ototag=0 and sil=0)
                                              where varno=@varno
                                              
             update pomvardimas set veresimik=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(top_mik) else top_mik end),0)
                                              from veresimas with (nolock) 
                                              where yertip=@yertip and varno=@varno and ototag=0 and sil=0)
                                              where varno=@varno                                              
                                              
                                              
      end


      /*delete */
      if (@del_yertip='pomvardimas') and (@del_varok=0)
      begin
          update pomvardimas set otomastop=(select isnull(sum(case when fistip='FISALCSAT' then
                                            -1*(toptut-(fiyfarktop+vadfarktop)) else
                                             toptut-(fiyfarktop+vadfarktop) end ),0)
                                            from veresimas  with (nolock)  
                                            where yertip=@del_yertip and varno=@del_varno and ototag>=1 and sil=0 )
                                            where varno=@del_varno
                                            
                                            
           update pomvardimas set otomasmik=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(top_mik) else top_mik end ),0)
                                              from veresimas  with (nolock)  
                                              where yertip=@del_yertip 
                                              and varno=@del_varno and ototag>=1 and sil=0 )
                                              where varno=@del_varno                                              
           

          update pomvardimas set veresitop=(select isnull(sum(case when fistip='FISALCSAT' then
                                            -1*(toptut-(fiyfarktop+vadfarktop)) else
                                             toptut-(fiyfarktop+vadfarktop) end),0)
                                             from veresimas  with (nolock)  
                                             where yertip=@del_yertip and varno=@del_varno and ototag=0 and sil=0) 
                                             where varno=@del_varno
                                             
         update pomvardimas set veresimik=(select isnull(sum(case when fistip='FISALCSAT' then
                                              -1*(top_mik) else top_mik end),0)
                                              from veresimas  with (nolock) 
                                              where yertip=@del_yertip and varno=@del_varno and ototag=0 and sil=0)
                                              where varno=@del_varno                                        
                                             
                                             
      end



      if (@yertip='marvardimas') and (@varok=0)
      begin
      
           update marvardimas set veresitop=
            (select isnull(sum(
            case when fistip='FISVERSAT' then
            (toptut-(fiyfarktop+vadfarktop))*kur
            else
            (toptut-(fiyfarktop+vadfarktop))*-kur end),0)
             from veresimas with (nolock) 
             where varno=@varno and sil=0 and yertip=@yertip) where varno=@varno

            
        end
          
      /*--cari kartlarıdaki otomatik aktarım */
      if (update(varok)) and (@kayok=1) and (@varok=1) and (@aktip='BK')
          exec carifisaktaroto @islmtar,@verid

      /*alacak fişi ödeme sildirme */
       if (@sil=1)
          exec Fis_Odeme_Sil @verid           
         
       /*borc kaydedilecek carhrk */
        exec Fis_Cari_Borc @verid,@sil
       
      
       /*alacak kaydedilecek carhrk  */
        exec Fis_Cari_Alacak @verid,@sil
      
      /*TTS bankahrk  */
      if (@sil=1)
        update bankahrk set sil=1 where fisid=@verid
      
       
        if (update(kayok) or update(sil)) and (@kayok=1 or @sil=1)  
          exec stokhrkisle 0,'veresihrk','',@kayok,@sil,@verid
        
 
      end
        
  end        

 FETCH NEXT FROM veresimasinup INTO  @idx,@firmano,@varno,@del_varno,@verid,@fistip,@cartip,@carkod,
 @varok,@del_varok,@sil,@ototag,@kayok,@aktip,
 @yertip,@del_yertip,@toptutar,@marsatid,@islmtar,@vtsid,@otomas_id,@fisserino,
 @fis_alc_bagverid
END
CLOSE veresimasinup
DEALLOCATE veresimasinup



END

================================================================================
