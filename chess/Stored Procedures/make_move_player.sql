CREATE proc [chess].[make_move_player]
  @game_id uniqueidentifier
, @col_from int
, @row_from int
, @col_to int
, @row_to int
, @turn_piece_to varchar(6) = 'Queen'
as

declare 
  @piece_id uniqueidentifier
, @captured_piece_id uniqueidentifier
, @piece_color varchar(5)
, @color_to_move varchar(5)
, @captured_piece_color varchar(max)
, @board_id uniqueidentifier

select @board_id = g.board_id
	, @color_to_move = b.color_to_move
from chess.game as g
	join chess.board as b on b.id = g.board_id
where g.id = @game_id

select @piece_id = bp.id
	, @piece_color = cp.color_id
from chess.board_piece as bp
	join chess.colored_piece as cp on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	and bp.col = @col_from
	and bp.row = @row_from
	and bp.is_captured = 0

if @piece_id is null
	exec chess.error @message = 'Invalid move %square: square is empty or available for several pieces', @col = @col_from, @row = @row_from

if @piece_color <> @color_to_move
	exec chess.error @message = 'Invalid move %square: wrong piece color', @col = @col_from, @row = @row_from

select @captured_piece_id	   = bp.id
	 , @captured_piece_color = cp.color_id
from chess.board_piece as bp
	left join chess.colored_piece as cp
		on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	  and bp.col = @col_to
	  and bp.row = @row_to
	  and bp.is_captured = 0

if @captured_piece_id is not null and @piece_color = @captured_piece_color
	exec chess.error @message = 'Invalid move to %square: square has the same color piece'
				   , @col = @col_to
				   , @row = @row_to



declare @is_move_legal bit

exec chess.is_move_lagal  @piece_id = @piece_id
						, @col = @col_to
						, @row = @row_to
						, @result = @is_move_legal out

if @is_move_legal = 0
	exec chess.error @message = 'Illegal move to %square'
				   , @col = @col_to
				   , @row = @row_to


exec chess.make_move_internal @game_id = @game_id
		, @col_from = @col_from
		, @row_from = @row_from
		, @col_to = @col_to
		, @row_to = @row_to
		, @turn_piece_to = @turn_piece_to