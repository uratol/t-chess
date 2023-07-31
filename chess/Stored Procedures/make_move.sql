CREATE proc [chess].[make_move]
  @from nchar(2)
, @to nvarchar(50)
, @game_id uniqueidentifier = null
as
set nocount on

if @game_id is null
	exec chess.get_or_create_game @game_id = @game_id out

declare 
  @board_id uniqueidentifier
, @col_from int
, @row_from int
, @col_to int
, @row_to int
, @selected_piece_id uniqueidentifier
, @selected_piece_col int
, @selected_piece_row int
, @selected_piece_color varchar(max)
, @piece_from_color varchar(max)
, @error_message nvarchar(max)
, @color_to_move varchar(max)
, @white_player varchar(max)
, @black_player varchar(max)
, @current_player varchar(max)
, @opponent varchar(max)

select @selected_piece_id = b.selected_piece
	, @selected_piece_col = bp.col
	, @selected_piece_row = bp.row
	, @selected_piece_color = cp.color_id
	, @board_id = g.board_id
	, @color_to_move = b.color_to_move
	, @white_player = g.white_player
	, @black_player = g.black_player
	, @current_player = iif(b.color_to_move = 'White', g.white_player, g.black_player)
	, @opponent = iif(b.color_to_move = 'White', g.black_player, g.white_player)
from chess.game as g
	join chess.board as b on b.id = g.board_id
	left join chess.board_piece as bp on bp.id = b.selected_piece
	left join chess.colored_piece as cp on cp.id = bp.colored_piece_id
where g.id = @game_id

select @col_from = col
	 , @row_from = row
from chess.square_to_coordinates(@from)

select @col_to = col
	 , @row_to = row
from chess.square_to_coordinates(@to)


select @piece_from_color = cp.color_id
from chess.board_piece as bp
	left join chess.colored_piece as cp on cp.id = bp.colored_piece_id
where bp.board_id = @board_id
	and bp.col = @col_from
	and bp.row = @row_from

begin try

	if @to is null and (@selected_piece_id is null or @selected_piece_color = @piece_from_color)
		exec chess.select_piece @game_id = @game_id, @col = @col_from, @row = @row_from, @color_to_move = @color_to_move
	else 
	begin
		if @to is null and @selected_piece_id is not null
			select @col_to = @col_from
				, @row_to = @row_from
				, @col_from = @selected_piece_col
				, @row_from = @selected_piece_row
		 
		exec chess.make_move_player @game_id = @game_id
									  , @col_from = @col_from
									  , @row_from = @row_from
									  , @col_to = @col_to
									  , @row_to = @row_to

		if @opponent = 'AI'
			and exists(
				select * from chess.game
				where id = @game_id
					and state in ('White to move', 'Black to move')
				)
			exec chess.make_move_ai @game_id = @game_id

	end

end try
begin catch
	set @error_message = error_message()

end catch

exec render.game @game_id = @game_id, @error_message = @error_message