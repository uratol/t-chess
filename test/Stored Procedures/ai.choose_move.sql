CREATE proc [test].[ai.choose_move]
as

declare @board nvarchar(max)
, @col_from tinyint
, @row_from tinyint
, @col_to tinyint
, @row_to tinyint
, @estimation real

set @board = chess.json_board_from_fen('7k/1p6/1P4Q1/8/8/8/8/8 b - - 0 1')

exec [ai].[choose_move]
	  @board = @board
	, @col_from = @col_from out
	, @row_from = @row_from out

set @board = chess.json_board_from_fen('7k/1p6/1P6/6Q1/8/8/8/8 b - - 0 1')

exec [ai].[choose_move] @board = @board
					  , @col_from = @col_from out
					  , @row_from = @row_from out
					  , @col_to = @col_to out
					  , @row_to = @row_to out

select test.assert_equals('The only move must be chosen'
	, 'H8H7'
	, chess.coordinates_to_move(@col_from, @row_from, @col_to, @row_to)
	)