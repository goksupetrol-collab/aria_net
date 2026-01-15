-- Function: dbo.UDF_KDV_GRUP_DRUM_RAPORU
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.735679
================================================================================

CREATE FUNCTION [dbo].[UDF_KDV_GRUP_DRUM_RAPORU] (
@firmano int,	
@BASTAR DATETIME,
@BITTAR DATETIME,
@FATTIPIN VARCHAR(2000),
@ZTIPIN VARCHAR(100),
@DEVIR INT)
RETURNS
  @TB_KDV_DURUM_EKSTRE TABLE (
    TIP            VARCHAR(1)  COLLATE Turkish_CI_AS,
    TIP_AD         VARCHAR(10)  COLLATE Turkish_CI_AS,  
    KDV_ORAN       FLOAT,
    MATRAH         FLOAT,
    KDV_TUTAR      FLOAT,
    IADE_MATRAH    FLOAT,
    IADE_KDV_TUTAR FLOAT ,
    TOPLAM_MATRAH    FLOAT,
    TOPLAM_KDV_TUTAR FLOAT  )
BEGIN

  DECLARE @EKSTRE_TEMP TABLE (
  FirmaNo		  int,
  TIP            VARCHAR(1)  COLLATE Turkish_CI_AS,
  TUR            INT,
  TARIH          DATETIME,
  KDV_ORAN       FLOAT,
  MATRAH         FLOAT,
  KDV_TUTAR      FLOAT)



  insert into @EKSTRE_TEMP (FirmaNo,TARIH,TIP,TUR,MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,m.tarih,t.gc,T.tur_id,
  ((h.brmfiy-(h.satisktut+h.genisktut))*mik),h.kdvtut*mik,h.kdvyuz
  from faturahrklistesi as h WITH (NOLOCK)
  inner join faturamas as m WITH (NOLOCK) on m.fatid=h.fatid
  and h.sil=0 and m.sil=0 /*and h.satirtip='S' */
  inner join fattip as t WITH (NOLOCK) on 
  t.kod=m.fattip and t.tip='FAT' 
  inner join raporlar as r WITH (NOLOCK) on t.kod=r.rapkod
  and m.fatrap_id=r.id   
  where m.fatrap_id in (select * from CsvToSTR(@FATTIPIN))
  AND m.tarih >=@BASTAR and m.tarih <=@BITTAR
  
  
  if @ZTIPIN<>''
  insert into @EKSTRE_TEMP (FirmaNo,TARIH,TIP,TUR,MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,m.tarih,'C',4,((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  (h.brmfiy*h.miktar)-((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  h.kdvyuz
  from zraporhrk as h WITH (NOLOCK)
  inner join zrapormas as m WITH (NOLOCK) on m.zrapid=h.zrapid
  and h.sil=0 and m.sil=0 and m.tarih >=@BASTAR and m.tarih <=@BITTAR
  where m.zraptip in (select * from CsvToSTR(@ZTIPIN))


   
   if @firmano=0
   begin
   
     insert into @TB_KDV_DURUM_EKSTRE (TIP,MATRAH,KDV_TUTAR,
     KDV_ORAN,IADE_MATRAH,IADE_KDV_TUTAR)
     select TIP,0,0,(KDV_ORAN*100),0,0     
     from @EKSTRE_TEMP
     group by TIP,KDV_ORAN
   
   
     update @TB_KDV_DURUM_EKSTRE set 
     MATRAH=dt.matrah,
     KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where TIP='G' and TUR=1  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='G' 
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     IADE_MATRAH=dt.matrah,
     IADE_KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where TIP='G' and TUR=3  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='G' 
     
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     MATRAH=dt.matrah,
     KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where TIP='C' and TUR in (2,4)  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='C'      
 
        
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     IADE_MATRAH=dt.matrah,
     IADE_KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where TIP='C' and TUR=3  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='C' 
     
     
     
   end  
     

   if @firmano>0
   begin
   
     insert into @TB_KDV_DURUM_EKSTRE (TIP,MATRAH,KDV_TUTAR,
     KDV_ORAN,IADE_MATRAH,IADE_KDV_TUTAR)
     select TIP,0,0,(KDV_ORAN*100),0,0     
     from @EKSTRE_TEMP
     where Firmano in (@firmano,0)
     group by TIP,KDV_ORAN
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     MATRAH=dt.matrah,
     KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where Firmano in (@firmano,0) and 
     TIP='G' and TUR=1  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='G' 
     
     
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     IADE_MATRAH=dt.matrah,
     IADE_KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where Firmano in (@firmano,0) and 
     TIP='G' and TUR=3  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='G' 
     


     update @TB_KDV_DURUM_EKSTRE set 
     MATRAH=dt.matrah,
     KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where Firmano in (@firmano,0) and 
     TIP='C' and TUR in (2,4)  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='C' 
     
     
     
     update @TB_KDV_DURUM_EKSTRE set 
     IADE_MATRAH=dt.matrah,
     IADE_KDV_TUTAR=dt.kdv_tutar
     from @TB_KDV_DURUM_EKSTRE as t join (
     select isnull(SUM(MATRAH),0) matrah,
     isnull(SUM(KDV_TUTAR),0) kdv_tutar,(KDV_ORAN*100) kdv from 
     @EKSTRE_TEMP where Firmano in (@firmano,0) and 
     TIP='C' and TUR=3  group by TIP,KDV_ORAN ) dt on 
     dt.kdv=t.KDV_ORAN and t.TIP='C' 
   
   
   
  
   
 
    end
 
 
  update @TB_KDV_DURUM_EKSTRE
   set 
   TOPLAM_MATRAH=MATRAH+IADE_MATRAH,
   TOPLAM_KDV_TUTAR=KDV_TUTAR+IADE_KDV_TUTAR,
   TIP_AD=CASE WHEN TIP='G' THEN 'ALIŞ' ELSE 'SATIŞ' END
   
 
 
  
 RETURN
  
END

================================================================================
