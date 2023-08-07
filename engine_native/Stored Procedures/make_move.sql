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
	, @is_white bit
	, @is_king bit
	, @col_from tinyint
	, @row_from tinyint

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
			, @is_king = iif(fen_symbol = 'k', 1, 0)
			, @is_white = is_white
			, @col_from = col
			, @row_from = row
	where id = @piece_id

	-- Castling
	if @is_king = 1
		and @col_to in (2, 6)
		and (@col_from = 4 and @row_from = 0 and @is_white = 1
			or
			@col_from = 4 and @row_from = 7 and @is_white = 0)
	begin
		update engine_native.piece
			set col = case @col_to 
						when 6 then 5
						when 2 then 3 end
		where board_id = @board_id
			and fen_symbol = 'r'
			and is_white = @is_white
			and col = case @col_to 
						when 6 then 7
						when 2 then 0 end
							
	end

	return
end