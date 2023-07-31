create   proc [G7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G7', @to = @to