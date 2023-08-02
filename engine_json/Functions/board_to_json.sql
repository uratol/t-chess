CREATE function [engine_json].[board_to_json]
(@board_id uniqueidentifier
)
returns nvarchar(max)
as
begin

	return (
	select 
		  color_to_move
		, (
			select bp.id
				, bp.colored_piece_id
				, bp.col
				, bp.row
			from chess.board_piece as bp 
			where bp.board_id = @board_id
			for json path
		) as pieces
	from chess.board
	where id = @board_id
	for json path, without_array_wrapper
	)
end