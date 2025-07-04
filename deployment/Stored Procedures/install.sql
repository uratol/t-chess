﻿CREATE proc [deployment].[install]
as

set xact_abort on

if not exists(select * from engine_native.number)
	insert engine_native.number(n)
		select value
		from generate_series(0, 7)

if not exists(select * from engine.instance)
	insert engine.instance(id, use_for_rules, use_for_ai, default_for_rules, default_for_ai)
		select *
		from (values
				  ('native', 1, 1, 1, 1)
				, ('json', 1, 1, 0, 0)
			) as v(id, use_for_rules, use_for_ai, default_for_rules, default_for_ai)

if exists(select * from chess.colored_piece) begin
	print 'Chess lookup tables already populated, exiting'
	return
end

begin tran
	insert chess.color(id)
	 values ('Black')
		  , ('White')

	insert [chess].[piece](id
						 , render_symbol)
	 values ('Bishop', nchar(9821))
		  , ('King', nchar(9818))
		  , ('Knight', nchar(9822))
		  , ('Pawn', nchar(9817)) -- 9823 is displayed incorrect in Power Shell
		  , ('Queen', nchar(9819))
		  , ('Rook', nchar(9820))

	
	insert chess.colored_piece(id, piece_id, color_id, render_symbol, fen_symbol)
	values 
		  ('Black Bishop','Bishop','Black', nchar(9821), 'b')
		, ('Black King','King','Black', nchar(9818), 'k')
		, ('Black Knight','Knight','Black', nchar(9822), 'n')
		, ('Black Pawn','Pawn','Black', nchar(9823), 'p')
		, ('Black Queen','Queen','Black', nchar(9819), 'q')
		, ('Black Rook','Rook','Black', nchar(9820), 'r')
		, ('White Bishop','Bishop','White', nchar(9815), 'B')
		, ('White King','King','White', nchar(9812), 'K')
		, ('White Knight','Knight','White', nchar(9816), 'N')
		, ('White Pawn','Pawn','White', nchar(9817), 'P')
		, ('White Queen','Queen','White', nchar(9813), 'Q')
		, ('White Rook','Rook','White', nchar(9814), 'R')

commit