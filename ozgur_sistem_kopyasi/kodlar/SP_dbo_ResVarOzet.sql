-- Stored Procedure: dbo.ResVarOzet
-- Tarih: 2026-01-14 20:06:08.362889
================================================================================

CREATE PROCEDURE [dbo].[ResVarOzet] @varno float,@tip varchar(10),@tipdty
 varchar(10)
AS
BEGIN

declare @sql         nvarchar(500)
declare @acik         float
declare @fazla         float
declare @perkod     varchar(50)
declare @perad         varchar(50)
declare @yertip     varchar(20)

set @yertip='Resvardimas'

SET NOCOUNT ON

if object_id( 'tempdb..##Resvardiozet' ) is null
CREATE TABLE [dbo].[##Resvardiozet] (
  [id] numeric(18, 0) IDENTITY(1, 1) NOT NULL,
  [varno] float NOT NULL,
  [perkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [perad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [ada] varchar(50) COLLATE Turkish_CI_AS NULL,
  [grs] float  DEFAULT 0 NULL,
  [cks] float DEFAULT 0 NULL,
  [ickkod] varchar(30) COLLATE Turkish_CI_AS NULL,
  [ickad] varchar(50) COLLATE Turkish_CI_AS NULL,
  [sr] float NULL,
  PRIMARY KEY  ([id], [varno]))
  delete from ##Resvardiozet where varno=@varno

/*
AKSAT
VERAT
VERBT
VEROT
POSST
MALST
NAKTS
ODETT
CAROD
PEROD
PRKOD
TAHTT
CARTH
PERTH
PRKTH
GELIR
GIDER

*/


DECLARE marvardiozetx CURSOR FAST_FORWARD FOR SELECT varno from resvardimas
 where varno=@varno
  OPEN marvardiozetx
  FETCH NEXT FROM marvardiozetx INTO  @varno
   WHILE @@FETCH_STATUS = 0
    BEGIN

       insert into ##Resvardiozet (varno,ickkod,ickad,sr,perkod,perad,grs,cks)
       select @varno,'RSSAT','Restaurant Satış - İade Tutarı',1,@perkod,@perad,
       isnull(sum(case when m.Iade=0 then round(h.miktar*(h.birimfiyat)*h.kur,2)
        else 0 end),0),
       isnull(sum(case when m.Iade=1 then round(h.miktar*(h.birimfiyat)*h.kur,2)
        else 0 end),0) 
       from Ressathrk as h inner join Ressatmas as m on m.Id=h.RessatId
       where m.varno=@varno and m.sil=0 

      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'BZPAR',
             'Bozuk Para Tutarı',
             2.0,
             @perkod,
             @perad,
             isnull(sum(bozukpara), 0),
             0
      from Resvardimas
      where varno = @varno
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'VERAT',
             'Veresiye Alacak Tutarı',
             2.1,
             @perkod,
             @perad,
             isnull(sum(toptut -(fiyfarktop + vadfarktop)), 0),
             0
      from veresimas
      where varno = @varno and
            fistip = 'FISALCSAT' and
            sil = 0 and
            adaid = @perkod and
            ototag = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'VERBT',
             'Veresiye Borç Tutarı',
             2.2,
             @perkod,
             @perad,
             0,
             isnull(sum(toptut -(fiyfarktop + vadfarktop)), 0)
      from veresimas
      where varno = @varno and
            fistip = 'FISVERSAT' and
            sil = 0 and
            ototag <> 1 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'POSST',
             'Pos Satış Tutarı',
             3,
             @perkod,
             @perad,
             isnull(sum(case
  when carslip = 1 then giren * kur
  else 0
end), 0),
             isnull(sum(giren * kur), 0)
      from poshrk
      where varno = @varno and
            sil = 0 and
            yertip = @yertip /*
      update ##marvardiozet set grs=dt.giris from ##marvardiozet t join
      (select isnull(sum(giren*kur),0) as giris from poshrk where
      varno=@varno and carkod<>'' and sil=0 and yertip=@yertip)
      dt on t.ickkod='POSST' and t.perkod=@perkod
      */
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'GIDER',
             'Gider Tutarı',
             5,
             @perkod,
             @perad,
             0,
             isnull(sum(borc * kur), 0)
      from carihrk
      where varno = @varno and
            ((islmtip = 'ODE') OR
            (islmhrk = 'IND') and
            (islmtip = 'GLG') OR
            (islmhrk = 'RES')) and
            cartip = 'gelgidkart' and
            sil = 0 and
            yertip = @yertip if @tipdty = 'genel'
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'ODETT',
             'Ödeme Tutarı',
             6,
             @perkod,
             @perad,
             0,
             isnull(sum(cikan * kur), 0)
      from kasahrk
      where varno = @varno and
            ((islmtip = 'ODE' and
            cartip <> 'gelgidkart') or
            (islmtip = 'BNK' and
            islmhrk = 'YTN')) and
            sil = 0 and
            yertip = @yertip if @tipdty = 'detay'
      begin

      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      values (@varno, 'ODETT', 'Ödeme Tutarı', 6, @perkod, @perad, 0, 0)
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'CAROD',
             'Cari Ödemeler',
             8,
             @perkod,
             @perad,
             0,
             isnull(sum(cikan * kur), 0)
      from kasahrk
      where varno = @varno and
            (islmtip = 'ODE' and
            cartip = 'carikart') and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'PEROD',
             'Personel Ödemeler',
             10,
             @perkod,
             @perad,
             0,
             isnull(sum(cikan * kur), 0)
      from kasahrk
      where varno = @varno and
            (islmtip = 'ODE' and
            cartip = 'perkart') and
            sil = 0 and
            yertip = @yertip end;


      if @tipdty='genel'
      begin
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'TAHTT',
             'Tahsilat Tutarı',
             7,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             0
      from kasahrk
      where varno = @varno and
            ((islmtip = 'TAH' and
            cartip <> 'gelgidkart') or
            (islmtip = 'BNK' and
            islmhrk = 'CKN')) and
            sil = 0 and
            yertip = @yertip end;


      if @tipdty='detay'
      begin
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      values (@varno, 'TAHTT', 'Tahsilat Tutarı', 7, @perkod, @perad, 0, 0);


      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'CARTH',
             'Cari Tahsilat',
             9,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             0
      from kasahrk
      where varno = @varno and
            (islmtip = 'TAH' and
            cartip = 'carikart') and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'PERTH',
             'Personel Tahsilat',
             11,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             0
      from kasahrk
      where varno = @varno and
            (islmtip = 'TAH' and
            cartip = 'perkart') and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'PRKTH',
             'Perakende Tahsilat',
             13,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             0
      from kasahrk
      where varno = @varno and
            (islmtip = 'TAH' and
            cartip = 'perakendekart') and
            sil = 0 and
            yertip = @yertip end;



      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'GELIR',
             'Gelir Tutarı',
             20,
             @perkod,
             @perad,
             isnull(sum(alacak * kur), 0),
             0
      from carihrk
      where varno = @varno and
            islmtip = 'TAH' and
            cartip = 'gelgidkart' and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'NAKTS',
             'Nakit Teslimat Tutarı',
             21,
             @perkod,
             @perad,
             0,
             isnull(sum(giren * kur), 0)
      from kasahrk
      where varno = @varno and
            sil = 0 and
            yertip = @yertip and
            islmtip = 'TAH' AND
            islmhrk = 'TES' and
            masterid = 0 if @tipdty = 'detay'
      begin

      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'CEKST',
             'Çek-Senet',
             25,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             isnull(sum(cikan * kur), 0)
      from cekkart
      where varno = @varno and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'BNKCK',
             'Banka Çekilen',
             26,
             @perkod,
             @perad,
             isnull(sum(giren * kur), 0),
             0
      from kasahrk
      where varno = @varno and
            islmtip = 'BNK' and
            islmhrk = 'CKN' and
            sil = 0 and
            yertip = @yertip
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'BNKYT',
             'Banka Yatan',
             27,
             @perkod,
             @perad,
             0,
             isnull(sum(cikan * kur), 0)
      from kasahrk
      where varno = @varno and
            islmtip = 'BNK' and
            islmhrk = 'YTN' and
            sil = 0 and
            yertip = @yertip end;


      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      select @varno,
             'aratp',
             'Ara Toplam',
             40,
             @perkod,
             @perad,
             sum(grs),
             sum(cks)
      from ##resvardiozet
      where varno = @varno
      select @acik =(grs - cks)
      from ##Resvardiozet
      where ickkod = 'aratp' and
            varno = @varno if @acik < 0
      begin
      set @fazla=0;
      set @acik=-@acik;
      end
      else
      begin
      set @fazla=@acik;
      set @acik=0;
      end;

      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      values (@varno, 'ackfz', 'Fark', 41, @perkod, @perad, @acik, @fazla);

      select @acik = sum(grs),
             @fazla = sum(cks)
      from ##Resvardiozet
      where (ickkod = 'aratp' or
            ickkod = 'ackfz') and
            varno = @varno
      insert into ##Resvardiozet(varno, ickkod, ickad, sr, perkod, perad, grs,
       cks)
      values (@varno, 'gentp', 'Genel Toplam', 42, @perkod, @perad, @acik,
       @fazla);



  FETCH NEXT FROM marvardiozetx INTO  @varno
  END
  CLOSE marvardiozetx
  DEALLOCATE marvardiozetx



SET NOCOUNT OFF

/*select sr as id,varno,ickkod,ickad,sr,sum(grs) grs,sum(cks) cks from pomvardiozet */
/*where varno=@varno group by varno,ickkod,ickad,sr order by sr */



END

================================================================================
