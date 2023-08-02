CREATE proc [chess].[select_piece] 
  @game_id uniqueidentifier
, @col int
, @row int
as

declare @board_id uniqueidentifier
, @piece_id uniqueidentifier
, @piece_color varchar(max)
, @color_to_move varchar(max)

select @board_id   = g.board_id
	, @color_to_move = b.color_to_move
from chess.game as g
	join chess.board as b on b.id = g.board_id
where g.id = @game_id

select @piece_id	= bp.id
	, @piece_color = cp.color_id
from chess.board_piece as bp
	left join chess.colored_piece as cp
		on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	  and bp.col = @col
	  and bp.row = @row


if @piece_id is null
	exec chess.error @message = 'Invalid square %square: square is empty'
			   , @col = @col
			   , @row = @row
else
if @piece_color <> @color_to_move
	exec chess.error @message = 'Invalid square %square: select your piece'
				   , @col = @col
				   , @row = @row
else
	update chess.board set selected_piece = @piece_id
	where id = @board_id