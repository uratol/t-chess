CREATE proc [dbo].[import]
  @fen nvarchar(256)
, @game_id uniqueidentifier = null
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

begin tran

	exec chess.board_from_fen @board_id = @board_id, @fen = @fen

	exec chess.update_game_state @game_id = @game_id

commit

exec render.game @game_id = @game_id