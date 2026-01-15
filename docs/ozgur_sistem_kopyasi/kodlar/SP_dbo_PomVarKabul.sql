-- Stored Procedure: dbo.PomVarKabul
-- Tarih: 2026-01-14 20:06:08.357477
================================================================================

CREATE PROCEDURE [dbo].PomVarKabul(
@firmano                           int,
@varno                                               float,
@varok                                               int,
@sil                                       int)
AS
BEGIN
SET NOCOUNT ON

BEGIN TRAN PM1

/*stok bilgileri */
declare @stkod                                                               varchar(30)
declare @sayackod                                        varchar(30)
declare @satmik                                             float
declare @idx                                                     float
declare @testmik                                           float
declare @transmik                                         float
declare @ilkenk                                               float
declare @sonenk                                            float
declare @olustar                                            datetime
DECLARE @tarx                                                               datetime
declare @saatx                                                                varchar(8)
declare @olususer                                          varchar(50)
declare @varad                                                               varchar(40)
declare @stktip                                               varchar(10)
declare @yerad                                                               varchar(30)
declare @stktipad                                          varchar(30)
declare @depkod                                           varchar(30)
DECLARE @trstank                                         varchar(30)
declare @yertip                                               varchar(30)
declare @islmtip                                             varchar(10)
declare @islmtipad                                        varchar(20)
declare @sayachrkid                      float
declare @say                                                    int
declare @brmfiy                                                             float
Declare @kdvyuz                                            float


DECLARE @Var_tar                                        datetime
declare @Var_saat                                         varchar(10)


