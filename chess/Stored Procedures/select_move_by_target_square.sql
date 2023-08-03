CREATE proc chess.select_move_by_target_square
  @board_id uniqueidentifier
, @col tinyint out
, @row tinyint out
, @col_to tinyint out
, @row_to tinyint out
as

declare @piece_id uniqueidentifier
, @piece_moves nvarchar(max)
, @start_piece_id uniqueidentifier

declare our_pieces cursor local fast_forward for
	select bp.id
	from chess.board as b
		join chess.board_piece as bp on bp.board_id = b.id
		join chess.colored_piece as cp on cp.id = bp.colored_piece_id
	where b.id = @board_id
		  and bp.is_captured = 0
		  and cp.color_id = b.color_to_move

open our_pieces
while 1 = 1 begin
	fetch our_pieces into @piece_id
	if @@fetch_status <> 0 break

	exec engine.legal_moves @piece_id = @piece_id, @moves = @piece_moves out

	if exists(
		select *
		from openjson(@piece_moves) with (
			  col tinyint
			, row tinyint
			) as m
		where m.col = @col
			and m.row = @row
		)
	begin
		if @start_piece_id is null 
			set @start_piece_id = @piece_id
		else
			return -- only one piece can move to passed square
	end

end

if @start_piece_id is not null
	select @col_to = @col
			, @row_to = @row
			, @col	   = col
			, @row	   = row
	from chess.board_piece
	where id = @start_piece_id