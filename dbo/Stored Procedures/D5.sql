create   proc [D5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D5', @to = @to