-- Function: dbo.POS_GRUP_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.666270
================================================================================

CREATE FUNCTION [dbo].POS_GRUP_TOPLAM
(@firmano int,
@POS_IN VARCHAR(4000),
@TARINDEX INT,@TARIH1 DATETIME,@TARIH2 DATETIME,
@AKTIPIN VARCHAR(20),
@PERTIP INT)
RETURNS
  @TB_POS_RAPOR_TOPLAM TABLE (
    BANKA_KOD         VARCHAR(50) COLLATE Turkish_CI_AS,
    BANKA_AD          VARCHAR(150)  COLLATE Turkish_CI_AS,
    POS_KOD           VARCHAR(50)  COLLATE Turkish_CI_AS,
    POS_ADI           VARCHAR(150)  COLLATE Turkish_CI_AS,
    POSTUTAR          FLOAT,
    KOMISYONTUTAR     FLOAT,
    HESGECTUTAR       FLOAT,
    PERIYOT_ACK       VARCHAR(50) COLLATE Turkish_CI_AS)
AS
BEGIN


   DECLARE @TB_POS_EXTRA_TOPLAM TABLE (
    BANKA_KOD         VARCHAR(50) COLLATE Turkish_CI_AS,
    BANKA_AD          VARCHAR(100)  COLLATE Turkish_CI_AS,
    POS_KOD           VARCHAR(50)  COLLATE Turkish_CI_AS,
    POS_ADI           VARCHAR(150)  COLLATE Turkish_CI_AS,
    POSTUTAR          FLOAT,
    KOMISYONTUTAR     FLOAT,
    HESGECTUTAR       FLOAT,
    TAR               VARCHAR(20) COLLATE Turkish_CI_AS,
    HAFTA             INT,
    AY                INT,
    YIL               INT)






 DECLARE @EKSTRE_TEMP TABLE (
 pos_kod      varchar(50) COLLATE Turkish_CI_AS )

declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@POS_IN)) > 0)
 BEGIN
  set @POS_IN = @POS_IN + ','
 END

 while patindex('%,%' , @POS_IN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @POS_IN)
   select @array_value = left(@POS_IN, @separator_position - 1)

  Insert @EKSTRE_TEMP
  Values (@array_value)

   select @POS_IN = stuff(@POS_IN, 1, @separator_position, '')
 end
