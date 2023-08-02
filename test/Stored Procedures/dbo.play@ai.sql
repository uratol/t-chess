CREATE proc [test].[dbo.play@ai]
as

declare @game_id uniqueidentifier
, @board_id uniqueidentifier
, @state nvarchar(64)

exec render.disable

exec play @arg1 = 'new', @game_id = @game_id out

select @state = state
	, @board_id = board_id
from chess.game
where id = @game_id

select test.assert_equals('State should be White to move, players should be Player vs AI'
	, (select *
		from (values('White to move', 'Player', 'AI')
			) as v(state, white_player, black_player)
		for json path
		)
	, (select state, white_player, black_player
		from chess.game
		where id = @game_id
		for json path
		)
	)

exec e2 e4


select test.assert_equals('State should be White to move if opponent is AI'
 , 'White to move'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )

delete chess.game
where id = @game_id

exec render.enable