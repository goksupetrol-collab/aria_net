-- Function: dbo.UDF_CARI_VADE_TARIH_VER
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.697343
================================================================================

CREATE FUNCTION [dbo].[UDF_CARI_VADE_TARIH_VER](
@Tip varchar(10),
@Kod varchar(20),
@Tarih Datetime )
RETURNS Datetime
AS
BEGIN
	DECLARE @result Datetime
    DECLARE @Sure   int
    DECLARE @SureTip  varchar(10)
    
    
    set  @result=@Tarih
    
    
    if @Tip='fis'
     begin
     SELECT @Sure=fisvadsur,@SureTip=fisvadtip FROM carikart with (nolock) where Kod=@Kod
     if @SureTip='fistar'
      set  @result=DATEADD(DAY,@SURE,@result)
     end
	
    
    
     if @Tip='fat'
      begin
       SELECT @Sure=fatvadsur,@SureTip=fisvadtip FROM carikart with (nolock) where Kod=@Kod

       if @SureTip='fattar'
        set  @result=DATEADD(DAY,@SURE,@result)
      end
      
      
      
        if @SureTip='bsaygun'  
        begin
        
         if @SURE=0
          set @SURE=1
        
         SELECT @result=CAST(CAST(year(@Tarih) AS varchar) + '-' + CAST(month(@Tarih) AS varchar) +
          '-' + CAST(@SURE as varchar) AS datetime)
      
        if ISDATE(DATEADD(month,1,@result))=1 
          set @result=DATEADD(month,1,@result)
        else
          set @result=DATEADD(month,2,@result) 
         
        end 
        
       if @SureTip='haysongun'   
        begin
        
         SELECT @result=CAST(CAST(year(@Tarih) AS varchar) + '-' + CAST(month(@Tarih) AS varchar) +
          '-' + CAST(1 as varchar) AS datetime)
      
         set @result=DATEADD(month,1,@result)
    
         set @result=DATEADD(day,-1,@result) 
        
        
        end
      
      
      
      
        
    
     RETURN @result
END

================================================================================
