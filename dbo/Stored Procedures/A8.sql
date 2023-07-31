create   proc [A8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'A8', @to = @to