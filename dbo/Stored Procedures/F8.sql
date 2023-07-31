create   proc [F8]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F8', @to = @to