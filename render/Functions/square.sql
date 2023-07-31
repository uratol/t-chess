CREATE function [render].[square]
( @piece_symbol nchar(1)
, @is_square_dark bit
, @is_piece_white bit
, @highlite tinyint --  1 selected piece, 2 - legal move, 3 - last move from, 4 - last move to
)
returns nvarchar(max)
begin
	
	return [render].[sprite](
			  concat(' ', isnull(@piece_symbol, ' '), ' ')
			, case 
				when @highlite = 1 then '42'
				when @highlite = 2 then '46'
				when @highlite = 3 then '44'
				when @highlite = 4 then '104'
				when @is_square_dark = 1 then '0;100'
				else '47' end
				+ ';'
				+ iif(@is_piece_white = 0, '30', '97')
				+ 'm'
		)

end