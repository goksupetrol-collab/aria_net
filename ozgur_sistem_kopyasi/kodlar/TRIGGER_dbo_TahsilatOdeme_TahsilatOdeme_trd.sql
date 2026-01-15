-- Trigger: dbo.TahsilatOdeme_trd
-- Tablo: dbo.TahsilatOdeme
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.035067
================================================================================

CREATE TRIGGER [dbo].[TahsilatOdeme_trd] ON [dbo].[TahsilatOdeme]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

 
 declare  @id			INT
 declare  @grp_tip 		varchar(30)
 
  select @id=id,@grp_tip=grp_tip  from deleted
  
  exec Fatura_TahOde @id,@grp_tip,0
  
  

END

================================================================================
