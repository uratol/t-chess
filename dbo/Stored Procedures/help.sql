CREATE proc [dbo].[help]
as

set nocount on

declare @text nvarchar(4000)
, @engines nvarchar(4000) = (
	select string_agg(id, ', ') within group(order by id)
	from engine.instance
	)

declare @commands table (n int identity primary key, cmd nvarchar(64), description nvarchar(256))

insert @commands(cmd, description)
	values	
		  ('E2', 'select piece/move peace')
		, ('E2 E4', 'select and move piece')
		, ('undo', 'move back')
		, ('play new', 'Start new game')
		, ('play black', 'Start new game black')
		, ('play demo', 'Start new game AI vs AI')
		, ('play', 'New game if current is finished, play-by-play in demo mode')
		, ('import ''...''', 'Set FEN position to board')
		, ('export', 'Get current FEN position')
		, ('engine ...', concat('Change engine. The allowed values: ', @engines))

select @text =  string_agg(
	concat(render. sprite(cmd, '32m')
		, replicate(' ', 20 - len(cmd))
		, description
	)
	, '
'
	) within group(order by n)
from @commands

exec render.text @text = @text