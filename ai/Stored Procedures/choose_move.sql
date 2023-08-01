CREATE proc [ai].[choose_move]
  @board nvarchar(max)
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint = null out
, @row_to tinyint = null out
, @estimation real = null out
as
begin

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
	from chess.parse_pieces(@board) as p
		join chess.colored_piece as cp on p.colored_piece_id = cp.id
		cross apply chess.piece_legal_moves(@board, p.id, 0, 1) as lm
	where cp.color_id = @color_to_move
	order by newid()

	return
end