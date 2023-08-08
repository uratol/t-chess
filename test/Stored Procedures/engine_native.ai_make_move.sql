CREATE proc [test].[engine_native.ai_make_move]
as

declare @board_id uniqueidentifier
, @col_from tinyint
, @row_from tinyint
, @col_to tinyint
, @row_to tinyint

begin tran

-- #########################################################################
exec [engine_native].[fen_to_board] @fen = 'k7/7p/8/1B2n3/2N5/5P2/8/K7 b - - 0 1'
								  , @board_id = @board_id out


exec engine_native.ai_make_move @board_id = @board_id
							  , @col_from = @col_from out
							  , @row_from = @row_from out
							  , @col_to = @col_to out
							  , @row_to = @row_to out
							  , @depth = 1

select test.assert_equals('Knight should capture the enemy knight when one halfmove processed'
	, 'E5C4'
	, chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)
	)

exec engine_native.ai_make_move @board_id = @board_id
							  , @col_from = @col_from out
							  , @row_from = @row_from out
							  , @col_to = @col_to out
							  , @row_to = @row_to out
							  , @depth = 2

select test.assert_equals('Knight should capture the enemy pawn when two halfmove processed'
	, 'E5F3'
	, chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)
	)

--exec engine_native.ai_make_move @board_id = @board_id
--							  , @col_from = @col_from out
--							  , @row_from = @row_from out
--							  , @col_to = @col_to out
--							  , @row_to = @row_to out
--							  , @depth = 3

--select test.assert_equals('Knight should not capture the any piece when three halfmove processed'
--	, 'A8A7'
--	, chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)
--	)

rollback