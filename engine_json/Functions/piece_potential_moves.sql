CREATE function [engine_json].[piece_potential_moves]
( @colored_piece varchar(50)
, @col int
, @row int
, @attack_only bit 
)
returns @result table(
  col tinyint
, row tinyint
primary key (col, row)
)
as
begin

	declare @piece varchar(10)
		, @color varchar(10)
	
	select @piece = max(case when ordinal = 2 then value end)
		, @color = max(case when ordinal = 1 then value end)
	from string_split(@colored_piece, ' ', 1)

	if @piece = 'Pawn' begin
		declare @direction int = iif(@color = 'White', 1, -1)

		insert @result(col, row)
			select *
			from (
				-- pawn move
				select @col, @row + @direction
				where @attack_only = 0
				union all
				select @col, @row + @direction * 2
				where @attack_only = 0
					and (@direction = 1 and @row = 1
						or @direction = -1 and @row = 6)
				union all
				-- pawn attack
				select @col + 1, @row + @direction
				union all
				select @col - 1, @row + @direction
			) as moves(col, row)
			where moves.col between 0 and 7
				and moves.row between 0 and 7
	end
	else
	if @piece = 'Knight'
		insert @result(col, row)
		select *
		from (
			values
			  (@col + 1, @row + 2)
			, (@col + 2, @row + 1)
			, (@col - 1, @row + 2)
			, (@col + 2, @row - 1)

			, (@col - 1, @row - 2)
			, (@col - 2, @row - 1)
			, (@col + 1, @row - 2)
			, (@col - 2, @row + 1)
			) as v(col, row)
		where v.col between 0 and 7
			and v.row between 0 and 7
	else
	if @piece in ('Bishop', 'Queen', 'Rook', 'King')
		insert @result(col, row)
		select moves.col, moves.row
		from tools.number as n
			cross apply (values
					  (1, 1)
					, (1, -1)
					, (-1, 1)
					, (-1, -1)
					, (1, 0)
					, (-1, 0)
					, (0, 1)
					, (0, -1)
					) as direction(x, y)
			cross apply (values(@col + n.n * direction.x, @row + n.n * direction.y)) as moves(col, row)
		where n.n between 1 and iif(@piece = 'King', 1, 7)
			and moves.col between 0 and 7
			and moves.row between 0 and 7
			and (@piece <> 'Rook' or direction.x * direction.y = 0)
			and (@piece <> 'Bishop' or direction.x * direction.y <> 0)

	return
end