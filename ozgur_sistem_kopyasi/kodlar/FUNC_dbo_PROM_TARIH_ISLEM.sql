-- Function: dbo.PROM_TARIH_ISLEM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.666879
================================================================================

CREATE FUNCTION [dbo].PROM_TARIH_ISLEM 
(
@FirmaNo    int,
@RapTip		int,
@Bas_Tar	Datetime,
@Bit_Tar	Datetime)
RETURNS
    @TB_PROM_ISLEM TABLE (
    FIRMA_NO		   INT,
    FIRMA_UNVAN	   VARCHAR(200) COLLATE Turkish_CI_AS,
    TARIH			DATETIME,
    CARITIP_ID     INT,
    CARI_ID        INT,
    CARI_KOD	    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN      VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_PLAKA      VARCHAR(50) COLLATE Turkish_CI_AS,
    STOKTIP_ID	   INT,
    STOK_ID         INT,
    STOK_KOD        VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(150) COLLATE Turkish_CI_AS,
    BELGE_NO       VARCHAR(50) COLLATE Turkish_CI_AS,
    BIRIM_FIYAT	   FLOAT,
    MIKTAR		   FLOAT,
    TUTAR		   FLOAT,
    PUAN		   FLOAT,
    ISLEM_SAYI     INT)
AS
BEGIN

   DECLARE  @TM_PROM_ISLEM TABLE (
    FIRMA_NO		INT,
    FIRMA_UNVAN	    VARCHAR(200) COLLATE Turkish_CI_AS,
    TARIH			DATETIME,
    CARITIP_ID      INT,
    CARI_ID         INT,
    CARI_KOD	    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN      VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_PLAKA      VARCHAR(50) COLLATE Turkish_CI_AS,
    STOKTIP_ID	    INT,
    STOK_ID         INT,
    STOK_KOD        VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(150) COLLATE Turkish_CI_AS,
    BELGE_NO       VARCHAR(50) COLLATE Turkish_CI_AS,
    BIRIM_FIYAT	    FLOAT,
    MIKTAR		    FLOAT,
    TUTAR		    FLOAT,
    PUAN		    FLOAT,
    ISLEM_SAYI      INT)




   if @RapTip=0 /*urun bazli */
   begin
    insert into @TM_PROM_ISLEM
    (FIRMA_NO,FIRMA_UNVAN,
    CARITIP_ID,CARI_ID,CARI_KOD,CARI_UNVAN,
    CARI_PLAKA,
    STOKTIP_ID,STOK_ID,STOK_KOD,STOK_AD,
    BIRIM_FIYAT,MIKTAR,TUTAR,PUAN,ISLEM_SAYI)
    Select h.firmano,'',
     0,0,'','','',
     stktip_id,stk_id,stkkod,'',
     0,/*h.Brm_Fiyat_Kdvli, */
     -1*sum(h.Mik_Giren-h.Mik_Cikan),
     -1*sum((h.Mik_Giren-h.Mik_Cikan)*h.Brm_Fiyat_Kdvli),
     SUM(h.Puan_Giren),
     count(h.Stk_id)
     from  Prom_Puan_Hrk as h 
     where h.sil=0 and stktip_id>0 and 
     tarih>=@Bas_Tar and tarih<=@Bit_Tar
     group by firmano,stktip_id,stk_id,stkkod
    end
    

   if @RapTip=1 /*musteri bazli */
   begin
    insert into @TM_PROM_ISLEM
    (FIRMA_NO,FIRMA_UNVAN,
    CARITIP_ID,CARI_ID,CARI_KOD,CARI_UNVAN,
    CARI_PLAKA,
    STOKTIP_ID,STOK_ID,STOK_KOD,STOK_AD,
    BIRIM_FIYAT,MIKTAR,TUTAR,PUAN,ISLEM_SAYI)
    Select firmano,'',
    h.Cartip_id,h.Car_id,'','',h.Car_Plaka,
    0,0,'','',0,/*h.Brm_Fiyat_Kdvli, */
    -1*sum(h.Mik_Giren-h.Mik_Cikan),
    -1*sum((h.Mik_Giren-h.Mik_Cikan)*h.Brm_Fiyat_Kdvli),
    SUM(h.Puan_Giren),
    count(h.Cartip_id)
    from  Prom_Puan_Hrk as h 
    where h.sil=0 and Cartip_id>0 and 
    tarih>=@Bas_Tar and tarih<=@Bit_Tar
    group by h.firmano,h.Cartip_id,h.Car_id,h.Car_Plaka
   end
   
   
   
   if @RapTip=2 /*Plaka */
   begin
    insert into @TM_PROM_ISLEM
    (FIRMA_NO,FIRMA_UNVAN,TARIH,
    CARITIP_ID,CARI_ID,CARI_KOD,CARI_UNVAN,
    CARI_PLAKA,
    STOKTIP_ID,STOK_ID,STOK_KOD,STOK_AD,BELGE_NO,
    BIRIM_FIYAT,MIKTAR,TUTAR,PUAN,ISLEM_SAYI)
    Select firmano,'',H.Tarih,
    h.Cartip_id,h.Car_id,'','',h.Car_Plaka,
    h.Stktip_id,h.Stk_id,h.Stkkod,'',h.BelNo,0,/*h.Brm_Fiyat_Kdvli, */
    -1*(h.Mik_Giren-h.Mik_Cikan),
    -1*((h.Mik_Giren-h.Mik_Cikan)*h.Brm_Fiyat_Kdvli),
    (h.Puan_Giren-h.Puan_Cikan),
    1
    from  Prom_Puan_Hrk as h 
    where h.sil=0 and Cartip_id>0 and 
    tarih>=@Bas_Tar and tarih<=@Bit_Tar
   
   end
   
   

  
   if @FirmaNo>0
    delete from @TM_PROM_ISLEM where FIRMA_NO<>@FirmaNo


   update @TM_PROM_ISLEM 
   set FIRMA_UNVAN=dt.ad from @TM_PROM_ISLEM t
   join (select id,ad from Firma) dt
   on dt.id=t.FIRMA_NO 

  if (@RapTip=0) OR (@RapTip=2)
   update @TM_PROM_ISLEM set STOK_AD=dt.ad from @TM_PROM_ISLEM t
   join (select tip_id,id,kod,ad from stokkart) dt
   on dt.id=STOK_ID and dt.tip_id=t.STOKTIP_ID
   
   if (@RapTip=1) OR (@RapTip=2)
   update @TM_PROM_ISLEM set 
   CARI_KOD=dt.kod,
   CARI_UNVAN=dt.Unvan from @TM_PROM_ISLEM t
   join (select CarTip_id,id,kod,Unvan from Genel_Cari_Kart) dt
   on dt.id=CARI_ID and dt.CarTip_id=t.CARITIP_ID
   
  insert @TB_PROM_ISLEM (
  FIRMA_NO,FIRMA_UNVAN,TARIH,
  CARITIP_ID,CARI_ID,CARI_KOD,CARI_UNVAN,
  CARI_PLAKA,
  STOKTIP_ID,STOK_ID,
  STOK_KOD,STOK_AD,BELGE_NO,
  BIRIM_FIYAT,MIKTAR,TUTAR,
  PUAN,ISLEM_SAYI)
  select FIRMA_NO,FIRMA_UNVAN,TARIH,
  CARITIP_ID,CARI_ID,CARI_KOD,CARI_UNVAN,
  CARI_PLAKA,
  STOKTIP_ID,STOK_ID,STOK_KOD,STOK_AD,BELGE_NO,
 /* BIRIM_FIYAT, */
  case when (MIKTAR)>0 then (TUTAR)/(MIKTAR)
  else (BIRIM_FIYAT) end,  
  MIKTAR,TUTAR,PUAN,
  ISLEM_SAYI from @TM_PROM_ISLEM
  ORDER BY CARI_UNVAN,CARI_PLAKA
  



 RETURN


END

================================================================================
