CREATE proc test.[chess.board_from_fen]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [chess].[board_from_fen] @board_id = @board_id out, @fen = '8/8/8/8/8/8/8/8 w - - 0 1'


select test.assert_not_null('New board should be assigned', @board_id)

select test.fail('Board should be empty for blank FEN board')
where exists(select * 
	from chess.board_piece as bp
	where bp.board_id = @board_id
	)


-- ##############################################
exec [chess].[board_from_fen] @board_id = @board_id out
							, @fen = 'K7/8/8/8/8/8/8/8 w - - 0 1'

select test.assert_equals('White king should be placed on A8'
	, (select *
		from (values('White King', 'A8')
			) as v(colored_piece_id, position)
		for json path
		)
	, (
		select colored_piece_id, position
		from chess.board_piece
		where board_id = @board_id
		for json path
		)
	)

-- ##############################################
exec [chess].[board_from_fen] @board_id = @board_id out
							, @fen = '5nk1/p1R5/8/6b1/8/4K3/8/7Q w - - 0 1'

select test.assert_equals('Complex position should be recognized'
	, (select *
		from (values
			  ('Black Knight', 'F8')
			, ('Black King', 'G8')
			, ('Black Pawn', 'A7')
			, ('White Rook', 'C7')
			, ('Black Bishop', 'G5')
			, ('White King', 'E3')
			, ('White Queen', 'H1')
			) as v(colored_piece_id, position)
		order by 1, 2
		for json path
		)
	, (
		select colored_piece_id, position
		from chess.board_piece
		where board_id = @board_id
		order by 1, 2
		for json path
		)
	)

rollback