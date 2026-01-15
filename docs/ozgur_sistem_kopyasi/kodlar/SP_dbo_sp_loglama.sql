-- Stored Procedure: dbo.sp_loglama
-- Tarih: 2026-01-14 20:06:08.366713
================================================================================

create PROCEDURE [dbo].[sp_loglama]
(
@firmano int,
@id float,
@tabload varchar(30),
@islem int,
@for_log varchar(500)
)
AS
BEGIN
/*
--- 1 insert 0 update -1 delete -2 kalıcı delete
--silen user -tarih- kodu , adi tutari

  --loglama
  Declare
  @SQL Nvarchar(4000),
  @PARAMDEF NVARCHAR(50),
  @LogAlan varchar(1000),
  @Usr varchar(100),
  @Tarih datetime,
  @Deger varchar(8000),
  @UsrIP varchar(20),
  @UsrPC varchar(50)

  Set @Usr=''
  Set @Tarih=''
  Set @Deger=''
  Set @UsrIP=''
  Set @UsrPC=''

  set @LogAlan=''
  Set @LogAlan = (Select Alan from LogAlan Where Tablo=@tabload)

  if @for_log=''
  begin
	set @SQL=''
	set @PARAMDEF='@DegerOut varchar(8000) OUTPUT'
	set @SQL =N' Declare @TmpDeger varchar(8000) '+
				' Set @TmpDeger = (Select top 1 '+@LogAlan+' from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @DegerOut=@TmpDeger '	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@DegerOut=@Deger out
  end

  if @islem=1
  begin
    set @SQL=''
	set @PARAMDEF='@UsrOut varchar(100) OUTPUT'
	set @SQL =N' Declare @TmpUsr varchar(100)'+
				' Set @TmpUsr = (Select top 1 olususer from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @UsrOut=@TmpUsr'	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@UsrOut=@Usr out

	set @SQL=''
	set @PARAMDEF='@TarihOut datetime OUTPUT'
	set @SQL =N'Declare @TmpTarih datetime '+
				' Set @TmpTarih = (Select top 1 olustarsaat from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @TarihOut=@TmpTarih  '	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@TarihOut=@Tarih out

    set @Deger=REPLACE(@Deger,'''','''''')
    Set @UsrIP = (Select isnull(ip,'') from users where ad=@Usr)
    Set @UsrPC = (Select isnull(pc,'') from users where ad=@Usr)

	set @SQL=''
    set @SQL='Insert into  userlog( islem,tarih,usr,ip,pcadi,firmano,kayitid,tablo,ack) values '+
          '( ''KAYIT'','''+convert(varchar,@Tarih,120)+''','''+isnull(@Usr,'')+''','''+isnull(@UsrIP,'')+''','''+isnull(@UsrPC,'')+''','+
          cast(@firmano as varchar(20))+','+cast(@id as varchar(20))+','''+isnull(@tabload,'')+''','''+isnull(@Deger,'')+''' )'
    EXEC SP_EXECUTESQL @SQL

    return
  end

  if @islem=0
  begin
	set @SQL=''
	set @PARAMDEF='@UsrOut varchar(100) OUTPUT'
	set @SQL =N' Declare @TmpUsr varchar(100)'+
				' Set @TmpUsr = (Select top 1 deguser from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @UsrOut=@TmpUsr'	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@UsrOut=@Usr out

	set @SQL=''
	set @PARAMDEF='@TarihOut datetime OUTPUT'
	set @SQL =N'Declare @TmpTarih datetime '+
				' Set @TmpTarih = (Select top 1 degtarsaat from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @TarihOut=@TmpTarih  '	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@TarihOut=@Tarih out

    set @Deger=REPLACE(@Deger,'''','''''')
    Set @UsrIP = (Select ip from users where ad=@Usr)
    Set @UsrPC = (Select pc from users where ad=@Usr)

    set @SQL='Insert into  userlog( islem,tarih,usr,ip,pcadi,firmano,kayitid,tablo,ack) values '+
          '( ''GÜNCELLEME'','''+convert(varchar,@Tarih,120)+''','''+isnull(@Usr,'')+''','''+isnull(@UsrIP,'')+''','''+isnull(@UsrPC,'')+''','+
          cast(@firmano as varchar(20))+','+cast(@id as varchar(20))+','''+isnull(@tabload,'')+''','''+isnull(@Deger,'')+''' )'

    EXEC SP_EXECUTESQL @SQL
    return
  end

  if @islem=-1
  begin
	set @SQL=''
	set @PARAMDEF='@UsrOut varchar(100) OUTPUT'
	set @SQL =N' Declare @TmpUsr varchar(100)'+
				' Set @TmpUsr = (Select top 1 deguser from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @UsrOut=@TmpUsr'	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@UsrOut=@Usr out

	set @SQL=''
	set @PARAMDEF='@TarihOut datetime OUTPUT'
	set @SQL =N'Declare @TmpTarih datetime '+
				' Set @TmpTarih = (Select top 1 degtarsaat from '+@tabload+
		                   ' where firmano='+cast(@firmano as varchar(20))+' and id='+cast(@id as varchar(20))+') '+
			    ' Set @TarihOut=@TmpTarih  '	

    EXEC SP_EXECUTESQL @SQL,@PARAMDEF,@TarihOut=@Tarih out


    set @Deger=REPLACE(@Deger,'''','''''')
    Set @UsrIP = (Select ip from users where ad=@Usr)
    Set @UsrPC = (Select pc from users where ad=@Usr)



    set @SQL='Insert into  userlog( islem,tarih,usr,ip,pcadi,firmano,kayitid,tablo,ack) values '+
          '( ''SİLME'','''+convert(varchar,@Tarih,120)+''','''+isnull(@Usr,'')+''','''+isnull(@UsrIP,'')+''','''+isnull(@UsrPC,'')+''','+
          cast(@firmano as varchar(20))+','+cast(@id as varchar(20))+','''+isnull(@tabload,'')+''','''+isnull(@Deger,'')+''' )'

    EXEC SP_EXECUTESQL @SQL
    return
  end

  if @islem=-2
  begin
    set @Deger=REPLACE(@Deger,'''','''''')
    
    set @SQL='Insert into  userlog( islem,tarih,usr,ip,pcadi,firmano,kayitid,tablo,ack) values '+
          '( ''SİLME'','''+convert(varchar,@Tarih,120)+''','''+isnull(@Usr,'')+''','''+isnull(@UsrIP,'')+''','''+isnull(@UsrPC,'')+''','+
          cast(@firmano as varchar(20))+','+cast(@id as varchar(20))+','''+isnull(@tabload,'')+''','''+isnull(@Deger,'')+''' )'

    EXEC SP_EXECUTESQL @SQL
    return
  end
 */
 return
END

================================================================================
