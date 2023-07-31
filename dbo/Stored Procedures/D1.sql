create   proc [D1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D1', @to = @to