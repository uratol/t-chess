CREATE proc [test].[engine_json.piece_legal_moves@knight]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran

-- ##############################################
set @board = [engine_json].[json_board_from_fen]('8/8/8/8/8/1b1N4/p7/2n5 b - - 0 1')

select @board_piece_id = id
from [engine_json].parse_pieces(@board)
where colored_piece_id = 'Black Knight'

select test.assert_equals('Knight shoul be restricted by own pieces and can attack alien piece'
 , (
	 select *
	 from (values ('D3')
	 , ('E2')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [engine_json].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )

rollback