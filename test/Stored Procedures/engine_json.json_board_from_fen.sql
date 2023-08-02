CREATE proc [test].[engine_json.json_board_from_fen]
as

declare @board nvarchar(max) 
, @start_fen nvarchar(max) = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
, @new_fen nvarchar(max)

set @board = engine_json.json_board_from_fen(@start_fen)

set @new_fen = engine_json.json_board_to_fen(@board)


select test.assert_equals('Start fen and new fen should match'
	, @start_fen
	, @new_fen
	)