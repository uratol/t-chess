CREATE proc [test].[chess.start_game]
as
begin tran

	declare @game_id uniqueidentifier

	-- ###################################################
	exec chess.start_game @game_id = @game_id out

	select test.assert_not_null('Game id should be assigned', @game_id)

	declare @game_state varchar(max)
	, @board_id uniqueidentifier

	select @game_state = state
		, @board_id = board_id
	from chess.game 
	where id = @game_id

	select test.assert_equals('Game state should be "White to move"'
		, 'White to move'
		, @game_state
		)


	select test.assert_not_null('Game should have a board', @board_id)

	select test.assert_equals('Board should have 16 black and 16 white pieces'
		, (select *
			from (values('White', 16), ('Black', 16)) as c(color, cnt)
			for json path
			)
		, (
			select cp.color_id as color
				, count(*) as cnt
			from chess.board_piece as bp
				join chess.colored_piece as cp on cp.id = bp.colored_piece_id
			where bp.board_id = @board_id
			group by cp.color_id 
			for json path
		)
		)

rollback