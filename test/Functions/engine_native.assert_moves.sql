CREATE function [test].[engine_native.assert_moves]
( @message nvarchar(max)
, @board_id uniqueidentifier
, @square_from varchar(2)
, @expected_moves_or_move_count nvarchar(max)
)
returns nvarchar(max)
as
begin
	
	if try_cast(@expected_moves_or_move_count as int) is not null
			return test.assert_equals(@message
				, cast(@expected_moves_or_move_count as int)
				, (
					select count(*)
					from [engine_native].[legal_move] as m with (repeatableread)
						join [engine_native].piece as p with (repeatableread) on p.id = m.piece_id
						cross apply chess.square_to_coordinates(@square_from) as c
					where p.board_id = @board_id
						and p.col = c.col
						and p.row = c.row
					)
			)
	else
	return test.assert_equals(@message
		, (
			select trim(value) as move
			from string_split(@expected_moves_or_move_count, ',')
			for json path
			)
		, (
			select chess.coordinates_to_square(m.col, m.row) as move
			from [engine_native].[legal_move] as m with (repeatableread)
				join [engine_native].piece as p with (repeatableread) on p.id = m.piece_id
				cross apply chess.square_to_coordinates(@square_from) as c
			where p.board_id = @board_id
				and p.col = c.col
				and p.row = c.row
			for json path
		)
	)
	return null
end