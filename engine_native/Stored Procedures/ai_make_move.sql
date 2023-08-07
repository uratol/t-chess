CREATE proc [engine_native].[ai_make_move]
  @board_id uniqueidentifier
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint out
, @row_to tinyint out
, @estimation real = null out
, @depth tinyint = 3
as
begin

	declare @piece_id uniqueidentifier
	, @white_to_move bit
	
	exec [engine_native].[board_to_native] @board_id = @board_id

	select @white_to_move = white_to_move
	from [engine_native].[board] with(repeatableread)
	where id = @board_id

	select @col_from = null, @row_from = null, @col_to = null, @row_to = null

	exec [engine_native].[minimax]
		  @board_id = @board_id
		, @depth = @depth
		, @white_to_move = @white_to_move
		, @col_from = @col_from out
		, @row_from = @row_from out
		, @col_to = @col_to out
		, @row_to = @row_to out
		, @estimation = @estimation out

	exec [engine_native].[clear_board] @board_id = @board_id

	return
end