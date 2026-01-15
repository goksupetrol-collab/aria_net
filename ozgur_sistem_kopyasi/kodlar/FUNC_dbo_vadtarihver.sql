-- Function: dbo.vadtarihver
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.800048
================================================================================

CREATE FUNCTION [dbo].vadtarihver
(@tip varchar(10),
@gun int,
@dt datetime
)
RETURNS
datetime
AS
BEGIN

 if (@tip='fattar') or (@tip='fistar')  
 set @dt=dateadd(day,@gun,convert(datetime,@dt))

 if @tip='bsaygun'
 begin
 declare @date char(20)
 declare @dayin int
 set @date =cast(YEAR(@dt) as varchar)+'-'+cast(MONTH(@dt) as varchar)+ '-01'
 set @dayin=datepart(day,dateadd(day,-1,(dateadd(month, 2, @date))))
 
 if @dayin>@gun
 begin
     select @dt=dateadd(month,1,@dt)
     set @dt=cast(YEAR(@dt) as varchar)+'-'+
     cast(MONTH(@dt) as varchar)+'-'+cast(@gun as varchar(2))
   end
  else
   begin
     select @dt=dateadd(month,1,@dt)
     set @dt=cast(YEAR(@dt) as varchar)+'-'+cast(MONTH(@dt) as varchar)+ '-01'
     set @dt=dateadd(day,@gun-1,convert(datetime,@dt))
   end
 end
 
return @dt


END

================================================================================
