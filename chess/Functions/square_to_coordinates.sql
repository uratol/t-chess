CREATE function [chess].[square_to_coordinates](
 @square nvarchar(50)
)
returns table
as
return 
	select 
		  cast(ascii(upper(left(@square, 1))) - 65 as tinyint) as col
		, cast(stuff(@square, 1, 1, '') as tinyint) - 1 as row