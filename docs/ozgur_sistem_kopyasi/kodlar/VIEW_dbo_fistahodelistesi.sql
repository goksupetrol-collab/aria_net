-- View: dbo.fistahodelistesi
-- Tarih: 2026-01-14 20:06:08.470506
================================================================================

CREATE VIEW [dbo].[fistahodelistesi] AS
CREATE VIEW [dbo].fistahodelistesi
AS
  SELECT 'Kasa' as grp,'kasahrk' as grptip,('kasahrkid') hrkidad,fisid,kashrkid as hrkid,varno,varok,
  kasahrk.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,kasahrk.id,
  tutar=case when kasahrk.giren>0 then kasahrk.giren else kasahrk.cikan end,kur,kasahrk.kaskod as odetipkod,
  kasakart.ad as odetipad,ack,null as vadetar,
  kasahrk.parabrm,kasahrk.olustarsaat,kasahrk.olususer from kasahrk  with (nolock)
  inner join kasakart with (nolock) on kasahrk.kaskod=kasakart.kod and kasahrk.fisid>0 where kasahrk.sil=0

  UNION
  SELECT 'Pos' as grp,'poshrk' as grptip,('poshrkid') hrkidad,fisid,poshrkid as hrkid,varno,varok,
  poshrk.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,poshrk.id,
  tutar=case when poshrk.giren>0 then poshrk.giren else poshrk.cikan end,kur,poshrk.poskod as odetipkod,poskart.ad as odetipad,ack,poshrk.vadetar as vadetar,
  poshrk.parabrm,poshrk.olustarsaat,poshrk.olususer from poshrk with (nolock)
  inner join  poskart with (nolock) on poskart.kod=poshrk.poskod and poshrk.fisid>0 where poshrk.sil=0

  UNION
  SELECT 'Çek-Senet' as grp,'cekkart' as grptip,('cekid') hrkidad,fisid,cekid as hrkid,varno,varok,
  cekkart.sil,yerad,tarih,saat,islmtipad,islmhrkad,cekkart.islmtip as islmtip,cekkart.islmhrk as islmhrk,yertip,ceksenno as belno,cekkart.id,
  tutar=case when giren>0 then giren else cikan end,kur,cekkart.refno as odetipkod,
  islmhrkad odetipad,ack,cekkart.vadetar as vadetar,cekkart.parabrm,cekkart.olustarsaat,cekkart.olususer
  from cekkart with (nolock) where cekkart.sil=0 and cekkart.fisid>0

  UNION
  SELECT 'Banka' as grp,'bankahrk' as grptip,('bankahrkid') hrkidad,fisid,bankhrkid as hrkid,varno,varok,
  bankahrk.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,bankahrk.id,
  tutar=case when bankahrk.borc>0 then bankahrk.borc else bankahrk.alacak end,kur,bankahrk.bankod as odetipkod,bankakart.ad as odetipad,ack,null as vadetar,
  bankahrk.parabrm,bankahrk.olustarsaat,bankahrk.olususer from bankahrk with (nolock)
  inner join bankakart with (nolock) on bankakart.kod=bankahrk.bankod and bankahrk.fisid>0 where bankahrk.sil=0

================================================================================
