-- Function: dbo.UDF_Stok_Fiyat
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.769401
================================================================================

CREATE FUNCTION [dbo].UDF_Stok_Fiyat 
(@tip    		varchar(20),
@SatTip			tinyint,
@kod    		varchar(50),
@Kdvtip 		varchar(20),
@FiyNo   		int)
  RETURNS   float
AS
BEGIN
  
 declare @fiyat    float


if @SatTip=2 /*satis */
 begin
  if @FiyNo=1
   select @fiyat=
   case 
   when k.sat1kdvtip='Dahil' and @Kdvtip='Dahil' then 
   k.sat1fiy 
   when k.sat1kdvtip='Hariç' and @Kdvtip='Dahil' then 
   k.sat1fiy*(1+(k.sat1kdv/100))
   
   when k.sat1kdvtip='Hariç' and @Kdvtip='Hariç' then 
   k.sat1fiy 
   when k.sat1kdvtip='Dahil' and @Kdvtip='Hariç' then 
   k.sat1fiy/(1+(k.sat1kdv/100))
   end 
   from stokkart as k 
   where k.tip=@tip and k.kod=@kod


  if @FiyNo=2
   select @fiyat=
   case 
   when k.sat2kdvtip='Dahil' and @Kdvtip='Dahil' then 
   k.sat2fiy 
   when k.sat2kdvtip='Hariç' and @Kdvtip='Dahil' then 
   k.sat2fiy*(1+(k.sat2kdv/100))
   
   when k.sat2kdvtip='Hariç' and @Kdvtip='Hariç' then 
   k.sat2fiy 
   when k.sat2kdvtip='Dahil' and @Kdvtip='Hariç' then 
   k.sat2fiy/(1+(k.sat2kdv/100))
   end 
   from stokkart as k 
   where k.tip=@tip and k.kod=@kod



   if @FiyNo=3
   select @fiyat=
   case 
   when k.sat3kdvtip='Dahil' and @Kdvtip='Dahil' then 
   k.sat3fiy 
   when k.sat3kdvtip='Hariç' and @Kdvtip='Dahil' then 
   k.sat3fiy*(1+(k.sat3kdv/100))
   
   when k.sat3kdvtip='Hariç' and @Kdvtip='Hariç' then 
   k.sat3fiy 
   when k.sat3kdvtip='Dahil' and @Kdvtip='Hariç' then 
   k.sat3fiy/(1+(k.sat3kdv/100))
   end 
   from stokkart as k 
   where k.tip=@tip and k.kod=@kod


   if @FiyNo=4
   select @fiyat=
   case 
   when k.sat4kdvtip='Dahil' and @Kdvtip='Dahil' then 
   k.sat4fiy 
   when k.sat4kdvtip='Hariç' and @Kdvtip='Dahil' then 
   k.sat4fiy*(1+(k.sat4kdv/100))
   
   when k.sat4kdvtip='Hariç' and @Kdvtip='Hariç' then 
   k.sat4fiy 
   when k.sat4kdvtip='Dahil' and @Kdvtip='Hariç' then 
   k.sat4fiy/(1+(k.sat4kdv/100))
   end 
   from stokkart as k 
   where k.tip=@tip and k.kod=@kod
 end
 
 if @SatTip=1 /*alis */
   begin
   select @fiyat=
   case 
   when k.alskdvtip='Dahil' and @Kdvtip='Dahil' then 
   k.alsfiy 
   when k.alskdvtip='Hariç' and @Kdvtip='Dahil' then 
   k.alsfiy*(1+(k.alskdv/100))
   
   when k.alskdvtip='Hariç' and @Kdvtip='Hariç' then 
   k.alsfiy 
   when k.alskdvtip='Dahil' and @Kdvtip='Hariç' then 
   k.alsfiy/(1+(k.alskdv/100))
   end 
   from stokkart as k 
   where k.tip=@tip and k.kod=@kod
   
   
   
   
   
   end
 
 
 
 

  RETURN @fiyat


END

================================================================================
