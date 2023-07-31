create   proc [G6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G6', @to = @to