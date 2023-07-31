create   proc [C5]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C5', @to = @to