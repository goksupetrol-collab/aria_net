-- Function: dbo.UDF_VAR_SATISIADEGRUP_TOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.790477
================================================================================

CREATE FUNCTION UDF_VAR_SATISIADEGRUP_TOPLAM
(@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_SATISIADE_TOPLAM TABLE (
    STOK_ANAGRUPID   INT,
    STOK_ANAGRUP     VARCHAR(50)  COLLATE Turkish_CI_AS,
    STOK_GRUPID      INT,
    STOK_GRUP        VARCHAR(50)  COLLATE Turkish_CI_AS,
    ONCEKIMIKTAR     FLOAT,
    ONCEKITUTAR      FLOAT,
    SATISMIKTAR      FLOAT,
    SATISTUTAR       FLOAT,
    DIGERGRSMIKTAR   FLOAT,
    DIGERGRSTUTAR    FLOAT,
    DIGERCKSMIKTAR   FLOAT,
    DIGERCKSTUTAR    FLOAT,
    IADEMIKTAR       FLOAT,
    IADETUTAR        FLOAT,
    KALANMIKTAR      FLOAT,
    KALANTUTAR       FLOAT,
    SATISTUTARYUZDE            FLOAT,
    SATISMIKTARYUZDE           FLOAT)
AS
BEGIN

  DECLARE @DEPO_KOD       VARCHAR(30)
  DECLARE @STOK_GRUP      VARCHAR(50)
  DECLARE @ONCEKIMIKTAR   FLOAT
  DECLARE @ONCEKITUTAR    FLOAT
  DECLARE @MALALISMIKTAR  FLOAT
  DECLARE @MALALISTUTAR   FLOAT
  DECLARE @SATISTUTAR     FLOAT
  DECLARE @SATISMIKTAR    FLOAT
  DECLARE @IADEMIKTAR     FLOAT
  DECLARE @IADETUAR       FLOAT
  DECLARE @DIGERGRSMIKTAR FLOAT
  DECLARE @DIGERCKSMIKTAR FLOAT

  DECLARE @KALANMIKTAR    FLOAT
  DECLARE @KALANTUTAR     FLOAT


  DECLARE @HRK_MINTARIH     DATETIME
  DECLARE @HRK_MAXTARIH     DATETIME


    declare @Market_Stok_AltGrup int
  
    select @Market_Stok_AltGrup=isnull(Market_Stok_AltGrup,0) From sistemtanim


  DECLARE @TB_GEC_DEP
   TABLE (
    DEPKOD    VARCHAR(50)
   
   )


  DECLARE @TB_GEC_STOKLIST
   TABLE (
   GRUPANA_ID    int,
   GRUPANA_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
   GRUP_ID    int,
   GRUP_AD    VARCHAR(50) COLLATE Turkish_CI_AS,
   actarih      datetime,
   kaptarih      datetime,
   depkod     varchar(50),
   STK_TIP    varchar(50),
   STK_KOD    varchar(50),   
   ONCEKIMIKTAR   FLOAT,
   ONCEKITUTAR   FLOAT,
   KALANMIKTAR   FLOAT,
   KALANTUTAR   FLOAT)

   declare @STK_TIP varchar(20)
   
   SET @STK_TIP='markt'

   if @TIP='marvardimas'
     begin
     
       insert into @TB_GEC_STOKLIST
       (GRUPANA_ID,GRUPANA_AD,GRUP_ID,GRUP_AD,actarih,kaptarih,
       depkod,STK_TIP,STK_KOD)
       select SK.grp1,'',grp.id,grp.ad,
       min(cast(mv.tarih as float)+cast(mv.saat as datetime)),
       max(cast(mv.kaptar as float)+cast(mv.kapsaat as datetime)),
       mv.depkod,sk.tip,sk.kod
       from marvardimas as mv WITH (NOLOCK)
       left join stokkart as sk WITH (NOLOCK) on sk.tip=@STK_TIP
       left join grup as grp WITH (NOLOCK) on grp.id=
       case when sk.grp3>0 then sk.grp3
       when sk.grp2>0 then sk.grp2
       when sk.grp1>0 then sk.grp1 end 
       and grp.sil=0 where mv.sil=0 and mv.varno in (select * from CsvToInt_Max(@VARNIN))
       group by SK.grp1,grp.id,grp.ad,mv.depkod,sk.tip,sk.kod
        
       select  @HRK_MINTARIH=min(actarih),@HRK_MAXTARIH=max(kaptarih) from  @TB_GEC_STOKLIST
      
      /*-onceki stok miktar tutar */
      
      insert into @TB_GEC_DEP (DEPKOD)
      select depkod From @TB_GEC_STOKLIST  group by depkod
      
       
      update @TB_GEC_STOKLIST set ONCEKIMIKTAR=Miktar,
       ONCEKITUTAR=tutar from @TB_GEC_STOKLIST as t join 
       ( select sk.tip,sk.kod,ISNULL(SUM(h.giren-h.cikan),0) Miktar,
       ISNULL(SUM((h.giren-h.cikan)*case when sk.sat1kdvtip='Dahil' then sk.sat1fiy ELSE
       sk.sat1fiy*(1+(sk.sat1kdv/100)) end),0) Tutar
       from stokkart as sk WITH (NOLOCK)
       left join stkhrk as h WITH (NOLOCK) on h.stktip=sk.tip 
       and h.stkod=sk.kod and sk.tip=@STK_TIP and  h.sil=0 
       AND  (h.tarih+cast(h.saat as datetime))<@HRK_MINTARIH
       /*and  h.depkod in ('M0001') */
       and  h.depkod in (select DEPKOD From @TB_GEC_DEP)
       group by sk.tip,sk.kod) dt on t.STK_TIP=dt.tip and t.STK_KOD=kod
      
      
       /*-kalan stok miktar tutar */
       update @TB_GEC_STOKLIST set KALANMIKTAR=Miktar,
       KALANTUTAR=tutar from @TB_GEC_STOKLIST as t join 
       ( select sk.tip,sk.kod,ISNULL(SUM(h.giren-h.cikan),0) Miktar,
       ISNULL(SUM((h.giren-h.cikan)*case when sk.sat1kdvtip='Dahil' then sk.sat1fiy ELSE
       sk.sat1fiy*(1+(sk.sat1kdv/100)) end),0) Tutar
       from stokkart as sk WITH (NOLOCK)
       left join stkhrk as h WITH (NOLOCK) on h.stktip=sk.tip 
       and h.stkod=sk.kod and sk.tip=@STK_TIP  and h.sil=0 
       AND  (h.tarih+cast(h.saat as datetime))<@HRK_MAXTARIH
      /* and  h.depkod in ('M0001' ) */
       and  h.depkod in (select DEPKOD From @TB_GEC_DEP  )
       group by sk.tip,sk.kod) dt on t.STK_TIP=dt.tip and t.STK_KOD=kod
       
     
      if @Market_Stok_AltGrup=0    
      INSERT @TB_SATISIADE_TOPLAM (
      STOK_ANAGRUPID,STOK_ANAGRUP,
      STOK_GRUPID,STOK_GRUP,ONCEKIMIKTAR,ONCEKITUTAR,
      DIGERGRSMIKTAR,DIGERGRSTUTAR,DIGERCKSMIKTAR,DIGERCKSTUTAR,
      SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,KALANMIKTAR,KALANTUTAR)
      SELECT DEP.GRUPANA_ID,DEP.GRUPANA_AD,dep.GRUPANA_ID,dep.GRUPANA_AD,
      sum(ONCEKIMIKTAR),sum(ONCEKITUTAR),
      0,0,0,0,0,0,0,0,sum(KALANMIKTAR),sum(KALANTUTAR)
      FROM @TB_GEC_STOKLIST as dep
      group by DEP.GRUPANA_ID,DEP.GRUPANA_AD
      ORDER BY DEP.GRUPANA_ID,dep.GRUPANA_AD
      
      if @Market_Stok_AltGrup=1    
      INSERT @TB_SATISIADE_TOPLAM (
      STOK_ANAGRUPID,STOK_ANAGRUP,
      STOK_GRUPID,STOK_GRUP,ONCEKIMIKTAR,ONCEKITUTAR,
      DIGERGRSMIKTAR,DIGERGRSTUTAR,DIGERCKSMIKTAR,DIGERCKSTUTAR,
      SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,KALANMIKTAR,KALANTUTAR)
      SELECT DEP.GRUPANA_ID,DEP.GRUPANA_AD,dep.GRUP_ID,dep.GRUP_AD,
      sum(ONCEKIMIKTAR),sum(ONCEKITUTAR),
      0,0,0,0,0,0,0,0,sum(KALANMIKTAR),sum(KALANTUTAR)
      FROM @TB_GEC_STOKLIST as dep
      group by DEP.GRUPANA_ID,DEP.GRUPANA_AD,DEP.GRUP_ID,DEP.GRUP_AD
      ORDER BY DEP.GRUPANA_ID,DEP.GRUPANA_AD,DEP.GRUP_ID,dep.GRUP_AD
     
     
       UPDATE @TB_SATISIADE_TOPLAM SET STOK_ANAGRUP=dt.ad
       from @TB_SATISIADE_TOPLAM as t join (select * from grup ) dt on 
       dt.id=t.STOK_ANAGRUPID
      
        UPDATE @TB_SATISIADE_TOPLAM SET STOK_GRUP=dt.ad
       from @TB_SATISIADE_TOPLAM as t join (select * from grup ) dt on 
       dt.id=t.STOK_GRUPID
     
     
         
      /*  INSERT @TB_SATISIADE_TOPLAM (
      STOK_ANAGRUPID,STOK_ANAGRUP,
      STOK_GRUPID,STOK_GRUP,ONCEKIMIKTAR,ONCEKITUTAR,
      DIGERGRSMIKTAR,DIGERGRSTUTAR,DIGERCKSMIKTAR,DIGERCKSTUTAR,
      SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,KALANMIKTAR,KALANTUTAR)
      SELECT DEP.GRUPANA_ID,DEP.GRUPANA_AD,dep.GRUP_ID,dep.GRUP_AD,
      sum(MIKTAR),sum(TUTAR),
      0,0,0,0,0,0,0,0,0,0 
      FROM DBO.DEPO_TARIHLI_GRUP_STOKIN(@TIP,@VARNIN) as dep
      group by DEP.GRUPANA_ID,DEP.GRUPANA_AD,dep.GRUP_ID,dep.GRUP_AD
      ORDER BY DEP.GRUPANA_ID,dep.GRUP_ID
      */
      
      
      if @Market_Stok_AltGrup=0     
      update @TB_SATISIADE_TOPLAM 
      set SATISMIKTAR=dt.SATISMIKTAR,
      SATISTUTAR=dt.SATISTUTAR,
      IADEMIKTAR=dt.IADEMIKTAR,
      IADETUTAR=dt.IADETUTAR  
      from @TB_SATISIADE_TOPLAM t join
      (select grpid=sk.grp1,
         isnull(sum(case when islmtip='satis' then mhk.mik else -1*mhk.mik end),0) as SATISMIKTAR,
         isnull(sum(case when islmtip='satis' then mhk.mik*((mhk.brmfiy*mhk.kur))
         else -1*mhk.mik*((mhk.brmfiy*mhk.kur)) end),0) SATISTUTAR ,
         isnull(sum(case when islmtip='iade' then mhk.mik else 0 end),0) IADEMIKTAR,
         isnull(sum(case when islmtip='iade' then mhk.mik*((mhk.brmfiy*mhk.kur))
          else 0 end),0) IADETUTAR from marvardimas as mv   WITH (NOLOCK)
         left join marsathrk as mhk  WITH (NOLOCK) on mhk.varno=mv.varno and mv.sil=0 and mhk.sil=0
         left join stokkart as sk  WITH (NOLOCK) on sk.kod=mhk.stkod and sk.tip=mhk.stktip
         where mv.varno in (select * from CsvToInt_Max(@VARNIN))
         group by sk.grp1) dt on 
         dt.grpid=t.STOK_GRUPID
         
         
         
      if @Market_Stok_AltGrup=1     
      update @TB_SATISIADE_TOPLAM 
      set SATISMIKTAR=dt.SATISMIKTAR,
      SATISTUTAR=dt.SATISTUTAR,
      IADEMIKTAR=dt.IADEMIKTAR,
      IADETUTAR=dt.IADETUTAR  
      from @TB_SATISIADE_TOPLAM t join
      (select grpid=case 
      when sk.grp3>0 then sk.grp3 
      when sk.grp2>0 then sk.grp2
      when sk.grp1>0 then sk.grp1 end,
         isnull(sum(case when islmtip='satis' then mhk.mik else -1*mhk.mik end),0) as SATISMIKTAR,
         isnull(sum(case when islmtip='satis' then mhk.mik*((mhk.brmfiy*mhk.kur))
         else -1*mhk.mik*((mhk.brmfiy*mhk.kur)) end),0) SATISTUTAR ,
         isnull(sum(case when islmtip='iade' then mhk.mik else 0 end),0) IADEMIKTAR,
         isnull(sum(case when islmtip='iade' then mhk.mik*((mhk.brmfiy*mhk.kur))
          else 0 end),0) IADETUTAR from marvardimas as mv  WITH (NOLOCK)
         left join marsathrk as mhk  WITH (NOLOCK) on mhk.varno=mv.varno and mv.sil=0 and mhk.sil=0
         left join stokkart as sk  WITH (NOLOCK) on sk.kod=mhk.stkod and sk.tip=mhk.stktip
         where mv.varno in (select * from CsvToInt_Max(@VARNIN))
         group by sk.grp1,sk.grp2,sk.grp3 ) dt on 
         dt.grpid=t.STOK_GRUPID   
    
   end  /*marvardimas  */
   
   
   
    if @TIP='resvardimas'
     begin

     select 
      @HRK_MINTARIH=min(mv.tarih+cast(mv.saat as datetime)),
      @HRK_MAXTARIH=max(mv.kaptarih+cast(mv.kapsaat as datetime))
      from  resvardimas as mv  WITH (NOLOCK) where mv.sil=0 and
      mv.varno  in (select * from CsvToInt_Max(@VARNIN))
   
     
      INSERT @TB_SATISIADE_TOPLAM (
      STOK_ANAGRUPID,STOK_ANAGRUP,
      STOK_GRUPID,STOK_GRUP,
      ONCEKIMIKTAR,ONCEKITUTAR,
      DIGERGRSMIKTAR,DIGERGRSTUTAR,DIGERCKSMIKTAR,DIGERCKSTUTAR,
      SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,
      KALANMIKTAR,KALANTUTAR)
      SELECT DEP.GRUPANA_ID,DEP.GRUPANA_AD,dep.GRUP_ID,dep.GRUP_AD,
      sum(MIKTAR),sum(TUTAR),
      0,0,0,0,0,0,0,0,0,0 
      FROM DBO.DEPO_TARIHLI_GRUP_STOKIN (@TIP,@VARNIN) as dep
      group by DEP.GRUPANA_ID,DEP.GRUPANA_AD,
      dep.GRUP_ID,dep.GRUP_AD
      ORDER BY DEP.GRUPANA_ID,dep.GRUP_ID
      
      
      if @Market_Stok_AltGrup=0     
      update @TB_SATISIADE_TOPLAM 
      set SATISMIKTAR=dt.SATISMIKTAR,
      SATISTUTAR=dt.SATISTUTAR,
      IADEMIKTAR=dt.IADEMIKTAR,
      IADETUTAR=dt.IADETUTAR  
      from @TB_SATISIADE_TOPLAM t join
      (select grpid=sk.grp1,
         isnull(sum(case when m.Iade=0 then mhk.miktar else -1*mhk.miktar end),0) as SATISMIKTAR,
         isnull(sum(case when m.Iade=0 then mhk.miktar*((mhk.birimfiyat*mhk.kur))
         else -1*mhk.miktar*((mhk.birimfiyat*mhk.kur)) end),0) SATISTUTAR ,
         isnull(sum(case when m.Iade=1 then mhk.miktar else 0 end),0) IADEMIKTAR,
         isnull(sum(case when m.Iade=1 then mhk.miktar*((mhk.birimfiyat*mhk.kur))
          else 0 end),0) IADETUTAR from resvardimas as mv  WITH (NOLOCK)
         inner join ressatmas as m  WITH (NOLOCK) on mv.varno=m.varno and m.sil=0
         left join ressathrk as mhk  WITH (NOLOCK) on mhk.ResSatId=m.Id and mv.sil=0 and mhk.sil=0
         left join stokkart as sk  WITH (NOLOCK) on sk.id=mhk.StkId and sk.tip_id=mhk.stktipId
         where mv.varno in (select * from CsvToInt_Max(@VARNIN))
         group by sk.grp1) dt on 
         dt.grpid=t.STOK_GRUPID
         
         
         
      if @Market_Stok_AltGrup=1     
      update @TB_SATISIADE_TOPLAM 
      set SATISMIKTAR=dt.SATISMIKTAR,
      SATISTUTAR=dt.SATISTUTAR,
      IADEMIKTAR=dt.IADEMIKTAR,
      IADETUTAR=dt.IADETUTAR  
      from @TB_SATISIADE_TOPLAM t join
      (select grpid=case 
      when sk.grp3>0 then sk.grp3 
      when sk.grp2>0 then sk.grp2
      when sk.grp1>0 then sk.grp1 end,
         isnull(sum(case when m.Iade=0 then mhk.miktar else -1*mhk.miktar end),0) as SATISMIKTAR,
         isnull(sum(case when m.Iade=0 then mhk.miktar*((mhk.birimfiyat*mhk.kur))
         else -1*mhk.miktar*((mhk.birimfiyat*mhk.kur)) end),0) SATISTUTAR ,
         isnull(sum(case when m.Iade=0 then mhk.miktar else 0 end),0) IADEMIKTAR,
         isnull(sum(case when m.Iade=0 then mhk.miktar*((mhk.birimfiyat*mhk.kur))
          else 0 end),0) IADETUTAR from resvardimas as mv  WITH (NOLOCK) 
          inner join ressatmas as m  WITH (NOLOCK) on mv.varno=m.varno and m.sil=0
         left join ressathrk as mhk  WITH (NOLOCK) on mhk.ResSatId=m.Id  and mv.sil=0 and mhk.sil=0
         left join stokkart as sk  WITH (NOLOCK) on sk.id=mhk.StkId and sk.tip_id=mhk.stktipId
         where mv.varno in (select * from CsvToInt_Max(@VARNIN))
         group by sk.grp1,sk.grp2,sk.grp3 ) dt on 
         dt.grpid=t.STOK_GRUPID   
    
   end  /*resvardimas  */
   
   
   
        
         
         
      /*-diger giris ve cikis */
     
     if @HRK_MAXTARIH is null
     begin 
     
     
     
      if @Market_Stok_AltGrup=0 
       update @TB_SATISIADE_TOPLAM set 
       DIGERGRSMIKTAR=dt.DIGERGRSMIKTAR,
       DIGERGRSTUTAR=DT.DIGERGRSTUTAR,
       DIGERCKSMIKTAR=dt.DIGERCKSMIKTAR,
       DIGERCKSTUTAR=dt.DIGERCKSTUTAR
       from @TB_SATISIADE_TOPLAM t join
      (select grpid=sk.grp1,
         isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
        'IRSAKALS','IRSMRALS','IRSYGALS','HARGIRCIK') then sh.giren else 0 end),0) 
         DIGERGRSMIKTAR,
         isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
        'IRSAKALS','IRSMRALS','IRSYGALS','HARGIRCIK') then (sh.giren*sh.brmfiykdvli) else 0 end),0) 
         DIGERGRSTUTAR,
         isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
         'IRSAKSAT','IRSMRSAT','IRSYGSAT','HARGIRCIK') then sh.cikan else 0 end),0) 
         DIGERCKSMIKTAR,
         isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
         'IRSAKSAT','IRSMRSAT','IRSYGSAT','HARGIRCIK') then (sh.cikan*sh.brmfiykdvli) else 0 end),0) 
         DIGERCKSTUTAR
         
         From stkhrk as sh  WITH (NOLOCK)
         left join stokkart as sk  WITH (NOLOCK) on sk.kod=sh.stkod and sk.tip=sh.stktip 
         and sk.tip='markt' where sh.sil=0  
         and  (sh.tarih+cast(sh.saat as datetime))>=@HRK_MINTARIH
         group by sk.grp1) dt on dt.grpid=t.STOK_GRUPID
     
     
     
      if @Market_Stok_AltGrup=1 
       update @TB_SATISIADE_TOPLAM set 
       DIGERGRSMIKTAR=dt.DIGERGRSMIKTAR,
       DIGERGRSTUTAR=DT.DIGERGRSTUTAR,
       DIGERCKSMIKTAR=dt.DIGERCKSMIKTAR,
       DIGERCKSTUTAR=dt.DIGERCKSTUTAR
       from @TB_SATISIADE_TOPLAM t join
      (select grpid=case 
      when sk.grp3>0 then sk.grp3 
      when sk.grp2>0 then sk.grp2
      when sk.grp1>0 then sk.grp1 end,
         isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
        'IRSAKALS','IRSMRALS','IRSYGALS','HARGIRCIK') then sh.giren else 0 end),0) 
         DIGERGRSMIKTAR,
         isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
        'IRSAKALS','IRSMRALS','IRSYGALS','HARGIRCIK') then (sh.giren*sh.brmfiykdvli) else 0 end),0) 
         DIGERGRSTUTAR,
         isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
         'IRSAKSAT','IRSMRSAT','IRSYGSAT','HARGIRCIK') then sh.cikan else 0 end),0) 
         DIGERCKSMIKTAR,
         isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
         'IRSAKSAT','IRSMRSAT','IRSYGSAT','HARGIRCIK') then (sh.cikan*sh.brmfiykdvli) else 0 end),0) 
         DIGERCKSTUTAR
         
         From stkhrk as sh 
         left join stokkart as sk on sk.kod=sh.stkod and sk.tip=sh.stktip 
         and sk.tip='markt'
         where sh.sil=0  
         and  (sh.tarih+cast(sh.saat as datetime))>=@HRK_MINTARIH
         group by sk.grp1,sk.grp2,sk.grp3) 
         dt on dt.grpid=t.STOK_GRUPID
         
         
         
         
         
         
         
       end
        else
         begin
         
         
          if @Market_Stok_AltGrup=0 
          update @TB_SATISIADE_TOPLAM set 
           DIGERGRSMIKTAR=dt.DIGERGRSMIKTAR,
           DIGERGRSTUTAR=DT.DIGERGRSTUTAR,
           DIGERCKSMIKTAR=dt.DIGERCKSMIKTAR,
           DIGERCKSTUTAR=dt.DIGERCKSTUTAR
          
          from @TB_SATISIADE_TOPLAM t join
          (select grpid=sk.grp1,
             isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
            'IRSAKALS','IRSMRALS','IRSYGALS') then sh.giren else 0 end),0) 
             DIGERGRSMIKTAR,
             isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
            'IRSAKALS','IRSMRALS','IRSYGALS') then (sh.giren*sh.brmfiykdvli) else 0 end),0) 
             DIGERGRSTUTAR,
             isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
             'IRSAKSAT','IRSMRSAT','IRSYGSAT') then sh.cikan else 0 end),0) 
             DIGERCKSMIKTAR,
             isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
             'IRSAKSAT','IRSMRSAT','IRSYGSAT') then (sh.cikan*sh.brmfiykdvli) else 0 end),0) 
             DIGERCKSTUTAR
             From stkhrk as sh 
             left join stokkart as sk on sk.kod=sh.stkod and sk.tip=sh.stktip 
             and sk.tip='markt'
             where sh.sil=0  
             and  (sh.tarih+cast(sh.saat as datetime))>=@HRK_MINTARIH
             and  (sh.tarih+cast(sh.saat as datetime))<=@HRK_MAXTARIH
             group by sk.grp1) 
             dt on dt.grpid=t.STOK_GRUPID
         
         
         
         if @Market_Stok_AltGrup=1 
          update @TB_SATISIADE_TOPLAM set 
           DIGERGRSMIKTAR=dt.DIGERGRSMIKTAR,
           DIGERGRSTUTAR=DT.DIGERGRSTUTAR,
           DIGERCKSMIKTAR=dt.DIGERCKSMIKTAR,
           DIGERCKSTUTAR=dt.DIGERCKSTUTAR
          
          from @TB_SATISIADE_TOPLAM t join
          (select grpid=case 
           when sk.grp3>0 then sk.grp3 
           when sk.grp2>0 then sk.grp2
           when sk.grp1>0 then sk.grp1 end,
             isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
            'IRSAKALS','IRSMRALS','IRSYGALS') then sh.giren else 0 end),0) 
             DIGERGRSMIKTAR,
             isnull(sum(case when islmtip in ('FATAKALS','FATMRALS','FATYGALS','FATIADSAT','FATIADALS',
            'IRSAKALS','IRSMRALS','IRSYGALS') then (sh.giren*sh.brmfiykdvli) else 0 end),0) 
             DIGERGRSTUTAR,
             isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
             'IRSAKSAT','IRSMRSAT','IRSYGSAT') then sh.cikan else 0 end),0) 
             DIGERCKSMIKTAR,
             isnull(sum(case when islmtip in ('FATTOPSAT','FATPERSAT','FATIADSAT','FATIADALS',
             'IRSAKSAT','IRSMRSAT','IRSYGSAT') then (sh.cikan*sh.brmfiykdvli) else 0 end),0) 
             DIGERCKSTUTAR
             
             From stkhrk as sh 
             left join stokkart as sk on sk.kod=sh.stkod and sk.tip=sh.stktip 
             and sk.tip='markt'
             where sh.sil=0  
             and  (sh.tarih+cast(sh.saat as datetime))>=@HRK_MINTARIH
             and  (sh.tarih+cast(sh.saat as datetime))<=@HRK_MAXTARIH
             group by sk.grp1,sk.grp2,sk.grp3) 
             dt on dt.grpid=t.STOK_GRUPID
          
         end
    
       
    
     
   /* update @TB_SATISIADE_TOPLAM set 
    KALANMIKTAR=(ONCEKIMIKTAR+DIGERGRSMIKTAR)
    -(SATISMIKTAR+DIGERCKSMIKTAR),    
     KALANTUTAR=((ONCEKIMIKTAR+DIGERGRSMIKTAR)
    -(SATISMIKTAR+DIGERCKSMIKTAR))* (CASE WHEN ONCEKIMIKTAR=0 THEN 0 
     ELSE  (ONCEKITUTAR/ONCEKIMIKTAR) END)
   */
    

    
   /*--GRUP TOPLAM BAŞLIK  */

  
    if @Market_Stok_AltGrup=0
      update @TB_SATISIADE_TOPLAM set STOK_GRUPID=0 

  
   if @Market_Stok_AltGrup=1
    INSERT @TB_SATISIADE_TOPLAM (
    STOK_ANAGRUPID,STOK_ANAGRUP,
    STOK_GRUPID,STOK_GRUP,
    ONCEKIMIKTAR,ONCEKITUTAR,
    DIGERGRSMIKTAR,DIGERGRSTUTAR,DIGERCKSMIKTAR,DIGERCKSTUTAR,
    SATISMIKTAR,SATISTUTAR,IADEMIKTAR,IADETUTAR,
    KALANMIKTAR,KALANTUTAR)
    SELECT DEP.STOK_ANAGRUPID,DEP.STOK_ANAGRUP,0,DEP.STOK_ANAGRUP,
    sum(ONCEKIMIKTAR),SUM(ONCEKITUTAR),
    sum(DIGERGRSMIKTAR),SUM(DIGERGRSTUTAR),sum(DIGERCKSMIKTAR),
    SUM(DIGERCKSTUTAR),SUM(SATISMIKTAR),SUM(SATISTUTAR),
    SUM(IADEMIKTAR),SUM(IADETUTAR),SUM(KALANMIKTAR),SUM(KALANTUTAR)
    FROM @TB_SATISIADE_TOPLAM dep
    group by DEP.STOK_ANAGRUPID,DEP.STOK_ANAGRUP
    ORDER BY DEP.STOK_ANAGRUPID
    
   set @SATISTUTAR=0
   set @SATISMIKTAR=0
   
    if @Market_Stok_AltGrup=0 
      select @SATISTUTAR=sum(SATISTUTAR),@SATISMIKTAR=sum(SATISMIKTAR) from @TB_SATISIADE_TOPLAM
   
    if @Market_Stok_AltGrup=1 
      select @SATISTUTAR=sum(SATISTUTAR),@SATISMIKTAR=sum(SATISMIKTAR) from @TB_SATISIADE_TOPLAM
      WHERE STOK_GRUPID>0
      
   
   
   UPDATE @TB_SATISIADE_TOPLAM SET 
   SATISTUTARYUZDE=
   CASE WHEN @SATISTUTAR>0 THEN ROUND((SATISTUTAR/@SATISTUTAR)*100,2) ELSE 0 END,
   SATISMIKTARYUZDE=
   CASE WHEN @SATISMIKTAR>0 THEN ROUND((SATISMIKTAR/@SATISMIKTAR)*100,2) ELSE 0 END


  RETURN


end

================================================================================
