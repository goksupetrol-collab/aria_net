-- Stored Procedure: dbo.vardirapicerik
-- Tarih: 2026-01-14 20:06:08.386611
================================================================================

CREATE PROCEDURE [dbo].vardirapicerik
AS
BEGIN
  TRUNCATE table marvardirapgoster
  TRUNCATE table pomvardirapgoster
  
  
INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (1, 'Emtia Satış', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (2, 'Dövizli Satış', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (3, 'Kdv Toplam', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (4, 'Satış / İade Dökümü', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (5, 'Cari Tahsilat / Ödemeler', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (6, 'Personel Tahsilat / Ödemeler', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (7, 'Gelir / Gider Tahsilat / Ödemeler', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (8, 'Genel Tahsilat / Ödemeler', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (9, 'Açık Fazla Dağılımı', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (10, 'Veresiye Fiş Dökümü', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES  (11, 'Banka Dökümü', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (12, 'Çek / Senet Dökümü', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (13, 'Pos Dökümü', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (14, 'Nakit Teslimat', 1)

INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (15, 'Vardiya Genel Toplam', 1)


INSERT INTO [dbo].[marvardirapgoster] ([id], [Ad], [Goster])
VALUES (16, 'Hizmet Satış', 1)

/*-pomvardiya */

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (1, 'Stok Miktarı', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (2, 'Sayaclara Göre', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (3, 'Nakit Teslimat', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (4, 'Cari Tahislat - Ödemeleri', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (5, 'Cari Veresiye', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (6, 'Pos Dökümü', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (7, 'Pos Grup Toplam', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (8, 'Personel', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (9, 'Emtia Satış', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (10, 'Akaryakıt Satış', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (11, 'Tanklara Gore  Stok', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (12, 'Vardiya Genel Toplam', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (13, 'Tahsilatlar', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (14, 'Ödemeler', 1)

INSERT INTO [dbo].[pomvardirapgoster] ([id], [Ad], [Goster])
VALUES (15, 'Cari Veresiye Grup Toplam', 1)

  
END

================================================================================
