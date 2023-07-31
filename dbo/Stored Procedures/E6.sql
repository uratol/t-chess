create   proc [E6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E6', @to = @to