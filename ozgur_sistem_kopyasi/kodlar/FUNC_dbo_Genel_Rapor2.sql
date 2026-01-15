-- Function: dbo.Genel_Rapor2
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.661974
================================================================================

CREATE FUNCTION dbo.Genel_Rapor2 (
@Firmano int,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
    @TB_GENEL_2 TABLE (
    ID			int IDENTITY(1, 1) NOT NULL,
    GRP_ID		int,
    HESAP     VARCHAR(150)  COLLATE Turkish_CI_AS,
    ACK     VARCHAR(150)  COLLATE Turkish_CI_AS,
    GIREN      FLOAT,
    CIKAN       FLOAT,
    BAKIYE          FLOAT)
AS
BEGIN

  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 1,'AKARYAKIT GELİRLERİ','',
  isnull(sum(h.cikan*h.brmfiykdvli),0),
  0,/*isnull(sum(h.giren*h.brmfiykdvli),0), */
  0
  FROM  stokkart as st
  inner join stkhrk as h on st.kod=h.stkod and h.stktip=st.tip
  and h.sil=0 and st.sil=0
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  where st.tip='akykt'
  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 2,'MAKKET GELİRLERİ','',
  isnull(sum(h.cikan*h.brmfiykdvli),0),
  0,/*isnull(sum(h.giren*h.brmfiykdvli),0), */
  0
  FROM  stokkart as st
  inner join stkhrk as h on st.kod=h.stkod and h.stktip=st.tip
  and h.sil=0 and st.sil=0
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  where st.tip='markt'  
  
  
  /*3 pompaci gelirleri */
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 3,'POMPACI GELİRLERİ','',0,0,0 
  
  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 4,k.ad,'',0,isnull(sum(h.giren),0),0
  FROM poskart as k
  inner join poshrk as h on k.kod=h.poskod and h.PosIsle=0
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  group by k.ad
  
  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 5,h.carkod,'',isnull(sum(h.giren),0),0,0
  FROM poskart as k
  inner join poshrk as h on k.kod=h.poskod 
  and h.PosIsle=1 and h.carkod<>''
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  group by h.carkod
  
    
  

  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 6,h.carkod,'',
  ISNULL(SUM(case when fistip='FISALCSAT' THEN h.toptut-h.isktop else 0 end),0),
  0,0
  FROM veresimas as h
  where h.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  group by h.carkod
  
  
   DELETE FROM @TB_GENEL_2 WHERE GIREN=0 and CIKAN=0 and GRP_ID=6
  
  
   declare @Pos_Top1  float
   declare @Pos_Top2  float
     
   select @Pos_Top1=sum(CIKAN) from @TB_GENEL_2 where GRP_ID=4
   
   select @Pos_Top2=isnull(sum(h.giren),0) FROM poskart as k
   inner join poshrk as h on k.kod=h.poskod 
   and h.PosIsle=1 and k.sil=0 and 
   h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  
    
  
  /*7 rapor farkı */
  if ISNULL((@Pos_Top1-@Pos_Top2),0)>=0
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 7,'RAPOR FARKLARI','',ISNULL((@Pos_Top1-@Pos_Top2),0),0,0
   else
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 7,'RAPOR FARKLARI','',0,-1*(@Pos_Top1-@Pos_Top2),0 
  

  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 10,'VERESİYE FİŞİ','',
  0,ISNULL(SUM(case when fistip='FISVERSAT' THEN h.toptut-h.isktop else 0 end),0),
  0
  FROM veresimas as h
  where h.sil=0 and h.Ototag=0 
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  
  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 11,'TAŞITMATİK SATIŞLARI','',
  0,ISNULL(SUM(case when fistip='FISVERSAT' THEN h.toptut-h.isktop else 0 end),0),
  0
  FROM veresimas as h
  where h.sil=0 and h.Ototag=1 
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  
  
  
  INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
  select 12,'IST. TAŞITMATİK SATIŞLARI','',
  0,ISNULL(SUM(case when fistip='FISVERSAT' THEN h.toptut-h.isktop else 0 end),0),
  0
  FROM veresimas as h
  where h.sil=0 and h.Ototag=2 
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  
  
   /*13 Peşin SATIŞLAR */
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 13,'PEŞİN SATIŞLAR','',0,0,0 
   
   
    /*14 PROMOSYON GİDERLERİ */
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 14,'PROMOSYON GİDERLERİ','',0,0,0 
   
   
   /*15 GÜNLÜK GİDERLER */
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 15,'GÜNLÜK GİDERLER','',0,0,0  
     
   
   /*16 POMPACI AÇIK/FAZLA */
   INSERT @TB_GENEL_2 (GRP_ID,HESAP,ACK,GIREN,CIKAN,BAKIYE)
   select 16,'POMPACI AÇIK/FAZLA','',0,0,0  
   
   
   
  declare @Id int
  declare @Giren float
  declare @Cikan float
  declare @Bakiye float
  set @Bakiye=0
  declare pom_var CURSOR FAST_FORWARD  FOR 
  select ID,GIREN,CIKAN from @TB_GENEL_2
   open pom_var
  fetch next from  pom_var into @Id,@Giren,@Cikan
  while @@FETCH_STATUS=0
   begin
   set @Bakiye=@Bakiye+@Giren-@Cikan
   
   update @TB_GENEL_2 set  BAKIYE=@Bakiye where Id=@Id
   
   FETCH next from  pom_var into @Id,@Giren,@Cikan
  end
 close Pom_Var
 deallocate pom_var
   
   

   RETURN
END

================================================================================
