create function chess.fen_starting_position()
returns nvarchar(max)
as
begin
	return 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
end