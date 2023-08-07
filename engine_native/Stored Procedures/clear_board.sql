CREATE proc [engine_native].[clear_board]
  @board_id uniqueidentifier
with schemabinding, native_compilation
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @pieces nvarchar(max)

	select @pieces = string_agg('"' + cast(p.id as varchar(64)) + '":1', ',')
	from [engine_native].[piece] as p
	where p.board_id = @board_id

	if @pieces is not null 
	begin

		-- Workaround for: Using the FROM clause in an UPDATE statement and specifying a table source in a DELETE statement is not supported with natively compiled modules.
		delete [engine_native].[legal_move]
		where json_value('{' + @pieces + '}', '$."' + cast(piece_id as varchar(64)) + '"') is not null

		delete [engine_native].[move]
		where json_value('{' + @pieces + '}', '$."' + cast(piece_id as varchar(64)) + '"') is not null

		delete [engine_native].[piece]
		where board_id = @board_id

	end

	delete [engine_native].board
	where id = @board_id

end


-- select newid()