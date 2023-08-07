CREATE proc [engine_stockfish].[ai_make_move@write_file]
  @file nvarchar(max)
, @file_name nvarchar(max)
as

declare @line nvarchar(4000)
, @ordinal int
, @cmd nvarchar(4000)

create table #output (output_text nvarchar(4000));

declare lines cursor local for
	select value, ordinal
	from string_split(@file, NCHAR(13), 1)
	order by ordinal

open lines
while 1 = 1 begin
	fetch lines into @line, @ordinal
	if @@fetch_status <> 0 break

	set @cmd = concat('@echo'
		, isnull(' ' + nullif(replace(@line, NCHAR(10), ''), ''), '.')
		, ' '
		, iif(@ordinal = 1, '>', '>>' )
		, ' "', @file_name, '"') 

	insert into #output
	exec sys.xp_cmdshell @cmd

end