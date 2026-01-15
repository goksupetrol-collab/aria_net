-- Stored Procedure: dbo.SpLog_Fatura
-- Tarih: 2026-01-14 20:06:08.373411
================================================================================

CREATE PROCEDURE dbo.SpLog_Fatura(@FaturaId int)
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
     update Log_Fatura Set Sil=dt.Sil,TransferStartId=TransferStartId+1,
     SyncStatus=1
     from  Log_Fatura as t join 
     (Select ins.id,ins.Sil FROM Faturamas  AS ins with (nolock)
     join Genel_Cari_Kart c with (nolock)
     on c.kod = ins.carkod and c.cartip=ins.cartip
     where ins.id=@FaturaId 
      and ins.id in (Select Id From Log_Fatura where Id=@FaturaId )) dt on dt.id=t.Id





	    INSERT INTO Log_Fatura
		(
			Id,
			Aciklama
			/*,YOK! */
			,AkaryakitIskontoTutar
			,AkaryakitIskontoYuzde
			,AkaryakitMatrah
			/*,YOK! */
			,BayiId
			,KartId
			/*,YOK! */
			/*,YOK! */
			,KartTipId
			/*,<KarsiKartId, int,> */
			/*,<KarsiKartTipId, int,> */
			/*,<KartId, int,> */
			/*,YOK! */
			,DegistirmeTarihSaat
			/*,<DegistirmeKullaniciId, int,> */
			/*,<DegistirmeKullaniciTipId, int,> */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			,EFaturaNo
			,EFaturaAktarimTarih
			,EFaturaId
			,EFaturaTipId
			/*,YOK!  */
			/*,YOK!  */
			,EntegreAktarimTarih
			/*,<EntegreId, int,> */
			/*,EntegreTipId */
			/*,FaturaAd */
			/*,YOK! */
			,FaturaNo
			/*,YOK! */
			,FaturaSeri
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			,FaturaAd
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			,GenelIskontoTutar
			/*,YOK! */
			,ToplamNetTutar
			/*,<GenelTipId, int,> */
			,ToplamGenelTutar
			/*,YOK! */
			,GenelIskontoYuzde
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,<ToplamIskontoTutar, float,> */
			/*,<ToplamAraTutar, float,> */
			,GiderKdvToplam
			,GiderToplam
			,GenelMatrah
			/*,<HareketCariYaz, bit,> */
			/*,<HareketStokYaz, bit,> */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			,IslemKur
			/*,<IslemParaBirimId, int,> */
			/*,<IslemTipId, int,> */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			/*,<KapTipId, int,> */
			,KarsiKartId
			,KarsiKartTipId
			,KartKur
			/*,<KartParaBirimId, int,> */
			/*,<KayitDurum, bit,> */
			,KdvOran1
			,KdvOran2
			,KdvOran3
			,KdvOran4
			,KdvOran5
			/*,<KdvTipId, int,> */
			,ToplamKdvTutar
			,KdvTutar1
			,KdvTutar2
			,KdvTutar3
			,KdvTutar4
			,KdvTutar5
			,Kilit
			,Kur
			/*,YOK! */
			/*,YOK! */
			,MarketIskontoTutar
			,MarketIskontoYuzde
			,MarketMatrah
			,Odeme
			,OdemeToplam
			,OlusturmaTarihSaat
			/*,<OlusturmaKullaniciId, int,> */
			/*,<OlusturmaKullaniciTipId, int,> */
			,OtvToplam
			/*,<ParaBirimId, int,> */
			/*,YOK! */
			,Plaka
			/*,YOK! */
			/*,<RaporId, int,> */
			,RemoteId
			/*,YOK! */
			/*,YOK! */
			/*,<Sil, bit,> */
			/*,<SilKullaniciId, int,> */
			/*,<SilKullaniciTipId, int,> */
			/*,<SilTarihSaat, datetime,> */
			/*,YOK! */
			,TarihSaat
			,VadeTarih
			/*,YOK! */
			/*,<VardiyaId, int,> */
			/*,YOK! */
			/*,YOK! */
			/*,YOK! */
			,YazarKasaFisno
			,YuvarlamaTutar
			/*,<TransferStartId, int,> */
			/*,<TransferStopId, int,> */
			/*,<TransferTarihSaat, datetime,> */
			,VergiNumarasi
			,GenelTipId
			,IslemTipId
		)
	  SELECT  
		
	  
			ins.id
			,ins.ack                                              AS Aciklama
			/*,ins.ak_isk_tip, tinyint,                             YOK! */
			,ins.ak_isk_top                                      AS AkaryakitIskontoTutar
			,ins.ak_isk_yuz                                      AS AkaryakitIskontoYuzde
			,ins.ak_matrah                                       AS AkaryakitMatrah
			/*,ins.AvansTakip, bit,                                 YOK! */
			,@BayiId										     AS BayiId
			,ins.car_id                                          AS KartId
			/*,ins.carkod, varchar(20),                             YOK! */
			/*,ins.cartip, varchar(20),                             YOK! */
			,ins.cartip_id                                       AS KartTipId
			/*,!YOK												 AS <KarsiKartId, int,> */
			/*,!YOK												 AS <KarsiKartTipId, int,> */
			/*,!YOK												 AS <KartId, int,> */
			/*,ins.dataok, int,                                     YOK! */
			,ins.degtarsaat                                      AS DegistirmeTarihSaat
			/*,ins.deguser, varchar(50),    <Tip Uyumsuz>        AS <DegistirmeKullaniciId, int,> */
			/*,!YOK												 AS <DegistirmeKullaniciTipId, int,> */
			/*,ins.Dep_Dag, bit,                                    YOK! */
			/*,ins.depo, varchar(20),                               YOK! */
			/*,ins.EFatura, bit,                                    YOK! */
			,CASE ins.EFatura    
				WHEN 1 THEN ins.fatno   
				WHEN 0 THEN NULL                                
			 END												 AS EFaturaNo
			,ins.Efatura_Aktar                                   AS EFaturaAktarimTarih
			,ins.EFatura_Id                                      AS EFaturaId
			,ins.EFatura_Tip                                     AS EFaturaTipId
			/*,ins.EFaturaEFinansBelgeOId, varchar(100),			YOK! */
			/*,ins.Entegre, bit,                                    YOK! */
			,ins.entegre_aktar                                   AS EntegreAktarimTarih
			/*,!YOK												 AS <EntegreId, int,> */
			/*,ins.entegre_tip, varchar(10), <Tip Uyumsuz>       AS EntegreTipId, int */
			/*,ins.fatad, nvarchar(50),      <Tip Uyumsuz>       AS FaturaAd, varchar(100) */
			/*,ins.fatid, float,                                    YOK! */
			,ins.fatno                                           AS FaturaNo
			/*,ins.fatrap_id, int,                                  YOK! */
			,ins.fatseri                                         AS FaturaSeri
			/*,ins.fattip, varchar(20),                             YOK! */
			/*,ins.fattip_id, int,                                  YOK! */
			/*,ins.fattop, float,          <Satır Toplamı>          YOK! */
			/*,ins.fattur, varchar(10),    <Veri Boş>               YOK! */
			/*,ins.fattur_id, int,         <Veri Boş>               YOK! */
			,ins.fatturad                                        AS FaturaAd
			/*,ins.firmano, int,                                    YOK! */
			/*,ins.gctip, int,             <1 Geliyor>              YOK! */
			/*,ins.gen_ind_tip, tinyint,                            YOK! */
			/*,ins.genel_ara_top, float,                            YOK! */
			,ins.genel_isk_top                                   AS GenelIskontoTutar
			/*,ins.genel_kdv_top, float,                            YOK! */
			,ins.genel_net_top                                   AS ToplamNetTutar
			/*,!YOK												 AS <GenelTipId, int,> */
			,ins.genel_top                                       AS ToplamGenelTutar
			/*,ins.genisktop, float,                                YOK! */
			,ins.geniskyuz                                       AS GenelIskontoYuzde
			/*,ins.gg_isk_tip                                       YOK! */
			/*,ins.gg_isk_top, float,                               YOK! */
			/*,ins.gg_isk_yuz, float,                               YOK! */
			/*,ins.gg_matrah, float,                                YOK! */
			/*,!YOK												 AS <ToplamIskontoTutar, float,> */
			/*,!YOK												 AS <ToplamAraTutar, float,> */
			,ins.giderkdvtop                                     AS GiderKdvToplam
			,ins.gidertop                                        AS GiderToplam
			,ins.gn_matrah                                       AS GenelMatrah
			/*,!YOK												 AS <HareketCariYaz, bit,> */
			/*,!YOK												 AS <HareketStokYaz, bit,> */
			/*,ins.hrk_car_pro, bit,                                YOK! */
			/*,ins.Hrk_Karsi_Pro, bit,                              YOK! */
			/*,ins.hrk_stk_pro, bit,                                YOK! */
			,ins.Islem_Kur                                       AS IslemKur
			/*,ins.Islem_ParaBrm, varchar(20),   <Tip Uyumsuz>   AS <IslemParaBirimId, int,> */
			/*,!YOK												 AS <IslemTipId, int,> */
			/*,ins.irs_no, varchar(100),                            YOK! */
			/*,ins.irsaliyeirid, float,                             YOK! */
			/*,ins.isk_tip, tinyint,                                YOK! */
			/*,ins.kapidler, varchar(8000),                         YOK! */
			/*,ins.kaptip, varchar(5),           <Tip Uyumsuz>   AS <KapTipId, int,> */
			,ins.Karsi_Car_id                                    AS KarsiKartId
			,ins.Karsi_Cartip_id                                 AS KarsiKartTipId
			,ins.Kart_Kur                                        AS KartKur
			/*,ins.Kart_ParaBrm, varchar(20),    <Tip Uyumsuz>   AS <KartParaBirimId, int,> */
			/*,ins.kayok, int,                   <Tip Uyumsuz>   AS <KayitDurum, bit,> */
			,ins.KdvOran1                                        AS KdvOran1
			,ins.KdvOran2                                        AS KdvOran2
			,ins.KdvOran3                                        AS KdvOran3
			,ins.KdvOran4                                        AS KdvOran4
			,ins.KdvOran5                                        AS KdvOran5
			/*,ins.kdvtip, varchar(10),          <Tip Uyumsuz>   AS <KdvTipId, int,> */
			,ins.kdvtop                                          AS ToplamKdvTutar
			,ins.KdvTutar1                                       AS KdvTutar1
			,ins.KdvTutar2                                       AS KdvTutar2
			,ins.KdvTutar3                                       AS KdvTutar3
			,ins.KdvTutar4                                       AS KdvTutar4
			,ins.KdvTutar5                                       AS KdvTutar5
			,ins.kilit                                           AS Kilit
			,ins.kur                                             AS Kur
			/*,ins.marsatid, float,                                 YOK! */
			/*,ins.mr_isk_tip, tinyint,                             YOK! */
			,ins.mr_isk_top                                      AS MarketIskontoTutar
			,ins.mr_isk_yuz                                      AS MarketIskontoYuzde
			,ins.mr_matrah                                       AS MarketMatrah
			,ins.Odeme                                           AS Odeme
			,ins.odemetop                                        AS OdemeToplam
			,ins.olustarsaat                                     AS OlusturmaTarihSaat
			/*,ins.olususer, varchar(50),       <Tip Uyumsuz>    AS <OlusturmaKullaniciId, int,> */
			/*,!YOK												 AS <OlusturmaKullaniciTipId, int,> */
			,ins.otvtop                                          AS OtvToplam
			/*,ins.parabrm, varchar(10),        <Tip Uyumsuz>    AS <ParaBirimId, int,> */
			/*,ins.Per_id, int,                                     YOK! */
			,ins.plaka                                           AS Plaka
			/*,ins.prom_pro, bit,                                   YOK! */
			/*,!YOK												 AS <RaporId, int,> */
			,ins.remote_id												 AS RemoteId
			/*,ins.saat, varchar(8),                                YOK! */
			/*,ins.satisktop, float,                                YOK! */
			/*,ins.sil, int,                    <Tip Uyumsuz>    AS <Sil, bit,> */
			/*,!YOK												 AS <SilKullaniciId, int,> */
			/*,!YOK												 AS <SilKullaniciTipId, int,> */
			/*,!YOK												 AS <SilTarihSaat, datetime,> */
			/*,ins.siparissipid, float,                             YOK! */
			,ins.tarih                                           AS TarihSaat
			,ins.vadtar                                          AS VadeTarih
			/*,ins.Varno, float,                                    YOK! */
			/*,!YOK												 AS <VardiyaId, int,> */
			/*,ins.yazildi, bit,                                    YOK! */
			/*,ins.yerad, varchar(30),                              YOK! */
			/*,ins.yertip, varchar(20),                             YOK! */
			,ins.ykfisno                                         AS YazarKasaFisno
			,ins.yuvtop                                          AS YuvarlamaTutar
			/*,!YOK												 AS <TransferStartId, int,> */
			/*,!YOK												 AS <TransferStopId, int,> */
			/*,!YOK												 AS <TransferTarihSaat, datetime,> */
			,c.vergino,
			(Case when ins.fattip='FATMRALS' then 11 
			when ins.fattip='FATIADALS' then 13 end)  as GenelTipId,
			(Case when ins.fattip='FATMRALS' then 2 
			when ins.fattip='FATIADALS' then 7 end) as IslemTipId

		FROM Faturamas  AS ins with (nolock)
        join Genel_Cari_Kart c with (nolock)
        on c.kod = ins.carkod and c.cartip=ins.cartip
        where ins.id=@FaturaId and  ins.kayok=1
        and ins.id not in ( Select Id From Log_Fatura Wtih (nolock) )
        
        
      
          /*delete  Silme update */
         update Log_Fatura Set Sil=1,TransferStartId=TransferStartId+1,
         SyncStatus=1 from Log_Fatura as ins  
         where ins.Id=@FaturaId and ins.Id not in (Select id From faturamas with (nolock)
         Where id=@FaturaId)  
      
        


END

================================================================================
