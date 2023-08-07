CREATE proc [dbo].[play]
  @arg1 nvarchar(32) = null
, @arg2 nvarchar(32) = null
, @game_id uniqueidentifier = null out
as

set nocount on

declare @state nvarchar(max)
, @black_player nvarchar(32) = 'AI'
, @white_player nvarchar(32) = 'Player'
, @error_message nvarchar(4000)
, @new_game bit = 0

if @arg1 is not null 
	or @arg2 is not null
begin
	if 'new' in (@arg1, @arg2)
		set @new_game = 1

	if 'black' in (@arg1, @arg2)
		select @white_player = 'AI', @black_player = 'Player'
	else 
	if 'demo' in (@arg1, @arg2)
		select @white_player = 'AI'
			 , @black_player = 'AI'
	else 
	if 'friend' in (@arg1, @arg2)
		select @white_player = 'Player'
			 , @black_player = 'Player'
	
	if exists(
		select *
		from (values(@arg1), (@arg2)) as v(arg)
		where arg is not null
			and arg not in ('new', 'black', 'demo', 'friend')
		)
		set @error_message = concat('Invalid argument: ', @arg1)
end

if @new_game = 1
	exec chess.start_game @game_id = @game_id out
						, @black_player = @black_player
						, @white_player = @white_player
else
	exec chess.get_or_create_game @game_id = @game_id out

select @state = state, @white_player = white_player, @black_player = black_player
from chess.game
where id = @game_id

if @game_id is null or @state not in ('White to move', 'Black to move')
	exec chess.start_game @game_id = @game_id out
		, @black_player = @black_player
		, @white_player = @white_player
else
begin try
	if @state = 'White to move' and @white_player = 'AI'
		or @state = 'Black to move' and @black_player = 'AI'
	exec chess.make_move_ai @game_id = @game_id	
end try
begin catch
	set @error_message = error_message()
end catch

exec render.game @game_id = @game_id, @error_message = @error_message