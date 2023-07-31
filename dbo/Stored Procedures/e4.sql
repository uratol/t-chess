create   proc [e4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E4', @to = @to