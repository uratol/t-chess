CREATE proc [engine_native].[legal_moves]
  @piece_id uniqueidentifier
, @moves nvarchar(max) out -- [{col: 1, row: 2}]
as

declare @board_id uniqueidentifier

select @board_id = board_id
from chess.board_piece
where id = @piece_id

exec engine_native.board_to_native @board_id = @board_id

exec engine_native.calc_legal_moves @piece_id = @piece_id
	, @board_id = @board_id
	, @attack_only = 0
	
set @moves = (
	select col, row
	from engine_native.legal_move
	where piece_id = @piece_id
	for json path
	)