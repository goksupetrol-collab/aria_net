-- Stored Procedure: dbo.SpLog_FaturaHareket
-- Tarih: 2026-01-14 20:06:08.373773
================================================================================

CREATE PROCEDURE dbo.SpLog_FaturaHareket(@FaturaId int)
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
     update Log_FaturaHareket Set Sil=dt.Sil,TransferStartId=TransferStartId+1,
     SyncStatus=1
     from  Log_FaturaHareket as t join 
     (Select ins.id,ins.Sil FROM faturahrk AS ins with (nolock) 
      inner join stokkart sk with (nolock) on sk.kod = ins.stkod 
      and sk.tip = ins.stktip  where ins.fatid=@FaturaId 
     and ins.id in (Select Id From Log_FaturaHareket where FaturaId=@FaturaId )) dt on dt.id=t.Id



	INSERT INTO Log_FaturaHareket
		(
			  Id
			  ,Aciklama
			  ,Barkod
			/*,[BirimId] [int] NULL, */
			  ,BayiId
			  ,BirimFiyat
			  ,Carpan
			  ,DegistirmeTarihSaat
			/*,[DegistirmeKullaniciId] [int] NULL, */
			/*,[DepoId] [int] NULL, */
			/*,[DepoTipId] [int] NULL, */
			  ,FaturaId
			  ,IslemKur
			/*,[IslemParaBirimId] [int] NULL, */
			  ,KartKur
			/*,[KartParaBirimId] [int] NULL, */
			/*,[KdvTipId] [int] NULL, */
			  ,KdvTutar
			  ,KdvYuzde
			  ,Kesafet
			  ,Kur
			  ,Miktar
			  ,OlusturmaTarihSaat
			/*,[OlusturmaKullaniciId] [int] NULL, */
			  ,OtvCarpan
			  ,OtvTutar
			  ,OtvYuzde
			/*,[ParaBirimId] [int] NULL, */
			  ,RemoteId
			  ,SatirIskontoTutar
			  ,SatirIskontoYuzde
			/*,[Sil] [bit] NULL, */
			  ,ToplamIskontoTutar
			  ,ToplamIskontoYuzde
			  ,ToplamKdvTutar
			  ,ToplamTutarIskontoluKdvli
			  ,ToplamTutarIskontoluKdvsiz
			  ,KartId
			  ,KartTipId
		)
	  SELECT 
				ins.id
			  ,ins.[ack]                                                          AS Aciklama
			/*,ins.[ak_isk_tut]                                                   AS  */
			/*,ins.[ak_isk_yuz]                                                   AS  */
			  ,ins.[barkod]                                                       AS Barkod
			  ,@BayiId															  AS BayiId
			/*,ins.[brim]                      <Tip Uyumsuz>                      AS [BirimId] [int] NULL, */
			  ,ins.[brmfiy]                                                       AS BirimFiyat
			  ,ins.[carpan]                                                       AS Carpan
			/*,ins.[dataok]                                                       AS  */
			  ,ins.[degtarsaat]                                                   AS DegistirmeTarihSaat
			/*,ins.[deguser]                   <Tip Uyumsuz>                      AS [DegistirmeKullaniciId] [int] NULL, */
			/*,ins.[dep_id]                    <Tip Uyumsuz>                      AS [DepoId] [int] NULL, */
			/*,ins.[depkod]                    <Tip Uyumsuz>                      AS [DepoTipId] [int] NULL, */
			  ,ins.[fatid]                                                        AS FaturaId
			/*,ins.[firmano]                                                      AS  */
			/*,ins.[genisktut]                                                    AS  */
			/*,ins.[geniskyuz]                                                    AS  */
			/*,ins.[gg_isk_tut]                                                   AS  */
			/*,ins.[gg_isk_yuz]                                                   AS  */
			/*,ins.[giderbrmtut]                                                  AS  */
			/*,ins.[grupid]                                                       AS  */
			/*,ins.[hrk_stk_pro]                                                  AS  */
			  ,ins.[Islem_Kur]                                                    AS IslemKur
			/*,ins.[Islem_ParaBrm]             <Tip Uyumsuz>                      AS [IslemParaBirimId] [int] NULL, */
			/*,ins.[kaphrkid]                                                     AS  */
			/*,ins.[kaptip]                                                       AS  */
			  ,ins.[Kart_Kur]                                                     AS KartKur
			/*,ins.[Kart_ParaBrm]              <Tip Uyumsuz>                      AS [KartParaBirimId] [int] NULL, */
			/*,ins.[kayok]                                                        AS  */
			/*,ins.[kdvtip]                    <Tip Uyumsuz>                      AS [KdvTipId] [int] NULL, */
			  ,ins.[kdvtut]                                                       AS KdvTutar
			  ,ins.[kdvyuz]*100                                                   AS KdvYuzde
			  ,ins.[kesafet]                                                      AS Kesafet
			  ,ins.[kur]                                                          AS Kur
			/*,ins.[masraf_tut]                                                   AS  */
			/*,ins.[masraf_yuz]                                                   AS  */
			  ,ins.[mik]                                                          AS Miktar
			/*,ins.[mr_isk_tut]                                                   AS  */
			/*,ins.[mr_isk_yuz]                                                   AS  */
			/*,ins.[Net_Miktar]                                                   AS  */
			  ,ins.[olustarsaat]                                                  AS OlusturmaTarihSaat
			/*,ins.[olususer]                   <Tip Uyumsuz>                     AS [OlusturmaKullaniciId] [int] NULL, */
			/*,ins.[OtoTag]                                                       AS  */
			  ,ins.[Otv_Carpan]                                                   AS OtvCarpan
			/*,ins.[otvbrim]                                                      AS  */
			  ,ins.[otvtut]                                                       AS OtvTutar
			  ,ins.[otvyuz]                                                       AS OtvYuzde
			/*,ins.[parabrim]                   <Tip Uyumsuz>                     AS [ParaBirimId] [int] NULL, */
			  ,ins.remote_id			                                                  AS RemoteId
			  ,ins.[satisktut]                                                    AS SatirIskontoTutar
			  ,ins.[satiskyuz]                                                    AS SatirIskontoYuzde
			/*,ins.[sil]                        <Tip Uyumsuz>                     AS [Sil] [bit] NULL, */
			
			/*,ins.[stkod]                                                        AS  */
			/*,ins.[stktip]                                                       AS  */
			/*,ins.[stktip_id]                                                    AS  */
			/*,ins.[Tesis_AlisFiyat]                                              AS  */
			/*,ins.[Tesis_Fiyat]                                                  AS  */
			/*,ins.[Tesis_id]                                                     AS  */
			/*,ins.[Tesis_PrimOran]                                               AS  */
			  ,ins.[top_isk_tut]                                                  AS ToplamIskontoTutar
			  ,ins.[top_isk_yuz]                                                  AS ToplamIskontoYuzde
			  ,ins.[top_kdv_tut]                                                  AS ToplamKdvTutar
			  ,ins.[top_tut_isk_kdvli]                                            AS ToplamTutarIskontoluKdvli
			  ,ins.[top_tut_isk_kdvsiz]                                           AS ToplamTutarIskontoluKdvsiz
			/*,ins.[top_tut_kdvsiz]                                               AS  */
			/*,ins.[ustbrim]                                                      AS  */
			/*,!YOK                                                               AS [DegistirmeKullaniciTipId] [int] NUL */
			/*,!YOK                                                               AS [KartId] [int] NULL, */
			/*,!YOK                                                               AS [KartTipId] [int] NULL, */
			/*,!YOK                                                               AS [SilKullaniciId] [int] NULL, */
			/*,!YOK                                                               AS [SilKullaniciTipId] [int] NULL, */
			/*,!YOK                                                               AS [SilTarihSaat] [datetime] NULL, */
			/*,!YOK                                                               AS [TransferStartId] [int] NULL, */
			/*,!YOK                                                               AS [TransferStopId] [int] NULL, */
			/*,!YOK                                                               AS [TransferTarihSaat] [datetime] NULL, */
			,sk.remote_id                                                         AS OpetUrunKartId
			,10
		 FROM faturahrk AS ins with (nolock) 
         inner join stokkart sk with (nolock) 
         on sk.kod = ins.stkod and sk.tip = ins.stktip  
         where ins.fatid=@FaturaId 
         and ins.id not in (Select Id From Log_FaturaHareket with (nolock) 
         Where FaturaId=@FaturaId )
         

     
        /*delete  Silme update */
         update Log_FaturaHareket Set Sil=1,TransferStartId=TransferStartId+1,
         SyncStatus=1 from Log_FaturaHareket as ins  
         where ins.FaturaId=@FaturaId and ins.Id not in (Select id From faturahrk with (nolock)
         Where Fatid=@FaturaId)  




END

================================================================================
