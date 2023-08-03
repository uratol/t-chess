CREATE proc [chess].[make_move_internal]
  @game_id uniqueidentifier
, @col_from int
, @row_from int
, @col_to int
, @row_to int
, @turn_piece_to varchar(6) = 'Queen'
as

declare @color_to_move varchar(5)
, @board_id uniqueidentifier
, @piece_id uniqueidentifier
, @captured_piece_id uniqueidentifier

select @board_id = g.board_id
	, @color_to_move = b.color_to_move
from chess.game as g
	join chess.board as b on b.id = g.board_id
where g.id = @game_id

select @piece_id	= bp.id
from chess.board_piece as bp
	join chess.colored_piece as cp
		on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	  and bp.col = @col_from
	  and bp.row = @row_from

select @captured_piece_id = bp.id
from chess.board_piece as bp
	left join chess.colored_piece as cp
		on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	  and bp.col = @col_to
	  and bp.row = @row_to
	  and bp.is_captured = 0

begin try
	begin tran

		insert chess.[move](board_id, half_move, from_col, from_row, to_col, to_row, captured_piece_id)
			select @board_id
				, (select isnull(max(half_move) + 1, 1)
					from chess.[move]
					where board_id = @board_id
				  )
				, @col_from
				, @row_from
				, @col_to
				, @row_to
				, @captured_piece_id

		update bp set is_captured = 1
		from chess.board_piece as bp
		where bp.id = @captured_piece_id

		update bp set 
			  col = @col_to
			, row = @row_to
			, colored_piece_id = isnull(turn_to.id, bp.colored_piece_id)
		from chess.board_piece as bp
			left join chess.colored_piece as turn_to on turn_to.id 
				= case 
						when bp.colored_piece_id = 'White Pawn' and @row_to = 7 then 'White ' + @turn_piece_to 
						when bp.colored_piece_id = 'Black Pawn' and @row_to = 0 then 'Black ' + @turn_piece_to 
					end
		where bp.id = @piece_id

		declare @opposit_color_to_move varchar(5) = chess.color_opposite(@color_to_move)

		update chess.board set selected_piece = null
			, color_to_move = @opposit_color_to_move
		where id = @board_id

		exec chess.update_game_state @game_id = @game_id

	commit 
end try
begin catch
	if @@trancount > 0 rollback;
	throw;
end catch