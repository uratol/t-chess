create   proc [F3]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F3', @to = @to