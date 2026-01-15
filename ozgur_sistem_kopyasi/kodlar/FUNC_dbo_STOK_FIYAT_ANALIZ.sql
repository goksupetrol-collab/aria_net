-- Function: dbo.STOK_FIYAT_ANALIZ
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.673623
================================================================================

CREATE FUNCTION [dbo].STOK_FIYAT_ANALIZ (
@STOK_TIP VARCHAR(10),
@STOK_KODIN VARCHAR (8000),
@FIYTIP   INT,
@KRITER   INT)
RETURNS
 @TB_STOKFIY_ANALIZ TABLE (
    STOK_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100) COLLATE Turkish_CI_AS,
    SATISFIYAT      FLOAT,
    ALISFIYAT       FLOAT,
    PARABIRIM         VARCHAR(20)  COLLATE Turkish_CI_AS)
 AS
 BEGIN

 DECLARE @TB_STOKFIY_TEMP TABLE (
    STOK_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(100) COLLATE Turkish_CI_AS,
    SATISFIYAT      FLOAT,
    ALISFIYAT       FLOAT,
    PARABIRIM         VARCHAR(20)  COLLATE Turkish_CI_AS)


 DECLARE @EKSTRE_IN TABLE (
 stkkod     varchar(30))

 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@STOK_KODIN)) > 0)
 BEGIN
  set @STOK_KODIN = @STOK_KODIN + ','
 END

 while patindex('%,%' , @STOK_KODIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @STOK_KODIN)
   select @array_value = left(@STOK_KODIN, @separator_position - 1)

  Insert @EKSTRE_IN
  Values (@array_value)

   select @STOK_KODIN = stuff(@STOK_KODIN, 1, @separator_position, '')
 end

  INSERT @TB_STOKFIY_TEMP
  (STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM)
  SELECT k.tip,k.kod,k.ad,
  CASE
  when @FIYTIP=1 and (K.sat1kdvtip='Dahil') then
  k.sat1fiy
  when (@FIYTIP=1) and (K.sat1kdvtip='Hariç') then
  k.sat1fiy*(1+(k.sat1kdv/100))
  when @FIYTIP=2 and (K.sat2kdvtip='Dahil') then
  k.sat2fiy
  when (@FIYTIP=2) and (K.sat2kdvtip='Hariç') then
  k.sat2fiy*(1+(k.sat2kdv/100))
  when @FIYTIP=3 and (K.sat3kdvtip='Dahil') then
  k.sat3fiy
  when (@FIYTIP=3) and (K.sat3kdvtip='Hariç') then
  k.sat3fiy*(1+(k.sat3kdv/100))
  when @FIYTIP=4 and (K.sat4kdvtip='Dahil') then
  k.sat4fiy
  when (@FIYTIP=4) and (K.sat4kdvtip='Hariç') then
  k.sat4fiy*(1+(k.sat4kdv/100)) end,
  CASE when K.alskdvtip='Dahil' then
  k.alsfiy
  when (K.alskdvtip='Hariç') then
  k.alsfiy*(1+(k.alskdv/100)) end,
  CASE
  WHEN @FIYTIP=1 then
  k.sat1pbrm
  WHEN @FIYTIP=2 then
  k.sat2pbrm
  WHEN @FIYTIP=3 then
  k.sat1pbrm
  WHEN @FIYTIP=4 then
  k.sat4pbrm end

  from stokkart k with (NOLOCK)
  where k.tip=@STOK_TIP and k.sil=0 and
  k.kod in (select * FROM @EKSTRE_IN)
  
  
  
  if @KRITER=0
  INSERT @TB_STOKFIY_ANALIZ
  (STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM)
  SELECT STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM
  FROM @TB_STOKFIY_TEMP WHERE ALISFIYAT>SATISFIYAT
  
  if @KRITER=1
  INSERT @TB_STOKFIY_ANALIZ
  (STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM)
  SELECT STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM
  FROM @TB_STOKFIY_TEMP WHERE SATISFIYAT=0


  if @KRITER=2
  INSERT @TB_STOKFIY_ANALIZ
  (STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM)
  SELECT STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM
  FROM @TB_STOKFIY_TEMP WHERE ALISFIYAT=SATISFIYAT


  if @KRITER=3
  INSERT @TB_STOKFIY_ANALIZ
  (STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM)
  SELECT STOK_TIP,STOK_KOD,STOK_AD,SATISFIYAT,ALISFIYAT,PARABIRIM
  FROM @TB_STOKFIY_TEMP WHERE ALISFIYAT<SATISFIYAT


RETURN
 
END

================================================================================
