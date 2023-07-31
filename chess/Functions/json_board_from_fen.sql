CREATE function [chess].[json_board_from_fen]
( @fen nvarchar(4000)
)
returns nvarchar(max)
as
begin 

	declare @result nvarchar(max)
		, @color_to_move varchar(5)

	declare @fen_squares nvarchar(max)

	select @fen_squares	  = squares
		 , @color_to_move = color_to_move
	from chess.parse_fen(@fen)

	select @result = (
		select 
			isnull(@color_to_move, 'White') as color_to_move
			, (
				select (select [newid] from [tools].[newid]) as id
					, colored_piece_id
					, [col]
					, [row]
				from chess.parse_fen_squares(@fen_squares)
				for json path
			) as pieces
		for json path, without_array_wrapper
		)

	return @result
end