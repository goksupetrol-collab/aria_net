-- Trigger: dbo.bankhrk_trd
-- Tablo: dbo.bankahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.920951
================================================================================

CREATE TRIGGER [dbo].[bankhrk_trd] ON [dbo].[bankahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id    int 
declare @varno float
declare @naktop float
declare @bankod varchar(20)
declare @islmhrk   varchar(30)
declare @bankhrkid   int
declare @yertip   varchar(30)


declare @gidtipkod varchar(20)
declare @gidtiphrkkod varchar(20)


/*-masraf kodları */
 set @gidtipkod='GLG'
 set @gidtiphrkkod='BMF'


SET NOCOUNT ON

DECLARE bankhrksilcur CURSOR LOCAL FAST_FORWARD  FOR SELECT id,bankod,islmhrk,
 bankhrkid,varno,yertip from deleted
 OPEN bankhrksilcur
  FETCH NEXT FROM bankhrksilcur INTO  @id,@bankod,@islmhrk,@bankhrkid,@varno,@yertip
  WHILE @@FETCH_STATUS <> -1
  BEGIN

    if (@islmhrk='YTN') or (@islmhrk='CKN')
    delete from kasahrk where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk 
    if (@islmhrk='B-C') or (@islmhrk='C-B')
    delete from carihrk where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk 
    if (@islmhrk='BKK') or (@islmhrk='EKK')
    delete from carihrk where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk 
    
    if (@islmhrk='BNK') or (@islmhrk='IKO')
    delete from istkhrk where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk 
    

    delete from bankahrk where masterid=@bankhrkid and karsihestip='bankakart'
    and islmhrk=@islmhrk 
    
    
    /*banka gelir gider kasa yansıması silimi */
    delete from bankahrk where masterid=@bankhrkid 
    and karsihestip='bankakart' and islmtip=@gidtipkod 
    and islmhrk=@gidtiphrkkod 
    
    
    /* masraf yansıması */
     delete from carihrk where masterid=@bankhrkid
     and islmtip=@gidtipkod and islmhrk=@gidtiphrkkod 
     and karsihestip='bankakart'
     
     
     
  

  if (@yertip='pomvardimas') and (@islmhrk='C-B')
  begin
  
    update pomvardimas set bankatop=
    (select isnull(sum(borc*kur),0) from bankahrk with (nolock) where varno=@varno and sil=0
    and islmhrk='C-B' and sil=0 and carkod='VRDHES'
    and yertip=@yertip )  where varno=@varno

  end   
     
     
 FETCH NEXT FROM bankhrksilcur INTO  @id,@bankod,@islmhrk,@bankhrkid,@varno,@yertip
END
CLOSE bankhrksilcur
DEALLOCATE bankhrksilcur    
     

SET NOCOUNT OFF
END

================================================================================
