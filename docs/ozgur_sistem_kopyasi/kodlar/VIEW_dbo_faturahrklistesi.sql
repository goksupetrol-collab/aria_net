-- View: dbo.faturahrklistesi
-- Tarih: 2026-01-14 20:06:08.469627
================================================================================

CREATE VIEW [dbo].[faturahrklistesi] AS
CREATE VIEW [dbo].faturahrklistesi
AS
  SELECT id,fatid,'S' as satirtip,h.sil,firmano,stktip,stkod,mik,
  Micro_Stktip=case when stktip='gelgid' then 2 else 1 end,
  brmfiy,depkod,kdvyuz,kdvtut,
  isnull(h.kdvtevkifatyuzde,0) kdvtevkifatYuzde,
  isnull(h.KdvTevkifatTutar,0) kdvtevkifatTutar,
  isnull(kt.Kod,'') kdvtevkifatKod,
  isnull(kt.Ad,'') kdvtevkifatAck,
  kdvtip,brim,satiskyuz,satisktut,
  ak_isk_yuz,ak_isk_tut,mr_isk_yuz,mr_isk_tut,
  otvyuz,otvtut,otv_carpan,geniskyuz,genisktut,ustbrim,carpan,parabrim,otvbrim,grupid,
  kayok,kaphrkid,kaptip,giderbrmtut,
  Top_isk_Yuz,Top_isk_Tut from faturahrk as h with (nolock)
  left join KDVTevkifat_Tip as kt with (nolock) on kt.Id=h.KdvTevkifatId
  and kt.Sil=0 
  
  union
  SELECT id,fisfatid as fatid,'M' as satirtip,sil,firmano,'gelgid' as stktip,
  carkod as stkod,(1) as mik,
  Micro_Stktip=2,
  abs(alacak-borc)/(1+kdvyuz) as brmfiy,'' as depkod,kdvyuz,
  (abs(alacak-borc)/(1+kdvyuz))*kdvyuz as kdvtut,
  0 kdvtevkifatyuzde,0 kdvtevkifatTutar,
  '' kdvtevkifatKod,'' kdvtevkifatTutar,  
  ('Hariç') as kdvtip,'AD' AS brim,0 as satiskyuz,0 as satisktut,
  0 ak_isk_yuz, 0 ak_isk_tut,0 mr_isk_yuz,0 mr_isk_tut,
  0 as otvyuz,0 as otvtut,0 otv_carpan,
  0 as geniskyuz,0 as genisktut,'' as ustbrim,1 as carpan,parabrm,0 as otvbrim,0 as grupid,
  1 as kayok,(0) kaphrkid,'' as kaptip,0 as giderbrmtut,
  0 Top_isk_Yuz,0 Top_isk_Tut from carihrk with (nolock) where cartip='gelgidkart'
  and islmtip='FAT' AND islmhrk='GID'

================================================================================
