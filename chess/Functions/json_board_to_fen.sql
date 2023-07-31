CREATE function [chess].[json_board_to_fen]
(
    @board_json nvarchar(max)
)
returns nvarchar(4000)
as
begin
    declare @fen_board nvarchar(4000) = '';
    declare @row int = 7;
    declare @col int = 0;

    while @row >= 0
    begin
        declare @empty_count int = 0;

        while @col < 8
        begin
            declare @piece nvarchar(1) = null;
            select @piece = 
                case colored_piece_id
                    when 'White Pawn' then 'P'
                    when 'White Rook' then 'R'
                    when 'White Knight' then 'N'
                    when 'White Bishop' then 'B'
                    when 'White Queen' then 'Q'
                    when 'White King' then 'K'
                    when 'Black Pawn' then 'p'
                    when 'Black Rook' then 'r'
                    when 'Black Knight' then 'n'
                    when 'Black Bishop' then 'b'
                    when 'Black Queen' then 'q'
                    when 'Black King' then 'k'
                end
            from openjson(@board_json, '$.pieces')
            with (
                colored_piece_id nvarchar(50),
                col int,
                row int
            )
            where col = @col and row = @row;

            if @piece is null
            begin
                set @empty_count += 1;
            end
            else
            begin
                if @empty_count > 0
                begin
                    set @fen_board += cast(@empty_count as nvarchar(2));
                    set @empty_count = 0;
                end

                set @fen_board += @piece;
            end

            set @col += 1;
        end

        if @empty_count > 0
        begin
            set @fen_board += cast(@empty_count as nvarchar(2));
        end

        if @row > 0
        begin
            set @fen_board += '/';
        end

        set @row -= 1;
        set @col = 0;
    end

    -- determine the active color to move
    declare @color_to_move nvarchar(1) = lower(left(json_value(@board_json, '$.color_to_move'), 1));

    -- combine fen representation of the board with the active color and other fen components

	-- TODO: Implement castling and pawn taking
    declare @final_fen nvarchar(4000) =
        @fen_board + ' ' + @color_to_move + ' KQkq - 0 1'; 

    return @final_fen;
end