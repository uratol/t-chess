
create proc [tests].[engine_native.calc_legal_moves_except_king@queen]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/3n1B2/6P1/4RQP1/4PpP1/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 5
							, @row = 3
							

select test.[engine_native.assert_moves](
'Queen shoul be restricted by own pieces and can attack alien piece', @board_id
 , 'F4'
 , 'E5, D6, F5, F3'
 )



rollback