-- Stored Procedure: dbo.personelmaas
-- Tarih: 2026-01-14 20:06:08.352660
================================================================================

CREATE PROCEDURE [dbo].personelmaas (@masid float,@sil int)
AS
BEGIN
  
declare @newid float
declare @gctip varchar(1);
declare @borc float,@alacak float

DECLARE @CARTIP VARCHAR(30)
DECLARE @CARKOD VARCHAR(50)
DECLARE @TUTAR FLOAT
DECLARE @KUR FLOAT

/*gider hareketleri */
  DECLARE @gidkod varchar(30)
  DECLARE @gidtutar float

  select @gidkod=karsiheskod,@gidtutar=isnull(sum(alacak),0) from carihrk
  with (nolock)
  where permasmasid=@masid and cartip='perkart' and sil=0 
  group by karsiheskod

  update carihrk set sil=1 where 
  permasmasid=@masid and cartip='gelgidkart'

  if isnull(@gidtutar,0)>0 and (@sil=0)
  begin
  select @newid=0
  insert into carihrk (permasmasid,carhrkid,gctip,masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,
  yertip,yerad,cartip,carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,
  karsihestip,karsiheskod,parabrm) 
  select top 1 @masid,@newid,'B',0,'KENDI',0,islmtip,islmtipad,
  islmhrk,islmhrkad,yertip,yerad,'gelgidkart',@gidkod,@gidtutar,0,0,tarih,saat,olususer,olustarsaat,null,belno,
  ack,0,kur,0,1,1,'',0,deguser,degtarsaat,sil,
  '','',parabrm from carihrk with (nolock)  where permasmasid=@masid 
  and cartip='perkart' and sil=0
  
  select @newid=SCOPE_IDENTITY()
  update carihrk set carhrkid=@newid where id=@newid
  
  end



END

================================================================================
