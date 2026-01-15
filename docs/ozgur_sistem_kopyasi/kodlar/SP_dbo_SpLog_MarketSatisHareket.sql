-- Stored Procedure: dbo.SpLog_MarketSatisHareket
-- Tarih: 2026-01-14 20:06:08.375412
================================================================================

CREATE PROCEDURE dbo.[SpLog_MarketSatisHareket](@MarketSatisId int)
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
     update Log_MarketSatisHareket Set Sil=dt.Sil,TransferStartId=TransferStartId+1,
     SyncStatus=1 from  Log_MarketSatisHareket as t join 
     (Select ins.id,ins.Sil FROM marsathrk AS ins with (nolock)  where 
     ins.marsatid=@MarketSatisId /*and ins.sil=1 */
     and ins.id in (Select Id From Log_MarketSatisHareket with (nolock) 
     Where MarketSatisId=@MarketSatisId)) dt on dt.id=t.Id
  
  
 
	    INSERT INTO [dbo].[Log_MarketSatisHareket] (
				   [Id]
				  ,[BayiId]
				  ,[MarketSatisId]
				  ,[TarihSaat]
				  ,[KartTipId]
				  ,[KartId]
				  ,[Barkod]
				  ,[FiyatNo]
				  ,[Miktar]
				  ,[BirimFiyat]
				  ,[IndirimYuzde]
				  ,[KdvYuzde]
				  ,[KdvTipId]
				  ,[ParaBirimId]
				  ,[ParaBirimKur]
				  ,[BirimId]
				  ,[Sil]
				  /*,[OlusturmaKullaniciTipId] */
				  ,[OlusturmaKullaniciId]
				  ,[OlusturmaTarihSaat]
				  /*,[DegistirmeKullaniciTipId] */
				  ,[DegistirmeKullaniciId]
				  ,[DegistirmeTarihSaat]
				  /*,[SilKullaniciTipId] */
				  /*,[SilKullaniciId] */
				  /*,[SilTarihSaat] */
				  ,[TransferStartId]
				  ,[TransferStopId]
				  ,[TransferTarihSaat]
				  ,[RemoteId]
			  )
			  SELECT
				  inserted.[id]						AS [Id]	
				  ,@BayiId
				  ,inserted.[marsatid]				AS [MarketSatisId]
				  ,CONVERT(DATETIME, CONVERT(CHAR(8), [tarih], 112)+' '+CONVERT(CHAR(8), [saat])) AS [TarihSaat]
				  ,10
				  ,sk.remote_id
				  ,inserted.[barkod]				AS [Barkod]
				  ,inserted.[satfiyno]				AS [FiyatNo]
				  ,inserted.[mik]					AS [Miktar]
				  ,inserted.[brmfiy]				AS [BirimFiyat]
				  ,inserted.[indyuz]				AS [IndirimYuzde]
				  ,inserted.[kdvyuz]				AS [KdvYuzde]
				  /* DİKKAT
				   * KDV Tiplerinin tutulduğu tabloyu bulamadım.
				   * Dahil için 1 gönderilmiş hariç için 0 göndereceğim !!!
				   */
				  ,CASE [kdvtip]			
					  WHEN 'Dahil' THEN 1
					  ELSE 0
				   END AS [KdvTipId]
				  ,CASE [parabrm]
					  WHEN 'TL' THEN 1
					  WHEN 'EUR' THEN 2
					  WHEN 'USD' THEN 3
					  WHEN 'GBP' THEN 4
				   END						AS [ParaBirimId]
				  ,inserted.[kur]			AS [ParaBirimKur]
				  ,CASE inserted.[brim] 
					  WHEN 'AD' THEN 1
					  WHEN 'KG' THEN 2
					  WHEN 'LT' THEN 3
					  ELSE 0
				   END						AS [BirimId]
				  ,inserted.[sil]			AS [Sil]
				  /* YOK! ,inserted.[OlusturmaKullaniciTipId] */
				  /* DİKKAT
				   * users tablosundaki ad alanına <TOP 1 id FROM users WHERE ad=@olususer> sorgusuyla kullanıcı id bilgisini alacağım 
				   * Eğer aynı adla iki kullanıcı olur bulunamazsa id bilgisi boş dönecek oysa sisteme giriş yapmış bir kullanıcı bu işlemi 
				   * yapıyor!
				   */
				  ,(SELECT TOP 1 id FROM users WHERE ad like inserted.olususer)		AS [OlusturmaKullaniciId]
				  ,inserted.[olustarsaat]											AS [OlusturmaTarihSaat]
				  /* YOK! ,inserted.[DegistirmeKullaniciTipId] */
				  /* DİKKAT
				   * OlusturmaKullaniciId ile aynı sorun!!!!
				   */
				  ,(SELECT TOP 1 id FROM users WHERE ad like inserted.deguser)		AS [DegistirmeKullaniciId]
				  ,inserted.[degtarsaat]											AS [DegistirmeTarihSaat]
				  /* YOK! ,inserted.[SilKullaniciTipId] */
				  /* YOK! ,inserted.[SilKullaniciId] */
				  /* YOK! ,inserted.[SilTarihSaat] */
				  ,inserted.[TransferStartId]	AS [TransferStartId]
				  ,inserted.[TransferStopId]	AS [TransferStopId]
				  ,inserted.[Transfer_TarSaat]	AS [TransferTarihSaat] /*,inserted.[TransferDateTime]	AS [TransferTarihSaat] */
				  ,inserted.[remote_id]			AS [RemoteId]
			  FROM Marsathrk AS inserted with (nolock) 
	        INNER JOIN stokkart sk with (nolock) ON sk.tip=inserted.stktip AND sk.Kod = inserted.stkod
             where inserted.marsatid=@MarketSatisId
            and inserted.id not in (Select Id From Log_MarketSatisHareket with (nolock)
            where MarketSatisId=@MarketSatisId)


         /* Silme */
         update Log_MarketSatisHareket Set Sil=1,TransferStartId=TransferStartId+1,
         SyncStatus=1 from Log_MarketSatisHareket as ins  
         where ins.MarketSatisId=@MarketSatisId 
         and ins.Id not in (Select id From Marsathrk with (nolock)
         Where marsatid=@MarketSatisId)



END

================================================================================
