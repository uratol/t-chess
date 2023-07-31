create   proc [C2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C2', @to = @to