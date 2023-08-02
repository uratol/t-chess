create proc [engine_json].[legal_moves]
  @piece_id uniqueidentifier
, @moves nvarchar(max) out -- [{col: 1, row: 2}]
as

declare @board_id uniqueidentifier

select @board_id = board_id
from chess.board_piece
where id = @piece_id

set @moves = (
	select col, row
	from engine_json.piece_legal_moves(engine_json.board_to_json(@board_id), @piece_id
		, 0 -- @attack_only
		, 1 -- check_king
		)
	for json path
	)