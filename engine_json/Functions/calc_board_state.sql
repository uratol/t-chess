CREATE function [engine_json].[calc_board_state](@board nvarchar(max))
returns int
	-- 1 white to move
	-- -1 black to move
	-- 2 white wins
	-- -2 black wins
	-- 0 stalemate
as
begin

	if try_cast(@board as uniqueidentifier) is not null
		set @board = [engine_json].[board_to_json](cast(@board as uniqueidentifier))

	declare 
	  @color_to_move varchar(5) = json_value(@board, '$.color_to_move')
	, @has_move bit = 0
	, @is_king_under_check bit = 0


	if exists (
				select *
				from [engine_json].parse_pieces(@board) as p
					join chess.colored_piece as cp
						on cp.id = p.colored_piece_id
					cross apply [engine_json].piece_legal_moves(@board
					, p.id
					, 0 -- attack only
					, 1 -- check king
			) as m
	where cp.color_id = @color_to_move)
	
	set @has_move = 1

	if @has_move = 0
		set @is_king_under_check = [engine_json].is_king_under_check(@board, @color_to_move)
	
	declare @color_sign int = iif(@color_to_move = 'White', 1, -1)

	return case 
					when @has_move = 1
						then @color_sign
					when @is_king_under_check = 1
						then -@color_sign * 2
					else 0
				end
					

end