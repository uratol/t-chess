CREATE proc [engine].[calc_board_state]
  @board_id uniqueidentifier
, @result int out 
	-- 1 white to move
	-- -1 black to move
	-- 2 white wins
	-- -2 black wins
	-- 0 stalemate
as

set @result = engine_json.calc_board_state(@board_id)