CREATE proc [tests].[engine_native.calc_legal_moves_except_king@castling]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = 'r3k1nr/ppppp1pp/2bqbp2/1n6/2B1P3/1B1N1N2/PPPP1PPP/R2QK2R w KQkq - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
								, @col = 4
								, @row = 0

select test.[engine_native.assert_moves]( 
	  'White king castlong allowed', @board_id
	, 'E1'
	, 'E2, F1, G1'
	)

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
												, @col = 4
												, @row = 0

select test.[engine_native.assert_moves](
 'White king castlong allowed', @board_id
 , 'E1'
 , 'E2, F1, G1'
 )


exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
												, @col = 4
												, @row = 7

select test.[engine_native.assert_moves](
 'Black queen castlong allowed', @board_id
 , 'E8'
 , 'F7, F8, D8, C8'
 )

rollback