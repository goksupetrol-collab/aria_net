-- Trigger: dbo.StokKart_AU
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.032399
================================================================================

CREATE TRIGGER [dbo].[StokKart_AU] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN


    /* SET NOCOUNT ON Olunca SCOPE_IDENTITY() Deger Almiyor */

   
     if not EXISTS (SELECT [id] FROM [petromas_db]..[isletme] 
      where dataname=DB_NAME() and isnull(AktarimYapilacak,0)=1 )
      RETURN
     

     IF NOT EXISTS (SELECT * FROM [petromas_db].dbo.sysobjects WHERE name = N'BayiInfo' AND xtype='U' ) 
      RETURN
 
   

	DECLARE @BayiId INT
	SET @BayiId = (SELECT TOP 1 [BayiId] FROM [petromas_db]..[BayiInfo] ORDER BY BayiId DESC)
  
    if @BayiId is null
	 RETURN
	

	

	INSERT INTO [dbo].[Log_UrunFiyatHistory]
			    (
					 [Id]
					,[BayiId]
                    ,[KartTipId]
					,[KartId]
					,[Fiyat]
					,[Kdv]
					,[KdvTipId]
					,[ParaBirimId]
					,EskiFiyat
					,DegistirmeKullanici
                    ,DegistirmeTarihSaat
					,TransferStartId
					,TransferStopId
			    )
		 SELECT ins.id                                                                          
				,@BayiId
                ,case when ins.Tip='akykt' then 9 else 10 end  
				,ins.remote_id
				,ins.sat1fiy
				,ins.sat1kdv
				,(CASE WHEN ins.sat1kdvtip = 'Dahil' THEN 1 ELSE 2 END)
				,(CASE WHEN ins.sat1pbrm = 'TL' THEN 1 ELSE 2 END)		
                ,del.sat1fiy
				,ins.deguser
                ,getdate()
                ,1
                ,0
		   FROM inserted AS ins 
		   JOIN deleted del ON del.id = ins.id 
		  WHERE del.sat1fiy != ins.sat1fiy and ins.sat1fiy<>0
END

================================================================================
