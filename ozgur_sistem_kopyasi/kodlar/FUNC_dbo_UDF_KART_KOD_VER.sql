-- Function: dbo.UDF_KART_KOD_VER
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.732052
================================================================================

CREATE FUNCTION UDF_KART_KOD_VER 
(@firmano      	int,
@tabload  		varchar(50),
@grp_index 		int,
@grp_id 		int)
RETURNS VARCHAR(50) AS
BEGIN
  
 declare @DEGER 			varchar(50)
 declare @SERI 				varchar(50)
 DECLARE @NUMARA 			varchar(50)/*FLOAT */
 DECLARE @I 				INT
 DECLARE @UZUNLUK     		INT

 SET @SERI = ''


/*---cari kart */
 if @tabload='carikart' and @grp_index=0 
   select @DEGER=max(kod) from carikart
   
 if @tabload='carikart' and @grp_index>0
   begin
   
   /*
   if @grp_index=1
    select @DEGER=max(kod) from carikart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from carikart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from carikart where grp3=@grp_id
    */
    
   if @grp_index=1
    select @DEGER=count(id) from carikart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=count(id) from carikart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=count(id) from carikart where grp3=@grp_id
    
    select @SERI=ISNULL(kod,'') from grup where id=@grp_id
    
     /* print(@DEGER) */
    
     set @UZUNLUK=4
     if LEN(@DEGER)>4
      set @UZUNLUK=5

    
    if @SERI=''
     begin
      select @DEGER=dbo.UDF_GETIR_FISNO ('carikart') 
      RETURN @DEGER
     end
     
     
     RETURN  @SERI+RIGHT('00000000000000000000' + CAST(@DEGER + 1 AS VARCHAR(15)),@UZUNLUK)
  
  end
   
  
  
/*---personel kart   */
  if @tabload='perkart' and @grp_index=0 
   select @DEGER=max(kod) from perkart
   
 if @tabload='perkart' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from perkart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from perkart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from perkart where grp3=@grp_id
  end  
  
/*--banka kart   */
  if @tabload='bankakart' and @grp_index=0 
   select @DEGER=max(kod) from bankakart
   
 if @tabload='bankakart' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from bankakart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from bankakart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from bankakart where grp3=@grp_id
  end 
  
  
 /*--gelir gider kart   */
  if @tabload='gelgidkart' and @grp_index=0 
   select @DEGER=max(kod) from gelgidkart
   
 if @tabload='gelgidkart' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from gelgidkart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from gelgidkart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from gelgidkart where grp3=@grp_id
  end  
  
 
  /*--perakendekart kart   */
  if @tabload='perakendekart' and @grp_index=0 
   select @DEGER=max(kod) from perakendekart
  
  if @tabload='perakendekart' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from perakendekart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from perakendekart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from perakendekart where grp3=@grp_id
  end  
  
  
  /*--sayackart kart   */
  if @tabload='sayackart' and @grp_index=0 
   select @DEGER=max(kod) from sayackart
  
  if @tabload='sayackart' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from sayackart where grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from sayackart where grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from sayackart where grp3=@grp_id
  end 
  
  /*-market stok kartları */
  
   if @tabload='stok_mr' and @grp_index=0 
   select @DEGER=max(kod) from stokkart where tip='markt'
  
  if @tabload='stok_mr' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from stokkart where tip='markt' and grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from stokkart where tip='markt' and grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from stokkart where tip='markt' and grp3=@grp_id
  end 
  
  
   /*-akaryakit stok kartları */
  
   if @tabload='stok_ak' and @grp_index=0 
   select @DEGER=max(kod) from stokkart where tip='akykt'
  

   if @tabload='stok_ak' and @grp_index>0
   begin
   if @grp_index=1
    select @DEGER=max(kod) from stokkart where tip='akykt' and grp1=@grp_id
   if @grp_index=2
    select @DEGER=max(kod) from stokkart where tip='akykt' and grp2=@grp_id
   if @grp_index=3
    select @DEGER=max(kod) from stokkart where tip='akykt' and grp3=@grp_id
  end 
  
  
  
  /*-depo kart */
   if @tabload='depo_kart' and @grp_index=0  /*- 0 tank,1 market  */
   select @DEGER=max(kod) from Depo_Kart_Listesi where tip='akykt'
   
   if @tabload='depo_kart' and @grp_index=1  /*- 0 tank,1 market  */
   select @DEGER=max(kod) from Depo_Kart_Listesi where tip='markt'
   
   
 /*-pos kart  */
   if @tabload='poskart' and @grp_index=0 
   select @DEGER=max(kod) from poskart 
  
  
  /*istkart */
   if @tabload='istkart' and @grp_index=0 
   select @DEGER=max(kod) from istkart 
  
 
  
  SET @I    = 1
  set @NUMARA=null 
 
 WHILE @I <= LEN(@DEGER)
  BEGIN
    IF ( (SELECT ISNUMERIC(SUBSTRING(@DEGER,@I,1))) = 0 )
    BEGIN
      SET @SERI = @SERI + ( SELECT SUBSTRING(@DEGER,@I,1) )
    END
    ELSE
    BEGIN
  /*    PRINT RIGHT(@DEGER,LEN(@DEGER) - @I + 1) */
      IF ISNUMERIC(RIGHT(@DEGER,LEN(@DEGER) - @I + 1))=1
      AND RIGHT(@DEGER,LEN(@DEGER) -@I + 1)>'0'
      BEGIN
      SET @UZUNLUK=LEN(@DEGER) - @I + 1
      SELECT @NUMARA = CAST(RIGHT(@DEGER,LEN(@DEGER) - @I + 1) AS FLOAT)
      BREAK
      END
    END
 
   SET @I = @I + 1
  END
 
 if @NUMARA is NULL
 set @DEGER=@SERI
 if not (@NUMARA is NULL)
  set @DEGER=@SERI+@NUMARA
  
  if (@NUMARA is NULL) and @SERI=''
   set @DEGER=''
  
 RETURN @DEGER
  /*RETURN @NUMARA */
  /*RETURN @SERI */
  /*RETURN @UZUNLUK */

END

================================================================================
