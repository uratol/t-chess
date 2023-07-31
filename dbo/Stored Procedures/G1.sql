create   proc [G1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'G1', @to = @to