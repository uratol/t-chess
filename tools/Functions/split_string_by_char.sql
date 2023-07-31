create function tools.split_string_by_char(@str nvarchar(max))
returns table
as
return
with s as (
	select substring(@str, 1, 1) as value
		, 1 as ordinal
	where len(@str) > 0
	union all
	select substring(@str, ordinal + 1, 1)
		, ordinal + 1
	from s
	where len(@str) > ordinal
)
select value, ordinal
from s