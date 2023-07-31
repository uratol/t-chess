create   proc [G5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G5', @to = @to