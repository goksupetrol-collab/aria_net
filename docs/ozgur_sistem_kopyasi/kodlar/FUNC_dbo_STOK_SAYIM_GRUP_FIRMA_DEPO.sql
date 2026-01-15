-- Function: dbo.STOK_SAYIM_GRUP_FIRMA_DEPO
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.677042
================================================================================

CREATE FUNCTION [dbo].[STOK_SAYIM_GRUP_FIRMA_DEPO] (
@sayid       int,
@stkgrp1id   int,
@stkgrp2id   int,
@stkgrp3id   int,
@depokod    varchar(30),
@tarih      datetime)
RETURNS
  @TB_STOK_SAYIM_GRUP_DEPO TABLE (
    FIRMANO            INT,
    DEP_KOD             VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_ID             INT,
    STOK_TIP            VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD            VARCHAR(30) COLLATE Turkish_CI_AS,
    MIKTAR              FLOAT,
    ORT_BRMFIY_D        FLOAT,
    ORT_BRMFIY_H        FLOAT,
    SAT1_BRMFIY_D       FLOAT,
    SAT1_BRMFIY_H       FLOAT,
    SAT2_BRMFIY_D       FLOAT,
    SAT2_BRMFIY_H       FLOAT,
    ALS_BRMFIY_D        FLOAT,
    ALS_BRMFIY_H        FLOAT,
    SAT1_KDV_YUZ        FLOAT,
    SAT2_KDV_YUZ        FLOAT,
    ALS_KDV_YUZ         FLOAT
    )