/*---------------------------------------------------- */
  IF @TARINDEX=0 /*islem tarihi */
  begin

 if @firmano<=0
  INSERT @TB_POS_EXTRA_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR,TAR,HAFTA,AY,YIL)
  select h.bankod,bk.ad,h.poskod,pk.ad,sum(h.giren),
  sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz))),
  convert(varchar,h.tarih,104),
  case when datepart(wk,(h.tarih-1))=53 then
  1 else datepart(wk,(h.tarih-1)) end,
  MONTH(h.tarih),YEAR(h.tarih)
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and H.PosIsle=1
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.tarih>=@TARIH1 and h.tarih <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
  group by h.bankod,bk.ad,h.poskod,pk.ad,h.tarih
  order by h.tarih
  
  
  if @firmano>0
  INSERT @TB_POS_EXTRA_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
  KOMISYONTUTAR,HESGECTUTAR,TAR,HAFTA,AY,YIL)
  select h.bankod,bk.ad,h.poskod,pk.ad,sum(h.giren),
  sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
  sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz))),
  convert(varchar,h.tarih,104),
  case when datepart(wk,(h.tarih-1))=53 then
  1 else datepart(wk,(h.tarih-1)) end,
  MONTH(h.tarih),YEAR(h.tarih)
  FROM  poshrk as h with (nolock)
  inner join poskart as pk with (nolock) on pk.kod=h.poskod and H.PosIsle=1 and h.firmano=@firmano
  left join bankakart as bk with (nolock) on bk.kod=pk.bankod
  where h.poskod in (select * from @EKSTRE_TEMP)
  and h.sil=0 and h.tarih>=@TARIH1 and h.tarih <= @TARIH2
  and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
  group by h.bankod,bk.ad,h.poskod,pk.ad,h.tarih
  order by h.tarih
  
  end
  
  IF @TARINDEX=1 /*vade tarihi */
  begin
  if @firmano<=0
    INSERT @TB_POS_EXTRA_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
    KOMISYONTUTAR,HESGECTUTAR,TAR,HAFTA,AY,YIL)
    select h.bankod,bk.ad,h.poskod,pk.ad,sum(h.giren),
    sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
    sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz))),
    convert(varchar,h.vadetar,104),
    case when datepart(wk,(h.vadetar-1))=53 then
    1 else datepart(wk,(h.vadetar-1)) end,
    MONTH(h.vadetar),YEAR(h.vadetar)
    FROM  poshrk as h with (nolock)
    inner join poskart as pk with (nolock) on pk.kod=h.poskod and H.PosIsle=1
    left join bankakart as bk with (nolock) on bk.kod=pk.bankod
    where h.poskod in (select * from @EKSTRE_TEMP)
    and h.sil=0 and h.vadetar>=@TARIH1 and h.vadetar <= @TARIH2
    and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
    group by h.bankod,bk.ad,h.poskod,pk.ad,h.vadetar
    order by h.vadetar
    
   if @firmano>0
    INSERT @TB_POS_EXTRA_TOPLAM (BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
    KOMISYONTUTAR,HESGECTUTAR,TAR,HAFTA,AY,YIL)
    select h.bankod,bk.ad,h.poskod,pk.ad,sum(h.giren),
    sum((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz)),
    sum(h.giren-((h.giren*h.bankomyuz)+((h.giren*h.bankomyuz)*h.extrakomyuz)+(h.giren*h.ekkomyuz))),
    convert(varchar,h.vadetar,104),
    case when datepart(wk,(h.vadetar-1))=53 then
    1 else datepart(wk,(h.vadetar-1)) end,
    MONTH(h.vadetar),YEAR(h.vadetar)
    FROM  poshrk as h with (nolock)
    inner join poskart as pk with (nolock) on pk.kod=h.poskod and H.PosIsle=1 and h.firmano=@firmano
    left join bankakart as bk with (nolock) on bk.kod=pk.bankod
    where h.poskod in (select * from @EKSTRE_TEMP)
    and h.sil=0 and h.vadetar>=@TARIH1 and h.vadetar <= @TARIH2
    and h.aktip in (SELECT * FROM dbo.CsvToSTR (@AKTIPIN))
    group by h.bankod,bk.ad,h.poskod,pk.ad,h.vadetar
    order by h.vadetar 
    
  end
  

  IF @PERTIP=0 /*TUMU */
   BEGIN
      INSERT INTO @TB_POS_RAPOR_TOPLAM (PERIYOT_ACK,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
      KOMISYONTUTAR,HESGECTUTAR)
      SELECT TAR,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
      KOMISYONTUTAR,HESGECTUTAR FROM @TB_POS_EXTRA_TOPLAM
  END
  
  
   IF @PERTIP=1 /*GUNLUK */
   BEGIN
      INSERT INTO @TB_POS_RAPOR_TOPLAM (PERIYOT_ACK,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
      KOMISYONTUTAR,HESGECTUTAR)
      SELECT TAR,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,SUM(POSTUTAR),
      SUM(KOMISYONTUTAR),SUM(HESGECTUTAR) FROM @TB_POS_EXTRA_TOPLAM
      GROUP BY BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,TAR
      ORDER BY TAR
  END
  
  
  
  
   IF @PERTIP=2 /*HAFTALIK */
   BEGIN
      INSERT INTO @TB_POS_RAPOR_TOPLAM (PERIYOT_ACK,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
      KOMISYONTUTAR,HESGECTUTAR)
      SELECT CAST(YIL as varchar)+'-'+CAST(HAFTA as varchar),BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,SUM(POSTUTAR),
      SUM(KOMISYONTUTAR),SUM(HESGECTUTAR) FROM @TB_POS_EXTRA_TOPLAM
      GROUP BY BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,HAFTA,YIL
      ORDER BY CAST(HAFTA as varchar)+'-'+CAST(HAFTA as varchar)
  END
  
   IF @PERTIP=3 /*AYLIK */
   BEGIN
      INSERT INTO @TB_POS_RAPOR_TOPLAM (PERIYOT_ACK,BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,POSTUTAR,
      KOMISYONTUTAR,HESGECTUTAR)
      SELECT CAST(YIL as varchar)+'-'+
       (CASE AY
           WHEN 1 THEN 'OCAK'
           WHEN 2 THEN 'ŞUBAT'
           WHEN 3 THEN 'MART'
           WHEN 4 THEN 'NİSAN'
           WHEN 5 THEN 'MAYIS'
           WHEN 6 THEN 'HAZİRAN'
           WHEN 7 THEN 'TEMMUZ'
           WHEN 8 THEN 'AĞUSTOS'
           WHEN 9 THEN 'EYLÜL'
           WHEN 10 THEN 'EKİM'
           WHEN 11 THEN 'KASIM'
           WHEN 12 THEN 'ARALIK'
           end),
           BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,SUM(POSTUTAR),
      SUM(KOMISYONTUTAR),SUM(HESGECTUTAR) FROM @TB_POS_EXTRA_TOPLAM
      GROUP BY BANKA_KOD,BANKA_AD,POS_KOD,POS_ADI,AY,YIL
      ORDER BY CAST(YIL as varchar)+'-'+CAST(AY as varchar)

  END
  
  


  RETURN

end

================================================================================
