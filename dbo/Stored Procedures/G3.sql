create   proc [G3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G3', @to = @to