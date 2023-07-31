create   proc [H1]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H1', @to = @to