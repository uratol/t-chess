CREATE proc [chess].[generate_wrappers]
as

declare @cell nvarchar(max)
, @sql nvarchar(max)

declare cells cursor local for
	select cell
	from (
		select nchar(c.value + 65) as [field]
			 , r.value + 1		   as [rank]
		from generate_series(0, 7) as r
			cross join generate_series(0, 7) as c
		) as cells
		outer apply (values(concat(field, [rank]))) as v(cell)
open cells
while 1 = 1 begin
	fetch cells into @cell
	if @@fetch_status <> 0 break

	set @sql = concat('create or alter proc [', @cell, ']
@to nvarchar(50) = null
as

exec chess.make_move @from = ''', @cell, ''', @to = @to

')

	print @sql
	exec(@sql)
end