/*----silme ve geri alma durumu için */
if (@sil=1) or (@varok=0)
  begin
  /* select @say=count(*) from pomvardimas where  */
  /* firmano=@firmano and sil=0 and varno>@varno and varok=1  */
    if (@sil=1)
     update sayachrk Set Sil=1 where varno=@varno and yertip='pomvardimas'
  
     
    update stkhrk set Sil=1 where varno=@varno and yertip='pomvardimas'
    and tabload is null 

    update pomvardiozet set Sil=1 where varno=@varno

    update kasahrk set Sil=1 where islmhrk='VTO' and varno=@varno and yertip='pomvardimas'

    /*-VARDIYA ACIK FAZLA İŞLENMESI SILIMI */
    update carihrk set sil=1 where varno=@varno and yertip='pomvardimas' and islmtip='VAR'

    if @varok=0
    update otomasoku set aktar=0 where varno=@varno

    if @sil=1
      delete otomasoku where varno=@varno


                IF @@ERROR > 0
                               ROLLBACK TRAN PM1
                ELSE
                               COMMIT TRAN PM1

    SET NOCOUNT OFF
   RETURN
  end
   /*----silme ve geri alma durumu için */
   
   
   
  declare  @drm     tinyint

  select @drm=Var_Hrk_Tar_isle from sistemtanim


   select @Var_tar=kaptar,@Var_saat=kapsaat from 
   pomvardimas with (nolock) where firmano=@firmano and varno=@varno


   if (@drm>0)/*acılıs tarihi */
     select @Var_tar=tarih,@Var_saat=saat from 
     pomvardimas with (nolock) where firmano=@firmano and varno=@varno 
    
  
  
   
   
  delete from  pomvardiozet where varno=@varno

  /*--vardiya özet tablosuna kapanış bilgilerini al */
  exec pomvarozet_Yeni @varno,'per','genel'
  insert into pomvardiozet (varno,varok,sil,tip,tipack,
  giris,cikis,bakiye,sr)
  select @varno,@varok,@sil,ickkod,ickad,
  sum(grs),sum(cks),sum(grs-cks),sr
  from ##pomvardiozet where varno=@varno
  group by ickkod,ickad,sr order by sr
  /*------------------------ */

  update otomasoku set aktar=-1 where varno=@varno


  Declare @Once_SonEndk                         float
  Declare @Gec_Satmik                Float
  Declare @Enktur                          Varchar(10)
  Declare @Fark_Enks                    float


  set @yertip='pomvardimas'
  select @yerad=ad from yertipad where kod=@yertip

  /*kasa cari tahsilat karsı hesap kapatma */
  exec Vardiya_Kasa_Kapat @yertip,@varno


  set @islmtip='POMSAYSAT'
  select @islmtipad=ad from stkhrktip where kod=@islmtip



     /*sayac endekleri isleniyor */
     DECLARE pomvardisayackab CURSOR FAST_FORWARD FOR
     SELECT pm.varad,pm.deguser,pm.degtarsaat,
     pm.kaptar,pm.kapsaat,
     ps.sayackod,ps.ilkendk,ps.sonendk,
     ps.Enktur,ps.OncekiSonEndk
      FROM pomvardisayac as ps with (nolock)
     inner join pomvardimas as pm on
     pm.varno=ps.varno where pm.firmano=@firmano 
     and pm.sil=0 and ps.Sil=0 and ps.varno=@varno and ps.varok=1
     and ps.perkod='Diger' /*and ps.ilkendk<>ps.sonendk */

      OPEN pomvardisayackab
      FETCH NEXT FROM pomvardisayackab INTO  
      @varad,@olususer,@olustar,@tarx,@saatx,
      @sayackod,@ilkenk,@sonenk,@Enktur,@Once_SonEndk
      WHILE @@FETCH_STATUS = 0
       BEGIN

      /*-sayac bilgileri */
      if (@sonenk<>0) and (@ilkenk<>@sonenk)
      begin

      if (select count(*) from sayachrk with (nolock) where 
       varno=@varno and sayackod=@sayackod and Sil=0 )=0
        begin       
          select @sayachrkid=isnull(max(sayachrkid),0)+1 from sayachrk
          insert into sayachrk (firmano,sayachrkid,varno,sayackod,
          tarih,saat,ilkendks,sonendks,belno,ack,olususer,olustarsaat,
          islmtip,islmtipad,yertip,yerad,dataok)
          values (@firmano,@sayachrkid,@varno,@sayackod,
          @Var_tar,@Var_Saat,@ilkenk,@sonenk,@varno,@varad+' SAYAÇ SATIŞI',
          @olususer,@olustar,@islmtip,@islmtipad,@yertip,@yerad,0)
        end  
        else
        update sayachrk set firmano=@firmano,
        ilkendks=@ilkenk,
        sonendks=@sonenk,
        belno=@varno,
        ack=@varad+' SAYAÇ SATIŞI',
        tarih=@Var_tar,saat=@Var_Saat where 
         varno=@varno and sayackod=@sayackod and Sil=0
       end 
        else
        begin
         if (@sonenk>0) and (@ilkenk=@sonenk)
           update sayachrk set Sil=1  where varno=@varno and sayackod=@sayackod
        end 
     
     /*     
      --Bu vardiyadan sonraki Vardiyalarda Endeks Duzelt
           
         if @sonenk<>@Once_SonEndk  
          begin
          
          --artan azalan dikkat
         -- if @Enktur='Artan'
            set @Fark_Enks=(@SonEnk-@Once_SonEndk)
         -- else
           --set @Fark_Enks=-1*(@SonEnk-@Once_SonEndk)  
          
            
          
       
           update pomvardisayac set
           ilkendk=ilkendk+@Fark_Enks,
           sonendk=Sonendk+@Fark_Enks,
           OncekiSonEndk=SonEndk+@Fark_Enks
           where firmano=@firmano and Varno>@Varno 
           and sayackod=@sayackod 
                 
           update sayachrk set
            ilkendks=ilkendks+@Fark_Enks,
            sonendks=sonendks+@Fark_Enks
            where firmano=@firmano and 
            varno>@varno and sayackod=@sayackod
          
        end
       */ 
        
        
        
        
     
      FETCH NEXT FROM pomvardisayackab INTO  
      @varad,@olususer,@olustar,@tarx,@saatx,@sayackod,
      @ilkenk,@sonenk,@Enktur,@Once_SonEndk

      END
     CLOSE pomvardisayackab
     DEALLOCATE pomvardisayackab
     
      /*Son Endeksi onceki endkse ata */
        update pomvardisayac set OncekiSonEndk=Sonendk
           where firmano=@firmano and Varno=@Varno and Sil=0

     
     


  /*stok satisları yansıtılıyor */

    DECLARE pomvardistkkab CURSOR FAST_FORWARD FOR 
    SELECT pm.varad,pm.deguser,pm.degtarsaat,
    pm.kaptar,pm.kapsaat,pt.kod,pt.stkod,pt.stktip,
    pt.brimfiy,pt.kdvyuz,pt.satmik,pt.testmik,pt.transfer_cks_mik
    FROM pomvarditank as pt inner join pomvardimas as pm on
    pm.varno=pt.varno and pm.sil=0 and isnull(pt.sil,0)=0 where pt.varno=@varno

    OPEN pomvardistkkab
    FETCH NEXT FROM pomvardistkkab INTO  
    @varad,@olususer,@olustar,@tarx,@saatx,@depkod,
    @stkod,@stktip,@brmfiy,@kdvyuz,@satmik,@testmik,@transmik
    WHILE @@FETCH_STATUS <> -1
     BEGIN

      if @satmik>0
      begin
        insert into stkhrk (firmano,stkhrkid,stkod,tarih,saat,
        giren,cikan,brmfiykdvli,kdvyuz,
        ack,olususer,olustarsaat,varno,islmtip,islmtipad,
        depkod,stktip,stktipad,
        yertip,yerad,dataok,pro)
        values (@firmano,@varno,@stkod,@Var_tar,@Var_Saat,
        0,@satmik,@brmfiy,@kdvyuz,@varad+' SAYAÇ SATIŞI',@olususer,@olustar,
        @varno,@islmtip,@islmtipad,@depkod,@stktip,@stktipad,@yertip,@yerad,0,1)
      end


      FETCH NEXT FROM pomvardistkkab INTO  
      @varad,@olususer,@olustar,@tarx,@saatx,@depkod,
      @stkod,@stktip,@brmfiy,@kdvyuz,@satmik,@testmik,@transmik

      END
    CLOSE pomvardistkkab
    DEALLOCATE pomvardistkkab


    /*-tank transfer giris haraketleri */

    set @islmtip='POMTRANS'
    select @islmtipad=ad from stkhrktip where kod=@islmtip

    /*- tank transfer giris haraketleri */
     insert into stkhrk (firmano,stkhrkid,stkod,tarih,saat,giren,cikan,
     brmfiykdvli,kdvyuz,ack,olususer,olustarsaat,varno,
     islmtip,islmtipad,depkod,stktip,yertip,yerad)

     select ps.firmano,ps.varno,ps.stkod,@Var_tar,@Var_Saat,
     isnull(sum(ps.transfermik),0),0,
     case when sum(ps.tutar)>0 then
     sum(ps.tutar)/sum(ps.satmik) else avg(ps.brimfiy) end,avg(ps.kdvyuz),
     @varad+' SAYAÇ TRANSFER GİRİS',@olususer,@olustar,ps.varno,
     @islmtip,@islmtipad,
     ps.transfertank,ps.stktip,@yertip,@yerad
     FROM pomvardisayac as ps 
     inner join pomvardimas as pm on pm.varno=ps.varno 
     and pm.firmano=ps.firmano and pm.sil=0 and isnull(ps.sil,0)=0
     where ps.varno=@varno and ps.firmano=@firmano
     and transfertank<>'' and ps.transfermik>0
     group by ps.firmano,ps.varno,ps.stkod,ps.transfertank,ps.stktip
   
   
     
         

    /*-tank transfer cikis haraketleri */
     
     insert into stkhrk (firmano,stkhrkid,stkod,tarih,saat,
     giren,cikan,brmfiykdvli,kdvyuz,ack,olususer,olustarsaat,varno,
     islmtip,islmtipad,
     depkod,stktip,yertip,yerad)

     select ps.firmano,ps.varno,ps.stkod,@Var_tar,@Var_Saat,
     0,isnull(sum(ps.transfer_cks_mik),0),
     case when sum(ps.tutar)>0 then
     sum(ps.tutar)/sum(ps.satmik) else avg(ps.brimfiy) end,avg(ps.kdvyuz),
     @varad+' SAYAÇ TRANSFER CIKIS',@olususer,@olustar,ps.varno,
     @islmtip,@islmtipad,
     ps.kod,ps.stktip,@yertip,@yerad
     FROM pomvarditank as ps
     inner join pomvardimas as pm on pm.varno=ps.varno 
     and pm.firmano=ps.firmano and pm.sil=0 and isnull(ps.sil,0)=0
     where ps.varno=@varno and ps.firmano=@firmano
     and ps.transfer_cks_mik>0
     group by ps.firmano,ps.varno,ps.stkod,ps.kod,ps.stktip


                IF @@ERROR > 0
                               ROLLBACK TRAN PM1
                ELSE
                               COMMIT TRAN PM1



  exec  PomVardi_Evrak_Kont

SET NOCOUNT OFF

END

================================================================================
