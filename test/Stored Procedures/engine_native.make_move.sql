CREATE proc test.[engine_native.make_move]
as


declare @board_id uniqueidentifier
, @piece1_id uniqueidentifier
, @piece2_id uniqueidentifier
, @piece3_id uniqueidentifier
, @move_id uniqueidentifier

begin tran

exec [engine_native].[fen_to_board] @fen = '8/5N2/8/8/2b5/8/4P3/8 w - - 0 1'
								  , @board_id = @board_id out

select @piece1_id = id
from chess.board_piece
where board_id = @board_id
	and position = 'E2'

-- ##############################################
exec [engine_native].make_move @board_id = @board_id
	, @piece_id = @piece1_id
	, @col_to = 4
	, @row_to = 3
	, @move_id = @move_id out

select test.assert_not_null ('Move id should be returned', @move_id)


--- select * from engine_native.move with(repeatableread)


select test.assert_equals('Move should be stored'
	, (
		select *
		from (values(
				@piece1_id
				, 4
				, 1
				, 4
				, 3
				, null
			)) as v(piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id)
		for json path
		) 

	, (
		select piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id
		from engine_native.move with(repeatableread)
		where id = @move_id
		for json path
		)
	)



select test.assert_equals('Board should be updated'
	, (
	select *
		from (values(
				  cast(0 as bit) 
				, 1
			)) as v(white_to_move, half_moves)
		for json path
		)
	, (
		select white_to_move, half_moves
		from engine_native.board with(repeatableread)
		where id = @board_id
		for json path
		)
	)

-- ##############################################

select @piece2_id = id
from chess.board_piece
where board_id = @board_id
	  and position = 'C4'

select @piece3_id = id
from chess.board_piece
where board_id = @board_id
	  and position = 'F7'

exec [engine_native].make_move @board_id = @board_id
							 , @piece_id = @piece2_id
							 , @col_to = 5
							 , @row_to = 6
							 , @move_id = @move_id out


select test.assert_equals('Move should be stored'
	, (
		select *
		from (values
				  (@piece1_id, 4, 1, 4, 3, null)
				, (@piece2_id, 2, 3, 5, 6, @piece3_id)
			) as v(piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id)
		for json path
		) 

	, (
		select piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id
		from engine_native.move as m with(repeatableread)
			join engine_native.piece as p with(repeatableread) on p.id = m.piece_id
		where p.board_id = @board_id
		for json path
		)
	)

select test.assert_equals('Piece should be captured'
	, 1
	, (
		select is_captured
		from engine_native.piece as p with(repeatableread)
		where id = @piece3_id
	)
	)


select test.assert_equals('Board should be updated'
	, (
	select *
		from (values(
				  cast(1 as bit) 
				, 2
			)) as v(white_to_move, half_moves)
		for json path
		)
	, (
		select white_to_move, half_moves
		from engine_native.board with(repeatableread)
		where id = @board_id
		for json path
		)
	)


-- ########################################################################

exec engine_native.undo_move @move_id = @move_id, @board_id = @board_id


select test.assert_equals('Move should be rolled back'
	, (
		select *
		from (values
				  (@piece1_id, 4, 1, 4, 3, null)
			) as v(piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id)
		for json path
		) 

	, (
		select piece_id
			, col_from
			, row_from
			, col_to
			, row_to
			, captured_piece_id
		from engine_native.move as m with(repeatableread)
			join engine_native.piece as p with(repeatableread) on p.id = m.piece_id
		where p.board_id = @board_id
		for json path
		)
	)

select test.assert_equals('Captured piece should be restored after undo'
	, 0
	, (
		select is_captured
		from engine_native.piece as p with(repeatableread)
		where id = @piece3_id
	)
	)


rollback