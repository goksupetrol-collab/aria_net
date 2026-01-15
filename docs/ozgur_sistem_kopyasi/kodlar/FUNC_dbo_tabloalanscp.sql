-- Function: dbo.tabloalanscp
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.682492
================================================================================

CREATE FUNCTION [dbo].tabloalanscp (@tabload varchar(30)
)
RETURNS varchar(4000)
AS
BEGIN
declare @alanadi varchar(40)
declare @id float
declare @sqlstr varchar(1000)

declare @fieldstr  varchar(1000);
declare @valuestr  varchar(1500);

set @fieldstr=''
set @valuestr=''

  Declare curpos CURSOR static FOR
  SELECT col.name FROM syscolumns as col
  left join sysobjects as obj on obj.id=col.id
  where obj.xtype='U' and obj.name=@tabload
  order by colorder
  OPEN curpos
  FETCH First FROM curpos into @alanadi
  WHILE (@@FETCH_STATUS = 0) begin

    if @fieldstr=''
    set @fieldstr =@alanadi
    else
    set @fieldstr = COALESCE(@fieldstr+',','' )+@alanadi
    FETCH Next FROM curpos into @alanadi
  end;
  CLOSE curpos
  DEALLOCATE curpos


 set @sqlstr='select '+@valuestr+'=COALESCE('''+@valuestr+''','','')+'''+@fieldstr+N'FROM '+@tabload+'';

 exec @sqlstr



RETURN @fieldstr

END

================================================================================
