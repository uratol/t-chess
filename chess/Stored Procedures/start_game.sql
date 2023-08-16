CREATE proc [chess].[start_game]
  @game_id uniqueidentifier = null out
, @white_player varchar(20) = 'Player'
, @black_player varchar(20) = 'AI'
, @starting_position_fen nvarchar(54) = null 
as

set xact_abort on

set @game_id = newid()

set @starting_position_fen = isnull(@starting_position_fen, [chess].[fen_starting_position]())

begin tran

	declare @board_id uniqueidentifier
		, @color_to_move varchar(5)

	exec [chess].[board_from_fen] @board_id = @board_id out
								, @fen = @starting_position_fen
								, @color_to_move = @color_to_move out

	insert chess.game(id, state, board_id, white_player, black_player)
		select @game_id, @color_to_move + ' to move', @board_id, @white_player, @black_player

	if @white_player = 'AI' and @color_to_move = 'White'
			or @black_player = 'AI' and @color_to_move = 'Black'
		exec chess.make_move_ai @game_id = @game_id
commit