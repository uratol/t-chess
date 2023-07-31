create function chess.color_opposite
(@color varchar(5)
)
returns varchar(5)
as
begin
	return
		case @color
			when 'White' then 'Black'
			when 'Black' then 'White'
		end
end