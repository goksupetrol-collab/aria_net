-- Stored Procedure: dbo.spStokKartOlustur
-- Tarih: 2026-01-14 20:06:08.379976
================================================================================

CREATE PROCEDURE [dbo].[spStokKartOlustur]
       @id DECIMAL=null, 
       @Epdk_Tur INT,
       @Gtip NVARCHAR(4000),
       @KarYuzde FLOAT,
       @Prom BIT,
       @Prom_Kac_Satis INT,
       @Prom_Sat_Puan FLOAT,
       @Prom_Sat_Tip TINYINT,
       @Prom_Urun BIT,
       @Puan_Brm  TINYINT,
       @Puan_Fis FLOAT,
       @Puan_KK FLOAT,
       @Puan_Nakit FLOAT,
       @Puan_Otomas FLOAT,
       @Puan_Tip tinyint,
       @Recete BIT,
       @Remote_id INT,
       @Restaurant BIT,
       @YK_Fiyat INT,
       @acmik FLOAT,
       @ad NVARCHAR(4000),
       @alsfiy FLOAT,
       @alsiadekdvlitoptut FLOAT,
       @alsiademik FLOAT,
       @alskdv FLOAT,
       @alskdvlitoptut FLOAT,
       @alskdvtip NVARCHAR(4000),
       @alsmik FLOAT,
       @alspbrm NVARCHAR(4000),
       @barkod NVARCHAR(4000),
       @brim NVARCHAR(4000),
       @brmcarp FLOAT,
       @brmcarp2 FLOAT,
       @brmust NVARCHAR(4000),
       @brmust2 NVARCHAR(4000),
       @dataok INT,
       @degtarsaat datetime,
       @deguser NVARCHAR(4000),
       @drm  NVARCHAR(4000),
       @eksat NVARCHAR(4000),
       @firmano INT,
       @grp1 INT,
       @grp2 INT,
       @grp3 INT,
       @grpkdvoran FLOAT,
       @karoran1 FLOAT,
       @karoran2 FLOAT,
       @kesft FLOAT,
       @kod NVARCHAR(4000),
       @minmik FLOAT,
       @muh_als_iad_kod NVARCHAR(4000),
       @muh_als_isk_kod NVARCHAR(4000),
       @muh_als_otv_kod  NVARCHAR(4000),
       @muh_sat_iad_kod NVARCHAR(4000),
       @muh_sat_isk_kod NVARCHAR(4000),
       @muh_sat_mal_kod NVARCHAR(4000),
       @muh_sat_otv_kod NVARCHAR(4000),
       @muhckskod NVARCHAR(4000),
       @muhgrskod NVARCHAR(4000),
       @muhonkod NVARCHAR(4000),
       @notack NVARCHAR(4000),
       @olustarsaat  datetime,
       @olususer NVARCHAR(4000),
       @ortalsfiykdvli FLOAT,
       @otv FLOAT,
       @ozel_kod1 INT,
       @ozel_kod2 INT,
       @sat1fiy FLOAT,
       @sat1kdv FLOAT,
       @sat1kdvtip NVARCHAR(4000),
       @sat1pbrm NVARCHAR(4000),
       @sat2fiy FLOAT,
       @sat2kdv FLOAT,
       @sat2kdvtip NVARCHAR(4000),
       @sat2pbrm NVARCHAR(4000),
       @sat3fiy FLOAT,
       @sat3kdv FLOAT,
       @sat3kdvtip NVARCHAR(4000),
       @sat3pbrm NVARCHAR(4000),
       @sat4fiy FLOAT,
       @sat4kdv FLOAT,
       @sat4kdvtip NVARCHAR(4000),
       @sat4pbrm NVARCHAR(4000),
       @satiadekdvlitoptut FLOAT,
       @satiademik FLOAT,
       @satkdvlitoptut FLOAT,
       @satmik FLOAT,
       @sil INT,
       @tip NVARCHAR(4000),
       @tip_id INT,
       @ykno NVARCHAR(4000),
       @zrapor tinyint
