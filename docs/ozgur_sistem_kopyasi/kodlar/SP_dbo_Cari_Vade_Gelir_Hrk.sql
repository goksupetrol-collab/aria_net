-- Stored Procedure: dbo.Cari_Vade_Gelir_Hrk
-- Tarih: 2026-01-14 20:06:08.316765
================================================================================

CREATE PROCEDURE  [dbo].[Cari_Vade_Gelir_Hrk] (@id float,@sil int)
AS
BEGIN

declare @newid float    
declare @islmtip varchar(10)
declare @islmhrk varchar(10)   

set @islmtip='VAD'
set @islmhrk='CVF'


 if @sil=1
  begin
    delete from carihrk where masterid=@id and islmtip=@islmtip and islmhrk=@islmhrk
    RETURN
  end
  

   if @sil=0
   begin 
     delete from carihrk where masterid=@id and islmtip=@islmtip and islmhrk=@islmhrk 
    
     select @newid=0 
     insert into carihrk (firmano,carhrkid,gctip,masterid,carvardmasid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
     cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
     ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm)
     select firmano,@newid,'-',@id,carvardmasid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
     karsihestip,karsiheskod,alacak,borc,tarih,saat,olususer,olustarsaat,tarih,belno,
     ack,varno,kur,dataok,1,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm
     from carihrk with (nolock)  where carhrkid=@id and islmtip=@islmtip and islmhrk=@islmhrk 

     select @newid=SCOPE_IDENTITY()
     update carihrk set carhrkid=@newid where id=@newid
     
   end
    
    



END

================================================================================
