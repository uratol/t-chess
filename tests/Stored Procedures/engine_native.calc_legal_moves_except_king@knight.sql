
CREATE proc [tests].[engine_native.calc_legal_moves_except_king@knight]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/8/8/8/1b1N4/p7/2n5 b - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 2
							, @row = 0
							

select test.[engine_native.assert_moves](
'Knight shoul be restricted by own pieces and can attack alien piece', @board_id
 , 'C1'
 , 'E2, D3'
 )



rollback