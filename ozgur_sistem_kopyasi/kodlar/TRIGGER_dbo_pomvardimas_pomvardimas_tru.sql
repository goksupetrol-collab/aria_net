-- Trigger: dbo.pomvardimas_tru
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.998866
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_tru] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN


SET NOCOUNT ON
SET XACT_ABORT ON /*rollback */

declare @varno float,@varok int,@sil int
declare @firmano int
declare @d_varok int
declare @ver_ak_sayi  int
declare @pos_ak_sayi  int
declare @mesaj     varchar(500)
declare @admin	   bit


declare @yertip varchar(20)
set @yertip='pomvardimas'

select @firmano=ins.firmano,@varno=ins.varno,@varok=ins.varok,@sil=ins.sil,
@d_varok=isnull(del.varok,0),@admin=isnull(ins.admin,0)
from inserted as ins left join deleted as del on del.id=ins.id


/*-sadece varokleme yada geri alma */
if UPDATE(varok)
begin
 if @varok=0
  begin
  /*geri alma durumda kontroller */
   /*
    --verisiye fis aktarÄ±m kontrol
    SELECT @ver_ak_sayi=COUNT(*) FROM veresimas WHERE aktip<>'BK' and sil=0 and varno=@varno
    --pos aktarÄ±m kontrol
    SELECT @pos_ak_sayi=COUNT(*) FROM poshrk WHERE aktip<>'BK' and sil=0 and varno=@varno
    
    set @mesaj=''
    if (@ver_ak_sayi>0)
    select @mesaj=cast(@ver_ak_sayi as varchar)+' Tane AktarÄ±lmÄ±ÅŸ FiÅŸiniz Var..!'+char(13)+char(10)
    
    if (@pos_ak_sayi>0)
    set @mesaj=@mesaj+cast(@pos_ak_sayi as varchar)+' Tane AktarÄ±lmÄ±ÅŸ Pos Slibiniz Var..!'+char(13)+char(10)

    if @mesaj<>''
     begin
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      RETURN
    end
   */
 
 
   exec pomvardistokduzelt @varno
 
 end
 
 
 if @varok=1
  exec Vardiya_Hrk_Tar_Ata @firmano,@varno,@yertip
 

  update pomvardisayac set varok=@varok  where varno=@varno and sil=0
  update pomvardiperada set varok=@varok     where varno=@varno and sil=0
  update pomvardiper set varok=@varok   where varno=@varno and sil=0
  update pomvardistok set varok=@varok    where varno=@varno and sil=0
  update pomvarditank set varok=@varok    where varno=@varno and sil=0
  update pomvardikap set varok=@varok    where varno=@varno and sil=0


  update veresimas set varok=@varok   where varno=@varno and yertip=@yertip and sil=0
  update carihrk set varok=@varok    where varno=@varno and yertip=@yertip and sil=0
  update emtiasat set varok=@varok   where varno=@varno and yertip=@yertip and sil=0
  update kasahrk set varok=@varok   where varno=@varno and yertip=@yertip and sil=0
  update bankahrk set varok=@varok    where varno=@varno and yertip=@yertip and sil=0
  update poshrk set varok=@varok    where varno=@varno and yertip=@yertip and sil=0
  update cekkart set varok=@varok    where varno=@varno and yertip=@yertip and sil=0
  
  
  exec SpPomvardiVeresiTTSKont @firmano,@varno
  
  end

 


/*--sadece silme */
 
    if UPDATE(sil) and (@sil=1)
     begin
       
      if @admin=0
         begin
         /*sonra Vardiya Varmi */
          if EXISTS (SELECT id FROM pomvardimas with (nolock) WHERE sil=0 and firmano=@firmano and varno>@varno )
          begin
          select @mesaj='Seçmiş Olduğunuz Vardiyadan Sonra Vardiya Var..!'+char(13)+char(10)+
          ' (Sayaç Endeksleri Etkilemektedir.)';
          if @mesaj<>''
           begin
            RAISERROR (@mesaj, 16,1)
            ROLLBACK TRANSACTION
            RETURN
          end
         end
        end

      /* havuza girilmis fis varsa havuza al */
      if @Sil=1
       begin
       declare @idler varchar(max)
       select @idler=COALESCE(@idler+',','','')+cast(cast(verid as bigint) as varchar)
       from veresimas with (nolock) where varno=@varno and havuzfis=1 and sil=0

        exec havuzfisaktar_max 0,0,@idler,@varno
          /* havuzdan girilmis fis varsa havuza al */
      
   
     update pomvardisayac set sil=@sil where varno=@varno and sil=0
       update pomvardiperada set sil=@sil  where varno=@varno and sil=0
      update pomvardiper set sil=@sil  where varno=@varno and sil=0
      update pomvardistok set sil=@sil  where varno=@varno and sil=0
      update pomvarditank set sil=@sil  where varno=@varno and sil=0
      update pomvardikap set sil=@sil  where varno=@varno and sil=0
   

      update veresimas set sil=@sil where varno=@varno and yertip=@yertip and sil=0
      update carihrk set sil=@sil  where varno=@varno and yertip=@yertip and sil=0
      update emtiasat set sil=@sil  where varno=@varno and yertip=@yertip and sil=0
      update kasahrk set sil=@sil  where varno=@varno and yertip=@yertip and sil=0
      update bankahrk set sil=@sil  where varno=@varno and yertip=@yertip and sil=0
      update poshrk set sil=@sil where varno=@varno and yertip=@yertip and sil=0
      update cekkart set sil=@sil  where varno=@varno and yertip=@yertip and sil=0
     
        update zrapormas set Sil=1 where Sil=0 and 
         zrapid in (select Zrapid from ZraporVardiya
        where  varno=@varno and varTip=1 and Sil=0 )
     
     
    end
  end

 

  if UPDATE (sil) or UPDATE(varok)
    EXECUTE pomvarkabul @firmano,@varno,@varok,@sil

 END

================================================================================
