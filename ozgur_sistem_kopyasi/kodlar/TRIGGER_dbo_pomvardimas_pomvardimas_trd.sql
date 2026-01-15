-- Trigger: dbo.pomvardimas_trd
-- Tablo: dbo.pomvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.998132
================================================================================

CREATE TRIGGER [dbo].[pomvardimas_trd] ON [dbo].[pomvardimas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @varno     varchar(50);
declare @mesaj     varchar(500)
declare @yertip    varchar(30)
SET NOCOUNT ON


set @yertip='pomvardimas'

select @varno=varno from deleted;


    /*sonra Vardiya Varmi */
    if (SELECT COUNT(*) FROM pomvardimas WHERE sil=0 and varno>@varno)>0
    begin
    select @mesaj='Seçmiş Olduğunuz Vardiyadan Sonra Vardiya Var..!'+char(13)+char(10)+
    ' (Sayaç Endekleri Etkilemektedir.)';
    if @mesaj<>''
     begin
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      RETURN
    end
    end


/* havuza girlmiş fis varsa havuza al */

 declare @idler varchar(8000)
 select @idler=COALESCE(@idler+',','','')+cast(verid as varchar)
 from veresimas where varno=@varno and havuzfis=1 and sil=0

 exec havuzfisaktar 0,0,@idler,@varno
 /* havuza girilmiş fis varsa havuza al */


delete FROM pomvardisayac where varno=@varno 
delete FROM pomvardiperada where varno=@varno 
delete FROM pomvardiper where varno=@varno 
delete FROM pomvardistok where varno=@varno
delete FROM pomvarditank where varno=@varno 
delete FROM poshrk where varno=@varno and yertip=@yertip
delete FROM emtiasat where varno=@varno and yertip=@yertip
delete FROM kasahrk where varno=@varno and yertip=@yertip
delete FROM veresimas where varno=@varno and yertip=@yertip
delete FROM carihrk where varno=@varno and yertip=@yertip


delete FROM stkhrk where varno=@varno and yertip=@yertip
delete FROM sayachrk where varno=@varno and yertip=@yertip

SET NOCOUNT OFF

END

================================================================================
