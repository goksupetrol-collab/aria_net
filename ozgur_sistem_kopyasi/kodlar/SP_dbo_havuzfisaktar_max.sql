-- Stored Procedure: dbo.havuzfisaktar_max
-- Tarih: 2026-01-14 20:06:08.334947
================================================================================

CREATE PROCEDURE [dbo].[havuzfisaktar_max](
@firmano int,
@aktip    int,/*1 aktarım 0 geri al */
@veridin  varchar(max),
@varno  int)
AS
 BEGIN

 
  declare @yertip varchar(30)
  declare @yertipad varchar(50)
  declare @say           int
  declare @mesaj         varchar(300)
  declare @vts           float
  
  if @aktip=1 /*vardiyaya aktarım */
  begin
   select @say=count(*) from veresimas as vs with (nolock) where varno>0
   and vs.verid in (select * from CsvToInt_Max(@veridin))

         if @say>0
           begin
           SELECT @MESAJ = 'Seçmiş Olduğunuz Fişler İçinde Aktarılmış Fişler Var..!'
           RAISERROR (@MESAJ, 16,1)
           RETURN
         end
  
  SET @yertip='pomvardimas'
  select @yertipad=ad from yertipad where kod=@yertip
  

  update veresimas set yertip=@yertip,yerad=@yertipad,
  varno=@varno,kayok=1
  where verid in (select * from CsvToInt_Max(@veridin))
  
  end
  
  if @aktip=0 /*havuza geri alım */
  begin
   select @say=count(*) from veresimas as vs where varok=1
   and vs.verid in (select * from CsvToInt_Max(@veridin))

         if @say>0
           begin
           SELECT @MESAJ = 'Seçmiş Olduğunuz Fişler İçinde Kapatılmış Vardiyalar Var..!'
           RAISERROR (@MESAJ, 16,1)
           RETURN
         end

  SET @yertip='havuzislem'
  select @yertipad=ad from yertipad where kod=@yertip





  update veresimas set yertip=
  case when vtsid>0 then 'vts_islem' else 'havuzislem' end,
  yerad=case when vtsid>0 then
  (select ad from yertipad where kod='vts_islem')
  else (select ad from yertipad where kod='havuzislem') end,
  varno=0,kayok=1
  where 
  verid in (select * from CsvToInt_Max(@veridin))
  /*and varno=@varno */
  end


 END

================================================================================
