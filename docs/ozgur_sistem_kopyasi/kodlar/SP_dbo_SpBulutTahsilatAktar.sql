-- Stored Procedure: dbo.SpBulutTahsilatAktar
-- Tarih: 2026-01-14 20:06:08.371551
================================================================================

CREATE PROCEDURE dbo.[SpBulutTahsilatAktar](
@Id  int )
AS
BEGIN
  
   declare @RecId    int
   declare @BankKod    varchar(50)
   declare @CariKod    varchar(50)
   declare @CariTipId  int
   declare @CariId    int
   declare @BankId    int
   declare @Tutar    float
   declare @CariTur    varchar(50)
   declare @CariTip    varchar(50)
   
   set @CariTur='carikart'
   set @CariTip='CARİ KARTLAR'
   
     
     
    select @CariTipId=CariTipId,@CariId=CariId,@BankId=BankaId,@Tutar=Tutar from  BulutTahsilat with (nolock) 
    Where Id=@Id
    
   
    
    select  @CariKod=kod,@CariTur=cartp,@CariTip=tip 
    from Genel_Kart with (nolock) Where Tip_id=@CariTipId and id=@CariId
    select  @BankKod=kod from bankakart with (nolock) Where id=@BankId
    
   if @Tutar>0 
    insert into bankahrk (firmano,gctip,bankhrkid,
    islmtip,islmtipad,
    islmhrk,islmhrkad,
    yertip,yerad,
    cartip,masterid,fisfatid,fisfattip,
    varno,varok,perkod,adaid,
    vadetar,tarih,saat,
    cartur,carkod,bankod,kaskod,
    belno,ack,borc,alacak,kur,parabrm,
    olususer,olustarsaat,
    gidkod,gidtutar,rg,CariAvans,
    Karsi_KartTip,Karsi_KartKod)
    select firmano,'C',0,
    'BNK','BANKA',
    'C-B','GELEN HAVALE / EFT',
    'bulut','Bulut Tahsilat',
    @CariTur,0,0,'KENDI',
    0,1,'Diger',0,
    DATEADD(DAY, DATEDIFF(DAY, 0, TarihSaat), 0),
    DATEADD(DAY, DATEDIFF(DAY, 0, TarihSaat), 0),
    convert(char(8), TarihSaat, 108),
    @CariTip,@CariKod,@BankKod,'',
    'BLT',SUBSTRING(Aciklama,1,100),Tutar,0,1,'TL',
    'Bulut Tahsilat',GetDate(),
    '',0,1,0,
    @CariTur,@CariKod
    from  BulutTahsilat with (nolock) Where Id=@Id
    
    
    if @Tutar<0 
    insert into bankahrk (firmano,gctip,bankhrkid,
    islmtip,islmtipad,
    islmhrk,islmhrkad,
    yertip,yerad,
    cartip,masterid,fisfatid,fisfattip,
    varno,varok,perkod,adaid,
    vadetar,tarih,saat,
    cartur,carkod,bankod,kaskod,
    belno,ack,borc,alacak,kur,parabrm,
    olususer,olustarsaat,
    gidkod,gidtutar,rg,CariAvans,
    Karsi_KartTip,Karsi_KartKod)
    select firmano,'G',0,
    'BNK','BANKA',
    'B-C','GİDEN HAVALE / EFT',
    'bulut','Bulut Tahsilat',
    @CariTur,0,0,'KENDI',
    0,1,'Diger',0,
    DATEADD(DAY, DATEDIFF(DAY, 0, TarihSaat), 0),
    DATEADD(DAY, DATEDIFF(DAY, 0, TarihSaat), 0),
    convert(char(8), TarihSaat, 108),
    @CariTip,@CariKod,@BankKod,'',
    'BLT',SUBSTRING(Aciklama,1,100),0,-1*Tutar,1,'TL',
    'Bulut Tahsilat',GetDate(),
    '',0,1,0,
    @CariTur,@CariKod
    from  BulutTahsilat with (nolock) Where Id=@Id
    
    
    
    select @RecId=SCOPE_IDENTITY()
    
    update bankahrk WITH (TABLOCK) set bankhrkid=@recId where id=@recId
    
    update BulutTahsilat set AktarimId=@RecId,AktarimTarihSaat=GetDate()
     Where Id=@Id



     
  
   RETURN  @RecId

END

================================================================================
