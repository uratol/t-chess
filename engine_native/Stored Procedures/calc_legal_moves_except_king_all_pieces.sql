create proc [engine_native].[calc_legal_moves_except_king_all_pieces]
  @board_id uniqueidentifier
, @white_to_move bit
with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @processed_squares [engine_native].coordinates
		, @piece_id uniqueidentifier
		, @piece_col tinyint
		, @piece_row tinyint
		, @break bit = 0 -- The statement 'BREAK' is not supported with natively compiled modules.

	while @break = 0 begin

		set @piece_id = null

		select top (1) @piece_id = id
			, @piece_col = p.col
			, @piece_row = p.row
		from [engine_native].piece as p
		where p.board_id = @board_id
			and p.is_white = @white_to_move
			and p.is_captured = 0
			and not exists(
				select 1
				from @processed_squares as pr
				where pr.col = p.col
					and pr.row = p.row
				)

		if @piece_id is null 
			set @break = 1
		else begin
			exec [engine_native].[calc_legal_moves_except_king]
				  @piece_id = @piece_id
				, @attack_only = 0
		end

		if @break = 0
			insert @processed_squares(col, row)
			values(@piece_col, @piece_row)

	end	
end