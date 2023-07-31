create   proc [B7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B7', @to = @to