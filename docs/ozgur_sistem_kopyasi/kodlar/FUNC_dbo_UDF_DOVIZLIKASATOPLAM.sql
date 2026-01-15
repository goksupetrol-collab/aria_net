-- Function: dbo.UDF_DOVIZLIKASATOPLAM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.711362
================================================================================

CREATE FUNCTION [dbo].UDF_DOVIZLIKASATOPLAM (
@yertip varchar(20),
@VARNIN varchar(4000))
RETURNS
@TB_KASA_DOVIZLI TABLE (
    KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD         VARCHAR(20)   COLLATE Turkish_CI_AS,
    KURYTL        FLOAT,
    NAKIT         FLOAT,
    KREDIKART     FLOAT,
    YTLTOPLAM        FLOAT )
AS
BEGIN

DECLARE @KOD VARCHAR(10)
DECLARE @KUR FLOAT

/*PARA BIRIMLERI */

 declare @tarih datetime

 if @yertip='marvardimas'
   select @tarih=max(tarih) from markasahrk where 
   sil=0 and  varno in (select * from CsvToInt(@VARNIN) )
  /* else */
  /* set @tarih=getdate() */
  
  
  if @yertip='resvardimas'
   select @tarih=max(tarih) from resSatkasahrk where 
    sil=0 and  varno in (select * from CsvToInt(@VARNIN) )
 



     insert into @TB_KASA_DOVIZLI 
        select kod,ad,1,0,0,0 from parabrm order by kod
        
 DECLARE gunkurlar CURSOR FAST_FORWARD FOR SELECT KOD FROM @TB_KASA_DOVIZLI
 OPEN gunkurlar
 FETCH NEXT FROM gunkurlar INTO  @KOD
 WHILE @@FETCH_STATUS = 0
 BEGIN
 set @KUR=1
 
 IF @KOD='EURO'
 SELECT @KUR=dov_satis FROM para_kur WHERE Kod=@KOD and tarih=(SELECT MAX(tarih) FROM para_kur where Tarih<=@tarih)
 IF @KOD='USD'
 SELECT @KUR=dov_satis FROM para_kur WHERE Kod=@KOD and tarih=(SELECT MAX(tarih) FROM para_kur where Tarih<=@tarih )
 IF @KOD='GBP'
 SELECT @KUR=dov_satis FROM para_kur WHERE Kod=@KOD and tarih=(SELECT MAX(tarih) FROM para_kur where Tarih<=@tarih)




 UPDATE @TB_KASA_DOVIZLI SET KURYTL=@KUR WHERE KOD=@KOD
 
  FETCH NEXT FROM gunkurlar INTO  @KOD
  END
 CLOSE gunkurlar
 DEALLOCATE gunkurlar

        

/*PARA BIRIMLERI */

  if @yertip='marvardimas'
  update @TB_KASA_DOVIZLI  set 
  NAKIT=NAKIT+dt.nakl,
  KREDIKART=KREDIKART+dt.krel,
  YTLTOPLAM=(NAKIT+dt.nakl)*KURYTL from @TB_KASA_DOVIZLI  t
   INNER JOIN (select h.parabrm,
   SUM(h.giren-h.cikan) as nakl,
   0 as krel FROM markasahrk as h
   inner join marsatmas as m  on m.marsatid=h.marsatid 
   where m.sil=0 and h.sil=0 and
   m.varno in (select * from CsvToInt(@VARNIN) )
   group by h.parabrm ) 
   as dt on dt.parabrm=t.kod
 
 
 
 if @yertip='resvardimas'
  update @TB_KASA_DOVIZLI  set 
  NAKIT=NAKIT+dt.nakl,
  KREDIKART=KREDIKART+dt.krel,
  YTLTOPLAM=(NAKIT+dt.nakl)*KURYTL from @TB_KASA_DOVIZLI  t
   INNER JOIN (select h.parabirim,
   SUM(h.Tutar) as nakl,
   0 as krel FROM ResSatkasahrk as h
   inner join Ressatmas as m  on m.Id=h.RessatId 
   where m.sil=0 and h.sil=0 and
   m.varno in (select * from CsvToInt(@VARNIN) )
   group by h.parabirim ) 
   as dt on dt.parabirim=t.kod
 
 

 RETURN



END

================================================================================
