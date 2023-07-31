create   proc [H4]
@to nvarchar(50) = null
as

exec chess.make_move @from = 'H4', @to = @to