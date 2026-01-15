-- Stored Procedure: dbo.SpFaturaHrkKarAnaliz
-- Tarih: 2026-01-14 20:06:08.372538
================================================================================

CREATE PROCEDURE dbo.SpFaturaHrkKarAnaliz
@FatId    int
AS
BEGIN
  

  Create Table #FatHrkKarAnaliz (
   Firmano              int,
   FatId   				int,
   StokTipId            int,
   StokId               int,
   STOK_KOD   			varchar(50),
   Barkod     			varchar(50),
   STOK_AD    			varchar(250),
   MIKTAR     			float,
   KDV        			float,
   STOK_BIRIM   varchar(50),
   BIRIM_FIYAT 			float,
   BIRIM_FIYATKDVLI   	float,
   TUTAR                float,
   TUTARKDVLI 			float,
   SAT_BIRIM_FIYATKDVLI float,
   SAT_TUTARKDVLI	    float,
   KAR_YUZDE    		float,
      
   TEDARIKFIYATKDVLI         float Default 0,
   MARJYUZDE            float Default 100,
   TEDARIKMARJFIYAT         float Default 0,
   TEDARIKMARJFARK          float Default 0,
   TEDARIKMARJTUTAR    		float Default 0
  )


insert into #FatHrkKarAnaliz (Firmano,FatId,StokTipId,StokId,
STOK_KOD,Barkod,STOK_AD,MIKTAR,KDV,STOK_BIRIM,
BIRIM_FIYAT,BIRIM_FIYATKDVLI,TUTAR,TUTARKDVLI,
SAT_BIRIM_FIYATKDVLI,SAT_TUTARKDVLI,KAR_YUZDE)

select fm.firmano, 
fhrk.fatid,gstk.Tip_id,gstk.id,
fhrk.stkod AS STOK_KOD,
fhrk.barkod,
gstk.ad as STOK_AD,
(fhrk.mik) MIKTAR,
(fhrk.kdvyuz*100) as KDV,
fhrk.brim AS STOK_BIRIM,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut)) BIRIM_FIYAT,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz) BIRIM_FIYATKDVLI,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*fhrk.mik TUTAR,
((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz)*fhrk.mik TUTARKDVLI,
case when gstk.sat1kdvtip='Dahil' then  sat1fiy 
else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END SAT_BIRIM_FIYATKDVLI,

fhrk.mik*case when gstk.sat1kdvtip='Dahil' then  sat1fiy 
else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END SAT_TUTARKDVLI,
0 KAR_YUZDE
/*
 -1*round( (1-((case when gstk.sat1kdvtip='Dahil' then  sat1fiy else gstk.sat1fiy*(1+(gstk.sat1kdv/100)) END) / 
 (case when ((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz)=0 then
 1 else ((fhrk.brmfiy+fhrk.otvbrim)-(fhrk.satisktut+fhrk.genisktut))*(1+fhrk.kdvyuz) end)))*100,2) KAR_YUZDE
 */


  from faturahrk AS fhrk WITH (NOLOCK)
  inner join faturamas as fm  WITH (NOLOCK) on fm.fatid=fhrk.fatid and fm.sil=0
  inner join gelgidlistok as gstk WITH (NOLOCK) 
  on gstk.kod=fhrk.stkod
  and fhrk.stktip=gstk.tip 
  where fhrk.fatid=@FatId and fhrk.sil=0 

 
 Create Table #StokFiyatAnaliz (
  Tarih    Datetime
   
 )
 
 insert into #StokFiyatAnaliz (Tarih)
 select max(Tarih) from StokFiyatLog (nolock)
 where sil=0 and Tarih <= (select top 1 Tarih From faturamas (nolock) 
 Where Fatid=@FatId and Sil=0 ) and StokId in (select StokId from #FatHrkKarAnaliz )
 group by Firmano,StokTipId,StokId
 order by Max(Tarih) desc  
 

 update #FatHrkKarAnaliz SET 
 TEDARIKFIYATKDVLI=dt.TedarikFiyat,
 MARJYUZDE=dt.MarjYuzde,
 SAT_BIRIM_FIYATKDVLI=dt.SatisFiyat,
 SAT_TUTARKDVLI=dt.SatisFiyat*MIKTAR 
 from #FatHrkKarAnaliz as t join (
 select Firmano,StokTipId,StokId,
 SatisFiyat,TedarikFiyat,MarjYuzde from StokFiyatLog (nolock)
 where Sil=0 and Tarih in (select Tarih from #StokFiyatAnaliz) )
 dt on dt.StokTipId=t.StokTipId and dt.StokId=t.StokId
 and dt.Firmano=t.Firmano
 
 update  #FatHrkKarAnaliz SET TEDARIKMARJFIYAT=((SAT_BIRIM_FIYATKDVLI-TEDARIKFIYATKDVLI)*MARJYUZDE)/100
 
 update  #FatHrkKarAnaliz SET TEDARIKMARJFARK=(TEDARIKMARJFIYAT-(SAT_BIRIM_FIYATKDVLI-BIRIM_FIYATKDVLI))
 
 update #FatHrkKarAnaliz SET  TEDARIKMARJTUTAR=TEDARIKMARJFARK*MIKTAR
 
 
 update #FatHrkKarAnaliz SET  KAR_YUZDE=
 case when SAT_BIRIM_FIYATKDVLI=0 then 0 else 
 ((SAT_BIRIM_FIYATKDVLI-BIRIM_FIYATKDVLI)/SAT_BIRIM_FIYATKDVLI)*100
 end


 select *,(SAT_TUTARKDVLI-TUTARKDVLI) FARK_TUTAR from #FatHrkKarAnaliz


END

================================================================================
