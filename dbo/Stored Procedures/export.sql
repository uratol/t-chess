CREATE proc [dbo].[export]
 @game_id uniqueidentifier = null
as

set nocount on

if @game_id is null
	select top (1) @game_id = id
	from chess.game
	order by ordinal desc

declare @board_id uniqueidentifier

select @board_id = board_id
from chess.game
where id = @game_id

declare @fen nvarchar(max) = engine_json.json_board_to_fen(engine_json.board_to_json(@board_id))

set @fen = render.sprite(@fen, '32m')

exec render.text @text = 'Export to FEN:'
exec render.text @text = @fen