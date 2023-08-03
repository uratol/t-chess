CREATE proc [engine_native].[ai_make_move]
  @board_id uniqueidentifier
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint out
, @row_to tinyint out
, @estimation real = null out
as
begin

	declare @piece_id uniqueidentifier
	, @white_to_move bit
	
	exec engine_native.board_to_native @board_id = @board_id

	select @white_to_move = white_to_move
	from engine_native.board with(repeatableread)
	where id = @board_id

	
	declare pieces cursor local for
		select id
		from engine_native.piece with(repeatableread)
		where board_id = @board_id
			and is_white = @white_to_move

	open pieces
	while 1 = 1 begin
		fetch pieces into @piece_id
		if @@fetch_status <> 0 break

		exec engine_native.calc_legal_moves @piece_id = @piece_id
	end

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
		, @col_to = m.col
		, @row_to = m.row
		, @estimation = 1
	from engine_native.legal_move as m with(repeatableread)
		join engine_native.piece as p with(repeatableread) on p.id = m.piece_id
	where p.is_white = @white_to_move
		and p.board_id = @board_id
	order by newid()

	return
end