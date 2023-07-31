CREATE proc [dbo].[resign]
 @game_id uniqueidentifier = null
as

set nocount on

if @game_id is null
	select top (1) @game_id = id
	from chess.game
	order by ordinal desc

declare @game_state varchar(max)
, @error_message nvarchar(max)

select @game_state = [state]
from chess.game
where id = @game_id

if @game_state in ('Black to move', 'White to move')
	update chess.game set state = iif(@game_state = 'Black to move', 'White wins', 'Black wins')
	where id = @game_id
else
	set @error_message = 'Invalid game state'

exec render.game @game_id = @game_id, @error_message = @error_message