create   proc [B1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B1', @to = @to