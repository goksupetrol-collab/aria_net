-- Stored Procedure: dbo.SpLog_MarketSatis
-- Tarih: 2026-01-14 20:06:08.374629
================================================================================

CREATE PROCEDURE dbo.[SpLog_MarketSatis](@MarketSatisId int)
AS
BEGIN
  /* Declare @KayOk Int */
  /* Declare @Id Int */
   
   /*--Sadece Insert islemleri icin  */
   /* Select @Id=id,@KayOk=KayOk From Inserted */
    
   /* if EXISTS (Select Id From Log_Fatura With (Nolock) Where Id=@Id) */
   /*    RETURN */
 
   /* if @KayOk=0  */
    /*  RETURN */
	
	
	SET NOCOUNT ON

    if not EXISTS (SELECT [id] FROM [petromas_db]..[isletme] 
      where dataname=DB_NAME() and isnull(AktarimYapilacak,0)=1 )
      RETURN


     IF NOT EXISTS (SELECT * FROM [petromas_db].dbo.sysobjects WHERE name = N'BayiInfo' AND xtype='U' ) 
      RETURN
	

	DECLARE @BayiId INT
	SET @BayiId = (SELECT TOP 1 [BayiId] FROM [petromas_db]..[BayiInfo] ORDER BY BayiId DESC)
  
  
     if @BayiId is null
	 RETURN
  
  
     /*update islemi Silme */
     update Log_MarketSatis Set Sil=dt.Sil,TransferStartId=TransferStartId+1,
     SyncStatus=1 from  Log_MarketSatis as t join 
     (Select ins.id,ins.Sil FROM marsatmas AS ins where 
     ins.marsatid=@MarketSatisId /*and ins.sil=1 */
     and ins.id in (Select Id From Log_MarketSatis 
     Where Id=@MarketSatisId)) dt on dt.id=t.Id
  
  
 
	    INSERT INTO [dbo].[Log_MarketSatis]
		(
			Id,
			BayiId
			,MarketVardiyaId
			,TarihSaat
			,IslemTipId
			/* YOK! ,OlusturmaKullaniciTipId */
			,OlusturmaKullaniciId
			,OlusturmaTarihSaat
			/* YOK! ,DegistirmeKullaniciTipId */
			,DegistirmeKullaniciId
			,DegistirmeTarihSaat
			,Sil
			,NakitTutar
			,PosTutar
			,VeresiyeTutar
			,IadeTutar
			,IndirimTutar
			,YuvarlamaTutar
			,SatisTutar
			,GiderTutar
			,RemoteId
			,YazarKasaNo
			,VeresiyeId
			,FaturaId
			,TransferStartId
			,TransferStopId	
			,TransferTarihSaat
		)
		SELECT
		id 						AS ID
		/*,marsatid				 */
		,@BayiId				AS BayiId
		,varno					AS MarketVardiyaId
		/*,varok */
		/*,kayok */
		/*,tarih */
		,CONVERT(DATETIME, CONVERT(CHAR(8), tarih, 112)+' '+CONVERT(CHAR(8), saat)) AS TarihSaat
		/*,saat */
		,CASE islmtip
			WHEN 'satis' THEN 9
			WHEN 'iade' THEN 10 
		END 					AS IslemTipId
		/*,islmtipad		 */
		/*,yertip		 */
		/*,yerad	 */
		/* DİKKAT
		* users tablosundaki ad alanına <TOP 1 id FROM users WHERE ad=@olususer> sorgusuyla kullanıcı id bilgisini alacağım 
		* Eğer aynı adla iki kullanıcı olur bulunamazsa id bilgisi boş dönecek oysa sisteme giriş yapmış bir kullanıcı bu işlemi 
		* yapıyor!
		*/
		,(SELECT TOP 1 id FROM users WHERE ad=ins.olususer)		AS OlusturmaKullaniciId
		,[olustarsaat]													AS OlusturmaTarihSaat
		/* YOK! ,[DegistirmeKullaniciTipId] */
		/* DİKKAT
		* OlusturmaKullaniciId ile aynı sorun!!!!
		*/
		,(SELECT TOP 1 id FROM users WHERE ad like ins.deguser)	AS DegistirmeKullaniciId
		,degtarsaat														AS DegistirmeTarihSaat
		,sil					AS Sil
		/*,dataok		 */
		,naktop					AS NakitTutar
		,postop					AS PosTutar
		,veresitop				AS VeresiyeTutar
		,iadetop				AS IadeTutar
		,indtop					AS IndirimTutar
		,yuvtop					AS YuvarlamaTutar
		/*,parabrm		 */
		/*,kur		 */
		,satistop				AS SatisTutar
		,gidertop				AS GiderTutar
		/*,cartip		 */
		/*,carkod		 */
		/*,islmhrk		 */
		/*,islmhrkad		 */
		/*,cartip_id		 */
		/*,car_id		 */
		,remote_id				AS RemoteId
		,YazarKasa_id			AS YazarKasaNo
		,Verid					AS VeresiyeId
		,Fatid					AS FaturaId
		/*,Fis_No		 */
		/*,[Transfer]		 */
		/*,Transfer_TarSaat		 */
		,TransferStartId		AS TransferStartId
		,TransferStopId			AS TransferStopId	
		,TransferDateTime		AS TransferTarihSaat
		FROM marsatmas as ins with (nolock) 
        where ins.sil=0 and ins.marsatid=@MarketSatisId
        and ins.id not in (Select Id From Log_MarketSatis with (NOLOCK)
        where Id=@MarketSatisId )


     /* Silme */
     update Log_MarketSatis Set Sil=1,TransferStartId=TransferStartId+1,
     SyncStatus=1 from Log_MarketSatis as ins 
     where ins.Id=@MarketSatisId and ins.Id not in (Select id From Marsatmas with (nolock) 
     Where id=@MarketSatisId)



END

================================================================================
