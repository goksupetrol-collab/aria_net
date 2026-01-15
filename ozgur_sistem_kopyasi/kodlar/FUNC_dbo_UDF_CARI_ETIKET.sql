-- Function: dbo.UDF_CARI_ETIKET
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.692944
================================================================================

CREATE FUNCTION [dbo].UDF_CARI_ETIKET (
@firmano int,
@tip   varchar(20),
@carin VARCHAR(8000),
@bassayi int,
@satirsayi int)
RETURNS
  @TB_ADRES_ETIKET TABLE (
    CARI_KOD        VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN      VARCHAR(200) COLLATE Turkish_CI_AS,
    ADRES1          VARCHAR(100) COLLATE Turkish_CI_AS,
    ADRES2          VARCHAR(100) COLLATE Turkish_CI_AS,
    IL              VARCHAR(50) COLLATE Turkish_CI_AS,
    ILCE            VARCHAR(50) COLLATE Turkish_CI_AS,
    TEL				VARCHAR(50) COLLATE Turkish_CI_AS,
    CEP				VARCHAR(50) COLLATE Turkish_CI_AS)
AS
BEGIN

  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(200)
  DECLARE @HRK_ADRES1      VARCHAR(100)
  DECLARE @HRK_ADRES2      VARCHAR(100)
  DECLARE @HRK_IL          VARCHAR(50)
  DECLARE @HRK_ILCE          VARCHAR(50)
  DECLARE @i               INT
  DECLARE @HRK_ONCARI_KOD  VARCHAR(30)
  DECLARE @HRK_TEL          VARCHAR(50)
  DECLARE @HRK_CEP          VARCHAR(50)


   SET @HRK_ONCARI_KOD=''

   DECLARE ADRES_HRK CURSOR FAST_FORWARD FOR
    SELECT
    k.kod,k.unvan,k.adres,k.adres2,k.evil,k.evilce,K.tel,k.cep
    from carikart as k
    where k.sil=0 and k.adres <>''
    and k.kod IN (SELECT * FROM dbo.CsvToSTR(@carin))
    order by k.kod

    OPEN ADRES_HRK
    FETCH NEXT FROM ADRES_HRK INTO
    @HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_ADRES1,@HRK_ADRES2,
    @HRK_IL,@HRK_ILCE,@HRK_TEL,@HRK_CEP
    WHILE @@FETCH_STATUS = 0
    BEGIN
    IF @HRK_ONCARI_KOD<>@HRK_CARI_KOD
    begin
    set @HRK_ONCARI_KOD=@HRK_CARI_KOD
    set @i=1
    end

     while @i<=@satirsayi
     begin
     INSERT @TB_ADRES_ETIKET
      SELECT
        @HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_ADRES1,@HRK_ADRES2,
       @HRK_IL,@HRK_ILCE,@HRK_TEL,@HRK_CEP
      set @i=@i+1
      end

     FETCH NEXT FROM ADRES_HRK INTO
       @HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_ADRES1,@HRK_ADRES2,
     @HRK_IL,@HRK_ILCE,@HRK_TEL,@HRK_CEP
     END

    CLOSE ADRES_HRK
    DEALLOCATE ADRES_HRK


 

  RETURN

END

================================================================================
