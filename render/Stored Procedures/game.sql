CREATE proc [render].[game]
  @game_id uniqueidentifier
, @render_labels bit = 1
, @error_message nvarchar(max) = null
as

if render.enabled() = 0 -- may be disabled during tests
	return

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

exec render.[text] @text = '%1 vs %2. %3'
				 , @p1 = @white_player
				 , @p2 = @black_player
				 , @p3 = 'Put "help" to display commands'

exec render.[text] @text = ''

declare @flip bit = iif(@black_player = 'Player' and @white_player = 'AI', 1, 0)

exec render.board @board_id = @board_id, @render_labels = @render_labels, @flip = @flip

exec render.[text] @text = @error_message, @is_error = 1

set @state = case @state 
				when 'White to move' 
					then render.sprite(@state + ':', '107;90m')
				when 'Black to move' 
					then render.sprite(@state + ':', '40;90m')
				else render.sprite(@state, '44;93m')
				end
exec render.[text] @text = @state