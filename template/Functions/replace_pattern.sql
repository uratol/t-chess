CREATE function [template].[replace_pattern](
  @sql nvarchar(max)
, @pattern nvarchar(max)
, @replacement nvarchar(max)
)
returns nvarchar(max)
as
begin 
	
	declare @pattern_start int
	, @pattern_end int
	, @pattern_length int
	, @index int = 1
	, @replace_to nvarchar(max)

	if @sql is null
		return null

	if @pattern is null
		exec dbo.error @message = 'Pattern cannot be null'

	while 1 = 1 begin

		set @pattern_start = charindex('/**' + @pattern, @sql, @index)
		
		if @pattern_start = 0 break

		set @pattern_end = charindex('*/', @sql, @pattern_start) + len('*/') + 1

		if @pattern_end = 0
			exec dbo.error @message = 'Invalid pattern: no closing mark "*/"'

		set @pattern_length = @pattern_end - @pattern_start - 1

		if @replacement = '{origin}'
			set @replace_to = substring(@sql, @pattern_start + len('/**' + @pattern), @pattern_length - len('/**' + @pattern) - 2)
		else
			set @replace_to = @replacement

		set @sql = stuff(@sql, @pattern_start, @pattern_length, @replace_to)

		set @index = @pattern_end + 1 - (@pattern_length - len(@replace_to))
	end
	
	return @sql
end