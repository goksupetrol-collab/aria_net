-- Stored Procedure: dbo.otomasondosya
-- Tarih: 2026-01-14 20:06:08.351422
================================================================================

CREATE PROCEDURE [dbo].otomasondosya @dosyad varchar(50),@tip varchar(30),@sil int
AS
BEGIN
  
  if @sil=0
  insert into otomasdosya (dosya,otomastip) values (@dosyad,@tip)
  if @sil=1
  delete from otomasdosya where dosya=@dosyad and otomastip=@tip
  
  
END

================================================================================
