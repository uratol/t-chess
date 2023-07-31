create   proc [A1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A1', @to = @to