CREATE proc [engine_native].[board_to_native]
 @board_id uniqueidentifier
as
   
begin tran

	exec [engine_native].[clear_board] @board_id = @board_id

   insert [engine_native].board(id
					, white_to_move
					, white_king_castling
					, white_queen_castling
					, black_king_castling
					, black_queen_castling
					, en_passant_col
					, half_moves)
   select id
		, iif(color_to_move = 'white', 1, 0)
		, 1
		, 1
		, 1
		, 1
		, null
		, 0
   from chess.board
   where id = @board_id

	insert [engine_native].[piece](id
		, [board_id]
		, [fen_symbol]
		, [is_white]
		, [col]
		, [row])
	select bp.id
		, bp.board_id
		, lower(cp.fen_symbol)
		, iif(cp.color_id = 'White', 1, 0)
		, bp.col
		, bp.row
	from chess.board_piece as bp
		join chess.colored_piece as cp on cp.id = bp.colored_piece_id
	where bp.board_id = @board_id
		and bp.is_captured = 0

commit