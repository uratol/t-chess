CREATE proc [template].[generate_object]
  @template_object_name nvarchar(256)
, @object_full_name nvarchar(256)
, @is_native_compiled bit
, @max_recursion_depth int
as

declare 
  @template_object_id int
, @object_flat_name nvarchar(max)
, @brln nchar(2) = nchar(13) + nchar(10)

set @object_flat_name = parsename(@object_full_name, 2) + '.' + parsename(@object_full_name, 1)

set @template_object_id = object_id(@template_object_name)

if @template_object_id is null
	exec dbo.error @message = 'Template %1 not found', @p1_str = @template_object_name

declare @sql nvarchar(max) = object_definition(@template_object_id)

set @sql = template.replace_pattern(@sql, 'NATIVE', iif(@is_native_compiled = 1, '{origin}', '') )

set @sql = template.replace_pattern(@sql, 'INTERPRETED', iif(@is_native_compiled = 1, '', '{origin}'))


if @max_recursion_depth is null or @max_recursion_depth > 32
	exec dbo.error @message = 'Max recursion depth is 32'

declare 
  @sql_branch nvarchar(max)
, @sql_leaf nvarchar(max)

set @sql_branch = template.replace_pattern(
						template.replace_pattern(@sql, 'RECURSION_START', '')
						, 'RECURSION_FINISH', '')

set @sql_leaf = template.replace_pattern(
						template.replace_pattern(@sql, 'RECURSION_START', '/*' + @brln)
						, 'RECURSION_FINISH'
						, concat('*/;', @brln 
							, '			throw 50001, ''Maximum recursion depth (', @max_recursion_depth, ') reached'', 1'
							, @brln
							)
					)

declare @index int = 0
while @index <= 32 begin
	
	declare @suffix nvarchar(max) = iif(@index = 0, '', format(@index, '_00'))

	declare @existing_object_name nvarchar(max) = @object_flat_name + @suffix

	if object_id(@existing_object_name) is not null begin
		exec('drop proc ' + @existing_object_name)
		print 'Object dropped: ' + @existing_object_name
	end

	set @index += 1
end

declare @autogenerate_warning nvarchar(max) = '-- WARNING!. This object is auto-generated from template '+ @template_object_name + '.'
	+ @brln + '-- Do not modify it manually, use [template].[generate_object] instead'

declare @depth int = @max_recursion_depth
while @depth >= 0  begin
	
	set @sql = iif(@depth = @max_recursion_depth and @is_native_compiled = 1, @sql_leaf, @sql_branch)

	declare @current_depth_suffix nvarchar(max) = iif(@depth = 0 or @is_native_compiled = 0
															, ''
															, format(@depth, '_00'))
		, @next_depth_suffix nvarchar(max) = iif(@is_native_compiled = 1
												, format(@depth + 1, '_00')
												, '')

	set @sql = template.replace_pattern(@sql, 'RECURSION_DEPTH', @next_depth_suffix)

	declare @object_name nvarchar(max) = @object_flat_name + @current_depth_suffix

	set @sql = tools.string_replace_first(@sql, @template_object_name, @object_name)


	set @sql = @autogenerate_warning + @brln
				+ @sql

	exec(@sql)

	print 'Object created: '+ @object_name

	set @depth -= 1

	if @is_native_compiled = 0 
		break
end