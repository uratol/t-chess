CREATE proc [render].[game]
  @game_id uniqueidentifier
, @render_labels bit = 1
, @error_message nvarchar(max) = null
as

declare @board_id uniqueidentifier
, @state nvarchar(max)
, @ordinal nvarchar(10)
, @title nvarchar(4000)
, @counter nvarchar(4000)
, @white_player nvarchar(4000)
, @black_player nvarchar(4000)
, @selected_piece nvarchar(4000)

select @board_id = g.board_id
	, @state = g.state
	, @ordinal = cast(g.ordinal as nvarchar(max))
	, @white_player = g.white_player
	, @black_player = g.black_player
	, @selected_piece = b.selected_piece
from chess.game as g
	left join chess.board as b on b.id = g.board_id
where g.id = @game_id

exec render.clear_screen

select @title = render.sprite('T-CHESS', '44;33m')
	, @counter = render.sprite(@ordinal, '44;33m')

exec render.[text] @text = '%1 Game %2'
				 , @p1 = @title
				 , @p2 = @counter

exec render.[text] @text = '%1 vs %2'
				 , @p1 = @white_player
				 , @p2 = @black_player

exec render.[text] @text = ''

exec render.board @board_id = @board_id, @render_labels = @render_labels


exec render.[text] @text = ''

if @error_message is not null
	exec render.[text] @text = @error_message, @is_error = 1
else begin
	
	declare @commands nvarchar(4000) = ''

	if @state in ('White to move', 'Black to move')
		set @commands = concat('E2'
							, case when  @selected_piece is null then ', E2 E4' end
							, ', ..., resign, export, import'
							)
	else
		set @commands = 'play'

	set @commands = render.sprite(@commands, '90m')
	exec render.[text] @text = 'Available commands: %1', @p1 = @commands
end

set @state = case @state 
				when 'White to move' 
					then render.sprite(@state + ':', '107;90m')
				when 'Black to move' 
					then render.sprite(@state + ':', '40;90m')
				else render.sprite(@state, '44;93m')
				end
exec render.[text] @text = @state