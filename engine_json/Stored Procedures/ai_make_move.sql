CREATE proc [engine_json].[ai_make_move]
  @board nvarchar(max) = null
, @board_id uniqueidentifier = null
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint = null out
, @row_to tinyint = null out
, @estimation real = null out
as
begin

	if @board is null
		set @board = engine_json.board_to_json(@board_id)

	declare @color_to_move varchar(5) = json_value(@board, '$.color_to_move')

	select 
		  @col_from = null
		, @row_from = null
		, @col_to = null
		, @row_to = null

	-- TODO:  Implement min-max
	-- Do random move for now
	select top(1)
		  @col_from = p.col
		, @row_from = p.row
		, @col_to = lm.col
		, @row_to = lm.row
		, @estimation = 1
	from engine_json.parse_pieces(@board) as p
		join chess.colored_piece as cp on p.colored_piece_id = cp.id
		cross apply engine_json.piece_legal_moves(@board, p.id, 0, 1) as lm
	where cp.color_id = @color_to_move
	order by newid()

	return
end