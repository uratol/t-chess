CREATE function [private].[test.json_hash]
(@json nvarchar(max))
returns varbinary(max)
as
begin
	declare @result varbinary(max) = 0x
	, @isarray bit = iif(left(ltrim(replace(replace(replace(@json, nchar(10), ''), nchar(13), ''), nchar(9), '')), 1) = '[', 1, 0)

	declare @buffer table(i int identity primary key
		, data varbinary(max) not null)

insert @buffer(data)
select iif(@isarray = 0, cast([key] as varbinary(max)), 0x)
 + 0x00
 + cast(const.val as varbinary(max))
 + 0x00
 + cast(type as varbinary(max))
 + 0x00
from openjson(@json) oj
	cross apply (
		select case
				   when oj.type = 1
					   and
					   try_cast(oj.value as datetime) is not null then cast(cast(oj.value as datetime) as varbinary(max))
				   when oj.type = 2 then cast(isnull(format(try_cast(oj.value as decimal(30, 20)), 'g18'), oj.value) as varbinary(max))
				   when oj.type in (4, 5) then [private].[test.json_hash](oj.value)
				   else isnull(cast(oj.value as varbinary(max)), 0x)
		 end) as const (val)
order by case
		  when @isarray = 1 then const.val
		  else oj.[key]
end

select @result += data
from @buffer as b
order by i

return @result
end