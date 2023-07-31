create   proc [F4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F4', @to = @to