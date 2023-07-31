create   proc [D7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D7', @to = @to