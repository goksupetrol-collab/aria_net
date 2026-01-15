-- Trigger: dbo.faturamas_tru
-- Tablo: dbo.faturamas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.945274
================================================================================

CREATE TRIGGER [dbo].[faturamas_tru] ON [dbo].[faturamas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @fatid float
declare @isklutop float
declare @geniskorn float
declare @kayok int,@sil int

SET NOCOUNT ON

 select @kayok=kayok,@sil=sil,@fatid=fatid from inserted

 if @fatid=0 
  RETURN
  

 /*if update(entegre_tip) and  */
 /* (not UPDATE(genisktop))   */
   /* RETURN */

 /*if update(genisktop) or UPDATE(ak_isk_top)  */
/* or UPDATE(mr_isk_top) or UPDATE(gg_isk_top)  */
  /*exec faturahrkgiris @fatid,@kayok,@sil */

if update(kayok) or  update(sil)
 begin
 
 update faturahrk set sil=@sil where fatid=@fatid and sil=0

 if @sil=1
 begin
      exec stokhrkisle @fatid,'faturahrk','',@kayok,@sil,@fatid 
      update kasahrk set sil=1 where fisfattip='FAT' and fisfatid=@fatid
      update poshrk set sil=1  where fisfattip='FAT' and fisfatid=@fatid
      update cekkart set sil=1 where fisfattip='FAT' and fisfatid=@fatid
      update bankahrk set sil=1 where fisfattip='FAT' and fisfatid=@fatid

      update carihrk set sil=1 where masterid=@fatid
      and SUBSTRING(islmhrk,1,3)='FAT'

    /* fatura iskonto yansimasi */
      update carihrk set sil=1 where fatid=@fatid
      and islmtip='GLG' and islmhrk='FTI'


      update carihrk set sil=1 where fisfattip='FAT' 
      and fatid=@fatid

       exec SpFaturaFisIkontoKontrol @fatid,@sil


      exec  verfisisle_sil @fatid
      exec  irsaliyeisle_sil @fatid
      
      exec Fat_Dep_Transfer @fatid,@sil
      
     
      
      if @fatid>0
       update TahsilatOdeme set Sil=@Sil where Fatid=@fatid
      
  end

  if @kayok=1
   begin
         /*update faturahrk set kayok=@kayok where fatid=@fatid  */
 
 
         exec faturahrkgiris @fatid,@kayok,@sil
         exec stokhrkisle    @fatid,'faturahrk','',@kayok,@sil,@fatid
         
         exec Fat_Dep_Transfer @fatid,@sil
         
         exec faturagiris @fatid
         exec siparisisle @fatid
         exec verfisisle @fatid
         exec irsaliyeisle @fatid
         
         exec SpFaturaFisIkontoKontrol @fatid,@sil
         
    end

end
  SET NOCOUNT OFF

END

================================================================================
