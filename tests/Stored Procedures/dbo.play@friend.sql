CREATE proc [tests].[dbo.play@friend]
as

declare @game_id uniqueidentifier
, @board_id uniqueidentifier
, @state nvarchar(64)

exec render.disable

exec play @arg1 = 'friend', @arg2 = 'new', @game_id = @game_id out

select @state = state
	, @board_id = board_id
from chess.game
where id = @game_id

select test.assert_equals('State should be White to move, players should be Player vs Player'
	, (select *
		from (values('White to move', 'Player', 'Player')
			) as v(state, white_player, black_player)
		for json path
		)
	, (select state, white_player, black_player
		from chess.game
		where id = @game_id
		for json path
		)
	)

exec e2

select test.assert_equals('State should stay White to move when piece is selected'
	, 'White to move'
	, (select state from chess.game
		where id = @game_id
		)
	)

declare @piece_id uniqueidentifier 
, @moves nvarchar(max)

select @piece_id = id
from chess.board_piece
where board_id = @board_id
	and chess.coordinates_to_square(col, row) = 'E2'
	and is_captured = 0

exec engine.legal_moves @piece_id = @piece_id, @moves = @moves out

select test.assert_equals('Should be available moves for E2: E3 and E4'
	, '[{"col": 4, "row": 2}, {"col": 4, "row": 3}]'
	, @moves
	)

exec e4

select test.assert_equals('State should be Black to move when piece is moved'
 , 'Black to move'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )

exec B8 'c5'

select test.assert_equals('The state should remain the same if an illegal move has been made'
 , 'Black to move'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )


exec F7 'F5'

select test.assert_equals('State should be White to move when black is moved'
 , 'White to move'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )


exec D2 'D4'

exec G7 'g5'

select test.assert_equals('White to move before they mated'
 , 'White to move'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )


exec D1 'H5'

select test.assert_equals('State should be White wins when black is mated'
 , 'White wins'
 , (
	 select state
	 from chess.game
	 where id = @game_id)
 )

delete chess.game
where id = @game_id

exec render.enable