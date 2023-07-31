create   proc [D2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'D2', @to = @to