CREATE proc dbo.undo
 @game_id uniqueidentifier = null
as


set nocount on

if @game_id is null
	select top (1) @game_id = id
	from chess.game
	order by ordinal desc

declare @game_state varchar(max)
, @board_id uniqueidentifier
, @error_message nvarchar(max)

select @game_state = [state]
	, @board_id = board_id
from chess.game
where id = @game_id

if @game_state in ('Black to move', 'White to move')
begin
	begin tran

		set @error_message = 'Undo is not implemented yet'

		--declare @move_id uniqueidentifier

		--select top(1) @move_id = id
		--from chess.move
		--where board_id = @board_id
		--order by half_move desc

		--update chess.game set state = iif(@game_state = 'Black to move', 'White to move', 'Black to move')
		--where id = @game_id

		--delete chess.move
		--where id = @move_id

		
	commit
end
else
	set @error_message = 'Invalid game state'

exec render.game @game_id = @game_id, @error_message = @error_message