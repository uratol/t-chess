create   proc [D6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D6', @to = @to