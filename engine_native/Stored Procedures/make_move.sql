CREATE proc [engine_native].[make_move] 
  @board_id uniqueidentifier
, @piece_id uniqueidentifier
, @col_to tinyint
, @row_to tinyint
, @move_id uniqueidentifier = null out
with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @captured_piece_id uniqueidentifier

	update engine_native.board set
		  white_to_move = ~white_to_move
		, half_moves += 1
		-- TODO:
		--, white_king_castling = ...
		--, white_queen_castling = ...
		--, black_king_castling = ...
		--, black_queen_castling = ...
		--, en_passant_col = ...
	where id = @board_id

	update engine_native.piece set
		  is_captured = 1
		, @captured_piece_id = id
	where board_id = @board_id
		and col = @col_to
		and row = @row_to
		and is_captured = 0

	set @move_id = newid()
	insert engine_native.move(id, piece_id, col_from, row_from, col_to, row_to, captured_piece_id)
		select @move_id, @piece_id, col, row, @col_to, @row_to, @captured_piece_id
		from engine_native.piece
		where id = @piece_id
	
	update engine_native.piece
		set   col = @col_to
			, row = @row_to
	where id = @piece_id

	return
end