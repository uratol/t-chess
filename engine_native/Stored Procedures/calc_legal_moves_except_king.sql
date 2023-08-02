CREATE proc [engine_native].[calc_legal_moves_except_king]
  @piece_id uniqueidentifier = null out
, @col tinyint = null out
, @row tinyint = null out
, @board_id uniqueidentifier = null out
, @attack_only bit = 0
, @is_white bit = null out

, @check_col tinyint = null
, @check_row tinyint = null
, @check_result bit = null out
 with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @piece char(1)

	declare @potential_moves [engine_native].coordinates

	if @col is null
		select @col		 = col
			 , @row		 = row
			 , @board_id = board_id
			 , @piece	 = fen_symbol
			 , @is_white = is_white
		from [engine_native].piece
		where id = @piece_id
	else
		select @piece_id = id
			 , @piece	 = fen_symbol
			 , @is_white = is_white
		from [engine_native].piece
		where board_id = @board_id
			and col = @col
			and row = @row

	if @piece = 'p' begin -- Pawn
		declare @direction int = iif(@is_white = 1, 1, -1)

		insert @potential_moves(col, row)
		select moves.col, moves.row
		from (
			-- pawn move
			select @col
				 , @row + @direction
			where @attack_only = 0
			union all
			select @col
				 , @row + @direction * 2
			where @attack_only = 0
				  and (@direction = 1
					  and @row = 1
					  or @direction = -1
					  and @row = 6)
			union all
			-- pawn attack
			select @col + 1
				 , @row + @direction
			union all
			select @col - 1
				 , @row + @direction) as moves (col, row)
		where moves.col between 0 and 7
			  and moves.row between 0 and 7
	end
	else
	if @piece = 'n' -- Knight
		insert @potential_moves(col, row)
		select moves.col, moves.row
		from (
			select @col + 1, @row + 2
			union all
			select @col + 2, @row + 1
			union all
			select @col - 1, @row + 2
			union all
			select @col + 2, @row - 1
			union all
			select @col - 1, @row - 2
			union all
			select @col - 2, @row - 1
			union all
			select @col + 1, @row - 2
			union all
			select @col - 2, @row + 1
			) as moves(col, row)
		where moves.col between 0 and 7
			and moves.row between 0 and 7
	else
		insert @potential_moves(col, row)
		select moves.col, moves.row
		from [engine_native].number as n
			cross apply (
				select 1, 1
				union all
				select 1, -1
				union all
				select -1, 1
				union all
				select -1, -1
				union all
				select 1, 0
				union all
				select -1, 0
				union all
				select 0, 1
				union all
				select 0, -1
				) as direction(x, y)
			cross apply (values(@col + n.n * direction.x, @row + n.n * direction.y)) as moves(col, row)
		where n.n between 1 and iif(@piece = 'k', 1, 7)
			and moves.col between 0 and 7
			and moves.row between 0 and 7
			and (@piece <> 'r' or direction.x * direction.y = 0)
			and (@piece <> 'b' or direction.x * direction.y <> 0)


	declare @legal_moves [engine_native].coordinates

	insert @legal_moves(col, row)
	select m.col, m.row
	from @potential_moves as m
	where (@piece <> 'p' -- It's not a pawn
				or m.col = @col -- The pawn does not attack
				or exists( -- The pawn attacks another color piece
					select 1
					from [engine_native].piece as p
					where p.col = m.col
						and p.row = m.row
						and p.is_white <> @is_white
						and p.is_captured = 0
					)
				)
		and not exists(
			-- check the pieces between starting and target squares
			select 1
			from [engine_native].piece as bp
				cross apply (
					values(
						  iif(m.col < @col, m.col, @col)
						, iif(m.col > @col, m.col, @col)
						, iif(m.row < @row, m.row, @row)
						, iif(m.row > @row, m.row, @row)
						)
					) as between_piece_and_move(start_col, finish_col, start_row, finish_row)
			where bp.board_id = @board_id
				and bp.id <> @piece_id -- skip current piece
				and bp.is_captured = 0
				and (
					-- there is no pieces between on horizontal and vertical
					@piece in ('r', 'q', 'p', 'k')  -- 'Rook', 'Queen', 'Pawn', 'King'
					and 
					(
							m.row = @row -- horizontal move
							and bp.row = @row
							and bp.col between between_piece_and_move.start_col and between_piece_and_move.finish_col
						or m.col = @col -- vertical move
							and bp.col = @col
							and bp.row between between_piece_and_move.start_row and between_piece_and_move.finish_row
					)
					or
					-- there is no pieces between on diagonals
					@piece in ('b', 'q', 'k') -- 'Bishop', 'Queen', 'King'
					and 
					(
						bp.col between between_piece_and_move.start_col and between_piece_and_move.finish_col
						and bp.row between between_piece_and_move.start_row and between_piece_and_move.finish_row
							and abs(cast(@row as smallint) - bp.row) = abs(cast(@col as smallint) - bp.col)
					)
					or @piece = 'n' -- Knight
						and bp.col = m.col
						and bp.row = m.row
				)
				-- allow to attack alien piece, except the pawns
				and (@piece = 'p' -- Pawn has our own logic, see above in WHERE
					or not(
						bp.col = m.col and bp.row = m.row 
							and bp.is_white <> @is_white
						)
					)
		)

	if @check_col is not null begin
		set @check_result = 0

		select @check_result = 1
		from @legal_moves 
		where col = @check_col
			and row = @check_row
	end
	else begin
		delete [engine_native].[legal_move]
		where piece_id = @piece_id

		insert [engine_native].[legal_move](piece_id, col, row)
			select @piece_id, col, row
			from @legal_moves
	end

end