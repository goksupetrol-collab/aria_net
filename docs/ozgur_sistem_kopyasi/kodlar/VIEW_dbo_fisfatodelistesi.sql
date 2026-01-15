-- View: dbo.fisfatodelistesi
-- Tarih: 2026-01-14 20:06:08.470107
================================================================================

CREATE VIEW [dbo].[fisfatodelistesi] AS
CREATE VIEW [dbo].fisfatodelistesi
AS
  SELECT 'Kasa' as grp,'kasahrk' as grptip,('fisfatid') hrkidad,fisfatid,fisfattip,kashrkid as hrkid,varno,varok,K.ad as aciklama,
  h.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,h.id,
  tutar=case when h.giren>0 then h.giren else h.cikan end,kur,h.kaskod as odetipkod,K.ad as odetipad,ack,null as vadetar,
  h.parabrm,h.olustarsaat,h.olususer from kasahrk as h with (nolock) 
  inner join kasakart as k with (nolock)  on h.kaskod=k.kod
  where h.sil=0 and h.islmtip in ('TAH','ODE')
  and h.fisfatid>0

  UNION
  SELECT 'Pos' as grp,'poshrk' as grptip,('fisfatid') hrkidad,fisfatid,fisfattip,poshrkid as hrkid,varno,varok,k.ad as aciklama,
  h.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,h.id,
  tutar=case when h.giren>0 then h.giren else h.cikan end,kur,h.poskod as odetipkod,k.ad as odetipad,ack,h.vadetar as vadetar,
  h.parabrm,h.olustarsaat,h.olususer from poshrk as h with (nolock) 
  inner join  poskart as k with (nolock)  on k.kod=h.poskod where h.sil=0
  and h.fisfatid>0

  UNION
  SELECT 'Çek-Senet' as grp,'cekkart' as grptip,('fisfatid') hrkidad,fisfatid,fisfattip,cekid as hrkid,varno,varok,convert(varchar,k.vadetar,103) aciklama,
  k.sil,yerad,tarih,saat,islmtipad,islmhrkad,k.islmtip as islmtip,k.islmhrk as islmhrk,yertip,ceksenno as belno,k.id,
  tutar=case when giren>0 then giren else cikan end,kur,k.refno as odetipkod,islmhrkad odetipad,ack,k.vadetar as vadetar,
  k.parabrm,k.olustarsaat,k.olususer  from cekkart as k where k.sil=0
  and k.fisfatid>0

  UNION
  SELECT 'Banka' as grp,'bankahrk' as grptip,('fisfatid') hrkidad,fisfatid,fisfattip,bankhrkid as hrkid,varno,varok,k.ad as aciklama,
  h.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,h.id,
  tutar=case when h.borc>0 then h.borc else h.alacak end,kur,h.bankod as odetipkod,k.ad as odetipad,ack,null as vadetar,
  h.parabrm,h.olustarsaat,h.olususer from bankahrk as h with (nolock) 
  inner join bankakart as k with (nolock)  on k.kod=h.bankod where
  h.sil=0 and h.islmhrk in ('B-C','C-B') and h.fisfatid>0

  UNION
  SELECT 'İşletme Kart İşlemleri' as grp,'istkhrk' as grptip,('fisfatid') hrkidad,fisfatid,fisfattip,istkhrkid as hrkid,varno,varok,k.ad as aciklama,
  h.sil,yerad,tarih,saat,islmtipad as tipad,islmhrkad as hrkad,islmtip,islmhrk,yertip,belno,h.id,
  tutar=case when h.borc>0 then h.borc else h.alacak end,kur,h.istkkod as odetipkod,k.ad as odetipad,ack,vadetar,
  h.parabrm,h.olustarsaat,h.olususer from istkhrk as h
  inner join istkart as k with (nolock)  on h.istkkod=k.kod where
  h.sil=0 and h.fisfatid>0

================================================================================
