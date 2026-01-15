-- Trigger: dbo.TahsilatOdeme_tru
-- Tablo: dbo.TahsilatOdeme
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.035405
================================================================================

CREATE TRIGGER [dbo].[TahsilatOdeme_tru] ON [dbo].[TahsilatOdeme]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

 DECLARE  @id			INT
 declare  @grp_tip 		varchar(30)
 declare  @kayit         bit
 declare  @Vadeli         bit
 declare @vadetar        datetime
 declare @fatid			 int
 
 
  select @id=id,@grp_tip=grp_tip,
  @fatid=case When fatid>0 then fatid else fisid end,
  @Vadeli=Vadeli,@VadeTar=VadeTar from inserted
   
   set @kayit=0
  
  if @Vadeli=0
   set @kayit=1 
  
   

  if @VadeTar<=getdate() and @Vadeli=1
   set @kayit=1
  
  if @fatid>0
     exec Fatura_TahOde @id,@grp_tip,@kayit
     
     

END

================================================================================
