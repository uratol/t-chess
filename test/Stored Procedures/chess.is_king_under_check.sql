CREATE proc [test].[chess.is_king_under_check]
as

declare @board nvarchar(max)

-- #######################################################################################
set @board = [chess].[json_board_from_fen]('2k5/P7/8/8/8/8/8/8 w - - 0 1')

select test.assert_equals('Should return false if no King on board'
	, 0
	, chess.is_king_under_check(@board, 'White')
	)

-- #######################################################################################
set @board = [chess].[json_board_from_fen]('r7/8/8/8/K7/8/8/8 w - - 0 1')

select test.assert_equals('Should return true if King is under attack by rook'
 , 1
 , chess.is_king_under_check(@board, 'White')
 )

-- #######################################################################################
set @board = [chess].[json_board_from_fen]('8/8/k7/1P6/8/8/8/8 w - - 0 1')

select test.assert_equals('Should return true if Black King is under attack by pawn'
 , 1
 , chess.is_king_under_check(@board, 'Black')
 )


-- #######################################################################################
set @board = [chess].[json_board_from_fen]('2k5/P3r1n1/5b1p/8/8/3K4/8/8 w - - 0 1')

select test.assert_equals('Should return false if King is not under check for many pieces'
 , 0
 , chess.is_king_under_check(@board, 'White')
 )

 -- #######################################################################################
 set @board = [chess].[json_board_from_fen]('8/p7/8/K7/8/8/8/8 w - - 0 1')

 select test.assert_equals('Should return false if King is blocked by pawn'
  , 0
  , chess.is_king_under_check(@board, 'White')
  )

-- #######################################################################################
set @board = [chess].[json_board_from_fen]('1k1q3b/8/8/2P2n2/3K4/8/8/8 w - - 0 1')

select test.assert_equals('Should return true if King is under attack by many pieces'
 , 1
 , chess.is_king_under_check(@board, 'White')
 )