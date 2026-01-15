-- Stored Procedure: dbo.SpNetsisDekontPompaciVardiya
-- Tarih: 2026-01-14 20:06:08.377545
================================================================================

CREATE PROCEDURE dbo.[SpNetsisDekontPompaciVardiya]
@Varno             int
AS
Begin
   
 /*StokMiktar */
 /*StokTutar */
 /*StokKdv */
 /*    */


   Declare @TB_STOK TABLE (
    Varno 				 INT,
    Tarih                DATETIME,
    Saat             	 VARCHAR(10) COLLATE Turkish_CI_AS,
    Tip                  Varchar(10), /* */
    DekontSeri           Varchar(10),
    DekontNo             Varchar(10),
    BA                   Varchar(1),
    CM 					 Varchar(1),
    HesapKod             VARCHAR(30) COLLATE Turkish_CI_AS,
    Tutar                Decimal(18,2) default 0,
    Miktar				 Float default 0, 
    KdvTutar			 Decimal(18,2) default 0,
    KdvYuzde			 Float default 0,		
    Ack 				 VARCHAR(100) COLLATE Turkish_CI_AS,
    CariTip              VARCHAR(20) COLLATE Turkish_CI_AS,
    CariKod				 VARCHAR(30) COLLATE Turkish_CI_AS,
    StokTip             VARCHAR(10) COLLATE Turkish_CI_AS,
    StokKod             VARCHAR(30) COLLATE Turkish_CI_AS,
    StokKdvYuz          Decimal(18,2),
    StokMiktar          Decimal(18,3),
    StokTutar  		    Decimal(18,2),
    OlusTarihSaat          DATETIME)
   
   
   
   DECLARE @CAR_KOD             VARCHAR(30) 
     
   SELECT @CAR_KOD=zrap_carkod FROM sistemtanim
   
   /*CM    S=STOK C=CARI M=MAVIN Kasa B=BANKA */
   
  
 
   /*Vardiya Stok Kalemleri */
     insert into @TB_STOK (Varno,Tarih,Saat,
     Ack,OlusTarihSaat,BA,CM,
     StokTip,StokKod,StokKdvYuz,StokMiktar,StokTutar)
     SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
     'A','S',
     ps.stktip,ps.stkod,max(ps.kdvyuz),sum(ps.satmik),sum(ps.tutar)
     from pomvardimas as p 
     inner join pomvardisayac as ps 
     on ps.varno=p.varno and p.varok=1
     and ps.varno=@Varno
     /* and p.tarih>=@BasTarih and p.tarih<=@BitTarih  */
       
      group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno
      
      
      update @TB_STOK Set 
      Tutar=StokTutar/(1+StokKdvYuz),
      KdvTutar=StokTutar-(StokTutar/(1+StokKdvYuz)),
      KdvYuzde=StokKdvYuz*100,
      Miktar=StokMiktar
     
      
      update @TB_STOK set HesapKod=dt.muhckskod 
      from @TB_STOK as t join (select tip,kod,muhckskod 
      from stokkart with (nolock) where Sil=0 ) dt 
      on dt.tip=t.StokTip and dt.kod=t.StokKod 
      
     /*-Nakit Teslimat */
        
      insert into @TB_STOK (Varno,Tarih,Saat,Ack,OlusTarihSaat,
       BA,CM,CariTip,CariKod,HesapKod,Tutar)
       SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
       'B','M','kasakart',k.Kod,k.muhkod,sum(h.giren)
       from kasahrk as h with (nolock) 
       inner join kasakart as k with (nolock)  on k.kod=h.kaskod
       inner join pomvardimas as p with (nolock) on  p.varno=h.varno
       where h.sil=0 and h.yertip='pomvardimas' 
       and h.varno=@Varno
       group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,k.muhkod,k.kod    
      
     
     
      /*Pos Kalemler */
     
     
      insert into @TB_STOK (Varno,Tarih,Saat,Ack,OlusTarihSaat,
       BA,CM,CariTip,CariKod,HesapKod,Tutar)
       SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
       'B','M','poskart',k.Kod,k.muhkod,sum(h.giren)
       from poshrk as h with (nolock) 
       inner join poskart as k with (nolock)  on  k.kod=h.poskod
       inner join pomvardimas as p with (nolock) on  p.varno=h.varno
       where h.sil=0 and h.yertip='pomvardimas' 
       and h.varno=@Varno
       group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,k.muhkod,k.kod
     
     
     
     /*Veresiye Kalemler */
     
      insert into @TB_STOK (Varno,Tarih,Saat,Ack,OlusTarihSaat,
       BA,CM,CariTip,CariKod,HesapKod,Tutar)
      Select p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
      'B','C','carikart',c.Kod,c.muhkod,sum(h.toptut)
      from veresimas as h with (nolock) 
      inner join carikart as c on h.carkod=c.kod
      inner join pomvardimas as p with (nolock) on  p.varno=h.varno
      where h.sil=0 and h.yertip='pomvardimas' 
      and h.varno =@Varno
      group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,c.kod,c.muhkod
     
    /*gelir gider girisi */
   
   
     
     /*acik ile 'B' fazla ise 'A' */
     insert into @TB_STOK (Varno,Tarih,Saat,
     Ack,OlusTarihSaat,BA,CM,
     CariTip,CariKod,HesapKod,Tutar)
     SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
     case when ps.tutar<0 then 'B' else 'A' end,'C',
     ps.cartip,ps.kod,'',abs(ps.tutar)
     from pomvardimas as p 
     inner join pomvardikap as ps 
     on ps.varno=p.varno and p.varok=1 
     and ps.sil=0 and p.varno =@Varno
     and abs(ps.tutar)>0
     
   
     
     
     /*
   
    
   
    --DECLARE @VARNO 				  int
    DECLARE @TARIH 				  DATETIME
    DECLARE @SAAT				  VARCHAR(10) 	 
    DECLARE @STOK_TIP             VARCHAR(10) 
    DECLARE @STOK_KOD             VARCHAR(30)
    DECLARE @STOK_KDVYUZ          FLOAT
    DECLARE @STOK_MIKTAR          FLOAT
    DECLARE @STOK_TUTAR  		  FLOAT
    DECLARE @ACK                  VARCHAR(100) 
    DECLARE @OLUSTARSAAT     	  DATETIME


 
   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),sum(ps.satmik),sum(ps.tutar)
    from pomvardimas as p 
    inner join pomvardisayac as ps 
     on ps.varno=p.varno and p.varok=1
     and ps.varno=@Varno
     -- and p.tarih>=@BasTarih and p.tarih<=@BitTarih 
       
      group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno
   
      
      
     OPEN  VARDI_STOK
      FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR
       WHILE @@FETCH_STATUS = 0
        BEGIN  

     declare @GEC_STOK_MIKTAR      FLOAT
     declare @GEC_STOK_TUTAR       FLOAT

     set @GEC_STOK_MIKTAR=0
     set @GEC_STOK_TUTAR=0

     select @GEC_STOK_MIKTAR=sum(h.mik),
     @GEC_STOK_TUTAR=sum(h.mik*h.brmfiy) from veresimas as m 
     inner join veresihrk as h 
     on m.verid=h.verid and m.sil=h.sil and m.sil=0
     and h.stktip=@STOK_TIP and h.stkod=@STOK_KOD
     and m.yertip='pomvardimas' and m.varno=@VARNO
     group by m.varno,h.stktip,h.stkod
     
     set @STOK_MIKTAR=@STOK_MIKTAR-@GEC_STOK_MIKTAR
     set @STOK_TUTAR=@STOK_TUTAR-@GEC_STOK_TUTAR

     insert into @TB_STOK (Varno,Tarih,Saat,Ack,
     CariKod,OlusTarihSaat,
     StokTip,StokKod,StokKdvYuz,StokMiktar,StokTutar)
     values (@VARNO,@TARIH,@SAAT,@ACK,@CAR_KOD,@OLUSTARSAAT,
     @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR) 


     FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR

   END
   
     CLOSE VARDI_STOK
     DEALLOCATE VARDI_STOK
     
     */
     
     select * from @TB_STOK


RETURN


END

================================================================================
