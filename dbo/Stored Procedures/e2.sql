create   proc [e2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E2', @to = @to