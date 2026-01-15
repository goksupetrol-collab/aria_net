-- Trigger: dbo.stokkart_tri
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.034329
================================================================================

CREATE TRIGGER [dbo].[stokkart_tri] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @tip      varchar(10)
declare @kod      varchar(20)
DECLARE @id       float;



select @id=id,@tip=tip,@kod=kod from inserted;

exec stokkartacilis @tip,'',@kod

 if @tip='akykt'
  EXEC numara_no_yaz 'akyktstkkart',@kod

 if @tip='markt'
  EXEC numara_no_yaz 'marktstkkart',@kod


  insert into stokfiyathistory (kaytip,firmano,kod,tip,
  sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
  sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
  sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
  sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
  alsfiy,alskdv,alskdvtip,alspbrm,
  olususer,olustarsaat)
  select 'KAY',firmano,kod,tip,
  sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
  sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
  sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
  sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
  alsfiy,alskdv,alskdvtip,alspbrm,
  olususer,olustarsaat from inserted
  


END

================================================================================
