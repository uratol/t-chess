CREATE proc [test].[engine_json.piece_legal_moves@king]
as

declare @board nvarchar(max)
, @board_piece_id uniqueidentifier

begin tran


-- ##############################################
set @board = [engine_json].[json_board_from_fen]('8/p1p1p3/8/4k3/5r2/3p4/1P1P1P1P/8 w - - 0 1')

select test.assert_equals('King shoul be blocked by own pieces'
 , (
	 select *
	 from (values
	   ('D6')
	 , ('D5')
	 , ('D4')
	 , ('E6')
	 , ('F6')
	 , ('F5')
	 , ('E4')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(m.col, m.row) as move
	 from [engine_json].parse_pieces(@board) as bp
		 cross apply [engine_json].[piece_legal_moves](@board, bp.id, 0, 1) as m
	 where bp.colored_piece_id = 'Black King'

	 for json path)
 )


-- ##############################################
set @board = [engine_json].[json_board_from_fen]('8/8/1q6/8/2K5/8/4n3/8 w - - 0 1')

select test.assert_equals('King cannot move to attacked square'
 , (
	 select *
	 from (values
	     ('D3')
	   , ('D5')
	 ) as v (move)
	 for json path)
 , (
	 select chess.coordinates_to_square(m.col, m.row) as move
	 from [engine_json].parse_pieces(@board) as bp
		 cross apply [engine_json].[piece_legal_moves](@board, bp.id, 0, 1) as m
	 where bp.colored_piece_id = 'White King'

	 for json path)
 )
 
rollback