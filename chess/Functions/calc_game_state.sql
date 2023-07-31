CREATE function chess.calc_game_state(
  @board nvarchar(max)
)
returns varchar(64)
as
begin

	declare 
	  @color_to_move varchar(5) = json_value(@board, '$.color_to_move')
	, @has_move bit = 0
	, @is_king_under_check bit = 0


	if exists(
		select * 
		from chess.parse_pieces(@board) as p
			join chess.colored_piece as cp on cp.id = p.colored_piece_id
			cross apply chess.piece_legal_moves(@board
												, p.id
												, 0 -- attack only
												, 1 -- check king
												) as m
		where cp.color_id = @color_to_move
		)
		set @has_move = 1

	if @has_move = 0
		set @is_king_under_check = chess.is_king_under_check(@board, @color_to_move)
	
	return case 
					when @has_move = 1
						then @color_to_move + ' to move'
					when @is_king_under_check = 1
						then chess.color_opposite(@color_to_move) + ' wins'
					else 'Stalemate'
				end
					

end