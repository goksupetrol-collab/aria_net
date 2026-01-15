-- Function: dbo.UDF_VAR_SATISIADE_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.790068
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_SATISIADE_TOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_SATISIADE_TOPLAM TABLE (
    STOK_TIP    VARCHAR(10)  COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100)  COLLATE Turkish_CI_AS,
    STOK_GRUP   VARCHAR(50)  COLLATE Turkish_CI_AS,
    ONCEKIMIKTAR     FLOAT,
    ONCEKITUTAR      FLOAT,
    MALALISMIKTAR    FLOAT,
    MALALISTUTAR     FLOAT,
    SATISMIKTAR      FLOAT,
    SATISTUTAR       FLOAT,
    IADEMIKTAR       FLOAT,
    IADETUTAR        FLOAT,
    DIGERMIKTAR      FLOAT,
    DIGERTUTAR       FLOAT,
    KALANMIKTAR      FLOAT,
    KALANTUTAR       FLOAT)
AS
BEGIN


  DECLARE @DEPO_KOD VARCHAR(30)
  DECLARE @STOK_TIP      VARCHAR(20)
  DECLARE @STOK_KOD      VARCHAR(30)
  DECLARE @STOK_AD       VARCHAR(50)
  DECLARE @STOK_GRUP     VARCHAR(50)
  DECLARE @ONCEKIMIKTAR  FLOAT
  DECLARE @ONCEKITUTAR   FLOAT
  DECLARE @MALALISMIKTAR FLOAT
  DECLARE @MALALISTUTAR  FLOAT
  DECLARE @SATISTUTAR    FLOAT
  DECLARE @SATISMIKTAR   FLOAT
  DECLARE @IADEMIKTAR    FLOAT
  DECLARE @IADETUAR      FLOAT
  DECLARE @DIGERMIKTAR   FLOAT
  DECLARE @DIGERTUTAR    FLOAT
  
  DECLARE @KALANMIKTAR   FLOAT
  DECLARE @KALANTUTAR     FLOAT
  
  DECLARE @MINTARIH     DATETIME
  DECLARE @MAXTARIH     DATETIME

  DECLARE @MINSAAT     VARCHAR(8)
  DECLARE @MAXSAAT     VARCHAR(8)


   declare @VarnoSayi    int
   

  select @VarnoSayi=count(*) from CsvToInt_Max(@VARNIN)


