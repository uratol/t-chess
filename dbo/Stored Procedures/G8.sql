create   proc [G8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G8', @to = @to