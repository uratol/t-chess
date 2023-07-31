create proc chess.update_game_state 
  @game_id uniqueidentifier
as

update chess.game
	set state = chess.calc_game_state(chess.board_to_json(board_id))
where id = @game_id