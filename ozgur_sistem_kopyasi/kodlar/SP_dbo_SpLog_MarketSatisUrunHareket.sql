-- Stored Procedure: dbo.SpLog_MarketSatisUrunHareket
-- Tarih: 2026-01-14 20:06:08.376086
================================================================================

CREATE PROCEDURE dbo.[SpLog_MarketSatisUrunHareket]( 
@MarketSatisId int)
AS
BEGIN

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
     update Log_UrunHareket Set 
     Sil=dt.Sil,
     KartId=dt.SkRemoteId, /*dt.RemoteId, */
     StokKodu=dt.stkod,
     StokBarkod=dt.Barkod,
     ReceteStokHareketId=dt.MarSatRecHrkId,
     Giren=dt.Giren,Cikan=dt.Cikan,
     BirimFiyatNetKdvli=dt.brmfiykdvli,
     KdvYuzde=dt.KdvYuzde,
     TransferStartId=TransferStartId+1,
     SyncStatus=1,
     TarihSaat=Dt.TarihSaat,
     IslemTipId=dt.IslemTipId
     from  Log_UrunHareket as t join 
     (Select ins.id,ins.Sil,ins.barkod,sk.remote_id as SkRemoteId,ins.MarSatRecHrkId,
     ins.stkod,ins.remote_id  AS RemoteId,
     CONVERT(DATETIME, CONVERT(CHAR(8), ins.tarih, 112)+' '+CONVERT(CHAR(8), ins.saat)) AS TarihSaat,
     CASE ins.islmtip 
			WHEN 'MARSAT' THEN 9 
			WHEN 'MARIAD' THEN 10
			WHEN 'FATMRALS' THEN 2
			/* Diğer tüm durumlar için tekrar gözden geçirilmeli */
		 END IslemTipId,	
     ins.Giren,ins.cikan,
     ins.brmfiykdvli,ins.kdvyuz*100 KdvYuzde
      FROM stkhrk AS ins with (nolock) 
     inner join stokkart sk with (nolock) on 
     sk.kod = ins.Stkod and sk.tip = ins.stktip and ins.marsatid=@MarketSatisId
     /*and ins.sil=1 */
     and ins.id in (Select Id From Log_UrunHareket with (nolock) 
     Where MarketSatisId=@MarketSatisId)) dt on dt.id=t.Id

   
   /*Insert İslemi */
    INSERT INTO [dbo].[Log_UrunHareket]
			   ([Id]
			   ,[KartTipId]
			   ,[StokKodu]
               ,[StokBarkod]
			   ,[BayiId]
			   ,[MarketVardiyaId]
			   ,[Sil]
			   ,[IslemTipId]
			   ,[TarihSaat]
			   ,[Giren]
			   ,[Cikan]
			   ,[BirimFiyatNetKdvli]
			   ,[KdvYuzde]
			   ,[Otv]
			   ,[BelgeNo]
			   ,[Aciklama]
			   ,[OlusturmaKullaniciId]
			   ,[OlusturmaTarihSaat]
			   ,[DegistirmeKullaniciId]
			   ,[DegistirmeTarihSaat]
   			   ,[FaturaId]
			   ,[IrsaliyeId]
			   ,[SayimId]
			   ,[KartId]
			   ,[RemoteId]
			   ,[DepoTransferId]
			   ,[DepoId]
			   ,[MarketSatisId]
			   ,[MarketSatisHareketId]
               ,[ReceteStokHareketId]
			   )
        SELECT
		 ins.id  AS Id
		,CASE ins.stktip 
			WHEN 'markt' THEN 10
			ELSE NULL
				/* markt değerinin [OpetBackOffice].[dbo].[KartTip] tarafında 10 */
				/* değerine denk geliyor */
				/* !! Tüm alabileceği değerler için WHEN koşulunu doldurmalı !! */
				/* > SELECT * FROM [OpetBackOffice].[dbo].[KartTip]							 */

	  								  
		END	AS KartTipId
		,ins.stkod   AS StokKodu
        ,ins.barkod  As Barkod
		,@BayiId	 AS BayiId
		,ins.varno  AS MarketVardiyaId
		,ins.sil   AS Sil
		,CASE ins.islmtip 
			WHEN 'MARSAT' THEN 9 
			WHEN 'MARIAD' THEN 10
			WHEN 'FATMRALS' THEN 2
			/* Diğer tüm durumlar için tekrar gözden geçirilmeli */
		 END															

					AS IslemTipId
		,CONVERT(DATETIME, CONVERT(CHAR(8), ins.tarih, 112)+' '+CONVERT(CHAR(8), ins.saat)) AS TarihSaat
		,ins.giren   AS Giren
		,ins.cikan   AS Cikan
		,ins.brmfiykdvli   AS BirimFiyatNetKdvli
		,ins.kdvyuz*100    AS KdvYuzde
		,ins.otv      AS Otv
		,ins.belno    AS BelgeNo
		,ins.ack   AS Aciklama
		,(SELECT TOP 1 ins.id FROM users WHERE ad like ins.olususer)  AS OlusturmaKullaniciId
		,ins.olustarsaat     AS OlusturmaTarihSaat
		,(SELECT TOP 1 ins.id FROM users WHERE ad like ins.deguser)    AS DegistirmeKullaniciId
		,ins.degtarsaat    AS DegistirmeTarihSaat
	    ,ins.fatid  AS FaturaId
		,ins.irid    AS IrsaliyeId
		,ins.sayid   AS SayimId
		,sk.Remote_id 	AS OpetUrunId
		,ins.remote_id  AS RemoteId
		,ins.DepTrsId    AS DepoTransferId
		,ins.DepoId   AS DepoId
		,ins.marsatid
		,ins.stkhrkid
        ,ins.MarSatRecHrkId
		FROM stkhrk AS ins with (nolock)  
        inner join stokkart sk with (nolock) on 
        sk.kod = ins.Stkod and sk.tip = ins.stktip and ins.marsatid=@MarketSatisId
        /*and ins.sil=0  */
        and ins.marsatid=@MarketSatisId 
        and ins.id Not in (Select Id From Log_UrunHareket with (nolock) 
        where MarketSatisId=@MarketSatisId )
        
       
 
        
        
        
        
        
        
        
        
END

================================================================================
