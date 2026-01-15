-- Function: dbo.Udf_Luca_ZraporId_Muh
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.746597
================================================================================

CREATE FUNCTION [dbo].[Udf_Luca_ZraporId_Muh]
(@Firmano int,
@MasId   int,
@KasaMuhKod  varchar(30),
@VeresiyeMuhKod  varchar(30),
@Kdv1MuhKod    varchar(30),  
@Kdv8MuhKod    varchar(30), 
@Kdv18MuhKod    varchar(30)
)
RETURNS
  @TB_LOGO_FATURA TABLE (
  TipId					 int default 0,
  ZrapId                 int,
  SatirTip               varchar(20),
  SatirKod               varchar(30),
  FisNo  				 varchar(30),
  FisTarih               datetime,
  HesapKodu 			 varchar(30),
  EvrakNo                varchar(30),                
  EvrakTarih             datetime,
  Aciklama			     varchar(100),
  Borc			         float,
  Alacak    			 float,
  Miktar                 float default 0
)
AS
BEGIN


/*
Fiş No	Fiş Tarihi	Hesap Kodu  	Evrak No	  Evrak Tarihi	Açıklama	Borç	Alacak	    Miktar
	     1.1.2019	600.11.01.005	181         	1.1.2019	Z RAPORU	0		610,2881	128,5
	     1.1.2019	600.11.01.003	181				1.1.2019	Z RAPORU	0		3594,797	742,95
	     1.1.2019	600.11.01.002	181				1.1.2019	Z RAPORU	0		754,2712	150,6   
	     1.1.2019	391.11.01.001	181				1.1.2019	Z RAPORU	0		892,6841	0      --hesaplanan kdv
		 1.1.2019	108-01( Ykb	    181				1.1.2019	Z RAPORU	1000	0	               --pos
	     1.1.2019	108-02 (Akbank	181				1.1.2019	Z RAPORU	852,04	0	               --pos
	     1.1.2019	120-01 (Z carisi)181			1.1.2019	Z RAPORU	3000	0	               --veresiye
	     1.1.2019	100 Kasa		 181			1.1.2019	Z RAPORU	1000	0	               --kasa
*/

   Declare @FisTarih           Datetime
   Declare @EvrakNo            varchar(30)
   Declare @Aciklama           varchar(100)
   
   declare   @ZCariMuh         varchar(30)
   
   select top 1 @ZCariMuh=c.muhkod from zrapormas as z with (nolock)
   inner join carikart as c on z.carkod=c.kod where z.sil=0 and z.MasId=@MasId
   

  declare @ZrapId int
  declare pom_var CURSOR FAST_FORWARD  FOR 
  select zrapid from zrapormas as m with (nolock) where MasId=@MasId and sil=0
   open pom_var
  fetch next from  pom_var into @ZrapId
  while @@FETCH_STATUS=0
   begin


  /*Stok Hrkleri */
   insert into @TB_LOGO_FATURA
  (ZrapId,SatirTip,SatirKod,
  FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
   Borc,Alacak,Miktar)

  /* Stok Hrkleri */
    select @ZrapId,
    'Stok','Stok '+sk.kod,
    '',m.tarih,
    sk.muhckskod,
   /* sk.muhckskod, */
    m.zseri+''+cast(m.zserino as varchar),
    m.tarih,m.ack,
   /* dbo.Udf_KdvMuhKodu(2,sk.kdv), */
    0,
    /*(h.brmfiy/(1+h.kdvyuz))*h.miktar,--kdvsiztop */
    /*(h.brmfiy/(1+h.kdvyuz)), --BRMKDVSIZ, */
   /* (h.brmfiy-(h.brmfiy/(1+h.kdvyuz)))*h.miktar,--kdvtop */
    (h.brmfiy/(1+h.kdvyuz))*h.miktar,
    h.miktar/*miktar */
  

    from zrapormas as m with (nolock)
    inner join  zraporhrk h with (nolock) on h.zrapid=m.zrapid and m.sil=0 and h.sil=0
    inner join Zrapor_UrunKart_Listesi as sk with (nolock) on sk.tip=h.tip and sk.kod=h.kod 
    where  m.zrapid=@ZrapId  /*m.firmano=@Firmano and */
    /*and isnull(m.Entegre,0)=0 */
    
  /* Hesaplanan Kdv  */
 /*  Declare @KdvliToplamTutar float */
  /* Declare @KdvsizToplamToplam float */
   
   
    Select top 1 
    /*@KdvliToplamTutar=sum(h.brmfiy*h.miktar), */
    /*@KdvsizToplamToplam=sum((h.brmfiy/(1+h.kdvyuz))*h.miktar), */
    @EvrakNo=m.zseri+''+cast(m.zserino as varchar),
    @FisTarih=m.tarih,
    @Aciklama=m.ack
    from zrapormas as m with (nolock)
    inner join  zraporhrk h with (nolock) on h.zrapid=m.zrapid and m.sil=0 and h.sil=0
    inner join Zrapor_UrunKart_Listesi as sk with (nolock) on sk.tip=h.tip and sk.kod=h.kod 
    where  m.zrapid=@ZrapId  /*m.firmano=@Firmano and */
    /*and isnull(m.Entegre,0)=0 */
   /* group by m.zseri+''+cast(m.zserino as varchar),m.tarih,m.ack */
   
    
    insert into @TB_LOGO_FATURA
    (ZrapId,SatirTip,SatirKod,FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
     Borc,Alacak)
    Select @ZrapId,'Hes.Kdv','Kdv '+cast(h.kdvyuz*100 as varchar),
    '' FisNo,m.tarih,
    case 
    when h.kdvyuz=0.01 then @Kdv1MuhKod 
    when h.kdvyuz=0.10 then @Kdv8MuhKod 
    when h.kdvyuz=0.20 then @Kdv18MuhKod end,
     m.zseri+''+cast(m.zserino as varchar),
     m.tarih,m.ack,
     0,
    sum((h.brmfiy-(h.brmfiy/(1+h.kdvyuz)))*h.miktar)/*kdvtop */
    from zrapormas as m with (nolock)
    inner join  zraporhrk h with (nolock) on h.zrapid=m.zrapid and m.sil=0 and h.sil=0
    inner join Zrapor_UrunKart_Listesi as sk with (nolock) on sk.tip=h.tip and sk.kod=h.kod 
    where  m.zrapid=@ZrapId /*and isnull(m.Entegre,0)=0 */
    and h.kdvyuz>0
    group by h.kdvyuz,m.masId,m.tarih,
    m.zseri,m.zserino,m.ack
  
  
  
    /*Z cari kapatma */
    insert into @TB_LOGO_FATURA
    (TipId,ZrapId,SatirTip,SatirKod,
    FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
    Borc,Alacak,Miktar)
    select 1,@MasId,'Zcari','ZCariMuhKod',
    '',@FisTarih,@ZCariMuh,@EvrakNo,@FisTarih,@Aciklama,
    case when sum(Borc-Alacak)<0 then abs(sum(Borc-Alacak)) else 0 end,
    case when sum(Borc-Alacak)>0 then sum(Borc-Alacak) else 0 end,0 from @TB_LOGO_FATURA
    where ZrapId=@ZrapId

  
  
     FETCH next from  pom_var into @ZrapId
  end
 close Pom_Var
 deallocate pom_var
 
  
  
   declare @VardiyaTip  int
   select top 1 @VardiyaTip=m.VarTip From ZraporVardiya as m with (nolock)
   inner join zrapormas as z with (nolock) on z.zrapid=m.zrapid 
   and m.sil=0 and z.sil=0 and z.MasId=@MasId
   
   
   
   /*pos  */
   if @VardiyaTip=1
    begin
    
      insert into @TB_LOGO_FATURA
      (TipId,ZrapId,SatirTip,SatirKod,
      FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
      Borc,Alacak)
      Select 2,@MasId,'Pos Cari','Pos '+k.kod,
      '',@FisTarih,k.muhkod,@MasId,@FisTarih,@Aciklama,
      sum(giren),0
      from poshrk as h with (nolock) 
      inner join poskart as k with (nolock)  on  k.kod=h.poskod
      where h.sil=0 and h.yertip='pomvardimas' 
      and h.varno in (
      select m.varno From ZraporVardiya as m with (nolock)
      inner join zrapormas as z with (nolock) on z.zrapid=m.zrapid 
      and m.sil=0 and z.sil=0 and z.MasId=@MasId )
      group by k.muhkod,k.kod
      
      
      insert into @TB_LOGO_FATURA
      (TipId,ZrapId,SatirTip,SatirKod,
      FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
      Borc,Alacak)
      Select 2,@MasId,'Veresiye',h.carkod,
      '',@FisTarih,c.muhkod,@MasId,@FisTarih,@Aciklama,
      sum(h.toptut),0
      from veresimas as h with (nolock) 
      inner join carikart as c on h.carkod=c.kod
      where h.sil=0 and h.yertip='pomvardimas' 
      and h.varno in (
      select m.varno From ZraporVardiya as m with (nolock)
      inner join zrapormas as z with (nolock) on z.zrapid=m.zrapid 
      and m.sil=0 and z.sil=0 and z.MasId=@MasId )
      group by h.carkod,c.muhkod
      
    
    end
   
   
   
   /*pos  */
   if @VardiyaTip=2
    begin
    
      insert into @TB_LOGO_FATURA
      (TipId,ZrapId,SatirTip,SatirKod,
      FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
      Borc,Alacak)
      Select 2,@MasId,'Pos Cari','Pos '+k.kod,
      '',@FisTarih,k.muhkod,@MasId,@FisTarih,@Aciklama,
      sum(giren),0
      from poshrk as h with (nolock) 
      inner join poskart as k with (nolock)  on  k.kod=h.poskod
      where h.sil=0 and h.yertip='marvardimas' 
      and h.varno in (
      select m.varno From ZraporVardiya as m with (nolock)
      inner join zrapormas as z with (nolock) on z.zrapid=m.zrapid 
      and m.sil=0 and z.sil=0 and z.MasId=@MasId )
      group by k.muhkod,k.kod
      
      
      insert into @TB_LOGO_FATURA
      (TipId,ZrapId,SatirTip,SatirKod,
      FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
      Borc,Alacak)
      Select 2,@MasId,'Veresiye',h.carkod,
      '',@FisTarih,c.muhkod,@MasId,@FisTarih,@Aciklama,
      sum(h.toptut),0
      from veresimas as h with (nolock)
      inner join carikart as c on h.carkod=c.kod 
      where h.sil=0 and h.yertip='marvardimas' 
      and h.varno in (
      select m.varno From ZraporVardiya as m with (nolock)
      inner join zrapormas as z with (nolock) on z.zrapid=m.zrapid 
      and m.sil=0 and z.sil=0 and z.MasId=@MasId )
      group by h.carkod,c.muhkod
    
    end
   
   
     insert into @TB_LOGO_FATURA
    (ZrapId,SatirTip,SatirKod,
    FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
    Borc,Alacak,Miktar)
    select @MasId,'Kasa','KasaMuhKod',
    '',@FisTarih,@KasaMuhKod,@MasId,@FisTarih,@Aciklama,
    case when sum(Borc-Alacak)<0 then abs(sum(Borc-Alacak)) else 0 end,
    case when sum(Borc-Alacak)>0 then sum(Borc-Alacak) else 0 end,0 from @TB_LOGO_FATURA
    where TipId in (0,2)
    /*group by ZrapId */
    
    
     
   
   /*Z cari kapatma */
    insert into @TB_LOGO_FATURA
    (TipId,ZrapId,SatirTip,SatirKod,
    FisNo,FisTarih,HesapKodu,EvrakNo,EvrakTarih,Aciklama,
    Borc,Alacak,Miktar)
    select 3,@MasId,'Zcari','ZCariKod',
    '',@FisTarih,@ZCariMuh,@MasId,@FisTarih,@Aciklama,
    case when sum(Borc-Alacak)<0 then abs(sum(Borc-Alacak)) else 0 end,
    case when sum(Borc-Alacak)>0 then sum(Borc-Alacak) else 0 end,0 from @TB_LOGO_FATURA
    where TipId=1

 return


END

================================================================================
