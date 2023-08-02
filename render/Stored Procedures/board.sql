CREATE proc [render].[board]
  @board_id uniqueidentifier
, @render_labels bit = 1
, @flip bit = 0
as

declare @render_str nvarchar(max)
, @selected_piece_id uniqueidentifier
, @legal_moves nvarchar(max)

select @selected_piece_id = selected_piece
from chess.board
where id = @board_id

if @selected_piece_id is not null
	exec engine.legal_moves @piece_id = @selected_piece_id, @moves = @legal_moves out

select @render_str = string_agg(rendered_row, '
') within group (order by iif(@flip = 1, -row, row) desc)
from (
	select r.n								 as row
		 , concat(
			  ' '
			, case when @render_labels = 1 then r.n + 1 end
			, ' '
			, string_agg(
			   [render].[square](
					 p.render_symbol
				   , [square].is_dark
				   , iif(cp.color_id = 'White', 1, 0)
				   , case 
						when bp.id = @selected_piece_id
							then 1
						when m.col is not null
							then 2
						when c.n = last_move.from_col and r.n = last_move.from_row
							then 3
						when c.n = last_move.to_col and r.n = last_move.to_row
							then 4
						else 0 end
				   )
			   , '') within group (order by iif(@flip = 1, -c.n, c.n)) 
		   )
		   as rendered_row
	from tools.number as r
		join tools.number as c
			on c.n < 8
		left join chess.board_piece as bp
			on bp.board_id = @board_id
				and bp.row = r.n
				and bp.col = c.n
		left join chess.colored_piece as cp
			on cp.id = bp.colored_piece_id
		left join chess.piece as p
			on p.id = cp.piece_id
		left join openjson(@legal_moves) with(
				  col tinyint
				, row tinyint
			) as m on m.col = c.n and m.row = r.n
		outer apply (
			select top(1) 
					  l.from_col
					, l.from_row
					, l.to_col
					, l.to_row
			from chess.[move] as l
			where l.board_id = @board_id
			order by l.half_move desc
		) as last_move
		outer apply (values(
					iif((r.n + c.n) % 2 = 0, 1, 0))
					) as [square](is_dark)
	where r.n < 8
	group by r.n) as t

if @render_labels = 1
	declare @labels nvarchar(64) = 'a  b  c  d  e  f  g  h'
	if @flip = 1 set @labels = reverse(@labels)
	
	set @render_str += '
    ' + @labels

print @render_str