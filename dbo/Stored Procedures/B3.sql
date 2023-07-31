create   proc [B3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B3', @to = @to