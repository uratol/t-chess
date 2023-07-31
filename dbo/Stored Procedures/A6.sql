create   proc [A6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A6', @to = @to