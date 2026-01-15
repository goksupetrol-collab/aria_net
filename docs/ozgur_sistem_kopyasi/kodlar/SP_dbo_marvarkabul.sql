-- Stored Procedure: dbo.marvarkabul
-- Tarih: 2026-01-14 20:06:08.347861
================================================================================

Create PROCEDURE [dbo].marvarkabul
(@varno float,@varok int,@sil int)
AS
BEGIN
SET NOCOUNT ON



declare @say 					int
declare @Firmano                int
declare @varad 					varchar(40)
declare @yertip 				varchar(30)

set @yertip='marvardimas'

/*----silme ve geri alma durumu icin */
if (@sil=1) or (@varok=0)
begin
 delete from marvardiozet where varno=@varno

/*-VARDIYA ACIK FAZLA İSLENMESI SILIMI */
 delete from carihrk where varno=@varno 
 and yertip=@yertip and islmtip='VAR';


RETURN
end
/*----silme ve geri alma durumu icin */

 delete from marvardiozet where varno=@varno

/*kasa cari tahsilat karsi hesap kapatma */
 exec Vardiya_Kasa_Kapat @yertip,@varno

/*--vardiya ozet tablosuna kapanis bilgilerini at */
 exec marvarozet @varno,'per','genel'
  insert into marvardiozet (varno,varok,sil,tip,tipack,giris,cikis,bakiye,sr)
   select @varno,@varok,@sil,ickkod,ickad,sum(grs),sum(cks),sum(grs-cks),sr
    from ##marvardiozet where varno=@varno
     group by ickkod,ickad,sr order by sr
/*------------------------ */



   declare @cartip varchar(20)
   declare @carkod varchar(30)
   
   
    select top 1 @cartip=cartip,@carkod=kod from marvardikap 
    with (nolock) where varno=@varno and sil=0
    
    delete from carihrk where varno=@varno and yertip=@yertip 
    and islmtip='VAR'
    
       
   
    /*personel carihrk */
    
    declare @KapTarih Datetime
    declare @KapTarihSaat varchar(20)
    declare @KapAcik      varchar(150)
    
    select @Firmano=Firmano,@KapTarih=kaptar,@KapTarihSaat=Kapsaat,@varad=varad from marvardimas with (nolock)
    where varno=@Varno and Sil=0 
    set @KapAcik='TARIH : '+CONVERT(varchar,@KapTarih, 104)+' # '+@varad+'. NOLU VARDIYA #'; 

     
    INSERT INTO [carihrk] (firmano,carhrkid,gctip,
    islmtip,islmtipad,
    islmhrk,islmhrkad,
    yertip,yerad,cartip,carkod,masterid,fisfattip,fisfatid,
    varno,perkod,adaid,tarih,saat,
    belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat,varok)
    select @firmano,0,case when ackfaz='acik' then 'C' else 'G' end,
    'VAR', N'VARDİYA', 
    case when ackfaz='acik' then 'ACK' else 'FAZ' end,
    case when ackfaz='acik' then 'VARDİYA AÇIK' else 'VARDİYA FAZLA' end,
    'marvardimas','MARKET VARDİYA', 
    cartip,kod,0,'KENDI',0,varno,'',0,@KapTarih,@KapTarihSaat,
    varno,@KapAcik+case when ackfaz='acik' then ' HESAP AÇIĞI' else ' HESAP FAZLASI' end,
    case when ackfaz='acik' then abs(tutar) else 0 end,
    case when ackfaz='acik' then 0 else abs(tutar) end,
    1,'TL',olususer,olustarsaat,@varok 
    from marvardikap with (nolock) where varno=@varno and sil=0 and ABS(tutar)>0
    
    update carihrk set carhrkid=id where carhrkid=0 and islmtip='VAR' and sil=0  


END

================================================================================
