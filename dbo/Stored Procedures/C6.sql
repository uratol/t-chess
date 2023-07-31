create   proc [C6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C6', @to = @to