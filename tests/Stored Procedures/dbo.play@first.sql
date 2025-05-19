create proc [tests].[dbo.play@first]
as

exec render.disable

begin tran

delete chess.game

exec play

select test.assert_equals('New game should be created if no games'
 , 'White to move'
 , (
	 select state
	 from chess.game)
 )

rollback

exec render.enable