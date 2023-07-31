CREATE trigger [check_test_name_convention]
on database
for create_procedure, rename
as

declare @xact_abort bit = (@@options & 16384)

declare @eventdata		 xml = eventdata()
	  , @schema_name	 nvarchar(max)
	  , @object_name	 nvarchar(max)
	  , @new_object_name nvarchar(max)
	  , @object_full_name nvarchar(max)
	  , @tested_object_full_name nvarchar(max)

if @xact_abort = 1
set xact_abort off


select @schema_name		= t.c.value('SchemaName[1]', 'NVARCHAR(MAX)')
	 , @object_name		= t.c.value('ObjectName[1]', 'NVARCHAR(MAX)')
	 , @new_object_name = t.c.value('NewObjectName[1]', 'NVARCHAR(MAX)')
from @eventdata.nodes('EVENT_INSTANCE[1]') as t (c)

set @object_name = isnull(@new_object_name, @object_name)


if @schema_name = 'test' and @object_name not like 'populate@%' begin
set @object_full_name = '[test].' + quotename(@object_name)

select @tested_object_full_name = tested_object_full_name
from test.test
where test_proc_full_name = @object_full_name

if @tested_object_full_name is null
exec error @message = 'Test [%1] is not found. Check the view [test].[test]'
		 , @p1_str = @object_name
		 , @proc_id = @@procid

declare @tested_schema_name nvarchar(max) = parsename(@tested_object_full_name, 2)

if @tested_schema_name = 'DDL trigger'
begin

if not exists (
		select *
		from sys.triggers
		where name = @tested_object_full_name
			  and parent_class = 0)
exec error @message = 'The test %1 should refer to an existing DDL trigger. The trigger [%2] is not found'
		 , @p1_str = @object_name
		 , @p2_str = @tested_object_full_name
		 , @proc_id = @@procid

end
else
if schema_id(@tested_schema_name) is null
exec error @message = 'Test name [%1] should contain the existing schema name or to be "DDL trigger". If it is not a test, please add exlusion to the view [test].[test]'
		 , @p1_str = @object_name
		 , @proc_id = @@procid
else
if object_id(@tested_object_full_name) is null
exec error @message = 'The test %1 should refer to an existing object. Please rename the test procedure by mask: [test].[{tested_object_schema}.{tested_object_name}] or  [test].[{tested_object_schema}.{tested_object_name};{action}]'
		 , @p1_str = @tested_object_full_name
		 , @proc_id = @@procid

end

if @xact_abort = 1
set xact_abort on
return