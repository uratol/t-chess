create proc [engine_native].[fen_to_board]
  @fen nvarchar(64)
, @board_id uniqueidentifier = null out
as

exec chess.board_from_fen @fen = @fen, @board_id = @board_id out

exec [engine_native].[board_to_native] @board_id = @board_id