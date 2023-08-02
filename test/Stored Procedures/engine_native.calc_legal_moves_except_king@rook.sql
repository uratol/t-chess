
CREATE proc [test].[engine_native.calc_legal_moves_except_king@rook]
as

declare @board_id uniqueidentifier

begin tran

-- ##############################################
exec [engine_native].[fen_to_board] @fen = '5P1R/8/7N/8/8/8/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 7
							, @row = 7
							

select test.[engine_native.assert_moves](
 'Rook moves should be restricted by own pieces', @board_id
 , 'H8'
 , 'H7, G8'
 )


-- ##############################################
exec [engine_native].[fen_to_board] @fen = '5P1R/8/7n/8/8/8/8/8 w - - 0 1'
					  , @board_id = @board_id out

exec engine_native.[calc_legal_moves_except_king] @board_id = @board_id
							, @col = 7
							, @row = 7
							

select test.[engine_native.assert_moves](
 'Rook moves should be restricted by own pieces', @board_id
 , 'H8'
 , 'H7, G8, H6'
 )


rollback