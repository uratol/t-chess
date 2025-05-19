CREATE proc [tests].[engine_json.calc_board_state]
as

select test.assert_equals('White have to move'
	, 1 -- 'White to move'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('1b6/P7/8/8/8/8/8/8 w - - 0 1'))
	)

select test.assert_equals('Black have to move'
	, - 1 -- 'Black to move'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('1b6/P7/8/8/8/8/8/8 b - - 0 1'))
	)

select test.assert_equals('White wins when black to move'
	, 2 -- 'White wins'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('2k5/1P6/P2Q4/8/8/2K5/8/8 b - - 0 1'))
	)

select test.assert_equals('White to move when black has no moves'
	, 1 -- 'White to move'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('2k5/1P6/P2Q4/8/8/2K5/8/8 w - - 0 1'))
	)


select test.assert_equals('Black wins when black to move'
	, -2 -- 'Black wins'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('r7/8/8/8/8/8/2k5/K7 w - - 0 1'))
	)

select test.assert_equals('Stalemate when white has no moves'
	, 0 -- 'Stalemate'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('8/8/8/8/8/p7/P1k5/K7 w - - 0 1'))
	)

select test.assert_equals('Black to move when white has no moves and turn is black'
	, -1 -- 'Black to move'
	, engine_json.calc_board_state(engine_json.json_board_from_fen('8/8/8/8/8/p7/P1k5/K7 b - - 0 1'))
	)