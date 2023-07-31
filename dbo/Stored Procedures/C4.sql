create   proc [C4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C4', @to = @to