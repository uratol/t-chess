CREATE proc [dbo].[play]
as

set nocount on

declare @game_id uniqueidentifier
, @state nvarchar(max)

exec chess.get_or_create_game @game_id = @game_id out

select @state = state
from chess.game
where id = @game_id

if @game_id is null or @state not in ('White to move', 'Black to move')
	exec chess.start_game @game_id = @game_id out

exec render.game @game_id = @game_id