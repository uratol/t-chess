
CREATE proc [tests].[engine_native.calc_legal_moves_except_king@king]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/p1p1p3/8/4k3/5r2/3p4/1P1P1P1P/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 4
							, @row = 4
							

select test.[engine_native.assert_moves](
   'King shoul be blocked by own pieces', @board_id
 , 'E5'
 , 'D6, D5, D4, E6, F6, F5, E4'
 )


rollback