CREATE proc [engine].[ai_make_move]
  @board_id uniqueidentifier
, @col_from tinyint out
, @row_from tinyint out
, @col_to tinyint out
, @row_to tinyint out
, @estimation real = null out
as

declare @engine_proc_name sysname = concat('engine_', chess.engine() + '.ai_make_move')

exec @engine_proc_name
		  @board_id = @board_id
		, @col_from = @col_from out
		, @row_from = @row_from out
		, @col_to = @col_to out
		, @row_to = @row_to out
		, @estimation = @estimation out