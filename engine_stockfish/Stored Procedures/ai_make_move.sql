CREATE proc [engine_stockfish].[ai_make_move]
  @board_id uniqueidentifier
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint out
, @row_to tinyint out
, @estimation real = null out
, @depth tinyint = 2
as
begin

/*
The direct call to xp_cmdshell doesn't work with stockfish.exe - Stockfish gives the first silly move when a file is passed as a parameter.
Direct Python call via sp_execute_external_script didn't work for me (problems with Windows instance), so I implemented a workaround xp_cmdshell + python script.
*/


	declare @fen nvarchar(128)
	, @stockfish_path nvarchar(4000)
	, @stockfish_best_move nvarchar(4000)
	, @stockfish_evaluation nvarchar(4000)
	, @stockfish_@movetime int
	, @error_message nvarchar(4000)

	set @fen = engine_json.json_board_to_fen(engine_json.board_to_json(@board_id))

	select @stockfish_path = json_value(settings, '$.path')
		, @stockfish_@movetime = isnull(json_value(settings, '$.movetime'), 5000)
	from engine.instance
	where id = 'stockfish'

	if nullif(@stockfish_path, '') is null
		exec chess.error @message = 'Stockfish path not found'

    declare @cmd nvarchar(4000)
		, @temp_file nvarchar(4000) = '"%TEMP%\t-chess.stockfish.py"'
		, @python_script nvarchar(max)

	set @python_script  = [engine_stockfish].[ai_make_move@python_script]( @fen, @stockfish_path, 2000)

	exec [engine_stockfish].[ai_make_move@write_file]
		  @file = @python_script
		, @file_name = @temp_file

    create table #output (output_text nvarchar(4000), ordinal int identity primary key);

	insert #output
		exec sys.xp_cmdshell @temp_file;

	declare @output nvarchar(max)

	select @output = string_agg(isnull(output_text, ''), '
') within group(order by ordinal)
	from #output

	if isnull(isjson(@output), 0) = 0
		set @error_message = concat('Stockfish error:', @output)
	else begin
		set @stockfish_best_move = json_value(@output, '$.best_move')

		select @col_from = square_from.col
			, @row_from = square_from.row
			, @col_to = square_to.col
			, @row_to = square_to.row
		from chess.square_to_coordinates(left(@stockfish_best_move, 2)) as square_from
			cross apply chess.square_to_coordinates(substring(@stockfish_best_move, 3, 2)) as square_to
	end
		
	if @col_from is null or @row_from is null 
		or @col_to is null or @row_to is null
		set @error_message = concat('Stockfish error:', @output)

	if @error_message is not null
		exec chess.error @message = @error_message

	return
end