create proc [engine_native].[is_king_under_check]
  @board_id uniqueidentifier
, @is_king_white bit
, @result bit out
with schemabinding, native_compilation
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare 
	  @king_col tinyint
	, @king_row tinyint
	, @opponent_piece_id uniqueidentifier
	, @opponent_col tinyint
	, @opponent_row tinyint
	, @opponent_is_white bit = ~@is_king_white

	select 
		  @king_col = p.col
		, @king_row = p.row
	from [engine_native].piece as p
	where p.board_id = @board_id
		and p.fen_symbol = 'k'
		and p.is_white = @is_king_white

	declare @processed_squares [engine_native].coordinates

	set @result = 0

	while 1 = 1 begin

		set @opponent_piece_id = null

		select top(1) @opponent_piece_id = id
			, @opponent_col = p.col
			, @opponent_row = p.row
		from [engine_native].piece as p
		where p.board_id = @board_id
			and p.is_white = @opponent_is_white
			and p.is_captured = 0
			and not exists(
				select 1
				from @processed_squares as pr
				where pr.col = p.col
					and pr.row = p.row
				)

		if @opponent_piece_id is null
			return

		exec [engine_native].[calc_legal_moves_except_king]
			  @piece_id = @opponent_piece_id
			, @attack_only = 1
			, @check_col = @king_col
			, @check_row = @king_row
			, @check_result = @result out

		if @result = 1
			return

		insert @processed_squares(col, row)
			values(@opponent_col, @opponent_row)

	end

	return
end