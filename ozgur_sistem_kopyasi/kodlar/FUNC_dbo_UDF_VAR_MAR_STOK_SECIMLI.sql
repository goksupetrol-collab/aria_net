-- Function: dbo.UDF_VAR_MAR_STOK_SECIMLI
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.783345
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_MAR_STOK_SECIMLI 
(@VARNIN VARCHAR(1000),
@GRPIN VARCHAR(4000))
RETURNS
    @TB_STOK_SECIMLI TABLE (
    DEPO_KOD     VARCHAR(30)  COLLATE Turkish_CI_AS, 
    STOK_TIP    VARCHAR(10)  COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_GRUP   VARCHAR(70)  COLLATE Turkish_CI_AS,
    STOK_SAT1FIY    FLOAT,
    ONCEKIMIKTAR     FLOAT,
    ONCEKITUTAR      FLOAT,
    MALALISMIKTAR    FLOAT,
    MALALISTUTAR     FLOAT,
    SATISMIKTAR      FLOAT,
    SATISTUTAR       FLOAT,
    IADEMIKTAR       FLOAT,
    IADETUTAR        FLOAT,
    KALANMIKTAR      FLOAT,
    KALANTUTAR       FLOAT)
    
AS
BEGIN    


   DECLARE @MIN_TARIH   DATETIME
   DECLARE @MAX_TARIH   DATETIME   
   declare @STK_TIP     varchar(20)
   declare @DEP_KOD     varchar(50)
   

   SELECT 
   @DEP_KOD=min(mv.depkod),
   @MIN_TARIH=min(cast(mv.tarih as float)+cast(mv.saat as datetime)),
   @MAX_TARIH=max(cast(mv.tarih as float)+cast(mv.saat as datetime))
   FROM marvardimas as mv where sil=0 and 
   varno in (select * from CsvToInt(@VARNIN))
  
   
   
      set @STK_TIP='markt' 
        
   
       insert into @TB_STOK_SECIMLI
       (DEPO_KOD,STOK_GRUP,STOK_TIP,
       STOK_KOD,STOK_AD,STOK_SAT1FIY,
       ONCEKIMIKTAR,ONCEKITUTAR,
       MALALISMIKTAR,MALALISTUTAR,
       SATISMIKTAR,SATISTUTAR,
       IADEMIKTAR,IADETUTAR,
       KALANMIKTAR,KALANTUTAR)
       select @DEP_KOD,grp.ad,sk.tip,sk.kod,sk.ad,
       case when sk.sat1kdvtip='Dahil' then sk.sat1fiy
       else sk.sat1fiy*(1+(sk.sat1kdv/100)) end,
       0,0,0,0,0,0,0,0,0,0
       from stokkart as sk 
       left join grup as grp on grp.id=sk.grp1 and grp.sil=0
       where sk.sil=0 and sk.tip=@STK_TIP
       and grp.id in (select * from CsvToInt(@GRPIN))
      
       
      update @TB_STOK_SECIMLI set  
      ONCEKIMIKTAR=dt.mik,
      ONCEKITUTAR=dt.mik*STOK_SAT1FIY  from 
      @TB_STOK_SECIMLI as t
       join (SELECT
       H.DEPKOD,h.stktip,h.stkod,
       ISNULL(SUM(h.giren-h.cikan),0) as mik
       from @TB_STOK_SECIMLI as dm
       left join stkhrk as h on 
       h.stktip=dm.STOK_TIP
       and h.stkod=dm.STOK_KOD and h.sil=0
       AND h.tarih < @MIN_TARIH 
       group by H.DEPKOD,h.stktip,h.stkod)
       dt on 
       T.DEPO_KOD=dt.DEPKOD and 
       t.STOK_TIP=dt.stktip
       and t.STOK_KOD=dt.stkod
     
         
      
      update @TB_STOK_SECIMLI set  
      MALALISMIKTAR=dt.mik,
      MALALISTUTAR=dt.tutar
      from 
      @TB_STOK_SECIMLI as t
       join (SELECT
       H.DEPKOD,h.stktip,h.stkod,
       ISNULL(SUM(h.giren),0) as mik,
       ISNULL(SUM((h.giren)*h.brmfiykdvli),0) as tutar
       from @TB_STOK_SECIMLI as dm
       left join stkhrk as h on 
       h.stktip=dm.STOK_TIP
       and h.stkod=dm.STOK_KOD and h.sil=0
       AND h.tarih > @MIN_TARIH 
       and h.tarih < @MAX_TARIH
       and h.islmtip<>'MARIAD'
       group by H.DEPKOD,h.stktip,h.stkod)
       dt on 
       T.DEPO_KOD=dt.DEPKOD and 
       t.STOK_TIP=dt.stktip
       and t.STOK_KOD=dt.stkod
      
      
      update @TB_STOK_SECIMLI 
      set SATISMIKTAR=dt.SATISMIKTAR,
      SATISTUTAR=dt.SATISTUTAR,
      IADEMIKTAR=dt.IADEMIKTAR,
      IADETUTAR=dt.IADETUTAR  from @TB_STOK_SECIMLI t join
      (select sk.kod,sk.tip,
       isnull(sum(case when islmtip='satis' then mhk.mik else -1*mhk.mik end),0) as SATISMIKTAR,
       isnull(sum(case when islmtip='satis' then mhk.mik*((mhk.brmfiy*mhk.kur))
       else -1*mhk.mik*((mhk.brmfiy*mhk.kur)) end),0) SATISTUTAR ,
       isnull(sum(case when islmtip='iade' then mhk.mik else 0 end),0) IADEMIKTAR,
       isnull(sum(case when islmtip='iade' then mhk.mik*((mhk.brmfiy*mhk.kur))
        else 0 end),0) IADETUTAR from marvardimas as mv 
       left join marsathrk as mhk on mhk.varno=mv.varno and mv.sil=0 and mhk.sil=0
       left join stokkart as sk on sk.kod=mhk.stkod and sk.tip=mhk.stktip
       where mv.varno in (select * from CsvToSTR(@VARNIN))
       group by sk.kod,sk.tip ) dt 
       on dt.tip=t.STOK_TIP
       and t.STOK_KOD=dt.kod
      
      
            
       
       update @TB_STOK_SECIMLI set 
       KALANMIKTAR=ONCEKIMIKTAR+MALALISMIKTAR-SATISMIKTAR+IADEMIKTAR,
       KALANTUTAR=(ONCEKIMIKTAR+MALALISMIKTAR-SATISMIKTAR+IADEMIKTAR)*
       STOK_SAT1FIY
       
   
   
   
   
   
   
   





  RETURN


END

================================================================================
