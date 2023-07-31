create   proc [F6]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F6', @to = @to