CREATE proc [dbo].[error]
  @message nvarchar(max)
, @http_code int = null
, @proc_id int = null
, @p1 sql_variant = N'[unassigned]'
, @p2 sql_variant = N'[unassigned]'
, @p3 sql_variant = N'[unassigned]'
, @p4 sql_variant = N'[unassigned]'
, @p1_str nvarchar(max) = N'[unassigned]' -- the same as @p1, cause varchar/nvarchar(max) can't be passed through sql_variant
, @p2_str nvarchar(max) = N'[unassigned]'
, @p3_str nvarchar(max) = N'[unassigned]'
, @p4_str nvarchar(max) = N'[unassigned]'
as

	declare @unassigned nvarchar(50) = N'[unassigned]'

	select @p1 = iif(@p1 = @unassigned, cast(@p1_str as nvarchar(4000)), @p1)
		 , @p2 = iif(@p2 = @unassigned, cast(@p2_str as nvarchar(4000)), @p2)
		 , @p3 = iif(@p3 = @unassigned, cast(@p3_str as nvarchar(4000)), @p3)
		 , @p4 = iif(@p4 = @unassigned, cast(@p4_str as nvarchar(4000)), @p4)

	select @message = tools.format_message(@message, @p1, @p2, @p3, @p4)

	declare @err_num int = 70000 + isnull(@http_code, 0);

	if @proc_id is not null
	begin
		set @message += concat('
<Procedure:> ', isnull(
		quotename(
		object_schema_name(@proc_id)
		)
		+ '.'
		+ quotename(
		object_name(@proc_id)
		)
		, @proc_id)
		);
	end

	set @message = replace(@message, '%', '%%');
	throw @err_num, @message, 1;