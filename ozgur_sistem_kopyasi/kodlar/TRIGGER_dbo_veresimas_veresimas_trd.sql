-- Trigger: dbo.veresimas_trd
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.044218
================================================================================

CREATE TRIGGER [dbo].[veresimas_trd] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @varno float,@verid float
declare @varok int,@sil int,@ototag int,@kayok int
declare @cartip      varchar(30)
declare @carkod      varchar(20)
declare @fistip      varchar(3)
declare @aktip       varchar(5)
declare @toptutar    float
declare @marsatid    float
declare @yertip      varchar(30)
declare @fisserino   varchar(30)
declare @otomas_id   int
declare @mesaj       varchar(200)
declare @fis_alc_bagverid   int
SET NOCOUNT ON

DECLARE veresimassil CURSOR LOCAL FOR SELECT varno,verid,fistip,cartip,carkod,varok,
sil,ototag,kayok,aktip,yertip,toptut,marsatid,otomas_id,seri+cast([no] as varchar),
 fis_alc_bagverid FROM deleted
 OPEN veresimassil
 FETCH NEXT FROM veresimassil INTO  @varno,@verid,@fistip,@cartip,@carkod,@varok,
 @sil,@ototag,@kayok,@aktip,@yertip,@toptutar,@marsatid,@otomas_id,@fisserino,
 @fis_alc_bagverid
 WHILE @@FETCH_STATUS = 0
 BEGIN
 
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

     delete from veresihrk where verid=@verid

    if @kayok=1
     begin
      
      /*
      if @aktip<>'BK'
        delete from carihrk where islmtip='FIS' and masterid=@verid
      ELSE
      */



      if (@yertip='pomvardimas') and (@varok=0)
      begin
          update pomvardimas set otomastop=(select isnull(sum(case when fistip='FISALCSAT' then
                                            -1*(toptut-(fiyfarktop+vadfarktop)) else
                                            toptut-(fiyfarktop+vadfarktop) end ),0)
                                            from veresimas where varno=@varno and ototag>=1 and sil=0)
                                            where varno=@varno

          update pomvardimas set veresitop=(select isnull(sum(case when fistip='FISALCSAT' then
                                            -1*(toptut-(fiyfarktop+vadfarktop)) else
                                            toptut-(fiyfarktop+vadfarktop) end),0)
                                            from veresimas where varno=@varno and ototag=0 and sil=0)
                                            where varno=@varno
                                            
                                            
          update otomasoku set aktarid=0 where otomasid=@otomas_id                                   
      end

      if (@yertip='marvardimas') and (@varok=0)
      begin
          update marvardimas set veresitop=
            (select isnull(sum((toptut-(fiyfarktop+vadfarktop))*kur),0) from veresimas where varno=@varno and sil=0 and
             yertip=@yertip) where varno=@varno


          update marsatmas set cartip=dt.cartip,carkod=dt.carkod,
                 veresitop=case when fistip='FISVERSAT'
                    THEN dt.veresitop else -dt.veresitop end,
                    islmhrk=dt.fistip,islmhrkad=dt.fisad
                 from marsatmas t join
             (select marsatid,cartip,carkod,fistip,fisad,
             isnull(((toptut-(fiyfarktop+vadfarktop)) *kur),0) as veresitop
             from veresimas where varno=@varno and sil=0 and marsatid=@marsatid )
             dt on dt.marsatid=t.marsatid and t.sil=0
       end
       
       /*fis odeme sil */
       exec Fis_Odeme_Sil @verid  
       
      /*borc kaydedilecek carhrk */
      exec Fis_Cari_Borc @verid,1
    
    
   
      update veresimas set fis_alc_bagverid=0 
       where verid=@fis_alc_bagverid
       
      /*TTS  */
       update bankahrk set sil=1 where fisid=@verid
     
      
       
       
      /*alacak kaydedilecek carhrk */
      exec Fis_Cari_Alacak @verid,1  
     
       exec stokhrkisle 0,'veresihrk','',1,1,@verid
      
      
   end


end

FETCH NEXT FROM veresimassil INTO  @varno,@verid,@fistip,@cartip,@carkod,@varok,
@sil,@ototag,@kayok,@aktip,@yertip,@toptutar,@marsatid,@otomas_id,@fisserino,
@fis_alc_bagverid
END
CLOSE veresimassil
DEALLOCATE veresimassil






SET NOCOUNT OFF


END

================================================================================
