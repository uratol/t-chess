create   proc [F1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F1', @to = @to