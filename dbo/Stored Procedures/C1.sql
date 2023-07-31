create   proc [C1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C1', @to = @to