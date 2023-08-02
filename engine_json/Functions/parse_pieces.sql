create function [engine_json].[parse_pieces]
(@board_json nvarchar(max)
)
returns table
as
return
	select *
	from openjson(@board_json, '$.pieces') with (
			  id uniqueidentifier
			, colored_piece_id varchar(max)
			, col int
			, row int
			)