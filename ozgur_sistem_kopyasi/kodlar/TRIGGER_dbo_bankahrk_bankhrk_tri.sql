-- Trigger: dbo.bankhrk_tri
-- Tablo: dbo.bankahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.921430
================================================================================

CREATE TRIGGER [dbo].[bankhrk_tri] ON [dbo].[bankahrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN


SET NOCOUNT ON

declare @varno float
declare @islmtip varchar(20)
declare @islmhrk varchar(20)
declare @yertip varchar(30)
declare @belno varchar(20)
declare @bankhrkid float
declare @id       int
declare @newid float
declare @gctip varchar(1)
declare @borc float,@alacak float
declare @bankod varchar(20)
declare @bankhrkIdcount int
declare @firmano  int


  select @id=id,@bankod=bankod,@bankhrkid=bankhrkid,@yertip=yertip,
  @islmtip=islmtip,@islmhrk=islmhrk,@varno=varno,@firmano=firmano,
  @belno=belno from inserted
    
  select @bankhrkIdcount=count(*) from bankahrk with (nolock)
  where isnull(bankhrkid,0)=0 and firmano=@firmano 

  
  if (@islmhrk='B-C') or (@islmhrk='C-B')
   begin 
     if isnull(@bankhrkid,0)=0
      begin
        update bankahrk set bankhrkid=id where isnull(bankhrkid,0)=0
        set @bankhrkid=@id 
      end  
   end


  if @bankhrkIdcount>1
  begin
    RAISERROR ('BankahrkId Hatası', 16,1) 
    ROLLBACK TRANSACTION
    RETURN
  end

 if isnull(@bankhrkid,0)=0
  return
   
   exec bankhrkgiris @id

   exec numara_no_yaz 'makbuz',@belno
 
  
   
 if (@yertip='pomvardimas') and (@islmtip='BNK') 
  and (@islmhrk='C-B')
  begin
  
   update pomvardimas set bankatop=
   (select isnull(sum(borc*kur),0) from bankahrk with (nolock) where varno=@varno and sil=0
   and islmtip='BNK' and islmhrk in ('C-B') and sil=0 and carkod='VRDHES'
   and yertip=@yertip )  where varno=@varno
 
 end
 
 
 
 if (@yertip='marvardimas') and (@islmtip='BNK') 
  and (@islmhrk='C-B')
  begin
  
   update marvardimas set bankatop=
   (select isnull(sum(borc*kur),0) from bankahrk with (nolock) where varno=@varno and sil=0
   and islmtip='BNK' and islmhrk in ('C-B') and sil=0 and carkod='VRDHES'
   and yertip=@yertip )  where varno=@varno
 
 end
  


  SET NOCOUNT OFF
END

================================================================================
