-- Stored Procedure: dbo.SpCariTarihBorcAlacakRapor
-- Tarih: 2026-01-14 20:06:08.371887
================================================================================

CREATE PROCEDURE dbo.SpCariTarihBorcAlacakRapor
@Firmano     int,
@CarTip    varchar(20),
@CarKodIn  varchar(8000),
@BasTarih   Datetime,
@BitTarih   Datetime
AS
BEGIN
  

   declare @Table table ( 
   id               int ,
   Tip              varchar(30),
   Kod              varchar(30),
   Unvan            varchar(250),
   GrupAd           varchar(150),
   DevirBorc     float default 0,
   DevirAlacak     float default 0,
   Borc     float default 0,
   Alacak     float default 0,
   ToplamBorc     float default 0,
   ToplamAlacak   float default 0  
   ) 



DECLARE @EKSTRE_CARITEMP TABLE (
 id         int,
 Firmano    int,
 cartip      varchar(20),
 carkod      varchar(30) COLLATE Turkish_CI_AS,
 carunvan      varchar(250) COLLATE Turkish_CI_AS,
 GrupAd        varchar(150) COLLATE Turkish_CI_AS )

declare @separator char(1) 
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@CarKodIn)) > 0)
 BEGIN
  set @CarKodIn = @CarKodIn + ','
 END

 while patindex('%,%' , @CarKodIn) <> 0
 begin

   select @separator_position =  patindex('%,%' , @CarKodIn)
   select @array_value = left(@CarKodIn, @separator_position - 1)

  Insert @EKSTRE_CARITEMP 
  Values (0,0,@CarTip,@array_value,'','')

   select @CarKodIn = stuff(@CarKodIn, 1, @separator_position, '')
 end

  if @CarKodIn=''
    Insert @EKSTRE_CARITEMP 
    select id,firmano,@CarTip,kod,ad,grupad1 from Genel_Kart as vc 
    where vc.cartp=@CarTip  and vc.sl=0 
    
 
   update @EKSTRE_CARITEMP set id=dt.id,firmano=dt.firmano,carunvan=dt.ad,
   GrupAd=dt.grupad1 
   from @EKSTRE_CARITEMP as t join
   (select id,firmano,kod,ad,grupad1 from Genel_Kart as vc 
   where vc.cartp=@CarTip  ) dt
   on t.carkod=dt.kod
 

 
   if (@Firmano>0)
    delete @EKSTRE_CARITEMP where Firmano not in (0,@Firmano)
  
   
   insert into  @Table (id,Tip,Kod,Unvan,GrupAd)
    select id,cartip,carkod,carunvan,GrupAd from @EKSTRE_CARITEMP
 
  if @CarTip in ('carikart','perkart','gelgidkart')
   begin
    update @Table set 
    DevirBorc=case when dt.toplam>0 then (dt.toplam) else 0 end, 
    DevirAlacak=case when dt.toplam<0 then abs(dt.toplam) else 0 end 
    From @Table as t 
    join (select carkod,round(sum(h.borc-h.alacak),2) toplam from carihrk as h with (nolock)
    where cartip=@CarTip and carkod in (select carkod from @EKSTRE_CARITEMP ) 
    and sil=0 and Tarih<@BasTarih group by carkod ) dt on dt.carkod=t.kod

    update @Table set Borc=dt.borc, 
    Alacak=dt.alacak From @Table as t 
    join (select carkod,round(sum(h.borc-h.alacak),2) toplam,round(sum(h.borc),2) borc,
	round(sum(h.alacak),2) alacak   from carihrk as h with (nolock)
    where cartip=@CarTip and carkod in (select carkod from @EKSTRE_CARITEMP ) 
    and sil=0 and Tarih>=@BasTarih and Tarih<=@BitTarih  group by carkod ) dt on dt.carkod=t.kod
   end
   
   
  if @CarTip in ('bankakart')
   begin
    update @Table set 
    DevirBorc=case when dt.toplam>0 then (dt.toplam) else 0 end, 
    DevirAlacak=case when dt.toplam<0 then abs(dt.toplam) else 0 end 
    From @Table as t 
    join (select bankod,round(sum(h.borc-h.alacak),2) toplam from bankahrk as h with (nolock)
    where  bankod in (select carkod from @EKSTRE_CARITEMP ) 
    and sil=0 and Tarih<@BasTarih group by bankod ) dt on dt.bankod=t.kod

    update @Table set Borc=dt.borc, 
    Alacak=dt.alacak From @Table as t 
    join (select bankod,round(sum(h.borc-h.alacak),2) toplam,round(sum(h.borc),2) borc,
	round(sum(h.alacak),2) alacak   from bankahrk as h with (nolock)
    where  bankod in (select carkod from @EKSTRE_CARITEMP ) 
    and sil=0 and Tarih>=@BasTarih and Tarih<=@BitTarih  group by bankod ) dt on dt.bankod=t.kod
   end 
   
  
   
    update @Table set ToplamBorc=
    case when (DevirBorc+Borc)-(DevirAlacak+Alacak)>0 then (DevirBorc+Borc)-(DevirAlacak+Alacak) else 0 end,
    ToplamAlacak=case when (DevirBorc+Borc)-(DevirAlacak+Alacak)<0 then abs((DevirBorc+Borc)-(DevirAlacak+Alacak)) else 0 end

     select * from @Table
    return

END

================================================================================
