CREATE function [engine_json].[make_move_json](
  @board_json nvarchar(max)
, @col_from int
, @row_from int
, @col_to int
, @row_to int
-- TODO: @turn_pawn_to varchar(6) 
)
returns nvarchar(max)
as
begin

	return (

	select 
		  chess.color_opposite(json_value(@board_json, '$.color_to_move')) as color_to_move
		, (
			select p.id
				, case 
					when piece.is_source = 1 
						and @row_to = 0
						and p.colored_piece_id = 'Black Pawn'
						then 'Black Queen' -- TODO: Implement turn pawn choise to 
					when piece.is_source = 1 
						and @row_to = 7
						and p.colored_piece_id = 'White Pawn'
						then 'White Queen'
					else
						p.colored_piece_id
				 end as colored_piece_id
				, iif(piece.is_source = 1, @col_to, p.col) as col
				, iif(piece.is_source = 1, @row_to, p.row) as row
			from [engine_json].[parse_pieces](@board_json) as p
				cross apply (values
						( iif(p.col = @col_from and p.row = @row_from, 1, 0)
						, iif(p.col = @col_to and p.row = @row_to, 1, 0)
						)
				) as piece(is_source, is_target)
			where piece.is_target = 0
			for json path
		  ) as pieces
	for json path, without_array_wrapper
	) 
end