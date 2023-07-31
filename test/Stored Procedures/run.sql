CREATE proc [test].[run]
as

set xact_abort on

set nocount on

declare @full_proc_name nvarchar(max)

declare c cursor local for
	select test_proc_full_name
	from test.test

open c
while 1 = 1 begin
	fetch c into @full_proc_name

	if @@FETCH_STATUS <> 0 break
	
	print '################################################################################################
Running ' + @full_proc_name
	exec @full_proc_name
end