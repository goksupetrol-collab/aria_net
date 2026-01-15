-- View: dbo._Cari_Teminat_Ilk
-- Tarih: 2026-01-14 20:06:08.459112
================================================================================

CREATE VIEW [dbo].[_Cari_Teminat_Ilk] AS
CREATE VIEW [dbo]._Cari_Teminat_Ilk
AS
 select t.kod,'carikart' as CarTip,t.tur,Tutar,ack From cariteminat as t 
 where t.id in (Select min(id) From cariteminat group by Kod)

================================================================================
