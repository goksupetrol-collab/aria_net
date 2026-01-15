-- Stored Procedure: dbo.Muh_Param_Olustur
-- Tarih: 2026-01-14 20:06:08.348986
================================================================================

CREATE PROCEDURE [dbo].Muh_Param_Olustur(@firmano int)
AS
BEGIN

 TRUNCATE table entegre_muh_hes_kod



 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'als_kdv','alis_kdv_1','İNDİRİLECEK KDV %1',1,'191.01','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'als_kdv','alis_kdv_8','İNDİRİLECEK KDV %8',8,'191.02','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'als_kdv','alis_kdv_18','İNDİRİLECEK KDV %18',18,'191.03','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'als_kdv','alis_kdv_26','İNDİRİLECEK KDV %26',26,'191.04','SİSTEM',getdate())
 
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'sat_kdv','satis_kdv_1','HESAPLANAN KDV %1',1,'391.01','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'sat_kdv','satis_kdv_8','HESAPLANAN KDV %8',8,'391.02','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'sat_kdv','satis_kdv_18','HESAPLANAN KDV %18',18,'391.03','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'sat_kdv','satis_kdv_26','HESAPLANAN KDV %26',26,'391.04','SİSTEM',getdate())
 
/* */
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'alsia_kdv','alis_iade_kdv_1','ALIŞ İADE KDV %1',1,'391.05','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'alsia_kdv','alis_iade_kdv_8','ALIŞ İADE KDV %8',8,'391.06','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'alsia_kdv','alis_iade_kdv_18','ALIŞ İADE KDV %18',18,'391.06','SİSTEM',getdate())
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'alsia_kdv','alis_iade_kdv_26','ALIŞ İADE KDV %26',26,'391.07','SİSTEM',getdate())
  
  insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'satia_kdv','satis_iade_kdv_1','SATIŞ İADE KDV %1',1,'191.05','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'satia_kdv','satis_iade_kdv_8','SATIŞ İADE KDV %8',8,'191.06','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'satia_kdv','satis_iade_kdv_18','SATIŞ İADE KDV %18',18,'191.07','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'satia_kdv','satis_iade_kdv_26','SATIŞ İADE KDV %26',26,'191.08','SİSTEM',getdate())
 
 
 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'yuv_gelir','yuv_gelir','YUVARLAMA GELİR HESABI',0,'679.01','SİSTEM',getdate())

 insert into entegre_muh_hes_kod
 (firmano,tip,kod,ack,kdv_oran,deger,deguser,degtarsaat)
 values (@firmano,'yuv_gider','yuv_gider','YUVARLAMA GİDER HESABI',0,'689.01','SİSTEM',getdate())
 
 


/*
INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (1, 7, 'als_kdv', 'alis_kdv_1', 'İNDİRİLECEK KDV %1', '191.01', 1, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:44.877', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (2, 7, 'als_kdv', 'alis_kdv_8', 'İNDİRİLECEK KDV %8', '191.02', 8, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:48.267', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (3, 7, 'als_kdv', 'alis_kdv_18', 'İNDİRİLECEK KDV %18', '191.03', 18, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:52.687', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (4, 7, 'als_kdv', 'alis_kdv_26', 'İNDİRİLECEK KDV %26', '191.04', 26, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:55.077', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (5, 7, 'sat_kdv', 'satis_kdv_1', 'HESAPLANAN KDV %1', '391.01', 1, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:56.420', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (6, 7, 'sat_kdv', 'satis_kdv_8', 'HESAPLANAN KDV %8', '391.02', 8, 'SİSTEM YÖNETİCİSİ', '20090401 18:24:58.983', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (7, 7, 'sat_kdv', 'satis_kdv_18', 'HESAPLANAN KDV %18', '391.03', 18, 'SİSTEM YÖNETİCİSİ', '20090401 18:25:02.170', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (8, 7, 'sat_kdv', 'satis_kdv_26', 'HESAPLANAN KDV %26', '391.04', 26, 'SİSTEM YÖNETİCİSİ', '20090401 18:25:04.530', '', 'SİSTEM', '20090313 11:28:55.840')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (11, 7, 'alsia_kdv', 'alis_iade_kdv_1', 'ALIŞ İADE KDV %1', '391.50', 1, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:18.843', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (12, 7, 'alsia_kdv', 'alis_iade_kdv_8', 'ALIŞ İADE KDV %8', '391.50', 8, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:22.077', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (13, 7, 'alsia_kdv', 'alis_iade_kdv_18', 'ALIŞ İADE KDV %18', '391.50', 18, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:22.843', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (14, 7, 'alsia_kdv', 'alis_iade_kdv_26', 'ALIŞ İADE KDV %26', '391.50', 26, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:23.907', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (15, 7, 'satia_kdv', 'satis_iade_kdv_1', 'SATIŞ İADE KDV %1', '191.50', 1, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:01.610', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (16, 7, 'satia_kdv', 'satis_iade_kdv_8', 'SATIŞ İADE KDV %8', '191.50', 8, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:03.390', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (17, 7, 'satia_kdv', 'satis_iade_kdv_18', 'SATIŞ İADE KDV %18', '191.50', 18, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:05.110', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (18, 7, 'satia_kdv', 'satis_iade_kdv_26', 'SATIŞ İADE KDV %26', '191.50', 26, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:06.703', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (19, 7, 'yuv_gelir', 'yuv_gelir', 'YUVARLAMA GELİR HESABI', '679.01', 0, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:49.577', '', 'SİSTEM', '20090313 11:28:55')
GO

INSERT INTO [dbo].[entegre_muh_hes_kod] ([id], [firmano], [tip], [kod], [ack], [deger], [kdv_oran], [deguser], [degtarsaat], [parabrm], [olususer], [olustarsaat])
VALUES 
  (20, 7, 'yuv_gider', 'yuv_gider', 'YUVARLAMA GİDER HESABI', '689.01', 0, 'SİSTEM YÖNETİCİSİ', '20090407 09:44:53.313', '', 'SİSTEM', '20090313 11:28:55')
GO

  */
  
END

================================================================================
