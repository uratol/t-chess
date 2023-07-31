CREATE proc [chess].[board_from_fen]
  @board_id uniqueidentifier out
, @fen nvarchar(4000)
, @color_to_move varchar(5) = null out
as

declare @fen_squares nvarchar(max) 

select @fen_squares = squares
	, @color_to_move = color_to_move
from chess.parse_fen(@fen)

begin tran

	update chess.board set selected_piece = null
		, @color_to_move = color_to_move = isnull(@color_to_move, color_to_move)
	where id = @board_id

	delete chess.move
	where board_id = @board_id

	if @board_id is null begin
	
		set @board_id = newid()

		set @color_to_move = isnull(@color_to_move, 'White')

		insert chess.board(id, color_to_move)
			select @board_id, @color_to_move

	end
	else
		delete chess.board_piece
		where board_id = @board_id

	insert chess.board_piece(board_id, colored_piece_id, [col], [row])
		select @board_id
			 , colored_piece_id
			 , [col]
			 , [row]
		from chess.parse_fen_squares(@fen_squares)

commit