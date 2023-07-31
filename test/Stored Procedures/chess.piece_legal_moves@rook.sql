CREATE proc [test].[chess.piece_legal_moves@rook]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran

-- ##############################################
set @board = [chess].[json_board_from_fen]('5P1R/8/7N/8/8/8/8/8 w - - 0 1')

select @board_piece_id = id
from chess.parse_pieces(@board)
where colored_piece_id = 'White Rook'

select test.assert_equals('Rook moves should be restricted by own pieces'
 , (
	 select *
	 from (values ('G8')
	 , ('H7')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [chess].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )


-- ##############################################
set @board = [chess].[json_board_from_fen]('5P1R/8/7n/8/8/8/8/8 w - - 0 1')

select @board_piece_id = id
from chess.parse_pieces(@board)
where colored_piece_id = 'White Rook'

select test.assert_equals('Rook can attack alien piece'
 , (
	 select *
	 from (values ('G8')
	 , ('H7')
	 , ('H6')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(col, row) as move
	 from [chess].[piece_legal_moves](@board, @board_piece_id, 0, 1)
	 for json path)
 )


rollback