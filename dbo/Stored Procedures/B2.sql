create   proc [B2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B2', @to = @to