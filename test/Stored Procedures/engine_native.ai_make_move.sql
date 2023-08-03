CREATE proc [test].[engine_native.ai_make_move]
as

declare @board_id uniqueidentifier
, @col_from tinyint
, @row_from tinyint
, @col_to tinyint
, @row_to tinyint
begin tran

-- #########################################################################
exec [engine_native].[fen_to_board] @fen = 'k7/7p/8/4n3/2N5/8/8/K7 b - - 0 1'
								  , @board_id = @board_id out

exec engine_native.ai_make_move @board_id = @board_id
	, @col_from = @col_from out
	, @row_from = @row_from out
	, @col_to = @col_to out
	, @row_to = @row_to out

--select test.assert_equals('Knight should capture the enemy knight'
--	, 'E5C4'
--	, chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)
--	)

rollback