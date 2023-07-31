create   proc [E5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E5', @to = @to