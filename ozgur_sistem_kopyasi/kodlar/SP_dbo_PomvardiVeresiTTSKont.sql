-- Stored Procedure: dbo.PomvardiVeresiTTSKont
-- Tarih: 2026-01-14 20:06:08.357075
================================================================================

CREATE PROCEDURE dbo.PomvardiVeresiTTSKont
(@varno float)
AS
BEGIN
 declare @firmano  int
 declare @TTSKey   varchar(100)
 declare @Tarih    datetime

  select @firmano=firmano,@Tarih=tarih  from pomvardimas with (nolock) where varno=@varno
 
  select @TTSKey=tts_key from otomaskart where firmano=@firmano and tts_key <>'' 
 
 if isnull(@TTSKey,'')<>''
  begin
 
 /*
  SELECT  O.kod AS oCARKOD,v.carkod as vCARKOD,v.TARÃ„Â°H ,O.plaka OPLAKA,V.PLAKA AS VPLAKA,
   o.cartip,v.verid,v.aktip
  from    otomasgenkod AS O 
  INNER JOIN     veresimas AS V  ON V.plaka = O.plaka and v.varno=@varno
  where v.firmano =@firmano and O.otomaskod='TTS' 
  and v.otocarkod in (select * from CsvToSTR(@TTSKey))
  AND o.kod<>v.carkod --and v.plaka='041RA398'

select * from veresimas where verid=29973
and otocarkod in (select * from CsvToSTR(@TTSKey))
--('901395','903182')
*/


 update veresimas set cartip=dt.cartip,carkod=dt.carkod from veresimas as t join 
 (select v.verid,O.kod AS carkod,o.cartip  from  otomasgenkod AS O 
  INNER JOIN  veresimas AS V  ON V.plaka = O.plaka and o.firmano=v.firmano
  and v.varno=@varno and v.tarih>=DATEADD(day,-5,@Tarih) and v.sil=0
  where v.firmano=@firmano  and O.otomaskod='TTS' and v.aktip='BK'
  and v.otocarkod in (select * from CsvToSTR(@TTSKey))
  AND o.kod<>v.carkod) dt on dt.verid=t.verid

end



   /*-vardiya olusumunda versiye fislerine varno atanmamÄ±s ise kontrol  */
    update veresimas set sil=1,
    deguser='VeresiTTSKont',degtarsaat=getdate() where id in (
    select id from veresimas with (NOLOCK) where firmano=@firmano
    and varno=0 and otomas_id in ( 
    select otomas_id from veresimas as v with (NOLOCK)
    where firmano=@firmano and sil=0 and otomas_id>0 and yertip='pomvardimas'  
    group by Tarih,otomas_id
    having count(*)>1) )



   



END

================================================================================
