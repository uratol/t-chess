create   proc [B4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'B4', @to = @to