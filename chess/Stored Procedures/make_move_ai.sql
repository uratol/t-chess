CREATE proc [chess].[make_move_ai] 
  @game_id uniqueidentifier
as

declare 
  @col_from int
, @row_from int
, @col_to int
, @row_to int
, @board_id uniqueidentifier

select @board_id = board_id
from chess.game
where id = @game_id

begin try

	exec engine.ai_make_move @board_id = @board_id
							, @col_from = @col_from out
							, @row_from = @row_from out
							, @col_to = @col_to out
							, @row_to = @row_to out

	if not(
			@col_from is null or @row_from is null
			or @col_to is null or @row_to is null
		)
		exec chess.make_move_internal @game_id = @game_id
				, @col_from = @col_from
				, @row_from = @row_from
				, @col_to = @col_to
				, @row_to = @row_to
	else 
		exec chess.error @message = 'Invalid AI move'

end try
begin catch
	
	if @@trancount > 0 rollback;
	
	throw;

end catch