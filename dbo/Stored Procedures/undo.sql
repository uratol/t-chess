CREATE proc [dbo].[undo]
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
	begin try
	
		exec chess.undo_halfmove @game_id = @game_id

		if exists(
			select * from chess.move
			where board_id = @board_id
			)
			exec chess.undo_halfmove @game_id = @game_id

	end try
	begin catch
	
		set @error_message = error_message()
	
	end catch
else
	set @error_message = 'Invalid game state'


exec render.game @game_id = @game_id, @error_message = @error_message