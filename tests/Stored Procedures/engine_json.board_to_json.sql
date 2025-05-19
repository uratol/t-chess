create proc [tests].[engine_json.board_to_json]
as

declare @board_id uniqueidentifier
, @board_json nvarchar(max)

begin tran

-- ##############################################
exec [chess].[board_from_fen] @board_id = @board_id out
							, @fen = '1k6/8/8/2Q5/8/8/2K5/8 w - - 0 1'

select @board_json = engine_json.board_to_json(@board_id)


select test.assert_equals('Pieces should be serialized'
	, '[
		  {"colored_piece_id": "Black King", "col": 1, "row": 7}
		, {"colored_piece_id": "White King", "col": 2, "row": 1}
		, {"colored_piece_id": "White Queen", "col": 2, "row": 4}
		]'

	, (select *
		from openjson(@board_json, '$.pieces') with (
			  colored_piece_id varchar(max)
			, col int
			, row int
			)
		for json path
		)
	)

rollback