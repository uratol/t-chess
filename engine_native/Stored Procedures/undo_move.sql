CREATE proc [engine_native].[undo_move] 
  @board_id uniqueidentifier
, @move_id uniqueidentifier
with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @piece_id uniqueidentifier
		, @captured_piece_id uniqueidentifier
		, @col_from tinyint
		, @row_from tinyint

	select @piece_id = m.piece_id
		, @col_from = m.col_from
		, @row_from = m.row_from
		, @captured_piece_id = m.captured_piece_id
	from engine_native.move as m
	where m.id = @move_id

	update engine_native.board set
		  white_to_move = ~white_to_move
		, half_moves -= 1
		-- TODO:
		--, white_king_castling = ...
		--, white_queen_castling = ...
		--, black_king_castling = ...
		--, black_queen_castling = ...
		--, en_passant_col = ...
	where id = @board_id

	update engine_native.piece set
		  is_captured = 0
	where board_id = @board_id
		and id = @captured_piece_id

	update engine_native.piece
		set   col = @col_from
			, row = @row_from
	where board_id = @board_id
		and id = @piece_id

	delete engine_native.move
	where id = @move_id

end