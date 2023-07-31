CREATE proc [test].[chess.piece_legal_moves@pawn]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran


-- ##############################################
set @board = [chess].[json_board_from_fen]('8/8/8/8/2p5/N2Q1p2/P1P1P3/8 w - - 0 1')

select test.assert_equals('Pieces moves should match'
 , (
	 select *
	 from (values
	   ('C2', 'C3')
	 , ('E2', 'E3')
	 , ('E2', 'E4')
	 , ('E2', 'F3')
	 ) as v ([from], [to])
	 for json path)
 , (
	 select chess.coordinates_to_square(bp.col, bp.row) as [from]
		, chess.coordinates_to_square(m.col, m.row) as [to]
	 from chess.parse_pieces(@board) as bp
		 cross apply [chess].[piece_legal_moves](@board, bp.id, 0, 1) as m
	 where bp.colored_piece_id = 'White Pawn'
	 for json path)
 )



rollback