/*-- stok son durumları */
  DECLARE @TB_DEP_TARIH TABLE (
    VAR_NO     FLOAT,
    DEP_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP   VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD   VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_SAT1FIY    FLOAT,
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
    
  /* INSERT INTO @TB_DEP_TARIH 
   SELECT * FROM DBO.DEPO_TARIHLI_STOKIN (@TIP,@VARNIN)
----stok son durumları
*/
   DECLARE @MIN_TARIH   DATETIME
   DECLARE @MAX_TARIH   DATETIME   
   declare @STK_TIP     varchar(20)
   declare @DEP_KOD     varchar(50)
   
   SELECT 
   @DEP_KOD=min(mv.depkod),
   @MIN_TARIH=min(cast(mv.tarih as float)+cast(mv.saat as datetime)),
   @MAX_TARIH=max(cast(mv.tarih as float)+cast(mv.saat as datetime))
   FROM marvardimas as mv with (nolock) where sil=0 and 
   varno in (select * from CsvToInt_Max(@VARNIN))
   
   
      insert into @TB_DEP_TARIH
       (DEP_KOD,STOK_TIP,STOK_KOD,
       STOK_SAT1FIY,MIKTAR,TUTAR)
       select @DEP_KOD,sk.tip,sk.kod,
       case when sk.sat1kdvtip='Dahil' then sk.sat1fiy
       else sk.sat1fiy*(1+(sk.sat1kdv/100)) end,
       0,0
       from stokkart as sk with (nolock)
       where sk.sil=0 and sk.tip='markt'

     update @TB_DEP_TARIH set  
      MIKTAR=dt.mik,
      TUTAR=dt.mik*STOK_SAT1FIY  from 
      @TB_DEP_TARIH as t
       join (SELECT
       H.DEPKOD,h.stktip,h.stkod,
       ISNULL(SUM(h.giren-h.cikan),0) as mik
       from @TB_DEP_TARIH as dm
       left join stkhrk as h with (nolock) on 
       h.stktip=dm.STOK_TIP
       and h.stkod=dm.STOK_KOD and h.sil=0
       AND h.tarih+cast(h.saat as datetime) < @MIN_TARIH 
       group by H.DEPKOD,h.stktip,h.stkod)
       dt on 
       T.DEP_KOD=dt.DEPKOD and 
       t.STOK_TIP=dt.stktip
       and t.STOK_KOD=dt.stkod



 
  DECLARE CRS_STOK_HRK CURSOR FAST_FORWARD FOR
    SELECT
       SK.tip,sk.kod,sk.ad,grup.ad,isnull(sum(case when islmtip='satis' then mhk.mik else -1*mhk.mik end),0),
       isnull(sum(case when islmtip='satis' then mhk.mik*((mhk.brmfiy*mhk.kur))
        else -1*mhk.mik*((mhk.brmfiy*mhk.kur)) end),0),
       isnull(sum(case when islmtip='iade' then mhk.mik else 0 end),0),
       isnull(sum(case when islmtip='iade' then mhk.mik*((mhk.brmfiy*mhk.kur)) else 0 end),0),
       isnull(dep.MIKTAR,0),ISNULL(dep.TUTAR,0),
       min(mv.tarih+cast(mv.saat as datetime)),max(mv.kaptar+cast(mv.kapsaat as datetime))
       from marvardimas as mv with (nolock)
       inner join marsathrk as mhk with (nolock) on mhk.varno=mv.varno and mv.sil=0 and mhk.sil=0
       inner join stokkart as sk with (nolock) on sk.kod=mhk.stkod and sk.tip=mhk.stktip
       left join @TB_DEP_TARIH as dep on /*dep.var_no=mv.varno and */
       dep.STOK_TIP=sk.tip and sk.kod=dep.STOK_KOD
       left join grup with (nolock) on grup.id=sk.grp1
       where mv.varno in (select * from CsvToInt_Max(@VARNIN))
       group by SK.tip,sk.kod,sk.ad,grup.ad,dep.MIKTAR,dep.TUTAR
    OPEN CRS_STOK_HRK


   FETCH NEXT FROM CRS_STOK_HRK INTO
   @STOK_TIP,@STOK_KOD,@STOK_AD,@STOK_GRUP,@SATISMIKTAR,@SATISTUTAR,@IADEMIKTAR,@IADETUAR,
   @ONCEKIMIKTAR,@ONCEKITUTAR,@MINTARIH,@MAXTARIH

   WHILE @@FETCH_STATUS = 0
   BEGIN
    
   
    /* if isnull(@varnosayi,0)>0
     begin 
      set @ONCEKIMIKTAR=@ONCEKIMIKTAR/isnull(@varnosayi,0)
      set @ONCEKITUTAR= @ONCEKITUTAR/isnull(@varnosayi,0)
     end 
     */ 


   Set @MINSAAT=convert(varchar,@MINTARIH,108);
   set @MINTARIH=convert(varchar,@MINTARIH,101);
   
   Set @MAXSAAT=convert(varchar,@MAXTARIH,108);
   set @MAXTARIH=convert(varchar,@MAXTARIH,101);

    set @KALANMIKTAR=0
    set @KALANTUTAR=0
    


    /*SELECT @ONCEKIMIKTAR=MIKTAR,@ONCEKITUTAR=TUTAR FROM */
    /*dbo.DEPO_TARIHLI_STOK ('',@STOK_TIP,@STOK_KOD,@MINTARIH,@MINSAAT) */
    set @MALALISMIKTAR=0
    set @MALALISTUTAR=0
    set @DIGERMIKTAR=0
    set @DIGERTUTAR=0
    
   /*
     SELECT @MALALISMIKTAR=MIKTAR,@MALALISTUTAR=TUTAR FROM
     dbo.MALALIS_TARIHLI_STOK ('',@STOK_TIP,@STOK_KOD,@MAXTARIH,@MINTARIH,@MINSAAT,@MAXSAAT)

      SELECT @DIGERMIKTAR=MIKTAR,@DIGERTUTAR=TUTAR FROM
       dbo.MALCIKIS_TARIHLI_STOK ('',@STOK_TIP,@STOK_KOD,@MAXTARIH,@MINTARIH,@MINSAAT,@MAXSAAT)
    */
      SET @KALANMIKTAR=(@ONCEKIMIKTAR+@MALALISMIKTAR)-(@SATISMIKTAR+@DIGERMIKTAR)
      SET @KALANTUTAR=(@ONCEKITUTAR+@MALALISTUTAR)-(@SATISTUTAR+@DIGERTUTAR)



    INSERT @TB_SATISIADE_TOPLAM (STOK_TIP,STOK_KOD,STOK_AD,STOK_GRUP,ONCEKIMIKTAR,ONCEKITUTAR,
    MALALISMIKTAR,MALALISTUTAR,SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,DIGERMIKTAR,DIGERTUTAR,
    KALANMIKTAR,KALANTUTAR)
    VALUES (@STOK_TIP,@STOK_KOD,@STOK_AD,@STOK_GRUP,@ONCEKIMIKTAR,@ONCEKITUTAR,@MALALISMIKTAR,@MALALISTUTAR,
    @SATISMIKTAR,@SATISTUTAR,@IADEMIKTAR,@IADETUAR,@DIGERMIKTAR,@DIGERTUTAR,@KALANMIKTAR,@KALANTUTAR)


      FETCH NEXT FROM CRS_STOK_HRK INTO
     @STOK_TIP,@STOK_KOD,@STOK_AD,@STOK_GRUP,@SATISMIKTAR,@SATISTUTAR,@IADEMIKTAR,@IADETUAR,
     @ONCEKIMIKTAR,@ONCEKITUTAR,@MINTARIH,@MAXTARIH


  END

  CLOSE CRS_STOK_HRK
  DEALLOCATE CRS_STOK_HRK




  RETURN

end

================================================================================
