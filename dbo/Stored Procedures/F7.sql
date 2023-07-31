create   proc [F7]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'F7', @to = @to