AS
BEGIN

       DECLARE @AutoIncId BIGINT

       SET @sat1fiy = Replace(@sat1fiy,',','.')
       SET @sat2fiy = Replace(@sat1fiy,',','.')
       SET @sat3fiy = Replace(@sat1fiy,',','.')
       SET @sat4fiy = Replace(@sat1fiy,',','.')
       SET @alsfiy = Replace(@alsfiy,',','.')

       /* Eğer Remote_Id StokKart içinde yoksa */
       IF NOT EXISTS (SELECT id FROM stokkart WHERE Remote_id = @Remote_id)
       BEGIN
             INSERT INTO [StokKart] ([tip], [kod], [firmano], [barkod], [ad], [sat1fiy], [sat1kdv], [sat1kdvtip], [sat2fiy], [sat2kdv], [sat2kdvtip], [alsfiy], [alskdv], [alskdvtip], [kesft], [brim], [otv], [eksat], [minmik], [drm], [muhgrskod], [muhckskod],  [brmcarp], [brmust], [ykno], [grp1], [grp2], [grp3], [alsmik], [satmik], [sil], [olususer], [olustarsaat], [deguser], [degtarsaat], [dataok], [acmik], [karoran1], [karoran2], [grpkdvoran], [sat1pbrm], [sat2pbrm], [sat3pbrm], [sat4pbrm], [alspbrm], [sat3fiy], [sat3kdv],  [sat3kdvtip], [sat4fiy], [sat4kdv], [sat4kdvtip], [alskdvlitoptut], [satkdvlitoptut], [alsiademik], [alsiadekdvlitoptut], [satiademik], [satiadekdvlitoptut], [ortalsfiykdvli], [brmust2], [brmcarp2], [zrapor], [muh_als_iad_kod], [muh_sat_iad_kod], [muh_als_isk_kod],  [muh_sat_isk_kod], [muh_als_otv_kod], [muh_sat_otv_kod], [muh_sat_mal_kod], [muhonkod], [ozel_kod1], [ozel_kod2], [notack], [tip_id], [Puan_Brm], [Puan_Tip], [Puan_Nakit], [Puan_KK], [Puan_Fis], [Prom], [Prom_Urun], [Prom_Sat_Tip], [Prom_Sat_Puan], [Prom_Kac_Satis],  [Puan_Otomas], [Gtip], [Epdk_Tur], [YK_Fiyat], [Recete], [Restaurant], [Remote_id], [KarYuzde]) values (@tip, @kod, @firmano, @barkod, @ad, @sat1fiy, @sat1kdv, @sat1kdvtip, @sat2fiy, @sat2kdv, @sat2kdvtip, @alsfiy, @alskdv, @alskdvtip, @kesft, @brim, @otv, @eksat,  @minmik, @drm, @muhgrskod, @muhckskod, @brmcarp, @brmust, @ykno, @grp1, @grp2, @grp3, @alsmik, @satmik, @sil, @olususer, @olustarsaat, @deguser, @degtarsaat, @dataok, @acmik, @karoran1, @karoran2, @grpkdvoran, @sat1pbrm, @sat2pbrm, @sat3pbrm, @sat4pbrm, @alspbrm,  @sat3fiy, @sat3kdv, @sat3kdvtip, @sat4fiy, @sat4kdv, @sat4kdvtip, @alskdvlitoptut, @satkdvlitoptut, @alsiademik, @alsiadekdvlitoptut, @satiademik, @satiadekdvlitoptut, @ortalsfiykdvli, @brmust2, @brmcarp2, @zrapor, @muh_als_iad_kod, @muh_sat_iad_kod, @muh_als_isk_kod,  @muh_sat_isk_kod, @muh_als_otv_kod, @muh_sat_otv_kod, @muh_sat_mal_kod, @muhonkod, @ozel_kod1, @ozel_kod2, @notack, @tip_id, @Puan_Brm, @Puan_Tip, @Puan_Nakit, @Puan_KK, @Puan_Fis, @Prom, @Prom_Urun, @Prom_Sat_Tip, @Prom_Sat_Puan, @Prom_Kac_Satis, @Puan_Otomas, @Gtip,  @Epdk_Tur, @YK_Fiyat, @Recete, @Restaurant, @Remote_id, @KarYuzde);
             SET @AutoIncId = (SELECT CAST(SCOPE_IDENTITY()  AS BIGINT) AS [id])
             INSERT INTO barkod(firmano,tip,kod,barkod,olususer,olustarsaat,sil,carpan,brim,tip_id,stk_id,Remote_id)
             SELECT @firmano, 'markt', @kod, @barkod, @olususer, @olustarsaat, 0, @brmcarp,  @brim, @tip_id, @AutoIncId, @AutoIncId
       END
       ELSE
       BEGIN
             UPDATE [StokKart] SET [tip] = @tip, [kod] = @kod, [firmano] = @firmano, [barkod] = @barkod, [ad] = @ad, [sat1fiy] = @sat1fiy, [sat1kdv] = @sat1kdv, [sat1kdvtip] = @sat1kdvtip, [sat2fiy] = @sat2fiy, [sat2kdv] = @sat2kdv, [sat2kdvtip] = @sat2kdvtip,  [alsfiy] = @alsfiy, [alskdv] = @alskdv, [alskdvtip] = @alskdvtip, [kesft] = @kesft, [brim] = @brim, [otv] = @otv, [eksat] = @eksat, [minmik] = @minmik, [drm] = @drm, [muhgrskod] = @muhgrskod, [muhckskod] = @muhckskod, [brmcarp] = @brmcarp, [brmust] = @brmust, [ykno] =  @ykno, [grp1] = @grp1, [grp2] = @grp2, [grp3] = @grp3, [alsmik] = @alsmik, [satmik] = @satmik, [sil] = @sil, [olususer] = @olususer, [olustarsaat] = @olustarsaat, [deguser] = @deguser, [degtarsaat] = @degtarsaat, [dataok] = @dataok, [acmik] = @acmik, [karoran1] =  @karoran1, [karoran2] = @karoran2, [grpkdvoran] = @grpkdvoran, [sat1pbrm] = @sat1pbrm, [sat2pbrm] = @sat2pbrm, [sat3pbrm] = @sat3pbrm, [sat4pbrm] = @sat4pbrm, [alspbrm] = @alspbrm, [sat3fiy] = @sat3fiy, [sat3kdv] = @sat3kdv, [sat3kdvtip] = @sat3kdvtip, [sat4fiy] =  @sat4fiy, [sat4kdv] = @sat4kdv, [sat4kdvtip] = @sat4kdvtip, [alskdvlitoptut] = @alskdvlitoptut, [satkdvlitoptut] = @satkdvlitoptut, [alsiademik] = @alsiademik, [alsiadekdvlitoptut] = @alsiadekdvlitoptut, [satiademik] = @satiademik, [satiadekdvlitoptut] =  @satiadekdvlitoptut, [ortalsfiykdvli] = @ortalsfiykdvli, [brmust2] = @brmust2, [brmcarp2] = @brmcarp2, [zrapor] = @zrapor, [muh_als_iad_kod] = @muh_als_iad_kod, [muh_sat_iad_kod] = @muh_sat_iad_kod, [muh_als_isk_kod] = @muh_als_isk_kod, [muh_sat_isk_kod] =  @muh_sat_isk_kod, [muh_als_otv_kod] = @muh_als_otv_kod, [muh_sat_otv_kod] = @muh_sat_otv_kod, [muh_sat_mal_kod] = @muh_sat_mal_kod, [muhonkod] = @muhonkod, [ozel_kod1] = @ozel_kod1, [ozel_kod2] = @ozel_kod2, [notack] = @notack, [tip_id] = @tip_id, [Puan_Brm] =  @Puan_Brm, [Puan_Tip] = @Puan_Tip, [Puan_Nakit] = @Puan_Nakit, [Puan_KK] = @Puan_KK, [Puan_Fis] = @Puan_Fis, [Prom] = @Prom, [Prom_Urun] = @Prom_Urun, [Prom_Sat_Tip] = @Prom_Sat_Tip, [Prom_Sat_Puan] = @Prom_Sat_Puan, [Prom_Kac_Satis] = @Prom_Kac_Satis, [Puan_Otomas] =  @Puan_Otomas, [Gtip] = @Gtip, [Epdk_Tur] = @Epdk_Tur, [YK_Fiyat] = @YK_Fiyat, [Recete] = @Recete, [Restaurant] = @Restaurant, [Remote_id] = @Remote_id, [KarYuzde] = @KarYuzde where [id] = @id          
       END


END

================================================================================
