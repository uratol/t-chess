create   proc [B8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B8', @to = @to