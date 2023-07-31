CREATE function [chess].[piece_legal_moves]
( @board_json nvarchar(max)
, @board_piece_id uniqueidentifier
, @attack_only bit
, @check_king bit
)
returns @result table(
  col tinyint
, row tinyint
primary key (col, row)
)
as
begin

	declare @piece_col int
		, @piece_row int
		, @colored_piece varchar(50)
		, @piece varchar(50)
		, @piece_color varchar(50)

	select @piece_col = bp.col
		, @piece_row = bp.row
		, @colored_piece = bp.colored_piece_id
		, @piece = cp.piece_id
		, @piece_color = cp.color_id
	from chess.parse_pieces(@board_json) as bp
		join chess.colored_piece as cp on cp.id = bp.colored_piece_id
	where bp.id = @board_piece_id

	insert @result(col, row)
		select m.col, m.row 
		from chess.piece_potential_moves(@colored_piece, @piece_col, @piece_row, @attack_only) as m
		 where 
			-- there is no pieces between cells
			not exists(
				select * 
				from chess.parse_pieces(@board_json) as bp
					join chess.colored_piece as cp on cp.id = bp.colored_piece_id
					cross apply (
						values(
							  least(m.col, @piece_col)
							, greatest(m.col, @piece_col)
							, least(m.row, @piece_row)
							, greatest(m.row, @piece_row)
							)
						) as between_piece_and_move(start_col, finish_col, start_row, finish_row)
				where bp.id <> @board_piece_id -- skip current piece
					and (
						-- there is no pieces between on horizontal and vertical
						@piece in ('Rook', 'Queen', 'Pawn', 'King') and 
						(
								m.row = @piece_row -- horizontal move
								and bp.row = @piece_row
								and bp.col between between_piece_and_move.start_col and between_piece_and_move.finish_col
							or m.col = @piece_col -- vertical move
								and bp.col = @piece_col
								and bp.row between between_piece_and_move.start_row and between_piece_and_move.finish_row
						)
						or
						-- there is no pieces between on diagonals
						@piece in ('Bishop', 'Queen', 'King') and 
						(
							bp.col between between_piece_and_move.start_col and between_piece_and_move.finish_col
							and bp.row between between_piece_and_move.start_row and between_piece_and_move.finish_row
								and abs(@piece_row - bp.row) = abs(@piece_col - bp.col)
						)
						or @piece = 'Knight'
							and bp.col = m.col
							and bp.row = m.row
					)
					-- allow attack alien piece, except the pawns
					and (@piece = 'Pawn'
						or not(
							bp.col = m.col and bp.row = m.row 
								and cp.color_id <> @piece_color
							)
						)
				
			)

	if @piece = 'Pawn'
		delete r
		from @result as r
		where r.col <> @piece_col -- square is attacked by this piece (move to another field)
			and not exists(
				-- square is empty or occupied by own piece
				select *
				from chess.parse_pieces(@board_json) as bp
					join chess.colored_piece as cp on cp.id = bp.colored_piece_id
				where bp.col = r.col
					and bp.row = r.row
					and cp.color_id <> @piece_color
			)

	
	-- delete moves lead to our check
	if @check_king = 1
		delete r
		from @result as r
		where chess.is_king_under_check(
												chess.make_move_json(
														@board_json
													, @piece_col, @piece_row
													, r.col, r.row
												)
												, @piece_color
											) = 1

	return
end