
CREATE proc [tests].[engine_json.piece_legal_moves@queen]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran

-- ##############################################
set @board = [engine_json].[json_board_from_fen]('8/8/3n1B2/6P1/4RQP1/4PpP1/8/8 w - - 0 1')

select @board_piece_id = id
from [engine_json].parse_pieces(@board)
where colored_piece_id = 'White Queen'

select test.assert_equals('Queen shoul be restricted by own pieces and can attack alien piece'
 , (
	 select *
	 from (values ('E5')
	 , ('D6')
	 , ('F5')
	 , ('F3')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [engine_json].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )




rollback