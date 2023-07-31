create   proc [E1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E1', @to = @to