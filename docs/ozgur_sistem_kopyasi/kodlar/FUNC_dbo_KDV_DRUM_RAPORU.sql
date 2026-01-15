-- Function: dbo.KDV_DRUM_RAPORU
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.663531
================================================================================

CREATE FUNCTION [dbo].KDV_DRUM_RAPORU (
@firmano int,	
@BASTAR DATETIME,
@BITTAR DATETIME,
@FATTIPIN VARCHAR(2000),
@ZTIPIN VARCHAR(100),
@DEVIR INT)
RETURNS
  @TB_KDV_DRUM_EKSTRE TABLE (
    ACK           VARCHAR(100)  COLLATE Turkish_CI_AS,
    KDV_ORAN      FLOAT,
    MATRAH        FLOAT,
    KDV_TUTAR     FLOAT,
    KDV_ODENEN    FLOAT,
    KDV_TAHSIL    FLOAT,
    TIP           VARCHAR(1)  COLLATE Turkish_CI_AS )
BEGIN

  DECLARE @EKSTRE_TEMP TABLE (
  FirmaNo		  int,
  TIP            VARCHAR(1)  COLLATE Turkish_CI_AS,
  ACK            VARCHAR(100)  COLLATE Turkish_CI_AS,
  TARIH          DATETIME,
  KDV_ORAN       FLOAT,
  MATRAH         FLOAT,
  KDV_TUTAR      FLOAT)



  insert into @EKSTRE_TEMP (FirmaNo,TIP,ACK,TARIH,MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,t.gc,r.ack,m.tarih,((h.brmfiy-(h.satisktut+h.genisktut))*mik),h.kdvtut*mik,h.kdvyuz
  from faturahrklistesi as h
  inner join faturamas as m on m.fatid=h.fatid
  and h.sil=0 and m.sil=0 /*and h.satirtip='S' */
  inner join fattip as t on 
  t.kod=m.fattip and t.tip='FAT' 
  inner join raporlar as r on t.kod=r.rapkod
  and m.fatrap_id=r.id   
  where h.kdvyuz>0 and m.fatrap_id
  in (select * from CsvToSTR(@FATTIPIN))
  
  
  if @ZTIPIN<>''
  insert into @EKSTRE_TEMP (FirmaNo,TIP,ACK,TARIH,MATRAH,KDV_TUTAR,KDV_ORAN)
  SELECT m.firmano,'C','Z RAPOR',m.tarih,((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  (h.brmfiy*h.miktar)-((h.brmfiy*h.miktar)/(1+h.kdvyuz)),
  h.kdvyuz
  from zraporhrk as h
  inner join zrapormas as m on m.zrapid=h.zrapid
  and h.sil=0 and m.sil=0 
  where h.kdvyuz>0 and m.zraptip in (select * from CsvToSTR(@ZTIPIN))


  if @DEVIR=1 and @firmano=0
   insert into @TB_KDV_DRUM_EKSTRE (ACK,MATRAH,
   KDV_TUTAR,KDV_ORAN,
   KDV_ODENEN,KDV_TAHSIL,TIP)
   select 'ÖNCEKİ DÖNEMDEN DEVREDEN KDV',
   isnull(SUM(MATRAH),0),isnull(SUM(KDV_TUTAR),0),
   (KDV_ORAN*100),
   sum(case when TIP='G' THEN KDV_TUTAR ELSE 0 END),
   sum(case when TIP='C' THEN KDV_TUTAR ELSE 0 END),
   TIP
   from @EKSTRE_TEMP
   where TARIH<@BASTAR
   group by TIP,KDV_ORAN
   
   
   if @DEVIR=1 and @firmano>0
   insert into @TB_KDV_DRUM_EKSTRE (ACK,MATRAH,
   KDV_TUTAR,KDV_ORAN,
   KDV_ODENEN,KDV_TAHSIL,TIP)
   select 'ÖNCEKİ DÖNEMDEN DEVREDEN KDV',
   isnull(SUM(MATRAH),0),isnull(SUM(KDV_TUTAR),0),
   (KDV_ORAN*100),
   sum(case when TIP='G' THEN KDV_TUTAR ELSE 0 END),
   sum(case when TIP='C' THEN KDV_TUTAR ELSE 0 END),
   TIP
   from @EKSTRE_TEMP
   where Firmano in (@firmano,0)
   and TARIH<@BASTAR
   group by TIP,KDV_ORAN
   
   
   
   
   
   if @firmano=0
   insert into @TB_KDV_DRUM_EKSTRE (ACK,MATRAH,
   KDV_TUTAR,KDV_ORAN,
   KDV_ODENEN,KDV_TAHSIL,TIP)
   select ACK,
   isnull(SUM(MATRAH),0),isnull(SUM(KDV_TUTAR),0),
   (KDV_ORAN*100),
   sum(case when TIP='G' THEN KDV_TUTAR ELSE 0 END),
   sum(case when TIP='C' THEN KDV_TUTAR ELSE 0 END),
   TIP
   from @EKSTRE_TEMP
   where TARIH>=@BASTAR and TARIH <=@BITTAR
   group by TIP,ACK,KDV_ORAN
   

   if @firmano>0
   insert into @TB_KDV_DRUM_EKSTRE (ACK,MATRAH,
   KDV_TUTAR,KDV_ORAN,
   KDV_ODENEN,KDV_TAHSIL,TIP)
   select ACK,
   isnull(SUM(MATRAH),0),isnull(SUM(KDV_TUTAR),0),
   (KDV_ORAN*100),
   sum(case when TIP='G' THEN KDV_TUTAR ELSE 0 END),
   sum(case when TIP='C' THEN KDV_TUTAR ELSE 0 END),
   TIP
   from @EKSTRE_TEMP
   where Firmano in (@firmano,0)
   and TARIH>=@BASTAR and TARIH <=@BITTAR
   group by TIP,ACK,KDV_ORAN

 /*   insert into @TB_KDV_DRUM_EKSTRE (TIP,MATRAH,KDV_TUTAR,KDV_ORAN) */
 /*  select TIP,MATRAH,KDV_TUTAR,KDV_ORAN from @EKSTRE_TEMP */

  
 RETURN
  
END

================================================================================
