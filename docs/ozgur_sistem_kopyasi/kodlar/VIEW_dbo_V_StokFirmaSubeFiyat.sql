-- View: dbo.V_StokFirmaSubeFiyat
-- Tarih: 2026-01-14 20:06:08.487389
================================================================================

CREATE VIEW [dbo].[V_StokFirmaSubeFiyat] AS
CREATE VIEW dbo.V_StokFirmaSubeFiyat 
AS
 Select f.id as Firmano,k.id StkId,k.Kod StkKod,
 k.sat1kdv SatisFiyat1Kdv,
   isnull((Select case 
      when  KdvTip=1 then Fiyat 
      when  KdvTip=0 then Fiyat*(1+(Kdv/100)) end
        From Stok_Fiyat as sf with (nolock) 
      Where sf.Stk_id=k.id and sf.FirmaNo=f.id 
      and sf.FiyTip=2 and sf.FiyNo=1 ) ,0) SatisFiyat1KdvDahil,
   k.sat2kdv SatisFiyat2Kdv,     
   isnull((Select case 
      when  KdvTip=1 then Fiyat 
      when  KdvTip=0 then Fiyat*(1+(Kdv/100)) end
        From Stok_Fiyat as sf with (nolock) 
      Where sf.Stk_id=k.id and sf.FirmaNo=f.id 
      and sf.FiyTip=2 and sf.FiyNo=2 ),0) SatisFiyat2KdvDahil,
      
   k.sat3kdv SatisFiyat3Kdv,     
    isnull((Select case 
      when  KdvTip=1 then Fiyat 
      when  KdvTip=0 then Fiyat*(1+(Kdv/100)) end
        From Stok_Fiyat as sf with (nolock) 
      Where sf.Stk_id=k.id and sf.FirmaNo=f.id 
      and sf.FiyTip=2 and sf.FiyNo=3 ),0) SatisFiyat3KdvDahil,
      
    k.sat4kdv SatisFiyat4Kdv,  
      isnull( (Select case 
      when  KdvTip=1 then Fiyat 
      when  KdvTip=0 then Fiyat*(1+(Kdv/100)) end
        From Stok_Fiyat as sf with (nolock) 
      Where sf.Stk_id=k.id and sf.FirmaNo=f.id 
      and sf.FiyTip=2 and sf.FiyNo=4 ),0) SatisFiyat4KdvDahil,
      
    k.alskdv AlisFiyatKdv,   
      isnull((Select case 
      when  KdvTip=1 then Fiyat 
      when  KdvTip=0 then Fiyat*(1+(Kdv/100)) end
        From Stok_Fiyat as sf with (nolock) 
      Where sf.Stk_id=k.id and sf.FirmaNo=f.id 
      and sf.FiyTip=1 and sf.FiyNo=1 ),0) AlisFiyatKdvDahil

from stokkart as k with (nolock)
left join Firma as f  with (nolock) on 1=1
where k.sil=0

================================================================================
