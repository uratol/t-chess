CREATE proc [test].[engine_native.calc_legal_moves]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/8/2p3b1/1n6/4B3/3K4/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves] @board_id = @board_id
							, @col = 4
							, @row = 2
							
select test.[engine_native.assert_moves](
	  'No move for white bishop when the king is under check', @board_id
	 , 'E3'
	 , 'F4, G5'
	 )

exec engine_native.[calc_legal_moves] @board_id = @board_id
							, @col = 3
							, @row = 1
							
select test.[engine_native.assert_moves](
	  'No move for king when the king is under check', @board_id
	 , 'D2'
	 , 'C3, C1, D1, E1, E2'
	 )

exec engine_native.[calc_legal_moves] @board_id = @board_id
							, @col = 1
							, @row = 3

exec [engine_native].[fen_to_board] @fen = '8/8/8/2p3b1/1n6/4B3/3K4/8 b - - 0 1'
								  , @board_id = @board_id out

select test.[engine_native.assert_moves](
	  'No move for other piece if king is under check', @board_id
	 , 'B4'
	 , null
	 )

rollback