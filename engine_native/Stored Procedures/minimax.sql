CREATE proc [engine_native].[minimax]
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
-- TODO:
-- with native_compilation, schemabinding
as
begin -- atomic with (transaction isolation level = repeatable read, language = N'English')

	declare @processed_moves [engine_native].[moves]
		, @piece_id uniqueidentifier
		, @piece_col tinyint
		, @piece_row tinyint
		, @move_col tinyint
		, @move_row tinyint
		, @move_id uniqueidentifier
		, @log_data nvarchar(max)


	if @depth = 0 begin
		exec engine_native.estimate @board_id = @board_id
			, @estimation = @estimation out

		--insert engine_native.logs(data)
		--select iif(@white_to_move = 1, 'W', 'B')
		--		+ replicate('    ', 5 - @depth)
		--		+ '  e:' + cast(@estimation as nvarchar(max))
		return
	end

	exec [engine_native].[calc_legal_moves_except_king_all_pieces] @board_id = @board_id
																 , @white_to_move = @white_to_move

	if @white_to_move = 1
		set @estimation = -99999999
	else
		set @estimation = +99999999

	while 1 = 1 begin

		set @piece_id = null

		select top(1) 
			  @piece_id = lm.piece_id
			, @piece_col = p.col
			, @piece_row = p.row
			, @move_col = lm.col
			, @move_row = lm.row
		from engine_native.legal_move as lm with(repeatableread)
			join engine_native.piece as p with(repeatableread) on p.id = lm.piece_id
		where p.board_id = @board_id
			and p.is_white = @white_to_move
			and not exists(
				select 1
				from @processed_moves as pm
				where pm.col = lm.col
					 and pm.row = lm.row
					 and pm.piece_id = p.id
				)

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

		--insert engine_native.logs(data)
		--select iif(@white_to_move = 1, 'W', 'B')
		--	 + replicate('    ', 5 - @depth)
		--	 + chess.coordinates_to_square(@piece_col, @piece_row)

		exec [engine_native].[minimax]
				  @board_id = @board_id
				, @white_to_move = @child_white_to_move
				, @depth = @child_depth
				, @estimation = @child_estimation out
				, @alpha = @alpha
				, @beta = @beta


		if @white_to_move = 1 and @child_estimation > @estimation
				or @white_to_move = 0 and @child_estimation < @estimation
			select @estimation = @child_estimation
				, @col_from = @piece_col
				, @row_from = @piece_row
				, @col_to = @move_col
				, @row_to = @move_row

		exec engine_native.undo_move @board_id = @board_id
									, @move_id = @move_id

		if @white_to_move = 1 and @estimation > @alpha 
				set @alpha = @estimation
		else
		if @white_to_move = 0 and @estimation < @beta
				set @beta = @estimation

		insert @processed_moves(piece_id, col, row)
		values (@piece_id, @move_col, @move_row)

	end	

end