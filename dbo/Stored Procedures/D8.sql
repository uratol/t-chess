create   proc [D8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D8', @to = @to