create   proc [E3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E3', @to = @to