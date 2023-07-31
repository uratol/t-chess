create   proc [B5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B5', @to = @to