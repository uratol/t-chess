create   proc [A5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A5', @to = @to