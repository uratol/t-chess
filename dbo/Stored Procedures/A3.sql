create   proc [A3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A3', @to = @to