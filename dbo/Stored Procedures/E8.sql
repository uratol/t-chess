create   proc [E8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'E8', @to = @to