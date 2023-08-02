CREATE proc [test].[engine_json.make_move_json@pawn_turning]
as

declare @board_json nvarchar(max)
, @new_board nvarchar(max)

begin tran

-- ##############################################

set @board_json = [engine_json].json_board_from_fen('8/P7/8/8/8/8/8/8 w - - 0 1')

set @new_board = [engine_json].[make_move_json](@board_json, 0, 6, 0, 7)

select test.assert_equals('Pawn should turn into Queen'
 , '[
		  {"colored_piece_id": "White Queen", "col": 0, "row": 7}
		]'

 , (
	 select colored_piece_id, col, row
	 from [engine_json].parse_pieces(@new_board)
	 for json path
	)
 )


-- ##############################################
 
set @board_json = [engine_json].json_board_from_fen('1b6/P7/8/8/8/8/8/8 w - - 0 1')

set @new_board = [engine_json].[make_move_json](@board_json, 0, 6, 1, 7)

select test.assert_equals('Pawn should turn into Queen when taking'
 , '[
		  {"colored_piece_id": "White Queen", "col": 1, "row": 7}
		]'

 , (
	 select colored_piece_id
		  , col
		  , row
	 from [engine_json].parse_pieces(@new_board)
	 for json path)
 )

rollback