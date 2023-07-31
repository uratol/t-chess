create   proc [F2]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F2', @to = @to