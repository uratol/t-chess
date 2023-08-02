create proc [test].[engine_json.make_move_json]
as

declare @board_json nvarchar(max)
, @new_board nvarchar(max)

begin tran

-- ##############################################

set @board_json = engine_json.json_board_from_fen('1k6/8/8/2Q3n1/8/8/2K5/8 w - - 0 1')

set @new_board = [engine_json].[make_move_json](@board_json, 2, 4, 3, 5)

select test.assert_equals('Queen should be moved'
 , '[
		  {"colored_piece_id": "Black King", "col": 1, "row": 7}
		, {"colored_piece_id": "White King", "col": 2, "row": 1}
		, {"colored_piece_id": "White Queen", "col": 3, "row": 5}
		, {"colored_piece_id": "Black Knight", "col": 6, "row": 4}
		]'

 , (
	 select *
	 from openjson(@new_board, '$.pieces') with (
	 colored_piece_id varchar(max)
	 , col int
	 , row int
	 )
	 for json path)
 )

set @new_board = [engine_json].[make_move_json](@new_board, 3, 5, 2, 4)

select test.assert_equals('Board should stay unchanged after move back'
	, @board_json
	, @new_board
	)


set @new_board = [engine_json].[make_move_json](@new_board, 2, 4, 6, 4)

select test.assert_equals('Queen should take black knight'
 , '[
		  {"colored_piece_id": "Black King", "col": 1, "row": 7}
		, {"colored_piece_id": "White King", "col": 2, "row": 1}
		, {"colored_piece_id": "White Queen", "col": 6, "row": 4}
		]'
 , (
	 select *
	 from openjson(@new_board, '$.pieces') with (
	 colored_piece_id varchar(max)
	 , col int
	 , row int
	 )
	 for json path)
 )

rollback