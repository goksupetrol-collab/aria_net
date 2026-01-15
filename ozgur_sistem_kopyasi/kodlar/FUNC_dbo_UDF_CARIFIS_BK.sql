-- Function: dbo.UDF_CARIFIS_BK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.698391
================================================================================

CREATE FUNCTION [dbo].UDF_CARIFIS_BK
(@CARI_TIP   VARCHAR(20),
@CARI_KOD    VARCHAR(30),
@AK_TIP      VARCHAR(30),
@RAP_ID      INT,
@CH_TARIH       INT,
@BAS_TARIH	 DATETIME,
@BIT_TARIH    DATETIME)
RETURNS
    @TB_CARI_FIS_EKSTRE TABLE (
    Firmano     int,
    Cartip_id   int, 
    Car_id     int,
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    VERID       FLOAT,
    RAPID       INT,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20) COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    TUTAR       FLOAT,
    ISK_FATTUT  FLOAT,
    ISK_FISTUT  FLOAT)
AS
BEGIN
 
 DECLARE @ISK_FATYUZDE FLOAT
 DECLARE @ISK_FISYUZDE FLOAT
 DECLARE @HRK_CARI_UNVAN VARCHAR(100)
 declare @CariTip_Id   int
 declare @Cari_Id   int
 
 
 select 
 @CariTip_Id=tip_id,
 @Cari_Id=id,
 @HRK_CARI_UNVAN=ck.ad,
 @ISK_FATYUZDE=fat_iskonto,
 @ISK_FISYUZDE=fis_iskonto
 from Genel_Kart as ck with (nolock)
  where kod=@CARI_KOD and ck.cartp=@CARI_TIP
  
  
  

  if ((@AK_TIP='CH') or (@AK_TIP='TEK_CH'))  AND (@CH_TARIH=0) 
     INSERT @TB_CARI_FIS_EKSTRE
      (Firmano,Cartip_id,Car_id,CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT v.firmano,@CariTip_Id,@Cari_Id,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop) else -1*(toptut-isktop) end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FATYUZDE/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FISYUZDE/100) else 0 end
       FROM veresimas as v with (nolock) 
       where cartip=@CARI_TIP and carkod=@CARI_KOD
       and v.sil=0  and v.aktip in ('BK','BL')
       and  v.varok=1 and isnull(devir,0)=0
       ORDER BY tarih
       
       
    if ((@AK_TIP='CH') or (@AK_TIP='TEK_CH'))  AND (@CH_TARIH=1) 
     INSERT @TB_CARI_FIS_EKSTRE
      (Firmano,Cartip_id,Car_id,CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT v.firmano,@CariTip_Id,@Cari_Id,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop) else -1*(toptut-isktop) end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FATYUZDE/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FISYUZDE/100) else 0 end
       FROM veresimas as v with (nolock) 
       where cartip=@CARI_TIP and carkod=@CARI_KOD
       AND tarih>=@BAS_TARIH AND tarih<=@BIT_TARIH
       and v.sil=0  and v.aktip in ('BK','BL')
       and  v.varok=1 and isnull(devir,0)=0
       ORDER BY tarih    
       


    if ((@AK_TIP='FT') or (@AK_TIP='TEK_FT')) AND (@CH_TARIH=0) 
     INSERT @TB_CARI_FIS_EKSTRE
      (Firmano,Cartip_id,Car_id,CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT v.firmano,@CariTip_Id,@Cari_Id,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop) else -1*(toptut-isktop) end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FATYUZDE/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FISYUZDE/100) else 0 end
       FROM veresimas as v with (nolock) 
       where cartip=@CARI_TIP and carkod=@CARI_KOD
       and v.sil=0 and v.fistip='FISVERSAT'
       and v.aktip in ('BK','BL')
       and  v.varok=1 and isnull(devir,0)=0
       ORDER BY tarih

     if ((@AK_TIP='FT') or (@AK_TIP='TEK_FT')) AND (@CH_TARIH=1) 
     INSERT @TB_CARI_FIS_EKSTRE
      (Firmano,Cartip_id,Car_id,CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT v.firmano,@CariTip_Id,@Cari_Id,
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop) else -1*(toptut-isktop) end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FATYUZDE/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  (toptut-isktop)*(@ISK_FISYUZDE/100) else 0 end
       FROM veresimas as v with (nolock) 
       where cartip=@CARI_TIP and carkod=@CARI_KOD
        AND tarih>=@BAS_TARIH AND tarih<=@BIT_TARIH
       and v.sil=0 and v.fistip='FISVERSAT'
       and v.aktip in ('BK','BL')
       and  v.varok=1 and isnull(devir,0)=0
       ORDER BY tarih
  
          
       

       if @RAP_ID>0
          Delete from @TB_CARI_FIS_EKSTRE where RAPID !=@RAP_ID





  RETURN

END

================================================================================
