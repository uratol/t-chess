CREATE proc [chess].[undo_halfmove]
  @game_id uniqueidentifier
as

declare @board_id uniqueidentifier
, @last_move_id uniqueidentifier
, @piece_id uniqueidentifier
, @captured_piece_id uniqueidentifier
, @from_col tinyint
, @from_row tinyint
, @to_col tinyint
, @to_row tinyint

select @board_id = g.board_id
from chess.game as g
where g.id = @game_id

select top(1) @last_move_id = m.id
	, @from_col = m.from_col
	, @from_row = m.from_row
	, @to_col	= m.to_col
	, @to_row	= m.to_row
	, @captured_piece_id = m.captured_piece_id
from chess.move as m
where m.board_id = @board_id
order by m.half_move desc

select @piece_id = id
from chess.board_piece
where board_id = @board_id
	and col = @to_col
	and row = @to_row
	and is_captured = 0

if @piece_id is null begin
	exec chess.error @message = 'Invalid move'
	return
end

begin try
begin tran

	delete chess.[move]
	where id = @last_move_id

	update bp set 
		col = @from_col
	  , row = @from_row
	  , colored_piece_id = isnull(bp.turned_from_colored_piece_id, bp.colored_piece_id)
	from chess.board_piece as bp
	where bp.id = @piece_id


	update bp set 
		is_captured = 0
	from chess.board_piece as bp
	where bp.id = @captured_piece_id

	update chess.board set 
		selected_piece = null
	  , color_to_move = chess.color_opposite(color_to_move)
	where id = @board_id

	exec chess.update_game_state @game_id = @game_id

commit
end try
begin catch

if @@trancount > 0
rollback;

throw;
end catch