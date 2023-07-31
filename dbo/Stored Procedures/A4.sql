create   proc [A4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A4', @to = @to