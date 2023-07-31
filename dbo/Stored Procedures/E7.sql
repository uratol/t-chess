create   proc [E7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E7', @to = @to