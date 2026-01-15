-- Stored Procedure: dbo.Yetki_Evrak_Olustur
-- Tarih: 2026-01-14 20:06:08.392122
================================================================================

CREATE PROCEDURE  [dbo].Yetki_Evrak_Olustur @Tip varchar(30)
AS
BEGIN
  declare @frmid		int
  declare @bolumid		int
  
  declare @link_name  varchar(50)
  declare @kont  varchar(50)
  declare @modul varchar(10)
  
  /*if NOT ((@tip='FATURA') or (@tip='PROMOSYON')) */
  /* return */
  
  
  set @modul=''
  
  if @tip='FATURA'
  begin
   set  @link_name='FATURA_LINK'
   set @kont='mn_fatlist'
  end
  
  
  if @tip='PROMOSYON'
  begin
   set  @link_name='PROM_LINK'
   set @kont='mn_fisislem'
   set @modul='H'
  end
  
  
   
  select @frmid=id,@bolumid=bolumid from frm
  where [frm]=@link_name


  insert into frmkont 
  (firmano,bolumid,frmid,kont,kont_menu,konttr,yetkialan,rap_id,modul)
  select 0,@bolumid,@frmid,
  @kont,
  @kont+cast(r.id as varchar),
  r.ack,1,r.id,@modul
  from raporlar r 
   where r.rapgrp=@Tip and r.sil=0 and id not in  
  (select rap_id from frmkont where frmid=@frmid and rap_id>0 )
  
  
  update frmkont set konttr=dt.ack from frmkont as t 
  join (select r.id,r.ack from raporlar as r 
  where r.rapgrp=@Tip and r.sil=0 ) dt
  on t.Rap_id=dt.id
  
    
   
  delete from frmkont where 
  kont=@kont and rap_id 
  not in (select id from raporlar as r
  where r.rapgrp=@Tip and r.sil=0 )  
  


END

================================================================================
