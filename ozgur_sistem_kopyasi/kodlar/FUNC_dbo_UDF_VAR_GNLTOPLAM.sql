-- Function: dbo.UDF_VAR_GNLTOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.780924
================================================================================

CREATE FUNCTION UDF_VAR_GNLTOPLAM (@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_TAH_ODE_TOPLAM TABLE (
    ACIKLAMA     VARCHAR(50)  COLLATE Turkish_CI_AS,
    GIREN         FLOAT,
    CIKAN         FLOAT,
    BAKIYE        FLOAT,
    SIRA          FLOAT)
AS
BEGIN
  DECLARE @ACIKFAZLA FLOAT
  DECLARE @GIREN     FLOAT
  DECLARE @CIKAN     FLOAT
  DECLARE @FARKGIREN FLOAT
  DECLARE @FARKCIKAN FLOAT
  DECLARE @VARNO	 INT
 
  
  if @TIP='pomvardimas'
  begin
    INSERT @TB_TAH_ODE_TOPLAM (ACIKLAMA,GIREN,CIKAN,BAKIYE,SIRA)
    select h.tipack,sum(h.giris),sum(h.cikis),sum(h.bakiye),h.sr
    FROM  pomvardiozet as h
    where h.varno in (select * from CsvToInt_Max(@VARNIN))
    and h.sil=0 and h.sr<=40 
    group by h.tipack,h.sr
  end
  
  if @TIP='marvardimas'
  begin
      INSERT @TB_TAH_ODE_TOPLAM (ACIKLAMA,GIREN,CIKAN,BAKIYE,SIRA)
      select h.tipack,sum(h.giris),sum(h.cikis),sum(h.bakiye),h.sr
      FROM  marvardiozet as h with (NOLOCK)
      where h.varno in (select * from CsvToInt_Max(@VARNIN)) 
      and h.sil=0 and h.sr<=40
      group by h.tipack,H.sr
  end
  
  
  
  if @TIP='resvardimas'
  begin
      INSERT @TB_TAH_ODE_TOPLAM (ACIKLAMA,GIREN,CIKAN,BAKIYE,SIRA)
      select h.tipack,sum(h.giris),sum(h.cikis),sum(h.bakiye),h.sr
      FROM  resvardiozet as h with (NOLOCK)
      where h.varno in (select * from CsvToInt_Max(@VARNIN)) 
      and h.sil=0 and h.sr<=40
      group by h.tipack,H.sr
  end


  
  
  SELECT @GIREN=GIREN,@CIKAN=CIKAN,@ACIKFAZLA=(GIREN-CIKAN)
  FROM @TB_TAH_ODE_TOPLAM WHERE SIRA=40 /*-ARA TOPLAM */

  IF @ACIKFAZLA<0
  SET @FARKGIREN=ABS(@ACIKFAZLA) ELSE SET @FARKGIREN=0
  IF @ACIKFAZLA>0
  SET @FARKCIKAN=ABS(@ACIKFAZLA) ELSE SET @FARKCIKAN=0

  INSERT INTO @TB_TAH_ODE_TOPLAM (ACIKLAMA,GIREN,CIKAN,BAKIYE,SIRA)
  VALUES ('Fark',@FARKGIREN,@FARKCIKAN,@ACIKFAZLA,41)

  INSERT INTO @TB_TAH_ODE_TOPLAM (ACIKLAMA,GIREN,CIKAN,BAKIYE,SIRA)
  VALUES ('Genel Toplam',(@GIREN+@FARKGIREN),(@CIKAN+@FARKCIKAN),
  (@GIREN+@FARKGIREN-@CIKAN+@FARKCIKAN),42)
  
  


  RETURN

end

================================================================================
