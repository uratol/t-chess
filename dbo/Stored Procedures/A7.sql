create   proc [A7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A7', @to = @to