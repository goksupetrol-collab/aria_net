-- Function: dbo.Stok_Brim_Carpan
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.672440
================================================================================

CREATE FUNCTION [dbo].Stok_Brim_Carpan (@tip varchar(30),@kod varchar(30))
RETURNS
 @TB_STOK_BRIM TABLE (
    kod    VARCHAR(20) COLLATE Turkish_CI_AS,
    ad     VARCHAR(30) COLLATE Turkish_CI_AS,
    carpan      FLOAT)
AS
BEGIN

    DECLARE @BRMKOD VARCHAR(20)
    DECLARE @BRMCAR FLOAT
    
    DECLARE @BRMKOD1 VARCHAR(20)
    DECLARE @BRMCAR1 FLOAT

    DECLARE @BRMKOD2 VARCHAR(20)
    DECLARE @BRMCAR2 FLOAT


  if @tip='gelgid'
   begin
    SELECT @BRMKOD=brim,@BRMCAR=1
    from gelgidkart with (NOLOCK) where kod=@kod and sil=0

    insert into @TB_STOK_BRIM (kod,ad,carpan)
    select @BRMKOD,k.ad,@BRMCAR from stkbrm as k with (NOLOCK) where kod=@BRMKOD
    return
   end


    SELECT @BRMKOD=brim,@BRMCAR=1,
    @BRMKOD1=brmust,@BRMCAR1=brmcarp,
    @BRMKOD2=brmust2,@BRMCAR2=brmcarp2
    from stokkart with (NOLOCK) where tip=@tip and kod=@kod and sil=0

    if @BRMKOD<>''
    insert into @TB_STOK_BRIM (kod,ad,carpan)
    select @BRMKOD,k.ad,@BRMCAR from stkbrm as k with (NOLOCK) where kod=@BRMKOD 
    

    if @BRMKOD1<>''
    insert into @TB_STOK_BRIM (kod,ad,carpan)
    select @BRMKOD1,k.ad,@BRMCAR1 from stkbrm as k with (NOLOCK) where kod=@BRMKOD1 
    
    
    if @BRMKOD2<>''
    insert into @TB_STOK_BRIM (kod,ad,carpan)
    select @BRMKOD2,k.ad,@BRMCAR2 from stkbrm as k with (NOLOCK) where kod=@BRMKOD2 

  
  
RETURN
  
  
END

================================================================================
