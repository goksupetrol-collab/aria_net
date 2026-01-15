-- Function: dbo.UDF_VAR_FINANS_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.779753
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_FINANS_HRK] 
(@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_CAR_TAHODE TABLE (
    CARTIP				VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    KAR_CARTIP				VARCHAR(20) COLLATE Turkish_CI_AS,
    KAR_CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    KAR_CARIUNVAN     		VARCHAR(150) COLLATE Turkish_CI_AS,
    BELGENO				VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA			VARCHAR(150) COLLATE Turkish_CI_AS,
    GTUTAR        	FLOAT,
    CTUTAR           FLOAT,
    KUR        			FLOAT,
    ISLEMTIP         	VARCHAR(50) COLLATE Turkish_CI_AS )
AS
BEGIN
 
  
  insert into @TB_CAR_TAHODE (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)
  SELECT h.cartip,h.carkod,'','kasakart',h.kaskod,'',
  h.belno,h.ack,
  h.giren*h.kur,h.cikan*h.kur,h.kur,h.islmhrkad
  from kasahrk as h with (nolock)
  where h.masterid=0
  and h.islmhrk<>'TES' and h.sil=0
  and h.yertip=@TIP and h.varno in (select * from CsvToInt_Max(@VARNIN)) 
   
 


   /* pos hrk */

  insert into @TB_CAR_TAHODE 
  (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)

  SELECT h.cartip,h.carkod,'','poskart',h.poskod,'',
  h.belno,h.ack,h.giren,h.cikan,h.kur,h.islmhrkad
  from poshrk as h with (nolock)
  where h.masterid=0
  and h.islmhrk<>'POS' and h.sil=0
  and h.yertip=@TIP and h.varno in (select * from CsvToInt_Max(@VARNIN)) 


 /*--cekkart */
  insert into @TB_CAR_TAHODE 
  (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)

  select
  case when h.islmhrk='ALN' then h.cartip
  when islmhrk='KSN' then   h.vercartip end, 
  case when h.islmhrk='ALN' then h.carkod
  when islmhrk='KSN' then   h.vercarkod end,'',
  'cekkart','','',
  ceksenno,ack,h.giren,h.cikan,h.kur,h.islmhrkad
  from cekkart as h with (nolock)
  where
  h.sil=0 and h.yertip=@TIP 
  and h.varno in (select * from CsvToInt_Max(@VARNIN)) 

 /*- banka hrk */
  insert into @TB_CAR_TAHODE 
  (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)
  
  /*h.kaskod, */
  select h.cartip,h.carkod,'','bankakart',h.bankod,'',  
  h.belno,h.ack,case 
  when h.islmhrk='CKN' then h.alacak
  when h.islmhrk='YTN' then 0
   else h.borc end,
  case 
  when h.islmhrk='YTN' then h.borc 
  when h.islmhrk='CKN' then 0
  else h.alacak end,h.kur,h.islmhrkad
  from bankahrk as h with (nolock)
  where h.masterid=0
  and h.sil =0
  and h.yertip=@TIP and h.varno in (select * from CsvToInt_Max(@VARNIN)) 


 /*- cari hrk */
  insert into @TB_CAR_TAHODE 
  (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)
  
  select h.cartip,h.carkod,'',
  '','','',
  h.belno,h.ack,
  h.borc,h.alacak,h.kur,
  h.islmhrkad  from carihrk as h with (nolock)
  where h.masterid=0 and h.islmtip='MAH'
  and h.sil=0
  and h.yertip=@TIP and h.varno  in (select * from CsvToInt_Max(@VARNIN)) 


/*isletme k.k hrk */
  insert into @TB_CAR_TAHODE 
  (CARTIP,CARIKOD,CARIUNVAN,
  KAR_CARTIP,KAR_CARIKOD,KAR_CARIUNVAN,
  BELGENO,ACIKLAMA,GTUTAR,CTUTAR,KUR,ISLEMTIP)

  select h.cartip,h.carkod,'','istkart',h.istkkod,'',
  h.belno,h.ack,
  h.borc,h.alacak,h.kur,h.islmhrkad
  from istkhrk as h with (nolock)
  where h.masterid=0
  and h.sil =0
  and h.yertip=@TIP and h.varno in (select * from CsvToInt_Max(@VARNIN)) 

 /*cari unvan */
  update @TB_CAR_TAHODE set CARIUNVAN=dt.ad from @TB_CAR_TAHODE as t
  join (select kod,ad,cartp,tip from Genel_Kart with (nolock) ) dt
  on dt.kod=t.CARIKOD and dt.cartp=t.CARTIP

 /*cari unvan */
  update @TB_CAR_TAHODE set KAR_CARIUNVAN=dt.ad from @TB_CAR_TAHODE as t
  join (select kod,ad,cartp,tip from Genel_Kart with (nolock) ) dt
  on dt.kod=t.KAR_CARIKOD and dt.cartp=t.KAR_CARTIP 


 /* update @TB_CAR_TAHODE  set Ytlgiren=giren*kur,ytlcikan=cikan*kur */


 
   
   
    
   
  RETURN

end

================================================================================
