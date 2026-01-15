-- View: dbo.view_hrklistesi
-- Tarih: 2026-01-14 20:06:08.490824
================================================================================

CREATE VIEW [dbo].[view_hrklistesi] AS
CREATE VIEW [dbo].view_hrklistesi
AS
  SELECT 'Kasa İşlemleri' as grp,'kasahrk' as grptip,('kashrkid') hrkidad,masterid,gctip,kashrkid as hrkid,varno,
  varok,kasahrk.sil,yerad,perkod,adaid,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,
  islmhrk,yertip,belno,kasahrk.id,kasahrk.kaskod as kod,carkod,cartip,car.tip as cartur,car.ad as unvan,
  (perkart.ad+' '+perkart.soyad) perad,(grup.ad) ada,kasahrk.giren,kasahrk.cikan,kur,
  kasahrk.kaskod as kaskod,kasakart.ad as kasad,('') as bankod,('') as bankad,ack,null as vadetar,kasahrk.parabrm,
  kasahrk.olustarsaat,kasahrk.olususer 
  from kasahrk with (nolock) left join Genel_Kart as car with (nolock) on kasahrk.carkod=car.kod and kasahrk.cartip=car.cartp
  left join perkart with (nolock) on perkart.kod=perkod left join grup with (nolock) on adaid=grup.id
  inner join kasakart with (nolock) on kasahrk.kaskod=kasakart.kod
  where kasahrk.masterid=0
  UNION ALL
  SELECT 'Pos İşlemleri' as grp,'poshrk' as grptip,('poshrkid') hrkidad,masterid,gctip,
  poshrkid as hrkid,varno,varok,poshrk.sil,yerad,perkod,adaid,tarih,saat,islmtipad as tipad,
  islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,poshrk.id,poshrk.poskod as kod,carkod,cartip,cartur,car.ad as unvan,
  (perkart.ad+' '+perkart.soyad) perad,(grup.ad) ada,poshrk.giren,poshrk.cikan,kur,('') as kaskod,('') as kasad,
  poshrk.bankod as bankod,bankakart.ad as bankad,ack,poshrk.vadetar as vadetar,
  poshrk.parabrm,poshrk.olustarsaat,poshrk.olususer from poshrk with (nolock) left join Genel_Kart as car  with (nolock)
  on poshrk.carkod=car.kod and poshrk.cartip=car.cartp
  left join perkart with (nolock) on perkart.kod=perkod left join grup with (nolock) on adaid=grup.id
  left join bankakart with (nolock) on bankakart.kod=poshrk.bankod
  where poshrk.masterid=0

================================================================================
