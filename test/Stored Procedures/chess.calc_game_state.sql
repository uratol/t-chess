CREATE proc test.[chess.calc_game_state]
as


select test.assert_equals('White have to move'
	, 'White to move'
	, chess.calc_game_state(chess.json_board_from_fen('1b6/P7/8/8/8/8/8/8 w - - 0 1'))
	)

select test.assert_equals('Black have to move'
	, 'Black to move'
	, chess.calc_game_state(chess.json_board_from_fen('1b6/P7/8/8/8/8/8/8 b - - 0 1'))
	)

select test.assert_equals('White wins when black to move'
	, 'White wins'
	, chess.calc_game_state(chess.json_board_from_fen('2k5/1P6/P2Q4/8/8/2K5/8/8 b - - 0 1'))
	)

select test.assert_equals('White to move when black has no moves'
	, 'White to move'
	, chess.calc_game_state(chess.json_board_from_fen('2k5/1P6/P2Q4/8/8/2K5/8/8 w - - 0 1'))
	)


select test.assert_equals('Black wins when black to move'
	, 'Black wins'
	, chess.calc_game_state(chess.json_board_from_fen('r7/8/8/8/8/8/2k5/K7 w - - 0 1'))
	)

select test.assert_equals('Stalemate when white has no moves'
	, 'Stalemate'
	, chess.calc_game_state(chess.json_board_from_fen('8/8/8/8/8/p7/P1k5/K7 w - - 0 1'))
	)

select test.assert_equals('Black to move when white has no moves and turn is black'
	, 'Black to move'
	, chess.calc_game_state(chess.json_board_from_fen('8/8/8/8/8/p7/P1k5/K7 b - - 0 1'))
	)