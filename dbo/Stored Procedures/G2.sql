create   proc [G2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G2', @to = @to