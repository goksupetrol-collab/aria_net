-- View: dbo.view_cari_hrk_fis_Isk_listesi
-- Tarih: 2026-01-14 20:06:08.488741
================================================================================

CREATE VIEW [dbo].[view_cari_hrk_fis_Isk_listesi] AS
CREATE VIEW view_cari_hrk_fis_Isk_listesi
AS
    select h.tarih,h.saat,MONTH(h.tarih) ay,YEAR(h.tarih) yil,
    h.carkod,vc.ad as unvan,h.cartip,
    ROUND(h.borc,sis.Para_Ondalik) borc,
    ROUND(h.alacak,sis.Para_Ondalik) alacak,
    0 as fisbakiye,h.kur,h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
    ('BK') aktip
    from carihrk as h  with (nolock)
    inner join Genel_Kart 
    as vc on vc.cartp=h.cartip and vc.kod=h.carkod and h.sil=0
    left join sistemtanim sis on 1=1
    union all
    select v.tarih,v.saat,MONTH(v.tarih) ay,YEAR(v.tarih) yil,
    v.carkod,vc.ad as unvan,v.cartip,0 borc,0 alacak,   
    ROUND(  ISNULL(SUM(
    CASE 
     WHEN v.fistip='FISVERSAT' THEN  
    (h.brmfiy*(1-(h.Fat_IskYuz/100)))*h.mik 
     WHEN v.fistip='FISALCSAT' THEN
     -1*((h.brmfiy*(1-(h.Fat_IskYuz/100)))*h.mik) 
     else 0 end ),0),sis.Para_Ondalik) as fisbakiye,    
    1 as kur,
    v.fistip as islmtip,v.fisad as islmtipad,'-' as islmhrk,'-'as islmhrkad,
    v.aktip
    from veresimas as v with (nolock)
    inner join veresihrk h with (nolock) on
    v.verid=h.verid and h.sil=0 and isnull(v.devir,0)=0 
    inner join Genel_Kart  as vc on 
    vc.cartp=v.cartip and vc.kod=v.carkod and v.sil=0
    left join sistemtanim sis  on 1=1
    group by v.tarih,v.saat,v.carkod,vc.ad,v.cartip,
    v.fistip,v.fisad,v.aktip,sis.Para_Ondalik

================================================================================