AS
BEGIN

   declare @Market_Sube  int
   Declare @Firmano int
   select @Firmano=firmano from sayimmas with (nolock)
   where id=@sayid
   
   Select @Market_Sube=Market_Sube  from sistemtanim
   
 if @Firmano>0 
  begin
    insert into @TB_STOK_SAYIM_GRUP_DEPO
    (FIRMANO,DEP_KOD,STOK_ID,STOK_TIP,STOK_KOD,MIKTAR,
    ORT_BRMFIY_D,ORT_BRMFIY_H,SAT1_BRMFIY_D,SAT1_BRMFIY_H,
    SAT2_BRMFIY_D,SAT2_BRMFIY_H,ALS_BRMFIY_D,ALS_BRMFIY_H,
    SAT1_KDV_YUZ,SAT2_KDV_YUZ,ALS_KDV_YUZ)
    select @Firmano,@depokod,k.id,k.tip,k.kod,
    isnull(sum(h.giren-cikan),0),
    isnull( case when sum(h.giren)>0 then
    (sum(h.giren*h.brmfiykdvli)) / sum(h.giren)
    else 0 end , 0)  ortfiykdvli,
    isnull( case when sum(h.giren)>0 then
    (sum(h.giren*(h.brmfiykdvli / (1+kdvyuz)) )) / sum(h.giren)
    else 0 end , 0)  ortfiykdvsiz,
    case when k.sat1kdvtip='Dahil' then k.sat1fiy else k.sat1fiy*(1+(k.sat1kdv/100)) end sat1fiykdvli,
    case when k.sat1kdvtip='Hariç' then k.sat1fiy else k.sat1fiy/(1+(k.sat1kdv/100)) end sat1fiykdvsiz,
    case when k.sat2kdvtip='Dahil' then k.sat2fiy else k.sat2fiy*(1+(k.sat2kdv/100)) end sat2fiykdvli,
    case when k.sat2kdvtip='Hariç' then k.sat2fiy else k.sat2fiy/(1+(k.sat2kdv/100)) end sat2fiykdvsiz,
    case when k.alskdvtip='Dahil' then k.alsfiy else k.alsfiy*(1+(k.alskdv/100)) end  alsfiykdvli,
    case when k.alskdvtip='Hariç' then k.alsfiy else k.alsfiy/(1+(k.alskdv/100)) end  alsfiykdvsiz,
    k.sat1kdv/100,k.sat2kdv/100,k.alskdv/100
    from stokkart as k with (nolock)
    left join stkhrk as h with (nolock) on h.stktip=k.tip and h.stkod=k.kod
    and h.depkod=@depokod and isnull(h.firmano,0) in (0,@Firmano)
    and (h.tarih+cast(h.saat as datetime))<=@tarih
    and h.sil=0
    where k.sil=0
    and k.grp1=@stkgrp1id
    and k.grp2=@stkgrp2id
    and k.grp3=@stkgrp3id
    group by k.id,k.tip,k.kod,
    k.sat1fiy,k.sat1kdvtip,k.sat1kdv,
    k.sat2fiy,k.sat2kdvtip,k.sat2kdv,
    k.alsfiy,k.alskdvtip,k.alskdv
    
    
    if @Market_Sube=1
     begin
      update @TB_STOK_SAYIM_GRUP_DEPO set
      SAT1_BRMFIY_D=dt.SatisFiyat1KdvDahil,
      SAT1_BRMFIY_H=dt.SatisFiyat1KdvDahil/(1+(dt.SatisFiyat1Kdv/100)) ,
      SAT2_BRMFIY_D=dt.SatisFiyat2KdvDahil,
      SAT2_BRMFIY_H=dt.SatisFiyat2KdvDahil/(1+(dt.SatisFiyat1Kdv/100)) ,
      ALS_BRMFIY_D=dt.AlisFiyatKdvDahil,
      ALS_BRMFIY_H=dt.AlisFiyatKdvDahil/ (1+(dt.AlisFiyatKdv/100)) 
      
      from @TB_STOK_SAYIM_GRUP_DEPO as t 
      join (select StkId,SatisFiyat1KdvDahil,SatisFiyat1Kdv,
      SatisFiyat2KdvDahil,SatisFiyat2Kdv,
      AlisFiyatKdvDahil,AlisFiyatKdv  from  V_StokFirmaSubeFiyat 
      WHERE firmano=@Firmano ) dt on 
      dt.StkId=t.STOK_ID
   
     end
   end
   
  if @Firmano=0 
   begin
   
   insert into @TB_STOK_SAYIM_GRUP_DEPO
    (FIRMANO,DEP_KOD,STOK_ID,STOK_TIP,STOK_KOD,MIKTAR,
    ORT_BRMFIY_D,ORT_BRMFIY_H,SAT1_BRMFIY_D,SAT1_BRMFIY_H,
    SAT2_BRMFIY_D,SAT2_BRMFIY_H,ALS_BRMFIY_D,ALS_BRMFIY_H,
    SAT1_KDV_YUZ,SAT2_KDV_YUZ,ALS_KDV_YUZ)
    select @Firmano,@depokod,k.id,k.tip,k.kod,isnull(sum(h.giren-cikan),0),
    isnull( case when sum(h.giren)>0 then
    (sum(h.giren*h.brmfiykdvli)) / sum(h.giren)
    else 0 end , 0)  ortfiykdvli,
    isnull( case when sum(h.giren)>0 then
    (sum(h.giren*(h.brmfiykdvli / (1+kdvyuz)) )) / sum(h.giren)
    else 0 end , 0)  ortfiykdvsiz,
    case when k.sat1kdvtip='Dahil' then k.sat1fiy else k.sat1fiy*(1+(k.sat1kdv/100)) end sat1fiykdvli,
    case when k.sat1kdvtip='Hariç' then k.sat1fiy else k.sat1fiy/(1+(k.sat1kdv/100)) end sat1fiykdvsiz,
    case when k.sat2kdvtip='Dahil' then k.sat2fiy else k.sat2fiy*(1+(k.sat2kdv/100)) end sat2fiykdvli,
    case when k.sat2kdvtip='Hariç' then k.sat2fiy else k.sat2fiy/(1+(k.sat2kdv/100)) end sat2fiykdvsiz,
    case when k.alskdvtip='Dahil' then k.alsfiy else k.alsfiy*(1+(k.alskdv/100)) end  alsfiykdvli,
    case when k.alskdvtip='Hariç' then k.alsfiy else k.alsfiy/(1+(k.alskdv/100)) end  alsfiykdvsiz,
    k.sat1kdv/100,k.sat2kdv/100,k.alskdv/100
    from stokkart as k with (nolock)
    left join stkhrk as h with (nolock) on h.stktip=k.tip and h.stkod=k.kod
    and h.depkod=@depokod /*and h.firmano=@Firmano */
    and (h.tarih+cast(h.saat as datetime))<=@tarih
    and h.sil=0
    where k.sil=0
    and k.grp1=@stkgrp1id
    and k.grp2=@stkgrp2id
    and k.grp3=@stkgrp3id
    group by k.id,k.tip,k.kod,
    k.sat1fiy,k.sat1kdvtip,k.sat1kdv,
    k.sat2fiy,k.sat2kdvtip,k.sat2kdv,
    k.alsfiy,k.alskdvtip,k.alskdv
  
   
   end 
   
   
  

  RETURN
  
END

================================================================================
