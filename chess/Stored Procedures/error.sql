CREATE proc [chess].[error]
  @message nvarchar(max)
, @col int = null
, @row int = null
as

set @message = replace(@message
	, '%square'
	, chess.coordinates_to_square(@col, @row))

exec dbo.error @message = @message