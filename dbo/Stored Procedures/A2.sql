create   proc [A2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A2', @to = @to