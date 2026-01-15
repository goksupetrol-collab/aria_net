-- Function: dbo.DEPO_TARIHLI_STOKIN
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.653011
================================================================================

CREATE FUNCTION dbo.DEPO_TARIHLI_STOKIN 
(@VARTIP VARCHAR(20),@VARNIN VARCHAR(1000))
RETURNS
  @TB_DEP_TARIH TABLE (
    VAR_NO     FLOAT,
    DEP_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP   VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD   VARCHAR(30) COLLATE Turkish_CI_AS,
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
BEGIN

 DECLARE @EKSTRE_TEMP TABLE (
    VARNO      FLOAT)
  declare @separator char(1) 
  set @separator = ','

  declare @separator_position int
  declare @array_value varchar(1000)

 IF (LEN(RTRIM(@VARNIN)) > 0)
 BEGIN
  set @VARNIN = @VARNIN + ','
 END

 while patindex('%,%' , @VARNIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @VARNIN)
   select @array_value = left(@VARNIN, @separator_position - 1)

  Insert @EKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @VARNIN = stuff(@VARNIN, 1, @separator_position, '')
 end

  DECLARE @TB_TEMP_STOKLIST
  TABLE (
   tarih  datetime,
   depkod varchar(50) COLLATE Turkish_CI_AS,
   stktip varchar(20) COLLATE Turkish_CI_AS,
   stkkod varchar(50) COLLATE Turkish_CI_AS )
   
   if @VARTIP='marvardimas'
   begin
       insert into @TB_TEMP_STOKLIST
       (tarih,depkod,stktip,stkkod)
       select max(cast(mv.tarih as float)+cast(mv.saat as datetime)),
       mv.depkod,mhk.stktip,mhk.stkod
       from marvardimas as mv
       inner join marsathrk as mhk on mhk.varno=mv.varno
       and mv.sil=0 and mhk.sil=0
       and mv.varno in (select varno from @EKSTRE_TEMP)
       group by mv.depkod,mhk.stktip,mhk.stkod
   end
   
   if @VARTIP='pomvardimas'
   begin
       insert into @TB_TEMP_STOKLIST
       (tarih,depkod,stktip,stkkod)
       select max(cast(p.tarih as float)+cast(p.saat as datetime)),
       ps.tankod,ps.stktip,ps.stkod
       from  pomvardisayac as ps
       inner join pomvardimas as p on ps.varno=p.varno
       and p.sil=0 and ps.perkod='Diger'
       and ps.varno in (select varno from @EKSTRE_TEMP)
       group by ps.tankod,ps.stktip,ps.stkod
   end
   
  DECLARE @VAR_NO   FLOAT
  DECLARE @DEP_KOD  VARCHAR(50)
  DECLARE @STOK_TIP VARCHAR(10)
  DECLARE @STOK_KOD VARCHAR(50)
  DECLARE @MIKTAR   FLOAT
  DECLARE @TUTAR    FLOAT

  IF @VARTIP='marvardimas'
  begin
    DECLARE CRS_DEPO_STOK_HRK CURSOR FAST_FORWARD FOR
    SELECT
       mv.depkod,sk.tip,sk.kod,ISNULL(SUM(h.giren-h.cikan),0),
       ISNULL(SUM((h.giren-h.cikan)*case when sk.sat1kdvtip='Dahil' then 
       sk.sat1fiy ELSE
        sk.sat1fiy*(1+(sk.sat1kdv/100)) end),0)
       from @TB_TEMP_STOKLIST as mv
       inner join stokkart as sk on sk.kod=mv.stkkod and sk.tip=mv.stktip
       left join stkhrk as h on h.depkod=mv.depkod  and h.stktip=mv.stktip
       and h.stkod=sk.kod and h.sil=0
       AND (mv.tarih) >  (h.tarih+cast(h.saat as datetime))
       group by mv.depkod,sk.tip,sk.kod
    end
       
    IF @VARTIP='pomvardimas'
    begin
     DECLARE CRS_DEPO_STOK_HRK CURSOR FAST_FORWARD FOR
     SELECT
       ps.depkod,sk.tip,sk.kod,ISNULL(SUM(h.giren-h.cikan),0),
       ISNULL(SUM((h.giren-h.cikan)*h.brmfiykdvli),0)
       from @TB_TEMP_STOKLIST as ps
       inner join stokkart as sk on sk.kod=ps.stkkod and sk.tip=ps.stktip
       left join stkhrk as h on h.depkod=ps.depkod  and h.stktip=sk.tip
       and h.stkod=sk.kod and h.sil=0
       AND ps.tarih > cast(h.tarih as float)+cast(h.saat as datetime)
       /*  (h.tarih+cast(h.saat as datetime)) */
       group by ps.depkod,sk.tip,sk.kod
     end
     
    OPEN CRS_DEPO_STOK_HRK
    
   FETCH NEXT FROM CRS_DEPO_STOK_HRK INTO
   @DEP_KOD,@STOK_TIP,@STOK_KOD,@MIKTAR,@TUTAR
   WHILE @@FETCH_STATUS = 0
   BEGIN

    INSERT @TB_DEP_TARIH (DEP_KOD,STOK_TIP,STOK_KOD,MIKTAR,TUTAR)
    VALUES (@DEP_KOD,@STOK_TIP,@STOK_KOD,@MIKTAR,@TUTAR)

   FETCH NEXT FROM CRS_DEPO_STOK_HRK INTO
   @DEP_KOD,@STOK_TIP,@STOK_KOD,@MIKTAR,@TUTAR
  END

  CLOSE CRS_DEPO_STOK_HRK
  DEALLOCATE CRS_DEPO_STOK_HRK


  RETURN
  
 END

================================================================================
