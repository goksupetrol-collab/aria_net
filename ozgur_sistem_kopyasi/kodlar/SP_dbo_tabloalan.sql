-- Stored Procedure: dbo.tabloalan
-- Tarih: 2026-01-14 20:06:08.384924
================================================================================

CREATE PROCEDURE [dbo].tabloalan (@tabload varchar(30),@fieldstr nvarchar(4000) OUTPUT
)
AS
BEGIN
declare @alanadi varchar(40)
declare @sqlstr varchar(1000)

/*declare @fieldstr  varchar(1000); */
declare @valuestr  varchar(8000);

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

   /* if @fieldstr='' */
    set @fieldstr =cast(@alanadi as varchar)
   /* else */
   /* set @fieldstr = COALESCE(@fieldstr+',','' )+@alanadi */
    FETCH Next FROM curpos into @alanadi
  end;
  CLOSE curpos
  DEALLOCATE curpos


  
/*
  EXEC(@sqlstr)
  OPEN curposf
  FETCH First FROM curposf into @alanadi
  WHILE (@@FETCH_STATUS = 0) begin

    if @valuestr=''
    set @valuestr =@alanadi
    else
    set @valuestr = COALESCE(@valuestr+',','' )+@alanadi

  FETCH Next FROM curposf into @alanadi
  end;
  CLOSE curposf
  DEALLOCATE curposf

*/


/*'''+@fieldstr */
  /*set @sqlstr='declare @valuestr varchar(8000); select @valuestr=COALESCE(@valuestr,'','')+cast(id as varchar)+'' ''+ad FROM '+@tabload+' '; */
  /*EXEC(@sqlstr) */



RETURN @fieldstr

END

================================================================================
