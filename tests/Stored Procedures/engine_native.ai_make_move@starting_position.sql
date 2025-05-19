CREATE proc [tests].[engine_native.ai_make_move@starting_position]
as
set nocount on

declare @board_id uniqueidentifier
, @col_from tinyint
, @row_from tinyint
, @col_to tinyint
, @row_to tinyint

-- begin tran

-- #########################################################################
exec [engine_native].[fen_to_board] @fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'
								  , @board_id = @board_id out


exec engine_native.ai_make_move @board_id = @board_id
							  , @col_from = @col_from out
							  , @row_from = @row_from out
							  , @col_to = @col_to out
							  , @row_to = @row_to out
							  , @depth = 3


select chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)

--select test.fail('Move should not be A7A5')
--where chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to) in ('A7A5', 'A7A6')

delete chess.board where id = @board_id

-- rollback