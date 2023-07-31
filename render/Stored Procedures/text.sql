CREATE proc [render].[text]
  @text nvarchar(max)
, @is_error bit = null
, @p1 sql_variant = N'[unassigned]'
, @p2 sql_variant = N'[unassigned]'
, @p3 sql_variant = N'[unassigned]'
, @p4 sql_variant = N'[unassigned]'
as

set @text = tools.format_message(@text, @p1, @p2, @p3, @p4)

if @is_error = 1
	set @text = render.sprite(@text, '101m')

print @text