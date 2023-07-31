CREATE function [chess].[is_king_under_check](
  @board_json nvarchar(max)
, @king_color varchar(10)
)
returns bit
as
begin

declare @king_id uniqueidentifier
, @king_col tinyint
, @king_row tinyint

select @king_id = bp.id
	, @king_col = bp.col
	, @king_row = bp.row
from chess.parse_pieces(@board_json) as bp
	join chess.colored_piece as cp on cp.id = bp.colored_piece_id
where cp.piece_id = 'King'
	and cp.color_id = @king_color

if exists(
	select *
	from chess.parse_pieces(@board_json) as bp
		join chess.colored_piece as cp on cp.id = bp.colored_piece_id
		cross apply chess.piece_legal_moves(@board_json, bp.id
				, 1 -- @attack_only
				, 0 -- @check_king
				) as a
	where cp.color_id <> @king_color
		and a.col = @king_col
		and a.row = @king_row
	)
	return 1


	return 0
end