-- Function: dbo.UDF_VAR_TANK_STOK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.796360
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_TANK_STOK (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TANK_STOK TABLE (
    TANK_KOD            VARCHAR(20),
    TANK_AD             VARCHAR(50),
    ONCEKIMIKTAR        FLOAT,
    ONCEKITUTAR         FLOAT,
    MALALIM             FLOAT,
    MALALIMTUTAR        FLOAT,
    SATISMIKTAR         FLOAT,
    TESTMIKTAR          FLOAT,
    TRANSFER_CKS_MIKTAR FLOAT,
    TRANSFER_GRS_MIKTAR FLOAT,
    DIGER_GRS_MIKTAR    FLOAT,
    DIGER_CKS_MIKTAR    FLOAT,
    KALANMIKTAR         FLOAT,
    KALANTUTAR          FLOAT)
AS
BEGIN

  DECLARE @HRK_VERNO 				FLOAT
  DECLARE @HRK_TANK_KOD             VARCHAR(30)
  DECLARE @HRK_TANK_AD 				VARCHAR(30)
  DECLARE @HRK_STK_KOD 				VARCHAR(30)
  DECLARE @HRK_STK_TIP 				VARCHAR(10)
  DECLARE @HRK_ONCEKIMIK 			FLOAT
  DECLARE @HRK_MALALIM 				FLOAT
  DECLARE @HRK_SATISMIKTAR 			FLOAT
  DECLARE @HRK_TESTMIKTAR 			FLOAT
  DECLARE @TRANSFER_CKS_MIKTAR 		FLOAT
  DECLARE @TRANSFER_GRS_MIKTAR 		FLOAT
  DECLARE @HRK_DIGER_GRS_MIKTAR 	FLOAT
  DECLARE @HRK_DIGER_CKS_MIKTAR 	FLOAT
  DECLARE @HRK_KALANMIKTAR 			FLOAT
  DECLARE @HRK_MALTUTAR    			FLOAT
  DECLARE @HRK_BRMFIYAT    			FLOAT


  DECLARE @HRK_MINTARIH DATETIME
  DECLARE @HRK_MAXTARIH DATETIME

    DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    select ps.kod,ps.stkod,ps.stktip,st.ad,
    0,0,
    sum(ps.satmik),
    sum(ps.testmik),
    isnull(sum(PS.transfer_cks_mik),0),
    isnull(sum(PS.transfer_grs_mik),0),
    0,0,
    case when sum(ps.satmik)>0 then
    sum(PS.satmik*ps.brimfiy)/sum(ps.satmik) else 0 end,
    min(pm.tarih+cast(pm.saat as datetime)),
    max(pm.kaptar+cast(pm.kapsaat as datetime))
    FROM  pomvarditank as ps with (nolock)
    inner join pomvardimas as pm with (nolock) on ps.varno=pm.varno and pm.sil=0
    inner join tankkart as st with (nolock) on st.kod=ps.kod
    where ps.varno in (select * from CsvToInt_Max(@VARNIN))
    and ps.sil=0 group by ps.kod,st.ad,ps.stkod,ps.stktip
    order by st.ad

   OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_TANK_KOD,@HRK_STK_KOD,@HRK_STK_TIP,@HRK_TANK_AD,
   @HRK_ONCEKIMIK,@HRK_MALALIM,
   @HRK_SATISMIKTAR,@HRK_TESTMIKTAR,@TRANSFER_CKS_MIKTAR,@TRANSFER_GRS_MIKTAR,
   @HRK_DIGER_GRS_MIKTAR,@HRK_DIGER_CKS_MIKTAR,@HRK_BRMFIYAT,
   @HRK_MINTARIH,@HRK_MAXTARIH

  WHILE @@FETCH_STATUS = 0
  BEGIN
     SET @HRK_MALALIM=0
     SET @HRK_MALTUTAR=0
     SET @HRK_ONCEKIMIK=0
     
      SELECT @HRK_ONCEKIMIK=SUM(giren-cikan) from stkhrk as h
      where h.sil=0 and h.depkod=@HRK_TANK_KOD 
      and (tarih+cast(saat as datetime))<@HRK_MINTARIH
     
     if @HRK_MAXTARIH is null
      begin

      SELECT @HRK_MALALIM=
      isnull(sum( case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT',
      'IRSAKALS','IRSMRALS','IRSYGALS') then giren-cikan else 0 end),0),
      @HRK_MALTUTAR=isnull(sum( case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT',
      'IRSAKALS','IRSMRALS','IRSYGALS') then 
      ((giren-cikan)*brmfiykdvli) else 0 end),0),
      
      @HRK_DIGER_GRS_MIKTAR=@TRANSFER_GRS_MIKTAR+
      isnull(sum( case when islmtip 
      not in ('POMSAYSAT','POMTRANS') then giren else 0 end),0),
      
      @HRK_DIGER_CKS_MIKTAR=@TRANSFER_CKS_MIKTAR+
      isnull(sum( case when islmtip 
      not in ('POMSAYSAT','POMTRANS') then cikan else 0 end),0)

      from stkhrk with (nolock)
      where sil=0 and depkod=@HRK_TANK_KOD and stkod=@HRK_STK_KOD 
      AND stktip=@HRK_STK_TIP
      and (tarih+cast(saat as datetime))>=@HRK_MINTARIH
      and (tarih+cast(saat as datetime))<=@HRK_MINTARIH

     end
     else
      begin
      
     SELECT @HRK_MALALIM=
      isnull(sum( case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT',
      'IRSAKALS','IRSMRALS','IRSYGALS') then giren-cikan else 0 end),0),
      @HRK_MALTUTAR=isnull(sum( case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT',
      'IRSAKALS','IRSMRALS','IRSYGALS') then 
      ((giren-cikan)*brmfiykdvli) else 0 end),0),
      @HRK_DIGER_GRS_MIKTAR=@TRANSFER_GRS_MIKTAR+
      isnull(sum( case when islmtip not in ('POMSAYSAT','POMTRANS') then giren else 0 end),0),
      
      @HRK_DIGER_CKS_MIKTAR=@TRANSFER_CKS_MIKTAR+
      isnull(sum( case when islmtip not in ('POMSAYSAT','POMTRANS') then cikan else 0 end),0)

      from stkhrk with (nolock)
      where sil=0 and depkod=@HRK_TANK_KOD and stkod=@HRK_STK_KOD AND stktip=@HRK_STK_TIP
      and (tarih+cast(saat as datetime))>=@HRK_MINTARIH
      and (tarih+cast(saat as datetime))<=@HRK_MAXTARIH
     end

     SET @HRK_KALANMIKTAR=(@HRK_ONCEKIMIK+@HRK_DIGER_GRS_MIKTAR)
      -(@HRK_SATISMIKTAR+@HRK_DIGER_CKS_MIKTAR)

       INSERT @TB_TANK_STOK (TANK_KOD,TANK_AD,ONCEKIMIKTAR,ONCEKITUTAR,
       MALALIM,MALALIMTUTAR,SATISMIKTAR,TESTMIKTAR,
       TRANSFER_CKS_MIKTAR,TRANSFER_GRS_MIKTAR,
       DIGER_GRS_MIKTAR,DIGER_CKS_MIKTAR,KALANMIKTAR,KALANTUTAR)
       VALUES (@HRK_TANK_KOD,@HRK_TANK_AD,@HRK_ONCEKIMIK,
       @HRK_ONCEKIMIK*@HRK_BRMFIYAT,
       @HRK_MALALIM,@HRK_MALTUTAR,@HRK_SATISMIKTAR,@HRK_TESTMIKTAR,
       @TRANSFER_CKS_MIKTAR,@TRANSFER_GRS_MIKTAR,
       @HRK_DIGER_GRS_MIKTAR,@HRK_DIGER_CKS_MIKTAR,@HRK_KALANMIKTAR,@HRK_KALANMIKTAR*@HRK_BRMFIYAT)

    FETCH NEXT FROM CRS_HRK INTO
     @HRK_TANK_KOD,@HRK_STK_KOD,@HRK_STK_TIP,@HRK_TANK_AD,@HRK_ONCEKIMIK,@HRK_MALALIM,
     @HRK_SATISMIKTAR,@HRK_TESTMIKTAR,@TRANSFER_CKS_MIKTAR,@TRANSFER_GRS_MIKTAR,
     @HRK_DIGER_GRS_MIKTAR,@HRK_DIGER_CKS_MIKTAR,@HRK_BRMFIYAT,@HRK_MINTARIH,@HRK_MAXTARIH
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  RETURN

end

================================================================================
