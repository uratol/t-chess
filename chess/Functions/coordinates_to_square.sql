create function chess.coordinates_to_square(
  @col int
, @row int
)
returns nvarchar(2)
as
begin
return concat(nchar(@col + 65), @row + 1)
end