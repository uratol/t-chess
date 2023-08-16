-- WARNING!. This object is auto-generated from template [template].[engine_native.minimax].
-- Do not modify it manually, use [template].[generate_object] instead
CREATE proc engine_native.minimax
  @board_id uniqueidentifier
, @white_to_move bit
, @depth tinyint
, @col_from tinyint = null out
, @row_from tinyint = null out
, @col_to tinyint = null out
, @row_to tinyint = null out
, @estimation real = null out
, @alpha real = -99999999
, @beta real = 99999999

as
begin 

	declare 
		  @piece_id uniqueidentifier
		, @piece_col tinyint
		, @piece_row tinyint
		, @move_col tinyint
		, @move_row tinyint
		, @move_id uniqueidentifier
		, @log_data nvarchar(max)

	if @depth = 0 begin
		exec engine_native.estimate @board_id = @board_id
			, @estimation = @estimation out
		return
	end

	exec [engine_native].[calc_legal_moves_except_king_all_pieces] @board_id = @board_id
																 , @white_to_move = @white_to_move

	declare @legal_moves engine_native.moves

	insert @legal_moves(piece_id, col, row, weight)
		select p.id, lm.col, lm.row, capture.weight
		from engine_native.legal_move as lm  with(repeatableread)
			join engine_native.piece as p  with(repeatableread) on p.id = lm.piece_id
			left join engine_native.piece as capture  with(repeatableread) 
				on capture.board_id = @board_id and capture.col = lm.col and capture.row = lm.row and capture.is_captured = 0
		where p.board_id = @board_id
			and p.is_white = @white_to_move
	
	if @white_to_move = 1
		set @estimation = -99999999
	else
		set @estimation = +99999999

	declare @break bit = 0
	while @break = 0 begin

		set @piece_id = null

		select top(1) 
			  @piece_id = lm.piece_id
			, @piece_col = p.col
			, @piece_row = p.row
			, @move_col = lm.col
			, @move_row = lm.row
		from @legal_moves as lm
			join engine_native.piece as p  with(repeatableread) on p.id = lm.piece_id
		where p.board_id = @board_id
			and p.is_white = @white_to_move
		order by lm.weight desc

		if @piece_id is null
			return

		exec engine_native.make_move @board_id = @board_id
									, @piece_id = @piece_id
									, @col_to = @move_col
									, @row_to = @move_row
									, @move_id = @move_id out

		declare @child_white_to_move bit = ~@white_to_move
			, @child_depth tinyint = @depth - 1
			, @child_estimation real

		
		exec [engine_native].[minimax]
				  @board_id = @board_id
				, @white_to_move = @child_white_to_move
				, @depth = @child_depth
				, @estimation = @child_estimation out
				, @alpha = @alpha
				, @beta = @beta
		

		declare @compare_estimation real = @child_estimation - @estimation

		if @compare_estimation = 0 and rand() > 0.5 -- random move if estimation the same
				or @white_to_move = 1 and @compare_estimation > 0
				or @white_to_move = 0 and @compare_estimation < 0
			select @estimation = @child_estimation
				, @col_from = @piece_col
				, @row_from = @piece_row
				, @col_to = @move_col
				, @row_to = @move_row

		exec engine_native.undo_move @board_id = @board_id
									, @move_id = @move_id

		if @white_to_move = 1 and @estimation > @beta 
			or 
			@white_to_move = 0 and @estimation < @alpha
			set @break = 1 -- BREAK is not allowed in natively compiled objects
		else begin
			if @white_to_move = 1 and @estimation > @alpha 
					set @alpha = @estimation
			else
			if @white_to_move = 0 and @estimation < @beta
					set @beta = @estimation

			delete @legal_moves
			where piece_id = @piece_id
				and col = @move_col
				and row = @move_row
		end

	end	

end