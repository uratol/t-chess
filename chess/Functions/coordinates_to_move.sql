create function [chess].[coordinates_to_move](
  @col_from int
, @row_from int
, @col_to int
, @row_to int
)
returns nvarchar(4)
as
begin
return [chess].[coordinates_to_square](@col_from, @row_from)
	+ [chess].[coordinates_to_square](@col_to, @row_to)
end