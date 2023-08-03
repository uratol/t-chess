create proc [engine_native].[estimate]
  @board_id uniqueidentifier
, @estimation real out
with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	declare @result real

	select @result = sum([weight] * iif(is_white = 1, 1, -1))
	from engine_native.piece
	where board_id = @board_id
		and is_captured = 0

	return @result

end