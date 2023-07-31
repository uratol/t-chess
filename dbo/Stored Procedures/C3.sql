create   proc [C3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C3', @to = @to