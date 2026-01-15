-- Function: dbo.grupad
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.662392
================================================================================

CREATE FUNCTION dbo.grupad(@grpno1 int,@grpno2 int,@grpno3 int,@tabload varchar(30))
RETURNS varchar(50)
AS
BEGIN
declare @sonuc varchar(50)

if @grpno3 > 0 
select @sonuc=ad from grup where tabload=@tabload and sr=2 and id=@grpno3;
ELSE
begin
if (@grpno2 > 0) and (@grpno1>0)
select @sonuc=ad from grup where tabload=@tabload and sr=1 and id=@grpno2;

if (@grpno1>0) and (@grpno2=0)
select @sonuc=ad from grup where tabload=@tabload and sr=0 and id=@grpno1;
end;

RETURN @sonuc;

  
  
END

================================================================================
