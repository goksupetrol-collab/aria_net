-- Stored Procedure: dbo.sp_LogMotor
-- Tarih: 2026-01-14 20:06:08.366987
================================================================================

CREATE procedure [dbo].sp_LogMotor
(
@TabloAd varchar(100),
@Rec_Id varchar(100),
@Islem int, /* 1 Insert , 0 Update , -1 Delete, */
@userid int
)
as



Declare
	@TmpAlan varchar(8000),
	@Alanlar varchar(8000),
	@ParamAlan varchar(8000),
	@DeclareAlan varchar(8000),
    @pcadi varchar(50),
    @pcip varchar(20)
    
    select @pcadi=isnull(ip,''),@pcip=isnull(pc,'') from users where id=@userid


	Set @TmpAlan=''
	Set @Alanlar=''
	Set @ParamAlan=''
	Set @DeclareAlan=''



Declare TabloAlanlari Cursor for
select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TabloAd and DATA_TYPE<>'image'

 Open TabloAlanlari
	Fetch Next From TabloAlanlari into  @TmpAlan
	While @@Fetch_status =0
	begin
	  Set @Alanlar = @Alanlar +'@'+@TmpAlan + '=isnull('+@TmpAlan +',''''),'
      Set @ParamAlan =@ParamAlan+'+''|'+@TmpAlan+'=''+@'+@TmpAlan
	  Set @DeclareAlan=@DeclareAlan+'@'+@TmpAlan+' varchar(8000),'
	  Fetch Next From TabloAlanlari into  @TmpAlan
	end

Close TabloAlanlari
Deallocate TabloAlanlari

Set @ParamAlan =SUBSTRING ( @ParamAlan ,2 , len(@ParamAlan) )
Set @DeclareAlan =' Declare ' +SUBSTRING ( @DeclareAlan ,1 , len(@DeclareAlan)-1 )
Set @Alanlar =SUBSTRING ( @Alanlar ,1 , len(@Alanlar)-1 )

DEclare @str_datetime varchar(50)
Set @str_datetime=convert(varchar,getdate(),120)


Exec(@DeclareAlan+'
declare @islemdetay varchar(8000)
 select '+@Alanlar+' from '+@TabloAd+' Where id='+@Rec_Id+'
 set @islemdetay =(select '+@ParamAlan+' )
 insert into eventlog (tarih,recid,userid,islemtipi,islemdetay,ip,pcadi)
values ('''+@str_datetime+''','+@Rec_Id+','+@userid+','+@Islem+',@islemdetay,'''+@pcip+''','''+@pcadi+''')')
/*Log insert gelicek */

================================================================================
