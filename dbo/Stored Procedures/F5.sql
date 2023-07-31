create   proc [F5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F5', @to = @to