create proc [test].[engine_native.calc_legal_moves_except_king@bishop]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/3N4/6P1/5B2/4P1P1/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
								, @col = 5
								, @row = 3

select test.[engine_native.assert_moves]( 
	  'Bishop moves should be restricted by own pieces', @board_id
	, 'F4'
	, 'E5'
	)

---- ##############################################
exec [engine_native].[fen_to_board] @fen = '8/8/3n4/6P1/5B2/4P1P1/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
		, @col = 5
		, @row = 3
		

select test.[engine_native.assert_moves](
 'Bishop can attack alien piece', @board_id
 , 'F4'
 , 'E5, D6'
 )

rollback