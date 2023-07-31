create function chess.parse_fen_squares(
  @squares nvarchar(max)
)
returns @result table
(  colored_piece_id varchar(12) not null
, [col] tinyint not null
, [row] tinyint not null
)
as
begin

	declare @fen_rows table(row_no tinyint 
			check(row_no < 8)
		, fen_str varchar(15) not null
			check (fen_str not like '%[^1-8rnbqkp]%')
		)

	insert @fen_rows(fen_str, row_no)
	select ss.value
		 , 8 - ss.ordinal
	from string_split(@squares, '/', 1) as ss;

	with symbols as (
		select r.row_no
			, cp.id as colored_piece_id
			, sum(
					isnull(try_cast(c.value as tinyint), 1)
				) over(partition by r.row_no order by c.ordinal) - 1
					as col
		from @fen_rows as r
			cross apply tools.split_string_by_char(r.fen_str) as c
			left join chess.colored_piece as cp on cp.fen_symbol collate Latin1_General_BIN = c.value collate Latin1_General_BIN
		)
	insert @result(colored_piece_id, [col], [row])
		select colored_piece_id
			 , col
			 , row_no
		from symbols
		where colored_piece_id is not null
	return
end