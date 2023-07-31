create function chess.parse_fen(
  @fen nvarchar(max)
)
returns @result table(
  squares varchar(1024) not null
, color_to_move varchar(5) null
)
as
begin


declare @squares varchar(max)
, @color_to_move varchar(max)

select @squares= max(case
							when ordinal = 1 then value
						end)
	 , @color_to_move = max(case
							 when ordinal = 2 and value = 'w' 
								then 'White'
							 when ordinal = 2 and value = 'b' 
								then 'Black'
							end
							)
from string_split(@fen, ' ', 1) as ss

insert @result(squares , color_to_move)
	select @squares, @color_to_move

return


end