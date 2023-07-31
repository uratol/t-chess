create   proc [D4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D4', @to = @to