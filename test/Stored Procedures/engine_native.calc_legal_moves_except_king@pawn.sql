
CREATE proc [test].[engine_native.calc_legal_moves_except_king@pawn]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/8/8/2p5/N2Q1p2/P1P1P3/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 0
							, @row = 1
							

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 2
							, @row = 1
							

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 4
							, @row = 1
							

select test.[engine_native.assert_moves](
'Pieces moves should match', @board_id
 , 'A2'
 , null
 )

select test.[engine_native.assert_moves](
 'Pieces moves should match', @board_id
 , 'C2'
 , 'C3'
 )


select test.[engine_native.assert_moves](
 'Pieces moves should match', @board_id
 , 'E2'
 , 'E3, E4, F3'
 )


rollback