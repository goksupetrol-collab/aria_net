-- Function: dbo.Genel_Grup_Ad_Ver
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.661441
================================================================================

CREATE FUNCTION [dbo].Genel_Grup_Ad_Ver 
(@grp1 int,@grp2 int,@grp3 int )
RETURNS varchar(100)
AS
BEGIN
declare @sonuc varchar(100) 

  select @sonuc=ad from grup 
  where id=case 
  when @grp3>0 then @grp3
  when @grp2>0 then @grp2
  when @grp1>0 then @grp1
  end
  
  RETURN @sonuc

END

================================================================================
