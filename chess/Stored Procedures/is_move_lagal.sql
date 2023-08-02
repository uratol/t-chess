CREATE proc [chess].[is_move_lagal]
  @piece_id uniqueidentifier
, @col tinyint
, @row tinyint
, @result bit out
as

declare @moves nvarchar(max)

exec [engine].[legal_moves] @piece_id = @piece_id, @moves = @moves out

if exists(
	select *
	from openjson(@moves) with (
		  col tinyint
		, row tinyint
		)
	where col = @col
		and row = @row
	)
	set @result = 1
else
	set @result = 0