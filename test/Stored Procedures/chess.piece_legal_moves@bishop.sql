CREATE proc [test].[chess.piece_legal_moves@bishop]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran

-- ##############################################
set @board = [chess].[json_board_from_fen]('8/8/3N4/6P1/5B2/4P1P1/8/8 w - - 0 1')

select @board_piece_id = id
from chess.parse_pieces(@board)
where colored_piece_id = 'White Bishop'

select test.assert_equals('Bishop moves should be restricted by own pieces'
 , (
	 select *
	 from (values ('E5')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [chess].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )

-- ##############################################
set @board = [chess].[json_board_from_fen]('8/8/3n4/6P1/5B2/4P1P1/8/8 w - - 0 1')

select @board_piece_id = id
from chess.parse_pieces(@board)
where colored_piece_id = 'White Bishop'

select test.assert_equals('Bishop can attack alien piece'
 , (
	 select *
	 from (values ('E5')
	 , ('D6')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [chess].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )



rollback