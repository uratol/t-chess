CREATE proc chess.get_or_create_game
 @game_id uniqueidentifier out
as

if @game_id is null
	select top (1) @game_id = id
	from chess.game
	order by ordinal desc

if @game_id is null
	exec chess.start_game @game_id = @game_id out