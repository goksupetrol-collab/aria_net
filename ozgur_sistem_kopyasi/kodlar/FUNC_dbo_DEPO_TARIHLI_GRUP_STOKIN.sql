-- Function: dbo.DEPO_TARIHLI_GRUP_STOKIN
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.651946
================================================================================

CREATE FUNCTION dbo.[DEPO_TARIHLI_GRUP_STOKIN] (@VARTIP VARCHAR(20),
@VARNIN VARCHAR(8000))
RETURNS
  @TB_DEP_TARIH TABLE (
    GRUPANA_ID    int,
    GRUPANA_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
    GRUP_ID    int,
    GRUP_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
    DEP_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
BEGIN

 /*declare @var_tarsaat   datetime */

 DECLARE  @STK_TIP   VARCHAR(10)

 DECLARE  @MAX_TAR   DATETIME

  declare @Market_Stok_AltGrup int
  
  select @Market_Stok_AltGrup=isnull(Market_Stok_AltGrup,0) From sistemtanim


 
  DECLARE @TB_TEMP_STOKLIST
  TABLE (
   GRUPANA_ID    int,
   GRUPANA_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
   GRUP_ID    int,
   GRUP_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
   tarih      datetime,
   depkod     varchar(50))
   
   if @VARTIP='marvardimas'
   begin
     SET @STK_TIP='markt'
    
   
    if @Market_Stok_AltGrup=0
       insert into @TB_TEMP_STOKLIST
       (GRUPANA_ID,GRUPANA_AD,GRUP_ID,GRUP_AD,tarih,depkod)
       select SK.grp1,'',grp.id,grp.ad,
       max(cast(mv.tarih as float)+cast(mv.saat as datetime)),
       mv.depkod
       from marvardimas as mv
       left join stokkart as sk on sk.sil=0 and sk.tip=@STK_TIP
       left join grup as grp on grp.id=SK.grp1 and grp.sil=0
       where mv.sil=0 
       and mv.varno in (select * from CsvToSTR(@VARNIN))
       group by SK.grp1,grp.id,grp.ad,mv.depkod
   
   
    if @Market_Stok_AltGrup=1
       insert into @TB_TEMP_STOKLIST
       (GRUPANA_ID,GRUPANA_AD,GRUP_ID,GRUP_AD,tarih,depkod)
       select SK.grp1,'',grp.id,grp.ad,
       max(cast(mv.tarih as float)+cast(mv.saat as datetime)),
       mv.depkod
       from marvardimas as mv
       left join stokkart as sk on sk.sil=0 and sk.tip=@STK_TIP
       left join grup as grp on grp.id=
       case when sk.grp3>0 then sk.grp3
       when sk.grp2>0 then sk.grp2
       when sk.grp1>0 then sk.grp1 end 
       and grp.sil=0
       where mv.sil=0 
       and mv.varno in (select * from CsvToSTR(@VARNIN))
       group by SK.grp1,grp.id,grp.ad,mv.depkod
     
     
       SELECT @MAX_TAR=max(tarih) from @TB_TEMP_STOKLIST
       
   end
   

  DECLARE @TB_TEMP_STOKMIKTAR_TUTAR
  TABLE (
   GRUPANA_ID    int,
   GRUP_ID    int,
   depkod     varchar(50),
   miktar     FLOAT,
   tutar      FLOAT)



  if @Market_Stok_AltGrup=0
    insert into @TB_TEMP_STOKMIKTAR_TUTAR
     (GRUPANA_ID,GRUP_ID,depkod,miktar,tutar)
     select SK.grp1,sk.grp1,h.depkod,ISNULL(SUM(h.giren-h.cikan),0),
       ISNULL(SUM((h.giren-h.cikan)*case when sk.sat1kdvtip='Dahil' then sk.sat1fiy ELSE
       sk.sat1fiy*(1+(sk.sat1kdv/100)) end),0) from stokkart as sk 
       left join stkhrk as h on h.stktip=sk.tip 
       and h.stkod=sk.kod and sk.tip=@STK_TIP and sk.sil=0 and h.sil=0 
       AND  (h.tarih+cast(h.saat as datetime))<@MAX_TAR
      group by sk.grp1,h.depkod



   if @Market_Stok_AltGrup=1
    insert into @TB_TEMP_STOKMIKTAR_TUTAR
     (GRUPANA_ID,GRUP_ID,depkod,miktar,tutar)
     select SK.grp1,case when sk.grp3>0 then sk.grp3
       when sk.grp2>0 then sk.grp2
       when sk.grp1>0 then sk.grp1 end,h.depkod,ISNULL(SUM(h.giren-h.cikan),0),
       ISNULL(SUM((h.giren-h.cikan)*case when sk.sat1kdvtip='Dahil' then sk.sat1fiy ELSE
       sk.sat1fiy*(1+(sk.sat1kdv/100)) end),0) from stokkart as sk 
       left join stkhrk as h on h.stktip=sk.tip 
       and h.stkod=sk.kod and sk.tip=@STK_TIP and sk.sil=0 and h.sil=0 
       AND  (h.tarih+cast(h.saat as datetime))<@MAX_TAR
      group by sk.grp1,sk.grp2,sk.grp3,h.depkod


  IF @VARTIP='marvardimas'
  begin
   INSERT @TB_DEP_TARIH (GRUPANA_ID,GRUP_ID,GRUP_AD,DEP_KOD,MIKTAR,TUTAR)
    SELECT
       MV.GRUPANA_ID,mv.GRUP_ID,mv.GRUP_AD,mv.depkod,
       ISNULL(SUM(miktar),0),ISNULL(SUM(tutar),0)
       from @TB_TEMP_STOKLIST as mv
       left join @TB_TEMP_STOKMIKTAR_TUTAR as sh on sh.depkod=mv.depkod
       and sh.GRUP_ID=mv.GRUP_ID
       group by MV.GRUPANA_ID,mv.GRUP_ID,mv.GRUP_AD,mv.depkod
          
    end


   UPDATE @TB_DEP_TARIH SET GRUPANA_AD=dt.ad from @TB_DEP_TARIH
   as t join (select * from grup ) dt on 
   dt.id=t.GRUPANA_ID
   

  RETURN
  
 END

================================================================================
