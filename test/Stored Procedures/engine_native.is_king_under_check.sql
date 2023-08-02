CREATE proc [test].[engine_native.is_king_under_check]
as


declare @board_id uniqueidentifier
, @result bit

begin tran

-- #######################################################################################

exec [engine_native].[fen_to_board] @fen = '2k5/P7/8/8/8/8/8/8 w - - 0 1'
								  , @board_id = @board_id out

exec [engine_native].[is_king_under_check] @board_id = @board_id
										 , @is_king_white = 1
										 , @result = @result out

select test.assert_equals('Should return false if no King on board'
 , 0
 , @result
 )

-- #######################################################################################

exec [engine_native].[fen_to_board] @fen = 'r7/8/8/8/K7/8/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec [engine_native].[is_king_under_check] @board_id = @board_id
	, @is_king_white = 1
	, @result = @result out

select test.assert_equals('Should return true if King is under attack by rook'
	, 1
	, @result
	)


-- #######################################################################################

exec [engine_native].[fen_to_board] @fen = '8/8/k7/1P6/8/8/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec [engine_native].[is_king_under_check] @board_id = @board_id
								 , @is_king_white = 0
								 , @result = @result out

select test.assert_equals('Should return true if Black King is under attack by pawn'
 , 1
 , @result
 )


---- #######################################################################################

 exec [engine_native].[fen_to_board] @fen = '2k5/P3r1n1/5b1p/8/8/3K4/8/8 w - - 0 1'
					   , @board_id = @board_id out

 exec [engine_native].[is_king_under_check] @board_id = @board_id
								  , @is_king_white = 1
								  , @result = @result out

 select test.assert_equals('Should return false if King is not under check for many pieces'
  , 0
  , @result
  )

---- #######################################################################################

exec [engine_native].[fen_to_board] @fen = '8/p7/8/K7/8/8/8/8 w - - 0 1'
					   , @board_id = @board_id out

exec [engine_native].[is_king_under_check] @board_id = @board_id
								  , @is_king_white = 1
								  , @result = @result out

select test.assert_equals('Should return false if King is blocked by pawn'
  , 0
  , @result
  )

---- #######################################################################################

exec [engine_native].[fen_to_board] @fen = '1k1q3b/8/8/2P2n2/3K4/8/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec [engine_native].[is_king_under_check] @board_id = @board_id
								 , @is_king_white = 1
								 , @result = @result out

select test.assert_equals('Should return true if King is under attack by many pieces'
 , 1
 , @result
 )

rollback