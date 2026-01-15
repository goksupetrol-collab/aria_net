-- Function: dbo.UDF_STOK_ORT_FIY
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.770287
================================================================================

CREATE FUNCTION UDF_STOK_ORT_FIY 
(@FIRMANO		INT,
@DEPO_KOD        VARCHAR(50),
@HRK_KRITER     VARCHAR(4000),
@STOK_TIP		VARCHAR(10),
@STOK_KODIN 	VARCHAR(4000),
@BAS_TAR		DATETIME,
@BIT_TAR		DATETIME)
 RETURNS
  @TB_STOK_ORT_FIY TABLE (
    GRUP_ID    		INT,
    GRUP_AD  		VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_TIP    	VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD    	VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD  	    VARCHAR(150) COLLATE Turkish_CI_AS,
    GUN_SAY			INT,
    DEPO_MIKTAR     FLOAT DEFAULT 0,	
    MIKTAR    	    FLOAT,
    ORT_BRM_FIY     FLOAT,
    ORT_TUTAR       FLOAT,
    GUN_ORT_MIKTAR  FLOAT,
    GUN_ORT_FIY     FLOAT,
    GUN_ORT_TUTAR   FLOAT)
AS
BEGIN

    if @DEPO_KOD='' 
    begin
     insert into @TB_STOK_ORT_FIY 
     (GRUP_ID,GRUP_AD,STOK_TIP,STOK_KOD,STOK_AD,
     GUN_SAY,MIKTAR,
     ORT_BRM_FIY,ORT_TUTAR,
     GUN_ORT_MIKTAR,GUN_ORT_FIY,GUN_ORT_TUTAR)
     SELECT g.id,g.ad,k.tip,k.kod,k.ad,
     (DATEDIFF(DAY,@BAS_TAR,@BIT_TAR))+1,
      sum(h.cikan),
      0,sum((h.cikan)*h.brmfiykdvli),
      0,0,0
      FROM stokkart as k with (nolock)
      left join grup as g on g.id=k.grp1
      inner join stkhrk h with (nolock) on k.kod=h.stkod and
      k.tip=h.stktip and h.sil=0  and h.islmtip not in
      (select * from CsvToSTR(@HRK_KRITER))
      WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
      in (select * FROM CsvToSTR(@STOK_KODIN))
      and tarih >= @BAS_TAR  and tarih <= @BIT_TAR
      group by k.tip,g.id,g.ad,k.kod,k.ad
    end

    if @DEPO_KOD<>'' 
    begin
     insert into @TB_STOK_ORT_FIY 
     (GRUP_ID,GRUP_AD,STOK_TIP,STOK_KOD,STOK_AD,
     GUN_SAY,MIKTAR,
     ORT_BRM_FIY,ORT_TUTAR,
     GUN_ORT_MIKTAR,GUN_ORT_FIY,GUN_ORT_TUTAR)
     SELECT g.id,g.ad,k.tip,k.kod,k.ad,
     (DATEDIFF(DAY,@BAS_TAR,@BIT_TAR))+1,
      sum(h.cikan),
      0,sum((h.cikan)*h.brmfiykdvli),
      0,0,0
      FROM stokkart as k with (nolock)
      left join grup as g on g.id=k.grp1
      inner join stkhrk h with (nolock) on k.kod=h.stkod and
      k.tip=h.stktip and h.sil=0
      and h.islmtip not in
      (select * from CsvToSTR(@HRK_KRITER))
      WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
      in (select * FROM CsvToSTR(@STOK_KODIN))
      and tarih >= @BAS_TAR  and tarih <= @BIT_TAR
      and h.depkod =@DEPO_KOD
      group by k.tip,g.id,g.ad,k.kod,k.ad
    end 

    update @TB_STOK_ORT_FIY set 
    ORT_BRM_FIY=case when MIKTAR<>0 then 
    ORT_TUTAR/MIKTAR else 0 end,
    GUN_ORT_MIKTAR=case when GUN_SAY<>0 then 
    MIKTAR/GUN_SAY else 0 end,
    GUN_ORT_FIY=case when GUN_SAY<>0 then 
    ORT_TUTAR/GUN_SAY else 0 end
    
    
    update @TB_STOK_ORT_FIY set 
    GUN_ORT_TUTAR=GUN_ORT_MIKTAR*GUN_ORT_FIY
    
    
   if @DEPO_KOD=''  
    update @TB_STOK_ORT_FIY set  DEPO_MIKTAR=dt.mevmiktar from @TB_STOK_ORT_FIY as t 
    join (select stktip,stkod,
    isnull(sum(mk.giren-mk.cikan),0) mevmiktar 
    from  stkhrk as mk WITH (NOLOCK, INDEX = stkhrk_idx5)
      where  mk.sil=0 group by stktip,stkod  ) dt on 
      dt.stktip=t.STOK_TIP and dt.stkod=t.STOK_KOD
   
    
   if @DEPO_KOD<>''  
    update @TB_STOK_ORT_FIY set  DEPO_MIKTAR=dt.mevmiktar from @TB_STOK_ORT_FIY as t 
    join (select stktip,stkod,
    isnull(sum(mk.giren-mk.cikan),0) mevmiktar 
    from  stkhrk as mk WITH (NOLOCK, INDEX = stkhrk_idx5)
      where  mk.sil=0 and mk.depkod =@DEPO_KOD 
      group by stktip,stkod  ) dt on 
      dt.stktip=t.STOK_TIP and dt.stkod=t.STOK_KOD 


  RETURN






END

================================================================================
