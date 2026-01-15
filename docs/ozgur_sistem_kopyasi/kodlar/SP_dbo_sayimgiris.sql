-- Stored Procedure: dbo.sayimgiris
-- Tarih: 2026-01-14 20:06:08.364089
================================================================================

CREATE PROCEDURE [dbo].sayimgiris 
@sayid float,
@saygrp1id int,
@saygrp2id int,
@saygrp3id int
AS
BEGIN

declare @mesaj varchar(100)
    DECLARE @TB_SAYIMHRK TABLE (
    id                  FLOAT,
    DEP_KOD             VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP            VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD            VARCHAR(30) COLLATE Turkish_CI_AS,
    DRM                 VARCHAR(10) COLLATE Turkish_CI_AS,
    SAYDRM              VARCHAR(10) COLLATE Turkish_CI_AS,
    SAYILAN_MIK         FLOAT,
    ONLINESAYILAN_MIK   FLOAT,
    ONLINETARIHSAAT     DATETIME,
    ONLINESAYIM         BIT)


  declare @grp1 int,@grp2 int,@grp3 int
  declare @depkod varchar(30),@stktip varchar(10)
  declare @stkod varchar(30)
  declare @brmfiytip varchar(30)
  declare @kdvtip varchar(5)
  declare @saybastar datetime
  declare @tarih datetime,@saat varchar(8)
  declare @olustarsaat datetime,@olususer varchar(50)


    insert into @TB_SAYIMHRK (id,DEP_KOD,STOK_TIP,STOK_KOD,DRM,SAYDRM,SAYILAN_MIK,
    ONLINESAYILAN_MIK,ONLINETARIHSAAT,ONLINESAYIM)
    select  hk.id,hk.depkod,hk.stktip,hk.stkod,hk.drm,hk.saydrm,hk.sayimmik,
    hk.OnlineSayimMiktar,hk.OnlineSayimTarihSaat,hk.OnlineSayim
    from  sayimhrk as hk with (nolock)
    inner join stokkart as k with (nolock)
    on k.kod=hk.stkod and k.tip=hk.stktip and k.sil=0
 /*   left join grup as g on g.id=(case when k.grp3>0 then k.grp3 */
 /*   when k.grp2>0 then k.grp2 */
 /*   when k.grp1>0 then k.grp1 end) and g.sil=0 */
    where hk.sayid=@sayid
    and k.grp1=@saygrp1id and k.grp2=@saygrp2id and k.grp3=@saygrp3id

    select @brmfiytip=brmfiytip,@depkod=depkod,@kdvtip=kdvtip,@tarih=tarih,@saat=saat,
    @saybastar=(tarih+cast(saat as datetime)),
    @olustarsaat=case when olustarsaat>0 then degtarsaat else olustarsaat end,
    @olususer=case when olususer<>'' then deguser else olususer end
    from sayimmas as sm with (nolock) where sayid=@sayid
   
    delete from sayimhrk where sayid=@sayid and id in
    (select id from @TB_SAYIMHRK)

   insert into sayimhrk (tarih,saat,sayid,depkod,stktip,stkod,mevcutmik,
   brmfiy,kdvyuz,kdvtip,olustarsaat,olususer)
   select @tarih,@saat,@sayid,@depkod,D.STOK_TIP,D.STOK_KOD,
   d.MIKTAR,case
   when @brmfiytip='SIFIR FIYAT' then 0
   when (@brmfiytip='ORTALAMA ALIS FIYAT') and @kdvtip='DAHIL' then
   d.ORT_BRMFIY_D
   when (@brmfiytip='ORTALAMA ALIS FIYAT') and @kdvtip='HARIC' then
   d.ORT_BRMFIY_H
   when (@brmfiytip='ALIS FIYAT') and @kdvtip='DAHIL' then
   d.ALS_BRMFIY_D
   when (@brmfiytip='ALIS FIYAT') and @kdvtip='HARIC' then
   d.ALS_BRMFIY_H
   when (@brmfiytip='SATIS FIYAT-1') and @kdvtip='DAHIL' then
   d.SAT1_BRMFIY_D
   when (@brmfiytip='SATIS FIYAT-1') and @kdvtip='HARIC' then
   d.SAT1_BRMFIY_H
   when (@brmfiytip='SATIS FIYAT-2') and @kdvtip='DAHIL' then
   d.SAT2_BRMFIY_D
   when (@brmfiytip='SATIS FIYAT-2') and @kdvtip='HARIC' then
   d.SAT2_BRMFIY_H end,
/*---kdv */
   case when @brmfiytip='SIFIR FIYAT' then 0
   when (@brmfiytip='ORTALAMA ALIS FIYAT') then
   d.ALS_KDV_YUZ
   when (@brmfiytip='ALIS FIYAT') then
   d.ALS_KDV_YUZ
   when (@brmfiytip='SATIS FIYAT-1') then
   d.SAT1_KDV_YUZ
   when (@brmfiytip='SATIS FIYAT-2') then
   d.SAT2_KDV_YUZ end,
   @kdvtip,@olustarsaat,@olususer FROM STOK_SAYIM_GRUP_FIRMA_DEPO
   (@sayid,@saygrp1id,@saygrp2id,@saygrp3id,@depkod,@saybastar) as d
  


   update sayimhrk set sayimmik=dt.SAYILAN_MIK,
   OnlineSayimMiktar=dt.ONLINESAYILAN_MIK,
   OnlineSayimTarihSaat=dt.ONLINETARIHSAAT,
   OnlineSayim=dt.ONLINESAYIM,
   drm=dt.DRM,saydrm=dt.SAYDRM
   from sayimhrk as t with (nolock) join
   (select DEP_KOD,STOK_TIP,STOK_KOD,DRM,SAYDRM,SAYILAN_MIK,
   ONLINESAYILAN_MIK,ONLINETARIHSAAT,ONLINESAYIM
   from @TB_SAYIMHRK ) dt on t.stkod=dt.STOK_KOD and t.stktip=dt.STOK_TIP
   and t.sayid=@sayid
   
   


END

================================================================================
