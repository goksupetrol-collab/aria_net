-- Trigger: dbo.stokkart_tru
-- Tablo: dbo.stokkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.034704
================================================================================

CREATE TRIGGER [dbo].[stokkart_tru] ON [dbo].[stokkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
DECLARE @id float
declare @sil int
declare @tip varchar(10)
declare @kod varchar(30)
declare @deguser varchar(100)
declare @degtarsaat datetime


 select @id=id,@sil=sil,@tip=tip,@kod=kod,
 @deguser=deguser,@degtarsaat=degtarsaat
  from inserted

 if @sil=1
  update barkod set Sil=1,
  deguser=@deguser,
  degtarsaat=@degtarsaat  
  where tip=@tip and kod=@kod;
   /*delete from barkod where tip=@tip and kod=@kod; */



 if UPDATE(sat1fiy) or UPDATE(sat1kdv)
 OR UPDATE(sat1kdvtip) or UPDATE(alsfiy)
  begin
  
  
  insert into stokfiyathistory (kaytip,firmano,kod,tip,
  sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
  sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
  sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
  sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
  alsfiy,alskdv,alskdvtip,alspbrm,
  olususer,olustarsaat)
  select 'DUZ',firmano,kod,tip,
  sat1fiy,sat1kdv,sat1kdvtip,sat1pbrm,
  sat2fiy,sat2kdv,sat2kdvtip,sat2pbrm,
  sat3fiy,sat3kdv,sat3kdvtip,sat3pbrm,
  sat4fiy,sat4kdv,sat4kdvtip,sat4pbrm,
  alsfiy,alskdv,alskdvtip,alspbrm,
  deguser,degtarsaat from inserted
  end


/*exec stokfiyhistory @id; */

 

END

================================================================================
