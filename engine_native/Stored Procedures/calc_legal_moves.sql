CREATE proc [engine_native].[calc_legal_moves]
  @piece_id uniqueidentifier = null
, @col tinyint = null
, @row tinyint = null
, @board_id uniqueidentifier = null
, @attack_only bit = 0

with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @move_col tinyint, @move_row tinyint
		, @is_king_under_check bit
		, @processed_moves [engine_native].coordinates
		, @all_moves_processed bit = 0
		, @move_id uniqueidentifier
		, @is_white bit

	exec [engine_native].[calc_legal_moves_except_king]
		  @piece_id = @piece_id out
		, @col = @col out
		, @row = @row out
		, @board_id = @board_id out
		, @is_white = @is_white out
		, @attack_only = @attack_only

	while @all_moves_processed = 0 begin

		select 
			  @move_col = l.col
			, @move_row = l.row
		from [engine_native].[legal_move] as l
		where l.piece_id = @piece_id
			and not exists(
				select 1
				from @processed_moves as p
				where p.col = l.col
					and p.row = l.row
			)

		if @@rowcount = 0 
			set @all_moves_processed = 1
		else begin

			exec [engine_native].make_move @board_id = @board_id
				, @piece_id = @piece_id
				, @col_to = @move_col, @row_to = @move_row
				, @move_id = @move_id out

			exec [engine_native].is_king_under_check @board_id = @board_id
										 , @is_king_white = @is_white
										 , @result = @is_king_under_check out

			exec [engine_native].undo_move @move_id = @move_id, @board_id = @board_id

			if @is_king_under_check = 1
				delete [engine_native].[legal_move]
				where piece_id = @piece_id
					and col = @move_col
					and row = @move_row

			insert @processed_moves(col, row)
				select @move_col, @move_row
		end
	end

end