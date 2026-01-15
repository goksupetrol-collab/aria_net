-- Stored Procedure: dbo.Yedek_Al
-- Tarih: 2026-01-14 20:06:08.390067
================================================================================

CREATE PROCEDURE [dbo].Yedek_Al (@dataadi varchar(50))
AS
BEGIN


/*SET NOCOUNT ON */
/*SET XACT_ABORT ON --rollback */

DECLARE @DBNAME VARCHAR(50)

DECLARE @BACK_YER VARCHAR(3000)
declare @dosyaad  VARCHAR(3000)
declare @sil_dosyad VARCHAR(3000)
declare @sil_id int
declare @i int
declare @dicExist bit
declare @mesaj  VARCHAR(255)
declare @sqlstr  VARCHAR(5000)


/*BEGIN TRANSACTION */

select @BACK_YER=isnull(yedek_dizin,'') from sistemtanim

 if @BACK_YER=''
  begin
       set @mesaj=@dataadi+' İçin Yedek Alınacak Dizini Belirtiniz...!'
       RAISERROR (@mesaj,16,1)
       ROLLBACK TRANSACTION
       RETURN
  end
 set @i=len(@BACK_YER)
 while @i>0
  begin
   if SUBSTRING(@BACK_YER,@i,1)='\'
    begin
    declare @dizin  varchar(200)
    declare @klasor  varchar(50)
    
    set @dizin=RTRIM(SUBSTRING(@BACK_YER,1,@i))
    set @klasor=RTRIM(SUBSTRING(@BACK_YER,@i+1,200))
    
    exec @dicExist=sp_DizinKontrol @dizin,@klasor

    if @dicExist=0
     begin
       set @mesaj='Ana Bilgisayarda Yedek Alınacak Dizin Bulunamıyor...!'+
       CHAR(13)+CHAR(10)+
       'Yedek Dizin = '+@dizin+@klasor
       RAISERROR (@mesaj,16,1)
      /* ROLLBACK TRANSACTION */
       RETURN
     end
    
     break
    
    end
  set @i=@i-1
  end
  

 SELECT @dosyaad=convert(varchar,getdate(),120);

 SELECT @dosyaad=Replace(@dosyaad,':', '-')
 SELECT @dosyaad=Replace(@dosyaad,' ', '_')

 set @BACK_YER=@BACK_YER+'\'+@dataadi+'_'+@dosyaad+'.bak';

  insert into yedek (tarih,dosyaad,ok) values
  (getdate(),@BACK_YER,1)

 set @sqlstr='BACKUP DATABASE ['+@dataadi+'] TO
 DISK = '''+@BACK_YER+''' WITH NOFORMAT, NOINIT,
 NAME =''Full Database Backup'', SKIP, NOREWIND,NOUNLOAD,STATS = 1'
 
  BEGIN TRY
     execute(@sqlstr)
  END TRY
   BEGIN CATCH
    delete from yedek where dosyaad=@BACK_YER 
    /*ROLLBACK TRANSACTION */
    RETURN
   END CATCH
    
    /*IF @@TRANCOUNT > 0 */
    /* COMMIT TRANSACTION */
  
 

 /*set @BACK_YER='C:\Petronet\Yedek' */

 /*declare @str varchar(300) */

 /*set @str = 'md '+@BACK_YER+'' */

  /*EXEC master..xp_cmdshell @str */

 if (select count(*) from yedek)>6
 begin
  select top 1 @sil_dosyad=min(dosyaad),@sil_id=min(id) from yedek

  set @sil_dosyad='del '+@sil_dosyad

  declare @RC int
  /* exec @RC = master..xp_cmdshell @sil_dosyad */
  /*  EXEC master..xp_cmdshell @sil_dosyad */
  /*
   EXEC master.dbo.sp_configure 'show advanced options', 1
   RECONFIGURE
   EXEC master.dbo.sp_configure 'xp_cmdshell', 1
   RECONFIGURE
  */
  
   if @RC=1
   begin
    raiserror ('Error',16,1)
    return
   end 
  
    
   delete from yedek where id =@sil_id
 
 end

 


/*
BACKUP DATABASE [BP] TO  DISK = N'C:\petronet\backup\BPDB.bak' WITH NOFORMAT, NOINIT,
NAME = N'GODB-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
*/


END

================================================================================
