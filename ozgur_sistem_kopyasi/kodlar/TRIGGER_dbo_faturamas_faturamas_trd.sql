-- Trigger: dbo.faturamas_trd
-- Tablo: dbo.faturamas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.944834
================================================================================

CREATE TRIGGER [dbo].[faturamas_trd] ON [dbo].[faturamas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id float,@fatid float

SET NOCOUNT ON


 DECLARE faturadel CURSOR LOCAL FOR SELECT id,fatid from deleted
 OPEN faturadel
  FETCH NEXT FROM faturadel INTO  @id,@fatid
  WHILE @@FETCH_STATUS = 0
  BEGIN

   if @fatid=0 
    RETURN
    
    
     exec Fat_Dep_Transfer @fatid,1

   


   /* fatura geri al için bekletiyoruz kayıtları */
  if isnull((select count(*) from faturahrk where fatid=@fatid and sil=0),0)=0
  begin
   

  delete from kasahrk where fisfattip='FAT' and fisfatid=@fatid;
  delete from poshrk where fisfattip='FAT' and fisfatid=@fatid;
  delete from cekkart where fisfattip='FAT' and fisfatid=@fatid;
  delete from bankahrk where fisfattip='FAT' and fisfatid=@fatid;
  delete from carihrk where masterid=@fatid
  AND SUBSTRING(islmhrk,1,3)='FAT'
  
  
   exec stokhrkisle @fatid,'faturahrk','',1,1,@fatid
  
   /* fatura iskonto yansimasi */
  delete carihrk where fatid=@fatid and islmtip='GLG' and islmhrk='FTI'
      
  delete from carihrk where fisfattip='FAT' and fatid=@fatid


  exec verfisisle_sil @fatid
  exec irsaliyeisle_sil @fatid
  
  exec SpFaturaFisIkontoKontrol @fatid,1
  
  delete from faturahrk where fatid=@fatid
  
  if @fatid>0
    update TahsilatOdeme set Sil=1 where Fatid=@fatid
  
   

  end

   FETCH NEXT FROM faturadel INTO  @id,@fatid
  END
  
 CLOSE faturadel
 DEALLOCATE faturadel


 SET NOCOUNT OFF

END

================================================================================
