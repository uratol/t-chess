create   proc [C8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C8', @to = @to