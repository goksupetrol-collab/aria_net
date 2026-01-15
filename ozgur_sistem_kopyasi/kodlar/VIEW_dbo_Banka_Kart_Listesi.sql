-- View: dbo.Banka_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.467642
================================================================================

CREATE VIEW [dbo].[Banka_Kart_Listesi] AS
CREATE VIEW Banka_Kart_Listesi
AS
  select k.[id],k.firmano,k.[kod],k.[grp1],k.[grp2],k.[grp3],
  k.[ad],k.[muhkod],k.[muhonkod],k.cekmuhkod,k.[hesno],K.Iban,
  k.[parabrm],k.[ilgili],
  k.[tel],k.[drm],k.[fax],
  k.[borc],k.[alacak],k.[olususer],k.[olustarsaat],
  k.[degtarsaat],k.[deguser],k.[sil],k.[actutar],
  (g.ad) as grup,
  isnull(round((bak.borc),2),0) brc_bakiye,
  isnull(round((bak.alacak),2),0) alc_bakiye,
  (bak.borc-bak.alacak) top_bakiye from bankakart as k
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2 
  when k.grp1>0 then k.grp1 end
  inner join Bakiye_Banka as bak on bak.kod=k.kod

================================================================================
