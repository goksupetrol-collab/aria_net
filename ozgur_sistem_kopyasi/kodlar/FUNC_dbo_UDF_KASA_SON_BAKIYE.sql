-- Function: dbo.UDF_KASA_SON_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.734883
================================================================================

CREATE FUNCTION [dbo].[UDF_KASA_SON_BAKIYE] ()
RETURNS
    @TB_KASA_EKSTRE TABLE (
    kod  VARCHAR(20)  COLLATE Turkish_CI_AS,
    ad   VARCHAR(50)  COLLATE Turkish_CI_AS,
    top_bakiye   FLOAT,
    parabrm      VARCHAR(20)  COLLATE Turkish_CI_AS)
AS
BEGIN
  
 
  DECLARE @KAS_FIN_GOS        	INT 
  DECLARE  @kod  VARCHAR(20)  
  DECLARE  @ad   VARCHAR(50)  
  DECLARE  @parabrm      VARCHAR(20) 
  declare @Bakiye      float
  

  SELECT @KAS_FIN_GOS=kas_fin_var from sistemtanim

 
  /*devir atanıyorrrrr..... */
  
  
    DECLARE KASA_HRK CURSOR FAST_FORWARD FOR
    select k.kod,k.ad,k.parabrm
    from kasakart as k  with (nolock) where k.Sil=0
    OPEN KASA_HRK
    
  FETCH NEXT FROM KASA_HRK INTO  @kod,@ad,@parabrm
  WHILE @@FETCH_STATUS = 0
  BEGIN
  
  
     set @Bakiye=0
  
     if @KAS_FIN_GOS=0
       select @Bakiye=isnull(sum(round(giren-cikan,2)),0)
       from kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
       where h.kaskod=@KOD and h.sil=0 and tarih < DATEADD(day,1,GETDATE())
       and ((varno>0  and islmhrk='TES') or (varno=0))

       if @KAS_FIN_GOS=1
       select @Bakiye=isnull(sum(round(giren-cikan,2)),0)
       from kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
       where h.kaskod=@KOD and h.sil=0 and tarih < DATEADD(day,1,GETDATE())
      



    INSERT @TB_KASA_EKSTRE (kod,ad,parabrm,top_bakiye)
      values (@kod,@ad,@parabrm,@Bakiye) 
    FETCH NEXT FROM KASA_HRK INTO  @kod,@ad,@parabrm
  END

  CLOSE KASA_HRK
  DEALLOCATE KASA_HRK

   


  RETURN

END

================================================================================
