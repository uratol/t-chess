CREATE proc [engine_native].[estimate]
  @board_id uniqueidentifier
, @estimation real out
with native_compilation, schemabinding
as
begin atomic
    with (transaction isolation level = repeatable read, language = N'English')

	select @estimation = sum([weight] * iif(is_white = 1, 1, -1))
	from engine_native.piece
	where board_id = @board_id
		and is_captured = 0

end