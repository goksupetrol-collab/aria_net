-- Stored Procedure: dbo.SpLog_FaturaUrunHareket
-- Tarih: 2026-01-14 20:06:08.374121
================================================================================

CREATE PROCEDURE dbo.SpLog_FaturaUrunHareket( 
@FaturaId int)
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
     update Log_UrunHareket Set Sil=dt.Sil,TransferStartId=TransferStartId+1,
     Giren=dt.Giren,Cikan=dt.Cikan,
     BirimFiyatNetKdvli=dt.brmfiykdvli,
     KdvYuzde=dt.KdvYuzde,
     SyncStatus=1
     from  Log_UrunHareket as t join 
     (Select ins.id,ins.Sil,ins.Giren,İns.Cikan,
     ins.brmfiykdvli,ins.kdvyuz*100 AS KdvYuzde 
     FROM stkhrk AS ins with (nolock) 
     inner join stokkart sk with (nolock) on 
     sk.kod = ins.Stkod and sk.tip = ins.stktip and ins.fatid=@FaturaId 
     /*and ins.sil=1 */
     and ins.id in (Select Id From Log_UrunHareket with (nolock)  
     where FaturaId=@FaturaId )) dt on dt.id=t.Id
  
   
   /*Insert İslemi */
    INSERT INTO [dbo].[Log_UrunHareket]
			   ([Id]
			   ,[KartTipId]
			   ,[StokKodu]
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
               ,[FaturaHareketId]
			   ,[IrsaliyeId]
			   ,[SayimId]
			   ,[KartId]
			   ,[RemoteId]
			   ,[DepoTransferId]
			   ,[DepoId]
			   ,[MarketSatisId]
			   ,[MarketSatisHareketId]
			   )
        SELECT
		 ins.id   AS Id
		,CASE ins.stktip 
			WHEN 'markt' THEN 10
			ELSE NULL
				/* markt değerinin [OpetBackOffice].[dbo].[KartTip] tarafında 10 */
				/* değerine denk geliyor */
				/* !! Tüm alabileceği değerler için WHEN koşulunu doldurmalı !! */
				/* > SELECT * FROM [OpetBackOffice].[dbo].[KartTip]							 */

	  								  
		END	AS KartTipId
		,ins.stkod  AS StokKodu
		,@BayiId	 AS BayiId
		,ins.varno   AS MarketVardiyaId
		,ins.sil  AS Sil
		,CASE ins.islmtip 
			WHEN 'MARSAT' THEN 9 
			WHEN 'MARIAD' THEN 10
			WHEN 'FATMRALS' THEN 2
			/* Diğer tüm durumlar için tekrar gözden geçirilmeli */
		 END AS IslemTipId
		,CONVERT(DATETIME, CONVERT(CHAR(8), ins.tarih, 112)+' '+CONVERT(CHAR(8), ins.saat)) AS TarihSaat
		,ins.giren  AS Giren
		,ins.cikan  AS Cikan
		,ins.brmfiykdvli  AS BirimFiyatNetKdvli
		,ins.kdvyuz*100 AS KdvYuzde
		,ins.otv    AS Otv
		,ins.belno   AS BelgeNo
		,ins.ack   AS Aciklama
		,(SELECT TOP 1 ins.id FROM users WHERE ad like ins.olususer)  AS OlusturmaKullaniciId
		,ins.olustarsaat  AS OlusturmaTarihSaat
		,(SELECT TOP 1 ins.id FROM users WHERE ad like ins.deguser)  AS DegistirmeKullaniciId
		,ins.degtarsaat   AS DegistirmeTarihSaat
		,ins.fatid    AS FaturaId
        ,ins.stkhrkid  AS FaturaHareketId
		,ins.irid    AS IrsaliyeId
		,ins.sayid AS SayimId
		,sk.Remote_id AS OpetUrunId
		,ins.remote_id  AS RemoteId
		,ins.DepTrsId    AS DepoTransferId
		,ins.DepoId  AS DepoId
		,ins.marsatid
		,0 hrkid
		FROM stkhrk AS ins with (nolock) 
        inner join stokkart sk with (nolock) on 
        sk.kod = ins.Stkod and sk.tip = ins.stktip 
        and ins.fatid=@FaturaId /*and ins.sil=0 */
        and ins.id Not in (Select Id From Log_UrunHareket with (nolock) 
        where FaturaId=@FaturaId )
        

        
        
        
        
        
        
END

================================================================================
