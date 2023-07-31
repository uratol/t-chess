CREATE proc test.[chess.json_board_to_fen]
as

declare @board nvarchar(max) 
, @start_fen nvarchar(max) = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
, @new_fen nvarchar(max)

set @board = chess.json_board_from_fen(@start_fen)

select @board

set @new_fen = chess.json_board_to_fen(@board)


select test.assert_equals('Start fen and new fen should match'
	, @start_fen
	, @new_fen
	)