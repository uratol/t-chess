create   proc [B6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B6', @to = @to