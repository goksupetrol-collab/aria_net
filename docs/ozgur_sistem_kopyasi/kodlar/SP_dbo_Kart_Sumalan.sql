-- Stored Procedure: dbo.Kart_Sumalan
-- Tarih: 2026-01-14 20:06:08.340065
================================================================================

CREATE PROCEDURE [dbo].Kart_Sumalan
AS
BEGIN
declare @tabload varchar(30)

 truncate TABLE kartsumalan

 /*carikart */
 set @tabload='carikart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'carbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisakadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'cekbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisaktut')
 insert into kartsumalan (tabload,alanad) values (@tabload,'actutar')
 insert into kartsumalan (tabload,alanad) values (@tabload,'sonhrktar')
 insert into kartsumalan (tabload,alanad) values (@tabload,'sonfistarih')
 insert into kartsumalan (tabload,alanad) values (@tabload,'sonfistutar')


 /*perkart */
 set @tabload='perkart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'carbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisakadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisaktut')
 insert into kartsumalan (tabload,alanad) values (@tabload,'actutar')

 /*gelir gider kart */
 set @tabload='gelgidkart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'carbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisakadet')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisaktut')
 insert into kartsumalan (tabload,alanad) values (@tabload,'actutar')

 /*bankakart */
 set @tabload='bankakart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'borc')
 insert into kartsumalan (tabload,alanad) values (@tabload,'alacak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'actutar')

 /*pos kart */
 set @tabload='poskart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'bekbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'kombak')

 /*ist kredi kart */
 set @tabload='istkart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'borc')
 insert into kartsumalan (tabload,alanad) values (@tabload,'alacak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'actutar')


 /*perekandekart */
 set @tabload='perekandekart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'carbak')
 insert into kartsumalan (tabload,alanad) values (@tabload,'fisadet')


  /*tank kart */
 set @tabload='tankkart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'alsmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'satmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'acmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'alskdvlitoptut')
 insert into kartsumalan (tabload,alanad) values (@tabload,'satkdvlitoptut')


  /*stok kart */
 set @tabload='stokkart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'alsmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'satmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'acmik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'alsiademik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'alsiadekdvlitoptut')
 insert into kartsumalan (tabload,alanad) values (@tabload,'satiademik')
 insert into kartsumalan (tabload,alanad) values (@tabload,'satiadekdvlitoptut')


 /*sayackart kart */
 set @tabload='sayackart'
 insert into kartsumalan (tabload,alanad) values (@tabload,'sonendks')



END

================================================================================
