CREATE proc [chess].[update_game_state] 
  @game_id uniqueidentifier
as

declare @state_int int
, @board_id uniqueidentifier

select @board_id = board_id
from chess.game
where id = @game_id

exec engine.calc_board_state @board_id = @board_id, @result = @state_int out

declare @state nvarchar(64) = case @state_int
									when 1 then 'White to move'
									when -1 then 'Black to move'
									when 2 then 'White wins'
									when -2 then 'Black wins'
									when 0 then 'Stalemate'
								end

if @state is null
	exec error @message = 'Invalid game state'

update chess.game
	set state = @state
where id = @game_id