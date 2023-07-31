create   proc [C7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'C7', @to = @to