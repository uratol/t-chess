create function tools.string_replace_first(
 @expression nvarchar(max)
, @pattern nvarchar(max)
, @replacement nvarchar(max)
)
returns nvarchar(max)
as
begin

	return stuff(
				  @expression
				, charindex(@pattern, @expression)
				, len(@pattern)
				, @replacement)
end