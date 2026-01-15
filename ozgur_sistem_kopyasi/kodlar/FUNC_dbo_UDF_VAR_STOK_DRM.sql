-- Function: dbo.UDF_VAR_STOK_DRM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.792830
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_STOK_DRM (@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_TANK_STOK TABLE (
    TANK_KOD    VARCHAR(20),
    TANK_AD     VARCHAR(50),
    ONCEKIMIKTAR        FLOAT,
    MALALIM             FLOAT,
    MALALIMTUTAR        FLOAT,
    SATISMIKTAR         FLOAT,
    TESTMIKTAR          FLOAT,
    DIGERMIKTAR         FLOAT,
    KALANMIKTAR         FLOAT)
AS
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

  DECLARE @HRK_VERNO FLOAT
  DECLARE @HRK_TANK_KOD VARCHAR(30)
  DECLARE @HRK_TANK_AD VARCHAR(30)
  DECLARE @HRK_STK_KOD VARCHAR(30)
  DECLARE @HRK_STK_TIP VARCHAR(10)
  DECLARE @HRK_ONCEKIMIK FLOAT
  DECLARE @HRK_MALALIM FLOAT
  DECLARE @HRK_SATISMIKTAR FLOAT
  DECLARE @HRK_TESTMIKTAR FLOAT
  DECLARE @HRK_DIGERMIKTAR FLOAT
  DECLARE @HRK_KALANMIKTAR FLOAT
  DECLARE @HRK_MALTUTAR    FLOAT


  DECLARE @HRK_MINTARIH DATETIME
  DECLARE @HRK_MAXTARIH DATETIME

    DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    select ps.kod,ps.stkod,ps.stktip,st.ad,min(ps.acmik),0,sum(ps.satmik),sum(ps.testmik),
    sum(PS.transfer_cks_mik),0,
    min(pm.tarih+cast(pm.saat as datetime)),
    max(pm.kaptar+cast(pm.kapsaat as datetime))
    FROM  pomvarditank as ps
    inner join pomvardimas as pm on ps.varno=pm.varno and pm.sil=0
    inner join tankkart as st on st.kod=ps.kod
    where ps.varno in (select * from @EKSTRE_TEMP)
    and ps.sil=0 group by ps.kod,st.ad,ps.stkod,ps.stktip

   OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_TANK_KOD,@HRK_STK_KOD,@HRK_STK_TIP,@HRK_TANK_AD,@HRK_ONCEKIMIK,@HRK_MALALIM,
   @HRK_SATISMIKTAR,@HRK_TESTMIKTAR,@HRK_DIGERMIKTAR,@HRK_KALANMIKTAR,
   @HRK_MINTARIH,@HRK_MAXTARIH

  WHILE @@FETCH_STATUS = 0
  BEGIN
     SET @HRK_MALALIM=0
     SET @HRK_MALTUTAR=0
     
     if @HRK_MAXTARIH is null
      begin

      SELECT @HRK_MALALIM=isnull(sum(giren-cikan),0),
      @HRK_MALTUTAR=isnull(sum((giren-cikan)*brmfiykdvli),0)
      from stkhrk
      where sil=0 and depkod=@HRK_TANK_KOD and stkod=@HRK_STK_KOD AND stktip=@HRK_STK_TIP
      and islmtip in ('FATAKALS','FATMRALS') and (tarih+cast(saat as datetime))>=@HRK_MINTARIH

     end
     else
      begin
      
     SELECT @HRK_MALALIM=isnull(sum(giren-cikan),0),
     @HRK_MALTUTAR=isnull(sum((giren-cikan)*brmfiykdvli),0) from stkhrk
     where sil=0 and depkod=@HRK_TANK_KOD and stkod=@HRK_STK_KOD AND stktip=@HRK_STK_TIP
     and islmtip in ('FATAKALS','FATMRALS') and (tarih+cast(saat as datetime))>=@HRK_MINTARIH
     and (tarih+cast(saat as datetime))<=@HRK_MAXTARIH
     end

     SET @HRK_KALANMIKTAR=(@HRK_ONCEKIMIK+@HRK_MALALIM)-(@HRK_SATISMIKTAR)

       INSERT @TB_TANK_STOK (TANK_KOD,TANK_AD,ONCEKIMIKTAR,MALALIM,MALALIMTUTAR,SATISMIKTAR,TESTMIKTAR,
       DIGERMIKTAR,KALANMIKTAR)
       VALUES (@HRK_TANK_KOD,@HRK_TANK_AD,@HRK_ONCEKIMIK,@HRK_MALALIM,@HRK_MALTUTAR,@HRK_SATISMIKTAR,@HRK_TESTMIKTAR,
   @HRK_DIGERMIKTAR,@HRK_KALANMIKTAR)

    FETCH NEXT FROM CRS_HRK INTO
     @HRK_TANK_KOD,@HRK_STK_KOD,@HRK_STK_TIP,@HRK_TANK_AD,@HRK_ONCEKIMIK,@HRK_MALALIM,@HRK_SATISMIKTAR,@HRK_TESTMIKTAR,
   @HRK_DIGERMIKTAR,@HRK_KALANMIKTAR,@HRK_MINTARIH,@HRK_MAXTARIH
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */



  RETURN

end

================================================================================
