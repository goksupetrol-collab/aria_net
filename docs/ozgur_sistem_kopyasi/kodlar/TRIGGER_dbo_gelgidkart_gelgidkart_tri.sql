-- Trigger: dbo.gelgidkart_tri
-- Tablo: dbo.gelgidkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.948904
================================================================================

CREATE TRIGGER [dbo].[gelgidkart_tri] ON [dbo].[gelgidkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @sis_gelirid int,@sis_@giderid int;
declare @grpid int
declare @kod varchar(20);
DECLARE @id float;

select @sis_gelirid=grp_gelirid,@sis_@giderid=grp_giderid from sistemtanim

select @id=id,@kod=kod,@grpid=grp1 from inserted;

EXEC carikartacilis 'gelgidkart',@kod;

if @grpid=@sis_gelirid
EXEC numara_no_yaz 'gelirkart',@kod

if @grpid=@sis_@giderid
EXEC numara_no_yaz 'giderkart',@kod



END

================================================================================
